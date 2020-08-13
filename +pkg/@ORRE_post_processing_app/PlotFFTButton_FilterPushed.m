function PlotFFTButton_FilterPushed(app, event)
%app.SelectIndependentVariableTimeListBox.ItemsData = 1:numel(app.SelectIndependentVariableTimeListBox.Items);
filttimevalue = app.FilterTimeDropDown.Value;

app.DataFilterListBox.ItemsData = 1:numel(app.DataFilterListBox.Items);
filtdepvalue = app.DataFilterListBox.Value;

%app.FFTvalue = depvalue;
%app.Timevalue = timevalue;

%             if app.FrequencyCheckBox.Value == 1
%                 app.SelectedFrequency = app.DesiredSampleFrequencyEditField.Value;
%                 %pkg.fun.plt_fft(app.Timevalue,app.FFTvalue,app.Wavedata,app.SelectedFrequency);
%                 pkg.fun.plt_fft(filttimevalue,filtdepvalue,app.Wavedata,app.SelectedFrequency);
%             end
app.Wavedata.addprop(strcat('DominantPeriod',(num2str(filtdepvalue))));
app.Wavedata.addprop(strcat('FS',(num2str(filtdepvalue))));
%[app.Wavedata.DominantPeriod,app.Wavedata.FS] =  pkg.fun.plt_fft(app.Timevalue,app.FFTvalue,app.Wavedata);
%app.Wavedata.DominantPeriod
[app.Wavedata.(strcat('DominantPeriod',(num2str(filtdepvalue)))),app.Wavedata.(strcat('FS',(num2str(filtdepvalue))))] =  pkg.fun.plt_fft(filttimevalue,filtdepvalue,app.Wavedata);

end
