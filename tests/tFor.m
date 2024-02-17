classdef tFor < matlab.unittest.TestCase
    methods (Test)
        function testForTagEmptyContext(testCase)
            template = "{for x=arr}{x}{end}";
            context = struct("arr", []);
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "");
        end
        
        function testForTagStringArray(testCase)
            template = "{for x=arr}{x}{end}";
            context = struct("arr", ["a", "b", "c"]);
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "abc");
        end
        
        function testForTagNumericArray(testCase)
            template = "{for x=arr}{x}{end}";
            context = struct("arr", [1, 2, 3]);
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "123");
        end
        
        function testForTagString(testCase)
            template = "{for x=arr}{x}{end}";
            context = struct("arr", "string");
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "string");
        end
        
        function testForTagNumericScalar(testCase)
            template = "{for x=arr}{x}{end}";
            context = struct("arr", 1);
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "1");
        end
        
        function testNestedForTagEmptyContext(testCase)
            template = "{for x=1:3}{x}{end}";
            f = Forge();
            testCase.verifyEqual(f.render(template, struct()), "123");
        end
        
        function testNestedForTagStructArray(testCase)
            template = "{for x=arr.y}{x}{end}";
            context = struct("arr", struct("y", ["a", "b", "c"]));
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "abc");
        end
        
        function testNestedForTagNumericArray(testCase)
            template = "{for x=arr}{x.y}{end}";
            context = struct("arr", [struct("y", "a"), struct("y", "b"), struct("y", "c")]);
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "abc");
        end
                
        function testNestedForTagStruct(testCase)
            template = "{for x=arr}{x.y}{end}";
            context = struct("arr", struct("y", "orange"));
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "orange");
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
            context = struct("arr", "ayo");
            f = Forge();
            testCase.verifyEqual(f.render(template, context), "ayo");
        end
    end
end