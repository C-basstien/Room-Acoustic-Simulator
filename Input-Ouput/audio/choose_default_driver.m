function defaultdriver = choose_default_driver()
%%function defaultdriver = choose_default_driver()
%this function choose the default ouput driver of playrec function
%%
deviceslist=playrec('getDevices');
devices_num=size(deviceslist,2);
%this function is just taking the first driver with 2 ouput and fs = 44100
for i= 1:devices_num
    if(deviceslist(i).outputChans==2 && deviceslist(i).defaultSampleRate==44100)
        defaultdriver=deviceslist(i).deviceID;
        return;
    end
end

