classdef tEscapeTags < matlab.unittest.TestCase
    methods (TestClassSetup)
        function instantiateForge(testCase)
            import matlab.unittest.fixtures.PathFixture;
            testCase.applyFixture(PathFixture("../toolbox"));
        end
    end

    methods (Test)
        function testEscapeBob(testCase)
            % Test escaping of {bob}
            input = "\{bob}";
            expected = "{bob}";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeBobBloss(testCase)
            % Test escaping of {bob.bloss}
            input = "\{bob.bloss}";
            expected = "{bob.bloss}";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeReindeer(testCase)
            % Test escaping of {>reindeer}
            input = "\{>reindeer}";
            expected = "{>reindeer}";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeForAngerInMgmt(testCase)
            % Test escaping of {for anger in mgmt}
            input = "\{for anger=mgmt}";
            expected = "{for anger=mgmt}";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeIfThen(testCase)
            % Test escaping of {if then}
            input = "\{if then}";
            expected = "{if then}";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeIfNotNow(testCase)
            % Test escaping of {if not now}
            input = "\{if ~ now}";
            expected = "{if ~ now}";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeElse(testCase)
            % Test escaping of {else}
            input = "\{else}";
            expected = "{else}";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end

        function testEscapeEnd(testCase)
            % Test escaping of {/if}
            input = "\{end}";
            expected = "{end}";

            f = forge.Forge();
            result = f.render(input, struct);
            testCase.verifyEqual(result, expected);
        end
    end
end
