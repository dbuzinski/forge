classdef tEscapeTags < matlab.unittest.TestCase
    methods (Test)
        function testEscape(testCase)
            input = "\{euclid}";
            expected = "{euclid}";

            f = Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeDotRef(testCase)
            input = "\{euclid.hilbert}";
            expected = "{euclid.hilbert}";

            f = Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapePartial(testCase)
            input = "\{>euclid}";
            expected = "{>euclid}";

            f = Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeFor(testCase)
            input = "\{for mathematician=mathematicians}";
            expected = "{for mathematician=mathematicians}";

            f = Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeIf(testCase)
            input = "\{if isa(euclid, Geometer)}";
            expected = "{if isa(euclid, Geometer)}";

            f = Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeIfNot(testCase)
            input = "\{if ~ isempty(unsolvedProblems)}";
            expected = "{if ~ isempty(unsolvedProblems)}";

            f = Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeElse(testCase)
            input = "\{else}";
            expected = "{else}";

            f = Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeEnd(testCase)
            input = "\{end}";
            expected = "{end}";

            f = Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end
    end
end
