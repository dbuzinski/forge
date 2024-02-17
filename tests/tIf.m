classdef tIf < matlab.unittest.TestCase
    methods (Test)
        function testIfTrue(testCase)
            context = struct("foo", "bar");
            f = Forge();
            testCase.verifyEqual(f.render("{if true}{foo}{end}", context), "bar");
        end
        
        function testIfFalse(testCase)
            context = struct("foo", "bar");
            f = Forge();
            testCase.verifyEqual(f.render("{if false}{foo}{end}", context), "");
        end
        
        function testIfNotTrue(testCase)
            context = struct("foo", "bar");
            f = Forge();
            testCase.verifyEqual(f.render("{if ~ true}{foo}{end}", context), "");
        end
        
        function testIfNotFalse(testCase)
            context = struct("foo", "bar");
            f = Forge();
            testCase.verifyEqual(f.render("{if ~ false}{foo}{end}", context), "bar");
        end

        function testConditionDependsOnContext(testCase)
            context = struct("foo", "bar");
            f = Forge();
            testCase.verifyEqual(f.render("{if foo==string('bar')}{foo}{end}", context), "bar");
        end
        
        % function testIfFalseElse(testCase)
        %     context = struct("foo", "bar");
        %     f = Forge();
        %     testCase.verifyEqual(f.render("{if false}blah{else}{foo}{end}", context), "bar");
        % end
    end
end
