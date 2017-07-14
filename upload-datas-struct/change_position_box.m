function change_position_box(handles)
%%change_position_box(handles)
%This is a callback function to change the position of the sources,recivier
%It create a new window in  which the user can speficy by a line vector [x y z]
%the positions
%%
prompt = cell(1,1+handles.totalchnl);
prompt{1}='[x y z] reciever';
defaultans = cell(1,1+handles.totalchnl);
defaultans{1}=sprintf('[%d, %d, %d]',getPosition(handles.receiver.coord)-[handles.r.xmin,handles.r.ymin],handles.receiver.z);
for i= 1:handles.filenum-1%get the list of instrument in the room
        for k= 1:handles.sounds{i}.nbchnl
            prompt{i+k}=sprintf('[x y z] %s %d',handles.namefilelist{i},handles.sounds{i}.chanl{k}.num);
            defaultans{i+k}=sprintf('[%d, %d, %d]',getPosition (handles.sounds{i}.chanl{k}.coord)-[handles.r.xmin,handles.r.ymin],handles.sounds{i}.chanl{k}.z);
        end
end
dlg_title = 'Change positions';
num_lines = 1;
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);%collect answer
rcvrpos=str2num(answer{1});%load the new recivier position
setPosition(handles.receiver.coord,rcvrpos(1:2)+[handles.r.xmin,handles.r.ymin]);handles.receiver.z=rcvrpos(3);
for i= 1:handles.filenum-1%load the new sources positions
        for k= 1:handles.sounds{i}.nbchnl
            srcpos=str2num(answer{i+k});
            setPosition(handles.sounds{i}.chanl{k}.coord,srcpos(1:2)+[handles.r.xmin,handles.r.ymin]);handles.receiver.z=rcvrpos(3);
        end
end
guidata(gcf,handles);%upload the new handles structure
