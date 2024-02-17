classdef tChars < matlab.unittest.TestCase
    methods (Test)
        function testBackslash(testCase)
            input = "\";
            expected = "\";

            f = Forge();
            result = f.render(input);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeSingleQuote(testCase)
            input = "''";
            expected = "''";

            f = Forge();
            result = f.render(input);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeDoubleQuote(testCase)
            input = """";
            expected = """";

            f = Forge();
            result = f.render(input);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeCombination(testCase)
            input = "\\''""";
            expected = "\\''""";

            f = Forge();
            result = f.render(input);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeVariable(testCase)
            input = "\\""{vehicle}";
            expected = "\\""truck";

            f = Forge();
            result = f.render(input, struct("vehicle", "truck"));
            testCase.verifyEqual(result, expected);
        end

        function testNewlineCharacter(testCase)
            input = "bob"+newline+"sue";
            expected = "bob"+newline+"sue";

            f = Forge();
            result = f.render(input);
            testCase.verifyEqual(result, expected);
        end

        function testCarriageReturnNewline(testCase)
            input = "bob\r"+newline+"sue";
            expected = "bob"+newline+"sue";

            f = Forge();
            result = f.render(input);
            testCase.verifyEqual(result, expected);
        end

        function testVariableUnderscore(testCase)
            input = "{under_score}";
            expected = "truck";

            f = Forge();
            result = f.render(input, struct("under_score", "truck"));
            testCase.verifyEqual(result, expected);
        end
    end
end
