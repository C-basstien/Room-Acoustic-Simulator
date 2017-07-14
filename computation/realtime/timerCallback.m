  function  timerCallback(src, event)
  %%timerCallback(src, event)
  %This function is the callback function of the timer
  %Period of the timer set time to wait after thhe execution of the last timer callback to start a new call of the function
  %Period may changes to respect real time constraint
  %%
  handles=guidata(gcf);
   handles.buffersize=floor(handles.totalchnl*(mean(handles.room.t60)+0.5)*44100);
   if(handles.t.Period<handles.buffersize/(44100*5)-0.010||handles.t.Period>handles.buffersize/(44100*5)+0.010)
       stop(handles.t);%stop to change the period
       set(handles.t,'Period',round(handles.buffersize/(44100*5),2));%empirical estimation of the period to be in realtime
       start(handles.t);%restart
   else
   sequential_realtime(1,1,handles);%execution  of the computation function
   end
   if(handles.ptr_audio>handles.maxlength)%no more audio datas to read 
       stop(handles.t);%end and remove the timer 
       handles=rmfield(handles,'t');
       guidata(gcf,handles);
   end
   %%