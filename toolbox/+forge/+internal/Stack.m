classdef Stack < handle
    properties
        Data (1,:) cell = {}
    end

    methods
        function push(stack, d)
            stack.Data{end+1} = d;
        end

        function d = pop(stack)
            if isempty(stack.Data)
                d = [];
                return
            end
            d = stack.Data{end};
            stack.Data = stack.Data(1:end-1);
        end

        function tf = isIterVar(stack, varName)
            tf = false;
            groups = varName.split(".");
            firstGroup = groups(1);
            for i=1:numel(stack.Data)
                s = stack.Data{i};
                if isfield(s, "iterVar")
                    if s.iterVar == firstGroup
                        tf = true;
                        return;
                    end
                end
            end
        end
    end
end