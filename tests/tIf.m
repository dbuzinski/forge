classdef tIf < matlab.unittest.TestCase
    methods (Test)
        function testIfTrue(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if true}{a}{end}", context), "euclid");
        end
        
        function testIfFalse(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if false}{a}{end}", context), "");
        end
        
        function testIfNotTrue(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if ~ true}{a}{end}", context), "");
        end
        
        function testIfNotFalse(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if ~ false}{a}{end}", context), "euclid");
        end

        function testConditionDependsOnContext(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if a==""euclid""}{a}{end}", context), "euclid");
        end

        function testIfElseif(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if false}blah{elseif true}{a}{end}", context), "euclid");
        end

        function testIfMultipleElseif(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if false}blah{elseif false}blah{elseif true}{a}{end}", context), "euclid");
        end
        
        function testIfElse(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if false}blah{else}{a}{end}", context), "euclid");
        end

        function testIfElseifElse(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if false}blah{elseif false}blah{else}{a}{end}", context), "euclid");
        end
    end
end
