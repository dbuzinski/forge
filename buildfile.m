function plan = buildfile
import matlab.buildtool.tasks.*;

plan = buildplan(localfunctions);

plan("clean") = CleanTask();
plan("check") = CodeIssuesTask();
plan("test") = TestTask("tests", IncludeSubfolders=false);
plan("integTest") = TestTask("tests/integ", IncludeSubfolders=false, Description="Run integration tests");
plan("package").Inputs = ["src", "doc"];
plan("package").Outputs = "Forge.mltbx";

plan.DefaultTasks = ["check" "test", "integTest", "package"];
end

function packageTask(ctx)
% Package toolbox

% Copy src
copyfile("src/*", "toolbox");

% Copy doc
copyfile("doc/GettingStarted.mlx", "toolbox");

% Package toolbox
matlab.addons.toolbox.packageToolbox("ForgeToolbox.prj", ctx.Task.Outputs.Path);
end