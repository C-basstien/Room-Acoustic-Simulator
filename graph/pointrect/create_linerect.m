function l= create_linerect(p1,p2)
%%function l= create_linerect(p1,p2)
%create and retrun a draggable line with the default position p1,p2 
%p1=(x1,y1),p2=(x2,y2)
%%
x=[p1(1),p2(1)];
y=[p1(2),p2(2)];
l = plot(gca,x,y,'Color','k');
hold on
iptPointerManager(gcf);
enterFcn = @(hFigure, currentPoint) set(hFigure, 'Pointer','fleur');
iptSetPointerBehavior(l, enterFcn);
drag=@(h,data)buttondownfcn_line(h,data);
set(l,'ButtonDownFcn',drag);
return