function varargout = Razr(varargin)
% Razr MATLAB code for Razr.fig
%      Razr, by itself, creates a new Razr or raises the existing
%      singleton*.
%
%      H = Razr returns the handle to a new Razr or the handle to
%      the existing singleton*.
%
%      Razr('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Razr.M with the given input arguments.
%
%      Razr('Property','Value',...) creates a new Razr or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Razr_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Razr_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Razr

% Last Modified by GUIDE v2.5 29-Jun-2017 12:32:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Razr_OpeningFcn, ...
    'gui_OutputFcn',  @Razr_OutputFcn, ...
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
% --- Executes just before Razr is made visible.

function Razr_OpeningFcn(hObject, eventdata, handles, varargin)
init_GUI(hObject, eventdata, handles, varargin);

function varargout = Razr_OutputFcn(hObject, eventdata, handles)

function axes1_CreateFcn(hObject, eventdata, handles)
init_room_axes(hObject, eventdata, handles);

function edtx_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edty_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edtz_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit1freq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit2freq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit3freq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit4freq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit5freq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit1dir_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit2dir_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider1dir_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider2dir_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function menu1xmat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function menu2xmat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function menu1ymat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function menu2ymat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function menu1zmat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function menu2zmat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit1globalt60_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[0.871  0.49 0.0]);
end
function slider1globalt60_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function pushbutton1load_Callback(hObject, eventdata, handles)
%methode 1
sequential_computation(hObject, eventdata, handles);%WORK FINE !
%methode 2
%sequential_realtime(hObject, eventdata, handles);%
%   uncoment this line to manually upload the song
function pushbutton1save_Callback(hObject, eventdata, handles)
saveconf(hObject, eventdata, handles);

function pushbutton1play_Callback(hObject, eventdata, handles)
playandpause(handles);

function pushbuttonrestart_Callback(hObject, eventdata, handles)
 set_audio_pointer_to_zero(handles);

function pushbutton1sub_Callback(hObject, eventdata, handles)
change_hrtf_subject(hObject, eventdata, handles);

function checkbox1mater_Callback(hObject, eventdata, handles)


function slider1dir_Callback(hObject, eventdata, handles)
upload_dir(get(hObject,'Value'),1);

function slider2dir_Callback(hObject, eventdata, handles)
upload_dir(get(hObject,'Value'),2);

function edtx_Callback(hObject, eventdata, handles)
extern_resize();

function edty_Callback(hObject, eventdata, handles)
extern_resize();

function edtz_Callback(hObject, eventdata, handles)
set(handles.axes1,'ZLim',[0,str2double(get(hObject,'String'))]);
h = guidata(gcf);
h.room.boxsize(3)=str2double(get(hObject,'String'));
p = get(0,'UserData');
p.fig.chg=1;
set(0,'Userdata',p);
guidata(gcf,h);
function edit1dir_Callback(hObject, eventdata, handles)
in=str2double(get(hObject,'String'));
if(isreal(in))
    upload_dir(in,1);
else
    set(hObject,'String',sprintf('%f',get(handles.slider1dir,'Value')));
end
function edit2dir_Callback(hObject, eventdata, handles)
in=str2double(get(hObject,'String'));
if(isreal(in))
    upload_dir(in,2);
else
    set(hObject,'String',sprintf('%f',get(handles.slider2dir,'Value')));
end

function Razr_1_Callback(hObject, eventdata, handles)
% hObject    handle to parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
% %	Character: character interpretation of the key(s) that was pressed
% %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% % handles    structure with handles and user data (see GUIDATA)
addCurrPressKey(eventdata,handles);%add the current press keys in the array of active keys


% --- Executes on key release with focus on figure1 or any of its controls.
function figure1_WindowKeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
rm_released_key(eventdata,handles);%remove the released keys of th active keys array.

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on selection change in menumat.
function menu1xmat_Callback(hObject, eventdata, handles)
usemat=logical(get(handles.checkbox1mater,'Value'));
if(usemat)
    upload_mater();
end
function menu2xmat_Callback(hObject, eventdata, handles)
usemat=logical(get(handles.checkbox1mater,'Value'));
if(usemat)
    upload_mater();
end
function menu1ymat_Callback(hObject, eventdata, handles)
usemat=logical(get(handles.checkbox1mater,'Value'));
if(usemat)
    upload_mater();
end
function menu2ymat_Callback(hObject, eventdata, handles)
usemat=logical(get(handles.checkbox1mater,'Value'));
if(usemat)
    upload_mater();
end
function menu1zmat_Callback(hObject, eventdata, handles)
usemat=logical(get(handles.checkbox1mater,'Value'));
if(usemat)
    upload_mater();
