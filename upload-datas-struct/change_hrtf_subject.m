function change_hrtf_subject(hObject, eventdata, handles)
%%change_hrtf_subject(hObject, eventdata, handles)
%This is a callback function to change the Subject of the Head Relative Transfer Function (HRTF)
%It invite the user to select the folder corresponding to the subject.
%Only supported with CIPIC database currently.
%%
dbase ='cipic';
cfg = get_razr_cfg;
fldname = sprintf('hrtf_path__%s', dbase);
if isfield(cfg, fldname)
    hrtf_path = cfg.(fldname);
else
    error('Path to HRTF databse "%s" not specified in razr_cfg.m.', database);
end
folder_name=uigetdir(hrtf_path,'Select the folder of the respective subject. Only working with cipic std data base !');
hf= guidata(gcf);
hf.chg=1;
hf.op.hrtf_options.subject=0;
l=length(folder_name);
for i=0:l-1
    if(folder_name(l-i)<58 && folder_name(l-i)>47)%detect the number of the subject  in the folder name
        hf.op.hrtf_options.subject=hf.op.hrtf_options.subject+(folder_name(l-i)-48)*10.^i;
    else
        break;
    end
end
set(handles.text1subj,'String',sprintf('Subject %d',hf.op.hrtf_options.subject));%change the corresponding text object
guidata(gcf, hf);%upload the new handles structure