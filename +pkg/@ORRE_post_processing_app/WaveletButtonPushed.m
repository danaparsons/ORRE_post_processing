function WaveletButtonPushed(app, event)

v = ver;
if ~any(strcmp({v.Name}, 'Wavelet Toolbox'))
    error(['Wavelet Toolbox is not installed. To use this feature please '...
        'navigate to Home > Add-Ons > Get Add-Ons > Install Wavelet Toolbox.'])
end

app.WaveletSelectIndependentVariableTimeListBox.ItemsData = 1:numel(app.WaveletSelectIndependentVariableTimeListBox.Items);
wavelettimevalue = app.WaveletSelectIndependentVariableTimeListBox.Value;

app.WaveletSelectDependentVariableListBox.ItemsData = 1:numel(app.WaveletSelectDependentVariableListBox.Items);
waveletdepvalue = app.WaveletSelectDependentVariableListBox.Value;

app.Waveletvalue = waveletdepvalue;
app.WaveletTimevalue = wavelettimevalue;

pkg.fun.plt_wavelet(app.WaveletTimevalue,app.Waveletvalue,app.Wavedata);

end