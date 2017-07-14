function upload_mater()
%upload_mater()
%Is a callback function to change all the graphical object
%that are use to represent/set the material of the room.
%%
p = get(0,'UserData');%load data
contents = cellstr(get(p.fig.menu2zmat,'String'));
p.fig.room.materials = {contents{get(p.fig.menu2zmat,'Value')}; contents{get(p.fig.menu2ymat,'Value')}; contents{get(p.fig.menu2xmat,'Value')};contents{get(p.fig.menu1xmat,'Value')}; contents{get(p.fig.menu1ymat,'Value')}; contents{get(p.fig.menu1zmat,'Value')}};
estimatet60=estimate_rt(p.fig.room);pos=[0,0];
p.fig.room.t60=estimatet60;
for i= 1:5%change the t60(f) graph wuth the new estimate t60
pos=[p.fig.room.freq(i),estimatet60(i)];
setPosition(p.fig.rvrb_trf{i},pos);
end
set(0,'Userdata',p);%upload change