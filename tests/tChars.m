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
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeSingleQuote(testCase)
            input = "''";
            expected = "''";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeCombination(testCase)
            input = "\\''";
            expected = "\\''";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeVariable(testCase)
            input = "\\''{vehicle}";
            expected = "\\''truck";

            f = forge.Forge();
            result = f.render(input, struct("vehicle", "truck"));
            testCase.verifyEqual(result, expected);
        end

        function testNewlineCharacter(testCase)
            input = "bob\nsue";
            expected = "bob\nsue";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testCarriageReturnNewline(testCase)
            input = "bob\r\nsue";
            expected = "bob\nsue";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testVariableUnderscore(testCase)
            input = "{under_score}";
            expected = "truck";

            f = forge.Forge();
            result = f.render(input, struct("under_score", "truck"));
            testCase.verifyEqual(result, expected);
        end

        % function testVariableHyphenatedKey(testCase)
        %     input = "{hyphenated-key}";
        %     expected = "truck";
        % 
        %     f = forge.Forge();
        %     result = f.render(input, struct("hyphenated-key", "truck"));
        %     testCase.verifyEqual(result, expected);
        % end
        % 
        % function testVariableSpecialContext(testCase)
        %     input = "{@context}";
        %     expected = "special tags in json-ld use at signs";
        % 
        %     f = forge.Forge();
        %     result = f.render(input, struct("@context", expected));
        %     testCase.verifyEqual(result, expected);
        % end
        % 
        % function testVariableSpecialTitle(testCase)
        %     input = "{dc:title}";
        %     expected = "special key in json-ld use compact IRI";
        % 
        %     f = forge.Forge();
        %     result = f.render(input, struct("dc:title", expected));
        %     testCase.verifyEqual(result, expected);
        % end
        % 
        % function testNestedVariables(testCase)
        %     input = "{dc:title.dc:topic}";
        %     expected = "special key in json-ld use compact IRI";
        % 
        %     f = forge.Forge();
        %     result = f.render(input, struct);
        %     testCase.verifyEqual(result, expected);
        % end
    end
end
