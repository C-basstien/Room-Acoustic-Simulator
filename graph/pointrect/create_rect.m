function r= create_rect(pos)
%%function r= create_rect(pos)
%Create a resizable and draggable room
%pos:[ xmin, ymin, width, length ]
%%
hf=guidata(gcf);
hf.r.xmin=pos(1);
hf.r.ymin=pos(2);
hf.r.length=pos(3);
hf.r.width=pos(4);
hold on
hf.r.l1=create_linerect([hf.r.xmin,hf.r.ymin],[hf.r.xmin,hf.r.ymin+hf.r.width]);
hf.r.l2=create_linerect([hf.r.xmin,hf.r.ymin+hf.r.width],[hf.r.xmin+hf.r.length,hf.r.ymin+hf.r.width]);
hf.r.l3=create_linerect([hf.r.xmin+hf.r.length,hf.r.ymin+hf.r.width],[hf.r.xmin+hf.r.length,hf.r.ymin]);
hf.r.l4=create_linerect([hf.r.xmin+hf.r.length,hf.r.ymin],[hf.r.xmin,hf.r.ymin]);
hf.r.p1=create_pointrect([hf.r.xmin,hf.r.ymin],'botl');
hf.r.p2=create_pointrect([hf.r.xmin,hf.r.ymin+hf.r.width/2],'left');
hf.r.p3=create_pointrect([hf.r.xmin,hf.r.ymin+hf.r.width],'topl');
hf.r.p4=create_pointrect([hf.r.xmin+hf.r.length/2,hf.r.ymin+hf.r.width],'top');
hf.r.p5=create_pointrect([hf.r.xmin+hf.r.length,hf.r.ymin+hf.r.width],'topr');
hf.r.p6=create_pointrect([hf.r.xmin+hf.r.length,hf.r.ymin+hf.r.width/2],'right');
hf.r.p7=create_pointrect([hf.r.xmin+hf.r.length,hf.r.ymin],'botr');
hf.r.p8=create_pointrect([hf.r.xmin+hf.r.length/2,hf.r.ymin],'bottom');

r=hf.r;
set(gca,'XLim',[pos(1)-pos(3)/10,pos(1)+pos(3)*11/10],'YLim',[pos(2)-pos(4)/10,pos(2)+pos(4)*11/10]);
xtick=pos(1):pos(3)/10:pos(1)+pos(3);
ytick=pos(2):pos(4)/10:pos(2)+pos(4);
xtickl=0:pos(3)/10:pos(3);
ytickl=0:pos(4)/10:pos(4);
set(gca,'XTick',xtick,'YTick',ytick,'XTickLabel',xtickl,'YTickLabel',ytickl);

guidata(gcf,hf);
return 
