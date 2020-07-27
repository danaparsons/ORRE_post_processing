%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Header %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename:     ORRE_post_processing_app.m    
% Description:  ORRE Post Processing App.
% Authors:      D. Lukas and J. Davis
% Created on:   6-10-20
% Last updated: 7-15-20 by D. Lukas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Notes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This app is designed to compute and display many different analyses,
% depending on user needs. Desired results are obtained by running the 
% app and interacting with various buttons, drop down selections, 
% checkboxes, and tabs.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef ORRE_post_processing_app < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                                            matlab.ui.Figure
        TabGroup                                            matlab.ui.container.TabGroup
        
        WelcomeTab                                          matlab.ui.container.Tab
        TextArea                                            matlab.ui.control.TextArea
        Image                                               matlab.ui.control.Image
        WelcomeLabel                                        matlab.ui.control.Label
        ImportantNotesLabel                                 matlab.ui.control.Label
        UpdatingThisAppLabel                                matlab.ui.control.Label
        
        UploadDataTab                                       matlab.ui.container.Tab
        UploadDataButton                                    matlab.ui.control.Button
        UITable                                             matlab.ui.control.Table
        LegendPanel                                         matlab.ui.container.Panel
        UITable3                                            matlab.ui.control.Table
        DataSettingsPanel                                   matlab.ui.container.Panel
        TagLinesDropDownLabel                               matlab.ui.control.Label
        TagLinesDropDown                                    matlab.ui.control.DropDown
        HeaderLinesDropDownLabel                            matlab.ui.control.Label
        HeaderLinesDropDown                                 matlab.ui.control.DropDown
        TagFormatDropDownLabel                              matlab.ui.control.Label
        TagFormatDropDown                                   matlab.ui.control.DropDown
        HeaderFormatDropDownLabel                           matlab.ui.control.Label
        HeaderFormatDropDown                                matlab.ui.control.DropDown
        DataFormatDropDownLabel                             matlab.ui.control.Label
        DataFormatDropDown                                  matlab.ui.control.DropDown
        CommentStyleDropDownLabel                           matlab.ui.control.Label
        CommentStyleDropDown                                matlab.ui.control.DropDown
        
        TimeHistoryStatsTab                                 matlab.ui.container.Tab
        UIAxes                                              matlab.ui.control.UIAxes
        UITable2                                            matlab.ui.control.Table
        Panel_2                                             matlab.ui.container.Panel
        SelectDatatoAnalyzeListBox                          matlab.ui.control.ListBox
        CheckBox10                                          matlab.ui.control.CheckBox
        FilterDataButtonGroup                               matlab.ui.container.ButtonGroup
        LowPassButton                                       matlab.ui.control.RadioButton
        HighPassButton                                      matlab.ui.control.RadioButton
        NoneButton                                          matlab.ui.control.RadioButton
        SpecifyNormalizedPassbandFrequencyEditField         matlab.ui.control.NumericEditField
        SpecifyNormalizedPassbandFrequencyEditFieldLabel    matlab.ui.control.Label
        SelectDatatoAnalyzeLabel                            matlab.ui.control.Label
        EnterNumericTimeChannelEditFieldLabel               matlab.ui.control.Label
        EnterNumericTimeChannelEditField                    matlab.ui.control.NumericEditField
  
        FourierTransformTab                                 matlab.ui.container.Tab
        Panel                                               matlab.ui.container.Panel
        TextArea_2                                          matlab.ui.control.TextArea
        SelectTimeEditFieldLabel                            matlab.ui.control.Label
        SelectTimeEditField                                 matlab.ui.control.NumericEditField
        SelectDependentVarEditFieldLabel                    matlab.ui.control.Label
        SelectDependentVarEditField                         matlab.ui.control.NumericEditField
        OptionalSpecificationsPanel                         matlab.ui.container.Panel
        FrequencyCheckBox                                   matlab.ui.control.CheckBox
        DesiredSampleFrequencyEditField                     matlab.ui.control.NumericEditField
        FFTButton                                           matlab.ui.control.Button
        
        LaplaceTransformTab                                 matlab.ui.container.Tab
        
        WaveletTransformTab                                 matlab.ui.container.Tab
        
        CreateReportTab                                     matlab.ui.container.Tab
    end
    
    properties (Access = public)
        Wavedata     %holds user chosen data set
        FFTvalue     %holds channel to plot in Fourier Transform
        Timevalue    %holds channel to use as time for FFT
        Headers      %headers of wavedata data set
        filtered_one %these 9 properties hold the filtered data channels
        filtered_two
        filtered_three
        filtered_four
        filtered_five
        filtered_six
        filtered_seven
        filtered_eight
        filtered_nine
        SelectedFrequency %holds frequency selection for FFT button
    end

    methods (Access = private)

