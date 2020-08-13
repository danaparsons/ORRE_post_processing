%% ------------------------------ Header ------------------------------- %%
% Filename:     ORRE_post_processing_app.m    
% Description:  ORRE Post Processing App.
% Authors:      D. Lukas and J. Davis
% Created on:   6-10-20
% Last updated: 7-31-20 by J. Davis
% Notes:
% This app is designed to compute and display many different analyses,
% depending on user needs. Desired results are obtained by running the 
% app and interacting with various buttons, drop down selections, 
% checkboxes, and tabs.
%% ------------------------------ App ---------------------------------- %%
classdef ORRE_post_processing_app < matlab.apps.AppBase

    properties (Access = public)    % APP COMPONENT PROPERTIES
        % General navigation and UI components
        UIFigure                                            matlab.ui.Figure
        TabGroup                                            matlab.ui.container.TabGroup
        
        % Welcome tab components
        WelcomeTab                                          matlab.ui.container.Tab
        TextArea                                            matlab.ui.control.TextArea
        Image                                               matlab.ui.control.Image
        WelcomeLabel                                        matlab.ui.control.Label
        ImportantNotesLabel                                 matlab.ui.control.Label
        UpdatingThisAppLabel                                matlab.ui.control.Label
        
        % Upload data tab components
        UploadDataTab                                       matlab.ui.container.Tab
        UploadDataButton                                    matlab.ui.control.Button
        UploadDataTable                                     matlab.ui.control.Table
        LegendPanel                                         matlab.ui.container.Panel
        DataLegendTable                                     matlab.ui.control.Table
        DataSettingsPanel                                   matlab.ui.container.Panel
        TagLinesDropDownLabel                               matlab.ui.control.Label
        TagLinesDropDown                                    matlab.ui.control.DropDown
            HeaderLinesDropDownLabel                            matlab.ui.control.Label
            HeaderLinesDropDown                                 matlab.ui.control.DropDown
        HeaderLinesSpinnerLabel                             matlab.ui.control.Label
        HeaderLinesSpinner                                  matlab.ui.control.Spinner
            TagFormatDropDownLabel                              matlab.ui.control.Label
            TagFormatDropDown                                   matlab.ui.control.DropDown
        TagLinesSpinnerLabel                                matlab.ui.control.Label
        TagLinesSpinner                                     matlab.ui.control.Spinner
        HeaderFormatDropDownLabel                           matlab.ui.control.Label
        HeaderFormatDropDown                                matlab.ui.control.DropDown
        DataFormatDropDownLabel                             matlab.ui.control.Label
        DataFormatDropDown                                  matlab.ui.control.DropDown
        CommentStyleDropDownLabel                           matlab.ui.control.Label
        CommentStyleDropDown                                matlab.ui.control.DropDown
        DelimiterEditFieldLabel                             matlab.ui.control.Label
        DelimiterEditField                                  matlab.ui.control.EditField
        DataSetInformationPanel                             matlab.ui.container.Panel
        TagInformation                                      matlab.ui.control.TextArea
        DataOperationPanel                                  matlab.ui.container.Panel
        DataOperationFieldLabel                             matlab.ui.control.Label
        DataOperationField                                  matlab.ui.control.EditField
        DataOperationButton                                 matlab.ui.control.Button
        DataOperationChannelDropDownLabel                   matlab.ui.control.Label
        DataOperationChannelDropDown                        matlab.ui.control.DropDown
        
        % Fliter data tab components
        FilterDataTab                                       matlab.ui.container.Tab
        FilterAxes                                          matlab.ui.control.UIAxes
        DataFilterPanel                                     matlab.ui.container.Panel
        DataFilterListBox                                   matlab.ui.control.ListBox
        SelectDatatoFilterLabel                             matlab.ui.control.Label
        FilterTimeDropDown                                  matlab.ui.control.DropDown
        FilterTimeLabel                                     matlab.ui.control.Label
%         EnterNumericTimeChannelEditField_2Label             matlab.ui.control.Label
%         TimeFilterEditField                                 matlab.ui.control.NumericEditField
        FilteringOptionsButtonGroup                         matlab.ui.container.ButtonGroup
        LowPassButton                                       matlab.ui.control.RadioButton
        HighPassButton                                      matlab.ui.control.RadioButton
        NoneButton                                          matlab.ui.control.RadioButton
        SpecifyPassbandFrequencyEditField                   matlab.ui.control.NumericEditField
        SpecifyPassbandFrequencyEditFieldLabel              matlab.ui.control.Label
        OverwriteCheckBox                                   matlab.ui.control.CheckBox
        FiltFreqPanel                                       matlab.ui.container.Panel
        PlotFFTButton_Filter                                matlab.ui.control.Button
        FilterDataTextArea                                  matlab.ui.control.TextArea
        
        % Time history stats tab components
        TimeHistoryStatsTab                                 matlab.ui.container.Tab
        TimeHistoryAxes                                     matlab.ui.control.UIAxes
        StatsTable                                          matlab.ui.control.Table
        SelectDatatoAnalyzePANEL                            matlab.ui.container.Panel
        SelectDatatoAnalyzeListBox                          matlab.ui.control.ListBox
        ClearButton                                         matlab.ui.control.CheckBox
        SelectDatatoAnalyzeLabel                            matlab.ui.control.Label
%         EnterNumericTimeChannelEditFieldLabel               matlab.ui.control.Label
%         EnterNumericTimeChannelEditField                    matlab.ui.control.NumericEditField  
        TimeHistTimeDropDownLabel                           matlab.ui.control.Label
        TimeHistTimeDropDown                                matlab.ui.control.DropDown
        FiltFreqTable                                       matlab.ui.control.Table
  
        % Fourier transform tab components
        FourierTransformTab                                 matlab.ui.container.Tab
        FFTPanel                                            matlab.ui.container.Panel
        FFTInfo                                             matlab.ui.control.TextArea
        SelectIndependentVariableTimeLabel                  matlab.ui.control.Label
        SelectIndependentVariableTimeListBox                matlab.ui.control.ListBox
        SelectDependentVariableListBoxLabel                 matlab.ui.control.Label
        SelectDependentVariableListBox                      matlab.ui.control.ListBox
        OptionalSpecificationsPanel                         matlab.ui.container.Panel
        FrequencyCheckBox                                   matlab.ui.control.CheckBox
        DesiredSampleFrequencyEditField                     matlab.ui.control.NumericEditField
        FFTButton                                           matlab.ui.control.Button
        FourierTransformLabel                               matlab.ui.control.Label
        
        % Wavelet transform tab components
        WaveletTransformTab                                 matlab.ui.container.Tab
        WaveletTransformLabel                               matlab.ui.control.Label
        WaveletPanel                                        matlab.ui.container.Panel
        WaveletText                                         matlab.ui.control.TextArea
        WaveletSelectIndependentVariableTimeListBoxLabel    matlab.ui.control.Label
        WaveletSelectIndependentVariableTimeListBox         matlab.ui.control.ListBox
        WaveletSelectDependentVariableListBoxLabel          matlab.ui.control.Label
        WaveletSelectDependentVariableListBox               matlab.ui.control.ListBox
        PlotWaveletTransformButton                          matlab.ui.control.Button
        
        % Laplace transform tab components
        LaplaceTransformTab                                 matlab.ui.container.Tab
        LaplacePanel                                            matlab.ui.container.Panel
        LaplaceInfo                                          matlab.ui.control.TextArea
        SelectIndependentVariableTimeListBox_2Label         matlab.ui.control.Label
        SelectIndependentVariableTimeListBox_2              matlab.ui.control.ListBox
        SelectDependentVariableListBox_2Label               matlab.ui.control.Label
        SelectDependentVariableListBox_2                    matlab.ui.control.ListBox
        PlotLaplaceTransformButton                          matlab.ui.control.Button
        LaplaceTransformLabel                               matlab.ui.control.Label
        
        % Create report tab components
        CreateReportTab                                     matlab.ui.container.Tab
        SaveTabletxtFilesPanel                              matlab.ui.container.Panel
        SaveTablesButton                                    matlab.ui.control.Button
        SaveDataChkBox                                      matlab.ui.control.CheckBox
        SaveLegendChkBox                                    matlab.ui.control.CheckBox
        SaveSettingsChkBox                                  matlab.ui.control.CheckBox
        SaveStatsChkBox                                     matlab.ui.control.CheckBox
        SaveFrequenciesChkBox                               matlab.ui.control.CheckBox
        TableFileTypeDropDownLabel                          matlab.ui.control.Label
        TableFileTypeDropDown                               matlab.ui.control.DropDown
        CreateReportButton                                  matlab.ui.control.Button
        SaveGraphsPanel                                     matlab.ui.container.Panel
        FilterDataTimeHistoryCheckBox                       matlab.ui.control.CheckBox
        TimeHistoryCheckBox                                 matlab.ui.control.CheckBox
        FourierTransformsCheckBox                           matlab.ui.control.CheckBox
        LaplaceTransformsCheckBox                           matlab.ui.control.CheckBox
        WaveletTransformsCheckBox                           matlab.ui.control.CheckBox
        GraphFileTypeDropDownLabel                            matlab.ui.control.Label
        GraphFileTypeDropDown                               matlab.ui.control.DropDown
        SaveGraphsButton                                    matlab.ui.control.Button
    end

