function varargout = parameters(varargin)
% PARAMETERS MATLAB code for parameters.fig
%      PARAMETERS, by itself, creates a new PARAMETERS or raises the existing
%      singleton*.
%
%      H = PARAMETERS returns the handle to a new PARAMETERS or the handle to
%      the existing singleton*.
%
%      PARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAMETERS.M with the given input arguments.
%
%      PARAMETERS('Property','Value',...) creates a new PARAMETERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before parameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to parameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help parameters

% Last Modified by GUIDE v2.5 07-Jul-2017 15:20:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @parameters_OpeningFcn, ...
    'gui_OutputFcn',  @parameters_OutputFcn, ...
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


% --- Executes just before parameters is made visible.
function parameters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to parameters (see VARARGIN)

% Choose default command line output for parameters
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

p = get(0,'UserData');
set(handles.slider2globalt60,'Max',p.fig.maxt60);
set(handles.slider2globalt60,'Value',p.fig.globalt60);
set(handles.edit2globalt60,'String',sprintf('%f',p.fig.globalt60));
for i= 1:5
    editname=sprintf('edit%dt60',i);
    set(handles.(editname),'String',sprintf('%f',p.fig.room.t60(i)));
end
handles.rvrb_trf{5}=[];
Ylim=[0,p.fig.maxt60];
set(gca,'YLim',[0,p.fig.maxt60]);
for i= 1:5
    handles.rvrb_trf{i}=impoint(handles.axes2,p.fig.room.freq(i),p.fig.room.t60(i));
    setColor(handles.rvrb_trf{i},'black');
    handles.rvrb_trf{i}.Deletable = false;
    param_clbk= @(pos) clbk_impoint_param(handles.rvrb_trf{i},pos,i);
    Xlim=[p.fig.room.freq(i),p.fig.room.freq(i)];
    fcn = makeConstrainToRectFcn('impoint',Xlim,Ylim);
    addNewPositionCallback(handles.rvrb_trf{i},param_clbk);
    setPositionConstraintFcn(handles.rvrb_trf{i},fcn);
end


handles.xp = 0:p.fig.room.freq(5)/100:p.fig.room.freq(5);
handles.yp = interp1(p.fig.room.freq,p.fig.room.t60,handles.xp ,'pchip');
handles.plt=plot(handles.xp,handles.yp,'-','parent',handles.axes2);
guidata(hObject, handles);
guidata(gcf,handles);
p.parhand=handles;
p.parhand.defop=get_default_options;
set(0,'Userdata',p);
init_parameters();


% refreshdata


% UIWAIT makes parameters wait for user response (see UIRESUME)
% uiwait(handles.parameters);
function clbk_impoint_param(h,pos,i)
%p = get(0,'UserData');
upload_t60_elem(pos(2),'',i);

function upload_t60_elem(value,type,indice)
    
p = get(0,'UserData');
 if (p.upload==1)
 else
    p.upload=1;
    set(0,'Userdata',p);
    p = get(0,'UserData');
    %h=guidata(gcf);
    inf_flg=0;
    if(value<0.01)
        value=0.01;
    elseif(value>p.fig.maxt60)
        upload_t60_max(value);
    end
    if(strcmp(type,'globalmean'))
        
        m=mean(p.fig.room.t60);

        for i= 1:5
            editname=sprintf('edit%dt60',i);
            new_val=p.fig.room.t60(i)*value/m;
            if(new_val>p.fig.maxt60)
                upload_t60_max(new_val);
            elseif (new_val<0.01)
                new_val=0.01;
                inf_flg=1;
            end
            set(p.parhand.(editname),'String',sprintf('%f',new_val));
            p.fig.room.t60(i)=new_val;
            setPosition(p.parhand.rvrb_trf{i},p.fig.room.freq(i),new_val);
            setPosition(p.fig.rvrb_trf{i},p.fig.room.freq(i),new_val);
        end
        val=mean(p.fig.room.t60);
        p.fig.globalt60=val;
        set(p.fig.slider1globalt60,'Value',val);
        set(p.parhand.slider2globalt60,'Value',value);
        set(p.fig.edit1globalt60,'String',sprintf('%f',val));
        set(p.parhand.edit2globalt60,'String',sprintf('%f',val));
        if(inf_flg)
            p.parhand.yp = interp1(p.fig.room.freq,p.fig.room.t60,p.parhand.xp ,'pchip');
            p.fig.yp = p.parhand.yp;
        else
        p.parhand.yp=p.parhand.yp*val/m;
        p.fig.yp=p.parhand.yp;
        end
        set(p.parhand.plt,'ydata',p.parhand.yp);
        set(p.fig.plt,'ydata',p.fig.yp);
    else
        editname=sprintf('edit%dt60',indice);
        set(p.parhand.(editname),'String',sprintf('%f',value));
        p.fig.room.t60(indice)=value;
        m=mean(p.fig.room.t60);
        if(m>p.fig.maxt60)
            upload_t60_max(m);
        end
        p.parhand.yp = interp1(p.fig.room.freq,p.fig.room.t60,p.parhand.xp ,'pchip');
        p.fig.yp = p.parhand.yp;
        set(p.parhand.plt,'ydata',p.parhand.yp);
        set(p.fig.plt,'ydata',p.fig.yp);
        setPosition(p.parhand.rvrb_trf{indice},p.fig.room.freq(indice),value);
        setPosition(p.fig.rvrb_trf{indice},p.fig.room.freq(indice),value);
        set(p.parhand.slider2globalt60,'Value',m);
        set(p.parhand.edit2globalt60,'String',sprintf('%f',m));
        set(p.fig.slider1globalt60,'Value',m);
        set(p.fig.edit1globalt60,'String',sprintf('%f',m));
        
    end
    p.fig.chg=1;
    p.upload=0;
    %guidata(gcf, h);
    %h=guidata(gcf);
    %p.parhand=h;
    set(0,'Userdata',p);