%%%%%%%%%%%%%%%%%%%%%%%%%% UPLOAD DATA BUTTON %%%%%%%%%%%%%%%%%%%%%%%%%%%
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

            %%%%%% Tag Format %%%%%%%
        %             if(strcmp(app.TagFormatDropDown.Value,'Default (String)'))
        %                 tagformat = "%s";
        %             elseif(strcmp(app.TagFormatDropDown.Value,'Float'))
        %                 tagformat = '%f';
        %             elseif(strcmp(app.TagFormatDropDown.Value,'Integer'))
        %                 tagformat = '%int64';
        %             end

            %%%%%% Header Format %%%%%%%
        %             if(strcmp(app.HeaderFormatDropDown.Value,'Default (String)'))
        %                 headerformat = '%s';
        %             elseif(strcmp(app.HeaderFormatDropDown.Value,'Float'))
        %                 headerformat = '%f';
        %             elseif(strcmp(app.HeaderFormatDropDown.Value,'Integer'))
        %                 headerformat = '%int64';
        %             end

            %%%%%% Data Format %%%%%%%
        %             if(strcmp(app.DataFormatDropDown.Value,'Default (Float)'))
        %                 dataformat = '%f';
        %             elseif(strcmp(app.DataFormatDropDown.Value,'String'))
        %                 dataformat = '%s';
        %             elseif(strcmp(app.DataFormatDropDown.Value,'Integer'))
        %                 dataformat = '%int64';
        %             end

            %%%%%% Comment Style %%%%%%%
        %             if(strcmp(app.CommentStyleDropDown.Value,'Default (%)'))
        %                 commentstyle = '%';
        %             elseif(strcmp(app.CommentStyleDropDown.Value,'#'))
        %                 commentstyle = '#';
        %             end

           % wavedata = pkg.fun.read_data(data_dir,filename,datatype,ntaglines,nheaderlines,tagformat,headerformat,dataformat,commentstyle);
            app.Wavedata = pkg.fun.read_data(data_dir,filename,datatype,ntaglines,nheaderlines);
            wavedata = app.Wavedata;
            app.Headers = wavedata.headers;
            app.UITable.Data = table(wavedata.ch1,wavedata.ch2,wavedata.ch3,wavedata.ch4,wavedata.ch5,wavedata.ch6,wavedata.ch7,wavedata.ch8,wavedata.ch9);
            app.UITable.ColumnName = wavedata.headers;
            app.SelectDatatoAnalyzeListBox.Items = app.Wavedata.headers;
            app.UITable3.Data = wavedata.map_legend;

            %%%%%% Need to select channels as a whole %%%%%%
            %%%%%% so that more or less than 9 channels can be used %%

            app.filtered_one = app.Wavedata.ch1;
            app.filtered_two = app.Wavedata.ch2;
            app.filtered_three = app.Wavedata.ch3;
            app.filtered_four = app.Wavedata.ch4;
            app.filtered_five = app.Wavedata.ch5;
            app.filtered_six = app.Wavedata.ch6;
            app.filtered_seven = app.Wavedata.ch7;
            app.filtered_eight = app.Wavedata.ch8;
            app.filtered_nine = app.Wavedata.ch9;
            
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%% STARTUP FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function startupFcn(app)
            app.DesiredSampleFrequencyEditField.Editable = 'off';
            app.NoneButton.Value = true;
            app.SelectDatatoAnalyzeListBox.ItemsData = 1:numel(app.SelectDatatoAnalyzeListBox.Items);
            app.SelectDatatoAnalyzeListBox.Value = [];
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%% FILTER BUTTONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
        function FilterButtonGroupSelectionChanged(app, event)
        wpass = app.SpecifyNormalizedPassbandFrequencyEditField.Value;
            %%% must be # between 0 and 1, create an error statement if 
            %%% input is out of this normalized range

            if app.NoneButton.Value == 1
                app.filtered_one = app.Wavedata.ch1;
                app.filtered_two = app.Wavedata.ch2;
                app.filtered_three = app.Wavedata.ch3;
                app.filtered_four = app.Wavedata.ch4;
                app.filtered_five = app.Wavedata.ch5;
                app.filtered_six = app.Wavedata.ch6;
                app.filtered_seven = app.Wavedata.ch7;
                app.filtered_eight = app.Wavedata.ch8;
                app.filtered_nine = app.Wavedata.ch9;
            end
            if app.LowPassButton.Value == 1
                app.filtered_one = lowpass(app.Wavedata.ch1,wpass);
                app.filtered_two = lowpass(app.Wavedata.ch2,wpass);
                app.filtered_three = lowpass(app.Wavedata.ch3,wpass);
                app.filtered_four = lowpass(app.Wavedata.ch4,wpass);
                app.filtered_five = lowpass(app.Wavedata.ch5,wpass);
                app.filtered_six = lowpass(app.Wavedata.ch6,wpass);
                app.filtered_seven = lowpass(app.Wavedata.ch7,wpass);
                app.filtered_eight = lowpass(app.Wavedata.ch8,wpass);
                app.filtered_nine = lowpass(app.Wavedata.ch9,wpass);
                
                %%%% need a way to select all channels so diff # of them
                %%%% can be used
            end
            if app.HighPassButton.Value == 1
                %app.Wavedata(:,5:end) = highpass(app.Wavedata(:,5:end));
                app.filtered_one = highpass(app.Wavedata.ch1,wpass);
                app.filtered_two = highpass(app.Wavedata.ch2,wpass);
                app.filtered_three = highpass(app.Wavedata.ch3,wpass);
                app.filtered_four = highpass(app.Wavedata.ch4,wpass);
                app.filtered_five = highpass(app.Wavedata.ch5,wpass);
                app.filtered_six = highpass(app.Wavedata.ch6,wpass);
                app.filtered_seven = highpass(app.Wavedata.ch7,wpass);
                app.filtered_eight = highpass(app.Wavedata.ch8,wpass);
                app.filtered_nine = highpass(app.Wavedata.ch9,wpass);
            end
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CLEAR BUTTON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        function CheckBox10ValueChanged(app, event)
            if app.CheckBox10.Value
                cla(app.UIAxes)
                app.UITable2.Data = [];
                app.SelectDatatoAnalyzeListBox.Value = [];
                app.CheckBox10.Value = false;
            end
        end
        
%%%%%%%%%%%%%%%%%%%%%% SelectDatatoAnalyze LISTBOX %%%%%%%%%%%%%%%%%%%%%%%%
        function SDtAListBoxValueChanged (app, event)
            app.UITable2.Data = [];
            cla(app.UIAxes);
            hold(app.UIAxes);
            app.SelectDatatoAnalyzeListBox.Multiselect = 'on';
            app.SelectDatatoAnalyzeListBox.ItemsData = 1:numel(app.SelectDatatoAnalyzeListBox.Items);
            %app.SelectDatatoAnalyzeListBox.ItemsData = [app.Wavedata.ch1,app.Wavedata.ch2,app.Wavedata.ch3,app.Wavedata.ch4,app.Wavedata.ch5,app.Wavedata.ch6,app.Wavedata.ch7,app.Wavedata.ch8,app.Wavedata.ch9];
            value = app.SelectDatatoAnalyzeListBox.Value;
            number_selections = length(app.SelectDatatoAnalyzeListBox.ItemsData);
            
            if value == 1
                plot(app.UIAxes,app.filtered_one,app.filtered_one,'b');
                ch1_Analysis = [1,"Blue",mean(app.Wavedata.ch1), min(app.Wavedata.ch1),max(app.Wavedata.ch1),std(app.Wavedata.ch1)];
                row = [app.UITable2.Data;ch1_Analysis];
                app.UITable2.Data = unique(row,'rows');
            end
            hold(app.UIAxes);
            if value == 2
                plot(app.UIAxes,app.filtered_one,app.filtered_two,'r');
                ch2_Analysis = [2,"Red",mean(app.Wavedata.ch2), min(app.Wavedata.ch2),max(app.Wavedata.ch2),std(app.Wavedata.ch2)];
                row = [app.UITable2.Data;ch2_Analysis];
                app.UITable2.Data = unique(row,'rows');
            end
            if value == 3
                plot(app.UIAxes,app.filtered_one,app.filtered_three,'g');
                ch3_Analysis = [3,"Green",mean(app.Wavedata.ch3), min(app.Wavedata.ch3),max(app.Wavedata.ch3),std(app.Wavedata.ch3)];
                row = [app.UITable2.Data;ch3_Analysis];
                app.UITable2.Data = unique(row,'rows');
            end
            if value == 4
                plot(app.UIAxes,app.filtered_one,app.filtered_four,'k');
                ch4_Analysis = [4,"Black",mean(app.Wavedata.ch4), min(app.Wavedata.ch4),max(app.Wavedata.ch4),std(app.Wavedata.ch4)];
                row = [app.UITable2.Data;ch4_Analysis];
                app.UITable2.Data = unique(row,'rows');
            end
            if value == 5
                plot(app.UIAxes,app.filtered_one,app.filtered_five,'m');
                ch5_Analysis = [5,"Pink",mean(app.Wavedata.ch5), min(app.Wavedata.ch5),max(app.Wavedata.ch5),std(app.Wavedata.ch5)];
                row = [app.UITable2.Data;ch5_Analysis];
                app.UITable2.Data = unique(row,'rows');
            end
            if value == 6
                plot(app.UIAxes,app.filtered_one,app.filtered_six,'c');
                ch6_Analysis = [6,"Cyan",mean(app.Wavedata.ch6), min(app.Wavedata.ch6),max(app.Wavedata.ch6),std(app.Wavedata.ch6)];
                row = [app.UITable2.Data;ch6_Analysis];
                app.UITable2.Data = unique(row,'rows');
            end
            if value == 7
                plot(app.UIAxes,app.filtered_one,app.filtered_seven,'color',[0.4940, 0.1840, 0.5560]);
                ch7_Analysis = [7,"Purple",mean(app.Wavedata.ch7), min(app.Wavedata.ch7),max(app.Wavedata.ch7),std(app.Wavedata.ch7)];
                row = [app.UITable2.Data;ch7_Analysis];
                app.UITable2.Data = unique(row,'rows');
            end
            if value == 8
                plot(app.UIAxes,app.filtered_one,app.filtered_eight,'color',[0.8500, 0.3250, 0.0980]);
                ch8_Analysis = [8,"Orange",mean(app.Wavedata.ch8), min(app.Wavedata.ch8),max(app.Wavedata.ch8),std(app.Wavedata.ch8)];
                row = [app.UITable2.Data;ch8_Analysis];
                app.UITable2.Data = unique(row,'rows');
            end
            if value == 9
                plot(app.UIAxes,app.filtered_one,app.filtered_nine,'color',[0, 0.5, 0]);
                ch9_Analysis = [9,"Dark Green",mean(app.Wavedata.ch9), min(app.Wavedata.ch9),max(app.Wavedata.ch9),std(app.Wavedata.ch9)];
                row = [app.UITable2.Data;ch9_Analysis];
                app.UITable2.Data = unique(row,'rows');
            end
            %%% needs to be fixed, 9 channels hard coded instead of %%%%%%
            %%% selecting all channels                              %%%%%%
            
