function h= create_3dimpoint(pos,type)
h = plot3(gca,pos(1),pos(2),pos(3),'Marker','s','Color','k','MarkerFaceColor','k');
hold on
iptPointerManager(gcf);
enterFcn = @(hFigure, currentPoint) set(hFigure, 'Pointer', type);
iptSetPointerBehavior(h, enterFcn);
move3d=@(h,data)buttondownfcn_3dpoint(h,data,type);
set(h,'ButtonDownFcn',move3d);
return