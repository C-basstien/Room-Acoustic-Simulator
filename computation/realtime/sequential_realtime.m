function sequential_realtime(hObject, eventdata, h)
%%sequential_realtime(hObject, eventdata, h)
%This function is used to compute in realtime the acoustic scene
%%
try%used to debug because still some errors may happens with paramters window and timer callback hide error message
    %%playrec checking
    if(playrec('isInitialised'))
        % playrec('reset');
    else
        if(isfield(h,'driverID'))
            playrec('init',44100,h.driverID,-1);
        else
            h.driverID=choose_default_driver();
            playrec('init',44100,h.driverID,-1);
        end
    end
    %%
    %set the latency,must be not to small oversise the song will have gape
    %ouputsong=zeros(lght_trck,2);
    % n=floor(h.maxlength/buffersize)
    % h.maxlength/n
    %a remplacer  par ir.fs pour un programmme plus generale
    %h.maxlength
    %h.out_res=zeros(1,1*h.maxlength,2);
    endflag=0;%flag to indic the end of o the song
    h.audiopage=playrec('getPageList');
    b_sz=size(h.audiopage);%indic the number of audio page to be play...
    if(b_sz(2)<2)%to synchronize the playback and computation
        if (h.ptr_audio<h.maxlength)
            p = get(0,'UserData');
            h.room.t60=p.fig.room.t60;
            h.buffersize=floor(h.totalchnl*(mean(h.room.t60)+0.5)*44100);%init emprical estimatiom pf  the needed computation time 0.5 stand for the minimal amount of time to generate a room...
            h.chg=p.fig.chg;
            h.usemat=p.fig.usemat;
            if(h.usemat)
                h.room.materials=p.fig.room.materials;
            elseif(isfield(h.room,'materials'))
                h.room=rmfield(h.room,'materials');
            end
            h.norm=logical(strcmp(h.normalization.Checked,'on'));%%option to normalize all the ouput to 0dB level
            if(p.fig.chg==1)
                h.room.boxsize=[str2double(get(h.edtx,'String')),str2double(get(h.edty,'String')),str2double(get(h.edtz,'String'))];
                pos=getPosition(h.receiver.coord);
                h.room.srcpos= [1, 1, 1];
                h.room.recpos = [pos(1)-h.r.xmin,  pos(2)-h.r.ymin,  h.room.boxsize(3)/2];
            end
            for i= 1:h.filenum-1%%sound loop
                
                h.buffersize=floor(h.totalchnl*(mean(h.room.t60)+0.5)*44100);
                if(h.ptr_audio+h.buffersize>h.sounds{i}.lght)%end of the song
                    h.buffersize=h.sounds{i}.lght-h.ptr_audio;
                    if(h.buffersize<0)
                        h.buffersize=0;
                    end
                    endflag=1;
                end
                for k= 1:h.sounds{i}.nbchnl%%channel loop
                    
                    if(h.sounds{i}.chanl{k}.chgcoord==0 && p.fig.chg==0)%only when changes occur the rir need to be recalculate
                        msg=sprintf(' * calculation, instrument %d of (sound %d )',k,i);set(h.text2status,'String',msg);drawnow;%user info displaying
                        if(h.sounds{i}.chanl{k}.outside)
                            msg=sprintf('instrument %d of (sound %d ) is outside the room,so it has been muted',h.sounds{i}.chanl{k},i);
                            set(h.text2status,'String',msg);drawnow;
                        else
                            h.room.out= apply_rir(h.room.ir{i,k},'src',h.sounds{i}.track(h.ptr_audio:h.ptr_audio+h.buffersize,h.sounds{i}.chanl{k}.num),'normalize',h.norm);
                        end
                    else
                        
                        pos=getPosition(h.sounds{i}.chanl{k}.coord);
                        h.rooms{k}=h.room;
                        h.rooms{k}.srcpos=[pos(1)-h.r.xmin,pos(2)-h.r.ymin,h.sounds{i}.chanl{k}.z];
                        h.sounds{i}.chanl{k}.outside=0;
                        for c=1:3
                            if(h.rooms{k}.srcpos(c)<0 || h.rooms{k}.srcpos(c)> h.room.boxsize(c))
                                h.sounds{i}.chanl{k}.outside=1;
                            end
                        end
                        if(h.sounds{i}.chanl{k}.outside)%%instrument ouside the room are muted
                            msg=sprintf('instrument %d of (sound %d ) is outside the room,so it has been muted',h.sounds{i}.chanl{k},i);set(h.text2status,'String',msg);drawnow;%user info displaying
                        else
                            msg=sprintf('RIR calculation of instrument %d of (sound %d )',k,i);set(h.text2status,'String',msg);drawnow;%user info displaying
                            h.room.ir{i,k} = razr(h.rooms{k},p.fig.op);
                            msg=sprintf('* calculation, instrument %d of (sound %d )',k,i);set(h.text2status,'String',msg);drawnow;%user info displaying
                            h.room.out= apply_rir(h.room.ir{i,k},'src',h.sounds{i}.track(h.ptr_audio:h.ptr_audio+h.buffersize,h.sounds{i}.chanl{k}.num),'normalize',h.norm);
                            h.sounds{i}.chanl{k}.chgcoord=0;%reset the flag,while no change occurs the rir will be not calculate again.
                            h.Tv(i,k)=h.buffersize+length(h.room.ir{i,k}.sig(:,1));%lenght of the ouput song
                        end
                    end
                    if(endflag==1)
                        h.Tv(i,k)=length(h.room.out{1})-1;%fprintf('end');
                    end
                    %%
                    %%mixing ouputs
                    if (k == 1 && i==1 && h.ptr_audio==1)%to initialize the ouput, assuming that the ouput lenght
                        sz=[h.maxlength+20*44100,2];%is below the size of the largest track + 20s -true for a realisitc simulation-
                        h.out_res=zeros(sz);
                        if(h.sounds{i}.chanl{k}.outside)%instrument ouside the room are muted
                        else
                            L=h.ptr_audio+h.Tv(i,k);
                            h.out_res(h.ptr_audio:L,1:2)=h.room.out{1};
                        end
                    else
                        if(h.sounds{i}.chanl{k}.outside)%%instrument ouside the room are muted
                        else
                            L=h.ptr_audio+h.Tv(i,k);
                            h.out_res(h.ptr_audio:L,1:2) = h.out_res(h.ptr_audio:L,1:2)+ h.room.out{1};
                        end
                    end
                    
                    %%
                    msg=sprintf('Audio of instrument %d of (sound %d ) => done',k,i);
                    set(h.text2status,'String',msg);drawnow;
                end%channel loop
            end%sound loop
            playrec('play',h.out_res(h.ptr_audio:h.ptr_audio+h.buffersize,1:2),[1 2]);%load audio data in the audio buffer
            p.fig.chg=0;
            h.ptr_audio=h.ptr_audio+h.buffersize+1;%next part to compute
            set(0,'UserData',p);
            
        end
    end
    msg=sprintf('Idle');
    set(h.text2status,'String',msg);
    guidata(gcf,h);%%upload handle struct..
catch
    
end