%             for w = 1:number_selections
%                 plot(app.UIAxes,app.filtered_one,w);
%             end
        end        

%%%%%%%%%%%%%%%%%%%%%%%%% FFT Frequency Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function FrequencyCheckBoxValueChanged(app, event)
            value = app.FrequencyCheckBox.Value;
            if app.FrequencyCheckBox.Value
                app.DesiredSampleFrequencyEditField.Editable = 'on';
            else
                app.DesiredSampleFrequencyEditField.Editable = 'off';
            end
        end

%%%%%%%%%%%%%%%%%%%%%%%%%% FOURIER TRANSFORM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
        function FFTButtonPushed(app, event)

            app.FFTvalue = app.SelectDependentVarEditField.Value;
            app.Timevalue = app.SelectTimeEditField.Value;
            
            if app.FrequencyCheckBox.Value == 1
                %fs = app.DesiredSampleFrequencyEditField.Value;
                pkg.fun.plt_fft(app.Timevalue,app.FFTvalue,app.Wavedata,app.SelectedFrequency);
            end
            if app.FrequencyCheckBox.Value == 0
                %app.DesiredSampleFrequencyEditField.Editable = 'off';
                pkg.fun.plt_fft(app.Timevalue,app.FFTvalue,app.Wavedata);
            end 
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 640 480];

            % Create WelcomeTab
            app.WelcomeTab = uitab(app.TabGroup);
            app.WelcomeTab.Title = 'Welcome';
            app.WelcomeTab.BackgroundColor = [0.651 0.8353 0.9294];

            % Create TextArea
            app.TextArea = uitextarea(app.WelcomeTab);
            app.TextArea.Position = [12 10 616 437];
             app.TextArea.Value = {''; ''; ''; ''; '- Start with the "Upload Data" tab to choose a data set from your computer that you''d like to analyze. From there, create tables, plots, and more by interacting with the other tabs.'; ''; ''; ''; ''; '-'; ''; ''; ''; '- **instructions here about where to add a new function, tab, etc. as the app evolves over time**'; ''; ''; ''; ''; ''; ''; ''; ''; ''; ''; ''; ''; ''; ''; '- J. Davis and D. Lukas '};
            
             % Create Image
            app.Image = uiimage(app.WelcomeTab);
            app.Image.Position = [358 342 261 153];
            app.Image.ImageSource = 'ORRE.png';
            
            % Create WelcomeLabel
            app.WelcomeLabel = uilabel(app.WelcomeTab);
            app.WelcomeLabel.FontSize = 15;
            app.WelcomeLabel.FontWeight = 'bold';
            app.WelcomeLabel.FontColor = [0.0392 0.5216 0.7412];
            app.WelcomeLabel.Position = [17 407 75 22];
            app.WelcomeLabel.Text = 'Welcome!';
            
             % Create ImportantNotesLabel
            app.ImportantNotesLabel = uilabel(app.WelcomeTab);
            app.ImportantNotesLabel.FontSize = 15;
            app.ImportantNotesLabel.FontWeight = 'bold';
            app.ImportantNotesLabel.FontColor = [0.0392 0.5216 0.7412];
            app.ImportantNotesLabel.Position = [16 321 126 22];
            app.ImportantNotesLabel.Text = 'Important Notes:';
            
             % Create UpdatingThisAppLabel
            app.UpdatingThisAppLabel = uilabel(app.WelcomeTab);
            app.UpdatingThisAppLabel.FontSize = 15;
            app.UpdatingThisAppLabel.FontWeight = 'bold';
            app.UpdatingThisAppLabel.FontColor = [0.0392 0.5216 0.7412];
            app.UpdatingThisAppLabel.Position = [16 253 142 22];
            app.UpdatingThisAppLabel.Text = 'Updating This App:';
            
            % Create UploadDataTab
            app.UploadDataTab = uitab(app.TabGroup);
            app.UploadDataTab.Title = 'Upload Data';
            app.UploadDataTab.BackgroundColor = [0.651 0.8353 0.9294];

            % Create UploadDataButton
            app.UploadDataButton = uibutton(app.UploadDataTab, 'push');
            app.UploadDataButton.ButtonPushedFcn = createCallbackFcn(app, @UploadDataButtonPushed, true);
            app.UploadDataButton.BackgroundColor = [0.8 0.8 0.8];
            app.UploadDataButton.FontWeight = 'bold';
            app.UploadDataButton.Position = [248 327 86 36];
            app.UploadDataButton.Text = {'Click to';'Upload Data'};

            % Create UITable
            app.UITable = uitable(app.UploadDataTab);
            app.UITable.ColumnName = {''; ''; ''; ''; ''; ''; ''; ''; ''};
            app.UITable.RowName = {};
            app.UITable.Position = [12 9 616 218];
    
            % Create DataSettingsPanel
            app.DataSettingsPanel = uipanel(app.UploadDataTab);
            app.DataSettingsPanel.TitlePosition = 'centertop';
            app.DataSettingsPanel.Title = 'Edit Data Settings';
            app.DataSettingsPanel.BackgroundColor = [0.8 0.8 0.8];
            app.DataSettingsPanel.FontWeight = 'bold';
            app.DataSettingsPanel.Position = [12 240 220 203];

            % Create TagLinesDropDownLabel
            app.TagLinesDropDownLabel = uilabel(app.DataSettingsPanel);
            app.TagLinesDropDownLabel.HorizontalAlignment = 'right';
            app.TagLinesDropDownLabel.FontWeight = 'bold';
            app.TagLinesDropDownLabel.Position = [4 155 60 22];
            app.TagLinesDropDownLabel.Text = 'Tag Lines';

            % Create TagLinesDropDown
            app.TagLinesDropDown = uidropdown(app.DataSettingsPanel);
            app.TagLinesDropDown.Items = {'Default (1)', '2', '3', '4', '5'};
            app.TagLinesDropDown.Position = [79 155 132 22];
            app.TagLinesDropDown.Value = 'Default (1)';

            % Create HeaderLinesDropDownLabel
            app.HeaderLinesDropDownLabel = uilabel(app.DataSettingsPanel);
            app.HeaderLinesDropDownLabel.HorizontalAlignment = 'right';
            app.HeaderLinesDropDownLabel.FontWeight = 'bold';
            app.HeaderLinesDropDownLabel.Position = [4 126 81 22];
            app.HeaderLinesDropDownLabel.Text = 'Header Lines';

            % Create HeaderLinesDropDown
            app.HeaderLinesDropDown = uidropdown(app.DataSettingsPanel);
            app.HeaderLinesDropDown.Items = {'Default (1)', '2', '3', '4', '5'};
            app.HeaderLinesDropDown.Position = [96 126 115 22];
            app.HeaderLinesDropDown.Value = 'Default (1)';

            % Create TagFormatDropDownLabel
            app.TagFormatDropDownLabel = uilabel(app.DataSettingsPanel);
            app.TagFormatDropDownLabel.HorizontalAlignment = 'right';
            app.TagFormatDropDownLabel.FontWeight = 'bold';
            app.TagFormatDropDownLabel.Position = [4 94 68 22];
            app.TagFormatDropDownLabel.Text = 'Tag Format';

            % Create TagFormatDropDown
            app.TagFormatDropDown = uidropdown(app.DataSettingsPanel);
            app.TagFormatDropDown.Items = {'Default (String)', 'Float', 'Integer'};
            app.TagFormatDropDown.Position = [89 94 122 22];
            app.TagFormatDropDown.Value = 'Default (String)';

            % Create HeaderFormatDropDownLabel
            app.HeaderFormatDropDownLabel = uilabel(app.DataSettingsPanel);
            app.HeaderFormatDropDownLabel.HorizontalAlignment = 'right';
            app.HeaderFormatDropDownLabel.FontWeight = 'bold';
            app.HeaderFormatDropDownLabel.Position = [4 64 91 22];
            app.HeaderFormatDropDownLabel.Text = 'Header Format';

            % Create HeaderFormatDropDown
            app.HeaderFormatDropDown = uidropdown(app.DataSettingsPanel);
            app.HeaderFormatDropDown.Items = {'Default (String)', 'Float', 'Integer'};
            app.HeaderFormatDropDown.Position = [100 64 111 22];
            app.HeaderFormatDropDown.Value = 'Default (String)';

            % Create DataFormatDropDownLabel
            app.DataFormatDropDownLabel = uilabel(app.DataSettingsPanel);
            app.DataFormatDropDownLabel.HorizontalAlignment = 'right';
            app.DataFormatDropDownLabel.FontWeight = 'bold';
            app.DataFormatDropDownLabel.Position = [4 36 76 22];
            app.DataFormatDropDownLabel.Text = 'Data Format';

            % Create DataFormatDropDown
            app.DataFormatDropDown = uidropdown(app.DataSettingsPanel);
            app.DataFormatDropDown.Items = {'Default (Float)', 'String', 'Integer'};
            app.DataFormatDropDown.Position = [95 36 116 22];
            app.DataFormatDropDown.Value = 'Default (Float)';

            % Create CommentStyleDropDownLabel
            app.CommentStyleDropDownLabel = uilabel(app.DataSettingsPanel);
            app.CommentStyleDropDownLabel.HorizontalAlignment = 'right';
            app.CommentStyleDropDownLabel.FontWeight = 'bold';
            app.CommentStyleDropDownLabel.Position = [4 7 92 22];
            app.CommentStyleDropDownLabel.Text = 'Comment Style';

            % Create CommentStyleDropDown
            app.CommentStyleDropDown = uidropdown(app.DataSettingsPanel);
            app.CommentStyleDropDown.Items = {'Default (%)', '#'};
            app.CommentStyleDropDown.Position = [111 7 100 22];
            app.CommentStyleDropDown.Value = 'Default (%)';
            
            % Create LegendPanel
            app.LegendPanel = uipanel(app.UploadDataTab);
            app.LegendPanel.TitlePosition = 'centertop';
            app.LegendPanel.Title = 'Legend';
            app.LegendPanel.BackgroundColor = [0.8 0.8 0.8];
            app.LegendPanel.FontWeight = 'bold';
            app.LegendPanel.Position = [358 240 260 203];
            
            % Create UITable3
            app.UITable3 = uitable(app.LegendPanel);
            app.UITable3.ColumnName = {};
            app.UITable3.RowName = {};
            app.UITable3.Position = [8 7 244 173];
            
            % Create TimeHistoryStatsTab
            app.TimeHistoryStatsTab = uitab(app.TabGroup);
            app.TimeHistoryStatsTab.Title = 'Time History/Stats';
            app.TimeHistoryStatsTab.BackgroundColor = [0.651 0.8353 0.9294];

            % Create UIAxes
            app.UIAxes = uiaxes(app.TimeHistoryStatsTab);
            title(app.UIAxes, 'Time History')
            xlabel(app.UIAxes, 'Time')
            ylabel(app.UIAxes, '') %what should be here
            app.UIAxes.ColorOrder = [0 0.4471 0.7412;0.851 0.3255 0.098;0.9294 0.6941 0.1255;0.4941 0.1843 0.5569;0.4667 0.6745 0.1882;0.302 0.7451 0.9333;0.6353 0.0784 0.1843];
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [39 9 560 218];           

            % Create UITable2
            app.UITable2 = uitable(app.TimeHistoryStatsTab);
            app.UITable2.ColumnName = {'Ch';'Color';'Mean'; 'Min'; 'Max'; 'Std Dev'};
            %app.UITable2.ColumnWidth = {1.5};
            app.UITable2.RowName = {};
            app.UITable2.Position = [258 306 361 141];
            
            % Create Panel_2
            app.Panel_2 = uipanel(app.TimeHistoryStatsTab);
            app.Panel_2.Position = [9 240 214 208];
            app.Panel_2.BackgroundColor = [0.8 0.8 0.8];           

            % Create SelectDatatoAnalyzeListBox
            app.SelectDatatoAnalyzeListBox = uilistbox(app.Panel_2);
            app.SelectDatatoAnalyzeListBox.Multiselect = 'on';
            app.SelectDatatoAnalyzeListBox.ValueChangedFcn = createCallbackFcn(app, @SDtAListBoxValueChanged, true);
            app.SelectDatatoAnalyzeListBox.Position = [7 37 190 99];
