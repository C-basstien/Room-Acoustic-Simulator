function motionfcn_point(fig,figdata,h,type)
%%function motionfcn_point(fig,figdata,h,type)
%callback function when a point/corne of the room is moving
%%
coords=get(gca,'currentpoint');
x=coords(1,1,1);
y=coords(1,2,1);
hf=guidata(gcf);
xl=get(gca,'XLim');
yl=get(gca,'YLim');
inwindow=1;
if(hf.r.xmin<xl(1)||hf.r.length+hf.r.xmin>xl(2)||hf.r.ymin<yl(1)||hf.r.width+hf.r.ymin>yl(2))
        inwindow=0;
end
switch type
    case 'botl'
        if(x< get(hf.r.p7,'xdata') && y < get(hf.r.p3,'ydata'))
        set(h,'xdata',x,'ydata',y);
        xn=(x+get(hf.r.p7,'xdata'))/2;
        yn=(y+get(hf.r.p3,'ydata'))/2;
        set(hf.r.p2,'xdata',x,'ydata',yn);
        set(hf.r.p3,'xdata',x);
        set(hf.r.p4,'xdata',xn);
        set(hf.r.p6,'ydata',yn); 
        set(hf.r.p7,'ydata',y);
        set(hf.r.p8,'xdata',xn,'ydata',y);
        end
    case 'topl'
        if(x< get(hf.r.p7,'xdata') && y > get(hf.r.p1,'ydata'))
        set(h,'xdata',x,'ydata',y);
        xn=(x+get(hf.r.p7,'xdata'))/2;
        yn=(y+get(hf.r.p1,'ydata'))/2;
        set(hf.r.p1,'xdata',x);
        set(hf.r.p2,'xdata',x,'ydata',yn);
        set(hf.r.p4,'xdata',xn,'ydata',y);
        set(hf.r.p5,'ydata',y);
        set(hf.r.p6,'ydata',yn); 
        set(hf.r.p8,'xdata',xn);
        end
    case 'topr'
        if(x>get(hf.r.p3,'xdata') && y > get(hf.r.p7,'ydata'))
        set(h,'xdata',x,'ydata',y);
        xn=(x+get(hf.r.p3,'xdata'))/2;
        yn=(y+get(hf.r.p7,'ydata'))/2;
        set(hf.r.p2,'ydata',yn);
        set(hf.r.p3,'ydata',y);
        set(hf.r.p4,'xdata',xn,'ydata',y);
        set(hf.r.p6,'xdata',x,'ydata',yn); 
        set(hf.r.p7,'xdata',x);
        set(hf.r.p8,'xdata',xn);
        end
    case 'botr'
        if(x>get(hf.r.p1,'xdata') && y < get(hf.r.p3,'ydata'))
        set(h,'xdata',x,'ydata',y);
        xn=(x+get(hf.r.p1,'xdata'))/2;
        yn=(y+get(hf.r.p3,'ydata'))/2;
        set(hf.r.p1,'ydata',y);
        set(hf.r.p2,'ydata',yn);
        set(hf.r.p4,'xdata',xn);
        set(hf.r.p5,'xdata',x);
        set(hf.r.p6,'xdata',x,'ydata',yn); 
        set(hf.r.p8,'xdata',xn,'ydata',y);
        end
    case 'left'
        if(x<get(hf.r.p6,'xdata'))
        set(h,'xdata',x);
        xn=(x+get(hf.r.p6,'xdata'))/2;
        set(hf.r.p1,'xdata',x);
        set(hf.r.p3,'xdata',x);
        set(hf.r.p4,'xdata',xn);
        set(hf.r.p8,'xdata',xn);
        end
    case 'top'
        if(y>get(hf.r.p8,'ydata'))
        set(h,'ydata',y);
        yn=(y+get(hf.r.p8,'ydata'))/2;
        set(hf.r.p3,'ydata',y);
        set(hf.r.p5,'ydata',y);
        set(hf.r.p2,'ydata',yn);
        set(hf.r.p6,'ydata',yn);
        end
    case 'right'
        if(x>get(hf.r.p2,'xdata'))
        set(h,'xdata',x);
        xn=(x+get(hf.r.p2,'xdata'))/2;
        set(hf.r.p5,'xdata',x);
        set(hf.r.p7,'xdata',x);
        set(hf.r.p4,'xdata',xn);
        set(hf.r.p8,'xdata',xn);
        end
    case 'bottom'
        if(y<get(hf.r.p4,'ydata'))
        set(h,'ydata',y);
        yn=(y+get(hf.r.p4,'ydata'))/2;
        set(hf.r.p1,'ydata',y);
        set(hf.r.p7,'ydata',y);
        set(hf.r.p2,'ydata',yn);
        set(hf.r.p6,'ydata',yn);
        end
