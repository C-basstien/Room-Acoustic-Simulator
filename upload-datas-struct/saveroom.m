function saveroom(h)
%%saveroom(h)
%This function save a room in a .m file that is currently used in the GUI
%Warning: For now options on room are not saved this will be aviable when 
%the room options menu will be create, see GET_DEFAULT_OPTIONS
%%
filename =uiputfile('*.m','Save the room as...');
if(~filename)
    msgbox('Room configuration not saved !');
else

% set(h.text1status,'String','Saving...');
% set(h.text1status,'ForegroundColor','r');
% drawnow;
fileID = fopen(filename,'w');%create a new matlab file
fprintf(fileID,'function room = %s\n',filename(1:length(filename)-2));
fprintf(fileID,'room.boxsize=[%d, %d, %d];\n',h.room.boxsize);
fprintf(fileID,'room.t60=[%d, %d, %d, %d, %d];\n',h.room.t60);
fprintf(fileID,'room.freq=[%d, %d, %d, %d, %d];\n',h.room.freq);
if(isfield(h.room,'TCelsius'))
    fprintf(fileID,'room.TCelsius=%f;\n',h.room.TCelsius);
end
if(isfield(h.room,'materials'))
    fprintf(fileID,'room.materials=%s;\n',h.room.materials);
end
%for now only the name of the materials can be specify in the interface
%but some change will occur to have in advanced parameters windows to
%abscoeff of the surface...
if(isfield(h.room,'op'))
    
end
%for now options on room are not saved 
%this will be aviable when the room options menu
%will be create
fclose(fileID);
end