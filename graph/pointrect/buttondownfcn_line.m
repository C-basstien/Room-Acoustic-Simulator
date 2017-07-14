function buttondownfcn_line(h,data)
%%function buttondownfcn_line(h,data)
%callback function when the mouse button is press on a line 
%%
initpos=get(gca,'currentpoint')
fmove=@(fig,figdata)motionfcn_line(fig,figdata,initpos);
frelease=@(fig,figdata)buttonup_line(fig,figdata);
set(gcf,'windowbuttonmotionfcn',fmove);
set(gcf,'windowbuttonupfcn',frelease);
