function  rm_released_key(eventdata,h)
%%rm_released_key(eventdata,h)
%This function remove the lasts released keys stored in the Key.active structure.
%%
%fprintf('Released Key:\n');
for i= 1:h.Key.i
    if(strcmp(h.Key.active{i},eventdata.Key))
        %fprintf('%s\n',h.Key.active{i});
        for j= i:h.Key.i
            if(j<h.Key.i)
                h.Key.active{j}=h.Key.active{j+1};
            else
                h.Key.active{h.Key.i}=0;
                h.Key.i=h.Key.i-1;
            end
        end
        break
    end
end
guidata(gcf,h);