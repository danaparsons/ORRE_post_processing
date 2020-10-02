function OverwriteCheckBoxValueChanged(app,event)
value = app.DataFilterListBox.Value;

%%% this is a work in progress, frequency values need to replace for a channel %%%

if app.OverwriteCheckBox.Value
    app.Wavedata.(strcat('ch',(num2str(value)))) = app.FilteredData(:,value);   
    newrow = array2table([unique(value,'last'),app.SpecifyPassbandFrequencyEditField.Value]);
    addrow = [app.FiltFreqTable.Data;newrow];
    app.FiltFreqTable.Data = unique(addrow,'rows');
    unique(app.FiltFreqTable.Data(:,1));
    app.FiltFreqTable.ColumnSortable = true;
        
else
    app.FilteredData(:,value) = app.FilteredData(:,value);
end

%DataFilterListBoxValueChanged(app);
end