end
function upload_t60_max(value)
p = get(0,'UserData');
set(p.parhand.slider2globalt60,'Max',value*1.1);
set(p.fig.slider1globalt60,'Max',value*1.1);
p.fig.maxt60=1.1*value;
set(gca,'YLim',[0,value*1.1]);
set(0,'Userdata',p);




% --- Outputs from this function are returned to the command line.
function varargout = parameters_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function slider2globalt60_Callback(hObject, eventdata, handles)
upload_t60_elem(get(hObject,'Value'),'globalmean',0);
function edit2globalt60_Callback(hObject, eventdata, handles)
upload_t60_elem(str2double(get(hObject,'String')),'globalmean',0);
function slider1t60_Callback(hObject, eventdata, handles)
% upload_t60_elem(get(hObject,'Value'),'',1);
% function slider2t60_Callback(hObject, eventdata, handles)
% upload_t60_elem(get(hObject,'Value'),'',2);
% function slider3t60_Callback(hObject, eventdata, handles)
% upload_t60_elem(get(hObject,'Value'),'',3);
% function slider4t60_Callback(hObject, eventdata, handles)
% upload_t60_elem(get(hObject,'Value'),'',4);
% function slider5t60_Callback(hObject, eventdata, handles)
% upload_t60_elem(get(hObject,'Value'),'',5);
function edit1t60_Callback(hObject, eventdata, handles)
upload_t60_elem(str2double(get(hObject,'String')),'',1);
function edit2t60_Callback(hObject, eventdata, handles)
upload_t60_elem(str2double(get(hObject,'String')),'',2);
function edit3t60_Callback(hObject, eventdata, handles)
upload_t60_elem(str2double(get(hObject,'String')),'',3);
function edit4t60_Callback(hObject, eventdata, handles)
upload_t60_elem(str2double(get(hObject,'String')),'',4);
function edit5t60_Callback(hObject, eventdata, handles)
upload_t60_elem(str2double(get(hObject,'String')),'',5);





% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.



% --- Executes during object creation, after setting all properties.
function edit1t60_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1t60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit2t60_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit3t60_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit4t60_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit5t60_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slider2globalt60_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function edit2globalt60_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function parameters_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p = get(0,'UserData');
p = rmfield(p,'parhand');
set(0,'Userdata',p);


function edit31_Callback(hObject, eventdata, handles)


function edit31_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit32_Callback(hObject, eventdata, handles)


function edit32_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit33_Callback(hObject, eventdata, handles)


function edit33_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkbox26_Callback(hObject, eventdata, handles)


function checkboxismbanpass_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.ism_enableBP=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function checkboxism_hiord_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.ism_hiord_always_valid=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);


function edit30_Callback(hObject, eventdata, handles)


function edit30_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkboxspecularreflection_Callback(hObject, eventdata, handles)

p = get(0,'UserData');
p.fig.op.ism_diffu_specu_ratio=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);
function checkboxdiffracfilter_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.ism_enableDiffrFilt=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function checkboxrandompos_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.ism_randFactorsInCart=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function checkboxfdnena_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.ism_enableBP=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function popupmenu9_Callback(hObject, eventdata, handles)