%-------------------------------------------------------------------------%
    
    properties (Access = public)    % DATA STORAGE PROPERTIES
        Wavedata     %holds user chosen data set
        FFTvalue     %holds channel to plot in Fourier Transform
        Timevalue    %holds channel to use as time for FFT
        Headers      %headers of wavedata data set
        Combined_Channels
        fs           %for filter data
        FilteredData
        filtplot
        SelectedFrequency %holds frequency selection for FFT button
        Timevalue_laplace
        laplacevalue
        
        Waveletvalue
        WaveletTimevalue
    end

%-------------------------------------------------------------------------%
    
    methods (Access = private)      % SUBFUNCTION METHODS
        %% --------------------- STARTUP FUNCTION ---------------------- %%

        % Startup
        startupFcn(app)
  
        %% ---------------------- UPLOAD DATA TAB ---------------------- %%
        
        % Upload data button
        UploadDataButtonPushed(app, event)
       
        % Data operation button
%         DataOperationButtonPushed(app, event)

        PerformDataOperationButtonPushed(app, event)
    
        %% ---------------------- FILTER DATA TAB ----------------------- %%
        

        % Filter FFT button       
        PlotFFTButton_FilterPushed(app, event)
        
        % Overwrite checkbox
        OverwriteCheckBoxValueChanged(app,event)
        
        % Filtering options button            
        FilteringOptionsButtonGroupSelectionChanged(app, event)
        %create a refresh plot function to update plot when button pushed
        
        % Filter data listbox        
        DataFilterListBoxValueChanged(app, event)
        
        % Clear button    
        ClearButtonValueChanged(app, event)
        
        %% --------------------- TIME HISTORY TAB ---------------------- %%
        
        % SelectDatatoAnalyze listbox
        SDtAListBoxValueChanged (app, event)     
        
        %% ------------------- FOURIER TRANSFORM TAB ------------------- %%

        % FFT Frequency Input 
        FrequencyCheckBoxValueChanged(app, event)
        
        % SelectIndepVariable LISTBOX 
        SIVTListBoxValueChanged(app, event)
        
        % SelectDependVariable LISTBOX
        SDVListBoxValueChanged(app, event)

        % FFT button              
        FFTButtonPushed(app, event)
        
        %% ------------------- LAPLACE TRANSFORM TAB ------------------- %%

        % Laplace transform button
        PlotLaplaceTransformButtonPushed(app, event)    
        
        %% -------------------- CREATE REPORT TAB ----------------------%%
        
        SaveTablesButtonPushed(app, event)
        SaveGraphsButtonPushed(app, event)
        CreateReportButtonPushed(app,event)
    end 

%-------------------------------------------------------------------------%
    
    methods (Access = private)      %  COMPONENT INITIALIZATION METHODS 
        function createComponents(app)
            %% ------------------ GENERAL NAV AND UI ------------------- %%
            
            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 777 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 777 480];
   
            %% ---------------------- WELCOME TAB ---------------------- %%
            
            % Create WelcomeTab
            app.WelcomeTab = uitab(app.TabGroup);
            app.WelcomeTab.Title = 'Welcome';
            app.WelcomeTab.BackgroundColor = [0.651 0.8353 0.9294];

            % Create TextArea
            app.TextArea = uitextarea(app.WelcomeTab);
            app.TextArea.Position = [12 16 756 426];
            app.TextArea.Value = {''; ''; 'Welcome!'; ''; 'Start with the Upload Data Tab to choose a data set from your computer that you''d like to analyze. From there, create tables, plots, and more by interacting with the other tabs.'; 
            ''; 'Please refer to the ORRE Laboratory Post Processing MatLab Application Documentation for questions and instructions about how to update this app'; ''; ''; ''; ''; ''; ''; 'Important Notes:'; 
            'To use the multiselect feature in the Time History/ Stats Tab, hold down the command button as you select options on a mac, and the crtl button on a PC'; ''; 
            'When filtering data, select one channel at a time and determine the passband freqency by first plotting the FFT. After specifying the frequency, select a filtering option, and play around with it until you are happy with the result. Then check the "Overwrite Channel with Filtered Data?" box. You will see this channel and your chosen frequency listed in the table on the Time History/Stats tab. Once ready to move onto the next channel, click the new channel from the listbox.';
            ''; ''; ''; ''; ''; ''; ''; ''; ''; 'Created by D. Lukas and J. Davis'};
            app.TextArea.FontSize = 12;
            
             % Create Image
            app.Image = uiimage(app.WelcomeTab);
            app.Image.Position = [500 382 261 58];
            app.Image.ImageSource = 'ORRE.png';
            
%             % Create WelcomeLabel
%             app.WelcomeLabel = uilabel(app.WelcomeTab);
%             app.WelcomeLabel.FontSize = 15;
%             app.WelcomeLabel.FontWeight = 'bold';
%             app.WelcomeLabel.FontColor = [0.0392 0.5216 0.7412];
%             app.WelcomeLabel.Position = [17 407 75 22];
%             app.WelcomeLabel.Text = 'Welcome!';
%             
%              % Create ImportantNotesLabel
%             app.ImportantNotesLabel = uilabel(app.WelcomeTab);
%             app.ImportantNotesLabel.FontSize = 15;
%             app.ImportantNotesLabel.FontWeight = 'bold';
%             app.ImportantNotesLabel.FontColor = [0.0392 0.5216 0.7412];
%             app.ImportantNotesLabel.Position = [16 321 126 22];
%             app.ImportantNotesLabel.Text = 'Important Notes:';
%             
%              % Create UpdatingThisAppLabel
%             app.UpdatingThisAppLabel = uilabel(app.WelcomeTab);
%             app.UpdatingThisAppLabel.FontSize = 15;
%             app.UpdatingThisAppLabel.FontWeight = 'bold';
%             app.UpdatingThisAppLabel.FontColor = [0.0392 0.5216 0.7412];
%             app.UpdatingThisAppLabel.Position = [16 253 142 22];
%             app.UpdatingThisAppLabel.Text = 'Updating This App:';
            
            %% -------------------- UPLOAD DATA TAB -------------------- %%
       
            % Create UploadDataTab
            app.UploadDataTab = uitab(app.TabGroup);
            app.UploadDataTab.Title = 'Upload Data';
            app.UploadDataTab.BackgroundColor = [0.651 0.8353 0.9294];

            % Create UploadDataTable
            app.UploadDataTable = uitable(app.UploadDataTab);
            app.UploadDataTable.ColumnName = {};
            app.UploadDataTable.RowName = {};
            app.UploadDataTable.Position = [9 13 757 212];
            app.UploadDataTable.ColumnEditable = [true];
    
            % Create DataSettingsPanel
            app.DataSettingsPanel = uipanel(app.UploadDataTab);
            app.DataSettingsPanel.TitlePosition = 'centertop';
            app.DataSettingsPanel.Title = 'Data File Settings';
            app.DataSettingsPanel.BackgroundColor = [0.8 0.8 0.8];
            app.DataSettingsPanel.FontWeight = 'bold';
            app.DataSettingsPanel.Position = [8 335 493 113];
            
            % Create UploadDataButton
            app.UploadDataButton = uibutton(app.DataSettingsPanel, 'push');
            app.UploadDataButton.ButtonPushedFcn = createCallbackFcn(app, @UploadDataButtonPushed, true);
            app.UploadDataButton.BackgroundColor = [0.9608 0.9608 0.9608];
            app.UploadDataButton.FontWeight = 'bold';
            app.UploadDataButton.Position = [365 11 119 51];
            app.UploadDataButton.Text = {'Click to';'Upload Data'};


