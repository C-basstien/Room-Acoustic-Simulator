function add_track(src,eventdata)
%%function add_track(src,eventdata)
%This function is a callback that occur on mouse click on the axes
%A window invite a user to choose one or severals wav files to add in the
%scene, intrument are automatically set in an ellipse shape around the point the user
%clicked on. The shape of the ellipse depents how much you are close to the
%boundary of the room, to avoid to have instrument outside of the room
%%
hf= guidata(gcf);
coords=get(src,'currentpoint');
x=coords(1,1,1);
y=coords(1,2,1);
[nme,pth] = uigetfile('*.wav','Select one or more .wav files in the same folder','MultiSelect','on');
if (ischar(nme))
    sz=1;n{1}=nme;nme={};nme{1}=n{1};
else
    sz=size(nme);sz=sz(2);
end
if (sz==1)%%only one file
    if(pth==0)%%mean nothing select
    else
        
        hf.coord{1}=[x,y,0];
        hf.namefilelist{hf.filenum}=nme{1};
        hf.pathfilelist{hf.filenum}=strcat(pth,nme{1});
        set(hf.text1status,'String','Extract Audio...');
        set(hf.text1status,'ForegroundColor','r');
        drawnow;
        [hf.sounds{hf.filenum}.track, hf.sounds{hf.filenum}.fs] = audioread( hf.pathfilelist{hf.filenum});%read the file
        set(hf.text1status,'String','Ready');
        set(hf.text1status,'ForegroundColor','c');
        drawnow;
        nchannel=length(hf.sounds{hf.filenum}.track(1,:));
        hf.sounds{hf.filenum}.lght=length(hf.sounds{hf.filenum}.track(:,1));
        if(isfield(hf,'maxlength'))
            if(hf.maxlength<hf.sounds{hf.filenum}.lght)
                hf.maxlength=hf.sounds{hf.filenum}.lght;
            end
        else
             hf.maxlength=hf.sounds{hf.filenum}.lght;
        end

        ask=sprintf('%d channel in the wav file, play  them all (enter empty)?\nOr specify the ones you are looking for in a line vector',nchannel);
        chnl= inputdlg(ask,nme{1});chnl=str2num(chnl{1});
        if (isempty(chnl))
            chnl=1:nchannel;
        end
        nslctd_chnl=length(chnl);
        hf.sounds{hf.filenum}.nbchnl=nslctd_chnl;
        if(nslctd_chnl==1)%only one channel select
            if (chnl>nchannel || chnl<1 )
                error('Channel selected %d does not exist',chnl);
            else
                
                chnlstr=sprintf(' - channel %d',chnl);
                hf.sounds{hf.filenum}.chanl{1}.coord=impoint(gca,x, y);%create a draggable point 
                hf.sounds{hf.filenum}.chanl{1}.num=chnl;
                setString(hf.sounds{hf.filenum}.chanl{1}.coord,strcat(hf.namefilelist{hf.filenum},chnlstr));
                call_pos{hf.filenum,1}= @(pos)callback_impoint(hf.sounds{hf.filenum}.chanl{1}.coord,1,pos,hf.filenum,1);
                id=addNewPositionCallback(hf.sounds{hf.filenum}.chanl{1}.coord, call_pos{hf.filenum,1});
                hf.sounds{hf.filenum}.chanl{1}.clbk=id;
                hf.sounds{hf.filenum}.chanl{1}.chgcoord=1;
                hf.sounds{hf.filenum}.chanl{1}.z=str2double(get(hf.edtz,'String'));
                hf.totalchnl=hf.totalchnl+1;
                
            end
        else%severals channels select
            for i= 1:nslctd_chnl
                
                if (chnl(i)>nchannel || chnl(i)<1 )
                    error('Channel selected %d does not exist',chnl(i));
                else
                    chnlstr=sprintf(' - channel %d',chnl(i));
                    a=x+(x)*(x-hf.room.boxsize(1))*cos(2*pi*i/(nslctd_chnl))/(hf.room.boxsize(1));
                    b=y+(y)*(y-hf.room.boxsize(2))*sin(2*pi*i/(nslctd_chnl))/(hf.room.boxsize(2));
                    hf.sounds{hf.filenum}.chanl{i}.coord=impoint(gca,a,b);%create a draggable point 
                    hf.sounds{hf.filenum}.chanl{i}.num=chnl(i);
                    setString(hf.sounds{hf.filenum}.chanl{i}.coord,strcat(hf.namefilelist{hf.filenum},chnlstr));
                    call_pos{hf.filenum,i}= @(pos)(callback_impoint(hf.sounds{hf.filenum}.chanl{i}.coord,1,pos,hf.filenum,i));
                    id=addNewPositionCallback(hf.sounds{hf.filenum}.chanl{i}.coord,call_pos{hf.filenum,i});
                    hf.sounds{hf.filenum}.chanl{i}.clbk=id;
                    hf.sounds{hf.filenum}.chanl{i}.chgcoord=1;
                    hf.sounds{hf.filenum}.chanl{i}.z=str2double(get(hf.edtz,'String'));
                    hf.totalchnl=hf.totalchnl+1;
                end
                
            end
        end
        hf.filenum=hf.filenum+1;
    end