function popupmenu9_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkbox7_Callback(hObject, eventdata, handles)


function checkbox8_Callback(hObject, eventdata, handles)


function checkbox9_Callback(hObject, eventdata, handles)


function checkbox10_Callback(hObject, eventdata, handles)


function checkbox11_Callback(hObject, eventdata, handles)


function checkbox12_Callback(hObject, eventdata, handles)


function checkbox13_Callback(hObject, eventdata, handles)


function checkbox14_Callback(hObject, eventdata, handles)


function popupmenu10_Callback(hObject, eventdata, handles)


function popupmenu10_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu11_Callback(hObject, eventdata, handles)


function popupmenu11_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editnumdelay_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
in=str2double(str);
if(isreal(in))
    if(~isinteger(in))
        in=round(in);
        set(hObject,'String',sprintf('%d',in));
    end
    p.fig.op.fdn_numDelays=in;
elseif (strcmp('',str))
    p.fig.op.fdn_numDelays=12;
    set(hObject,'String',sprintf('%d',p.fig.op.fdn_numDelays));

else
    set(hObject,'String',sprintf('%d',p.fig.op.fdn_numDelays));
end
p.fig.chg=1;set(0,'Userdata',p);


function editnumdelay_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit26_Callback(hObject, eventdata, handles)


function edit26_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editismorder_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
in=str2num(str);
if(isreal(in))
    if(~isinteger(in))
        in=round(in);
        set(hObject,'String',sprintf('%d',in));
    end
    p.fig.op.ism_order=in;
elseif (strcmp('',str))
    p.fig.op.ism_order=3;
    set(hObject,'String',sprintf('%d',p.fig.op.ism_order));
else
    set(hObject,'String',sprintf('%d',p.fig.op.ism_order));
end
p.fig.chg=1;set(0,'Userdata',p);

function editismorder_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkboxismonly_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.ism_only=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function checkboxismreflecfilter_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.ism_enableReflFilt=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function checkboxtimesspread_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.ism_enable_timespread=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function edit29_Callback(hObject, eventdata, handles)


function edit29_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkbox15_Callback(hObject, eventdata, handles)


function checkboxairabsoprtion_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.ism_enableAirAbsFilt=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function popupmenurtesti_Callback(hObject, eventdata, handles)


function popupmenurtesti_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenuspmodes_Callback(hObject, eventdata, handles)


function popupmenuspmodes_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenurendermd_Callback(hObject, eventdata, handles)


function popupmenurendermd_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu4_Callback(hObject, eventdata, handles)


function popupmenu4_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenuwarpmth_Callback(hObject, eventdata, handles)

p = get(0,'UserData');
str=get(hObject,'String');
p.fig.op.array_render=str(get(hObject,'Value'));
p.fig.chg=1;set(0,'Userdata',p);
function popupmenuwarpmth_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenufiltmeth_Callback(hObject, eventdata, handles)


function popupmenufiltmeth_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenudifffiltmeth_Callback(hObject, eventdata, handles)


function popupmenudifffiltmeth_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkboxpseudoradom_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.pseudoRand=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function checkbox4_Callback(hObject, eventdata, handles)


function checkbox3_Callback(hObject, eventdata, handles)


function popupmenu8_Callback(hObject, eventdata, handles)


function popupmenu8_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkboxseedshift_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.seed_shift=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function editfs_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
in=str2double(str);
if(isreal(in))
    p.fig.op.fs=round(in);
elseif (strcmp('',str))
    p.fig.op.fs=44100;
    set(hObject,'String',sprintf('%f',p.fig.op.fs));

else
    set(hObject,'String',sprintf('%f',p.fig.op.fs));
end
p.fig.chg=1;set(0,'Userdata',p);


function editfs_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edittlen_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
in=str2double(str);
if(isreal(in))
    p.fig.op.tlen=round(in);
elseif (strcmp('',str))
    p.fig.op.tlen=[];
     set(hObject,'String',sprintf('%f',p.fig.op.tlen));
else
    set(hObject,'String',sprintf('%f',p.fig.op.tlen));
end
p.fig.chg=1;set(0,'Userdata',p);

function edittlen_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editspl0db_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
in=str2double(str);
if(isreal(in))
    p.fig.op.SPL_at_0dBFS=(in);
elseif (strcmp('',str))
    p.fig.op.SPL_at_0dBFS=100;
   set(hObject,'String',sprintf('%f',p.fig.op.SPL_at_0dBFS));
