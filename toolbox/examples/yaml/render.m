% Create renderer
renderer = Forge;

% Load template from mtl file
tmpl = fileread("templates/users.mtl");

% Load user data from json
ctx.users = jsondecode(fileread("data/users.json"));

% Render yaml text
users = renderer.render(tmpl, ctx);

% Remove empty lines
while ~isempty(regexp(users, newline+" *"+newline, "once"))
    users = regexprep(users, newline+" *"+newline, newline);
end

% Write result to yaml
writelines(users, "users.yaml");