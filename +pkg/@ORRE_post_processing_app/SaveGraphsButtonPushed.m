function SaveGraphsButtonPushed(app, event)

app.GraphFileTypeDropDown.ItemsData = 1:numel(app.GraphFileTypeDropDown.Items);
GraphFileChoice = app.GraphFileTypeDropDown.Value;

if GraphFileChoice == 1
    gsuffix = '.png';
end
if GraphFileChoice == 2
    gsuffix = '.jpg';
end
if GraphFileChoice == 3
    gsuffix = '.pdf';
end
if GraphFileChoice == 4
    gsuffix = '.tif';
end

if app.FilterDataTimeHistoryCheckBox.Value
    graphfilename = strcat('FilterData_TimeHistory',gsuffix);
    exportgraphics(app.FilterAxes,graphfilename);
end
if app.TimeHistoryCheckBox.Value
    graphfilename = strcat('TimeHistory',gsuffix);
    exportgraphics(app.TimeHistoryAxes,graphfilename);
end
% if app.FourierTransformsCheckBox.Value
%     graphfilename = strcat('FourierTransform',gsuffix);
%     exportgraphics(    ,graphfilename);
% end
% if app.LaplaceTransformsCheckBox.Value
%     graphfilename = strcat('LaplaceTransform',gsuffix);
%     exportgraphics(,graphfilename);
% end
% if app.WaveletTransformsCheckBox.Value
%     graphfilename = strcat('WaveletTransform',gsuffix);
%     exportgraphics(,graphfilename);
% end
end