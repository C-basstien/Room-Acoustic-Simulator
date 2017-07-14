function buttonup_line(fig,figdata)
%%function buttonup_line(fig,figdata)
%remove the callback associate to the line when the user release the
%mouse.
%%
hf=guidata(gcf);
set(fig,'windowbuttonmotionfcn','');
set(fig,'windowbuttonupfcn','');
hf.r=rmfield(hf.r,'lastdragpoint');
guidata(gcf,hf);