%                 % Create TagLinesDropDownLabel
%                 app.TagLinesDropDownLabel = uilabel(app.DataSettingsPanel);
%                 app.TagLinesDropDownLabel.HorizontalAlignment = 'right';
%                 app.TagLinesDropDownLabel.FontWeight = 'bold';
%                 app.TagLinesDropDownLabel.Position = [10 68 60 22];
%                 app.TagLinesDropDownLabel.Text = 'Tag Lines';
% 
%                 % Create TagLinesDropDown
%                 app.TagLinesDropDown = uidropdown(app.DataSettingsPanel);
%                 app.TagLinesDropDown.Items = {'Default (1)', '2', '3', '4', '5'};
%                 app.TagLinesDropDown.Position = [95 68 83 22];
%                 app.TagLinesDropDown.Value = 'Default (1)';
            
            
            % Create TagLinesSpinnerLabel
            app.TagLinesSpinnerLabel = uilabel(app.DataSettingsPanel);
            app.TagLinesSpinnerLabel.HorizontalAlignment = 'right';
            app.TagLinesSpinnerLabel.FontWeight = 'bold';
            app.TagLinesSpinnerLabel.Position = [4 68 61 22];
            app.TagLinesSpinnerLabel.Text = 'Tag Lines';

            % Create TagLinesSpinner
            app.TagLinesSpinner = uispinner(app.DataSettingsPanel);
            app.TagLinesSpinner.Position = [86 68 84 22];
            app.TagLinesSpinner.Value = 1;
            app.TagLinesSpinner.Tooltip = {['Enter the number of tag line rows ',...
                'that exist in the data file. The default value is 1.']};
% 
%                 % Create HeaderLinesDropDownLabel
%                 app.HeaderLinesDropDownLabel = uilabel(app.DataSettingsPanel);
%                 app.HeaderLinesDropDownLabel.HorizontalAlignment = 'right';
%                 app.HeaderLinesDropDownLabel.FontWeight = 'bold';
%                 app.HeaderLinesDropDownLabel.Position = [191 68 81 22];
%                 app.HeaderLinesDropDownLabel.Text = 'Header Lines';
% 
%                 % Create HeaderLinesDropDown
%                 app.HeaderLinesDropDown = uidropdown(app.DataSettingsPanel);
%                 app.HeaderLinesDropDown.Items = {'Default (1)', '2', '3', '4', '5'};
%                 app.HeaderLinesDropDown.Position = [289 68 84 22];
%                 app.HeaderLinesDropDown.Value = 'Default (1)';

            % Create HeaderLinesSpinnerLabel
            app.HeaderLinesSpinnerLabel = uilabel(app.DataSettingsPanel);
            app.HeaderLinesSpinnerLabel.HorizontalAlignment = 'right';
            app.HeaderLinesSpinnerLabel.FontWeight = 'bold';
            app.HeaderLinesSpinnerLabel.Position = [173 68 81 22];
            app.HeaderLinesSpinnerLabel.Text = 'Header Lines';

            % Create HeaderLinesSpinner
            app.HeaderLinesSpinner = uispinner(app.DataSettingsPanel);
            app.HeaderLinesSpinner.Position = [272 68 84 22];
            app.HeaderLinesSpinner.Value = 1;
            app.HeaderLinesSpinner.Tooltip = {['Enter the number of header ',...
                'line rows here that exist in the data file. The ',...
                'default value is 1.']};
            
            
            % Create TagFormatDropDownLabel
            app.TagFormatDropDownLabel = uilabel(app.DataSettingsPanel);
%             app.TagFormatDropDownLabel.HorizontalAlignment = 'right';
            app.TagFormatDropDownLabel.FontWeight = 'bold';
            app.TagFormatDropDownLabel.Position = [10 40 68 22];
            app.TagFormatDropDownLabel.Text = 'Tag Format';

            % Create TagFormatDropDown
            app.TagFormatDropDown = uidropdown(app.DataSettingsPanel);
            app.TagFormatDropDown.Items = {'Default (String)', 'Float', 'Integer'};
            app.TagFormatDropDown.Position = [86 40 83 22];
            app.TagFormatDropDown.Value = 'Default (String)';
            app.TagFormatDropDown.Tooltip = {['Define the expected format of ',...
              'the data file tag information.']};
            
            % Create HeaderFormatDropDownLabel
            app.HeaderFormatDropDownLabel = uilabel(app.DataSettingsPanel);
%             app.HeaderFormatDropDownLabel.HorizontalAlignment = 'right';
            app.HeaderFormatDropDownLabel.FontWeight = 'bold';
            app.HeaderFormatDropDownLabel.Position = [178 40 91 22];
            app.HeaderFormatDropDownLabel.Text = 'Header Format';

            % Create HeaderFormatDropDown
            app.HeaderFormatDropDown = uidropdown(app.DataSettingsPanel);
            app.HeaderFormatDropDown.Items = {'Default (String)', 'Float', 'Integer'};
            app.HeaderFormatDropDown.Position = [272 40 83 22];
            app.HeaderFormatDropDown.Value = 'Default (String)';
            app.HeaderFormatDropDown.Tooltip = {['Define the expected format of ',...
              'the data file header information.']};
            
            % Create DataFormatDropDownLabel
            app.DataFormatDropDownLabel = uilabel(app.DataSettingsPanel);
%             app.DataFormatDropDownLabel.HorizontalAlignment = 'right';
            app.DataFormatDropDownLabel.FontWeight = 'bold';
            app.DataFormatDropDownLabel.Position = [10 12 76 22];
            app.DataFormatDropDownLabel.Text = 'Data Format';

            % Create DataFormatDropDown
            app.DataFormatDropDown = uidropdown(app.DataSettingsPanel);
            app.DataFormatDropDown.Items = {'Default (Float)', 'String', 'Integer'};
            app.DataFormatDropDown.Position = [86 12 83 22];
            app.DataFormatDropDown.Value = 'Default (Float)';
            app.DataFormatDropDown.Tooltip = {['Define the expected format of ',...
              'the data.']};

            % Create CommentStyleDropDownLabel
            app.CommentStyleDropDownLabel = uilabel(app.DataSettingsPanel);
