function init_parameters()
%%init_parameters()
%this function initialize the UI graphic object related to the options
%define in get default options
%I write it to avoid a long affection for each object 
%some modification should be done for some case (popupmenu) 
%Because the list of graphic object is very long we use a function wich
%take the name of the graphic object and affect the corresponding parameter
p = get(0,'UserData');
h=guidata(gcf);
%%
%%editbox init
%list of the graphical edit box object to initalize....
edit_name={'editfs','edittlen','edittlenmax','editspl0db','editsplsource','editseedshift'...
    'editnumdelay','editstrechfactor','editismorder','editdiscardorder',...
    'editismposrandomfact','editismrandompos','editrandomjitter','editrismeflecgain','editspecratio'};

edt_param_name={'fs','tlen','tlen_max','SPL_at_0dBFS','SPL_source','seed_shift'...
    'fdn_numDelays','fdn_mfactor','ism_order','ism_discd_dir_orders',...
    'ism_randFactorsInCart','ism_ISposRandFactor','ism_rand_start_order','ism_refl_gain','ism_diffu_specu_ratio'};


for i=1:size(edit_name,2)
    if(isfield(p.fig.op,edt_param_name{i}))
    set(h.(edit_name{i}),'String',sprintf('%f',p.fig.op.(edt_param_name{i})));
    else
    set(h.(edit_name{i}),'String',sprintf('%f',p.parhand.defop.(edt_param_name{i})));
    end
end
%%
%checkbox init
chkbox_name={'checkboxpseudorando','checkboxverbositty','checkboxsmearing','checkboxfdnenable',...
        'checkboxsmearfdn','checkboxabsfilter','checkboxreflecfilter','checkboxfdnbandpass',...
        'checkboxhrtfcube','checkboxchnlmapping','checkboxhrtfdiago','checkboxismonly',...
        'checkboxismreflecfilter','checkboxismdiffusion','checkboxrandompos',...
        'checkboxairabsoprtion','checkboxtyonecorrect','checkboxdiffracfilter',...
        'checkboxtimesspread','checkboxismbanpass','checkboxism_hiord'};
    
    
chkbox_param_name={'pseudoRand','verbosity','enableSR','fdn_enabled',...
        'fdn_enable_apc','fdn_enableReflFilt','fdn_enableReflFilt','fdn_enableBP',...
        'fdn_hrtf_on_cube','fdn_smart_ch_mapping','fdn_hrtf_boxdiags','ism_only',...
        'ism_enableReflFilt','ism_enable_diffusion','ism_norand_if_diffr',...
        'ism_enableAirAbsFilt','ism_enableToneCorr','ism_enableDiffrFilt',...
        'ism_enable_timespread','ism_enableBP','ism_hiord_always_valid'};
for i=1:size(chkbox_name,2)
    
    if(isfield(p.fig.op,chkbox_param_name{i}))
        if(i==12)%ism_only = -1 is not a possible value for a checkbox so a converstion need to be done...
            set(h.(chkbox_name{i}),'Value',1+p.fig.op.(chkbox_param_name{i}));
        else
            set(h.(chkbox_name{i}),'Value',p.fig.op.(chkbox_param_name{i}));
        end
    else
        if(i==12)%ism_only = -1 is not a possible value for a checkbox so a converstion need to be done...
            set(h.(chkbox_name{i}),'Value',1+p.parhand.defop.(chkbox_param_name{i}));
        else
            set(h.(chkbox_name{i}),'Value',p.parhand.defop.(chkbox_param_name{i}));
        end
    end
end
%%
%popup menu init
popupmenu_name={'popupmenudiffrac','popupmenufiltcrea','popupmenusphericalmodel','popupmenusmearingtype','popupmenurtestimation',...
'popupmenuspatia','popupmenuhrtf','popupmenurenders','popupmenumatrix','popupmenudelaycrit','popupmenudelaytype'};
popupmenu_param_name={'diffrFiltMeth','filtCreatMeth','shm_warpMethod','typeSR','rt_estim',...
'spat_mode','hrtf_database','array_render','fdn_fmatrix','fdn_delay_criterion','fdn_delays_choice'};
for i=1:size(popupmenu_name,2)
   fields=get(h.(popupmenu_name{i}),'String');
   fields_number=size(fields,2);
   for j=1:fields_number
       if(isfield(p.fig.op,popupmenu_param_name{i}))
           if(strcmp(p.fig.op.(popupmenu_param_name{i}),fields(j)))
           set(h.(popupmenu_name{i}),'Value',j);
           break;
           end
       elseif(strcmp(p.parhand.defop.(popupmenu_param_name{i}),fields(j)))
           set(h.(popupmenu_name{i}),'Value',j);
           break;
       end
   end
end
% because for some case the content of the popmenu is different of the
% value taked in the options a spefic converstion  should be done to have
% the good value...
%
