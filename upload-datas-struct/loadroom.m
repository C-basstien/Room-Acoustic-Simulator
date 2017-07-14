function loadroom(h)
%%loadroom(h)
%This function load a room that has been saved in a .m file
%Warning: Currently ,value of graphical object are not change automatically.
%%
filename=uigetfile('*.m','Please choose a room');
if(~filename)
    msgbox('No room configuration not loaded !');
else
    h.room=eval(filename);
    guidata(gcf,h);%upload the new handles structure
end