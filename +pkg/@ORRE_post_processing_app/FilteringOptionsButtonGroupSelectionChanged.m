function FilteringOptionsButtonGroupSelectionChanged(app, event)
fpass = app.SpecifyPassbandFrequencyEditField.Value;
value = app.DataFilterListBox.Value;

if app.NoneButton.Value == 1
    app.FilteredData(:,value) = app.Wavedata.(strcat('ch',(num2str(value))));
    %app.Filtered_Channels = app.Combined_Channels;
    app.OverwriteCheckBox.Enable = 'off';
    
end
if app.LowPassButton.Value == 1
    app.OverwriteCheckBox.Enable = 'on';
    %app.Wavedata.(strcat('ch',(num2str(value)))) = lowpass(app.Wavedata.(strcat('ch',(num2str(value)))),fpass,app.Wavedata.(strcat('FS',(num2str(value)))));
    app.FilteredData(:,value) = lowpass(app.Wavedata.(strcat('ch',(num2str(value)))),fpass,app.Wavedata.(strcat('FS',(num2str(value)))));
    
    %fix app.fs
    %app.Filtered_Channels = lowpass(app.Combined_Channels,fpass,app.fs);
end
if app.HighPassButton.Value == 1
    app.OverwriteCheckBox.Enable = 'on';
    %app.Wavedata.(strcat('ch',(num2str(value)))) = lowpass(app.Wavedata.(strcat('ch',(num2str(value)))),fpass,app.Wavedata.(strcat('FS',(num2str(value)))));
    app.FilteredData(:,value) = highpass(app.Wavedata.(strcat('ch',(num2str(value)))),fpass,app.Wavedata.(strcat('FS',(num2str(value)))));
    %fix app.fs
    %app.Filtered_Channels = highpass(app.Combined_Channels,fpass,app.fs);
end

app.FilterTimeDropDown.ItemsData = 1:numel(app.FilterTimeDropDown.Items);
filtertimevalue = app.FilterTimeDropDown.Value;

%plot(app.FilterAxes,app.Wavedata.(strcat('ch',(num2str(app.TimeFilterEditField.Value)))),app.FilteredData(:,value));
plot(app.FilterAxes,app.Wavedata.(strcat('ch',(num2str(app.FilterTimeDropDown.Value)))),app.FilteredData(:,value));
%savefig('filter.fig')

pkg.fun.Save_UI_Axes.copyUIAxes(app.FilterAxes);
savefig(strcat('+output/FilterTimeHistory_',(app.Wavedata.headers{value}),'.fig')); 

end

