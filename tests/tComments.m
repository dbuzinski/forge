classdef tComments < matlab.unittest.TestCase
    methods (TestClassSetup)
        function instantiateForge(testCase)
            import matlab.unittest.fixtures.PathFixture;
            testCase.applyFixture(PathFixture("../toolbox"));
        end
    end

    methods(Test)
        function testComment(testCase)
            input = "{!this won\'t show up!}";
            expected = "";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEmptyComment(testCase)
            input = "{!!}";
            expected = "";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testCommentContainingEscapeChars(testCase)
            input = "{!this won't show up\neither!}";
            expected = "";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testCommentContainingDelimiters(testCase)
            input = "{!this won't {show} up!}";
            expected = "";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapedComment(testCase)
            input = "\{!this will show up!}";
            expected = "{!this will show up!}";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapedCommentWithBackslash(testCase)
            input = "\{!this will"+newline+" show up!}";
            expected = "{!this will"+newline+" show up!}";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testUnclosedComment(testCase)
            input = "{!this will also show up}";
            expected = "{!this will also show up}";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testCommentWithTwoCloses(testCase)
            input = "{!this won\'t, but!}this part will show up!}";
            expected = "this part will show up!}";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testCommentWithDelimiterOverlaps(testCase)
            input = "{also, {!this} part won\'t show up!}";
            expected = "{also, ";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testMultipleComments(testCase)
            input = "{!more than !}just one{!silly!} comment";
            expected = "just one comment";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end
    end 
end