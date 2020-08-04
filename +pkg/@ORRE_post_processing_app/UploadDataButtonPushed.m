function UploadDataButtonPushed(app, event)
[filename,data_dir] = uigetfile('*.txt','Select the 0 deg FD file');
datatype = 1;
% 0 - test data
% 1 - user-defined (dataClass)
% 2 - signal (signalClass)
% (keep hard coded as 1 for now)

%%%%%% Data Settings Drop Down %%%%%%%
%%%%%% Tag Lines %%%%%%%
if(strcmp(app.TagLinesDropDown.Value,'Default (1)'))
    %ntaglines = pkg.fun.read_data.default_ntaglines;
    ntaglines = 1;
elseif(strcmp(app.TagLinesDropDown.Value,'2'))
    ntaglines = 2;
elseif(strcmp(app.TagLinesDropDown.Value,'3'))
    ntaglines = 3;
elseif(strcmp(app.TagLinesDropDown.Value,'4'))
    ntaglines = 4;
elseif(strcmp(app.TagLinesDropDown.Value,'5'))
    ntaglines = 5;
end

%%%%%% Header Lines %%%%%%%
if(strcmp(app.HeaderLinesDropDown.Value,'Default (1)'))
    nheaderlines = 1;
elseif(strcmp(app.HeaderLinesDropDown.Value,'2'))
    nheaderlines = 2;
elseif(strcmp(app.HeaderLinesDropDown.Value,'3'))
    nheaderlines = 3;
elseif(strcmp(app.HeaderLinesDropDown.Value,'4'))
    nheaderlines = 4;
elseif(strcmp(app.HeaderLinesDropDown.Value,'5'))
    nheaderlines = 5;
end

%%%%% Tag Format %%%%%%%
if(strcmp(app.TagFormatDropDown.Value,'Default (String)'))
    tagformat = '%s';
elseif(strcmp(app.TagFormatDropDown.Value,'Float'))
    tagformat = '%f';
elseif(strcmp(app.TagFormatDropDown.Value,'Integer'))
    tagformat = '%int64';
end

%%%%% Header Format %%%%%%%
if(strcmp(app.HeaderFormatDropDown.Value,'Default (String)'))
    headerformat = '%s';
elseif(strcmp(app.HeaderFormatDropDown.Value,'Float'))
    headerformat = '%f';
elseif(strcmp(app.HeaderFormatDropDown.Value,'Integer'))
    headerformat = '%int64';
end

%%%%% Data Format %%%%%%%
if(strcmp(app.DataFormatDropDown.Value,'Default (Float)'))
    dataformat = '%f';
elseif(strcmp(app.DataFormatDropDown.Value,'String'))
    dataformat = '%s';
elseif(strcmp(app.DataFormatDropDown.Value,'Integer'))
    dataformat = '%int64';
end

%%%%% Comment Style %%%%%%%
if(strcmp(app.CommentStyleDropDown.Value,'Default (%)'))
    commentstyle = '%';
elseif(strcmp(app.CommentStyleDropDown.Value,'#'))
    commentstyle = '#';
end
%%%%%% End Data Settings Drop Down %%%%%%%

app.Wavedata = pkg.fun.read_data(data_dir,filename,datatype,ntaglines,nheaderlines,tagformat,headerformat,dataformat,commentstyle);

%%% this needs to be fixed
wavedata = app.Wavedata;
app.Headers = wavedata.headers;
%%%

for ch = 1:length(wavedata.headers)
    combined_data(:,ch) = wavedata.(strcat('ch',num2str(ch)));
end
app.Combined_Channels = combined_data;
%app.UITable.Data = array2table(app.Combined_Channels);
app.UploadDataTable.Data = array2table(combined_data);
app.TagInformation.Value = wavedata.tags;

app.DataFilterListBox.Items = app.Wavedata.headers;

app.UploadDataTable.ColumnName = wavedata.headers;
app.SelectDatatoAnalyzeListBox.Items = app.Wavedata.headers;
app.DataLegendTable.Data = wavedata.map_legend;

%app.Filtered_Channels = app.Combined_Channels;
app.SelectIndependentVariableTimeListBox.Items = app.Wavedata.headers;
app.SelectDependentVariableListBox.Items = app.Wavedata.headers;

app.SelectIndependentVariableTimeListBox_2.Items = app.Wavedata.headers;
app.SelectDependentVariableListBox_2.Items = app.Wavedata.headers;

headerlength = length(app.Wavedata.headers);
columnlength = length(app.Wavedata.ch1);

app.FilteredData = zeros(columnlength,headerlength);

%%%%%% DELETE %%%%%%
%%%%%% fixes dataset specific time issue %%%%%%
app.Wavedata.ch1 = sqrt(app.Wavedata.ch1);
%%%%%% DELETE %%%%%%
end