%             app.CommentStyleDropDownLabel.HorizontalAlignment = 'right';
            app.CommentStyleDropDownLabel.FontWeight = 'bold';
            app.CommentStyleDropDownLabel.Position = [178 12 92 22];
            app.CommentStyleDropDownLabel.Text = 'Comment Style';

            % Create CommentStyleDropDown
            app.CommentStyleDropDown = uidropdown(app.DataSettingsPanel);
            app.CommentStyleDropDown.Items = {'Default (%)', '#'};
            app.CommentStyleDropDown.Position = [271 12 84 22];
            app.CommentStyleDropDown.Value = 'Default (%)';
            app.CommentStyleDropDown.Tooltip = {['Define the expected format of ',...
              'any data file comments.']};
          
            % Create DelimiterEditFieldLabel
            app.DelimiterEditFieldLabel = uilabel(app.DataSettingsPanel);
            app.DelimiterEditFieldLabel.HorizontalAlignment = 'right';
            app.DelimiterEditFieldLabel.FontWeight = 'bold';
            app.DelimiterEditFieldLabel.Position = [361 68 57 22];
            app.DelimiterEditFieldLabel.Text = 'Delimiter';

            % Create DelimiterEditField
            app.DelimiterEditField = uieditfield(app.DataSettingsPanel, 'text');
            app.DelimiterEditField.Value = ',';
            app.DelimiterEditField.Tooltip = {['Enter the expected delimiter style. ',...
                'If left empty, the default value is a comma. Other common values ',...
                'include a space '' '' or a tab ''\t''.']};
            app.DelimiterEditField.Position = [426 68 58 22];
            
            % Create LegendPanel
            app.LegendPanel = uipanel(app.UploadDataTab);
            app.LegendPanel.TitlePosition = 'centertop';
            app.LegendPanel.Title = 'Legend';
            app.LegendPanel.BackgroundColor = [0.8 0.8 0.8];
            app.LegendPanel.FontWeight = 'bold';
            app.LegendPanel.Position = [507 238 260 133];
            
            % Create DataLegendTable
            app.DataLegendTable = uitable(app.LegendPanel);
            app.DataLegendTable.ColumnName = {};
            app.DataLegendTable.RowName = {};
            app.DataLegendTable.Position = [9 8 244 102];
            
            % Create DataSetInformationPanel
            app.DataSetInformationPanel = uipanel(app.UploadDataTab);
            app.DataSetInformationPanel.TitlePosition = 'centertop';
            app.DataSetInformationPanel.Title = 'Data Set Information';
            app.DataSetInformationPanel.BackgroundColor = [0.8 0.8 0.8];
            app.DataSetInformationPanel.FontWeight = 'bold';
            app.DataSetInformationPanel.Position = [508 375 259 73];
            
            % Create TagInformation
            app.TagInformation = uitextarea(app.DataSetInformationPanel);
            app.TagInformation.Position = [8 7 244 46];
            
            % Create DataOperationPanel
            app.DataOperationPanel = uipanel(app.UploadDataTab);
            app.DataOperationPanel.TitlePosition = 'centertop';
            app.DataOperationPanel.Title = 'Perform Element-Wise Data Operation';
            app.DataOperationPanel.BackgroundColor = [0.8 0.8 0.8];
            app.DataOperationPanel.FontWeight = 'bold';
            app.DataOperationPanel.Position = [9 238 331 88];

            % Create DataOperationFieldLabel
            app.DataOperationFieldLabel = uilabel(app.DataOperationPanel);
            app.DataOperationFieldLabel.HorizontalAlignment = 'right';
            app.DataOperationFieldLabel.FontWeight = 'bold';
            app.DataOperationFieldLabel.Position = [3 11 96 22];
            app.DataOperationFieldLabel.Text = 'f(x) =';

            % Create DataOperationField
            app.DataOperationField = uieditfield(app.DataOperationPanel, 'text');
            app.DataOperationField.Position = [109 11 103 22];
            app.DataOperationField.Tooltip = {['Use this text field to enter the ',...
                'element-wise operation. ',...
                'The operation should be defined as a function of x (e.g. x^2*3). ',...
                'It is not neccessary to use dots to indicate element-wise ',...
                'operations, nor do you need to define a function handle using @(x).']};

            % Create DataOperationButton
            app.DataOperationButton = uibutton(app.DataOperationPanel, 'push');
            app.DataOperationButton.ButtonPushedFcn = createCallbackFcn(app, @DataOperationButtonPushed, true);
            app.DataOperationButton.Position = [221 11 100 22];
            app.DataOperationButton.Text = 'Perform';

            % Create DataOperationChannelDropDownLabel
            app.DataOperationChannelDropDownLabel = uilabel(app.DataOperationPanel);
            app.DataOperationChannelDropDownLabel.HorizontalAlignment = 'right';
            app.DataOperationChannelDropDownLabel.FontWeight = 'bold';
            app.DataOperationChannelDropDownLabel.Position = [2 41 92 22];
            app.DataOperationChannelDropDownLabel.Text = 'Select Channel';

            % Create DataOperationSelectChannelDropDown
            app.DataOperationChannelDropDown = uidropdown(app.DataOperationPanel);
            app.DataOperationChannelDropDown.Position = [109 41 212 22];
            app.DataOperationChannelDropDown.Items = {};
            app.DataOperationChannelDropDown.Items = {'(Upload Data Required)'};
            
            %% -------------------- FILTER DATA TAB -------------------- %%

            % Create FilterDataTab
            app.FilterDataTab = uitab(app.TabGroup);
            app.FilterDataTab.Title = 'Filter Data';
            app.FilterDataTab.BackgroundColor = [0.651 0.8353 0.9294];

            % Create FilterAxes
            app.FilterAxes = uiaxes(app.FilterDataTab);
            title(app.FilterAxes, 'Time History')
            xlabel(app.FilterAxes, 'Time')
            ylabel(app.FilterAxes, '') %what should be here
            app.FilterAxes.XGrid = 'on';
            app.FilterAxes.YGrid = 'on';
            app.FilterAxes.Position = [8 13 758 274];

            % Create DataFilterPanel
            app.DataFilterPanel = uipanel(app.FilterDataTab);
            app.DataFilterPanel.Position = [9 302 318 146];
            app.DataFilterPanel.BackgroundColor = [0.8 0.8 0.8];

            % Create DataFilterListBox
            app.DataFilterListBox = uilistbox(app.DataFilterPanel); 
            app.DataFilterListBox.ValueChangedFcn = createCallbackFcn(app, @DataFilterListBoxValueChanged, true);
            app.DataFilterListBox.BackgroundColor = [1.00,1.00,1.00];
            app.DataFilterListBox.Position = [124 9 187 101];

            % Create SelectDatatoFilterLabel
            app.SelectDatatoFilterLabel = uilabel(app.DataFilterPanel);
            app.SelectDatatoFilterLabel.FontWeight = 'bold';
            app.SelectDatatoFilterLabel.Position = [159 115 119 22];
            app.SelectDatatoFilterLabel.Text = 'Select Data to Filter';
            
            % Create FilterTimeDropDown
            app.FilterTimeDropDown = uidropdown(app.DataFilterPanel);
            app.FilterTimeDropDown.Position = [11 85 100 22];

            % Create FilterTimeLabel
            app.FilterTimeLabel = uilabel(app.DataFilterPanel);
            app.FilterTimeLabel.FontWeight = 'bold';
            app.FilterTimeLabel.Position = [44 115 34 22];
            app.FilterTimeLabel.Text = 'Time';

