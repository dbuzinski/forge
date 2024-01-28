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
            result = string(tmplFn(context)).replace("""""", """");
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
            % Remove \r and escape quotes
            template = template.replace("\r", "").replace("""", """""");
            % Replace all comments
            [captureGroups, matches, offsets] = regexp(template, "(\\*){![\s\S]*?!}", "tokens", "emptymatch", "match");
            for i=1:numel(matches)
                args = [{matches(i)} num2cell(captureGroups{i}) {offsets(i)} {template}];
                template = template.replace(matches(i), replaceComments(obj, stack, args{:}));
            end
            % Replace all tags
            [captureGroups, matches, ~, ind] = regexp(template, "(\\*){(([\w_.\-@:]+)|>([\w_.\-@:]+)|for +([\w_\-@:]+) *= *([\w_.\-@:]+)|if +(~ +|)([\w_.\-@:=""]+))}", "tokens", "match", "emptymatch");
            if numel(matches) > 0
                args = [{matches(1)} num2cell(captureGroups{1}) {template}];
                first = extractBefore(template, ind(1)+1).replace(matches(1), replaceTags(obj, stack, args{:}));
                second = obj.compile(extractAfter(template, ind(1)));
                first = eval("@(c)"""+first+"""");
                compiledTemplate = @(c)first(c)+second(c);
            else
                compiledTemplate = @(c)template;
            end
        end

        function out = replaceByFunction(obj, str, pattern, replacer, stack)
            out = str;
            [captureGroups, matches, offsets] = regexp(str, pattern, "tokens", "emptymatch", "match");
            for i=1:numel(matches)
                args = [{matches(i)} num2cell(captureGroups{i}) {offsets(i)} {str}];
                out = out.replace(matches(i), replacer(obj, stack, args{:}));
            end
        end
        
        function out = replaceComments(~, ~, str, escapeChar, ~, ~)
            if strlength(escapeChar) > 0
                out = regexprep(str, "\\", "", "once");
            else
                out = "";
            end
        end
        
        function out = replaceVars(~, stack, str, escapeChar, var, ~, ~)
            if strlength(escapeChar) > 0
                out = regexprep(str, "\\", "", "once");
            elseif strlength(var) > 0
                if var == "end"
                    if ~isempty(stack.Data)
                        block = stack.pop();
                        if block.statement == "if"
                            out = """)+""";
                            return
                        elseif block.statement == "for"
                            out = """)+""";
                            return
                        end
                    end
                end
                out = """+c."+string(var)+"+""";
            end
        end
        
        function out = replacePartials(~, ~, str, escapeChar, partial, ~, ~)
            if strlength(escapeChar) > 0
                out = regexprep(str, "\\", "", "once");
            elseif strlength(partial) > 0
                out = """+obj.render(c."+string(partial)+",c)+""";
            end
        end
        
        function out = replaceIf(~, stack, str, escapeChar, ifNot, ifKey, ~, ~)
            if strlength(escapeChar) > 0
                out = regexprep(str, "\\", "", "once");
            elseif strlength(ifKey) > 0
                stack.push(struct("statement", "if"));
                if strlength(ifNot) > 0
                    neg = "~";
                else
                    neg = "";
                end
                out = """+ifReplacement(c,"""+ifKey+""","""+neg+""",""";
            end
        end
        
        function out = replaceTags(varargin)
            obj = varargin{1};
            stack = varargin{2};
            str = varargin{3};
            out = str;
            out = replaceByFunction(obj, out, "(\\*){([\w_.\-@:]+)}", @replaceVars, stack);
            out = replaceByFunction(obj, out, "(\\*){>([\w_.\-@:]+)}", @replacePartials, stack);
            out = replaceByFunction(obj, out, "(\\*){for +([\w_\-@:]+) *= *([\w_.\-@:]+)}", @replaceFor, stack);
            out = replaceByFunction(obj, out, "(\\*){if +(~ +|)([\w_.\-@:=""]+)}", @replaceIf, stack);
        end

        function out = replaceFor(obj, stack, str, escapeChar, iterVar, forKey, ~, ~)
            if strlength(escapeChar) > 0
                out = regexprep(str, "\\", "", "once");
            elseif strlength(forKey) > 0
                stack.push(struct("statement", "for", "forKey", forKey, "iterVar", iterVar))
                out = """+forReplacement(obj,c,"""+iterVar+""","""+forKey+""",""";
            end
        end
        
        function fstr = forReplacement(obj, c,iterVar, forKey, template)
            if ~isempty(fieldnames(c))
                for f = string(fieldnames(c))
                    eval(f+"=c.(f);");
                end
            end
            fstr = "";
            eval("for "+iterVar+"="+forKey+";c."+iterVar+"="+iterVar+";fstr=fstr+obj.render(template,c);end;");
        end
    end
end

function fstr = ifReplacement(c, ifKey, neg, template)
if ~isempty(fieldnames(c))
    for f = string(fieldnames(c))
        eval(f+"=c.(f);");
    end
end
fstr = "";
eval("if "+neg+"("+ifKey+");fstr=fstr+template;end;");
end