end
function menu2zmat_Callback(hObject, eventdata, handles)

usemat=logical(get(handles.checkbox1mater,'Value'));
if(usemat)
    upload_mater();
end

function pushbuttonparaminst_Callback(hObject, eventdata, handles)
h=guidata(gcf);
guidata(gcf,h);
function Parameters_Callback(hObject, eventdata, handles)
function pushbuttonparam_Callback(hObject, eventdata, handles)

h=guidata(gcf);
h.Parameters.Position=h.pushbuttonparam.Position(1:2);
pannelpos=get(h.uipanelparam,'Position');
buttonpos=get(hObject,'Position');
posmenu=[buttonpos(1)+pannelpos(1),pannelpos(2)+buttonpos(2)-buttonpos(4)];
h.Parameters.Visible = 'on';
set(h.Parameters,'Position',posmenu);
guidata(gcf,h);


function Reverbfreq_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
if(isfield(p,'parhand'))
    
else
    parameters;
    p = get(0,'UserData');
    set(0,'Userdata',p);
end


function rescale_Callback(hObject, eventdata, handles)

if(strcmp(handles.rescale.Checked,'on'))
    handles.rescale.Checked='off';
else
    handles.rescale.Checked='on';
end



function normalization_Callback(hObject, eventdata, handles)
if(strcmp(handles.normalization.Checked,'on'))
    handles.normalization.Checked='off';
else
    handles.normalization.Checked='on';
end
guidata(gcf, handles);


function edit1globalt60_Callback(hObject, eventdata, handles)
in=str2double(get(hObject,'String'));
if(isreal(in) && in >0.01)
    upload_paramGUIt60(in,'globalmean',0);
else
    set(hObject,'String',sprintf('%f',get(handles.slider1globalt60,'Value')));
end

function slider1globalt60_Callback(hObject, eventdata, handles)
upload_paramGUIt60(get(hObject,'Value'),'globalmean',0);






function figure1_DeleteFcn(hObject, eventdata, handles)
handles.receiver.coord.Deletable = true;


function Untitled_5_Callback(hObject, eventdata, handles)


function Untitled_6_Callback(hObject, eventdata, handles)


function axes1_DeleteFcn(hObject, eventdata, handles)



function Untitled_7_Callback(hObject, eventdata, handles)


function Metho_Callback(hObject, eventdata, handles)
switch handles.computmethod
    case 'seq'
        set(handles.seqmenu,'Checked','On');
        set(handles.parmenu,'Checked','Off');
    case 'para'
        set(handles.seqmenu,'Checked','Off');
        set(handles.parmenu,'Checked','On');
end
switch handles.playmethod
    case 'realtime'
        set(handles.realtmenu,'Checked','On');
    case 'notrealtime'
        set(handles.realtmenu,'Checked','Off');
        
end

function Metho_CreateFcn(hObject, eventdata, handles)
    handles.seqmenu = uimenu('Parent',hObject,'Label','Sequential','Callback',@method);
    handles.parmenu = uimenu('Parent',hObject,'Label','Parallel','Callback',@method);
    handles.realtmenu = uimenu('Parent',hObject,'Label','Realtime','Callback',@method,'Separator','on');
    guidata(gcf,handles);

    function method(source,callbackdata)
        h=guidata(gcf);
        switch source.Label
            case 'Sequential'
                h.computmethod='seq';
            case 'Parallel'
                h.computmethod='para';
                h.parrapool=gcp;
            case 'Realtime'
                switch h.playmethod
                    case 'realtime'
                    h.playmethod='notrealtime';
                    set(h.pushbutton1load,'Visible','On');
                    case 'notrealtime'
                    h.playmethod='realtime';
                    set(h.pushbutton1load,'Visible','Off');
                end
        end
        guidata(gcf,h);


function Untitled_1_Callback(hObject, eventdata, handles)


function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
mouse_wheel_zoom(eventdata,handles);



function elevation_Callback(hObject, eventdata, handles)
change_position_box(handles);


function figure1_CloseRequestFcn(hObject, eventdata, handles)
if(isfield(handles,'t'))
    stop(handles.t);
end
if(playrec('isInitialised'))
    playrec('reset');
    
end
% Hint: delete(hObject) closes the figure
delete(hObject);


function processinfo_Callback(hObject, eventdata, handles)


function driverchoose_Callback(hObject, eventdata, handles)
handles.driverID=chooseaudiodrivers();
guidata(gcf,handles);
function saveroom_Callback(hObject, eventdata, handles)
saveroom(handles);

function loadroom_Callback(hObject, eventdata, handles)
loadroom(handles);
