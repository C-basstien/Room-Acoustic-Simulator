function buttondownfcn_3dpoint(h,data,type)
fmove=@(fig,figdata)motionfcn_3dpoint(fig,figdata,h,type);
frelease=@(fig,figdata)buttonup_3dpoint(fig,figdata,h);
set(gcf,'windowbuttonmotionfcn',fmove);
set(gcf,'windowbuttonupfcn',frelease);
