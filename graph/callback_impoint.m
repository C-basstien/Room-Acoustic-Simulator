function callback_impoint(h,type,pos,sound_id,chnl_id)
%%callback_impoint(h,type,pos,sound_id,chnl_id)
%this function signal that an instrument have change of position
%this usefull to avoid to compute again the instrument that have not change of position since the last simulation...
%%
hf= guidata(gcf);
if (type==0)%type indic if the impoint correspond to a sources or the recivier, 0 for recivier something else for sources ...
    hf.chg=1;
    linepos=getPosition(hf.receiver.compass);
    xyshift=[pos(1)-linepos(1,1) pos(2)-linepos(1,2)];
    linepos(1,1:2)=linepos(1,1:2)+xyshift;
    linepos(2,1:2)=linepos(2,1:2)+xyshift;
    setPosition(hf.receiver.compass,linepos);
else
    hf.sounds{sound_id}.chanl{chnl_id}.chgcoord=1;
end



%%
%%to delete the impoint, but not supported now. 
%the GUI is recieving a list of event when you're moving an impoint 
%and execute this callback.
%If the impoint is delete while there are still a  list of event on it
%an error may appear because the handle of  the impoint is no longer
%existing...
%to solve this you need to create your own impoint and specify his behaviour\
%a quick way to do this
%is to look at the create_pointrect.m, it's not at all the best way to do it but
%it's work fine.

% if(hf.Key.i>=1 &&(strcmp(hf.Key.active{hf.Key.i},'delete')||strcmp(hf.Key.active{hf.Key.i},'backspace')))
%     removeNewPositionCallback(h,hf.sounds{sound_id}.chanl{chnl_id}.clbk);
%     hf.sounds{sound_id}.chanl{chnl_id}.delete=1;%flag for computation parts to know that this chanel is no longer existing..
%     delete(h);
%  end



% if(hf.Key.i>=1 &&(strcmp(hf.Key.active{hf.Key.i},'control')))
%     ask={sprintf('x (current x=%f)',pos(1)),sprintf('y (current y=%f)',pos(2)),sprintf('z (current z=%f)',hf.sounds{sound_id}.chanl{chnl_id}.z)};
%     title = 'Input coord of instrument or leave empty to unchange';
%     res = inputdlg(ask,title);
%     newxy=[res{1},res{2}];
%     setPosition(h,newxy);
%     hf.sounds{sound_id}.chanl{chnl_id}.z=res{3};
% end
%%
guidata(gcf, hf);