function WaveletButtonPushed(app, event)
app.WaveletSelectIndependentVariableTimeListBox.ItemsData = 1:numel(app.WaveletSelectIndependentVariableTimeListBox.Items);
wavelettimevalue = app.WaveletSelectIndependentVariableTimeListBox.Value;

app.WaveletSelectDependentVariableListBox.ItemsData = 1:numel(app.WaveletSelectDependentVariableListBox.Items);
waveletdepvalue = app.WaveletSelectDependentVariableListBox.Value;

app.Waveletvalue = waveletdepvalue;
app.WaveletTimevalue = wavelettimevalue;

pkg.fun.plt_wavelet(app.WaveletTimevalue,app.Waveletvalue,app.Wavedata);

% if app.FrequencyCheckBox.Value == 1
%     app.SelectedFrequency = app.DesiredSampleFrequencyEditField.Value;
%     pkg.fun.plt_fft(app.Timevalue,app.FFTvalue,app.Wavedata,app.SelectedFrequency);
% end
% if app.FrequencyCheckBox.Value == 0
%     app.Wavedata.addprop('DominantPeriod');
%     app.Wavedata.addprop('FS');
%     [app.Wavedata.DominantPeriod,app.Wavedata.FS] =  pkg.fun.plt_fft(app.Timevalue,app.FFTvalue,app.Wavedata);
%     
% end
end