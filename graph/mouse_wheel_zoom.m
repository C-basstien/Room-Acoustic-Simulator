function mouse_wheel_zoom(eventdata,handles)
%%function mouse_wheel_zoom(eventdata,handles)
%callback function to zoom in/out on the room by using the mouse wheel
%%
pannelpos=get(handles.uipanelaxes,'Position');
axespos=get(handles.axes1,'Position');
mousepos=get (gcf, 'CurrentPoint');
x1=pannelpos(1)+axespos(1) ;
x2=x1+axespos(3);
y1=pannelpos(2)+axespos(2) ;
y2=y1+axespos(4);
if(mousepos(1)> x1 && mousepos(1)<x2 && mousepos(2)> y1 && mousepos(2)<y2)%%%check that we are on the axes zone
    mousepos=get (handles.axes1, 'CurrentPoint');%position  of the mouse in the axes    
        XLim=get(handles.axes1,'XLim');
        YLim=get(handles.axes1,'YLim');
        XL=XLim(2)-XLim(1);
        YL=YLim(2)-YLim(1);
    if (eventdata.VerticalScrollCount > 0)

        XLim=[mousepos(1),mousepos(1)]+handles.zoom*[-XL,XL]/2;
        YLim=[mousepos(2),mousepos(2)]+handles.zoom*[-YL,YL]/2;
        set(handles.axes1,'XLim',XLim);
        set(handles.axes1,'YLim',YLim);

     elseif (eventdata.VerticalScrollCount < 0)
        XLim=[mousepos(1),mousepos(1)]+[-XL,XL]/(2*handles.zoom);
        YLim=[mousepos(2),mousepos(2)]+[-YL,YL]/(2*handles.zoom);
         set(handles.axes1,'XLim',XLim);
         set(handles.axes1,'YLim',YLim);
     end
end