%             % Create EnterNumericTimeChannelEditField_2Label
%             app.EnterNumericTimeChannelEditField_2Label = uilabel(app.DataFilterPanel);
%             app.EnterNumericTimeChannelEditField_2Label.HorizontalAlignment = 'center';
%             app.EnterNumericTimeChannelEditField_2Label.Position = [7 82 82 28];
%             app.EnterNumericTimeChannelEditField_2Label.Text = {'Enter Numeric'; 'Time Channel'};
% 
%             % Create TimeFilterEditField
%             app.TimeFilterEditField = uieditfield(app.DataFilterPanel, 'numeric');
%             app.TimeFilterEditField.Position = [13 47 70 22];
            
            % Create FiltFreqPanel
            app.FiltFreqPanel = uipanel(app.FilterDataTab);
            app.FiltFreqPanel.Position = [492 302 274 146];
            app.FiltFreqPanel.BackgroundColor = [0.8 0.8 0.8];
            
             % Create FilteringOptionsButtonGroup
            app.FilteringOptionsButtonGroup = uibuttongroup(app.FiltFreqPanel);
            app.FilteringOptionsButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @FilteringOptionsButtonGroupSelectionChanged, true);
            app.FilteringOptionsButtonGroup.Title = 'Filtering Options';
            app.FilteringOptionsButtonGroup.BackgroundColor = [1.0 1.0 1.0];
            app.FilteringOptionsButtonGroup.FontWeight = 'bold';
            app.FilteringOptionsButtonGroup.Position = [14 27 246 68];
            
            % Create NoneButton
            app.NoneButton = uiradiobutton(app.FilteringOptionsButtonGroup);
            app.NoneButton.Text = 'None';
            app.NoneButton.Position = [8 14 51 22];
            app.NoneButton.Value = true;
            
            % Create LowPassButton
            app.LowPassButton = uiradiobutton(app.FilteringOptionsButtonGroup);
            app.LowPassButton.Text = 'Low-Pass';
            app.LowPassButton.Position = [76 14 76 22];
            
            % Create HighPassButton
            app.HighPassButton = uiradiobutton(app.FilteringOptionsButtonGroup);
            app.HighPassButton.Text = 'High-Pass';
            app.HighPassButton.Position = [165 14 78 22];
            
             % Create SpecifyPassbandFrequencyEditFieldLabel
            app.SpecifyPassbandFrequencyEditFieldLabel = uilabel(app.FiltFreqPanel);
            %app.SpecifyPassbandFrequencyEditFieldLabel.BackgroundColor = [0.8 0.8 0.8];
            app.SpecifyPassbandFrequencyEditFieldLabel.HorizontalAlignment = 'center';
            app.SpecifyPassbandFrequencyEditFieldLabel.FontWeight = 'bold';
            app.SpecifyPassbandFrequencyEditFieldLabel.Position = [14 106 158 32];
            app.SpecifyPassbandFrequencyEditFieldLabel.Text = {'Specify Passband'; 'Frequency'};

            % Create SpecifyPassbandFrequencyEditField
            app.SpecifyPassbandFrequencyEditField = uieditfield(app.FiltFreqPanel, 'numeric');
            %app.SpecifyPassbandFrequencyEditField.BackgroundColor = [0.8 0.8 0.8];
            app.SpecifyPassbandFrequencyEditField.Position = [187 109 73 28];
            
            % Create OverwriteCheckBox
            app.OverwriteCheckBox = uicheckbox(app.FiltFreqPanel);
            app.OverwriteCheckBox.ValueChangedFcn = createCallbackFcn(app, @OverwriteCheckBoxValueChanged, true);
            app.OverwriteCheckBox.Text = 'Overwrite Channel with Filtered Data?';
            app.OverwriteCheckBox.Position = [14 4 246 22];

            % Create PlotFFTButton_Filter
            app.PlotFFTButton_Filter = uibutton(app.FilterDataTab, 'push');
            app.PlotFFTButton_Filter.ButtonPushedFcn = createCallbackFcn(app, @PlotFFTButton_FilterPushed, true);
            app.PlotFFTButton_Filter.Position = [362 320 100 22];
            app.PlotFFTButton_Filter.BackgroundColor = [1.00,1.00,1.00];
            app.PlotFFTButton_Filter.Text = 'Plot FFT';

            % Create FilterDataTextArea
            app.FilterDataTextArea = uitextarea(app.FilterDataTab);
            app.FilterDataTextArea.Position = [339 364 146 81];
            app.FilterDataTextArea.HorizontalAlignment = 'center';
            app.FilterDataTextArea.Value = {'Use the Fourier Transform to determine the Passband Freqency and enter it into the box below to filter the data.'};

            %% ----------------- TIME HISTORY STATS TAB ---------------- %%
            
            % Create TimeHistoryStatsTab
            app.TimeHistoryStatsTab = uitab(app.TabGroup);
            app.TimeHistoryStatsTab.Title = 'Time History/Stats';
            app.TimeHistoryStatsTab.BackgroundColor = [0.651 0.8353 0.9294];

            % Create TimeHistoryAxes
            app.TimeHistoryAxes = uiaxes(app.TimeHistoryStatsTab);
            title(app.TimeHistoryAxes, 'Time History')
            xlabel(app.TimeHistoryAxes, 'Time')
            ylabel(app.TimeHistoryAxes, '') %what should be here
            app.TimeHistoryAxes.ColorOrder = [0 0.4471 0.7412;0.851 0.3255 0.098;0.9294 0.6941 0.1255;0.4941 0.1843 0.5569;0.4667 0.6745 0.1882;0.302 0.7451 0.9333;0.6353 0.0784 0.1843];
            app.TimeHistoryAxes.XGrid = 'on';
            app.TimeHistoryAxes.YGrid = 'on';
            app.TimeHistoryAxes.Position = [12 13 754 220];           

            % Create StatsTable
            app.StatsTable = uitable(app.TimeHistoryStatsTab);
            app.StatsTable.ColumnName = {'Ch';'Color';'Mean'; 'Min'; 'Max'; 'Std Dev'};
            app.StatsTable.ColumnWidth = {30, 50,'auto','auto','auto','auto'};
            app.StatsTable.Position = [227 238 360 207]; 
            
            % Create FiltFreqTable
            app.FiltFreqTable = uitable(app.TimeHistoryStatsTab);
            app.FiltFreqTable.ColumnName = {'Ch'; 'Passband Frequency'};
            app.FiltFreqTable.RowName = {};
            app.FiltFreqTable.ColumnWidth = {40, 'auto'};
            app.FiltFreqTable.Position = [593 238 175 207];
            
            % Create SelectDatatoAnalyzePANEL
            app.SelectDatatoAnalyzePANEL = uipanel(app.TimeHistoryStatsTab);
            app.SelectDatatoAnalyzePANEL.Position = [7 237 214 208];
            app.SelectDatatoAnalyzePANEL.BackgroundColor = [0.8 0.8 0.8];           

            % Create SelectDatatoAnalyzeListBox
            app.SelectDatatoAnalyzeListBox = uilistbox(app.SelectDatatoAnalyzePANEL);
            app.SelectDatatoAnalyzeListBox.Multiselect = 'on';
            app.SelectDatatoAnalyzeListBox.ValueChangedFcn = createCallbackFcn(app, @SDtAListBoxValueChanged, true);
            app.SelectDatatoAnalyzeListBox.Position = [7 37 190 99];

            % Create SelectDatatoAnalyzeLabel
            app.SelectDatatoAnalyzeLabel = uilabel(app.SelectDatatoAnalyzePANEL);
            app.SelectDatatoAnalyzeLabel.FontWeight = 'bold';
            app.SelectDatatoAnalyzeLabel.Position = [35 141 134 22];
            app.SelectDatatoAnalyzeLabel.Text = 'Select Data to Analyze';
            
            % Create TimeHistTimeDropDownLabel
            app.TimeHistTimeDropDownLabel = uilabel(app.SelectDatatoAnalyzePANEL);
            app.TimeHistTimeDropDownLabel.HorizontalAlignment = 'right';
            app.TimeHistTimeDropDownLabel.FontWeight = 'bold';
            app.TimeHistTimeDropDownLabel.Position = [31 169 37 22];
            app.TimeHistTimeDropDownLabel.Text = 'Time:';

            % Create TimeHistTimeDropDown
            app.TimeHistTimeDropDown = uidropdown(app.SelectDatatoAnalyzePANEL);
            app.TimeHistTimeDropDown.Position = [83 169 100 22];
            
