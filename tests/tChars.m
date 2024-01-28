classdef tChars < matlab.unittest.TestCase
    methods (TestClassSetup)
        function instantiateForge(testCase)
            import matlab.unittest.fixtures.PathFixture;
            testCase.applyFixture(PathFixture("../toolbox"));
        end
    end
    
    methods (Test)
        function testBackslash(testCase)
            input = "\";
            expected = "\";

            f = forge.Forge();
            result = f.render(input);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeSingleQuote(testCase)
            input = "''";
            expected = "''";

            f = forge.Forge();
            result = f.render(input);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeDoubleQuote(testCase)
            input = """";
            expected = """";

            f = forge.Forge();
            result = f.render(input);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeCombination(testCase)
            input = "\\''""";
            expected = "\\''""";

            f = forge.Forge();
            result = f.render(input);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeVariable(testCase)
            input = "\\""{vehicle}";
            expected = "\\""truck";

            f = forge.Forge();
            result = f.render(input, struct("vehicle", "truck"));
            testCase.verifyEqual(result, expected);
        end

        function testNewlineCharacter(testCase)
            input = "bob\nsue";
            expected = "bob\nsue";

            f = forge.Forge();
            result = f.render(input);
            testCase.verifyEqual(result, expected);
        end

        function testCarriageReturnNewline(testCase)
            input = "bob\r\nsue";
            expected = "bob\nsue";

            f = forge.Forge();
            result = f.render(input);
            testCase.verifyEqual(result, expected);
        end

        function testVariableUnderscore(testCase)
            input = "{under_score}";
            expected = "truck";

            f = forge.Forge();
            result = f.render(input, struct("under_score", "truck"));
            testCase.verifyEqual(result, expected);
        end
    end
end