%             app.SelectDatatoAnalyzeListBox.Value = {'Item 1'};

            % Create SelectDatatoAnalyzeLabel
            app.SelectDatatoAnalyzeLabel = uilabel(app.Panel_2);
            app.SelectDatatoAnalyzeLabel.FontWeight = 'bold';
            app.SelectDatatoAnalyzeLabel.Position = [46 181 134 22];
            app.SelectDatatoAnalyzeLabel.Text = 'Select Data to Analyze';
            
            % Create EnterNumericTimeChannelEditFieldLabel
            app.EnterNumericTimeChannelEditFieldLabel = uilabel(app.Panel_2);
            app.EnterNumericTimeChannelEditFieldLabel.HorizontalAlignment = 'center';
            app.EnterNumericTimeChannelEditFieldLabel.Position = [25 147 103 28];
            app.EnterNumericTimeChannelEditFieldLabel.Text = {'Enter Numeric'; 'Time Channel'};

            % Create EnterNumericTimeChannelEditField
            app.EnterNumericTimeChannelEditField = uieditfield(app.Panel_2, 'numeric');
            app.EnterNumericTimeChannelEditField.Position = [134 150 54 22];
            
            % Create CheckBox10
            app.CheckBox10 = uicheckbox(app.Panel_2);
            app.CheckBox10.ValueChangedFcn = createCallbackFcn(app, @CheckBox10ValueChanged, true);
            app.CheckBox10.Text = 'CLEAR';
            app.CheckBox10.Position = [7 8 79 22];
            
            % Create FilterDataButtonGroup
            app.FilterDataButtonGroup = uibuttongroup(app.TimeHistoryStatsTab);
            app.FilterDataButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @FilterButtonGroupSelectionChanged, true);
            app.FilterDataButtonGroup.Title = 'Filter Data?';
            app.FilterDataButtonGroup.BackgroundColor = [0.8 0.8 0.8];
            app.FilterDataButtonGroup.FontWeight = 'bold';
            app.FilterDataButtonGroup.Position = [235 240 232 51];
            
            % Create NoneButton
            app.NoneButton = uiradiobutton(app.FilterDataButtonGroup);
            app.NoneButton.Text = 'None';
            app.NoneButton.Position = [4 5 51 22];
