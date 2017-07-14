function buttondownfcn_point(h,data,type)
%%function buttondownfcn_point(h,data,type)
%callback function when the mouse button is press on a point 
%%
fmove=@(fig,figdata)motionfcn_point(fig,figdata,h,type);
frelease=@(fig,figdata)buttonup_point(fig,figdata,h);
set(gcf,'windowbuttonmotionfcn',fmove);
set(gcf,'windowbuttonupfcn',frelease);

