classdef Post_Processing_Draft_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure             matlab.ui.Figure
        TabGroup             matlab.ui.container.TabGroup
        WelcomeTab           matlab.ui.container.Tab
        TextArea             matlab.ui.control.TextArea
        Image                matlab.ui.control.Image
        TimeHistoryStatsTab  matlab.ui.container.Tab
        UploadDataButton     matlab.ui.control.Button
        UITable              matlab.ui.control.Table
        UIAxes               matlab.ui.control.UIAxes
        SelectSensorstoPlotAnalyzeLabel  matlab.ui.control.Label
        SelectSensorstoPlotAnalyzeListBox  matlab.ui.control.ListBox
        PlotAnalyzeButton    matlab.ui.control.Button
        UITable2             matlab.ui.control.Table
        FourierTransformTab  matlab.ui.container.Tab
        Button               matlab.ui.control.Button
        RAOTab               matlab.ui.container.Tab
        LaplaceTransformTab  matlab.ui.container.Tab
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: UploadDataButton
        function UploadDataButtonPushed(app, event)
            %first upload table, user will change to their txt file
            wavedata = readtable("zerodegdata.txt");
            app.UITable.Data = wavedata;
            app.UITable.ColumnName = wavedata.Properties.VariableNames;
            %next, apply the wave probe data columns to the graph
            %depending on the name of your given data, change the name
            %t = table2array(wavedata(:,"Time_Sec_"));
            %wpe = table2array(wavedata(:,"EastWaveProbe_m_"));
            %wpw = table2array(wavedata(:,"WestWaveProbe_m_"));
            %plot(app.UIAxes,t,wpe);
            %note: if the column name has a space, replace it with an
            %underscore when calling it
        end

        % Callback function
        function ListBoxValueChanged(app, event)
            value = app.SelectSensorstoPlotAnalyzeListBox.Value;
            value.Multiselect = 'on';
        end

        % Value changed function: SelectSensorstoPlotAnalyzeListBox
        function SelectSensorstoPlotAnalyzeListBoxValueChanged2(app, event)
            %value = app.SelectSensorstoPlotAnalyzeListBox.Value;
            %this is extra, can't figure out how to delete it
        end

        % Button pushed function: PlotAnalyzeButton
        function PlotAnalyzeButtonPushed(app, event)
            wavedata = readtable("zerodegdata.txt");
            t = table2array(wavedata(:,"Time_Sec_"));
            %file will have to be changed here too
            if(strcmp(app.SelectSensorstoPlotAnalyzeListBox.Value,'East WaveProbe'))
                y = table2array(wavedata(:,"EastWaveProbe_m_"));
                East_Analysis = [mean(y), min(y),max(y),std(y)];
                app.UITable2.Data = East_Analysis;
                plot(app.UIAxes,t,y)
            else if(strcmp(app.SelectSensorstoPlotAnalyzeListBox.Value,'West WaveProbe'))
                a = table2array(wavedata(:,"EastWaveProbe_m_"));
                West_Analysis = [mean(a), min(a),max(a),std(a)];
                app.UITable2.Data = West_Analysis;
                plot(app.UIAxes,t,a)
            else if(strcmp(app.SelectSensorstoPlotAnalyzeListBox.Value,'A WaveProbe'))
                b = table2array(wavedata(:,"WaveProbe_A_m_"));
                A_Analysis = [mean(b), min(b),max(b),std(b)];
                app.UITable2.Data = A_Analysis;
                plot(app.UIAxes,t,b)
            else if(strcmp(app.SelectSensorstoPlotAnalyzeListBox.Value,'B WaveProbe'))
                c = table2array(wavedata(:,"WaveProbe_B_m_"));
                B_Analysis = [mean(c), min(c),max(c),std(c)];
                app.UITable2.Data = B_Analysis;
                plot(app.UIAxes,t,c)
            else if(strcmp(app.SelectSensorstoPlotAnalyzeListBox.Value,'C WaveProbe'))
                d = table2array(wavedata(:,"WaveProbe_C_m_"));
                C_Analysis = [mean(d), min(d),max(d),std(d)];
                app.UITable2.Data = C_Analysis;
                plot(app.UIAxes,t,d)
            else if(strcmp(app.SelectSensorstoPlotAnalyzeListBox.Value,'StringPot1'))
                e = table2array(wavedata(:,"StringPot_1_m_"));
                Str1_Analysis = [mean(e), min(e),max(e), std(e)];
                app.UITable2.Data = Str1_Analysis;
                plot(app.UIAxes,t,e)
            else
                g = table2array(wavedata(:,"StringPot_2_m_"));
                Str2_Analysis = [mean(g), min(g),max(g),std(g)];
                app.UITable2.Data = Str2_Analysis;
                plot(app.UIAxes,t,g)
            end
            end
            end
            end
            end
            end
                    
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
            
        end
    end

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

            % Create TextArea
            app.TextArea = uitextarea(app.WelcomeTab);
            app.TextArea.Position = [12 10 616 437];
            app.TextArea.Value = {'Welcome! '; ''; 'Instructions: '; '- Click on the tabs to complete different analyses'; ''; 'Important Notes:'; '- The textfile in the "readtable" functions must be changed to your specific text or excel file. Make sure your file is saved in the same folder as this app so it can be found.'; ''; 'How to add a function:'; '- instructions here'; ''; ''; ''; ''; ''; ''; ''; ''; ''; ''; ''; ''; '- Jake and Devon '; '(maybe list contact for questions, which can be added to for each person who adds something)'};

            % Create Image
            app.Image = uiimage(app.WelcomeTab);
            app.Image.Position = [358 340 261 153];
            app.Image.ImageSource = 'ORRE.png';

            % Create TimeHistoryStatsTab
            app.TimeHistoryStatsTab = uitab(app.TabGroup);
            app.TimeHistoryStatsTab.Title = 'Time History/Stats';

            % Create UploadDataButton
            app.UploadDataButton = uibutton(app.TimeHistoryStatsTab, 'push');
            app.UploadDataButton.ButtonPushedFcn = createCallbackFcn(app, @UploadDataButtonPushed, true);
            app.UploadDataButton.Position = [269 425 100 22];
            app.UploadDataButton.Text = 'Upload Data';

            % Create UITable
            app.UITable = uitable(app.TimeHistoryStatsTab);
            app.UITable.ColumnName = {'Column 1'; 'Column 2'; 'Column 3'; 'Column 4'; 'Column 5'; 'Column 6'; 'Column 7'; 'Column 8'; 'Column 9'};
            app.UITable.RowName = {};
            app.UITable.Position = [39 308 560 110];

            % Create UIAxes
            app.UIAxes = uiaxes(app.TimeHistoryStatsTab);
            title(app.UIAxes, 'Time History')
            xlabel(app.UIAxes, 'Time')
            ylabel(app.UIAxes, 'Wave Probe (m)')
            app.UIAxes.ColorOrder = [0 0.4471 0.7412;0.851 0.3255 0.098;0.9294 0.6941 0.1255;0.4941 0.1843 0.5569;0.4667 0.6745 0.1882;0.302 0.7451 0.9333;0.6353 0.0784 0.1843];
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [39 9 560 204];

            % Create SelectSensorstoPlotAnalyzeLabel
            app.SelectSensorstoPlotAnalyzeLabel = uilabel(app.TimeHistoryStatsTab);
            app.SelectSensorstoPlotAnalyzeLabel.BackgroundColor = [1 1 1];
            app.SelectSensorstoPlotAnalyzeLabel.HorizontalAlignment = 'center';
            app.SelectSensorstoPlotAnalyzeLabel.Position = [39 236 97 42];
            app.SelectSensorstoPlotAnalyzeLabel.Text = {'Select Sensors '; 'to Plot/Analyze:'};

            % Create SelectSensorstoPlotAnalyzeListBox
            app.SelectSensorstoPlotAnalyzeListBox = uilistbox(app.TimeHistoryStatsTab);
            app.SelectSensorstoPlotAnalyzeListBox.Items = {'East WaveProbe', 'West WaveProbe', 'A WaveProbe', 'B WaveProbe', 'C WaveProbe', 'StringPot1', 'StringPot2'};
            app.SelectSensorstoPlotAnalyzeListBox.ValueChangedFcn = createCallbackFcn(app, @SelectSensorstoPlotAnalyzeListBoxValueChanged2, true);
            app.SelectSensorstoPlotAnalyzeListBox.Position = [135 221 114 72];
            app.SelectSensorstoPlotAnalyzeListBox.Value = 'East WaveProbe';

            % Create PlotAnalyzeButton
            app.PlotAnalyzeButton = uibutton(app.TimeHistoryStatsTab, 'push');
            app.PlotAnalyzeButton.ButtonPushedFcn = createCallbackFcn(app, @PlotAnalyzeButtonPushed, true);
            app.PlotAnalyzeButton.Position = [270 246 100 22];
            app.PlotAnalyzeButton.Text = 'Plot/Analyze';

            % Create UITable2
            app.UITable2 = uitable(app.TimeHistoryStatsTab);
            app.UITable2.ColumnName = {'Mean'; 'Min'; 'Max'; 'Std Dev'};
            app.UITable2.RowName = {};
            app.UITable2.Position = [393 227 191 61];

            % Create FourierTransformTab
            app.FourierTransformTab = uitab(app.TabGroup);
            app.FourierTransformTab.Title = 'Fourier Transform';

            % Create Button
            app.Button = uibutton(app.FourierTransformTab, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.Position = [95 376 100 22];

            % Create RAOTab
            app.RAOTab = uitab(app.TabGroup);
            app.RAOTab.Title = 'RAO';

            % Create LaplaceTransformTab
            app.LaplaceTransformTab = uitab(app.TabGroup);
            app.LaplaceTransformTab.Title = 'Laplace Transform';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Post_Processing_Draft_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

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