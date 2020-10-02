function PlotFFTButton_FilterPushed(app, event)
filttimevalue = app.FilterTimeDropDown.Value;

app.DataFilterListBox.ItemsData = 1:numel(app.DataFilterListBox.Items);
filtdepvalue = app.DataFilterListBox.Value;

app.Wavedata.addprop(strcat('DominantPeriod',(num2str(filtdepvalue))));
app.Wavedata.addprop(strcat('FS',(num2str(filtdepvalue))));
[app.Wavedata.(strcat('DominantPeriod',(num2str(filtdepvalue)))),app.Wavedata.(strcat('FS',(num2str(filtdepvalue))))] =  pkg.fun.plt_fft(filttimevalue,filtdepvalue,app.Wavedata);

end
