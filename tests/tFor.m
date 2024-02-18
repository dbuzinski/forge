classdef tFor < matlab.unittest.TestCase
    methods (Test)
        function testForEmptyArray(testCase)
            template = "{for x=arr}{x}{end}";
            context = struct("arr", []);
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "");
        end
        
        function testForStringArray(testCase)
            template = "{for x=arr}{x}{end}";
            context = struct("arr", ["a", "b", "c"]);
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "abc");
        end

        function testForWithSpacesAround(testCase)
            template = "{ for x=arr }{x}{ end }";
            context = struct("arr", ["a", "b", "c"]);
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "abc");
        end

        function testForWithSpacesAfter(testCase)
            template = "{for x=arr }{x}{end }";
            context = struct("arr", ["a", "b", "c"]);
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "abc");
        end

        function testForWithSpacesBefore(testCase)
            template = "{ for x=arr}{x}{ end}";
            context = struct("arr", ["a", "b", "c"]);
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "abc");
        end

        function testForNumericArray(testCase)
            template = "{for x=arr}{x}{end}";
            context = struct("arr", [1, 2, 3]);
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "123");
        end
        
        function testForStringScalar(testCase)
            template = "{for x=arr}{x}{end}";
            context = struct("arr", "string");
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "string");
        end
        
        function testForNumericScalar(testCase)
            template = "{for x=arr}{x}{end}";
            context = struct("arr", 1);
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "1");
        end
        
        function testForEmptyContext(testCase)
            template = "{for x=1:3}{x}{end}";
            f = Forge();
            testCase.verifyEqual(f.render(template, struct()), "123");
        end
        
        function testNestedForStructArray(testCase)
            template = "{for x=arr.y}{x}{end}";
            context = struct("arr", struct("y", ["a", "b", "c"]));
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "abc");
        end
        
        function testNestedForNumericArray(testCase)
            template = "{for x=arr}{x.y}{end}";
            context = struct("arr", [struct("y", "a"), struct("y", "b"), struct("y", "c")]);
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "abc");
        end
                
        function testNestedForStruct(testCase)
            template = "{for x=arr}{x.y}{end}";
            context = struct("arr", struct("y", "euclid"));
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "euclid");
        end

        function testVerticalArray(testCase)
            template = "{for x=arr}{x}{end}";
            context = struct("arr", [1; 2; 3]);
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "123");
        end

        function testNestedForTag(testCase)
            template = "{for x=arr}{for y=x}{y}{end}{end}";
            context = struct("arr",[["a"; "b"; "c"], ["d"; "e"; "f"], ["g"; "h";"i"];]);
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "abcdefghi");
        end

        function testNestedIfTag(testCase)
            template = "{for x=arr}{if x==2}{x}{end}{end}";
            context = struct("arr", [1; 2; 3]);
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "2");
        end

        function testNestedPartialTag(testCase)
            template = "{for x=arr}{>x}{end}";
            context = struct("arr", "euclid");
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "euclid");
        end
    end
end