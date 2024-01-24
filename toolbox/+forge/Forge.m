classdef Forge
    properties
        Cache (1,1) dictionary = dictionary(string.empty(), function_handle.empty())
    end

    methods
        function result = render(obj, template, context)
            arguments
                obj
                template
                context = struct()
            end
            if ~isKey(obj.Cache, template)
                obj.Cache(template) = obj.compile(template);
            end
            tmplFn = obj.Cache(template);
            result = tmplFn(context);
        end
    end

    methods (Access=private)
        function compiledTemplate = compile(obj, template)
            if isa(template, "function_handle")
                compiledTemplate = template;
                return;
            end
            stack = forge.internal.Stack();
            template = string(template);
            template = template.replace("\r", "");
            template = replaceByFunction(template, "(\\*){![\s\S]*?!}", @replaceComments, stack);
            template = replaceByFunction(template, "(\\*){([\w_.\-@:]+)}", @replaceTags, stack);
            template = replaceByFunction(template, "(\\*){>([\w_.\-@:]+)}", @replacePartials, stack);
            template = replaceByFunction(template, "(\\*){for +([\w_\-@:]+) +in +([\w_.\-@:]+)}", @replaceFor, stack);
            template = replaceByFunction(template, "(\\*){if +(not +|)([\w_.\-@:]+)}", @replaceIf, stack);
            template = replaceByFunction(template, "(\\*){\/(for|if)}", @replaceCloseStatement, stack);
            eval("t={};t{end+1}=@(c)"""+template+""";");
            fn = @(c)"";
            for i=1:numel(t)
                fn=@(c)fn(c)+t{i}(c);
            end
            compiledTemplate = fn;
        end
    end
end

function out = replaceByFunction(str, pattern, replacer, stack)
out = str;
[captureGroups, matches, offsets] = regexp(str, pattern, "tokens", "emptymatch", "match");
for i=1:numel(matches)
    args = [{matches(i)} num2cell(captureGroups{i}) {offsets(i)} {str}];
    out = out.replace(matches(i), replacer(stack, args{:}));
end
end

function out = replaceComments(~, str, escapeChar, ~, ~)
if strlength(escapeChar) > 0
    out = regexprep(str, "\\", "", "once");
else
    out = "";
end
end

function out = replaceTags(~, str, escapeChar, tag, ~, ~)
if strlength(escapeChar) > 0
    out = regexprep(str, "\\", "", "once");
elseif strlength(tag) > 0
    out = """+c."+string(tag)+"+""";
end
end

function out = replacePartials(~, str, escapeChar, partial, ~, ~)
if strlength(escapeChar) > 0
    out = regexprep(str, "\\", "", "once");
elseif strlength(partial) > 0
    out = """+obj.render(c."+string(partial)+",c)+""";
end
end

function out = replaceFor(stack, str, escapeChar, iterVar, forKey, ~, ~)
if strlength(escapeChar) > 0
    out = regexprep(str, "\\", "", "once");
elseif strlength(forKey) > 0
    % stack.push({statement:'for', forKey:forKey, iterVar:iterVar, safeIterVar:safeIterVar});
    stack.push(struct("statement": "for", "forKey", forKey, "iterVar": iterVar))
    out = "";
end
end

function out = replaceIf(stack, str, escapeChar, ifNot, ifKey, ~, ~)
if strlength(escapeChar) > 0
    out = regexprep(str, "\\", "", "once");
elseif strlength(ifKey) > 0
    stack.push(struct("statement", "if"));
    if strlength(ifNot) > 0
        in = "~";
    else
        in = "";
    end
    out = """;if "+in+"("+ifKey+");t{end+1}=@(c)""";
end
end

function out = replaceCloseStatement(stack, str, escapeChar, closeStatement, ~, ~)
if strlength(escapeChar) > 0
    out = regexprep(str, "\\", "", "once");
elseif strlength(closeStatement) > 0
    % block = stack[stack.length-1];
    % if (block && block.statement == closeStatement) {
    %   stack.pop();
    %   return '\'}'+(block.statement == 'for' ? 'c[\''+block.iterVar+'\']=__'+block.safeIterVar+';' : '')+'b+=\'';
    % }
    % console.warn('extra {/'+closeStatement+'} ignored');
    % return '';
    if ~isempty(stack.Data) && stack.Data{end}.statement == closeStatement
        block = stack.pop();
        out = """;end;t{end+1}=@(c)""";
        return
    end
    out = "";
end
end