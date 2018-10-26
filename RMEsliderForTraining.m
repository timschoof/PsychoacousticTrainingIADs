function RMEsliderForTraining(p, task)
%% Set RME Slider if necessary -- appropriate for all tasks
if strcmp(p.RMEslider,'TRUE')
    if strcmp(task, 'TransposedITDs') ||  strcmp(task, 'TransposedILDs') ||  strcmp(task, 'LoFrqILDs')
        RMEsettingsFile=fullfile('..\TransposedIADs', 'RMEsettings.csv');
    else
        RMEsettingsFile=fullfile(['..\' task], 'RMEsettings.csv');
    end
    PrepareRMEslider(RMEsettingsFile,p.dBSPL);
end