else
    set(hObject,'String',sprintf('%f',p.fig.op.SPL_at_0dBFS));
end
p.fig.chg=1;set(0,'Userdata',p);

function editspl0db_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editsplsource_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
in=str2double(str);
if(isreal(in))
    p.fig.op.SPL_source=(in);
elseif (strcmp('',str))
    p.fig.op.SPL_source=100;
   set(hObject,'String',sprintf('%f',p.fig.op.SPL_source));

else
    set(hObject,'String',sprintf('%f',p.fig.op.SPL_source));

end
p.fig.chg=1;set(0,'Userdata',p);

function editsplsource_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edittlenmax_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
in=str2double(str);
if(isreal(in))
    p.fig.op.tlen_max=in;
elseif (strcmp('',str))
    p.fig.op.tlen_max=20;
    set(hObject,'String',sprintf('%f',p.fig.op.tlen_max));

else
    set(hObject,'String',sprintf('%f',p.fig.op.tlen_max));
end
p.fig.chg=1;set(0,'Userdata',p);

function edittlenmax_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editx1abs_Callback(hObject, eventdata, handles)


function editx1abs_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editx2abs_Callback(hObject, eventdata, handles)


function editx2abs_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edity1abs_Callback(hObject, eventdata, handles)


function edity1abs_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edity2abs_Callback(hObject, eventdata, handles)


function edity2abs_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editz1abs_Callback(hObject, eventdata, handles)


function editz1abs_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editz2abs_Callback(hObject, eventdata, handles)


function editz2abs_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editrandomjitter_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
in=str2double(str);
if(isreal(in))
    p.fig.op.ism_rand_start_order=in;
elseif (strcmp('',str))
    p.fig.op.ism_rand_start_order=0;
    set(hObject,'String',sprintf('%d',p.fig.op.ism_rand_start_order));
else
    set(hObject,'String',sprintf('%d',p.fig.op.ism_rand_start_order));
end
p.fig.chg=1;set(0,'Userdata',p);

function editrandomjitter_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editrismeflecgain_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
in=str2double(str);
if(isreal(in))
    p.fig.op.ism_refl_gain=in;
elseif (strcmp('',str))
    p.fig.op.ism_refl_gain=0;
    set(hObject,'String',sprintf('%d',p.fig.op.ism_refl_gain));
else
    set(hObject,'String',sprintf('%d',p.fig.op.ism_refl_gain));
end
p.fig.chg=1;set(0,'Userdata',p);

function editrismeflecgain_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editismrandompos_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
in=str2double(str);
if(isreal(in))
    p.fig.op.ism_ISposRandFactor=in;
elseif (strcmp('',str))
    p.fig.op.ism_ISposRandFactor=0;
    set(hObject,'String',sprintf('%d',p.fig.op.ism_ISposRandFactor));
else
    set(hObject,'String',sprintf('%d',p.fig.op.ism_ISposRandFactor));
end
p.fig.chg=1;set(0,'Userdata',p);

function editismrandompos_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editismposrandomfact_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
in=str2double(str);
if(isreal(in))
    p.fig.op.ism_randFactorsInCart=in;
elseif (strcmp('',str))
    p.fig.op.ism_randFactorsInCart=0;
    set(hObject,'String',sprintf('%d',p.fig.op.ism_randFactorsInCart));
else
    set(hObject,'String',sprintf('%d',p.fig.op.ism_randFactorsInCart));
end
p.fig.chg=1;set(0,'Userdata',p);

function editismposrandomfact_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editdiscardorder_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
in=str2double(str);
if(isreal(in))
    if(~isinteger(in))
        in=round(in);
        set(hObject,'String',sprintf('%d',in));
    end
    p.fig.op.ism_discd_dir_orders=in;
elseif (strcmp('',str))
    p.fig.op.ism_discd_dir_orders=[];
    set(hObject,'String',sprintf('%d',p.fig.op.ism_discd_dir_orders));

else
    set(hObject,'String',sprintf('%d',p.fig.op.ism_discd_dir_orders));
end
p.fig.chg=1;set(0,'Userdata',p);

function editdiscardorder_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenumatrix_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
p.fig.op.fdn_fmatrix=str(get(hObject,'Value'));
p.fig.chg=1;set(0,'Userdata',p);

