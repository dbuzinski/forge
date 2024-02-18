classdef tPartials < matlab.unittest.TestCase
    methods (Test)
        function testPartialPassesContext(testCase)
            template = "{>p}";
            expected = "euclid";

            f = Forge();
            result = f.render(template, struct("p", "{q}", "q", "euclid"));
            testCase.verifyEqual(result, expected);
        end

        function testPartialWithContextValue(testCase)
            template = "{>p}";
            expected = "euclid";

            f = Forge();
            result = f.render(template, struct("p", "euclid"));
            testCase.verifyEqual(result, expected);
        end

        function testPartialNestedKeyWithValue(testCase)
            template = "{>p.a}";
            expected = "euclid";

            f = Forge();
            result = f.render(template, struct("p", struct("a", "euclid")));
            testCase.verifyEqual(result, expected);
        end

        function testNestedPartialNestedKeyWithValue(testCase)
            template = "{>p.a.b}";
            expected = "euclid";

            f = Forge();
            result = f.render(template, struct("p", struct("a", struct("b", "euclid"))));
            testCase.verifyEqual(result, expected);
        end
    end
end
