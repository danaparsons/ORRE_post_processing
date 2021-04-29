function PlotLaplaceTransformButtonPushed(app, event)
app.SelectIndependentVariableTimeListBox_2.ItemsData = 1:numel(app.SelectIndependentVariableTimeListBox_2.Items);
timevalue_laplace = app.SelectIndependentVariableTimeListBox_2.Value;

app.SelectDependentVariableListBox_2.ItemsData = 1:numel(app.SelectDependentVariableListBox_2.Items);
depvalue_laplace = app.SelectDependentVariableListBox_2.Value;

app.laplacevalue = depvalue_laplace;
app.Timevalue_laplace = timevalue_laplace;
pkg.fun.plt_laplace(app.Timevalue_laplace,app.laplacevalue,app.Wavedata);
%%% this is just a general set up, doesn't work for laplace transform %%%
end
