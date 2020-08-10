function DataFilterListBoxValueChanged(app, event)

app.OverwriteCheckBox.Value = 0;
app.OverwriteCheckBox.Enable = 'off';
app.NoneButton.Value = 1;
app.LowPassButton.Value = 0;
app.HighPassButton.Value = 0;

app.DataFilterListBox.ItemsData = 1:numel(app.DataFilterListBox.Items);
value = app.DataFilterListBox.Value;

FilteringOptionsButtonGroupSelectionChanged(app);
OverwriteCheckBoxValueChanged(app);
%
%             if app.OverwriteCheckBox.Value
%                 a = app.Wavedata.(strcat('ch',(num2str(value))));
%             else
%                 a = app.FilteredData(:,value);
%             end
%plot(app.FilterAxes,app.Wavedata.(strcat('ch',(num2str(app.TimeFilterEditField.Value)))),app.FilteredData(:,value));
end

