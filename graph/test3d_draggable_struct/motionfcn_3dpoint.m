function motionfcn_3dpoint(fig,figdata,h,type)
%figdata
coords=get(gca,'currentpoint');
x=coords(1,1,1)
y=coords(1,2,1)
z=coords(1,3,1)
set(h,'xdata',x,'ydata',y,'zdata',z);