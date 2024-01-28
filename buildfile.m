function plan = buildfile
import matlab.buildtool.tasks.*;

plan = buildplan(localfunctions);
plan("clean") = CleanTask();
plan("check") = CodeIssuesTask();
plan("test") = TestTask("tests", IncludeSubfolders=false);
plan("integTest") = TestTask("tests/integ", IncludeSubfolders=false);
plan.DefaultTasks = ["check" "test", "integTest"];
end
