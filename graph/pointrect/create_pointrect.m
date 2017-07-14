function h= create_pointrect(pos,type)
%%function h= create_pointrect(pos,type)
%create and retrun a point with the default position pos
%type indic pointer aspect
%%
h = plot(gca,pos(1),pos(2),'Marker','s','Color','k','MarkerFaceColor','k');
hold on
iptPointerManager(gcf);
enterFcn = @(hFigure, currentPoint) set(hFigure, 'Pointer', type);
iptSetPointerBehavior(h, enterFcn);
resize=@(h,data)buttondownfcn_point(h,data,type);
set(h,'ButtonDownFcn',resize);
return
