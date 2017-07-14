function upload_paramGUIt60(value,type,indice)
%upload_paramGUIt60(value,type,indice)
%This function is callback fubnction to change all 
%the content of graphical object related to t60
%value t60 value 
%type:globalmean change by a multiplicative factor all the t60()f
%others type input change justr the value of t60(f) f specify by the indice
%indice 1:5 represent the frequency
%%
p = get(0,'UserData');%using UserData to share the data between multiple figure . 
if (p.upload==1)
else
    p.upload=1;
    set(0,'Userdata',p);
    p = get(0,'UserData');

    m=mean(p.fig.room.t60);
    p.fig.chg=1;
    inf_flg=0;
    if(value<0.01)
        value=0.01;
    elseif(value>p.fig.maxt60)
        upload_paramGUIt60max(value);
    end
    if(strcmp(type,'globalmean'))%%The global t60 has been changed

        if(isfield(p,'parhand'))%mean if the figure parameter is open 
            if(value<0.01)%test if the t60 value is ok
                value=0.01;
            elseif(value>p.fig.maxt60)
                upload_paramGUIt60max(value);
            end
            for i= 1:5
                new_val=p.fig.room.t60(i)*value/m;%propotional factor
                editname=sprintf('edit%dt60',i);
                if(new_val>p.fig.maxt60)%test if the t60 value is ok
                    upload_paramGUIt60max(new_val);
                elseif(new_val<0.01)
                    new_val=0.01;
                    inf_flg=1;
                end
                p.fig.room.t60(i)=new_val;
                set(p.parhand.(editname),'String',sprintf('%f',new_val));%.(editname) matlab trick to read a field of an object by a dtring
                setPosition(p.parhand.rvrb_trf{i},p.fig.room.freq(i),new_val);
                setPosition(p.fig.rvrb_trf{i},p.fig.room.freq(i),new_val);
            end
            val=mean(p.fig.room.t60);
            p.fig.globalt60=val;
            set(p.fig.slider1globalt60,'Value',val);
            set(p.parhand.slider2globalt60,'Value',val);
            set(p.fig.edit1globalt60,'String',sprintf('%f',val));
            set(p.parhand.edit2globalt60,'String',sprintf('%f',val))
            if(inf_flg)
                p.parhand.yp = interp1(p.fig.room.freq,p.fig.room.t60,p.parhand.xp ,'pchip');%interpolation curve
                p.fig.yp = p.parhand.yp;
            else
                p.parhand.yp=p.parhand.yp*val/m;
                p.fig.yp=p.parhand.yp;
            end
            set(p.parhand.plt,'ydata',p.parhand.yp);
            set(p.fig.plt,'ydata',p.fig.yp);
        else%mean the figure parameter is not open 

            for i= 1:5
                p.fig.room.t60(i)=p.fig.room.t60(i)*value/m;
                if(p.fig.room.t60(i)>p.fig.maxt60)
                    upload_paramGUIt60max(p.fig.room.t60(i));
                elseif (p.fig.room.t60(i)<0.01)
                    p.fig.room.t60(i)=0.01;
                    inf_flg=1;
                end
                setPosition(p.fig.rvrb_trf{i},p.fig.room.freq(i),p.fig.room.t60(i));
            end
            val=mean(p.fig.room.t60);
            p.fig.globalt60=val;
            set(p.fig.slider1globalt60,'Value',val);
            set(p.fig.edit1globalt60,'String',sprintf('%f',val));
            if(inf_flg)
                p.fig.yp = interp1(p.fig.room.freq,p.fig.room.t60,p.fig.xp ,'pchip');
            else
                p.fig.yp=p.fig.yp*val/m;
            end
            set(p.fig.plt,'ydata',p.fig.yp);
        end

    else%%just a t60(f) has been changed
        p.fig.room.t60(indice)=value;
        m=mean(p.fig.room.t60);
        if(m>p.fig.maxt60)
            upload_paramGUIt60max(m);
        end
        if(isfield(p,'parhand'))
            editname=sprintf('edit%dt60',indice);
            set(p.parhand.(editname),'String',sprintf('%f',value));
            p.parhand.yp = interp1(p.fig.room.freq,p.fig.room.t60,p.parhand.xp ,'pchip');
            set(p.parhand.plt,'ydata',p.parhand.yp);
            setPosition(p.parhand.rvrb_trf{indice},p.fig.room.freq(indice),value);
            set(p.parhand.slider2globalt60,'Value',m);
            set(p.parhand.edit2globalt60,'String',sprintf('%f',m));
        end
        p.fig.yp = interp1(p.fig.room.freq,p.fig.room.t60,p.fig.xp ,'pchip');%interpolation curve
        set(p.fig.plt,'ydata',p.fig.yp);
        setPosition(p.fig.rvrb_trf{indice},p.fig.room.freq(indice),value);
        set(p.fig.slider1globalt60,'Value',m);
        set(p.fig.edit1globalt60,'String',sprintf('%f',m));
    end
    p.upload=0;
    p.fig.chg=1;
    set(0,'Userdata',p);
end