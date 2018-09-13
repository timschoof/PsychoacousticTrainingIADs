function [response,p] = PlayAndReturnResponse2I2AFC(Wave2Play,trial,p,InfoToDisplay)
%
% varargins
%
% 1 OneSoundDuration (ms)
% 2 ISI (ms)
% 3 CorrectAnswer
% 4 CorrectImage
% 5 IncorrectImage
% 6 trial

% OneSoundDuration=max(p.NoiseDuration,p.ToneDuration); % for pulsed
% background noise
OneSoundDuration=max(p.SignalDuration);
if trial==1
    p.responseGUI = ResponsePadXtra2I2AFC(OneSoundDuration,p.ISI,p.Order,p.CorrectImage,p.IncorrectImage,0,InfoToDisplay);
    pause(0.5);
end

% intialize playrec if necessary
if p.usePlayrec == 1 % if you're using playrec
    if playrec('isInitialised')
        playrec('reset');
    end
    playrec('init', p.SampFreq, p.playDeviceInd, p.recDeviceInd);
    playrec('play', Wave2Play, [3,4]);
else
    playEm = audioplayer(Wave2Play,p.SampFreq);
    play(playEm);
end

% IntervalIndicators(p.responseGUI, OneSoundDuration,p.ISI,p.initialDelay)
response = ResponsePadXtra2I2AFC(OneSoundDuration,p.ISI,p.Order,p.CorrectImage,p.IncorrectImage,trial,InfoToDisplay);



return
trial=2;
playEm = audioplayer(Wave2Play,SampFreq);
play(playEm);
IntervalIndicators(responseGUI, OneSoundDuration,ISI)
response = ResponsePad3I3AFC(Wave2Play,SampFreq,OneSoundDuration,ISI,CorrectAnswer,CorrectImage,IncorrectImage,trial)


return