else%%several files to put in the spaces
    for i= 1:sz

        hf.namefilelist{hf.filenum+i-1}=nme{i};
        hf.pathfilelist{hf.filenum+i-1}=strcat(pth,nme{i});
        set(hf.text1status,'String','Extract Audio...');
        set(hf.text1status,'ForegroundColor','r');
        drawnow;
        [hf.sounds{hf.filenum+i-1}.track, hf.sounds{hf.filenum+i-1}.fs] = audioread( hf.pathfilelist{hf.filenum+i-1});
        set(hf.text1status,'String','Ready');
        set(hf.text1status,'ForegroundColor','c');
        drawnow;
        nchannel=length(hf.sounds{hf.filenum+i-1}.track(1,:));
        ask=sprintf('%d channel in the wav file, play  them all (enter empty)?\nOr specify the ones you are looking for in a line vector',nchannel);
        xs=x+(x+hf.r.xmin)*(x-hf.room.boxsize(1)-hf.r.xmin)*cos(2*pi*i/(sz))/(hf.room.boxsize(1));
        ys=y+(y+hf.r.ymin)*(y-hf.room.boxsize(2)-hf.r.ymin)*sin(2*pi*i/(sz))/(hf.room.boxsize(2));
        hf.sounds{hf.filenum+i-1}.lght=length(hf.sounds{hf.filenum+i-1}.track(:,1));
         if(isfield(hf,'maxlength'))
            if(hf.maxlength<hf.sounds{hf.filenum+i-1}.lght)
                hf.maxlength=hf.sounds{hf.filenum+i-1}.lght;
            end
         else
            hf.maxlength=hf.sounds{hf.filenum+i-1}.lght;
         end
        chnl= inputdlg(ask,nme{i});chnl=str2num(chnl{1});
        if (isempty(chnl))
            chnl=1:nchannel;
        end
        nslctd_chnl=length(chnl);
        hf.sounds{hf.filenum+i-1}.nbchnl=nslctd_chnl;
        if(nslctd_chnl==1)%one channel
            if (chnl>nchannel || chnl<1 )
                error('Channel selected %d does not exist',chnl(i));
            else
                chnlstr=sprintf(' - channel %d',chnl);
                hf.sounds{hf.filenum+i-1}.chanl{1}.coord=impoint(gca,xs, ys);
                hf.sounds{hf.filenum+i-1}.chanl{1}.num=chnl;
                setString(hf.sounds{hf.filenum+i-1}.chanl{1}.coord,strcat(hf.namefilelist{hf.filenum+i-1},chnlstr));
                call_pos{hf.filenum+i-1,1}= @(pos) callback_impoint(hf.sounds{hf.filenum+i-1}.chanl{1}.coord,1,pos,hf.filenum+i-1,1);%create a draggable point 
                id=addNewPositionCallback(hf.sounds{hf.filenum+i-1}.chanl{1}.coord,call_pos{hf.filenum+i-1,1});
                hf.sounds{hf.filenum+i-1}.chanl{1}.clbk=id;
                hf.sounds{hf.filenum+i-1}.chanl{1}.chgcoord=1;
                hf.sounds{hf.filenum+i-1}.chanl{1}.z=str2double(get(hf.edtz,'String'));
                hf.totalchnl=hf.totalchnl+1;
            end
        else%several channel
            for j= 1:nslctd_chnl
                if (chnl(j)>nchannel || chnl(j)<1 )
                    error('Channel selected %d does not exist',chnl(i));
                else
                    chnlstr=sprintf(' - channel %d',chnl(j));
                    a=xs+(xs-hf.r.xmin)*(xs-hf.room.boxsize(1)-hf.r.xmin)*cos(2*pi*j/(nslctd_chnl))/(2*hf.room.boxsize(1));
                    b=ys+(ys-hf.r.ymin)*(ys-hf.room.boxsize(2)-hf.r.ymin)*sin(2*pi*j/(nslctd_chnl))/(2*hf.room.boxsize(2));
                    hf.sounds{hf.filenum+i-1}.chanl{j}.coord=impoint(gca,a,b);%create a draggable point 
                    hf.sounds{hf.filenum+i-1}.chanl{j}.num=chnl(j);
                    setString(hf.sounds{hf.filenum+i-1}.chanl{j}.coord,strcat(hf.namefilelist{hf.filenum+i-1},chnlstr));
                    call_pos{hf.filenum+i-1,j}= @(pos) callback_impoint(hf.sounds{hf.filenum+i-1}.chanl{j}.coord,1,pos,hf.filenum+i-1,j);
                    id=addNewPositionCallback(hf.sounds{hf.filenum+i-1}.chanl{j}.coord,call_pos{hf.filenum+i-1,j});
                    hf.sounds{hf.filenum+i-1}.chanl{j}.clbk=id;
                    hf.sounds{hf.filenum+i-1}.chanl{j}.chgcoord=1;
                    hf.sounds{hf.filenum+i-1}.chanl{j}.z=str2double(get(hf.edtz,'String'));
                    hf.totalchnl=hf.totalchnl+1;
                end
            end
        end
    end
    hf.filenum=hf.filenum+sz;%indic the number of file in the scene to compute
end
set(hf.text2status,'String','You can now, drag the instument in the box and then compute the audio result of this musical scene: press load');
drawnow;
guidata(gcf, hf);
set(gcf,'windowbuttonupfcn',@done_add_track);%remove the callback on mouse button up event
