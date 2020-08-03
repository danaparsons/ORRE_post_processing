function OverwriteCheckBoxValueChanged(app,event)
value = app.DataFilterListBox.Value;

if app.OverwriteCheckBox.Value
    %app.filtplot = app.Wavedata.(strcat('ch',(num2str(value))));
    app.Wavedata.(strcat('ch',(num2str(value)))) = app.FilteredData(:,value);
else
    app.FilteredData(:,value) = app.FilteredData(:,value);
end

%DataFilterListBoxValueChanged(app);
end
