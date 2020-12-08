function SIVTLListBoxValueChanged(app, event)

% Assign FFT time and dependent variable channel numbers:
app.SelectIndependentVariableTimeListBox.ItemsData = 1:numel(app.SelectIndependentVariableTimeListBox.Items);
app.Timevalue = app.SelectIndependentVariableTimeListBox.Value;
 
% app.SelectDependentVariableListBox.ItemsData = 1:numel(app.SelectDependentVariableListBox.Items);
% app.FFTvalue = app.SelectDependentVariableListBox.Value;

% Update start and end time field values; default to entire length:
Time = app.Wavedata.(strcat('ch',num2str(app.Timevalue)));
app.StartTimeEditField.Value = Time(1);
app.EndTimeEditField.Value = Time(end);
end

