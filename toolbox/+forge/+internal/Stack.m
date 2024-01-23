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
    end
end