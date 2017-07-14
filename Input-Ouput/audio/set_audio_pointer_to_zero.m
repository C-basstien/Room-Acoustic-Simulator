function set_audio_pointer_to_zero(handles)
%%function set_audio_pointer_to_zero(handles)
%stop the audioplayer and reset pointer position at
%beginning of the song, used in  non realtime mode
%%
if(strcmp(get(handles.pushbutton1load,'Visible'),'off'))
 handles.ptr_audio=1;
 else
     if(isfield(handles,'player'))
         set(handles.text1status,'String','Song stopped');
         stop(handles.player);
     end
 end
 guidata(gcf,handles);