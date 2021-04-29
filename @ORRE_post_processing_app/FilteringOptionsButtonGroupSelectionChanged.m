function FilteringOptionsButtonGroupSelectionChanged(app, event)
fpass = app.SpecifyPassbandFrequencyEditField.Value;
value = app.DataFilterListBox.Value;

if app.NoneButton.Value == 1
    app.FilteredData(:,value) = app.Wavedata.(strcat('ch',(num2str(value))));
    app.OverwriteCheckBox.Enable = 'off';
    
end
if app.LowPassButton.Value == 1
    app.OverwriteCheckBox.Enable = 'on';
    app.FilteredData(:,value) = lowpass(app.Wavedata.(strcat('ch',(num2str(value)))),fpass,app.Wavedata.(strcat('FS',(num2str(value)))));
end
if app.HighPassButton.Value == 1
    app.OverwriteCheckBox.Enable = 'on';
    app.FilteredData(:,value) = highpass(app.Wavedata.(strcat('ch',(num2str(value)))),fpass,app.Wavedata.(strcat('FS',(num2str(value)))));
end

app.FilterTimeDropDown.ItemsData = 1:numel(app.FilterTimeDropDown.Items);
filtertimevalue = app.FilterTimeDropDown.Value;

plot(app.FilterAxes,app.Wavedata.(strcat('ch',(num2str(app.FilterTimeDropDown.Value)))),app.FilteredData(:,value));

pkg.fun.Save_UI_Axes.copyUIAxes(app.FilterAxes);
savefig(strcat('+output/FilterTimeHistory_',(app.Wavedata.headers{value}),'.fig')); 

end

