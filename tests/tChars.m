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
            input = "\\""{a}";
            expected = "\\""euclid";

            f = Forge();
            result = f.render(input, struct("a", "euclid"));
            testCase.verifyEqual(result, expected);
        end

        function testNewlineCharacter(testCase)
            input = "euclid"+newline+"hilbert";
            expected = "euclid"+newline+"hilbert";

            f = Forge();
            result = f.render(input);
            testCase.verifyEqual(result, expected);
        end

        function testCarriageReturnNewline(testCase)
            input = "euclid\r"+newline+"hilbert";
            expected = "euclid"+newline+"hilbert";

            f = Forge();
            result = f.render(input);
            testCase.verifyEqual(result, expected);
        end

        function testVariableUnderscore(testCase)
            input = "{under_score}";
            expected = "euclid";

            f = Forge();
            result = f.render(input, struct("under_score", "euclid"));
            testCase.verifyEqual(result, expected);
        end
        
        function testTagWithSpacesAround(testCase)
            input = "{ myvar }";
            expected = "euclid";

            f = Forge();
            result = f.render(input, struct("myvar", "euclid"));
            testCase.verifyEqual(result, expected);
        end

        function testTagWithSpacesBefore(testCase)
            input = "{ myvar}";
            expected = "euclid";

            f = Forge();
            result = f.render(input, struct("myvar", "euclid"));
            testCase.verifyEqual(result, expected);
        end

        function testTagWithSpacesAfter(testCase)
            input = "{myvar }";
            expected = "euclid";

            f = Forge();
            result = f.render(input, struct("myvar", "euclid"));
            testCase.verifyEqual(result, expected);
        end
    end
end
