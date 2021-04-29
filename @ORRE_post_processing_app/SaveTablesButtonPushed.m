function SaveTablesButtonPushed(app, event)

app.TableFileTypeDropDown.ItemsData = 1:numel(app.TableFileTypeDropDown.Items);
TableFileChoice = app.TableFileTypeDropDown.Value;

if TableFileChoice == 1
    suffix = '.txt';
end
if TableFileChoice == 2
    suffix = '.csv';
end
if TableFileChoice == 3
    suffix = '.dat';
end
if TableFileChoice == 4
    suffix = '.xls';
end

if app.SaveDataChkBox.Value
    datafilename = strcat('Upload_Data_Table',suffix);
    writetable(app.UploadDataTable.Data,datafilename);      
end
if app.SaveLegendChkBox.Value
    legendfilename = strcat('Legend',suffix);
    writetable(app.DataLegendTable.Data,legendfilename);        
end
% if app.SaveSettingsChkBox.Value
%     settingsfilename = strcat('Data_Specification_Settings',suffix);
%     writetable(app. .Data,settingsfilename);        
% end
if app.SaveStatsChkBox.Value
    statsfilename = strcat('Data_Statistics',suffix);
    writecell(app.StatsTable.Data,statsfilename);        
end
if app.SaveFrequenciesChkBox.Value
    frequenciesfilename = strcat('Chosen_Passband_Frequencies',suffix);
    writetable(app.FiltFreqTable.Data,frequenciesfilename);        
end
end







