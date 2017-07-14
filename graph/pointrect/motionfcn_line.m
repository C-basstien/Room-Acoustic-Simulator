function motionfcn_line(fig,figdata,initpos)
%%function motionfcn_line(fig,figdata,initpos)
%callback function when a line/wall of the room is moving
%%
hf=guidata(gcf);
coords=get(gca,'currentpoint');
if(isfield(hf.r,'lastdragpoint'))
lastpos=hf.r.lastdragpoint;
else
lastpos=initpos;
end
dx=coords(1,1,1)-lastpos(1,1,1);
dy=coords(1,2,1)-lastpos(1,2,1);
hf.r.lastdragpoint=coords;
for i= 1:8
    pn=sprintf('p%d',i);
    set(hf.r.(pn),'xdata',dx+get(hf.r.(pn),'xdata'),'ydata',dy+get(hf.r.(pn),'ydata'));
end

hf.r.xmin=get(hf.r.p1,'xdata');
hf.r.ymin=get(hf.r.p1,'ydata');
hf.r.length=(-get(hf.r.p1,'xdata')+get(hf.r.p7,'xdata'));
hf.r.width=(-get(hf.r.p1,'ydata')+get(hf.r.p5,'ydata'));
guidata(gcf,hf);

pos(1)=hf.r.xmin;
pos(2)=hf.r.ymin;
pos(3)=hf.r.length;
pos(4)=hf.r.width;

for i= 1:hf.filenum-1
    for k= 1:hf.sounds{i}.nbchnl
        possrc=getPosition(hf.sounds{i}.chanl{k}.coord);
        if(possrc(1)>hf.prevroomcoord(1)&& possrc(1)<hf.prevroomcoord(1)+hf.prevroomcoord(3)&& possrc(2)>hf.prevroomcoord(2)&& possrc(2)<hf.prevroomcoord(2)+hf.prevroomcoord(4))
            possrc(1)=possrc(1)+pos(1)-hf.prevroomcoord(1);
            possrc(2)=possrc(2)+pos(2)-hf.prevroomcoord(2);
            setPosition(hf.sounds{i}.chanl{k}.coord,possrc);
        else
        end
    end
end
posrec=getPosition(hf.receiver.coord);
posrec(1)=posrec(1)+pos(1)-hf.prevroomcoord(1);
posrec(2)=posrec(2)+pos(2)-hf.prevroomcoord(2);
setPosition(hf.receiver.coord,posrec);
hf.prevroomcoord=pos;
hf.chg=0;%drag the room in the space not affect the sound...
xl=get(gca,'XLim');
yl=get(gca,'YLim');
xtick=pos(1):pos(3)/10:pos(1)+pos(3);
ytick=pos(2):pos(4)/10:pos(2)+pos(4);
xtickl=round(0:pos(3)/10:pos(3),1);
ytickl=round(0:pos(4)/10:pos(4),1);
set(gca,'XTick',xtick,'YTick',ytick,'XTickLabel',xtickl,'YTickLabel',ytickl);
guidata(gcf,hf);

reclinechange();