%             app.NoneButton.Value = true;
            
            % Create LowPassButton
            app.LowPassButton = uiradiobutton(app.FilterDataButtonGroup);
            app.LowPassButton.Text = 'Low-Pass';
            app.LowPassButton.Position = [63 5 76 22];
            
            % Create HighPassButton
            app.HighPassButton = uiradiobutton(app.FilterDataButtonGroup);
            app.HighPassButton.Text = 'High-Pass';
            app.HighPassButton.Position = [149 5 78 22];
            
             % Create SpecifyNormalizedPassbandFrequencyEditFieldLabel
            app.SpecifyNormalizedPassbandFrequencyEditFieldLabel = uilabel(app.TimeHistoryStatsTab);
            app.SpecifyNormalizedPassbandFrequencyEditFieldLabel.BackgroundColor = [0.8 0.8 0.8];
            app.SpecifyNormalizedPassbandFrequencyEditFieldLabel.HorizontalAlignment = 'center';
            app.SpecifyNormalizedPassbandFrequencyEditFieldLabel.FontWeight = 'bold';
            app.SpecifyNormalizedPassbandFrequencyEditFieldLabel.Position = [480 235 78 63];
            app.SpecifyNormalizedPassbandFrequencyEditFieldLabel.Text = {'Specify '; 'Normalized'; 'Passband '; 'Frequency'};

            % Create SpecifyNormalizedPassbandFrequencyEditField
            app.SpecifyNormalizedPassbandFrequencyEditField = uieditfield(app.TimeHistoryStatsTab, 'numeric');
            app.SpecifyNormalizedPassbandFrequencyEditField.BackgroundColor = [0.8 0.8 0.8];
            app.SpecifyNormalizedPassbandFrequencyEditField.Position = [565 257 53 22];
            
            % Create FourierTransformTab
            app.FourierTransformTab = uitab(app.TabGroup);
            app.FourierTransformTab.Title = 'Fourier Transform';
            app.FourierTransformTab.BackgroundColor = [0.651 0.8353 0.9294];
            
            % Create Panel
            app.Panel = uipanel(app.FourierTransformTab);
            app.Panel.Position = [153 307 333 140];
            app.Panel.BackgroundColor = [0.8 0.8 0.8];
            app.Panel.FontWeight = 'bold';
                        
            % Create SelectTimeEditFieldLabel
            app.SelectTimeEditFieldLabel = uilabel(app.Panel);
            app.SelectTimeEditFieldLabel.HorizontalAlignment = 'center';
            app.SelectTimeEditFieldLabel.Position = [26 34 110 28];
            app.SelectTimeEditFieldLabel.Text = {'Select Independent';'Variable (Time)'};

            % Create SelectTimeEditField
            app.SelectTimeEditField = uieditfield(app.Panel, 'numeric');
            app.SelectTimeEditField.Position = [31 10 100 22];

            % Create SelectDependentVarEditFieldLabel
            app.SelectDependentVarEditFieldLabel = uilabel(app.Panel);
            app.SelectDependentVarEditFieldLabel.HorizontalAlignment = 'center';
            app.SelectDependentVarEditFieldLabel.Position = [205 33 102 28];
            app.SelectDependentVarEditFieldLabel.Text = {'Select Dependent' ; 'Variable'};

            % Create SelectDependentVarEditField
            app.SelectDependentVarEditField = uieditfield(app.Panel, 'numeric');
            app.SelectDependentVarEditField.Position = [205 10 100 22];
            
            % Create TextArea_2
            app.TextArea_2 = uitextarea(app.Panel);
            app.TextArea_2.HorizontalAlignment = 'center';
            app.TextArea_2.Position = [56 69 221 60];
            app.TextArea_2.Value = {'Input channel values (numeric only) in the boxes below to compute Fourier Transform.'};
            
            % Create OptionalSpecificationsPanel
            app.OptionalSpecificationsPanel = uipanel(app.FourierTransformTab);
            app.OptionalSpecificationsPanel.TitlePosition = 'centertop';
            app.OptionalSpecificationsPanel.BackgroundColor = [0.8 0.8 0.8];
            app.OptionalSpecificationsPanel.FontWeight = 'bold';
            app.OptionalSpecificationsPanel.Title = 'Optional Specifications';
            app.OptionalSpecificationsPanel.Position = [189 155 260 143];
            
           % Create FrequencyCheckBox
            app.FrequencyCheckBox = uicheckbox(app.OptionalSpecificationsPanel);
            app.FrequencyCheckBox.ValueChangedFcn = createCallbackFcn(app, @FrequencyCheckBoxValueChanged, true);
            app.FrequencyCheckBox.Text = {'Input Sample'; 'Frequency?'};
            app.FrequencyCheckBox.Position = [7 87 93 28];

            % Create DesiredSampleFrequencyEditField
            app.DesiredSampleFrequencyEditField = uieditfield(app.OptionalSpecificationsPanel, 'numeric');
            app.DesiredSampleFrequencyEditField.Position = [146 87 100 22];
             
            % Create FFTButton
            app.FFTButton = uibutton(app.FourierTransformTab, 'push');
            app.FFTButton.ButtonPushedFcn = createCallbackFcn(app, @FFTButtonPushed, true);
            app.FFTButton.Position = [270 23 100 22];
            app.FFTButton.Text = 'Plot FFT';

            % Create LaplaceTransformTab
            app.LaplaceTransformTab = uitab(app.TabGroup);
            app.LaplaceTransformTab.Title = 'Laplace Transform';
            app.LaplaceTransformTab.BackgroundColor = [0.651 0.8353 0.9294];
            
             % Create WaveletTransformTab
            app.WaveletTransformTab = uitab(app.TabGroup);
            app.WaveletTransformTab.Title = 'Wavelet Transform';
            app.WaveletTransformTab.BackgroundColor = [0.651 0.8353 0.9294];

            % Create CreateReportTab
            app.CreateReportTab = uitab(app.TabGroup);
            app.CreateReportTab.Title = 'Create Report';
            app.CreateReportTab.BackgroundColor = [0.651 0.8353 0.9294];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ORRE_post_processing_app

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)
            
            %Execute Startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF APP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%% old functions/ code attempts %%%%%%%%%%%%%%%%%%%%%

%             app.SelectChannelforFourierTransformListBox.Items = app.Wavedata.headers;
            %app.SelectChannelforFourierTransformListBox.Value = [];
