classdef tBlog < matlab.unittest.TestCase
    methods (TestClassSetup)
        function setupPath(testCase)
            import matlab.unittest.fixtures.PathFixture;
            testCase.applyFixture(PathFixture("../../toolbox"));
        end
    end
    
    methods (Test)
        function testBlog(testCase)
            expected = fileread("testdata/rendered/blog.html");

            template = fileread("testdata/templates/blog.mtl");
            context = jsondecode(fileread("testdata/contexts/blog.json"));
            context.commentSection = fileread("testdata/templates/comment.mtl");
            context.addComment = fileread("testdata/templates/addcomment.mtl");
            f = forge.Forge();
            actual = f.render(template, context);
            testCase.verifyEqual(expected, actual);
        end
    end
end