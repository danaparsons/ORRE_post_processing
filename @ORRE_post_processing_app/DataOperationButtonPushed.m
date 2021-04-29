function DataOperationButtonPushed(app, event)

operation_input = app.DataOperationField.Value;

% Error handling:
if ~contains(operation_input,'x')
    error('The operation must be a function of the variable x.')
end

if contains(operation_input,'@(x)') == 1
    input_fun = str2func(operation_input);
else
    input_fun = str2func(['@(x)',operation_input]);
end
ch_idx = find(strcmp(app.DataOperationChannelDropDown.Value,app.Wavedata.headers));
app.Wavedata.(['ch',num2str(ch_idx)]) = arrayfun(input_fun,app.Wavedata.(['ch',num2str(ch_idx)]));

app.Combined_Channels(:,ch_idx) = app.Wavedata.(['ch',num2str(ch_idx)]);
app.UploadDataTable.Data{:,ch_idx} = app.Combined_Channels(:,ch_idx);

end
