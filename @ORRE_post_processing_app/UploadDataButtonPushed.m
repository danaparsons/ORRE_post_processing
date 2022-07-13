function UploadDataButtonPushed(app, event)
[filename,data_dir] = uigetfile('*.txt','Select the 0 deg FD file');
datatype = 1;
% 1 - Delimited text file (.csv,.txt)
% 2 - Hierarchical Data Format v5 (HDF5)
% (keep hard coded as 1 for now)

%%%%%% Data Settings Drop Down %%%%%%%
%%%%%% Tag Lines %%%%%%%
if app.TagLinesSpinner.Value >= 0
    ntaglines = app.TagLinesSpinner.Value;
else
    error('The number of tag line rows cannot be a negative value.')  
end

%%%%%% Header Lines %%%%%%%
if app.HeaderLinesSpinner.Value >= 0
    nheaderlines = app.HeaderLinesSpinner.Value;
else
    error('The number of header line rows cannot be a negative value.')  
end

%%%%% Tag Format %%%%%%%
if(strcmp(app.TagFormatDropDown.Value,'Default (String)'))
    tagformat = '~'; % (accept default value defined in read_data.m)
elseif(strcmp(app.TagFormatDropDown.Value,'Float'))
    tagformat = '%f';
elseif(strcmp(app.TagFormatDropDown.Value,'Integer'))
    tagformat = '%int64';
end

%%%%% Header Format %%%%%%%
if(strcmp(app.HeaderFormatDropDown.Value,'Default (String)'))
    headerformat = '~'; % (accept default value defined in read_data.m)
elseif(strcmp(app.HeaderFormatDropDown.Value,'Float'))
    headerformat = '%f';
elseif(strcmp(app.HeaderFormatDropDown.Value,'Integer'))
    headerformat = '%int64';
end

%%%%% Data Format %%%%%%%
if(strcmp(app.DataFormatDropDown.Value,'Default (Float)'))
    dataformat = '~'; % (accept default value defined in read_data.m)
elseif(strcmp(app.DataFormatDropDown.Value,'String'))
    dataformat = '%s';
elseif(strcmp(app.DataFormatDropDown.Value,'Integer'))
    dataformat = '%int64';
end

%%%%%% Data Delmiiter %%%%%%%
if isempty(app.DelimiterEditField.Value)
 	datadelimiter = '~'; % (accept default value defined in read_data.m)
else
    datadelimiter = app.DelimiterEditField.Value;
end

%%%%%% Header Delmiiter %%%%%%%
%TODO: update this; This needs to become an input and have GUI entry
headerdelimiter = datadelimiter; % For now, set it to the data delimiter.

%%%%% Comment Style %%%%%%%
if(strcmp(app.CommentStyleDropDown.Value,'Default (%)'))
    commentstyle = '~'; % (accept default value defined in read_data.m)
elseif(strcmp(app.CommentStyleDropDown.Value,'#'))
    commentstyle = '#';
end
%%%%%% End Data Settings Drop Down %%%%%%%

app.Wavedata = pkg.fun.read_data(data_dir,filename,datatype,ntaglines,...
    nheaderlines,tagformat,headerformat,dataformat,headerdelimiter,datadelimiter,commentstyle);

%     if varargin{1} == '~'; varargin{1} = default_ntaglines;         end
%     if varargin{2} == '~'; varargin{2} = default_nheaderlines;      end
%     if varargin{3} == '~'; varargin{3} = default_tagformat;         end
%     if varargin{4} == '~'; varargin{4} = default_headerformat;      end
%     if varargin{5} == '~'; varargin{5} = default_dataformat;        end
%     if varargin{6} == '~'; varargin{6} = default_headerdelimiter;   end
%     if varargin{6} == '~'; varargin{6} = default_datadelimiter;     end
%     if varargin{7} == '~'; varargin{7} = default_commentstyle;      end


wavedata = app.Wavedata;
app.Headers = wavedata.headers;

for ch = 1:length(wavedata.headers)
    combined_data(:,ch) = wavedata.(strcat('ch',num2str(ch)));
end
app.Combined_Channels = combined_data;
app.UploadDataTable.Data = array2table(combined_data);
app.TagInformation.Value = wavedata.tags;

app.DataFilterListBox.Items = app.Wavedata.headers;

app.DataOperationChannelDropDown.Items = app.Wavedata.headers;

app.UploadDataTable.ColumnName = wavedata.headers;
app.SelectDatatoAnalyzeListBox.Items = app.Wavedata.headers;
app.DataLegendTable.Data = wavedata.map_legend;

% FFT 
app.SelectIndependentVariableTimeListBox.Items = app.Wavedata.headers;
% Use 1 as default:
DefaultIVTLBV = 1;
app.SelectIndependentVariableTimeListBox.Value = app.SelectIndependentVariableTimeListBox.Items{DefaultIVTLBV};

app.SelectDependentVariableListBox.Items = app.Wavedata.headers;
% Use 2 as default:
DefaultDVTLBV = 2;
app.SelectDependentVariableListBox.Value = app.SelectIndependentVariableTimeListBox.Items{DefaultDVTLBV};


% app.SelectIndependentVariableTimeListBox_2.Items = app.Wavedata.headers;
% app.SelectDependentVariableListBox_2.Items = app.Wavedata.headers;

app.WaveletSelectIndependentVariableTimeListBox.Items = app.Wavedata.headers;
app.WaveletSelectDependentVariableListBox.Items = app.Wavedata.headers;

app.FilterTimeDropDown.Items = app.Wavedata.headers;
app.TimeHistTimeDropDown.Items = app.Wavedata.headers;

headerlength = length(app.Wavedata.headers);
columnlength = length(app.Wavedata.ch1);

app.FilteredData = zeros(columnlength,headerlength);

% Update default FFT start and end times
Time = app.Wavedata.(strcat('ch',num2str(DefaultIVTLBV)));
app.StartTimeEditField.Value = Time(1);
app.EndTimeEditField.Value = Time(end);
end