end
hf.r.xmin=get(hf.r.p1,'xdata');
hf.r.ymin=get(hf.r.p1,'ydata');
hf.r.length=(-get(hf.r.p1,'xdata')+get(hf.r.p7,'xdata'));
hf.r.width=(-get(hf.r.p1,'ydata')+get(hf.r.p5,'ydata'));
pos(1)=hf.r.xmin;
pos(2)=hf.r.ymin;
pos(3)=hf.r.length;
pos(4)=hf.r.width;
pm=[pos(1)+(pos(3)/2),pos(2)+(pos(4)/2) ];
pmprev=[hf.prevroomcoord(1)+(hf.prevroomcoord(3)/2),hf.prevroomcoord(2)+(hf.prevroomcoord(4)/2) ];
if(strcmp(hf.rescale.Checked,'on'))
    for i= 1:hf.filenum-1
        for k= 1:hf.sounds{i}.nbchnl
            possrc=getPosition(hf.sounds{i}.chanl{k}.coord);
            if(possrc(1)>hf.prevroomcoord(1)&& possrc(1)<hf.prevroomcoord(1)+hf.prevroomcoord(3)&& possrc(2)>hf.prevroomcoord(2)&& possrc(2)<hf.prevroomcoord(2)+hf.prevroomcoord(4))
                possrc(1)=pm(1)+(possrc(1)-pmprev(1))*pos(3)/hf.prevroomcoord(3);
                possrc(2)=pm(2)+(possrc(2)-pmprev(2))*pos(4)/hf.prevroomcoord(4);
                setPosition(hf.sounds{i}.chanl{k}.coord,possrc);
            else
            end
        end
    end

posrec=getPosition(hf.receiver.coord);
posrec(1)=pm(1)+(posrec(1)-pmprev(1))*pos(3)/hf.prevroomcoord(3);
posrec(2)=pm(2)+(posrec(2)-pmprev(2))*pos(4)/hf.prevroomcoord(4);
setPosition(hf.receiver.coord,posrec);
hf.prevroomcoord=pos;
end
hf.chg=1;
set(hf.edtx,'String',sprintf('%f',round(pos(3),2)));
set(hf.edty,'String',sprintf('%f',round(pos(4),2)));
hf.room.boxsize(1)=pos(3);
hf.room.boxsize(2)=pos(4);
if(inwindow==1)
    if(pos(1)<xl(1)||pos(3)+pos(1)>xl(2))
        set(gca,'XLim',[pos(1)-pos(3)/10,pos(1)+pos(3)*11/10]);
        
    end
    if(pos(2)<yl(1)||pos(4)+pos(2)>yl(2))
        set(gca,'YLim',[pos(2)-pos(4)/10,pos(2)+pos(4)*11/10]);
    end
end
xtick=pos(1):pos(3)/10:pos(1)+pos(3);
ytick=pos(2):pos(4)/10:pos(2)+pos(4);
xtickl=round(0:pos(3)/10:pos(3),1);
ytickl=round(0:pos(4)/10:pos(4),1);
set(gca,'XTick',xtick,'YTick',ytick,'XTickLabel',xtickl,'YTickLabel',ytickl);

guidata(gcf,hf); 
reclinechange();
upload_dir(hf.room.recdir(1),1)
