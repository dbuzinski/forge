classdef tEscapeTags < matlab.unittest.TestCase
    methods (Test)
        function testEscapeBob(testCase)
            input = "\{bob}";
            expected = "{bob}";

            f = Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeBobBloss(testCase)
            input = "\{bob.bloss}";
            expected = "{bob.bloss}";

            f = Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeReindeer(testCase)
            input = "\{>reindeer}";
            expected = "{>reindeer}";

            f = Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeForAngerInMgmt(testCase)
            input = "\{for anger=mgmt}";
            expected = "{for anger=mgmt}";

            f = Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeIfThen(testCase)
            input = "\{if then}";
            expected = "{if then}";

            f = Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeIfNotNow(testCase)
            input = "\{if ~ now}";
            expected = "{if ~ now}";

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