%             % Create EnterNumericTimeChannelEditFieldLabel
%             app.EnterNumericTimeChannelEditFieldLabel = uilabel(app.SelectDatatoAnalyzePANEL);
%             app.EnterNumericTimeChannelEditFieldLabel.HorizontalAlignment = 'center';
%             app.EnterNumericTimeChannelEditFieldLabel.Position = [25 147 103 28];
%             app.EnterNumericTimeChannelEditFieldLabel.Text = {'Enter Numeric'; 'Time Channel'};
% 
%             % Create EnterNumericTimeChannelEditField
%             app.EnterNumericTimeChannelEditField = uieditfield(app.SelectDatatoAnalyzePANEL, 'numeric');
%             app.EnterNumericTimeChannelEditField.Position = [134 150 54 22];
            
            % Create ClearButton  
            app.ClearButton= uicheckbox(app.SelectDatatoAnalyzePANEL);
            app.ClearButton.ValueChangedFcn = createCallbackFcn(app, @CheckBox10ValueChangedValueChanged, true);
            app.ClearButton.Text = 'CLEAR';
            app.ClearButton.Position = [7 8 79 22];
            
            %% ----------------- FOURIER TRANSFORM TAB ----------------- %%
            
            % Create FourierTransformTab
            app.FourierTransformTab = uitab(app.TabGroup);
            app.FourierTransformTab.Title = 'Fourier Transform';
            app.FourierTransformTab.BackgroundColor = [0.651 0.8353 0.9294];
            
            % Create FFTPanel
            app.FFTPanel = uipanel(app.FourierTransformTab);
            app.FFTPanel.Position = [186 13 409 432];
            app.FFTPanel.BackgroundColor = [0.8 0.8 0.8];
            app.FFTPanel.FontWeight = 'bold';
            
            % Create SelectIndependentVariableTimeLabel
            app.SelectIndependentVariableTimeLabel = uilabel(app.FFTPanel);
            app.SelectIndependentVariableTimeLabel.HorizontalAlignment = 'center';
            app.SelectIndependentVariableTimeLabel.Position = [41 301 113 28];
            app.SelectIndependentVariableTimeLabel.Text = {'Select Independent '; 'Variable (Time)'};

            % Create SelectIndependentVariableTimeListBox
            app.SelectIndependentVariableTimeListBox = uilistbox(app.FFTPanel);
            app.SelectIndependentVariableTimeListBox.Position = [13 225 169 74];
            app.SelectIndependentVariableTimeListBox.ValueChangedFcn = createCallbackFcn(app, @SIVTListBoxValueChanged, true);

            % Create SelectDependentVariableListBoxLabel
            app.SelectDependentVariableListBoxLabel = uilabel(app.FFTPanel);
            app.SelectDependentVariableListBoxLabel.HorizontalAlignment = 'center';
            app.SelectDependentVariableListBoxLabel.Position = [258 301 102 28];
            app.SelectDependentVariableListBoxLabel.Text = {'Select Dependent'; 'Variable'};

            % Create SelectDependentVariableListBox
            app.SelectDependentVariableListBox = uilistbox(app.FFTPanel);
            app.SelectDependentVariableListBox.Position = [220 225 172 74];
            app.SelectDependentVariableListBox.ValueChangedFcn = createCallbackFcn(app, @SDVListBoxValueChanged, true);
            
            % Create FFTInfo
            app.FFTInfo = uitextarea(app.FFTPanel);
            app.FFTInfo.HorizontalAlignment = 'center';
            app.FFTInfo.Position = [77 346 253 38];
            app.FFTInfo.Value = {'Choose channel values from the boxes below to compute the Fourier Transform.'};
            
            % Create OptionalSpecificationsPanel
            app.OptionalSpecificationsPanel = uipanel(app.FFTPanel);
            app.OptionalSpecificationsPanel.TitlePosition = 'centertop';
            app.OptionalSpecificationsPanel.BackgroundColor = [0.8 0.8 0.8];
            app.OptionalSpecificationsPanel.FontWeight = 'bold';
            app.OptionalSpecificationsPanel.Title = 'Optional Specifications';
            app.OptionalSpecificationsPanel.Position = [78 73 260 122];
            
           % Create FrequencyCheckBox
            app.FrequencyCheckBox = uicheckbox(app.OptionalSpecificationsPanel);
            app.FrequencyCheckBox.ValueChangedFcn = createCallbackFcn(app, @FrequencyCheckBoxValueChanged, true);
            app.FrequencyCheckBox.Text = {'Input Sample'; 'Frequency?'};
            app.FrequencyCheckBox.Position = [7 66 93 28];

            % Create DesiredSampleFrequencyEditField
            app.DesiredSampleFrequencyEditField = uieditfield(app.OptionalSpecificationsPanel, 'numeric');
            app.DesiredSampleFrequencyEditField.Position = [146 66 100 22];
             
            % Create FFTButton
            app.FFTButton = uibutton(app.FFTPanel, 'push');
            app.FFTButton.ButtonPushedFcn = createCallbackFcn(app, @FFTButtonPushed, true);
            app.FFTButton.Position = [140 17 142 22];
            app.FFTButton.FontWeight = 'bold';
            app.FFTButton.Text = 'Plot FFT';
            
            % Create FFTLabel
            app.FourierTransformLabel = uilabel(app.FFTPanel);
            app.FourierTransformLabel.HorizontalAlignment = 'center';
            app.FourierTransformLabel.Position = [145 395 127 26];
            app.FourierTransformLabel.FontWeight = 'bold';
            app.FourierTransformLabel.Text = 'Fourier Transform';

            %% ----------------- WAVELET TRANSFORM TAB ----------------- %%
            
             % Create WaveletTransformTab
            app.WaveletTransformTab = uitab(app.TabGroup);
            app.WaveletTransformTab.Title = 'Wavelet Transform';
            app.WaveletTransformTab.BackgroundColor = [0.651 0.8353 0.9294];

            % Create WaveletPanel
            app.WaveletPanel = uipanel(app.WaveletTransformTab);
            app.WaveletPanel.Position = [186 13 409 432];
            app.WaveletPanel.BackgroundColor = [0.8 0.8 0.8];
            
             % Create WaveletTransformLabel
            app.WaveletTransformLabel = uilabel(app.WaveletPanel);
            app.WaveletTransformLabel.HorizontalAlignment = 'center';
            app.WaveletTransformLabel.Position = [145 395 127 26];
            app.WaveletTransformLabel.FontWeight = 'bold';
            app.WaveletTransformLabel.Text = 'Wavelet Transform';

            % Create WaveletText
            app.WaveletText = uitextarea(app.WaveletPanel);
            app.WaveletText.Value = {'Choose channel values from the boxes below to compute the Wavelet Transform.'};
            app.WaveletText.HorizontalAlignment = 'center';
            app.WaveletText.Position = [77 346 253 38];

            % Create WaveletSelectIndependentVariableTimeListBoxLabel
            app.WaveletSelectIndependentVariableTimeListBoxLabel = uilabel(app.WaveletPanel);
            app.WaveletSelectIndependentVariableTimeListBoxLabel.HorizontalAlignment = 'center';
            app.WaveletSelectIndependentVariableTimeListBoxLabel.Position = [41 301 113 28];
            app.WaveletSelectIndependentVariableTimeListBoxLabel.Text = {'Select Independent '; 'Variable (Time)'};

            % Create WaveletSelectIndependentVariableTimeListBox
            app.WaveletSelectIndependentVariableTimeListBox = uilistbox(app.WaveletPanel);
            app.WaveletSelectIndependentVariableTimeListBox.Position = [13 225 169 74];

            % Create WaveletSelectDependentVariableListBoxLabel
            app.WaveletSelectDependentVariableListBoxLabel = uilabel(app.WaveletPanel);
            app.WaveletSelectDependentVariableListBoxLabel.HorizontalAlignment = 'center';
            app.WaveletSelectDependentVariableListBoxLabel.Position = [258 301 102 28];
            app.WaveletSelectDependentVariableListBoxLabel.Text = {'Select Dependent'; 'Variable'};

            % Create WaveletSelectDependentVariableListBox
            app.WaveletSelectDependentVariableListBox = uilistbox(app.WaveletPanel);
            app.WaveletSelectDependentVariableListBox.Position = [220 225 172 74];

            % Create PlotWaveletTransformButton
            app.PlotWaveletTransformButton = uibutton(app.WaveletPanel, 'push');
            app.PlotWaveletTransformButton.ButtonPushedFcn = createCallbackFcn(app, @WaveletButtonPushed, true);
            app.PlotWaveletTransformButton.Position = [140 17 142 22];
            app.PlotWaveletTransformButton.FontWeight = 'bold';
            app.PlotWaveletTransformButton.Text = 'Plot Wavelet Transform';

            %% ----------------- LAPLACE TRANSFORM TAB ----------------- %%
            
            % Create LaplaceTransformTab
            app.LaplaceTransformTab = uitab(app.TabGroup);
            app.LaplaceTransformTab.Title = 'Laplace Transform';
            app.LaplaceTransformTab.BackgroundColor = [0.651 0.8353 0.9294];
            
             % Create LaplacePanel
            app.LaplacePanel = uipanel(app.LaplaceTransformTab);
            app.LaplacePanel.Position = [179 243 421 189];
            app.LaplacePanel.BackgroundColor = [0.8 0.8 0.8];

            % Create LaplaceInfo
            app.LaplaceInfo = uitextarea(app.LaplacePanel);
            app.LaplaceInfo.Position = [101 138 221 40];
            app.LaplaceInfo.Value = {'Choose channel values from the boxes below to compute Laplace Transform.'};

            % Create SelectIndependentVariableTimeListBox_2Label
            app.SelectIndependentVariableTimeListBox_2Label = uilabel(app.LaplacePanel);
            app.SelectIndependentVariableTimeListBox_2Label.HorizontalAlignment = 'center';
            app.SelectIndependentVariableTimeListBox_2Label.Position = [43 88 113 28];
            app.SelectIndependentVariableTimeListBox_2Label.Text = {'Select Independent '; 'Variable (Time)'};

            % Create SelectIndependentVariableTimeListBox_2
            app.SelectIndependentVariableTimeListBox_2 = uilistbox(app.LaplacePanel);
            app.SelectIndependentVariableTimeListBox_2.Position = [11 12 178 74];

            % Create SelectDependentVariableListBox_2Label
            app.SelectDependentVariableListBox_2Label = uilabel(app.LaplacePanel);
            app.SelectDependentVariableListBox_2Label.HorizontalAlignment = 'center';
            app.SelectDependentVariableListBox_2Label.Position = [268 91 102 28];
            app.SelectDependentVariableListBox_2Label.Text = {'Select Dependent'; 'Variable'};

            % Create SelectDependentVariableListBox_2
            app.SelectDependentVariableListBox_2 = uilistbox(app.LaplacePanel);
            app.SelectDependentVariableListBox_2.Position = [233 15 172 74];

            % Create PlotLaplaceTransformButton
            app.PlotLaplaceTransformButton = uibutton(app.LaplaceTransformTab, 'push');
            app.PlotLaplaceTransformButton.ButtonPushedFcn = createCallbackFcn(app, @PlotLaplaceTransformButtonPushed, true);
            app.PlotLaplaceTransformButton.Position = [339 83 100 36];
            app.PlotLaplaceTransformButton.BackgroundColor = [0.8 0.8 0.8];
            app.PlotLaplaceTransformButton.Text = {'Plot Laplace'; 'Transform'};
            
            % Create LaplaceTransformLabel
            app.LaplaceTransformLabel = uilabel(app.LaplaceTransformTab);
            app.LaplaceTransformLabel.HorizontalAlignment = 'center';
            app.LaplaceTransformLabel.Position = [325 421 127 26];
            app.LaplaceTransformLabel.BackgroundColor = [0.8 0.8 0.8];
            app.LaplaceTransformLabel.FontWeight = 'bold';
            app.LaplaceTransformLabel.Text = 'Laplace Transform';
                       
            %% ------------------- CREATE REPORT TAB ------------------- %%
            
            % Create CreateReportTab
            app.CreateReportTab = uitab(app.TabGroup);
            app.CreateReportTab.Title = 'Create Report';
            app.CreateReportTab.BackgroundColor = [0.651 0.8353 0.9294];
            
            % Create SaveTabletxtFilesPanel
            app.SaveTabletxtFilesPanel = uipanel(app.CreateReportTab);
            app.SaveTabletxtFilesPanel.TitlePosition = 'centertop';
            app.SaveTabletxtFilesPanel.Title = 'Save Table Files';
            app.SaveTabletxtFilesPanel.BackgroundColor = [0.8 0.8 0.8];
            app.SaveTabletxtFilesPanel.FontWeight = 'bold';
            app.SaveTabletxtFilesPanel.Position = [9 232 219 215];

            % Create SaveTablesButton
            app.SaveTablesButton = uibutton(app.SaveTabletxtFilesPanel, 'push');
            app.SaveTablesButton.ButtonPushedFcn = createCallbackFcn(app, @SaveTablesButtonPushed, true);
            app.SaveTablesButton.Position = [55 8 100 22];
            app.SaveTablesButton.Text = 'Save Tables';

            % Create SaveDataChkBox
            app.SaveDataChkBox = uicheckbox(app.SaveTabletxtFilesPanel);
            app.SaveDataChkBox.Text = 'Upload Data Table';
            app.SaveDataChkBox.Position = [11 168 121 22];

            % Create SaveLegendChkBox
            app.SaveLegendChkBox = uicheckbox(app.SaveTabletxtFilesPanel);
            app.SaveLegendChkBox.Text = 'Channel Legend';
            app.SaveLegendChkBox.Position = [11 143 110 22];

            % Create SaveSettingsChkBox
            app.SaveSettingsChkBox = uicheckbox(app.SaveTabletxtFilesPanel);
            app.SaveSettingsChkBox.Text = 'Data Settings Specifications';
            app.SaveSettingsChkBox.Position = [11 118 173 22];

            % Create SaveStatsChkBox
            app.SaveStatsChkBox = uicheckbox(app.SaveTabletxtFilesPanel);
            app.SaveStatsChkBox.Text = 'Statistics';
            app.SaveStatsChkBox.Position = [11 93 71 22];

            % Create SaveFrequenciesChkBox
            app.SaveFrequenciesChkBox = uicheckbox(app.SaveTabletxtFilesPanel);
            app.SaveFrequenciesChkBox.Text = 'Passband Frequencies';
            app.SaveFrequenciesChkBox.Position = [11 70 144 22];
            
             % Create TableFileTypeDropDownLabel
            app.TableFileTypeDropDownLabel = uilabel(app.SaveTabletxtFilesPanel);
            app.TableFileTypeDropDownLabel.HorizontalAlignment = 'right';
            app.TableFileTypeDropDownLabel.Position = [33 42 53 22];
            app.TableFileTypeDropDownLabel.FontWeight = 'bold';
            app.TableFileTypeDropDownLabel.Text = 'File Type';

            % Create TableFileTypeDropDown
            app.TableFileTypeDropDown = uidropdown(app.SaveTabletxtFilesPanel);
            app.TableFileTypeDropDown.Items = {'.txt', '.csv', '.dat', '.xls'};
            app.TableFileTypeDropDown.Position = [101 42 100 22];
            app.TableFileTypeDropDown.Value = '.txt';
            
            % Create CreateReportButton
            app.CreateReportButton = uibutton(app.CreateReportTab, 'push');
            app.CreateReportButton.ButtonPushedFcn = createCallbackFcn(app, @CreateReportButtonPushed, true);
            app.CreateReportButton.Position = [326 92 100 22];
            app.CreateReportButton.Text = 'Create Report';

            % Create SaveGraphsPanel
            app.SaveGraphsPanel = uipanel(app.CreateReportTab);
            app.SaveGraphsPanel.TitlePosition = 'centertop';
            app.SaveGraphsPanel.BackgroundColor = [0.8 0.8 0.8];
            app.SaveGraphsPanel.Title = 'Save Graphs';
            app.SaveGraphsPanel.FontWeight = 'bold';
            app.SaveGraphsPanel.Position = [255 226 230 221];

            % Create FilterDataTimeHistoryCheckBox
            app.FilterDataTimeHistoryCheckBox = uicheckbox(app.SaveGraphsPanel);
            app.FilterDataTimeHistoryCheckBox.Text = 'Filter Data Time History';
            app.FilterDataTimeHistoryCheckBox.Position = [9 172 148 22];

            % Create TimeHistoryCheckBox
            app.TimeHistoryCheckBox = uicheckbox(app.SaveGraphsPanel);
            app.TimeHistoryCheckBox.Text = 'Time History';
            app.TimeHistoryCheckBox.Position = [9 147 90 22];

            % Create FourierTransformsCheckBox
            app.FourierTransformsCheckBox = uicheckbox(app.SaveGraphsPanel);
            app.FourierTransformsCheckBox.Text = 'Fourier Transforms';
            app.FourierTransformsCheckBox.Position = [8 122 122 22];

            % Create LaplaceTransformsCheckBox
            app.LaplaceTransformsCheckBox = uicheckbox(app.SaveGraphsPanel);
            app.LaplaceTransformsCheckBox.Text = 'Laplace Transforms';
            app.LaplaceTransformsCheckBox.Position = [8 74 127 22];

            % Create WaveletTransformsCheckBox
            app.WaveletTransformsCheckBox = uicheckbox(app.SaveGraphsPanel);
            app.WaveletTransformsCheckBox.Text = 'Wavelet Transforms';
            app.WaveletTransformsCheckBox.Position = [8 97 127 22];

            % Create FileTypeDropDown_2Label
            app.GraphFileTypeDropDownLabel = uilabel(app.SaveGraphsPanel);
            app.GraphFileTypeDropDownLabel.HorizontalAlignment = 'right';
            app.GraphFileTypeDropDownLabel.FontWeight = 'bold';
            app.GraphFileTypeDropDownLabel.Position = [30 45 55 22];
            app.GraphFileTypeDropDownLabel.Text = 'File Type';

            % Create GraphFileTypeDropDown
            app.GraphFileTypeDropDown = uidropdown(app.SaveGraphsPanel);
            app.GraphFileTypeDropDown.Items = {'.png', '.jpg', '.pdf', '.tif'};
            app.GraphFileTypeDropDown.Position = [100 45 100 22];
            app.GraphFileTypeDropDown.Value = '.png';

            % Create SaveGraphsButton
            app.SaveGraphsButton = uibutton(app.SaveGraphsPanel, 'push');
            app.SaveGraphsButton.ButtonPushedFcn = createCallbackFcn(app, @SaveGraphsButtonPushed, true);
            app.SaveGraphsButton.Position = [66 13 100 22];
            app.SaveGraphsButton.Text = 'Save Graphs';
            
            %% ------------------ FIGURE VISIBILITY -------------------- %%
            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
            
        end
    end 
    
