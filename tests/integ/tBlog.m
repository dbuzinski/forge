classdef tBlog < matlab.unittest.TestCase
    methods (TestClassSetup)
        function setupPath(testCase)
            import matlab.unittest.fixtures.PathFixture;
            testCase.applyFixture(PathFixture("../../toolbox"));
        end
    end
    
    methods (Test)
        function testBlog(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.StringComparator

            template = fileread("testdata/templates/blog.mtl");
            context = jsondecode(fileread("testdata/contexts/blog.json"));
            context.commentSection = fileread("testdata/templates/comment.mtl");
            context.addComment = fileread("testdata/templates/addcomment.mtl");
            f = forge.Forge();

            expected = string(fileread("testdata/rendered/blog.html"));
            actual = f.render(template, context);

            testCase.verifyThat(expected, IsEqualTo(actual,"Using",StringComparator(IgnoringWhitespace=true)));
        end

        function testEmpty(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.StringComparator

            template = fileread("testdata/templates/blog.mtl");
            context.blog.title = "Scrumptious lessons";
            context.posts = [];
            f = forge.Forge();

            expected = "<h1>Scrumptious lessons</h1><p>No posts!</p>";
            actual = f.render(template, context);

            testCase.verifyThat(expected, IsEqualTo(actual,"Using",StringComparator(IgnoringWhitespace=true)));
        end
    end
end