%             if app.SelectChannelforFourierTransformListBox.Value == app.SelectChannelforFourierTransformListBox.Items{1}
%                 app.FFTvalue = app.Wavedata.ch1;
%             end
%             if app.SelectChannelforFourierTransformListBox.Value == app.SelectChannelforFourierTransformListBox.Items{2}
%                 app.FFTvalue = app.Wavedata.ch2;
%             end
%             if app.SelectChannelforFourierTransformListBox.Value == app.Wavedata.headers(3)
%                 app.FFTvalue = app.Wavedata.ch3;
%             end
%             if app.SelectChannelforFourierTransformListBox.Value == app.Wavedata.headers(4)
%                 app.FFTvalue = app.Wavedata.ch4;
%             end
%             if app.SelectChannelforFourierTransformListBox.Value == app.Wavedata.headers(5)
%                 app.FFTvalue = app.Wavedata.ch5;
%             end
%             if app.SelectChannelforFourierTransformListBox.Value == app.Wavedata.headers(6)
%                 app.FFTvalue = app.Wavedata.ch6;
%             end
%             if app.SelectChannelforFourierTransformListBox.Value == app.Wavedata.headers(7)
%                 app.FFTvalue = app.Wavedata.ch7;
%             end
%             if app.SelectChannelforFourierTransformListBox.Value == app.Wavedata.headers(8)
%                 app.FFTvalue = app.Wavedata.ch8;
%             end
%             if app.SelectChannelforFourierTransformListBox.Value == app.Wavedata.headers(9)
%                 app.FFTvalue = app.Wavedata.ch9;
%             end
%             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%         function FilterDataButtonGroupSelectionChanged(app, event, handles)
%             filter_button = get(handles.FilterDataButtonGroup,'SelectedObject');
%             filter_selection = get(filter_button,'String');
%             
%             selectedButton = app.ButtonGroup.SelectedObject;
%             Button_Selection = get(selectedButton, 'String');
%             
%             switch Button_Selection
%                 case 'Low-Pass'
%                     wpass = 0.80; %this needs to be decided by user
%                     %[app.Wavedata.ch1,app.Wavedata.ch2,app.Wavedata.ch3,app.Wavedata.ch4,app.Wavedata.ch5,app.Wavedata.ch6,app.Wavedata.ch7,app.Wavedata.ch8,app.Wavedata.ch9] = [lowpass(app.Wavedata.ch1),lowpass(app.Wavedata.ch2),lowpass(app.Wavedata.ch3),lowpass(app.Wavedata.ch4),lowpass(app.Wavedata.ch5),lowpass(app.Wavedata.ch6),lowpass(app.Wavedata.ch7),lowpass(app.Wavedata.ch8),lowpass(app.Wavedata.ch9)]; 
%                     app.filtered_one = lowpass(app.Wavedata.ch1,wpass);
%                     app.filtered_two = lowpass(app.Wavedata.ch2,wpass);
%                     app.filtered_three = lowpass(app.Wavedata.ch3,wpass);
%                     app.filtered_four = lowpass(app.Wavedata.ch4,wpass);
%                     app.filtered_five = lowpass(app.Wavedata.ch5,wpass);
%                     app.filtered_six = lowpass(app.Wavedata.ch6,wpass);
%                     app.filtered_seven = lowpass(app.Wavedata.ch7,wpass);
%                     app.filtered_eight = lowpass(app.Wavedata.ch8,wpass);
%                     app.filtered_nine = lowpass(app.Wavedata.ch9,wpass);
%                     %%%% need a way to select all channels so diff # of 
%                     %%%% can be used
%                 case 'High-Pass'
%                     wpass = 0.30; %this needs to be decided by user
%                     %app.Wavedata(:,5:end) = highpass(app.Wavedata(:,5:end));
%                     app.filtered_one = highpass(app.Wavedata.ch1,wpass);
%                     app.filtered_two = highpass(app.Wavedata.ch2,wpass);
%                     app.filtered_three = highpass(app.Wavedata.ch3,wpass);
%                     app.filtered_four = highpass(app.Wavedata.ch4,wpass);
%                     app.filtered_five = highpass(app.Wavedata.ch5,wpass);
%                     app.filtered_six = highpass(app.Wavedata.ch6,wpass);
%                     app.filtered_seven = highpass(app.Wavedata.ch7,wpass);
%                     app.filtered_eight = highpass(app.Wavedata.ch8,wpass);
%                     app.filtered_nine = highpass(app.Wavedata.ch9,wpass);
%                 case 'None'
%                     app.filtered_one = app.Wavedata.ch1;
%                     app.filtered_two = app.Wavedata.ch2;
%                     app.filtered_three = app.Wavedata.ch3;
%                     app.filtered_four = app.Wavedata.ch4;
%                     app.filtered_five = app.Wavedata.ch5;
%                     app.filtered_six = app.Wavedata.ch6;
%                     app.filtered_seven = app.Wavedata.ch7;
%                     app.filtered_eight = app.Wavedata.ch8;
%                     app.filtered_nine = app.Wavedata.ch9; 
%             end
%            
% 
%         end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%         function SelectChannelforFourierTransformListBoxValueChanged(app, event, handles)
%             value = app.SelectChannelforFourierTransformListBox.Value;
%             %app.SelectChannelforFourierTransformListBox.Items = app.Headers;
%             %a = get(handles.SelectChannelforFourierTransformListBox,'Value');
%             
%             if app.handles.SelectChannelforFourierTransformListBox.Value == 1
%             %if (value == app.SelectChannelforFourierTransformListBox.Items(1))   
%                 %set(app.FFTvalue,app.Wavedata.ch1);
%                 app.FFTvalue = app.Wavedata.ch1;
%             end
%             if (value == 2)
%                 set(app.FFTvalue,app.Wavedata.ch2);
%             end
%             
%         end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%             if(strcmp(app.SelectChannelforFourierTransformListBox.Value,app.Wavedata.headers{1,1}))
%                 app.FFTvalue = 1;
%             else if (strcmp(app.SelectChannelforFourierTransformListBox.Value,app.Wavedata.headers{1,2}))
%                 app.FFTvalue = 2;
%             else if (strcmp(app.SelectChannelforFourierTransformListBox.Value,app.Wavedata.headers{1,3}))
%                 app.FFTvalue = 3;
%             else if (strcmp(app.SelectChannelforFourierTransformListBox.Value,app.Wavedata.headers{1,4}))
%                 app.FFTvalue = 4;
%             else if (strcmp(app.SelectChannelforFourierTransformListBox.Value,app.Wavedata.headers{1,5}))
%                 app.FFTvalue = 5;
%             else if (strcmp(app.SelectChannelforFourierTransformListBox.Value,app.Wavedata.headers{1,6}))
%                 app.FFTvalue = 6;
%             else if (strcmp(app.SelectChannelforFourierTransformListBox.Value,app.Wavedata.headers{1,7}))
%                 app.FFTvalue = 7;
%             else if (strcmp(app.SelectChannelforFourierTransformListBox.Value,app.Wavedata.headers{1,8}))
%                 app.FFTvalue = 8;
%             else if (strcmp(app.SelectChannelforFourierTransformListBox.Value,app.Wavedata.headers{1,9}))
%                 app.FFTvalue = 9;
%                 end
%                 end
%                 end
%                 end
%                 end
%                 end
%                 end
%                 end
%             end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LISTBOX if statements:

%             list = get(value,'String');   %%get string here%%
%             item = list{value};
%             item_selected =  str2double(item);
            
%             app.SelectDatatoAnalyzeListBox.Value == app.Wavedata.headers(2)
%             item_selected == app.SelectDatatoAnalyzeListBox.Items(1)
%             app.SelectDatatoAnalyzeListBox.Items(1)
%             app.SelectDatatoAnalyzeListBox.Value == app.SelectDatatoAnalyzeListBox.Items{3}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%             % Create SelectDatatoAnalyzePanel
%             app.SelectDatatoAnalyzePanel = uipanel(app.TimeHistoryStatsTab);
%             app.SelectDatatoAnalyzePanel.TitlePosition = 'centertop';
%             app.SelectDatatoAnalyzePanel.Title = 'Select Data to Analyze';
%             app.SelectDatatoAnalyzePanel.BackgroundColor = [0.8 0.8 0.8];
%             app.SelectDatatoAnalyzePanel.FontWeight = 'bold';
%             app.SelectDatatoAnalyzePanel.Position = [12 304 232 143];
% 
%             % Create CheckBox
%             app.CheckBox = uicheckbox(app.SelectDatatoAnalyzePanel);
%             app.CheckBox.Position = [12 90 81 22];
% 
%             % Create CheckBox2
%             app.CheckBox2 = uicheckbox(app.SelectDatatoAnalyzePanel);
%             app.CheckBox2.Position = [12 69 88 22];
% 
%             % Create CheckBox3
%             app.CheckBox3 = uicheckbox(app.SelectDatatoAnalyzePanel);
%             app.CheckBox3.Position = [12 48 88 22];
% 
%             % Create CheckBox4
%             app.CheckBox4 = uicheckbox(app.SelectDatatoAnalyzePanel);
%             app.CheckBox4.Position = [12 25 88 22];
% 
%             % Create CheckBox5
%             app.CheckBox5 = uicheckbox(app.SelectDatatoAnalyzePanel);
%             app.CheckBox5.Position = [12 2 88 22];
% 
%             % Create CheckBox6
%             app.CheckBox6 = uicheckbox(app.SelectDatatoAnalyzePanel);
%             app.CheckBox6.Position = [130 90 88 22];
% 
%             % Create CheckBox7
%             app.CheckBox7 = uicheckbox(app.SelectDatatoAnalyzePanel);
%             app.CheckBox7.Position = [130 69 88 22];
% 
%             % Create CheckBox8
%             app.CheckBox8 = uicheckbox(app.SelectDatatoAnalyzePanel);
%             app.CheckBox8.Position = [130 48 88 22];
%             
%             % Create CheckBox9
%             app.CheckBox9 = uicheckbox(app.SelectDatatoAnalyzePanel);
%             app.CheckBox9.Position = [130 27 88 22];

