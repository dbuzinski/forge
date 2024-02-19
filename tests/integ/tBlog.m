classdef tBlog < matlab.unittest.TestCase
    methods (Test)
        function testBlog(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.StringComparator

            renderer = Forge();
            tmpl = fileread("testdata/templates/blog.mtl");

            ctx.title = "Forge Dev Blog";
            ctx.organization = "Forge";
            ctx.posts = jsondecode(fileread("testdata/data/posts.json"));
            ctx.postSummary = fileread("testdata/templates/postSummary.mtl");
            ctx.header = fileread("testdata/templates/header.mtl");
            ctx.footer = fileread("testdata/templates/footer.mtl");

            expected = string(fileread("testdata/rendered/blog.html"));
            actual = renderer.render(tmpl, ctx);

            testCase.verifyThat(expected, IsEqualTo(actual,"Using",StringComparator(IgnoringWhitespace=true)));
        end

        function testNoPosts(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.StringComparator

            renderer = Forge();
            tmpl = fileread("testdata/templates/blog.mtl");

            ctx.title = "Forge Dev Blog";
            ctx.organization = "Forge";
            ctx.posts = [];
            ctx.header = fileread("testdata/templates/header.mtl");
            ctx.footer = fileread("testdata/templates/footer.mtl");

            blog = renderer.render(tmpl, ctx);

            testCase.verifyTrue(blog.contains("No posts!"));
        end
    end
end