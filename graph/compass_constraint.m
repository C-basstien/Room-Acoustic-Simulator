function pos_out=compass_constraint(pos_in)
%%function pos_out=compass_constraint(pos_in)
%callback function to set the compass behaviour of the recivier
%%
pos_out=[0, 0; 0, 0];
pos_out(1,1)=pos_in(1,1);
pos_out(1,2)=pos_in(1,2);
h = guidata(gcf);
%%
%Trick to have the line always at the same size
XLim=get(h.axes1,'XLim');
YLim=get(h.axes1,'YLim');
Rx=(XLim(2)-XLim(1))/10;
Ry=(YLim(2)-YLim(1))/10;
%%
angl=atan2(pos_in(2,2)-pos_in(1,2),pos_in(2,1)-pos_in(1,1));
pos_out(2,1)=pos_in(1,1)+Rx*cos(angl);
pos_out(2,2)=pos_in(1,2)+Ry*sin(angl);
upload_dir(180*angl/pi,1);


pos=getPosition(h.receiver.coord);
if(pos_out(1,1)~=pos(1) && pos_out(1,2)~=pos(2))
    setPosition(h.receiver.coord,pos_out(1,1),pos_out(1,2));
end
return;