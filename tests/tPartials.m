classdef tPartials < matlab.unittest.TestCase
    methods (TestClassSetup)
        function instantiateForge(testCase)
            import matlab.unittest.fixtures.PathFixture;
            testCase.applyFixture(PathFixture("../toolbox"));
        end
    end
    
    methods (Test)
        % function testPartialEmptyContext(testCase)
        %     % Test partial with empty context
        %     template = "{>p}";
        %     expected = "";
        % 
        %     f = forge.Forge();
        %     result = f.render(template);
        %     testCase.verifyEqual(result, expected);
        % end
        % 
        % function testPartialWithContext(testCase)
        %     % Test partial with non-empty context
        %     template = "{>p}";
        %     expected = "";
        % 
        %     f = forge.Forge();
        %     result = f.render(template, struct());
        %     testCase.verifyEqual(result, expected);
        % end
        % 
        % function testPartialNestedKey(testCase)
        %     % Test partial with nested key
        %     template = "{>p.a}";
        %     expected = "";
        % 
        %     f = forge.Forge();
        %     result = f.render(template, struct());
        %     testCase.verifyEqual(result, expected);
        % end

        function testPartialWithContextValue(testCase)
            template = "{>p}";
            expected = "3";

            f = forge.Forge();
            result = f.render(template, struct("p", 3));
            testCase.verifyEqual(result, expected);
        end

        % function testPartialWithContextEmptyArray(testCase)
        %     % Test partial with empty array in context
        %     template = "{>p}";
        %     expected = "";
        % 
        %     f = forge.Forge();
        %     result = f.render(template, struct("p", {}));
        %     testCase.verifyEqual(result, expected);
        % end
        % 
        % function testPartialWithContextFunction(testCase)
        %     % Test partial with context as a function
        %     template = "{>p}";
        %     expected = "foo";
        % 
        %     f = forge.Forge();
        %     result = f.render(template, struct("p", @(~) "foo"));
        %     testCase.verifyEqual(result, expected);
        % end

        function testPartialNestedKeyWithValue(testCase)
            % Test partial with nested key and context value
            template = "{>p.a}";
            expected = "foo";

            f = forge.Forge();
            result = f.render(template, struct("p", struct("a", "foo")));
            testCase.verifyEqual(result, expected);
        end

        function testNestedPartialNestedKeyWithValue(testCase)
            % Test nested partial with nested key and context value
            template = "{>p.a.b}";
            expected = "foo";

            f = forge.Forge();
            result = f.render(template, struct("p", struct("a", struct("b", "foo"))));
            testCase.verifyEqual(result, expected);
        end

        % function testComplexTemplateWithContext(testCase)
        %     % Test complex template with nested partials and context
        %     template = "book: {title}{for author in authors}{>partials.comma} {>partials.author}{/for}";
        %     context = struct("title", "Bob", "authors", { ...
        %         struct("name", "Liz", "pets", {struct("name", "Errol")}) ...
        %         struct("name", "Jan", "pets", {}) ...
        %     }, "partials", struct("author", "author: {author.name}{for pet in author.pets}{>partials.comma} {>partials.pet}{/for}", "pet", "pet: {pet.name}", "comma", ","));
        %     expected = "book: Bob, author: Liz, pet: Errol, author: Jan";
        % 
        %     f = forge.Forge();
        %     result = f.render(template, context);
        %     testCase.verifyEqual(result, expected);
        % end
    end
end
