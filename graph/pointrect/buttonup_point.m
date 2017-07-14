function buttonup_point(fig,figdata,h)
%%function buttonup_point(fig,figdata,h)
%remove the callback associate to the point when the user release the
%mouse.
%%
set(fig,'windowbuttonmotionfcn','');
set(fig,'windowbuttonupfcn','');
