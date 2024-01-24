classdef tIf < matlab.unittest.TestCase
    methods (TestClassSetup)
        function instantiateForge(testCase)
            import matlab.unittest.fixtures.PathFixture;
            testCase.applyFixture(PathFixture("../toolbox"));
        end
    end
    
    methods (Test)
        function testIfTrue(testCase)
            context = struct("foo", "bar");
            f = forge.Forge();
            testCase.verifyEqual(f.render("{if true}{foo}{/if}", context), "bar");
        end
        
        function testIfFalse(testCase)
            context = struct("foo", "bar");
            f = forge.Forge();
            testCase.verifyEqual(f.render("{if false}{foo}{/if}", context), "");
        end
        
        function testIfNotTrue(testCase)
            context = struct("foo", "bar");
            f = forge.Forge();
            testCase.verifyEqual(f.render("{if not true}{foo}{/if}", context), "");
        end
        
        function testIfNotFalse(testCase)
            context = struct("foo", "bar");
            f = forge.Forge();
            testCase.verifyEqual(f.render("{if not false}{foo}{/if}", context), "bar");
        end
        
        function testIfFalseElse(testCase)
            context = struct("foo", "bar");
            f = forge.Forge();
            testCase.verifyEqual(f.render("{if false}blah{else}{foo}{/if}", context), "bar");
        end
    end
end
