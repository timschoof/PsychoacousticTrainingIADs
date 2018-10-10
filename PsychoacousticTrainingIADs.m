function varargout = PsychoacousticTrainingIADs(varargin)
%% OBS! I had to resort to hard coding some extra parameters so that the 
%  software can be readily used with different sound cards: line 81
%
% PSYCHOACOUSTICTRAININGIADS MATLAB code for PsychoacousticTrainingIADs.fig
%      PSYCHOACOUSTICTRAININGIADS, by itself, creates a new PSYCHOACOUSTICTRAININGIADS or raises the existing
%      singleton*.
%
%      H = PSYCHOACOUSTICTRAININGIADS returns the handle to a new PSYCHOACOUSTICTRAININGIADS or the handle to
%      the existing singleton*.
%
%      PSYCHOACOUSTICTRAININGIADS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PSYCHOACOUSTICTRAININGIADS.M with the given input arguments.
%
%      PSYCHOACOUSTICTRAININGIADS('Property','Value',...) creates a new PSYCHOACOUSTICTRAININGIADS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PsychoacousticTrainingIADs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PsychoacousticTrainingIADs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PsychoacousticTrainingIADs

% Last Modified by GUIDE v2.5 06-Sep-2018 07:51:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PsychoacousticTrainingIADs_OpeningFcn, ...
                   'gui_OutputFcn',  @PsychoacousticTrainingIADs_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

addpath('..\TransposedIADs');
% addpath('..\NoisySAM');
% addpath('..\Berniotis');

% --- Executes just before PsychoacousticTrainingIADs is made visible.
function PsychoacousticTrainingIADs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PsychoacousticTrainingIADs (see VARARGIN)

% Choose default command line output for PsychoacousticTrainingIADs
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Move the GUI to the center of the screen.
movegui(handles.figure1,'center')
% put all conditions possibilities into box
[tasks, levels]=ReadConditions();
set(handles.Task, 'String', tasks);

contents = cellstr(get(handles.Task,'String')); 
handles.task=contents{1};
set(handles.Level,'String',levels(1));
handles.level=str2double(levels(1));
handles.numExamples=str2double(get(handles.nExamples,'String'));
handles.numTests=str2double(get(handles.nTests,'String'));

%% OBS! Hard coding of any extra args that need to be passed
%handles.ExtraArgsArray = {'usePlayrec', 0, 'RMEslider', 'FALSE','preSilence', 00};
 handles.ExtraArgsArray = {'usePlayrec', 1, 'RMEslider', 'TRUE','preSilence', 0};


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PsychoacousticTrainingIADs wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PsychoacousticTrainingIADs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles)
    varargout{1}='quit';
else
    % Get default command line output from handles structure
    varargout{1} = handles.task;% handles.output;
    %varargout{2} = str2double(get(handles.Level,'String'));
    %varargout{3} = str2double(handles.initial);
end
% The figure can be deleted now
delete(handles.figure1);

