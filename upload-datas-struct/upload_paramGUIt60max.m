function upload_paramGUIt60max(value)
%upload_paramGUIt60(value,type,indice)
%This function is callback fubnction to change all 
%the content of graphical object related to t60. If a t60 is higher than
%the max proprety of the graphical objects
%%
    p = get(0,'UserData');
    if(isfield(p,'parhand'))
        set(p.parhand.axes2,'YLim',[0,value*1.1]);
        set(p.parhand.slider2globalt60,'Max',value*1.1);
    end
    Ylim=[0 value*1.1];
    set(p.fig.axes5,'YLim',[0,value*1.1]);
    for i= 1:5
        Xlim=[p.fig.room.freq(i),p.fig.room.freq(i)];
        fcn = makeConstrainToRectFcn('impoint',Xlim,Ylim);
        setPositionConstraintFcn(p.fig.rvrb_trf{i},fcn);
    end

    set(p.fig.slider1globalt60,'Max',value*1.1);
    p.fig.maxt60=1.1*value;
    set(0,'Userdata',p);