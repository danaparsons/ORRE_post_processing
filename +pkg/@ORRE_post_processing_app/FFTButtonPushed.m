function FFTButtonPushed(app, event)
app.SelectIndependentVariableTimeListBox.ItemsData = 1:numel(app.SelectIndependentVariableTimeListBox.Items);
timevalue = app.SelectIndependentVariableTimeListBox.Value;

app.SelectDependentVariableListBox.ItemsData = 1:numel(app.SelectDependentVariableListBox.Items);
depvalue = app.SelectDependentVariableListBox.Value;

if app.StartTimeEditField == true
    app.FFTvalue = depvalue(StartTimeEditField.Value:EndTimeEditField.Value);
    app.Timevalue = timevalue(StartTimeEditField.Value:EndTimeEditField.Value);
else
    app.FFTvalue = depvalue;
    app.Timevalue = timevalue;
end

if app.FrequencyCheckBox.Value == 1
    app.SelectedFrequency = app.DesiredSampleFrequencyEditField.Value;
    pkg.fun.plt_fft(app.Timevalue,app.FFTvalue,app.Wavedata,app.SelectedFrequency);
end
if app.FrequencyCheckBox.Value == 0
    app.Wavedata.addprop(strcat('DominantPeriod',num2str(app.SelectDependentVariableListBox.Value)));
    app.Wavedata.addprop(strcat('FS',num2str(app.SelectDependentVariableListBox.Value)));
    [app.Wavedata.(strcat('DominantPeriod',num2str(app.SelectDependentVariableListBox.ItemsData))),app.Wavedata.(strcat('FS',num2str(app.SelectDependentVariableListBox.ItemsData)))] =  pkg.fun.plt_fft(app.Timevalue,app.FFTvalue,app.Wavedata);
    
end
end