%             % Create PlotAnalyzeButton
%             app.PlotAnalyzeButton = uibutton(app.TimeHistoryStatsTab, 'push');
%             app.PlotAnalyzeButton.ButtonPushedFcn = createCallbackFcn(app, @PlotAnalyzeButtonPushed, true);
%             app.PlotAnalyzeButton.BackgroundColor = [0.8 0.8 0.8];
%             app.PlotAnalyzeButton.FontWeight = 'bold';
%             app.PlotAnalyzeButton.Position = [474 246 154 35];
%             app.PlotAnalyzeButton.Text = 'Plot/Analyze';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             a = get(handles.ButtonGroup_2, 'SelectedObject');
%             freqselection = get(a,'String');
                
%             switch freqselection
%                 case 'Input Sample Frequency?'
%                     %set(app.DesiredSampleFrequencyEditField,'editable', 'on');
%                     app.DesiredSampleFrequencyEditField.Editable = 'on';
%                 case 'Off'
%                     %set(app.DesiredSampleFrequencyEditField,'Editable', 'off');
%                     app.DesiredSampleFrequencyEditField.Editable = 'off';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FFTButton Pushed %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%         function ButtonGroup_2SelectionChanged(app, event)
%             selectedButton = app.ButtonGroup_2.SelectedObject;
%             radioselection = get(selectedButton,'String');
%             
%             switch radioselection
%                 case 'Input Sample Frequency?'
%                     set(app.DesiredSampleFrequencyEditField,'enable','on')
%                     %app.DesiredSampleFrequencyEditField.Editable = 'on';
%                 case 'Off'
%                     set(app.DesiredSampleFrequencyEditField,'enable','off')
%                     %app.DesiredSampleFrequencyEditField.Editable = 'off';
%             end
%             
%             if strcmp(selectedButton.Text,'Input Sample Frequency?')
%                 app.DesiredSampleFrequencyEditField.Editable = 'on';
%             else
%                 app.DesiredSampleFrequencyEditField.Editable = 'off';
%             end
%             
                        
