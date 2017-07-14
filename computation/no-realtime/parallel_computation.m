function parallel_computation(hObject, eventdata, h)
%%
%not supported now
%%
if(playrec('isInitialised'))
else
    playrec('init',44100,3,-1);
end
%set the latency,must be not to small oversise the song will have gape
%ouputsong=zeros(lght_trck,2);
% n=floor(h.maxlength/buffersize)
% h.maxlength/n
%a remplacer  par ir.fs pour un programmme plus generale
%h.maxlength
% h.out_res=zeros(1,1*h.maxlength,2);
endflag=0;
h.audiopage=playrec('getPageList');
b_sz=size(h.audiopage);
if(b_sz(2)<2)
    if (h.ptr_audio<h.maxlength)
        p = get(0,'UserData');
        h.room.t60=p.fig.room.t60;
        h.buffersize=floor(h.totalchnl*(mean(h.room.t60)+0.5)*44100);
        h.chg=p.fig.chg;
        h.usemat=p.fig.usemat;
        if(h.usemat)
            h.room.materials=p.fig.room.materials;
        end
        h.norm=logical(strcmp(h.normalization.Checked,'on'));
        if(p.fig.chg==1)
            h.room.boxsize=[str2double(get(h.edtx,'String')),str2double(get(h.edty,'String')),str2double(get(h.edtz,'String'))];
            pos=getPosition(h.receiver.coord);
            h.room.srcpos= [1, 1, 1];
            h.room.recpos = [pos(1)-h.r.xmin,  pos(2)-h.r.ymin,  h.room.boxsize(3)/2];
        end
        for i= 1:h.filenum-1
            
            h.buffersize=floor(h.totalchnl*(mean(h.room.t60)+0.5)*44100);
            if(h.ptr_audio+h.buffersize>h.sounds{i}.lght)
                h.buffersize=h.sounds{i}.lght-h.ptr_audio;
                if(h.buffersize<0)
                    h.buffersize=0;
                end
                
                endflag=1;
            end
            for k= 1:h.sounds{i}.nbchnl
                msg=sprintf('RIR calculation of instrument %d of (sound %d )',k,i);
                set(h.text2status,'String',msg);drawnow;
                if(h.sounds{i}.chanl{k}.chgcoord==0 && p.fig.chg==0)
                    h.room.out= apply_rir(h.room.ir{i,k},'src',h.sounds{i}.track(h.ptr_audio:h.ptr_audio+h.buffersize,h.sounds{i}.chanl{k}.num),'normalize',h.norm);
                else
                    
                    pos=getPosition(h.sounds{i}.chanl{k}.coord);
                    h.rooms{k}=h.room;
                    h.rooms{k}.srcpos=[pos(1)-h.r.xmin,pos(2)-h.r.ymin,h.sounds{i}.chanl{k}.z];
                    h.room.ir{i,k} = razr(h.rooms{k},h.op);
                    h.room.out= apply_rir(h.room.ir{i,k},'src',h.sounds{i}.track(h.ptr_audio:h.ptr_audio+h.buffersize,h.sounds{i}.chanl{k}.num),'normalize',h.norm);
                    h.sounds{i}.chanl{k}.chgcoord=0;
                    h.Tv(i,k)=h.buffersize+length(h.room.ir{i,k}.sig(:,1));
                end
                if(endflag==1)
                    h.Tv(i,k)=length(h.room.out{1})-1
                    fprintf('end');
                end
                
                if (k == 1 && i==1 && h.ptr_audio==1)
                    sz=[h.maxlength+20*44100,2];
                    h.out_res=zeros(sz);
                    L=h.ptr_audio+h.Tv(i,k);
                    h.out_res(h.ptr_audio:L,1:2)=h.room.out{1};
                else
                    L=h.ptr_audio+h.Tv(i,k);
                                 fprintf('\nmixing\n');
                                 length( h.room.out{1})
                                 length(h.out_res(h.ptr_audio:L,1:2))
                    h.out_res(h.ptr_audio:L,1:2) = h.out_res(h.ptr_audio:L,1:2)+ h.room.out{1};
                end
            end
            
        end
        playrec('play',h.out_res(h.ptr_audio:h.ptr_audio+h.buffersize,1:2),[1 2]); %buffer size/latence a laquelle est joue le morceau a modifier
        p.fig.chg=0;
        h.ptr_audio=h.ptr_audio+h.buffersize+1;
        set(0,'UserData',p);
    end
end
guidata(gcf,h);

