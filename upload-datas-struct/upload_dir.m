function upload_dir(value,angltype)
%upload_dir(value,angltype)
%Is a callback function to change all the graphical object
%that are use to represent/set the direction of the recivier.
%%
h=guidata(gcf);%load the handles structure

if(h.dir.upload==1)%mechanism to avoid a callback loop
else
    p = get(0,'UserData');
    p.fig.chg=1;              
    %flag that it's use during the computation
    %to know if the room impulses need to be process again    
    set(0,'Userdata',p);
    h.dir.upload=1;
    guidata(gcf,h);
    h=guidata(gcf);
    if(value>180)
        value=180;
    elseif(value<-180)
        value=-180;
    end
    if(angltype==1)
        %%
        %Trick to have the compass line with always the same size
        %in the axes
        XLim=get(h.axes1,'XLim');
        YLim=get(h.axes1,'YLim');
        Rx=(XLim(2)-XLim(1))/10;
        Ry=(YLim(2)-YLim(1))/10;
        %%
        pos = sprintf('%f',value);
        set(h.edit1dir,'String',pos);
        set(h.slider1dir,'Value',value);
        linepos=getPosition(h.receiver.compass);
        linepos(2,1)=linepos(1,1)+Rx*cos(value*pi/180);
        linepos(2,2)=linepos(1,2)+Ry*sin(value*pi/180);
        setPosition(h.receiver.compass,linepos);
    else
        pos = sprintf('%f',value);
        set(h.edit2dir,'String',pos);
        set(h.slider2dir,'Value',value);
    end
    h.dir.upload=0;
    h.room.recdir(angltype)=value;
    guidata(gcf,h);%upload the new handles structure

end