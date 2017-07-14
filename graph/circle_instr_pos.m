function coord_instr = circle_instr_pos(ctr,room_sizes,n_inst)
%%coord_instr = circle_instr_pos(ctr,room_sizes,n_inst)
%function to position in a circle the instrument
%%
    if(room_sizes(1)>room_sizes(2))
      r=room_sizes(2)/4;  
    else
      r=room_sizes(1)/4;  
    end
    coord_instr=ones(n_inst,3);
    for i=1:n_inst
        coord_instr(i,1:3)=[ctr(1)+r*cos(2*pi*i/(n_inst+1)),ctr(2)+ r*sin(2*pi*i/(n_inst+1)),ctr(3)];
    end
    
    return
    
