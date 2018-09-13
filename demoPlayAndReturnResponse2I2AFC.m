%% demoPlayAndReturnResponse2I2AFC
addpath('..\TransposedIADs')
%%
clear
close all
IAD='ILD';
% TaskFormat='3I-3AFC';
TaskFormat='2I-2AFC';
TranspositionFreq = 4000;
%TranspositionFreq = 0;
% ModulationRate = 500;
ModulationRate = 125;
VolumeSettingsFile='VolumeSettings4kHzILD.txt';
%VolumeSettingsFile='VolumeSettings500HzILD.txt';

if strcmp(IAD, 'ITD')
    ITD = 650; % in us -- 12500 is 1/2 period for 40 Hz modulation
    starting_SNR=20*log10(ITD/100);
    START_change_dB=6;
    MIN_change_dB = 1;
else
    starting_SNR=3;
    MIN_change_dB = 0.25;
    START_change_dB=1;
    MIN_SNR_dB=0.25; % minimal difference: for ILD only
    % Remember, it's twice this!
    InitialDescentMinimum=.5;
end

p=TransposedIADsParseArgs('SR', 'starting_SNR',starting_SNR, ...
    'TranspositionFreq', TranspositionFreq, ...
    'ModulationRate', ModulationRate, ...
    'TaskFormat', TaskFormat, ...
    'MaximalDifference', 1, 'IAD', IAD, ...
    'START_change_dB', START_change_dB, 'MIN_change_dB', MIN_change_dB, ...
    'usePlayrec', 0, 'RMEslider', 'FALSE', ...
    'trackAbsThreshold', 0, 'GoButton', 1, ...
    'BackNzLevel', -100, ...
    'ModulationPhase', 0, ...
    'VolumeSettingsFile', VolumeSettingsFile, 'LongMaskerNoise', 1500,...
    'PlotTrackFile', 1, 'outputAllWavs', 1, 'DEBUG', 0);

%% read in all the necessary faces for feedback
if ~strcmp(p.FeedBack, 'None')
    FacesDir = fullfile('Faces',p.FacePixDir,'');
    SmileyFace = imread(fullfile(FacesDir,'smile24.bmp'),'bmp');
    WinkingFace = imread(fullfile(FacesDir,'wink24.bmp'),'bmp');
    FrownyFace = imread(fullfile(FacesDir,'frown24.bmp'),'bmp');
    %ClosedFace = imread(fullfile(FacesDir,'closed24.bmp'),'bmp');
    %OpenFace = imread(fullfile(FacesDir,'open24.bmp'),'bmp');
    %BlankFace = imread(fullfile(FacesDir,'blank24.bmp'),'bmp');
    p.CorrectImage=SmileyFace;
    p.IncorrectImage=FrownyFace;
end

%% generate the appropriate sounds
[w, wInQuiet, wUntransposed]=GenerateIADduple(p);
%% ensure no overload
% function [OutWave, flag] = NoClipStereo(InWave,message)
[w, flag] = NoClipStereo(w);
InfoToDisplay= sprintf('Now you try');
% function [response,p] = PlayAndReturnResponse3I3AFC(Wave2Play,trial,p)
[response,p] = PlayAndReturnResponse2I2AFC(w,1,p,InfoToDisplay);
close
%delete(findobj('Type','figure'));
return
