function [soundo1,soundo2] = up_sample(soundi1, soundi2, mode)
%[soundo1,soundo2] = up_sample(soundi1, soundi2, mode)
%This function can be used to mix audio signals of diffrent size.
%It's change the vector size of sound which is the smaller.
%Mode:
%padding: fill the new colonum with 0
%loop (default: fill the new colonum with the previous samples of the sound
if(length(soundi1)>length(soundi2))
    soundo1=soundi1;
    soundo2=soundi1;
    n = length(soundi1);
    m=length(soundi2(:,1));
    for i = 1:n
        if (strcmp(mode,'padding'))
            if(i<length(soundi2))
                soundo2(i,1)=soundi2(i,1);
                soundo2(i,2)=soundi2(i,2);
            else
                soundo2(i,1)=0;
                soundo2(i,2)=0;
            end
        else
            j=mod(i-1,m)+1;
            soundo2(i,1)=soundi2(j,1);
            soundo2(i,2)=soundi2(j,2);
        end
    end
else
    [soundo2,soundo1] = up_sample(soundi2, soundi1, mode);
end
return
    
