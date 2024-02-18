classdef Forge
    properties
        CacheEnabled (1,1) logical = true
    end

    properties (Access=private)
        Cache (1,1) dictionary = dictionary(string.empty(), function_handle.empty())
    end

    methods
        function result = render(obj, template, context)
            arguments
                obj
                template (1,1) string
                context = struct()
            end
            if obj.CacheEnabled
                if ~isKey(obj.Cache, template)
                    obj.Cache(template) = obj.compile(template);
                end
                tmplFn = obj.Cache(template);
            else
                tmplFn = obj.compile(template);
            end
            result = string(tmplFn(context)).replace("\n", newline).replace("\quote", """");
        end
    end

    methods (Access=private)
        function ct = compile(obj, template)
            arguments
                obj
                template (1,1) string
            end
            pt = obj.parse(template);
            try
                ct = eval("@(c)"""+pt+"""");
            catch err
                if err.identifier == "MATLAB:m_incomplete_statement"
                    error("Forge:UnclosedTag", "At least one 'end' tag is missing.");
                end
                throw(err)
            end
        end

        function pt = parse(obj, template, stack)
            arguments
                obj
                template (1,1) string
                stack (1,:) string = string.empty()
            end
            % Remove \r and escape quotes
            pt = template.replace(newline, "\n").replace("\r", "").replace("""", "\quote");
            % Replace all comments
            [captureGroups, match] = regexp(pt, "(\\*){%[\s\S]*?%}", "tokens", "emptymatch", "match");
            for i=1:numel(match)
                args = [{match(i)} num2cell(captureGroups{i}) {pt}];
                pt = pt.replace(match(i), replaceComments(obj, stack, args{:}));
            end
            % Replace all tags
            [captureGroups, match, ~, ind] = regexp(pt, "(\\*){ *(([\w_.\-@:]+)|>([\w_.\-@:]+)|for *([^ }]*) *= *([^}]*)|if *([^}]*)|elseif *([^}]*)) *}", "tokens", "match", "emptymatch");
            if numel(match) > 0
                args = [{match(1)} num2cell(captureGroups{1}) {pt}];
                if match(1).startsWith(["{for ", "{"+whitespacePattern+"for "])
                    stack(end+1) = "for";
                elseif match(1).startsWith(["{if ", "{"+whitespacePattern+"if "])
                    stack(end+1) = "if";
                elseif match(1).startsWith(["{elseif ", "{"+whitespacePattern+"elseif "])
                    if isempty(stack) || stack(end) ~= "if"
                        error("Forge:UnmatchedElseifTag", "'elseif' tag found without corresponding 'if' tag '%s'.", match{1});
                    end
                elseif matches(match(1), ["{end}", "{"+whitespacePattern+"end}", "{end"+whitespacePattern+"}", "{"+whitespacePattern+"end"+whitespacePattern+"}"])
                    if isempty(stack)
                        error("Forge:UnmatchedEndTag", "'end' tag found without corresponding 'if' or 'for' tag.");
                    end
                    stack(end) = [];
                end
                left = extractBefore(pt, ind(1)+1).replace(match(1), replaceTags(obj, stack, args{:}));
                right = obj.parse(extractAfter(pt, ind(1)), stack);
                pt = left + right;
            end
        end

        function out = replaceByFunction(obj, str, pattern, replacer, stack)
            out = str;
            [captureGroups, match, offsets] = regexp(str, pattern, "tokens", "emptymatch", "match");
            for i=1:numel(match)
                args = [{match(i)} num2cell(captureGroups{i}) {offsets(i)} {str}];
                out = out.replace(match(i), replacer(obj, stack, args{:}));
            end
        end
        
        function out = replaceComments(~, ~, str, escapeChar, ~, ~)
            if strlength(escapeChar) > 0
                out = regexprep(str, "\\", "", "once");
            else
                out = "";
            end
        end
        
        function out = replaceTags(varargin)
            obj = varargin{1};
            stack = varargin{2};
            str = varargin{3};
            out = str;
            if ~isempty(regexp(str, "(\\*){ *for *([^}]*) *}", "once")) && isempty(regexp(str, "(\\*){ *for +([\w_\-@:]+) *= *([^}]+) *}", "once"))
                error("Forge:BadForTag", "Invalid 'for' syntax '%s'", str);
            end
            if ~isempty(regexp(str, "(\\*){ *if *([^}]*) *}", "once")) && isempty(regexp(str, "(\\*){ *if *([^}]+) *}", "once"))
                error("Forge:BadIfTag", "Invalid 'if' syntax '%s'", str);
            end
            if ~isempty(regexp(str, "(\\*){ *elseif *([^}]*) *}", "once")) && isempty(regexp(str, "(\\*){ *elseif ([^}]+) *}", "once"))
                error("Forge:BadElseifTag", "Invalid 'elseif' syntax '%s'", str);
            end
            out = replaceByFunction(obj, out, "(\\*){ *([\w_.\-@:]+) *}", @replaceVars, stack);
            out = replaceByFunction(obj, out, "(\\*){> *([\w_.\-@:]+) *}", @replacePartials, stack);
            out = replaceByFunction(obj, out, "(\\*){ *for +([\w_\-@:]+) *= *([^}]+) *}", @replaceFor, stack);
            out = replaceByFunction(obj, out, "(\\*){ *if *([^}]+) *}", @replaceIf, stack);
            out = replaceByFunction(obj, out, "(\\*){ *elseif ([^}]+) *}", @replaceElseif, stack);
        end
        
        function out = replaceVars(~, stack, str, escapeChar, var, ~, ~)
            out = str;
            if numel(stack) > 0
                if var == "else"
                    out = """, ""true"",""";
                end
                return
            end
            if strlength(escapeChar) > 0
                out = regexprep(str, "\\", "", "once");
            elseif strlength(var) > 0
                if var == "end"
                    out = """)+""";
                else
                    out = """+c."+var+"+""";
                end
            end
        end
        
        function out = replacePartials(~, stack, str, escapeChar, partial, ~, ~)
            out = str;
            if numel(stack) > 0
                return
            end
            if strlength(escapeChar) > 0
                out = regexprep(str, "\\", "", "once");
            elseif strlength(partial) > 0
                out = """+obj.render(c."+partial+",c)+""";
            end
        end
        
        function out = replaceIf(~, stack, str, escapeChar, ifKey, ~, ~)
            out = str;
            if numel(stack) > 1
                return
            end
            if strlength(escapeChar) > 0
                out = regexprep(str, "\\", "", "once");
            elseif strlength(ifKey) > 0
                out = """+ifReplacement(obj,c,"""+ifKey+""",""";
            end
        end

        function out = replaceElseif(~, stack, str, escapeChar, elseifKey, ~, ~)
            out = str;
            if numel(stack) > 1
                return
            end
            if strlength(escapeChar) > 0
                out = regexprep(str, "\\", "", "once");
            elseif strlength(elseifKey) > 0
                out = """, """+elseifKey+""",""";
            end
        end

        function fstr = ifReplacement(varargin)
            obj = varargin{1};
            c = varargin{2};
            if ~isempty(fieldnames(c))
                for f = string(fieldnames(c))'
                    eval(f+"=c.(f);");
                end
            end
            fstr = "";
            for ind = 3:2:numel(varargin)-1
                ifKey = varargin{ind};
                try
                    safeIfKey = eval(ifKey.replace("\quote", """"));
                    safeIfKey = logical(safeIfKey);
                catch caughtException
                    errID = "Forge:BadIfTag";
                    msg = sprintf("Unable to parse 'if' tag condition '%s'.", ifKey);
                    baseException = MException(errID,msg);
                    baseException = addCause(baseException, caughtException);
                    throw(baseException);
                end
                if safeIfKey
                    fstr=fstr + obj.render(varargin{ind+1},c);
                    return
                end
            end
        end
        
        function out = replaceFor(~, stack, str, escapeChar, iterVar, forKey, ~, ~)
            out = str;
            if numel(stack) > 1
                return
            end
            if strlength(escapeChar) > 0
                out = regexprep(str, "\\", "", "once");
            elseif strlength(forKey) > 0
                out = """+forReplacement(obj,c,"""+iterVar+""","""+forKey+""",""";
            end
        end

        function fstr = forReplacement(obj, c,iterVar, forKey, template)
            if ~isempty(fieldnames(c))
                for f = string(fieldnames(c))'
                    eval(f+"=c.(f);");
                end
            end
            fstr = "";
            try
                safeForKey = eval(forKey);
                safeForKey = safeForKey(:)';
            catch caughtException
                errID = "Forge:BadForTag";
                msg = sprintf("Unable to parse 'for' tag iterator '%s'.", forKey);
                baseException = MException(errID,msg);
                baseException = addCause(baseException, caughtException);
                throw(baseException);
            end
            for safeIterVar = safeForKey
                c.(iterVar)=safeIterVar;
                fstr = fstr + obj.render(template,c);
            end
        end
    end
end