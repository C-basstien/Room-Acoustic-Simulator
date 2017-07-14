function reclinechange()
%%function reclinechange()
%modify all the position  of the  room line/wall
%%
hf=guidata(gcf);

set(hf.r.l1,'xdata',[hf.r.xmin,hf.r.xmin],'ydata',[hf.r.ymin,hf.r.ymin+hf.r.width]);
set(hf.r.l2,'xdata',[hf.r.xmin,hf.r.xmin+hf.r.length],'ydata',[hf.r.ymin+hf.r.width,hf.r.ymin+hf.r.width]);
set(hf.r.l3,'xdata',[hf.r.xmin+hf.r.length,hf.r.xmin+hf.r.length],'ydata',[hf.r.ymin+hf.r.width,hf.r.ymin]);
set(hf.r.l4,'xdata',[hf.r.xmin+hf.r.length,hf.r.xmin],'ydata',[hf.r.ymin,hf.r.ymin]);

guidata(gcf,hf);