%             if(strcmp(app.SelectChannelforFourierTransformListBox.Value,app.Wavedata.headers{1,1}))
%                 app.FFTvalue = 1;
%             end             
%         end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         function FrequencySelectionChanged(app,event,handles)
%             a = get(handles.ButtonGroup_2, 'SelectedObject');
%             freqselection = get(a,'String');
%             
%             switch freqselection
%                 case 'Input Sample Frequency?'
%                     set(app.handles.DesiredSampleFrequencyEditField,'enable','on')
%                 case 'Off'
%                     set(app.handles.DesiredSampleFrequencyEditField,'enable','off');
%                     
%             end
%             
% %             if app.FrequencyCheckBox.Value
% %                 set(app.DesiredSampleFrequencyEditField, 'enable','on');
% %                 %app.DesiredSampleFrequencyEditField.Visible = 'on';
% %             end
% %             if app.FrequencyCheckBox.Value == 0
% %                 set(app.DesiredSampleFrequencyEditField, 'enable', 'off');
% %                 %app.DesiredSampleFrequencyEditField.Visible = 'off';
% %             end
%         end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Old Checkboxes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
%             if app.CheckBox.Value
%                 plot(app.UIAxes,app.filtered_one,app.filtered_one,'b');
%                 ch1_Analysis = [1,"Blue",mean(app.Wavedata.ch1), min(app.Wavedata.ch1),max(app.Wavedata.ch1),std(app.Wavedata.ch1)];
%                 row = [app.UITable2.Data;ch1_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             %should the analysis values be of the filtered?
%             %replaced app.Wavedata.ch1 witht app.filtered_one
%             end
%             if app.CheckBox2.Value
%                 plot(app.UIAxes,app.filtered_one,app.filtered_two,'r');
%                 ch2_Analysis = [2,"Red",mean(app.Wavedata.ch2), min(app.Wavedata.ch2),max(app.Wavedata.ch2),std(app.Wavedata.ch2)];
%                 row = [app.UITable2.Data;ch2_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if app.CheckBox3.Value
%                 plot(app.UIAxes,app.filtered_one,app.filtered_three,'g');
%                 ch3_Analysis = [3,"Green",mean(app.Wavedata.ch3), min(app.Wavedata.ch3),max(app.Wavedata.ch3),std(app.Wavedata.ch3)];
%                 row = [app.UITable2.Data;ch3_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if app.CheckBox4.Value
%                 plot(app.UIAxes,app.filtered_one,app.filtered_four,'k');
%                 ch4_Analysis = [4,"Black",mean(app.Wavedata.ch4), min(app.Wavedata.ch4),max(app.Wavedata.ch4),std(app.Wavedata.ch4)];
%                 row = [app.UITable2.Data;ch4_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if app.CheckBox5.Value
%                 plot(app.UIAxes,app.filtered_one,app.filtered_five,'m');
%                 ch5_Analysis = [5,"Pink",mean(app.Wavedata.ch5), min(app.Wavedata.ch5),max(app.Wavedata.ch5),std(app.Wavedata.ch5)];
%                 row = [app.UITable2.Data;ch5_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if app.CheckBox6.Value
%                 plot(app.UIAxes,app.filtered_one,app.filtered_six,'c');
%                 ch6_Analysis = [6,"Cyan",mean(app.Wavedata.ch6), min(app.Wavedata.ch6),max(app.Wavedata.ch6),std(app.Wavedata.ch6)];
%                 row = [app.UITable2.Data;ch6_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if app.CheckBox7.Value
%                 plot(app.UIAxes,app.filtered_one,app.filtered_seven,'color',[0.4940, 0.1840, 0.5560]);
%                 ch7_Analysis = [7,"Purple",mean(app.Wavedata.ch7), min(app.Wavedata.ch7),max(app.Wavedata.ch7),std(app.Wavedata.ch7)];
%                 row = [app.UITable2.Data;ch7_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if app.CheckBox8.Value
%                 plot(app.UIAxes,app.filtered_one,app.filtered_eight,'color',[0.8500, 0.3250, 0.0980]);
%                 ch8_Analysis = [8,"Orange",mean(app.Wavedata.ch8), min(app.Wavedata.ch8),max(app.Wavedata.ch8),std(app.Wavedata.ch8)];
%                 row = [app.UITable2.Data;ch8_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if app.CheckBox9.Value
%                 plot(app.UIAxes,app.filtered_one,app.filtered_nine,'color',[0, 0.5, 0]);
%                 ch9_Analysis = [9,"Dark Green",mean(app.Wavedata.ch9), min(app.Wavedata.ch9),max(app.Wavedata.ch9),std(app.Wavedata.ch9)];
%                 row = [app.UITable2.Data;ch9_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             
%             drawnow; 

%%%%%%%%%%%%%%%%%%%%%% Old Button pushed function: PlotAnalyzeButton %%%%%%%%%%%%%%%%%%

%        function PlotAnalyzeButtonPushed(app, event)
%             app.UITable2.Data = [];
%             %plot(app.UIAxes,[],[]);
%             cla(app.UIAxes);
%             hold(app.UIAxes);

%             wpass = app.SpecifyNormalizedPassbandFrequencyEditField.Value;
%             %%% must be # between 0 and 1, create an error statement if 
%             %%% input is out of this normalized range
%             
%             %%%%%%%%%%%% Filter Buttons %%%%%%%%%%%%%%%
%             if app.NoneButton.Value == 1
%                 app.filtered_one = app.Wavedata.ch1;
%                 app.filtered_two = app.Wavedata.ch2;
%                 app.filtered_three = app.Wavedata.ch3;
%                 app.filtered_four = app.Wavedata.ch4;
%                 app.filtered_five = app.Wavedata.ch5;
%                 app.filtered_six = app.Wavedata.ch6;
%                 app.filtered_seven = app.Wavedata.ch7;
%                 app.filtered_eight = app.Wavedata.ch8;
%                 app.filtered_nine = app.Wavedata.ch9;
%             end
%             if app.LowPassButton.Value == 1
%                 %[app.Wavedata.ch1,app.Wavedata.ch2,app.Wavedata.ch3,app.Wavedata.ch4,app.Wavedata.ch5,app.Wavedata.ch6,app.Wavedata.ch7,app.Wavedata.ch8,app.Wavedata.ch9] = [lowpass(app.Wavedata.ch1),lowpass(app.Wavedata.ch2),lowpass(app.Wavedata.ch3),lowpass(app.Wavedata.ch4),lowpass(app.Wavedata.ch5),lowpass(app.Wavedata.ch6),lowpass(app.Wavedata.ch7),lowpass(app.Wavedata.ch8),lowpass(app.Wavedata.ch9)]; 
%                 app.filtered_one = lowpass(app.Wavedata.ch1,wpass);
%                 app.filtered_two = lowpass(app.Wavedata.ch2,wpass);
%                 app.filtered_three = lowpass(app.Wavedata.ch3,wpass);
%                 app.filtered_four = lowpass(app.Wavedata.ch4,wpass);
%                 app.filtered_five = lowpass(app.Wavedata.ch5,wpass);
%                 app.filtered_six = lowpass(app.Wavedata.ch6,wpass);
%                 app.filtered_seven = lowpass(app.Wavedata.ch7,wpass);
%                 app.filtered_eight = lowpass(app.Wavedata.ch8,wpass);
%                 app.filtered_nine = lowpass(app.Wavedata.ch9,wpass);
%                 %%%% need a way to select all channels so diff # of 
%                 %%%% can be used
%             end
%             if app.HighPassButton.Value == 1
%                 %app.Wavedata(:,5:end) = highpass(app.Wavedata(:,5:end));
%                 app.filtered_one = highpass(app.Wavedata.ch1,wpass);
%                 app.filtered_two = highpass(app.Wavedata.ch2,wpass);
%                 app.filtered_three = highpass(app.Wavedata.ch3,wpass);
%                 app.filtered_four = highpass(app.Wavedata.ch4,wpass);
%                 app.filtered_five = highpass(app.Wavedata.ch5,wpass);
%                 app.filtered_six = highpass(app.Wavedata.ch6,wpass);
%                 app.filtered_seven = highpass(app.Wavedata.ch7,wpass);
%                 app.filtered_eight = highpass(app.Wavedata.ch8,wpass);
%                 app.filtered_nine = highpass(app.Wavedata.ch9,wpass);
%             end
%        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             if (strcmp(app.SelectDatatoAnalyzeListBox.Value,app.Wavedata.headers{1,10}))
%                 plot(app.UIAxes,app.filtered_one,app.filtered_ten,'color',[0, 0.5, 0]);
%                 ch10_Analysis = [10,"Dark Green",mean(app.Wavedata.ch10), min(app.Wavedata.ch10),max(app.Wavedata.ch10),std(app.Wavedata.ch10)];
%                 row = [app.UITable2.Data;ch10_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if (strcmp(app.SelectDatatoAnalyzeListBox.Value,app.Wavedata.headers{1,11}))
%                 plot(app.UIAxes,app.filtered_one,app.filtered_eleven,'color',[0, 0.5, 0]);
%                 ch11_Analysis = [11,"Dark Green",mean(app.Wavedata.ch11), min(app.Wavedata.ch11),max(app.Wavedata.ch11),std(app.Wavedata.ch11)];
%                 row = [app.UITable2.Data;ch11_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if (strcmp(app.SelectDatatoAnalyzeListBox.Value,app.Wavedata.headers{1,12}))
%                 plot(app.UIAxes,app.filtered_one,app.filtered_twelve,'color',[0, 0.5, 0]);
%                 ch12_Analysis = [12,"Dark Green",mean(app.Wavedata.ch12), min(app.Wavedata.ch12),max(app.Wavedata.ch12),std(app.Wavedata.ch12)];
%                 row = [app.UITable2.Data;ch12_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if (strcmp(app.SelectDatatoAnalyzeListBox.Value,app.Wavedata.headers{1,13}))
%                 plot(app.UIAxes,app.filtered_one,app.filtered_thirteen,'color',[0, 0.5, 0]);
%                 ch13_Analysis = [13,"Dark Green",mean(app.Wavedata.ch13), min(app.Wavedata.ch13),max(app.Wavedata.ch13),std(app.Wavedata.ch13)];
%                 row = [app.UITable2.Data;ch13_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if (strcmp(app.SelectDatatoAnalyzeListBox.Value,app.Wavedata.headers{1,14}))
%                 plot(app.UIAxes,app.filtered_one,app.filtered_fourteen,'color',[0, 0.5, 0]);
%                 ch14_Analysis = [14,"Dark Green",mean(app.Wavedata.ch14), min(app.Wavedata.ch14),max(app.Wavedata.ch14),std(app.Wavedata.ch14)];
%                 row = [app.UITable2.Data;ch14_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if (strcmp(app.SelectDatatoAnalyzeListBox.Value,app.Wavedata.headers{1,15}))
%                 plot(app.UIAxes,app.filtered_one,app.filtered_fifteen,'color',[0, 0.5, 0]);
%                 ch15_Analysis = [15,"Dark Green",mean(app.Wavedata.ch15), min(app.Wavedata.ch15),max(app.Wavedata.ch15),std(app.Wavedata.ch15)];
%                 row = [app.UITable2.Data;ch15_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%only 9 check boxes, fix so that ther can be any number:
            %%change to multiselect listbox maybe
%             app.CheckBox.Text = app.Wavedata.headers(1);
%             app.CheckBox2.Text = app.Wavedata.headers(2);
%             app.CheckBox3.Text = app.Wavedata.headers(3);
%             app.CheckBox4.Text = app.Wavedata.headers(4);
%             app.CheckBox5.Text = app.Wavedata.headers(5);
%             app.CheckBox6.Text = app.Wavedata.headers(6);
%             app.CheckBox7.Text = app.Wavedata.headers(7);
%             app.CheckBox8.Text = app.Wavedata.headers(8);
%             app.CheckBox9.Text = app.Wavedata.headers(9);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         PlotAnalyzeButton                                   matlab.ui.control.Button
%         SelectDatatoAnalyzeListBoxLabel                     matlab.ui.control.Label        
%         SelectDatatoAnalyzePanel                            matlab.ui.container.Panel
%         CheckBox                                            matlab.ui.control.CheckBox
%         CheckBox2                                           matlab.ui.control.CheckBox
%         CheckBox3                                           matlab.ui.control.CheckBox
%         CheckBox4                                           matlab.ui.control.CheckBox
%         CheckBox5                                           matlab.ui.control.CheckBox
%         CheckBox6                                           matlab.ui.control.CheckBox
%         CheckBox7                                           matlab.ui.control.CheckBox
%         CheckBox8                                           matlab.ui.control.CheckBox
%         CheckBox9                                           matlab.ui.control.CheckBox