function popupmenumatrix_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkboxsmearfdn_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.fdn_enable_apc=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function checkboxabsfilter_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.fdn_enableAbsFilt=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function checkboxfdnenable_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.fdn_enabled=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function checkboxreflecfilter_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.fdn_enableReflFilt=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function checkboxhrtfcube_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.fdn_hrtf_on_cube=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function checkboxchnlmapping_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.fdn_smart_ch_mapping=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function checkboxhrtfdiago_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.fdn_hrtf_boxdiags=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function checkboxfdnbandpass_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.fdn_enableBP=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function popupmenudelaytype_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
p.fig.op.fdn_delays_choice=str(get(hObject,'Value'));
p.fig.chg=1;set(0,'Userdata',p);

function popupmenudelaytype_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenudelaycrit_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
p.fig.op.fdn_delay_criterion=str(get(hObject,'Value'));
p.fig.chg=1;set(0,'Userdata',p);

function popupmenudelaycrit_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editstrechfactor_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
in=str2double(str);
if(isreal(in))
    p.fig.op.fdn_mfactor=round(in);
elseif (strcmp('',str))
    p.fig.op.fdn_mfactor=1.0;
else
    set(hObject,'String',sprintf('%f',p.fig.op.fdn_mfactor));
end
p.fig.chg=1;set(0,'Userdata',p);

function editstrechfactor_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkboxpseudorando_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.pseudoRand=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);


function checkbox28_Callback(hObject, eventdata, handles)


function popupmenuhrtf_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
p.fig.op.hrtf_database=str(get(hObject,'Value'));
p.fig.chg=1;set(0,'Userdata',p);

function popupmenuhrtf_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenusmearingtype_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.array_render=get(hObject,'Value')-1;
p.fig.chg=1;set(0,'Userdata',p);

function popupmenusmearingtype_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenufiltcrea_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
p.fig.op.filtCreatMeth=str(get(hObject,'Value'));
p.fig.chg=1;set(0,'Userdata',p);


function popupmenufiltcrea_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenudiffrac_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
p.fig.op.diffrFiltMeth=str(get(hObject,'Value'));
p.fig.chg=1;set(0,'Userdata',p);

function popupmenudiffrac_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkboxsmearing_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.enableSR=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function popupmenusphericalmodel_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.shm_warpMethod=get(hObject,'Value')-1;
p.fig.chg=1;set(0,'Userdata',p);

function popupmenusphericalmodel_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenuspatia_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
p.fig.op.spat_mode=str(get(hObject,'Value'));
p.fig.chg=1;set(0,'Userdata',p);

function popupmenuspatia_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenurtestimation_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
p.fig.op.rt_estim=str(get(hObject,'Value'));
p.fig.chg=1;set(0,'Userdata',p);

function popupmenurtestimation_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenurenders_Callback(hObject, eventdata, handles)

p = get(0,'UserData');
str=get(hObject,'String');
p.fig.op.array_render=str(get(hObject,'Value'));
p.fig.chg=1;set(0,'Userdata',p);
function popupmenurenders_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkboxverbositty_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.verbosity=get(hObject,'Value');logical(p.fig.op.verbosity)
p.fig.chg=1;set(0,'Userdata',p);

function edittemper_Callback(hObject, eventdata, handles)


function edittemper_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkboxabsorptioncoeff_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.pseudoRand=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function checkboxplotroomdata_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.pseudoRand=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function popupmenuplotpos_Callback(hObject, eventdata, handles)


function popupmenuplotpos_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkboxismdiffusion_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.ism_enable_diffusion=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function checkboxtyonecorrect_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
p.fig.op.ism_enableToneCorr=get(hObject,'Value');
p.fig.chg=1;set(0,'Userdata',p);

function editseedshift_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
in=str2double(str);
if(isreal(in))
    p.fig.op.seed_shift=in;
elseif (strcmp('',str))
    p.fig.op.seed_shift=0;
    set(hObject,'String',sprintf('%d',p.fig.op.seed_shift));
else
    set(hObject,'String',sprintf('%d',p.fig.op.seed_shift));
end
p.fig.chg=1;set(0,'Userdata',p);

function editseedshift_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editspecratio_Callback(hObject, eventdata, handles)
p = get(0,'UserData');
str=get(hObject,'String');
in=str2double(str);
if(isreal(in))
    p.fig.op.ism_diffu_specu_ratio=in;
elseif (strcmp('',str))
    p.fig.op.ism_diffu_specu_ratio=0;
    set(hObject,'String',sprintf('%d',p.fig.op.ism_diffu_specu_ratio));
else
    set(hObject,'String',sprintf('%d',p.fig.op.ism_diffu_specu_ratio));
end
p.fig.chg=1;p.fig.chg=1;set(0,'Userdata',p);

function editspecratio_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
