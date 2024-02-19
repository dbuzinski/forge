classdef tIf < matlab.unittest.TestCase
    methods (Test)
        function testIfTrue(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if true}{a}{end}", context), "euclid");
        end
        
        function testIfFalse(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if false}{a}{end}", context), "");
        end
        
        function testIfNotTrue(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if ~ true}{a}{end}", context), "");
        end
        
        function testIfNotFalse(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if ~ false}{a}{end}", context), "euclid");
        end

        function testConditionDependsOnContext(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if a==""euclid""}{a}{end}", context), "euclid");
        end

        function testIfElseif(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if false}blah{elseif true}{a}{end}", context), "euclid");
        end

        function testIfMultipleElseif(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if false}blah{elseif false}blah{elseif true}{a}{end}", context), "euclid");
        end
        
        function testIfElse(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if false}blah{else}{a}{end}", context), "euclid");
        end

        function testIfElseifElse(testCase)
            context = struct("a", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render("{if false}blah{elseif false}blah{else}{a}{end}", context), "euclid");
        end

        function testForIfElseifElse(testCase)
            context = struct("names", ["Jim", "Jeff", "Jane"]);
            f = Forge();
            tmpl = "Hello {for name=names}{if name==""Jeff""}Jeffrey, {elseif name~=names(end)}{name}, {else}and {name}.{end}{end}";
            testCase.verifyEqual(f.render(tmpl, context), "Hello Jim, Jeffrey, and Jane.");
        end

        function testIfElseifFor(testCase)
            f = Forge();
            context = struct("greeting", "hello", "names", ["Jim", "Jeff", "Jane"]);
            tmpl = "{if greeting == ""hello""}Hello!{elseif greeting == ""goodbye""}{for name=names}Goodbye {name}! {end}{else}{for name=names}Hello {name}! {end}{end}";
            testCase.verifyEqual(f.render(tmpl, context), "Hello!");
            context = struct("greeting", "goodbye", "names", ["Jim", "Jeff", "Jane"]);
            testCase.verifyEqual(f.render(tmpl, context), "Goodbye Jim! Goodbye Jeff! Goodbye Jane! ");
            context = struct("greeting", "default", "names", ["Jim", "Jeff", "Jane"]);
            testCase.verifyEqual(f.render(tmpl, context), "Hello Jim! Hello Jeff! Hello Jane! ");
        end
    end
end
