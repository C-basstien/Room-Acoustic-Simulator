function sequential_computation(hObject, eventdata, handles)
%%sequential_realtime(hObject, eventdata, h)
%This function is used to compute the acoustic scene in non-realtime mode.
%%
%get the configuration
h = guidata(gcf);
p = get(0,'UserData');
h.room.t60=p.fig.room.t60;
h.chg=p.fig.chg;
h.usemat=p.fig.usemat;
if(h.usemat)
    h.room.materials=p.fig.room.materials;
elseif(isfield(h.room,'materials'))
    h.room=rmfield(h.room,'materials');
end
h.norm=logical(strcmp(h.normalization.Checked,'on'));
set(handles.text1status,'String','Loading...');
set(handles.text1status,'ForegroundColor','r');
drawnow;
mix_chg=0;
if(p.fig.chg==1)
    h.room.boxsize=[str2double(get(handles.edtx,'String')),str2double(get(handles.edty,'String')),str2double(get(handles.edtz,'String'))];
    pos=getPosition(h.receiver.coord);
    h.room.srcpos= [1, 1, 1];
    h.room.recpos = [pos(1)-h.r.xmin,  pos(2)-h.r.ymin,  h.room.boxsize(3)/2];
    mix_chg=1;
end

%%
%dcomputation part
for i= 1:h.filenum-1%file loop
    for k= 1:h.sounds{i}.nbchnl%channel loop
        if(h.sounds{i}.chanl{k}.chgcoord==1 || p.fig.chg==1||h.normchg==1)
            if(h.sounds{i}.chanl{k}.chgcoord==0 && p.fig.chg==0)
                [h.room.out{k}, h.room.in{k}]= apply_rir(h.room.ir{k},'src',h.sounds{i}.chanl{k}.num,'normalize',h.norm);
                msg=sprintf(' convolution calculation, instrument %d of (sound %d )',h.sounds{i}.chanl{k}.num,i);
                set(handles.text2status,'String',msg);drawnow;
            else
                pos=getPosition(h.sounds{h.filenum+i-2}.chanl{k}.coord);
                h.rooms{i,k}=h.room;h.rooms{i,k}.srcpos=[pos(1)-h.r.xmin,pos(2)-h.r.ymin,h.sounds{i}.chanl{k}.z];
                
                msg=sprintf('RIR calculation of instrument %d of (sound %d )',h.sounds{i}.chanl{k},i);
                set(handles.text2status,'String',msg);drawnow;
               
                h.room.ir{k} = razr(h.rooms{i,k},h.op);
                
                msg=sprintf(' convolution calculation, instrument %d of (sound %d )',h.sounds{i}.chanl{k}.num,i);
                
                set(handles.text2status,'String',msg);drawnow;
                
                [h.room.out{k}, h.room.in{k}]= apply_rir(h.room.ir{k},'src',h.sounds{i}.track(:,h.sounds{i}.chanl{k}.num),'normalize',h.norm);
                h.sounds{i}.chanl{k}.chgcoord=0;
            end
            mix_chg=1;%flag to indic change in the mix
        end
        if(mix_chg==0)%%mix output
            msg=sprintf('Configuratiom already loaded');
            set(handles.text2status,'String',msg);drawnow;
        else
            if (k == 1 && i==1)
                h.out_res=h.room.out{1}{1};
            else
                if(length(h.out_res)==length(h.room.out{k}{1}))
                    h.out_res = h.out_res+ h.room.out{k}{1};
                else
                    [h.out_res, outb]=up_sample(h.out_res,h.room.out{k}{1},'loop');
                    h.out_res=h.out_res+outb;
                end
            end
            msg=sprintf('Audio of instrument %d of (sound %d ) => done',k,i);
            set(handles.text2status,'String',msg);drawnow;
        end
    end
end
set(handles.text2status,'String','You can now play or save the wav file generated');
set(handles.text1status,'String','Ready');
set(handles.text1status,'ForegroundColor','c');
drawnow
p.fig.chg=0;
h.normchg=0;
%%
%audio playback
if(isfield(h,'player') && isplaying(h.player))
    set(h.pushbutton1play,'String','Pause');
    set(h.text1status,'String','Playing');
    start=get(h.player,'CurrentSample');
    h.player = audioplayer(h.out_res,h.room.ir{1}.fs) ;
    play(h.player,start); 
else
    h.player = audioplayer(h.out_res,h.room.ir{1}.fs) ;
end
%%
guidata(gcf, h);