%-------------------------------------------------------------------------%   
    
    methods (Access = public)       % APP CREATION AND DELETION METHODS
 
        %------------------------- CONSTRUCT APP -------------------------%
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

        %-------------------------- DELETE APP --------------------------%
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end 
    
%-------------------------------------------------------------------------%
end
%% -------------------- old functions/ code attempts ------------------- %%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
%             
%             if value == 1
%                 plot(app.UIAxes,app.Filtered_Channels(:,app.EnterNumericTimeChannelEditField.Value),app.Filtered_Channels(:,1),'b');
%                 ch1_Analysis = [1,"Blue",mean(app.Wavedata.ch1), min(app.Wavedata.ch1),max(app.Wavedata.ch1),std(app.Wavedata.ch1)];
%                 row = [app.UITable2.Data;ch1_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             hold(app.UIAxes);
%             if value == 2
%                 plot(app.UIAxes,app.Filtered_Channels(:,app.EnterNumericTimeChannelEditField.Value),app.Filtered_Channels(:,2),'r');
%                 ch2_Analysis = [2,"Red",mean(app.Wavedata.ch2), min(app.Wavedata.ch2),max(app.Wavedata.ch2),std(app.Wavedata.ch2)];
%                 row = [app.UITable2.Data;ch2_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if value == 3
%                 plot(app.UIAxes,app.Filtered_Channels(:,app.EnterNumericTimeChannelEditField.Value),app.Filtered_Channels(:,3),'g');
%                 ch3_Analysis = [3,"Green",mean(app.Wavedata.ch3), min(app.Wavedata.ch3),max(app.Wavedata.ch3),std(app.Wavedata.ch3)];
%                 row = [app.UITable2.Data;ch3_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if value == 4
%                 plot(app.UIAxes,app.Filtered_Channels(:,app.EnterNumericTimeChannelEditField.Value),app.Filtered_Channels(:,4),'k');
%                 ch4_Analysis = [4,"Black",mean(app.Wavedata.ch4), min(app.Wavedata.ch4),max(app.Wavedata.ch4),std(app.Wavedata.ch4)];
%                 row = [app.UITable2.Data;ch4_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if value == 5
%                 plot(app.UIAxes,app.Filtered_Channels(:,app.EnterNumericTimeChannelEditField.Value),app.Filtered_Channels(:,5),'m');
%                 ch5_Analysis = [5,"Pink",mean(app.Wavedata.ch5), min(app.Wavedata.ch5),max(app.Wavedata.ch5),std(app.Wavedata.ch5)];
%                 row = [app.UITable2.Data;ch5_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if value == 6
%                 plot(app.UIAxes,app.Filtered_Channels(:,app.EnterNumericTimeChannelEditField.Value),app.Filtered_Channels(:,6),'c');
%                 ch6_Analysis = [6,"Cyan",mean(app.Wavedata.ch6), min(app.Wavedata.ch6),max(app.Wavedata.ch6),std(app.Wavedata.ch6)];
%                 row = [app.UITable2.Data;ch6_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if value == 7
%                 plot(app.UIAxes,app.Filtered_Channels(:,app.EnterNumericTimeChannelEditField.Value),app.Filtered_Channels(:,7),'color',[0.4940, 0.1840, 0.5560]);
%                 ch7_Analysis = [7,"Purple",mean(app.Wavedata.ch7), min(app.Wavedata.ch7),max(app.Wavedata.ch7),std(app.Wavedata.ch7)];
%                 row = [app.UITable2.Data;ch7_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if value == 8
%                 plot(app.UIAxes,app.Filtered_Channels(:,app.EnterNumericTimeChannelEditField.Value),app.Filtered_Channels(:,8),'color',[0.8500, 0.3250, 0.0980]);
%                 ch8_Analysis = [8,"Orange",mean(app.Wavedata.ch8), min(app.Wavedata.ch8),max(app.Wavedata.ch8),std(app.Wavedata.ch8)];
%                 row = [app.UITable2.Data;ch8_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             if value == 9
%                 plot(app.UIAxes,app.Filtered_Channels(:,app.EnterNumericTimeChannelEditField.Value),app.Filtered_Channels(:,9),'color',[0, 0.5, 0]);
%                 ch9_Analysis = [9,"Dark Green",mean(app.Wavedata.ch9), min(app.Wavedata.ch9),max(app.Wavedata.ch9),std(app.Wavedata.ch9)];
%                 row = [app.UITable2.Data;ch9_Analysis];
%                 app.UITable2.Data = unique(row,'rows');
%             end
%             %%% needs to be fixed, 9 channels hard coded instead of %%%%%%
%             %%% selecting all channels                              %%%%%%%
%             
% %             for w = 1:number_selections
% %                 plot(app.UIAxes,app.filtered_one,w);
% %             end


