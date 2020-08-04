function OverwriteCheckBoxValueChanged(app,event)
value = app.DataFilterListBox.Value;

%%% this is a work in progress, frequency values don't sort yet %%%

if app.OverwriteCheckBox.Value
    %app.filtplot = app.Wavedata.(strcat('ch',(num2str(value))));
    app.Wavedata.(strcat('ch',(num2str(value)))) = app.FilteredData(:,value);
    
    newrow = [value,app.SpecifyPassbandFrequencyEditField.Value];
    %app.FiltFreqTable.Data = [app.FiltFreqTable.Data;unique(newrow)];
    app.FiltFreqTable.Data = [app.FiltFreqTable.Data;newrow];     
    
    %sort(app.FiltFreqTable.Data(1,:));
    
else
    app.FilteredData(:,value) = app.FilteredData(:,value);
end
sort(app.FiltFreqTable.Data);
%DataFilterListBoxValueChanged(app);
end
