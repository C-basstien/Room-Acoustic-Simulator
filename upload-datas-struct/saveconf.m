function saveconf (hObject, eventdata, handles)
%%loadroom(h)
%This function save the audio in a wav file  
%and also save some information about the simulation 
%configuration
%%
filename =uiputfile('*.wav','Save ouput audio as...');
set(handles.text1status,'String','Saving...');
set(handles.text1status,'ForegroundColor','r');
drawnow;
h=handles;
audiowrite(filename,h.out_res, h.room.ir{1}.fs);
fileID = fopen(strcat(filename(1:length(filename)-4),'_setup.txt'),'w');%create a new text file filename extension  .wav  replace by .txt
fprintf(fileID,'Room setup:\r\n');
fprintf(fileID,'Room sizes:[%f %f %f]\r\n',h.room.boxsize);
fprintf(fileID,'Global T60:\r\n');
fprintf(fileID,'T60 and  frequency dependence:[<%f(s),%f(Hz)>,<%f(s),%f(Hz)>,<%f(s),%f(Hz)>,<%f(s),%f(Hz)>,<%f(s),%f(Hz)>]\r\n',h.room.t60(1),h.room.freq(1),h.room.t60(2),h.room.freq(2),h.room.t60(3),h.room.freq(3),h.room.t60(4),h.room.freq(4),h.room.t60(5),h.room.freq(5));
if(h.usemat)
    fprintf(fileID,'Materials specification activate:YES\r\n');
    fprintf(fileID,'Materials used:-Z:%s -Y:%s -X:%s  +X:%s +Y:%s  +Z:%s\r\n',h.room.materials{1},h.room.materials{2},h.room.materials{3},h.room.materials{4},h.room.materials{5},h.room.materials{6});
else
    fprintf(fileID,'Materials specification activate:NO\r\n');
end
fprintf(fileID,'Receiver position [x y z]:[%f %f %f]\r\n',h.room.recpos);
fprintf(fileID,'Receiver orientatiom [a ß]:[%f %f]\r\n',h.room.recdir);
fprintf(fileID,'HRTF CIPIC database subject:%d\r\n',h.op.hrtf_options.subject);
if(h.norm)
    fprintf(fileID,'Sound normalize to 1:YES\r\n');
else
    fprintf(fileID,'Sound normalize to 1:NO\r\n');
end
fprintf(fileID,'Number of sounds files import:%d\r\n',h.filenum-1);
for i= 1:h.filenum-1
    fprintf(fileID,'Song %d Name:%s\r\n',i,h.namefilelist{i});
    fprintf(fileID,'Selected instrument:%d\r\n',h.sounds{i}.nbchnl);
    for k= 1:h.sounds{i}.nbchnl
        fprintf(fileID,'Instrument %d:channel %d\r\n',k,h.sounds{i}.chanl{k}.num);
        fprintf(fileID,'Instrument %d: position:[%d %d %d]\r\n',k,h.rooms{i,k}.srcpos);
    end
end
fclose(fileID);
set(h.text1status,'String','Ready');
set(h.text1status,'ForegroundColor','c');
drawnow;