% --- Executes on selection change in Task.
function Task_Callback(hObject, eventdata, handles)
% hObject    handle to Task (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Task contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Task
contents = cellstr(get(hObject,'String')); 
handles.task=contents{get(hObject,'Value')};
% guidata(hObject, handles); % Save the updated structure
% now set appropriate level
[tasks, levels]=ReadConditions();
% Hints: get(hObject,'String') returns contents of Level as text
%        str2double(get(hObject,'String')) returns contents of Level as a double
set(handles.Level, 'String', levels(hObject.Value));
handles.level=str2double(levels(hObject.Value));

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Task_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Task (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GiveExamples.
function GiveExamples_Callback(hObject, eventdata, handles)
% hObject    handle to GiveExamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% randomise order
order=[];
while length(order)<handles.numExamples
    order=[order randperm(2)];
end
%% now to the task-specific sections -- set up structure with all the necessary information
% function p=SetUpStructure(task, ExtraArgsArray, level)
p=SetUpStructure(handles.task, handles.ExtraArgsArray, handles.level);

%% Set RME Slider if necessary -- appropriate for all tasks
% function RMEsliderForTraining(p, task);
RMEsliderForTraining(p, handles.task)

for i= 1:handles.numExamples
    p.Order=order(i);
    %% generate the appropriate sounds
    % function [w, wInQuiet, wUntransposed] = GenerateTheTriple(task, p)
    [w, wInQuiet, wUntransposed] = GenerateTheDuple(handles.task, 'Ex', p);
%     if p.Order==1
%         InfoToDisplay= sprintf('To the R');
%     else
%         InfoToDisplay= sprintf('To the L');
%     end
    if p.Order==1
        InfoToDisplay= sprintf('                        To the R');
    else
        InfoToDisplay= sprintf('To the L                         ');
    end
    % function [response,p] = PlayAndReturnResponse2I2AFC(Wave2Play,trial,p)
    responseGUI = PlayAndReturnNoResponse2I2AFC(w,p,InfoToDisplay,order(i));
    % function responseGUI = PlayAndReturnNoResponse2I2AFC(Wave2Play,p,InfoToDisplay,correct)
end
delete(responseGUI);
if p.usePlayrec==1
    if playrec('isInitialised')
        playrec('reset');
    end
end

% --- Executes on button press in TestExamples.
function TestExamples_Callback(hObject, eventdata, handles)
% hObject    handle to TestExamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% randomise order
order=[];
while length(order)<handles.numTests
    order=[order randperm(2)];
end
%% now to the task-specific sections -- set up structure with all the necessary information
% function p=SetUpStructure(task, ExtraArgsArray, level)
p=SetUpStructure(handles.task, handles.ExtraArgsArray, handles.level);

%% Set RME Slider if necessary -- appropriate for all tasks
% function RMEsliderForTraining(p, task);
RMEsliderForTraining(p, handles.task)

correct=0;
GoOrMessageButton('String', 'none')
pause(1)
for i= 1:handles.numTests
    p.Order=order(i);
    %% generate the appropriate sounds
    % function [w, wInQuiet, wUntransposed] = GenerateTheTriple(task, p)
    [w, wInQuiet, wUntransposed] = GenerateTheDuple(handles.task, 'Tst', p);
    InfoToDisplay= sprintf('Now you try',p.Order);
    %  function [response,p] = PlayAndReturnResponse2I2AFC(Wave2Play,trial,p,InfoToDisplay)
    %         if i==1
    %             [response,p] = PlayAndReturnResponse2I2AFC(w,0,p,InfoToDisplay);
    %         end
    [response,p] = PlayAndReturnResponse2I2AFC(w,i,p,InfoToDisplay);
    if p.Order==response
        correct=correct+1;
    end
    % function responseGUI = PlayAndReturnNoResponse2I2AFC(Wave2Play,p,InfoToDisplay,correct)
end
delete(p.responseGUI);
FeedbackTestResults(0, sprintf('You got %d/%d correct = %5.1f%%',correct,handles.numTests,100*correct/handles.numTests));
if p.usePlayrec==1
    if playrec('isInitialised')
        playrec('reset');
    end
end

function nExamples_Callback(hObject, eventdata, handles)
% hObject    handle to nExamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nExamples as text
%        str2double(get(hObject,'String')) returns contents of nExamples as a double
handles.numExamples = str2double(get(hObject,'String'));
guidata(hObject, handles); % Save the updated structure

% --- Executes during object creation, after setting all properties.
function nExamples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nExamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nTests_Callback(hObject, eventdata, handles)
% hObject    handle to nTests (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nTests as text
%        str2double(get(hObject,'String')) returns contents of nTests as a double
handles.numTests = str2double(get(hObject,'String'));
guidata(hObject, handles); % Save the updated structure

% --- Executes during object creation, after setting all properties.
function nTests_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nTests (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Finished.
function Finished_Callback(hObject, eventdata, handles)
% hObject    handle to Finished (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles); % Save the updated structure
uiresume(handles.figure1);

function Level_Callback(hObject, eventdata, handles)
% hObject    handle to Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Level as text
%        str2double(get(hObject,'String')) returns contents of Level as a double
handles.level = str2double(get(hObject,'String'));
guidata(hObject, handles); % Save the updated structure

% --- Executes during object creation, after setting all properties.
function Level_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
