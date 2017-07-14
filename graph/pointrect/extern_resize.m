function extern_resize()
%%function extern_resize()
%to change the size of the room in the axes by the edit box
%pos is in this form: [sizeX,sizeY]
%%
hf=guidata(gcf);
hf.room.boxsize(1)=str2double(get(hf.edtx,'String'));
hf.room.boxsize(2)=str2double(get(hf.edty,'String'));
pos(1)=hf.room.boxsize(1);
pos(2)=hf.room.boxsize(2);
ctrx=hf.r.xmin+hf.r.length/2;
ctry=hf.r.ymin+hf.r.width/2;
hf.r.xmin=ctrx+(hf.r.xmin-ctrx)*pos(1)/hf.r.length;
hf.r.ymin=ctry+(hf.r.ymin-ctry)*pos(2)/hf.r.width;
hf.r.length=pos(1);
hf.r.width=pos(2);
set(hf.axes1,'XLim',[hf.r.xmin-hf.r.length/10,hf.r.xmin+hf.r.length*11/10]);
set(hf.axes1,'YLim',[hf.r.ymin-hf.r.width/10,hf.r.ymin+hf.r.width*11/10]);
xtick=hf.r.xmin:hf.r.length/10:hf.r.xmin+hf.r.length;
ytick=hf.r.ymin:hf.r.width/10:hf.r.ymin+hf.r.width;
xtickl=0:hf.r.length/10:hf.r.length;
ytickl=0:hf.r.width/10:hf.r.width;
set(hf.axes1,'XTick',xtick,'YTick',ytick,'XTickLabel',xtickl,'YTickLabel',ytickl);
guidata(gcf,hf);
reclinechange();
set(hf.r.p1,'xdata',hf.r.xmin,'ydata',hf.r.ymin);
set(hf.r.p2,'xdata',hf.r.xmin,'ydata',hf.r.ymin+hf.r.width/2);
set(hf.r.p3,'xdata',hf.r.xmin,'ydata',hf.r.ymin+hf.r.width);
set(hf.r.p4,'xdata',hf.r.xmin+hf.r.length/2,'ydata',hf.r.ymin+hf.r.width);
set(hf.r.p5,'xdata',hf.r.xmin+hf.r.length,'ydata',hf.r.ymin+hf.r.width);
set(hf.r.p6,'xdata',hf.r.xmin+hf.r.length,'ydata',hf.r.ymin+hf.r.width/2);
set(hf.r.p7,'xdata',hf.r.xmin+hf.r.length,'ydata',hf.r.ymin);
set(hf.r.p8,'xdata',hf.r.xmin+hf.r.length/2,'ydata',hf.r.ymin);

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
guidata(gcf,hf);
upload_dir(hf.room.recdir(1),1)
p = get(0,'UserData');
p.fig.chg=1;
set(0,'Userdata',p);