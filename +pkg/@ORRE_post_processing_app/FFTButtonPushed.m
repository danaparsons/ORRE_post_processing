function FFTButtonPushed(app, event)
app.SelectIndependentVariableTimeListBox.ItemsData = 1:numel(app.SelectIndependentVariableTimeListBox.Items);
timevalue = app.SelectIndependentVariableTimeListBox.Value;

app.SelectDependentVariableListBox.ItemsData = 1:numel(app.SelectDependentVariableListBox.Items);
depvalue = app.SelectDependentVariableListBox.Value;

app.FFTvalue = depvalue;
app.Timevalue = timevalue;

if app.FrequencyCheckBox.Value == 1
    app.SelectedFrequency = app.DesiredSampleFrequencyEditField.Value;
    pkg.fun.plt_fft(app.Timevalue,app.FFTvalue,app.Wavedata,app.SelectedFrequency);
end
if app.FrequencyCheckBox.Value == 0
    app.Wavedata.addprop('DominantPeriod');
    app.Wavedata.addprop('FS');
    [app.Wavedata.DominantPeriod,app.Wavedata.FS] =  pkg.fun.plt_fft(app.Timevalue,app.FFTvalue,app.Wavedata);
    
end
end

