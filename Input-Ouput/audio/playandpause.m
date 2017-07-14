function playandpause(handles)
%%playandpause(handles)
%Callback function execute when the button play/pause is press 
%handle the different audio player for realtime/no realtime mode.
%%
 get(handles.pushbutton1load,'Visible');
 if(strcmp(get(handles.pushbutton1load,'Visible'),'off'))%test if the realtime is selected
     if(isfield(handles,'t'))
         if(playrec('isInitialised'))%should be...
             if(~playrec('pause'))%return if playrec is playing or no
                 playrec('pause',1);%pause the audio stream
                 set(handles.pushbutton1play,'String','Play');
                 set(handles.text1status,'String','Paused');
             else
                 playrec('pause',0);%resume the audio stream
                 set(handles.pushbutton1play,'String','Pause');
                 set(handles.text1status,'String','Playing');
                 
             end
         end
     else%start a new timer....
         handles.buffersize=floor(handles.totalchnl*(mean(handles.room.t60)+0.5)*44100);
         handles.t = timer;
         handles.t.TimerFcn = @timerCallback;
         handles.t.Period = handles.buffersize/(44100*5);
         handles.t.BusyMode='queue';
         handles.t.ExecutionMode  = 'fixedSpacing';
         guidata(gcf,handles);
         start(handles.t);
         
     end
 else%%not real time
     if(isfield(handles,'player'))
         if(isplaying(handles.player))%pause audio
             set(handles.pushbutton1play,'String','Play');
             set(handles.text1status,'String','Paused');
             pause(handles.player);
         else%resume audio
             set(handles.pushbutton1play,'String','Pause');
             set(handles.text1status,'String','Playing');
             resume(handles.player);
             set(handles.text1status,'String','Ready');
         end
         
         
     end
 end