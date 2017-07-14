function init_room_axes(hObject, eventdata, handles)
%%This function  is just initializing the axes
%%
set(hObject,'XLim',[0,10]);
set(hObject,'YLim',[0,10]);
set(hObject,'ZLim',[0,3]);
set(hObject,'buttondownfcn',@add_track);
xlabel(hObject,'X');ylabel(hObject,'Y');zlabel(hObject,'Z');