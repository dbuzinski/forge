% Create renderer
renderer = Forge;

% Load template from mtl file
tmpl = fileread("templates/blog.mtl");

% Add needed data to context
ctx.title = "Forge Dev Blog";
ctx.organization = "Forge";
% Load some data from external source
ctx.posts = jsondecode(fileread("data/posts.json"));
% Use nested templates
ctx.postSummary = fileread("templates/postSummary.mtl");
ctx.header = fileread("templates/header.mtl");
ctx.footer = fileread("templates/footer.mtl");

% Render page
blog = renderer.render(tmpl, ctx);
% Write to a HTML file
writelines(blog, "blog.html");