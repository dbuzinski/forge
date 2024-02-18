classdef tErrors < matlab.unittest.TestCase
    methods(Test)
        function testInvalidForIterator(testCase)
            f = Forge();
            template = "{for a=undefined}euclid{end}";
            testCase.verifyError(@()f.render(template), "Forge:BadForTag");
        end

        function testIncompleteForStatement(testCase)
            f = Forge();
            template = "{for a=}{a}{end}";
            testCase.verifyError(@()f.render(template), "Forge:BadForTag");
        end

        function testInvalidForTag(testCase)
            f = Forge();
            template = "{for} euclid";
            testCase.verifyError(@()f.render(template), "Forge:BadForTag");
        end

        function testInvalidIfCondition(testCase)
            f = Forge();
            template = "{if undefined}euclid{end}";
            testCase.verifyError(@()f.render(template), "Forge:BadIfTag");
        end

        function testIncompleteIfStatement(testCase)
            f = Forge();
            template = "{if 1==}euclid{end}";
            testCase.verifyError(@()f.render(template), "Forge:BadIfTag");
        end

        function testInvalidIfTag(testCase)
            f = Forge();
            template = "{if}euclid{end}";
            testCase.verifyError(@()f.render(template), "Forge:BadIfTag");
        end
        
        function testInvalidElseifTag(testCase)
            f = Forge();
            template = "{elseif}";
            testCase.verifyError(@()f.render(template), "Forge:BadElseifTag");
        end

        function testUnmatchedElseifTag(testCase)
            f = Forge();
            template = "{elseif true}euclid";
            testCase.verifyError(@()f.render(template), "Forge:UnmatchedElseifTag");
        end

        function testUnmatchedElseifTagInFor(testCase)
            f = Forge();
            template = "{for a=1:3}{elseif true}{end}";
            testCase.verifyError(@()f.render(template), "Forge:UnmatchedElseifTag");
        end

        function testUnmatchedEndTag(testCase)
            f = Forge();
            template = "{end}";
            testCase.verifyError(@()f.render(template), "Forge:UnmatchedEndTag");
        end

        function UnclosedForTag(testCase)
            f = Forge();
            template = "{for a=1:3}euclid";
            testCase.verifyError(@()f.render(template), "Forge:UnclosedTag");
        end

        function UnclosedIfTag(testCase)
            f = Forge();
            template = "{if true}euclid";
            testCase.verifyError(@()f.render(template), "Forge:UnclosedTag");
        end

        function UnclosedIfElseif(testCase)
            f = Forge();
            template = "{if false}euclid{elseif true}hilbert";
            testCase.verifyError(@()f.render(template), "Forge:UnclosedTag");
        end
    end
end