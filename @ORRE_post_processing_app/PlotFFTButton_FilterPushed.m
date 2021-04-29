function PlotFFTButton_FilterPushed(app, event)
% <<<<<<< HEAD
%app.SelectIndependentVariableTimeListBox.ItemsData = 1:numel(app.SelectIndependentVariableTimeListBox.Items);
timevalue = app.FilterTimeDropDown.Value;
depvalue = app.DataFilterListBox.Value;
% =======
% filttimevalue = app.FilterTimeDropDown.Value;
% >>>>>>> 818d0e7c5d33b1b920bb909c75d482af3c802950
% 
% app.DataFilterListBox.ItemsData = 1:numel(app.DataFilterListBox.Items);
% depvalue = app.DataFilterListBox.Value;
% 
% <<<<<<< HEAD
%app.FFTvalue = depvalue;
%app.Timevalue = timevalue;

%             if app.FrequencyCheckBox.Value == 1
%                 app.SelectedFrequency = app.DesiredSampleFrequencyEditField.Value;
%                 %pkg.fun.plt_fft(app.Timevalue,app.FFTvalue,app.Wavedata,app.SelectedFrequency);
%                 pkg.fun.plt_fft(filttimevalue,filtdepvalue,app.Wavedata,app.SelectedFrequency);
%             end

if ~isprop(app.Wavedata,'fft')
    app.Wavedata.addprop('fft')
    app.Wavedata.fft.fs = [];
    app.Wavedata.fft.dominant_periods = cell2table(cell(0,2));
    app.Wavedata.fft.dominant_periods.Properties.VariableNames = {'Channel','T_dominant'};
    app.Wavedata.fft.log = {['Log of fft operations performed by user on <',app.Wavedata.filename,'>']} ;
end

[T_dominant,app.Wavedata.fft.fs] =  pkg.fun.plt_fft(timevalue,depvalue,app.Wavedata);


current_ch = app.Wavedata.map(strcat('ch',num2str(depvalue)));
temp_table = cell2table({current_ch,T_dominant});
temp_table.Properties.VariableNames = {'Channel','T_dominant'};
app.Wavedata.fft.dominant_periods = [app.Wavedata.fft.dominant_periods ; temp_table];

app.Wavedata.fft.log{end+1,1} = ['[',datestr(datetime),']',' fft performed on <',...
    current_ch,'> using a sample frequency of ',num2str(app.Wavedata.fft.fs),...
    ' Hz. T_dominant = ',num2str(T_dominant),' s.'];
% =======
% app.Wavedata.addprop(strcat('DominantPeriod',(num2str(filtdepvalue))));
% app.Wavedata.addprop(strcat('FS',(num2str(filtdepvalue))));
% [app.Wavedata.(strcat('DominantPeriod',(num2str(filtdepvalue)))),app.Wavedata.(strcat('FS',(num2str(filtdepvalue))))] =  pkg.fun.plt_fft(filttimevalue,filtdepvalue,app.Wavedata);
% >>>>>>> 818d0e7c5d33b1b920bb909c75d482af3c802950

end
