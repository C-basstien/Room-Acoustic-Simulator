function addCurrPressKey(eventdata,h)
%%This function strore the current pressed keys in a an array.
%%
if(h.Key.i>0 && strcmp(h.Key.active{h.Key.i},eventdata.Key))
else
    h.Key.i=h.Key.i+1;
    h.Key.active{h.Key.i}=eventdata.Key;
    %fprintf('Pressed Keys:\n');
%     for i= 1:h.Key.i
%         fprintf('%s\n',h.Key.active{i});
%     end
end
guidata(gcf,h);