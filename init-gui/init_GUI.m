function init_GUI(hObject, eventdata, handles, varargin)
%%This function initialize the main graphical object/variable of the GUI RAZR window
%%
%handles=guidata(gcf);
%%audio and computation setup
handles.sounds={};
handles.namefilelist={};
handles.pathfilelist={};
handles.namefilelist{1}='';
handles.filenum=1;
handles.totalchnl=0;
handles.ptr_audio=1;
handles.computmethod='seq';
handles.playmethod='realtime';
%%
%%keyboard
handles.Key.i=0;
handles.Key.active={};
%%
%%HRTF
handles.op.spat_mode = 'hrtf';
handles.op.hrtf_database = 'cipic';
handles.op.hrtf_options.subject=21;
%%
%%creation of the draggable/resizeable roomhandles.output = hObject;
handles.maxt60=10;
handles.globalt60=0.3;%image of the current mean t60
handles.room.t60=[0.3 0.3 0.3 0.3 0.3];
handles.room.freq=[250   500   1e3   2e3   4e3];
handles.room.boxsize=[10 10 3];
handles.room.recdir= [90 0];
initpos=[0 ,0 ,handles.room.boxsize(1) , handles.room.boxsize(2)];
guidata(gcf,handles);
handles.r=create_rect(initpos);
handles.prevroomcoord=initpos;
%%
%%Revivier creation with the compass
x = [initpos(1)+handles.room.boxsize(1)/2, initpos(1)+handles.room.boxsize(1)/2];
y = [initpos(2)+handles.room.boxsize(2)/2 initpos(2)+1+handles.room.boxsize(2)/2];
handles.receiver.compass = imline(gca, x, y);
setColor(handles.receiver.compass,'black');
handles.receiver.compass.Deletable = false;
setPositionConstraintFcn (handles.receiver.compass,@compass_constraint);
handles.dir.upload=0;
handles.receiver.coord=impoint(gca,initpos(1)+handles.room.boxsize(1)/2, initpos(2)+handles.room.boxsize(2)/2);
setColor(handles.receiver.coord,'black');
setString(handles.receiver.coord,'receiver');
handles.receiver.z=handles.room.boxsize(3)/2;
handles.receiver.coord.Deletable = false;
rcvr_clbk= @(pos) callback_impoint(handles.receiver.coord,0,pos,0,0);
id=addNewPositionCallback(handles.receiver.coord,rcvr_clbk);
setColor(handles.receiver.compass,'black');
handles.receiver.compass.Deletable = false;
setPositionConstraintFcn (handles.receiver.compass,@compass_constraint);
%%
%%Graph of t60(f)
Ylim=[0,handles.maxt60];
for i= 1:5
    handles.rvrb_trf{i}=impoint(handles.axes5,handles.room.freq(i),handles.room.t60(i));
    setColor(handles.rvrb_trf{i},'black');
    handles.rvrb_trf{i}.Deletable = false;
    param_clbk= @(pos) clbk_impoint_t60(handles.rvrb_trf{i},pos,i);
    Xlim=[handles.room.freq(i),handles.room.freq(i)];
    fcn = makeConstrainToRectFcn('impoint',Xlim,Ylim);
    addNewPositionCallback(handles.rvrb_trf{i},param_clbk);
    setPositionConstraintFcn(handles.rvrb_trf{i},fcn);
end
handles.xp = 0:handles.room.freq(5)/100:handles.room.freq(5);
handles.yp = interp1(handles.room.freq,handles.room.t60,handles.xp ,'pchip');
handles.plt=plot(handles.xp,handles.yp,'-','parent',handles.axes5);
%%
%%Others graph vars
handles.coord={};
handles.coord{1}=[0,0,0];
handles.zoom=1.5;%%Change this parameter if the zoom factor is too high/slow.
handles.normchg=1;
%%
%%data upload
guidata(gcf, handles);
p.upload=0;
p.fig=handles;
p.fig.chg=1;
p.fig.usemat=0;
set(0,'Userdata',p);
%%