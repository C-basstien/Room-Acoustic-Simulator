function done_add_track(src,evendata)
%%done_add_track(src,evendata)
%Remove the callback on the mouse associate to the figure during add_track function
%%
set(gcf,'windowbuttonmotionfcn','');
set(gcf,'windowbuttonupfcn','');