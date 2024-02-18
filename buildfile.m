function plan = buildfile
import matlab.buildtool.tasks.*;

plan = buildplan(localfunctions);

plan("clean") = CleanTask();
plan("check") = CodeIssuesTask();
plan("test") = TestTask("tests", IncludeSubfolders=false);
plan("integTest") = TestTask("tests/integ", IncludeSubfolders=false, Description="Run integration tests");
plan("package").Inputs = "toolbox";
plan("package").Outputs = "Forge.mltbx";

plan.DefaultTasks = ["check" "test", "integTest", "package"];
end

function packageTask(ctx)
% Package toolbox
matlab.addons.toolbox.packageToolbox("ForgeToolbox.prj", ctx.Task.Outputs.Path);
end