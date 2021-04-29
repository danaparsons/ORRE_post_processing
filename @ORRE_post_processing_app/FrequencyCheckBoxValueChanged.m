function FrequencyCheckBoxValueChanged(app, event)
value = app.FrequencyCheckBox.Value;
if app.FrequencyCheckBox.Value
    app.DesiredSampleFrequencyEditField.Editable = 'on';
else
    app.DesiredSampleFrequencyEditField.Editable = 'off';
end
end