% Written by Ali Hassani in MatLab R2021a
% Prepared for github on April 11th 2023 (last edited: April 11th 2023)
% Please contact Ali Hassani (seyed.ali.hassani@gmail.com) if you have any
% questions regarding the script or data.

clear

% SET PATHING AS NEEDED
Reider= load('/Users/.../VU595_data_Reider.mat');
Sindri = load('/Users/.../VU595_data_Sindri.mat');
Igor = load('/Users/.../VU595_data_Igor.mat');
Bard= load('/Users/.../VU595_data_Bard.mat');
%figSave_dir = '/Users/.../';

% plotting parameters 

drug_plot_colors = [0 0 0; 0 1 0; 1 0.6 0.3; 1 0 0];
last_trial_window = 10;
min_block_len = 35;

% defining vehicle & drug days

rec_day_of_week = [Reider.rec_day_of_week, Sindri.rec_day_of_week, Igor.rec_day_of_week, Bard.rec_day_of_week];

vehicle = 'M/T';% vehicle_days_ind redfined here as seen fit
%note: if vehicle is changed from M/T, may need to adjust bad block edits
switch vehicle
    case 'M'
        vehicle_days_ind = strcmp(rec_day_of_week,'M');
    case 'T'
        vehicle_days_ind = strcmp(rec_day_of_week,'T');
    case 'M/T'
        vehicle_days_ind = logical(strcmp(rec_day_of_week,'M') + strcmp(rec_day_of_week,'T'));
end

drug_1days_ind = [Reider.drug_1days_ind, Sindri.drug_1days_ind, Igor.drug_1days_ind, Bard.drug_1days_ind]; % low dose
drug_2days_ind = [Reider.drug_2days_ind, Sindri.drug_2days_ind, Igor.drug_2days_ind, Bard.drug_2days_ind]; % med dose
drug_3days_ind = [Reider.drug_3days_ind, Sindri.drug_3days_ind, Igor.drug_3days_ind, Bard.drug_3days_ind]; % high dose

monkey_ind = [repmat({'Reider'},size(Reider.rec_day_of_week)),repmat({'Sindri'},size(Sindri.rec_day_of_week)),...
    repmat({'Igor'},size(Igor.rec_day_of_week)),repmat({'Bard'},size(Bard.rec_day_of_week))];

sess_cond_label = cell(size(vehicle_days_ind)); sess_cond_label(find(vehicle_days_ind)) = {'vehicle'};
sess_cond_label(find(drug_1days_ind)) = {'drugLow'};sess_cond_label(find(drug_2days_ind)) = {'drugMed'};sess_cond_label(find(drug_3days_ind)) = {'drugHigh'};

%% FL ana and figures

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Learning curves %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

all_block_outcomes_prob = [Reider.all_block_outcomes_prob', Sindri.all_block_outcomes_prob', Igor.all_block_outcomes_prob', Bard.all_block_outcomes_prob'];
allFLU_dim_by_block = [Reider.allFLU_dim_by_block', Sindri.allFLU_dim_by_block', Igor.allFLU_dim_by_block', Bard.allFLU_dim_by_block'];

allFLU_dim_by_block_forCurves = allFLU_dim_by_block; allFLU_dim_by_block_forCurves{26}(18) = []; % bad block, previously NaN


lowDim_block_outcomes_prob = cellfun(@(x,y) [x(find(y==0),:)], all_block_outcomes_prob,allFLU_dim_by_block_forCurves,'un',0);
highDim_block_outcomes_prob = cellfun(@(x,y) [x(find(y==1),:)], all_block_outcomes_prob,allFLU_dim_by_block_forCurves,'un',0);

%raw trial outcomes
Reider_vehicle_learning_curve = cell2mat(all_block_outcomes_prob(intersect(find(vehicle_days_ind),find(strcmp(monkey_ind,'Reider'))))');
Reider_lowDim_vehicle_learning_curve = cell2mat(lowDim_block_outcomes_prob(intersect(find(vehicle_days_ind),find(strcmp(monkey_ind,'Reider'))))');
Reider_highDim_vehicle_learning_curve = cell2mat(highDim_block_outcomes_prob(intersect(find(vehicle_days_ind),find(strcmp(monkey_ind,'Reider'))))');
Sindri_vehicle_learning_curve = cell2mat(all_block_outcomes_prob(intersect(find(vehicle_days_ind),find(strcmp(monkey_ind,'Sindri'))))');
Sindri_lowDim_vehicle_learning_curve = cell2mat(lowDim_block_outcomes_prob(intersect(find(vehicle_days_ind),find(strcmp(monkey_ind,'Sindri'))))');
Sindri_highDim_vehicle_learning_curve = cell2mat(highDim_block_outcomes_prob(intersect(find(vehicle_days_ind),find(strcmp(monkey_ind,'Sindri'))))');
Igor_vehicle_learning_curve = cell2mat(all_block_outcomes_prob(intersect(find(vehicle_days_ind),find(strcmp(monkey_ind,'Igor'))))');
Igor_lowDim_vehicle_learning_curve = cell2mat(lowDim_block_outcomes_prob(intersect(find(vehicle_days_ind),find(strcmp(monkey_ind,'Igor'))))');
Igor_highDim_vehicle_learning_curve = cell2mat(highDim_block_outcomes_prob(intersect(find(vehicle_days_ind),find(strcmp(monkey_ind,'Igor'))))');
Bard_vehicle_learning_curve = cell2mat(all_block_outcomes_prob(intersect(find(vehicle_days_ind),find(strcmp(monkey_ind,'Bard'))))');
Bard_lowDim_vehicle_learning_curve = cell2mat(lowDim_block_outcomes_prob(intersect(find(vehicle_days_ind),find(strcmp(monkey_ind,'Bard'))))');
Bard_highDim_vehicle_learning_curve = cell2mat(highDim_block_outcomes_prob(intersect(find(vehicle_days_ind),find(strcmp(monkey_ind,'Bard'))))');

all_vehicle_learning_curve = [Reider_vehicle_learning_curve;Sindri_vehicle_learning_curve;Igor_vehicle_learning_curve;Bard_vehicle_learning_curve];
all_lowDim_vehicle_learning_curve = [Reider_lowDim_vehicle_learning_curve;Sindri_lowDim_vehicle_learning_curve;Igor_lowDim_vehicle_learning_curve;Bard_lowDim_vehicle_learning_curve];
all_highDim_vehicle_learning_curve = [Reider_highDim_vehicle_learning_curve;Sindri_highDim_vehicle_learning_curve;Igor_highDim_vehicle_learning_curve;Bard_highDim_vehicle_learning_curve];

all_lowDim_drug1_learning_curve = cell2mat(lowDim_block_outcomes_prob(find(drug_1days_ind))');
all_highDim_drug1_learning_curve = cell2mat(highDim_block_outcomes_prob(find(drug_1days_ind))');
all_lowDim_drug2_learning_curve = cell2mat(lowDim_block_outcomes_prob(find(drug_2days_ind))');
all_highDim_drug2_learning_curve = cell2mat(highDim_block_outcomes_prob(find(drug_2days_ind))');
all_lowDim_drug3_learning_curve = cell2mat(lowDim_block_outcomes_prob(find(drug_3days_ind))');
all_highDim_drug3_learning_curve = cell2mat(highDim_block_outcomes_prob(find(drug_3days_ind))');

%SEM for plotting
Reider_vehicle_learning_curveSEM = cellfun (@SEM_AH,num2cell(Reider_vehicle_learning_curve,1));
Reider_lowDim_vehicle_learning_curveSEM = cellfun (@SEM_AH,num2cell(Reider_lowDim_vehicle_learning_curve,1));
Reider_highDim_vehicle_learning_curveSEM = cellfun (@SEM_AH,num2cell(Reider_highDim_vehicle_learning_curve,1));
Sindri_vehicle_learning_curveSEM = cellfun (@SEM_AH,num2cell(Sindri_vehicle_learning_curve,1));
Sindri_lowDim_vehicle_learning_curveSEM = cellfun (@SEM_AH,num2cell(Sindri_lowDim_vehicle_learning_curve,1));
Sindri_highDim_vehicle_learning_curveSEM = cellfun (@SEM_AH,num2cell(Sindri_highDim_vehicle_learning_curve,1));
Igor_vehicle_learning_curveSEM = cellfun (@SEM_AH,num2cell(Igor_vehicle_learning_curve,1));
Igor_lowDim_vehicle_learning_curveSEM = cellfun (@SEM_AH,num2cell(Igor_lowDim_vehicle_learning_curve,1));
Igor_highDim_vehicle_learning_curveSEM = cellfun (@SEM_AH,num2cell(Igor_highDim_vehicle_learning_curve,1));
Bard_vehicle_learning_curveSEM = cellfun (@SEM_AH,num2cell(Bard_vehicle_learning_curve,1));
Bard_lowDim_vehicle_learning_curveSEM = cellfun (@SEM_AH,num2cell(Bard_lowDim_vehicle_learning_curve,1));
Bard_highDim_vehicle_learning_curveSEM = cellfun (@SEM_AH,num2cell(Bard_highDim_vehicle_learning_curve,1));

all_vehicle_learning_curveSEM = cellfun (@SEM_AH,num2cell(all_vehicle_learning_curve,1));
all_lowDim_vehicle_learning_curveSEM = cellfun (@SEM_AH,num2cell(all_lowDim_vehicle_learning_curve,1));
all_highDim_vehicle_learning_curveSEM = cellfun (@SEM_AH,num2cell(all_highDim_vehicle_learning_curve,1));

all_lowDim_drug1_learning_curveSEM = cellfun (@SEM_AH,num2cell(all_lowDim_drug1_learning_curve,1));
all_highDim_drug1_learning_curveSEM = cellfun (@SEM_AH,num2cell(all_highDim_drug1_learning_curve,1));
all_lowDim_drug2_learning_curveSEM = cellfun (@SEM_AH,num2cell(all_lowDim_drug2_learning_curve,1));
all_highDim_drug2_learning_curveSEM = cellfun (@SEM_AH,num2cell(all_highDim_drug2_learning_curve,1));
all_lowDim_drug3_learning_curveSEM = cellfun (@SEM_AH,num2cell(all_lowDim_drug3_learning_curve,1));
all_highDim_drug3_learning_curveSEM = cellfun (@SEM_AH,num2cell(all_highDim_drug3_learning_curve,1));

%plotting learning curves
figure
subplot(2,2,1)
hold on
tmpplot1= shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(Reider_lowDim_vehicle_learning_curve)',3,2),Reider_lowDim_vehicle_learning_curveSEM','lineProps','c--','patchSaturation',0.2);
tmpplot2= shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(Sindri_lowDim_vehicle_learning_curve)',3,2),Sindri_lowDim_vehicle_learning_curveSEM','lineProps','m--','patchSaturation',0.2);
tmpplot3= shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(Igor_lowDim_vehicle_learning_curve)',3,2),Igor_lowDim_vehicle_learning_curveSEM','lineProps','--','patchSaturation',0.2);
tmpplot4= shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(Bard_lowDim_vehicle_learning_curve)',3,2),Bard_lowDim_vehicle_learning_curveSEM','lineProps','--','patchSaturation',0.2);
tmpplot3.patch.FaceColor=[0.4660 0.6740 0.1880];tmpplot3.mainLine.Color=[0.4660 0.6740 0.1880];tmpplot3.edge(1).Color=[0.4660 0.6740 0.1880];tmpplot3.edge(2).Color=[0.4660 0.6740 0.1880];
tmpplot4.patch.FaceColor=[0.9290 0.6940 0.1250];tmpplot4.mainLine.Color=[0.9290 0.6940 0.1250];tmpplot4.edge(1).Color=[0.9290 0.6940 0.1250];tmpplot4.edge(2).Color=[0.9290 0.6940 0.1250];
tmpplot5= shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(all_lowDim_vehicle_learning_curve)',3,2),all_lowDim_vehicle_learning_curveSEM','lineProps','k--','patchSaturation',0.2);
yline (0.33, 'k--'); yline (0.66, 'k--'); xlim([-10 35]); ylabel([0.2 1]);%yline(0.80, 'k'); 
legend([tmpplot1.mainLine, tmpplot2.mainLine, tmpplot3.mainLine, tmpplot4.mainLine tmpplot5.mainLine],{'Monkey Re', 'Monkey Si', 'Monkey Ig', 'Monkey Ba', 'Vehicle'},'Location','southeast');
ylabel('prop. correct'); xlabel('trial # from block switch'); title('low load only');

set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(2,2,2)
hold on
shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(Reider_highDim_vehicle_learning_curve)',3,2),Reider_highDim_vehicle_learning_curveSEM','lineProps','c:','patchSaturation',0.2);
shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(Sindri_highDim_vehicle_learning_curve)',3,2),Sindri_highDim_vehicle_learning_curveSEM','lineProps','m:','patchSaturation',0.2);
tmpplot2= shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(Igor_highDim_vehicle_learning_curve)',3,2),Igor_highDim_vehicle_learning_curveSEM','lineProps',':','patchSaturation',0.2);
tmpplot4= shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(Bard_highDim_vehicle_learning_curve)',3,2),Bard_highDim_vehicle_learning_curveSEM','lineProps',':','patchSaturation',0.2);
tmpplot2.patch.FaceColor=[0.4660 0.6740 0.1880];tmpplot2.mainLine.Color=[0.4660 0.6740 0.1880];tmpplot2.edge(1).Color=[0.4660 0.6740 0.1880];tmpplot2.edge(2).Color=[0.4660 0.6740 0.1880];
tmpplot4.patch.FaceColor=[0.9290 0.6940 0.1250];tmpplot4.mainLine.Color=[0.9290 0.6940 0.1250];tmpplot4.edge(1).Color=[0.9290 0.6940 0.1250];tmpplot4.edge(2).Color=[0.9290 0.6940 0.1250];
shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(all_highDim_vehicle_learning_curve)',3,2),all_highDim_vehicle_learning_curveSEM','lineProps','k:','patchSaturation',0.2);
yline (0.33, 'k--'); yline (0.66, 'k--'); xlim([-10 35]); ylabel([0.2 1]);%yline(0.80, 'k'); 
ylabel('prop. correct'); xlabel('trial # from block switch'); title('high load only');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(2,2,3)
hold on
tmpplot1= shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(all_lowDim_drug1_learning_curve)',3,2),all_lowDim_drug1_learning_curveSEM','lineProps','--','patchSaturation',0.2);
tmpplot2= shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(all_lowDim_drug2_learning_curve)',3,2),all_lowDim_drug2_learning_curveSEM','lineProps','--','patchSaturation',0.2);
tmpplot3= shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(all_lowDim_drug3_learning_curve)',3,2),all_lowDim_drug3_learning_curveSEM','lineProps','--','patchSaturation',0.2);
tmpplot1.patch.FaceColor=drug_plot_colors(2,:);tmpplot1.mainLine.Color=drug_plot_colors(2,:);tmpplot1.edge(1).Color=drug_plot_colors(2,:);tmpplot1.edge(2).Color=drug_plot_colors(2,:);
tmpplot2.patch.FaceColor=drug_plot_colors(3,:);tmpplot2.mainLine.Color=drug_plot_colors(3,:);tmpplot2.edge(1).Color=drug_plot_colors(3,:);tmpplot2.edge(2).Color=drug_plot_colors(3,:);
tmpplot3.patch.FaceColor=drug_plot_colors(4,:);tmpplot3.mainLine.Color=drug_plot_colors(4,:);tmpplot3.edge(1).Color=drug_plot_colors(4,:);tmpplot3.edge(2).Color=drug_plot_colors(4,:);
tmpplot4= shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(all_lowDim_vehicle_learning_curve)',3,2),all_lowDim_vehicle_learning_curveSEM','lineProps','k--','patchSaturation',0.2);
yline (0.33, 'k--'); yline (0.66, 'k--'); xlim([-10 35]); ylabel([0.2 1]);%yline(0.80, 'k'); 
ylabel('prop. correct'); xlabel('trial # from block switch'); title('low load only');
legend([tmpplot1.mainLine, tmpplot2.mainLine, tmpplot3.mainLine, tmpplot4.mainLine],{'VU595 0.3', 'VU595 1', 'VU595 3','Vehicle'},'Location','southeast');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(2,2,4)
hold on
tmpplot2= shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(all_highDim_drug1_learning_curve)',3,2),all_highDim_drug1_learning_curveSEM','lineProps',':','patchSaturation',0.2);
tmpplot4= shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(all_highDim_drug2_learning_curve)',3,2),all_highDim_drug2_learning_curveSEM','lineProps',':','patchSaturation',0.2);
tmpplot6= shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(all_highDim_drug3_learning_curve)',3,2),all_highDim_drug3_learning_curveSEM','lineProps',':','patchSaturation',0.2);
tmpplot2.patch.FaceColor=drug_plot_colors(2,:);tmpplot2.mainLine.Color=drug_plot_colors(2,:);tmpplot2.edge(1).Color=drug_plot_colors(2,:);tmpplot2.edge(2).Color=drug_plot_colors(2,:);
tmpplot4.patch.FaceColor=drug_plot_colors(3,:);tmpplot4.mainLine.Color=drug_plot_colors(3,:);tmpplot4.edge(1).Color=drug_plot_colors(3,:);tmpplot4.edge(2).Color=drug_plot_colors(3,:);
tmpplot6.patch.FaceColor=drug_plot_colors(4,:);tmpplot6.mainLine.Color=drug_plot_colors(4,:);tmpplot6.edge(1).Color=drug_plot_colors(4,:);tmpplot6.edge(2).Color=drug_plot_colors(4,:);
shadedErrorBar(-(last_trial_window-1):min_block_len,FilterLearningCurves(nanmean(all_highDim_vehicle_learning_curve)',3,2),all_highDim_vehicle_learning_curveSEM','lineProps','k:','patchSaturation',0.2);
yline (0.33, 'k--'); yline (0.66, 'k--'); xlim([-10 35]); ylabel([0.2 1]);%yline(0.80, 'k'); 
ylabel('prop. correct'); xlabel('trial # from block switch'); title('high load only');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
set(gcf,'Position',[1 1 920 579]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Temporal LP %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% individual monkey temporal progress (VU595)
Reider_vehicleDays = find(strcmp(Reider.rec_day_of_week,'M') + strcmp(Reider.rec_day_of_week,'T'));
Sindri_vehicleDays = find(strcmp(Sindri.rec_day_of_week,'M') + strcmp(Sindri.rec_day_of_week,'T'));
Igor_vehicleDays = find(strcmp(Igor.rec_day_of_week,'M') + strcmp(Igor.rec_day_of_week,'T'));
Bard_vehicleDays = find(strcmp(Bard.rec_day_of_week,'M') + strcmp(Bard.rec_day_of_week,'T'));

Reider_propLearned = [cellfun(@(x) [1-sum(isnan(x(1:7)))/7], Reider.allFLU_altLP_by_blockNum);...
    cellfun(@(x) [1-sum(isnan(x(8:14)))/7], Reider.allFLU_altLP_by_blockNum);...
    cellfun(@(x) [1-sum(isnan(x(15:end)))/7], Reider.allFLU_altLP_by_blockNum)];
Sindri_propLearned = [cellfun(@(x) [1-sum(isnan(x(1:7)))/7], Sindri.allFLU_altLP_by_blockNum);...
    cellfun(@(x) [1-sum(isnan(x(8:14)))/7], Sindri.allFLU_altLP_by_blockNum);...
    cellfun(@(x) [1-sum(isnan(x(15:end)))/7], Sindri.allFLU_altLP_by_blockNum)];
Igor_propLearned = [cellfun(@(x) [1-sum(isnan(x(1:7)))/7], Igor.allFLU_altLP_by_blockNum);...
    cellfun(@(x) [1-sum(isnan(x(8:14)))/7], Igor.allFLU_altLP_by_blockNum);...
    cellfun(@(x) [1-sum(isnan(x(15:end)))/7], Igor.allFLU_altLP_by_blockNum)];
Bard_propLearned = [cellfun(@(x) [1-sum(isnan(x(1:7)))/7], Bard.allFLU_altLP_by_blockNum);...
    cellfun(@(x) [1-sum(isnan(x(8:14)))/7], Bard.allFLU_altLP_by_blockNum);...
    cellfun(@(x) [1-sum(isnan(x(15:end)))/7], Bard.allFLU_altLP_by_blockNum)];

Reider_propLearned = [nanmean(Reider_propLearned(:,find(Reider.drug_1days_ind)),2)-nanmean(Reider_propLearned(:,Reider_vehicleDays),2),...
    nanmean(Reider_propLearned(:,find(Reider.drug_2days_ind)),2)-nanmean(Reider_propLearned(:,Reider_vehicleDays),2),...
    nanmean(Reider_propLearned(:,find(Reider.drug_3days_ind)),2)-nanmean(Reider_propLearned(:,Reider_vehicleDays),2)];
Sindri_propLearned = [nanmean(Sindri_propLearned(:,find(Sindri.drug_1days_ind)),2)-nanmean(Sindri_propLearned(:,Sindri_vehicleDays),2),...
    nanmean(Sindri_propLearned(:,find(Sindri.drug_2days_ind)),2)-nanmean(Sindri_propLearned(:,Sindri_vehicleDays),2),...
    nanmean(Sindri_propLearned(:,find(Sindri.drug_3days_ind)),2)-nanmean(Sindri_propLearned(:,Sindri_vehicleDays),2)];
Igor_propLearned = [nanmean(Igor_propLearned(:,find(Igor.drug_1days_ind)),2)-nanmean(Igor_propLearned(:,Igor_vehicleDays),2),...
    nanmean(Igor_propLearned(:,find(Igor.drug_2days_ind)),2)-nanmean(Igor_propLearned(:,Igor_vehicleDays),2),...
    nanmean(Igor_propLearned(:,find(Igor.drug_3days_ind)),2)-nanmean(Igor_propLearned(:,Igor_vehicleDays),2)];
Bard_propLearned = [nanmean(Bard_propLearned(:,find(Bard.drug_1days_ind)),2)-nanmean(Bard_propLearned(:,Bard_vehicleDays),2),...
    nanmean(Bard_propLearned(:,find(Bard.drug_2days_ind)),2)-nanmean(Bard_propLearned(:,Bard_vehicleDays),2),...
    nanmean(Bard_propLearned(:,find(Bard.drug_3days_ind)),2)-nanmean(Bard_propLearned(:,Bard_vehicleDays),2)];

Reider_avgLP = [cellfun(@(x) [nanmean(x(1:7))], Reider.allFLU_altLP_by_blockNum);...
    cellfun(@(x) [nanmean(x(8:14))], Reider.allFLU_altLP_by_blockNum);...
    cellfun(@(x) [nanmean(x(15:end))], Reider.allFLU_altLP_by_blockNum)];
Sindri_avgLP = [cellfun(@(x) [nanmean(x(1:7))], Sindri.allFLU_altLP_by_blockNum);...
    cellfun(@(x) [nanmean(x(8:14))], Sindri.allFLU_altLP_by_blockNum);...
    cellfun(@(x) [nanmean(x(15:end))], Sindri.allFLU_altLP_by_blockNum)];
Igor_avgLP = [cellfun(@(x) [nanmean(x(1:7))], Igor.allFLU_altLP_by_blockNum);...
    cellfun(@(x) [nanmean(x(8:14))], Igor.allFLU_altLP_by_blockNum);...
    cellfun(@(x) [nanmean(x(15:end))], Igor.allFLU_altLP_by_blockNum)];
Bard_avgLP = [cellfun(@(x) [nanmean(x(1:7))], Bard.allFLU_altLP_by_blockNum);...
    cellfun(@(x) [nanmean(x(8:14))], Bard.allFLU_altLP_by_blockNum);...
    cellfun(@(x) [nanmean(x(15:end))], Bard.allFLU_altLP_by_blockNum)];

Reider_avgLP = [nanmean(Reider_avgLP(:,find(Reider.drug_1days_ind)),2)-nanmean(Reider_avgLP(:,Reider_vehicleDays),2),...
    nanmean(Reider_avgLP(:,find(Reider.drug_2days_ind)),2)-nanmean(Reider_avgLP(:,Reider_vehicleDays),2),...
    nanmean(Reider_avgLP(:,find(Reider.drug_3days_ind)),2)-nanmean(Reider_avgLP(:,Reider_vehicleDays),2)];
Sindri_avgLP = [nanmean(Sindri_avgLP(:,find(Sindri.drug_1days_ind)),2)-nanmean(Sindri_avgLP(:,Sindri_vehicleDays),2),...
    nanmean(Sindri_avgLP(:,find(Sindri.drug_2days_ind)),2)-nanmean(Sindri_avgLP(:,Sindri_vehicleDays),2),...
    nanmean(Sindri_avgLP(:,find(Sindri.drug_3days_ind)),2)-nanmean(Sindri_avgLP(:,Sindri_vehicleDays),2)];
Igor_avgLP = [nanmean(Igor_avgLP(:,find(Igor.drug_1days_ind)),2)-nanmean(Igor_avgLP(:,Igor_vehicleDays),2),...
    nanmean(Igor_avgLP(:,find(Igor.drug_2days_ind)),2)-nanmean(Igor_avgLP(:,Igor_vehicleDays),2),...
    nanmean(Igor_avgLP(:,find(Igor.drug_3days_ind)),2)-nanmean(Igor_avgLP(:,Igor_vehicleDays),2)];
Bard_avgLP = [nanmean(Bard_avgLP(:,find(Bard.drug_1days_ind)),2)-nanmean(Bard_avgLP(:,Bard_vehicleDays),2),...
    nanmean(Bard_avgLP(:,find(Bard.drug_2days_ind)),2)-nanmean(Bard_avgLP(:,Bard_vehicleDays),2),...
    nanmean(Bard_avgLP(:,find(Bard.drug_3days_ind)),2)-nanmean(Bard_avgLP(:,Bard_vehicleDays),2)];

% altLP: 70% perf in 10 trials) w/ sliding window starting after first error
% note: as opposed to LP variables in data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% ONLY 'altLP' IS USED THROUGHOUT THIS SCRIPT %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Reider.allFLU_altLP_by_blockNum{26}= [Reider.allFLU_altLP_by_blockNum{26}(1:17) NaN Reider.allFLU_altLP_by_blockNum{26}(18:end)];% accounting for bad block
allFLU_altLP_by_blockNum = [Reider.allFLU_altLP_by_blockNum, Sindri.allFLU_altLP_by_blockNum, Igor.allFLU_altLP_by_blockNum, Bard.allFLU_altLP_by_blockNum];

%set LP exclusion criterion
for isess = 1:numel(allFLU_altLP_by_blockNum)
    allFLU_altLP_by_blockNum{isess}(find(allFLU_altLP_by_blockNum{isess}==1)) = NaN; %remove LP = 1
    allFLU_altLP_by_blockNum{isess}(find(allFLU_altLP_by_blockNum{isess}>40)) = NaN; %remove LP > 40
end

daily_altLP_thirdsRaw(1,:) = cellfun(@(x) [x(1:7)],allFLU_altLP_by_blockNum,'un',0);
daily_altLP_thirdsRaw(2,:) = cellfun(@(x) [x(8:14)],allFLU_altLP_by_blockNum,'un',0);
daily_altLP_thirdsRaw(3,:) = cellfun(@(x) [x(15:21)],allFLU_altLP_by_blockNum,'un',0);

daily_altLP_thirds = cellfun(@nanmedian,daily_altLP_thirdsRaw);

vehicle_daily_altLP_thirds = nanmean(daily_altLP_thirds(:,vehicle_days_ind),2);
drug1_daily_altLP_thirds = nanmean(daily_altLP_thirds(:,drug_1days_ind),2);
drug2_daily_altLP_thirds = nanmean(daily_altLP_thirds(:,drug_2days_ind),2);
drug3_daily_altLP_thirds = nanmean(daily_altLP_thirds(:,drug_3days_ind),2);

vehicle_daily_altLP_thirdsSEM = [SEM_AH(daily_altLP_thirds(1,vehicle_days_ind));SEM_AH(daily_altLP_thirds(2,vehicle_days_ind));SEM_AH(daily_altLP_thirds(3,vehicle_days_ind))];
drug1_daily_altLP_thirdsSEM = [SEM_AH(daily_altLP_thirds(1,drug_1days_ind));SEM_AH(daily_altLP_thirds(2,drug_1days_ind));SEM_AH(daily_altLP_thirds(3,drug_1days_ind))];
drug2_daily_altLP_thirdsSEM = [SEM_AH(daily_altLP_thirds(1,drug_2days_ind));SEM_AH(daily_altLP_thirds(2,drug_2days_ind));SEM_AH(daily_altLP_thirds(3,drug_2days_ind))];
drug3_daily_altLP_thirdsSEM = [SEM_AH(daily_altLP_thirds(1,drug_3days_ind));SEM_AH(daily_altLP_thirds(2,drug_3days_ind));SEM_AH(daily_altLP_thirds(3,drug_3days_ind))];

vehilce_blk_altLP_thirds = cell2mat(daily_altLP_thirdsRaw(:,vehicle_days_ind));
drug1_blk_altLP_thirds = cell2mat(daily_altLP_thirdsRaw(:,drug_1days_ind));
drug2_blk_altLP_thirds = cell2mat(daily_altLP_thirdsRaw(:,drug_2days_ind));
drug3_blk_altLP_thirds = cell2mat(daily_altLP_thirdsRaw(:,drug_3days_ind));

vehilce_blk_altLP_thirdsSEM = cellfun(@(x) [SEM_AH(x,'median')], num2cell(vehilce_blk_altLP_thirds,2));
drug1_blk_altLP_thirdsSEM = cellfun(@(x) [SEM_AH(x,'median')], num2cell(drug1_blk_altLP_thirds,2));
drug2_blk_altLP_thirdsSEM = cellfun(@(x) [SEM_AH(x,'median')], num2cell(drug2_blk_altLP_thirds,2));
drug3_blk_altLP_thirdsSEM = cellfun(@(x) [SEM_AH(x,'median')], num2cell(drug3_blk_altLP_thirds,2));

%blk dimensionality for first third
FL_altLP_lowDim =  cellfun(@(x,y) [x(find(y(1:7)==0))],allFLU_altLP_by_blockNum,allFLU_dim_by_block,'un',0);
FL_altLP_highDim = cellfun(@(x,y) [x(find(y(1:7)==1))],allFLU_altLP_by_blockNum,allFLU_dim_by_block,'un',0);

vehicle_daily_altLP_lowDim = cellfun (@nanmedian, FL_altLP_lowDim(vehicle_days_ind));
vehicle_daily_altLP_highDim = cellfun (@nanmedian, FL_altLP_highDim(vehicle_days_ind));
drug1_daily_altLP_lowDim = cellfun (@nanmedian, FL_altLP_lowDim(drug_1days_ind));
drug1_daily_altLP_highDim = cellfun (@nanmedian, FL_altLP_highDim(drug_1days_ind));
drug2_daily_altLP_lowDim = cellfun (@nanmedian, FL_altLP_lowDim(drug_2days_ind));
drug2_daily_altLP_highDim = cellfun (@nanmedian, FL_altLP_highDim(drug_2days_ind));
drug3_daily_altLP_lowDim = cellfun (@nanmedian, FL_altLP_lowDim(drug_3days_ind));
drug3_daily_altLP_highDim = cellfun (@nanmedian, FL_altLP_highDim(drug_3days_ind));

vehicle_blk_altLP_lowDim = cell2mat(FL_altLP_lowDim(vehicle_days_ind));
vehicle_blk_altLP_highDim = cell2mat(FL_altLP_highDim(vehicle_days_ind));
drug1_blk_altLP_lowDim = cell2mat(FL_altLP_lowDim(drug_1days_ind));
drug1_blk_altLP_highDim = cell2mat(FL_altLP_highDim(drug_1days_ind));
drug2_blk_altLP_lowDim = cell2mat(FL_altLP_lowDim(drug_2days_ind));
drug2_blk_altLP_highDim = cell2mat(FL_altLP_highDim(drug_2days_ind));
drug3_blk_altLP_lowDim = cell2mat(FL_altLP_lowDim(drug_3days_ind));
drug3_blk_altLP_highDim = cell2mat(FL_altLP_highDim(drug_3days_ind));

%blk thirds + dimensionality
FL_altLP_lowDim_thirds(1,:) = cellfun(@(x,y) [x(find(y(1:7)==0))],daily_altLP_thirdsRaw(1,:),allFLU_dim_by_block,'un',0);
FL_altLP_lowDim_thirds(2,:) = cellfun(@(x,y) [x(find(y(8:14)==0))],daily_altLP_thirdsRaw(2,:),allFLU_dim_by_block,'un',0);
FL_altLP_lowDim_thirds(3,:) = cellfun(@(x,y) [x(find(y(15:21)==0))],daily_altLP_thirdsRaw(3,:),allFLU_dim_by_block,'un',0);

FL_altLP_highDim_thirds(1,:) = cellfun(@(x,y) [x(find(y(1:7)==1))],daily_altLP_thirdsRaw(1,:),allFLU_dim_by_block,'un',0);
FL_altLP_highDim_thirds(2,:) = cellfun(@(x,y) [x(find(y(8:14)==1))],daily_altLP_thirdsRaw(2,:),allFLU_dim_by_block,'un',0);
FL_altLP_highDim_thirds(3,:) = cellfun(@(x,y) [x(find(y(15:21)==1))],daily_altLP_thirdsRaw(3,:),allFLU_dim_by_block,'un',0);

vehicle_FL_altLP_lowDim_thirds = cellfun (@nanmedian, FL_altLP_lowDim_thirds(:,vehicle_days_ind));
vehicle_FL_altLP_highDim_thirds = cellfun (@nanmedian, FL_altLP_highDim_thirds(:,vehicle_days_ind));
drug1_FL_altLP_lowDim_thirds = cellfun (@nanmedian, FL_altLP_lowDim_thirds(:,drug_1days_ind));
drug1_FL_altLP_highDim_thirds = cellfun (@nanmedian, FL_altLP_highDim_thirds(:,drug_1days_ind));
drug2_FL_altLP_lowDim_thirds = cellfun (@nanmedian, FL_altLP_lowDim_thirds(:,drug_2days_ind));
drug2_FL_altLP_highDim_thirds = cellfun (@nanmedian, FL_altLP_highDim_thirds(:,drug_2days_ind));
drug3_FL_altLP_lowDim_thirds = cellfun (@nanmedian, FL_altLP_lowDim_thirds(:,drug_3days_ind));
drug3_FL_altLP_highDim_thirds = cellfun (@nanmedian, FL_altLP_highDim_thirds(:,drug_3days_ind));

vehicle_FL_blk_altLP_lowDim_thirds = FL_altLP_lowDim_thirds(:,vehicle_days_ind);
vehicle_FL_blk_altLP_highDim_thirds = FL_altLP_highDim_thirds(:,vehicle_days_ind);
drug1_FL_blk_altLP_lowDim_thirds = FL_altLP_lowDim_thirds(:,drug_1days_ind);
drug1_FL_blk_altLP_highDim_thirds = FL_altLP_highDim_thirds(:,drug_1days_ind);
drug2_FL_blk_altLP_lowDim_thirds = FL_altLP_lowDim_thirds(:,drug_2days_ind);
drug2_FL_blk_altLP_highDim_thirds = FL_altLP_highDim_thirds(:,drug_2days_ind);
drug3_FL_blk_altLP_lowDim_thirds = FL_altLP_lowDim_thirds(:,drug_3days_ind);
drug3_FL_blk_altLP_highDim_thirds = FL_altLP_highDim_thirds(:,drug_3days_ind);

vehicle_FL_blk_altLP_lowDim_thirdsMed = cellfun(@(x) [nanmedian(cell2mat(x))], num2cell(vehicle_FL_blk_altLP_lowDim_thirds,2));
vehicle_FL_blk_altLP_highDim_thirdsMed = cellfun(@(x) [nanmedian(cell2mat(x))], num2cell(vehicle_FL_blk_altLP_highDim_thirds,2));
drug1_FL_blk_altLP_lowDim_thirdsMed = cellfun(@(x) [nanmedian(cell2mat(x))], num2cell(drug1_FL_blk_altLP_lowDim_thirds,2));
drug1_FL_blk_altLP_highDim_thirdsMed = cellfun(@(x) [nanmedian(cell2mat(x))], num2cell(drug1_FL_blk_altLP_highDim_thirds,2));
drug2_FL_blk_altLP_lowDim_thirdsMed = cellfun(@(x) [nanmedian(cell2mat(x))], num2cell(drug2_FL_blk_altLP_lowDim_thirds,2));
drug2_FL_blk_altLP_highDim_thirdsMed = cellfun(@(x) [nanmedian(cell2mat(x))], num2cell(drug2_FL_blk_altLP_highDim_thirds,2));
drug3_FL_blk_altLP_lowDim_thirdsMed = cellfun(@(x) [nanmedian(cell2mat(x))], num2cell(drug3_FL_blk_altLP_lowDim_thirds,2));
drug3_FL_blk_altLP_highDim_thirdsMed = cellfun(@(x) [nanmedian(cell2mat(x))], num2cell(drug3_FL_blk_altLP_highDim_thirds,2));

vehicle_FL_blk_altLP_lowDim_thirdsSEM = cellfun(@(x) [SEM_AH(cell2mat(x),'median')], num2cell(vehicle_FL_blk_altLP_lowDim_thirds,2));
vehicle_FL_blk_altLP_highDim_thirdsSEM = cellfun(@(x) [SEM_AH(cell2mat(x),'median')], num2cell(vehicle_FL_blk_altLP_highDim_thirds,2));
drug1_FL_blk_altLP_lowDim_thirdsSEM = cellfun(@(x) [SEM_AH(cell2mat(x),'median')], num2cell(drug1_FL_blk_altLP_lowDim_thirds,2));
drug1_FL_blk_altLP_highDim_thirdsSEM = cellfun(@(x) [SEM_AH(cell2mat(x),'median')], num2cell(drug1_FL_blk_altLP_highDim_thirds,2));
drug2_FL_blk_altLP_lowDim_thirdsSEM = cellfun(@(x) [SEM_AH(cell2mat(x),'median')], num2cell(drug2_FL_blk_altLP_lowDim_thirds,2));
drug2_FL_blk_altLP_highDim_thirdsSEM = cellfun(@(x) [SEM_AH(cell2mat(x),'median')], num2cell(drug2_FL_blk_altLP_highDim_thirds,2));
drug3_FL_blk_altLP_lowDim_thirdsSEM = cellfun(@(x) [SEM_AH(cell2mat(x),'median')], num2cell(drug3_FL_blk_altLP_lowDim_thirds,2));
drug3_FL_blk_altLP_highDim_thirdsSEM = cellfun(@(x) [SEM_AH(cell2mat(x),'median')], num2cell(drug3_FL_blk_altLP_highDim_thirds,2));

%LME
LME_altLP_data = cell2mat(allFLU_altLP_by_blockNum)';
LME_altLP_monkeyLabel = repmat(monkey_ind,21,1); LME_altLP_monkeyLabel = LME_altLP_monkeyLabel(:);
LME_altLP_condLabel = repmat(sess_cond_label,21,1); LME_altLP_condLabel = LME_altLP_condLabel(:);
LME_altLP_blkThirdLabel = [repmat(1,1,7),repmat(2,1,7),repmat(3,1,7)]; LME_altLP_blkThirdLabel = repmat(LME_altLP_blkThirdLabel,size(allFLU_altLP_by_blockNum))';
LME_altLP_loadLabel = cell2mat(allFLU_dim_by_block)';

LME_altLP_table = [table(LME_altLP_data) table(LME_altLP_monkeyLabel) table(LME_altLP_condLabel) table(LME_altLP_blkThirdLabel) table(LME_altLP_loadLabel)];
LME_altLP_table.LME_altLP_blkThirdLabel = categorical(LME_altLP_table.LME_altLP_blkThirdLabel);
LME_altLP_table.LME_altLP_loadLabel = categorical(LME_altLP_table.LME_altLP_loadLabel);

altLPblks_toExclude = find(cellfun(@isempty, LME_altLP_table.LME_altLP_condLabel));
LME_altLP_table(altLPblks_toExclude,:) = [];
altLP_blk_LME = fitlme (LME_altLP_table, 'LME_altLP_data ~ LME_altLP_condLabel*LME_altLP_loadLabel*LME_altLP_blkThirdLabel + (LME_altLP_condLabel|LME_altLP_monkeyLabel)'); 
[~, ~, altLP_blk_Reffects] = randomEffects (altLP_blk_LME);
%first third cohen's d 0.1mg/kg
computeCohen_d(cell2mat(daily_altLP_thirdsRaw(1,drug_2days_ind)),cell2mat(daily_altLP_thirdsRaw(1,vehicle_days_ind)),'independent');

% stats for altLP
%first third only stats by dim:
T1_altLP_stats_blkPool_lowDim_data = [cell2mat(vehicle_FL_blk_altLP_lowDim_thirds(1,:)),cell2mat(drug1_FL_blk_altLP_lowDim_thirds(1,:)),...
    cell2mat(drug2_FL_blk_altLP_lowDim_thirds(1,:)),cell2mat(drug3_FL_blk_altLP_lowDim_thirds(1,:))];
T1_altLP_stats_blkPool_highDim_data = [cell2mat(vehicle_FL_blk_altLP_highDim_thirds(1,:)),cell2mat(drug1_FL_blk_altLP_highDim_thirds(1,:)),...
    cell2mat(drug2_FL_blk_altLP_highDim_thirds(1,:)),cell2mat(drug3_FL_blk_altLP_highDim_thirds(1,:))];
T1_altLP_stats_blkPool_lowDim_condLabel = [repmat({'vehicle'},size(cell2mat(vehicle_FL_blk_altLP_lowDim_thirds(1,:)))),repmat({'lowDrug'},size(cell2mat(drug1_FL_blk_altLP_lowDim_thirds(1,:)))),...
    repmat({'medDrug'},size(cell2mat(drug2_FL_blk_altLP_lowDim_thirds(1,:)))),repmat({'highDrug'},size(cell2mat(drug3_FL_blk_altLP_lowDim_thirds(1,:))))];
T1_altLP_stats_blkPool_highDim_condLabel = [repmat({'vehicle'},size(cell2mat(vehicle_FL_blk_altLP_highDim_thirds(1,:)))),repmat({'lowDrug'},size(cell2mat(drug1_FL_blk_altLP_highDim_thirds(1,:)))),...
    repmat({'medDrug'},size(cell2mat(drug2_FL_blk_altLP_highDim_thirds(1,:)))),repmat({'highDrug'},size(cell2mat(drug3_FL_blk_altLP_highDim_thirds(1,:))))];

[altLP_anova_blkPool_lowDimT1_p,altLP_anova_blkPool_lowDimT1_table,altLP_anova_blkPool_lowDimT1_stats] =anova1(T1_altLP_stats_blkPool_lowDim_data,T1_altLP_stats_blkPool_lowDim_condLabel,'display','off');
%multcompare (altLP_anova_blkPool_lowDimT1_stats)
mes1way(T1_altLP_stats_blkPool_lowDim_data','eta2','group',(strcmp(T1_altLP_stats_blkPool_lowDim_condLabel,'highDrug')*3+strcmp(T1_altLP_stats_blkPool_lowDim_condLabel,'medDrug')*2+strcmp(T1_altLP_stats_blkPool_lowDim_condLabel,'lowDrug'))');
computeCohen_d(T1_altLP_stats_blkPool_lowDim_data(find(strcmp(T1_altLP_stats_blkPool_lowDim_condLabel,'medDrug'))),...
    T1_altLP_stats_blkPool_lowDim_data(find(strcmp(T1_altLP_stats_blkPool_lowDim_condLabel,'vehicle'))),'independent');

[altLP_anova_blkPool_highDimT1_p,altLP_anova_blkPool_highDimT1_table,altLP_anova_blkPool_highDimT1_stats] =anova1(T1_altLP_stats_blkPool_highDim_data,T1_altLP_stats_blkPool_highDim_condLabel,'display','off');
%multcompare (altLP_anova_blkPool_highDimT1_stats)
mes1way(T1_altLP_stats_blkPool_highDim_data','eta2','group',(strcmp(T1_altLP_stats_blkPool_highDim_condLabel,'highDrug')*3+strcmp(T1_altLP_stats_blkPool_highDim_condLabel,'medDrug')*2+strcmp(T1_altLP_stats_blkPool_highDim_condLabel,'lowDrug'))');
computeCohen_d(T1_altLP_stats_blkPool_highDim_data(find(strcmp(T1_altLP_stats_blkPool_highDim_condLabel,'medDrug'))),...
    T1_altLP_stats_blkPool_highDim_data(find(strcmp(T1_altLP_stats_blkPool_highDim_condLabel,'vehicle'))),'independent');

%plotting LP by both temporal thirds & dimension (median of blocks)
figure
subplot(1,2,1)
hold on
errorbar(0.9:1:2.9,cellfun(@nanmedian, num2cell(vehilce_blk_altLP_thirds,2)),vehilce_blk_altLP_thirdsSEM,'.-','color',drug_plot_colors(1,:),'MarkerSize',40,'Linewidth',2);
errorbar(1:3,cellfun(@nanmedian, num2cell(drug1_blk_altLP_thirds,2)),drug1_blk_altLP_thirdsSEM,'.-','color',drug_plot_colors(2,:),'MarkerSize',40,'Linewidth',2);
errorbar(1.1:1:3.1,cellfun(@nanmedian, num2cell(drug2_blk_altLP_thirds,2)),drug2_blk_altLP_thirdsSEM,'.-','color',drug_plot_colors(3,:),'MarkerSize',40,'Linewidth',2);
errorbar(1.2:1:3.2,cellfun(@nanmedian, num2cell(drug3_blk_altLP_thirds,2)),drug3_blk_altLP_thirdsSEM,'.-','color',drug_plot_colors(4,:),'MarkerSize',40,'Linewidth',2);
xticks(1:3); xticklabels({'first third', 'mid third', 'last third'});xlim([0.5 3.6]);
ylim([3 14]);ylabel('altLP');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 20;

subplot(1,2,2)
hold on
errorbar(0.9:1:1.9,[nanmean(vehicle_blk_altLP_lowDim),nanmean(vehicle_blk_altLP_highDim)],...
    [SEM_AH(vehicle_blk_altLP_lowDim,'median'),SEM_AH(vehicle_blk_altLP_highDim,'median')],'.-','color',drug_plot_colors(1,:),'MarkerSize',40,'Linewidth',2);
errorbar(1:2,[nanmean(drug1_blk_altLP_lowDim),nanmean(drug1_blk_altLP_highDim)],...
    [SEM_AH(drug1_blk_altLP_lowDim,'median'),SEM_AH(drug1_blk_altLP_highDim,'median')],'.-','color',drug_plot_colors(2,:),'MarkerSize',40,'Linewidth',2);
errorbar(1.1:1:2.1,[nanmean(drug2_blk_altLP_lowDim),nanmean(drug2_blk_altLP_highDim)],...
    [SEM_AH(drug2_blk_altLP_lowDim,'median'),SEM_AH(drug2_blk_altLP_highDim,'median')],'.-','color',drug_plot_colors(3,:),'MarkerSize',40,'Linewidth',2);
errorbar(1.2:1:2.2,[nanmean(drug3_blk_altLP_lowDim),nanmean(drug3_blk_altLP_highDim)],...
    [SEM_AH(drug3_blk_altLP_lowDim,'median'),SEM_AH(drug3_blk_altLP_highDim,'median')],'.-','color',drug_plot_colors(4,:),'MarkerSize',40,'Linewidth',2);
xticks(1:2); xticklabels({'low load', 'high load'});xlim([0.7 2.4]);
ylim([3 16]);ylabel('altLP');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 20;
set(gcf,'Position',[1 1 878 340]);

% % individual monkey temporal progress plot (VU595)
% 
% figure
% subplot(3,1,1)
% hold on
% title ('First third')
% scatter(Reider_propLearned(1,:),1:3,64,'r','filled');
% scatter(Sindri_propLearned(1,:),0.95:1:2.95,64,'g','filled');
% scatter(Igor_propLearned(1,:),0.9:1:2.9,64,'b','filled');
% scatter(Bard_propLearned(1,:),1.05:1:3.05,64,'c','filled');
% xlabel('prop. learned (diff.)');yticks(1:3);yticklabels({'0.3 mg/kg','1 mg/kg', '3 mg/kg'});
% xline(0);ylim([0.5 3.5]);
% legend({'monkey Re','monkey Si','monkey Ig','monkey Ba'},'location','nw')
% set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
% 
% subplot(3,1,2)
% hold on
% title ('Second third')
% scatter(Reider_propLearned(2,:),1:3,64,'r','filled');
% scatter(Sindri_propLearned(2,:),0.95:1:2.95,64,'g','filled');
% scatter(Igor_propLearned(2,:),0.9:1:2.9,64,'b','filled');
% scatter(Bard_propLearned(2,:),1.05:1:3.05,64,'c','filled');
% xlabel('prop. learned (diff.)');yticks(1:3);yticklabels({'0.3 mg/kg','1 mg/kg', '3 mg/kg'});
% xline(0);ylim([0.5 3.5]);
% set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
% 
% subplot(3,1,3)
% hold on
% title ('Last third')
% scatter(Reider_propLearned(3,:),1:3,64,'r','filled');
% scatter(Sindri_propLearned(3,:),0.95:1:2.95,64,'g','filled');
% scatter(Igor_propLearned(3,:),0.9:1:2.9,64,'b','filled');
% scatter(Bard_propLearned(3,:),1.05:1:3.05,64,'c','filled');
% xlabel('prop. learned (diff.)');yticks(1:3);yticklabels({'0.3 mg/kg','1 mg/kg', '3 mg/kg'});
% xline(0);ylim([0.5 3.5]);
% set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
% set(gcf,'Position',[1 1 887 764]);
% 
% % saveas(gcf,[figSave_dir 'monkeyTemporal_propLearned'],'epsc')
% 
% figure
% subplot(3,1,1)
% hold on
% title ('First third')
% scatter(Reider_avgLP(1,:),1:3,64,'r','filled');
% scatter(Sindri_avgLP(1,:),0.95:1:2.95,64,'g','filled');
% scatter(Igor_avgLP(1,:),0.9:1:2.9,64,'b','filled');
% scatter(Bard_avgLP(1,:),1.05:1:3.05,64,'c','filled');
% xlabel('LP (diff.)');yticks(1:3);yticklabels({'0.3 mg/kg','1 mg/kg', '3 mg/kg'});
% xline(0);ylim([0.5 3.5]);
% legend({'monkey Re','monkey Si','monkey Ig','monkey Ba'},'location','nw')
% set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
% 
% subplot(3,1,2)
% hold on
% title ('Second third')
% scatter(Reider_avgLP(2,:),1:3,64,'r','filled');
% scatter(Sindri_avgLP(2,:),0.95:1:2.95,64,'g','filled');
% scatter(Igor_avgLP(2,:),0.9:1:2.9,64,'b','filled');
% scatter(Bard_avgLP(2,:),1.05:1:3.05,64,'c','filled');
% xlabel('LP (diff.)');yticks(1:3);yticklabels({'0.3 mg/kg','1 mg/kg', '3 mg/kg'});
% xline(0);ylim([0.5 3.5]);
% set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
% 
% subplot(3,1,3)
% hold on
% title ('Last third')
% scatter(Reider_avgLP(3,:),1:3,64,'r','filled');
% scatter(Sindri_avgLP(3,:),0.95:1:2.95,64,'g','filled');
% scatter(Igor_avgLP(3,:),0.9:1:2.9,64,'b','filled');
% scatter(Bard_avgLP(3,:),1.05:1:3.05,64,'c','filled');
% xlabel('LP (diff.)');yticks(1:3);yticklabels({'0.3 mg/kg','1 mg/kg', '3 mg/kg'});
% xline(0);ylim([0.5 3.5]);
% set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
% set(gcf,'Position',[1 1 887 764]);
% 
% % saveas(gcf,[figSave_dir 'monkeyTemporal_LP'],'epsc')

close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Prop. blocks learned (altLP)%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

allFLU_LP_by_blockNum_Raw = [Reider.allFLU_LP_by_blockNum, Sindri.allFLU_LP_by_blockNum, Igor.allFLU_LP_by_blockNum, Bard.allFLU_LP_by_blockNum];
allFLU_altLP_by_blockNum_Raw = [Reider.allFLU_altLP_by_blockNum, Sindri.allFLU_altLP_by_blockNum, Igor.allFLU_altLP_by_blockNum, Bard.allFLU_altLP_by_blockNum];

% limit based on LME results on LP
temporal_limit_propLearned = 7;

FL_propLearned_lowDim = cellfun(@(x,y) [x(find(y(1:temporal_limit_propLearned)==0))],allFLU_altLP_by_blockNum_Raw,allFLU_dim_by_block,'un',0);
FL_propLearned_highDim = cellfun(@(x,y) [x(find(y(1:temporal_limit_propLearned)==1))],allFLU_altLP_by_blockNum_Raw,allFLU_dim_by_block,'un',0);

vehicle_FL_propLearned_lowDim_data = cell2mat(FL_propLearned_lowDim(vehicle_days_ind));
vehicle_FL_propLearned_highDim_data = cell2mat(FL_propLearned_highDim(vehicle_days_ind));
drug1_FL_propLearned_lowDim_data = cell2mat(FL_propLearned_lowDim(drug_1days_ind));
drug1_FL_propLearned_highDim_data = cell2mat(FL_propLearned_highDim(drug_1days_ind));
drug2_FL_propLearned_lowDim_data = cell2mat(FL_propLearned_lowDim(drug_2days_ind));
drug2_FL_propLearned_highDim_data = cell2mat(FL_propLearned_highDim(drug_2days_ind));
drug3_FL_propLearned_lowDim_data = cell2mat(FL_propLearned_lowDim(drug_3days_ind));
drug3_FL_propLearned_highDim_data = cell2mat(FL_propLearned_highDim(drug_3days_ind));

vehicle_FL_propLearned_lowDim = sum(~isnan(vehicle_FL_propLearned_lowDim_data)) / numel(vehicle_FL_propLearned_lowDim_data);
vehicle_FL_propLearned_highDim = sum(~isnan(vehicle_FL_propLearned_highDim_data)) / numel(vehicle_FL_propLearned_highDim_data);
drug1_FL_propLearned_lowDim = sum(~isnan(drug1_FL_propLearned_lowDim_data)) / numel(drug1_FL_propLearned_lowDim_data);
drug1_FL_propLearned_highDim = sum(~isnan(drug1_FL_propLearned_highDim_data)) / numel(drug1_FL_propLearned_highDim_data);
drug2_FL_propLearned_lowDim = sum(~isnan(drug2_FL_propLearned_lowDim_data)) / numel(drug2_FL_propLearned_lowDim_data);
drug2_FL_propLearned_highDim = sum(~isnan(drug2_FL_propLearned_highDim_data)) / numel(drug2_FL_propLearned_highDim_data);
drug3_FL_propLearned_lowDim = sum(~isnan(drug3_FL_propLearned_lowDim_data)) / numel(drug3_FL_propLearned_lowDim_data);
drug3_FL_propLearned_highDim = sum(~isnan(drug3_FL_propLearned_highDim_data)) / numel(drug3_FL_propLearned_highDim_data);

vehicle_FL_propLearned_lowDimSEM = SEM_AH(~isnan(vehicle_FL_propLearned_lowDim_data),'prop');
vehicle_FL_propLearned_highDimSEM = SEM_AH(~isnan(vehicle_FL_propLearned_highDim_data),'prop');
drug1_FL_propLearned_lowDimSEM = SEM_AH(~isnan(drug1_FL_propLearned_lowDim_data),'prop');
drug1_FL_propLearned_highDimSEM = SEM_AH(~isnan(drug1_FL_propLearned_highDim_data),'prop');
drug2_FL_propLearned_lowDimSEM = SEM_AH(~isnan(drug2_FL_propLearned_lowDim_data),'prop');
drug2_FL_propLearned_highDimSEM = SEM_AH(~isnan(drug2_FL_propLearned_highDim_data),'prop');
drug3_FL_propLearned_lowDimSEM = SEM_AH(~isnan(drug3_FL_propLearned_lowDim_data),'prop');
drug3_FL_propLearned_highDimSEM = SEM_AH(~isnan(drug3_FL_propLearned_highDim_data),'prop');

%keep in mind tukey's does every pair-wise. Tried chi-sqr test w/
%bonferonni correction and only the same vehicle comparison came out signif
tukeys_propTest_lowDim_statsData = [sum(~isnan(vehicle_FL_propLearned_lowDim_data)), numel(vehicle_FL_propLearned_lowDim_data);...
    sum(~isnan(drug1_FL_propLearned_lowDim_data)), numel(drug1_FL_propLearned_lowDim_data);...
    sum(~isnan(drug2_FL_propLearned_lowDim_data)), numel(drug2_FL_propLearned_lowDim_data);...
    sum(~isnan(drug3_FL_propLearned_lowDim_data)), numel(drug3_FL_propLearned_lowDim_data)];
tukeys_propTest_highDim_statsData = [sum(~isnan(vehicle_FL_propLearned_highDim_data)), numel(vehicle_FL_propLearned_highDim_data);...
    sum(~isnan(drug1_FL_propLearned_highDim_data)), numel(drug1_FL_propLearned_highDim_data);...
    sum(~isnan(drug2_FL_propLearned_highDim_data)), numel(drug2_FL_propLearned_highDim_data);...
    sum(~isnan(drug3_FL_propLearned_highDim_data)), numel(drug3_FL_propLearned_highDim_data)];
tmcomptest(tukeys_propTest_lowDim_statsData);%tukeys_mc_propTest_lowDim
tmcomptest(tukeys_propTest_highDim_statsData);%tukeys_mc_propTest_highDim 
%actual p value needs to refer to a chart for a comparable critical value...

%plot prop. blocks learned
figure
hold on
errorbar(0.9:1:1.9,[vehicle_FL_propLearned_lowDim vehicle_FL_propLearned_highDim],...
    [vehicle_FL_propLearned_lowDimSEM vehicle_FL_propLearned_highDimSEM],'.-','color',drug_plot_colors(1,:),'MarkerSize',40,'Linewidth',3);
errorbar(1:2,[drug1_FL_propLearned_lowDim drug1_FL_propLearned_highDim],...
    [drug1_FL_propLearned_lowDimSEM drug1_FL_propLearned_highDimSEM],'.-','color',drug_plot_colors(2,:),'MarkerSize',40,'Linewidth',3);
errorbar(1.1:1:2.1,[drug2_FL_propLearned_lowDim drug2_FL_propLearned_highDim],...
    [drug2_FL_propLearned_lowDimSEM drug2_FL_propLearned_highDimSEM],'.-','color',drug_plot_colors(3,:),'MarkerSize',40,'Linewidth',3);
errorbar(1.2:1:2.2,[drug3_FL_propLearned_lowDim drug3_FL_propLearned_highDim],...
    [drug3_FL_propLearned_lowDimSEM drug3_FL_propLearned_highDimSEM],'.-','color',drug_plot_colors(4,:),'MarkerSize',40,'Linewidth',3);
xticks(1:2);xticklabels({'low load','high load'});xlim([0.5 2.6]);
ylabel('prop. blocks learned');yticks(0.6:0.1:1);ylim([0.6 1]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 22;
set(gcf,'Position',[1 1 560 420]);

% saveas(gcf,[figSave_dir 'FL_prop_blksLearned'],'epsc')

close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Block shifts (altLP) %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tar_was_dist_dim_id = [Reider.tar_was_dist_dim_id, Sindri.tar_was_dist_dim_id, Igor.tar_was_dist_dim_id, Bard.tar_was_dist_dim_id];
tar_was_novel_dim_id = [Reider.tar_was_novel_dim_id, Sindri.tar_was_novel_dim_id, Igor.tar_was_novel_dim_id, Bard.tar_was_novel_dim_id];
tar_was_same_dim_id = [Reider.tar_was_same_dim_id, Sindri.tar_was_same_dim_id, Igor.tar_was_same_dim_id, Bard.tar_was_same_dim_id];

% limit based on LME results on LP
temporal_limit_shiftLP = 7; %set to maximum block number to be included (not coded for min)

tar_was_dist_dim_id = cellfun (@(x) [x(x<=temporal_limit_shiftLP)], tar_was_dist_dim_id,'un',0);
tar_was_novel_dim_id = cellfun (@(x) [x(x<=temporal_limit_shiftLP)], tar_was_novel_dim_id,'un',0);
tar_was_same_dim_id = cellfun (@(x) [x(x<=temporal_limit_shiftLP)], tar_was_same_dim_id,'un',0);

allFLU_altLP_by_blockNum_lowDim = allFLU_altLP_by_blockNum;
allFLU_altLP_by_blockNum_highDim = allFLU_altLP_by_blockNum;
for isess = 1:numel(allFLU_altLP_by_blockNum)
    allFLU_altLP_by_blockNum_lowDim{isess}(find(allFLU_dim_by_block{1} == 1)) = NaN;
    allFLU_altLP_by_blockNum_highDim{isess}(find(allFLU_dim_by_block{1} == 0)) = NaN;
end

% extract LPs
tar_was_dist_dim_LP = cellfun (@(x,y) [x(y)], allFLU_altLP_by_blockNum, tar_was_dist_dim_id,'un',0);
tar_was_novel_dim_LP = cellfun (@(x,y) [x(y)], allFLU_altLP_by_blockNum, tar_was_novel_dim_id,'un',0);
tar_was_same_dim_LP = cellfun (@(x,y) [x(y)], allFLU_altLP_by_blockNum, tar_was_same_dim_id,'un',0);

vehicle_tar_was_dist_LP = cell2mat(tar_was_dist_dim_LP(find(vehicle_days_ind)));
drug1_tar_was_dist_LP = cell2mat(tar_was_dist_dim_LP(find(drug_1days_ind)));
drug2_tar_was_dist_LP = cell2mat(tar_was_dist_dim_LP(find(drug_2days_ind)));
drug3_tar_was_dist_LP = cell2mat(tar_was_dist_dim_LP(find(drug_3days_ind)));
vehicle_tar_was_novel_LP = cell2mat(tar_was_novel_dim_LP(find(vehicle_days_ind)));
drug1_tar_was_novel_LP = cell2mat(tar_was_novel_dim_LP(find(drug_1days_ind)));
drug2_tar_was_novel_LP = cell2mat(tar_was_novel_dim_LP(find(drug_2days_ind)));
drug3_tar_was_novel_LP = cell2mat(tar_was_novel_dim_LP(find(drug_3days_ind)));
vehicle_tar_was_same_LP = cell2mat(tar_was_same_dim_LP(find(vehicle_days_ind)));
drug1_tar_was_same_LP = cell2mat(tar_was_same_dim_LP(find(drug_1days_ind)));
drug2_tar_was_same_LP = cell2mat(tar_was_same_dim_LP(find(drug_2days_ind)));
drug3_tar_was_same_LP = cell2mat(tar_was_same_dim_LP(find(drug_3days_ind)));

% individual monkey temporal progress (VU595)
ntmp = cumsum([numel(Reider.tar_was_dist_dim_id),numel(Sindri.tar_was_dist_dim_id),numel(Igor.tar_was_dist_dim_id),numel(Bard.tar_was_dist_dim_id)]);
Reider_ED = tar_was_dist_dim_LP(1:ntmp(1));
Reider_ED = [nanmean(cell2mat(Reider_ED(find(Reider.drug_1days_ind))))-nanmean(cell2mat(Reider_ED(Reider_vehicleDays))),...
    nanmean(cell2mat(Reider_ED(find(Reider.drug_2days_ind))))-nanmean(cell2mat(Reider_ED(Reider_vehicleDays))),...
    nanmean(cell2mat(Reider_ED(find(Reider.drug_3days_ind))))-nanmean(cell2mat(Reider_ED(Reider_vehicleDays)))];
Sindri_ED = tar_was_dist_dim_LP(ntmp(1)+1:ntmp(2));
Sindri_ED = [nanmean(cell2mat(Sindri_ED(find(Sindri.drug_1days_ind))))-nanmean(cell2mat(Sindri_ED(Sindri_vehicleDays))),...
    nanmean(cell2mat(Sindri_ED(find(Sindri.drug_2days_ind))))-nanmean(cell2mat(Sindri_ED(Sindri_vehicleDays))),...
    nanmean(cell2mat(Sindri_ED(find(Sindri.drug_3days_ind))))-nanmean(cell2mat(Sindri_ED(Sindri_vehicleDays)))];
Igor_ED = tar_was_dist_dim_LP(ntmp(2)+1:ntmp(3));
Igor_ED = [nanmean(cell2mat(Igor_ED(find(Igor.drug_1days_ind))))-nanmean(cell2mat(Igor_ED(Igor_vehicleDays))),...
    nanmean(cell2mat(Igor_ED(find(Igor.drug_2days_ind))))-nanmean(cell2mat(Igor_ED(Igor_vehicleDays))),...
    nanmean(cell2mat(Igor_ED(find(Igor.drug_3days_ind))))-nanmean(cell2mat(Igor_ED(Igor_vehicleDays)))];
Bard_ED = tar_was_dist_dim_LP(ntmp(3)+1:ntmp(4));
Bard_ED = [nanmean(cell2mat(Bard_ED(find(Bard.drug_1days_ind))))-nanmean(cell2mat(Bard_ED(Bard_vehicleDays))),...
    nanmean(cell2mat(Bard_ED(find(Bard.drug_2days_ind))))-nanmean(cell2mat(Bard_ED(Bard_vehicleDays))),...
    nanmean(cell2mat(Bard_ED(find(Bard.drug_3days_ind))))-nanmean(cell2mat(Bard_ED(Bard_vehicleDays)))];

Reider_ID = tar_was_same_dim_LP(1:ntmp(1));
Reider_ID = [nanmean(cell2mat(Reider_ID(find(Reider.drug_1days_ind))))-nanmean(cell2mat(Reider_ID(Reider_vehicleDays))),...
    nanmean(cell2mat(Reider_ID(find(Reider.drug_2days_ind))))-nanmean(cell2mat(Reider_ID(Reider_vehicleDays))),...
    nanmean(cell2mat(Reider_ID(find(Reider.drug_3days_ind))))-nanmean(cell2mat(Reider_ID(Reider_vehicleDays)))];
Sindri_ID = tar_was_same_dim_LP(ntmp(1)+1:ntmp(2));
Sindri_ID = [nanmean(cell2mat(Sindri_ID(find(Sindri.drug_1days_ind))))-nanmean(cell2mat(Sindri_ID(Sindri_vehicleDays))),...
    nanmean(cell2mat(Sindri_ID(find(Sindri.drug_2days_ind))))-nanmean(cell2mat(Sindri_ID(Sindri_vehicleDays))),...
    nanmean(cell2mat(Sindri_ID(find(Sindri.drug_3days_ind))))-nanmean(cell2mat(Sindri_ID(Sindri_vehicleDays)))];
Igor_ID = tar_was_same_dim_LP(ntmp(2)+1:ntmp(3));
Igor_ID = [nanmean(cell2mat(Igor_ID(find(Igor.drug_1days_ind))))-nanmean(cell2mat(Igor_ID(Igor_vehicleDays))),...
    nanmean(cell2mat(Igor_ID(find(Igor.drug_2days_ind))))-nanmean(cell2mat(Igor_ID(Igor_vehicleDays))),...
    nanmean(cell2mat(Igor_ID(find(Igor.drug_3days_ind))))-nanmean(cell2mat(Igor_ID(Igor_vehicleDays)))];
Bard_ID = tar_was_same_dim_LP(ntmp(3)+1:ntmp(4));
Bard_ID = [nanmean(cell2mat(Bard_ID(find(Bard.drug_1days_ind))))-nanmean(cell2mat(Bard_ID(Bard_vehicleDays))),...
    nanmean(cell2mat(Bard_ID(find(Bard.drug_2days_ind))))-nanmean(cell2mat(Bard_ID(Bard_vehicleDays))),...
    nanmean(cell2mat(Bard_ID(find(Bard.drug_3days_ind))))-nanmean(cell2mat(Bard_ID(Bard_vehicleDays)))];

% extract LPs by dim
tar_was_dist_dim_LP_lowDim = cellfun (@(x,y) [x(y)], allFLU_altLP_by_blockNum_lowDim, tar_was_dist_dim_id,'un',0);
tar_was_novel_dim_LP_lowDim = cellfun (@(x,y) [x(y)], allFLU_altLP_by_blockNum_lowDim, tar_was_novel_dim_id,'un',0);
tar_was_same_dim_LP_lowDim = cellfun (@(x,y) [x(y)], allFLU_altLP_by_blockNum_lowDim, tar_was_same_dim_id,'un',0);

vehicle_tar_was_dist_LP_lowDim = cell2mat(tar_was_dist_dim_LP_lowDim(find(vehicle_days_ind)));
drug1_tar_was_dist_LP_lowDim = cell2mat(tar_was_dist_dim_LP_lowDim(find(drug_1days_ind)));
drug2_tar_was_dist_LP_lowDim = cell2mat(tar_was_dist_dim_LP_lowDim(find(drug_2days_ind)));
drug3_tar_was_dist_LP_lowDim = cell2mat(tar_was_dist_dim_LP_lowDim(find(drug_3days_ind)));
vehicle_tar_was_novel_LP_lowDim = cell2mat(tar_was_novel_dim_LP_lowDim(find(vehicle_days_ind)));
drug1_tar_was_novel_LP_lowDim = cell2mat(tar_was_novel_dim_LP_lowDim(find(drug_1days_ind)));
drug2_tar_was_novel_LP_lowDim = cell2mat(tar_was_novel_dim_LP_lowDim(find(drug_2days_ind)));
drug3_tar_was_novel_LP_lowDim = cell2mat(tar_was_novel_dim_LP_lowDim(find(drug_3days_ind)));
vehicle_tar_was_same_LP_lowDim = cell2mat(tar_was_same_dim_LP_lowDim(find(vehicle_days_ind)));
drug1_tar_was_same_LP_lowDim = cell2mat(tar_was_same_dim_LP_lowDim(find(drug_1days_ind)));
drug2_tar_was_same_LP_lowDim = cell2mat(tar_was_same_dim_LP_lowDim(find(drug_2days_ind)));
drug3_tar_was_same_LP_lowDim = cell2mat(tar_was_same_dim_LP_lowDim(find(drug_3days_ind)));

tar_was_dist_dim_LP_highDim = cellfun (@(x,y) [x(y)], allFLU_altLP_by_blockNum_highDim, tar_was_dist_dim_id,'un',0);
tar_was_novel_dim_LP_highDim = cellfun (@(x,y) [x(y)], allFLU_altLP_by_blockNum_highDim, tar_was_novel_dim_id,'un',0);
tar_was_same_dim_LP_highDim = cellfun (@(x,y) [x(y)], allFLU_altLP_by_blockNum_highDim, tar_was_same_dim_id,'un',0);

vehicle_tar_was_dist_LP_highDim = cell2mat(tar_was_dist_dim_LP_highDim(find(vehicle_days_ind)));
drug1_tar_was_dist_LP_highDim = cell2mat(tar_was_dist_dim_LP_highDim(find(drug_1days_ind)));
drug2_tar_was_dist_LP_highDim = cell2mat(tar_was_dist_dim_LP_highDim(find(drug_2days_ind)));
drug3_tar_was_dist_LP_highDim = cell2mat(tar_was_dist_dim_LP_highDim(find(drug_3days_ind)));
vehicle_tar_was_novel_LP_highDim = cell2mat(tar_was_novel_dim_LP_highDim(find(vehicle_days_ind)));
drug1_tar_was_novel_LP_highDim = cell2mat(tar_was_novel_dim_LP_highDim(find(drug_1days_ind)));
drug2_tar_was_novel_LP_highDim = cell2mat(tar_was_novel_dim_LP_highDim(find(drug_2days_ind)));
drug3_tar_was_novel_LP_highDim = cell2mat(tar_was_novel_dim_LP_highDim(find(drug_3days_ind)));
vehicle_tar_was_same_LP_highDim = cell2mat(tar_was_same_dim_LP_highDim(find(vehicle_days_ind)));
drug1_tar_was_same_LP_highDim = cell2mat(tar_was_same_dim_LP_highDim(find(drug_1days_ind)));
drug2_tar_was_same_LP_highDim = cell2mat(tar_was_same_dim_LP_highDim(find(drug_2days_ind)));
drug3_tar_was_same_LP_highDim = cell2mat(tar_was_same_dim_LP_highDim(find(drug_3days_ind)));

%SEM for plotting
vehicle_tar_was_dist_LPSEM = SEM_AH(vehicle_tar_was_dist_LP);
drug1_tar_was_dist_LPSEM = SEM_AH(drug1_tar_was_dist_LP);
drug2_tar_was_dist_LPSEM = SEM_AH(drug2_tar_was_dist_LP);
drug3_tar_was_dist_LPSEM = SEM_AH(drug3_tar_was_dist_LP);
vehicle_tar_was_novel_LPSEM = SEM_AH(vehicle_tar_was_novel_LP);
drug1_tar_was_novel_LPSEM = SEM_AH(drug1_tar_was_novel_LP);
drug2_tar_was_novel_LPSEM = SEM_AH(drug2_tar_was_novel_LP);
drug3_tar_was_novel_LPSEM = SEM_AH(drug3_tar_was_novel_LP);
vehicle_tar_was_same_LPSEM = SEM_AH(vehicle_tar_was_same_LP);
drug1_tar_was_same_LPSEM = SEM_AH(drug1_tar_was_same_LP);
drug2_tar_was_same_LPSEM = SEM_AH(drug2_tar_was_same_LP);
drug3_tar_was_same_LPSEM = SEM_AH(drug3_tar_was_same_LP);

%stats: block-wise only, most sessions have very few if any blocks that match
%note: separating by dim with only first third of blocks is underpowered (all n.s.)
tar_was_dist_LP_stats_data = [vehicle_tar_was_dist_LP,drug1_tar_was_dist_LP,drug2_tar_was_dist_LP,drug3_tar_was_dist_LP];
tar_was_dist_LP_stats_label = [repmat({'vehicle'},size(vehicle_tar_was_dist_LP)),repmat({'drugLow'},size(drug1_tar_was_dist_LP)),...
    repmat({'drugMed'},size(drug2_tar_was_dist_LP)),repmat({'drugHigh'},size(drug3_tar_was_dist_LP))];
tar_was_novel_LP_stats_data = [vehicle_tar_was_novel_LP,drug1_tar_was_novel_LP,drug2_tar_was_novel_LP,drug3_tar_was_novel_LP];
tar_was_novel_LP_stats_label = [repmat({'vehicle'},size(vehicle_tar_was_novel_LP)),repmat({'drugLow'},size(drug1_tar_was_novel_LP)),...
    repmat({'drugMed'},size(drug2_tar_was_novel_LP)),repmat({'drugHigh'},size(drug3_tar_was_novel_LP))];
tar_was_same_LP_stats_data = [vehicle_tar_was_same_LP,drug1_tar_was_same_LP,drug2_tar_was_same_LP,drug3_tar_was_same_LP];
tar_was_same_LP_stats_label = [repmat({'vehicle'},size(vehicle_tar_was_same_LP)),repmat({'drugLow'},size(drug1_tar_was_same_LP)),...
    repmat({'drugMed'},size(drug2_tar_was_same_LP)),repmat({'drugHigh'},size(drug3_tar_was_same_LP))];

[tar_was_dist_LP_p,tar_was_dist_LP_table,tar_was_dist_LP_stats] = anova1(tar_was_dist_LP_stats_data,tar_was_dist_LP_stats_label,'display','off');
mes1way(tar_was_dist_LP_stats_data','eta2','group',(strcmp(tar_was_dist_LP_stats_label,'drugHigh')*3+strcmp(tar_was_dist_LP_stats_label,'drugMed')*2+strcmp(tar_was_dist_LP_stats_label,'drugLow'))');
computeCohen_d(tar_was_dist_LP_stats_data(find(strcmp(tar_was_dist_LP_stats_label,'drugMed'))),...
    tar_was_dist_LP_stats_data(find(strcmp(tar_was_dist_LP_stats_label,'vehicle'))),'independent');

[tar_was_novel_LP_p,tar_was_novel_LP_table,tar_was_novel_LP_stats] = anova1(tar_was_novel_LP_stats_data,tar_was_novel_LP_stats_label,'display','off');
mes1way(tar_was_novel_LP_stats_data','eta2','group',(strcmp(tar_was_novel_LP_stats_label,'drugHigh')*3+strcmp(tar_was_novel_LP_stats_label,'drugMed')*2+strcmp(tar_was_novel_LP_stats_label,'drugLow'))');
computeCohen_d(tar_was_novel_LP_stats_data(find(strcmp(tar_was_novel_LP_stats_label,'drugMed'))),...
    tar_was_novel_LP_stats_data(find(strcmp(tar_was_novel_LP_stats_label,'vehicle'))),'independent');

[tar_was_same_LP_p,tar_was_same_LP_table,tar_was_same_LP_stats] = anova1(tar_was_same_LP_stats_data,tar_was_same_LP_stats_label,'display','off');
mes1way(tar_was_same_LP_stats_data','eta2','group',(strcmp(tar_was_same_LP_stats_label,'drugHigh')*3+strcmp(tar_was_same_LP_stats_label,'drugMed')*2+strcmp(tar_was_same_LP_stats_label,'drugLow'))');
computeCohen_d(tar_was_same_LP_stats_data(find(strcmp(tar_was_same_LP_stats_label,'drugMed'))),...
    tar_was_same_LP_stats_data(find(strcmp(tar_was_same_LP_stats_label,'vehicle'))),'independent');

%plotting block transitions
figure
subplot(2,2,1)
hold on
tmpBar = bar([nanmean(vehicle_tar_was_dist_LP),nanmean(drug1_tar_was_dist_LP),nanmean(drug2_tar_was_dist_LP),nanmean(drug3_tar_was_dist_LP)],'FaceAlpha',0.6);
tmpBar.FaceColor = 'flat';tmpBar.CData = drug_plot_colors;
errorbar(1:4,[nanmean(vehicle_tar_was_dist_LP),nanmean(drug1_tar_was_dist_LP),nanmean(drug2_tar_was_dist_LP),nanmean(drug3_tar_was_dist_LP)],...
    [vehicle_tar_was_dist_LPSEM drug1_tar_was_dist_LPSEM drug2_tar_was_dist_LPSEM drug3_tar_was_dist_LPSEM],'color','k','linewidth',1,'linestyle','none');
xlim([0.5 4.5]);xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});
ylabel ('LP (trl)'); title ('Target was from last distractor dim');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(2,2,2)
hold on
tmpBar = bar([nanmean(vehicle_tar_was_novel_LP),nanmean(drug1_tar_was_novel_LP),nanmean(drug2_tar_was_novel_LP),nanmean(drug3_tar_was_novel_LP)],'FaceAlpha',0.6);
tmpBar.FaceColor = 'flat';tmpBar.CData = drug_plot_colors;
errorbar(1:4,[nanmean(vehicle_tar_was_novel_LP),nanmean(drug1_tar_was_novel_LP),nanmean(drug2_tar_was_novel_LP),nanmean(drug3_tar_was_novel_LP)],...
    [vehicle_tar_was_novel_LPSEM drug1_tar_was_novel_LPSEM drug2_tar_was_novel_LPSEM drug3_tar_was_novel_LPSEM],'color','k','linewidth',1,'linestyle','none');
xlim([0.5 4.5]);xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});
ylabel ('LP (trl)'); title ('Target was from novel dim (not in last blk)');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(2,2,3)
hold on
tmpBar = bar([nanmean(vehicle_tar_was_same_LP),nanmean(drug1_tar_was_same_LP),nanmean(drug2_tar_was_same_LP),nanmean(drug3_tar_was_same_LP)],'FaceAlpha',0.6);
tmpBar.FaceColor = 'flat';tmpBar.CData = drug_plot_colors;
errorbar(1:4,[nanmean(vehicle_tar_was_same_LP),nanmean(drug1_tar_was_same_LP),nanmean(drug2_tar_was_same_LP),nanmean(drug3_tar_was_same_LP)],...
    [vehicle_tar_was_same_LPSEM drug1_tar_was_same_LPSEM drug2_tar_was_same_LPSEM drug3_tar_was_same_LPSEM],'color','k','linewidth',1,'linestyle','none');
xlim([0.5 4.5]);xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});
ylabel ('LP (trl)'); title ('Target was from same dim as before');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
set(gcf,'Position',[1 1 1036 790]);

% saveas(gcf,[figSave_dir 'FL_blkTransitions_LP'],'epsc')

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Plateau perf. %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
allFLU_block_end_performance = [Reider.allFLU_block_end_performance', Sindri.allFLU_block_end_performance', Igor.allFLU_block_end_performance', Bard.allFLU_block_end_performance'];

% limit based on LME results on LP
temporal_limit_plateau = 7;

FL_plateauPerf_lowLoad =  cellfun(@(x,y) [x(find(y(1:temporal_limit_plateau)==0))],allFLU_block_end_performance,allFLU_dim_by_block,'un',0);
FL_plateauPerf_highLoad = cellfun(@(x,y) [x(find(y(1:temporal_limit_plateau)==1))],allFLU_block_end_performance,allFLU_dim_by_block,'un',0);

vehicle_FL_plateauPerf_lowLoad = cell2mat(FL_plateauPerf_lowLoad(vehicle_days_ind));
vehicle_FL_plateauPerf_highLoad = cell2mat(FL_plateauPerf_highLoad(vehicle_days_ind));
drug1_FL_plateauPerf_lowLoad = cell2mat(FL_plateauPerf_lowLoad(drug_1days_ind));
drug1_FL_plateauPerf_highLoad = cell2mat(FL_plateauPerf_highLoad(drug_1days_ind));
drug2_FL_plateauPerf_lowLoad = cell2mat(FL_plateauPerf_lowLoad(drug_2days_ind));
drug2_FL_plateauPerf_highLoad = cell2mat(FL_plateauPerf_highLoad(drug_2days_ind));
drug3_FL_plateauPerf_lowLoad = cell2mat(FL_plateauPerf_lowLoad(drug_3days_ind));
drug3_FL_plateauPerf_highLoad = cell2mat(FL_plateauPerf_highLoad(drug_3days_ind));

%stats
FL_plateau_stats_data = [vehicle_FL_plateauPerf_lowLoad,vehicle_FL_plateauPerf_highLoad,drug1_FL_plateauPerf_lowLoad,drug1_FL_plateauPerf_highLoad,...
    drug2_FL_plateauPerf_lowLoad,drug2_FL_plateauPerf_highLoad,drug3_FL_plateauPerf_lowLoad,drug3_FL_plateauPerf_highLoad];
FL_plateau_stats_labelCond = [repmat({'vehicle'},size([vehicle_FL_plateauPerf_lowLoad,vehicle_FL_plateauPerf_highLoad])),...
    repmat({'lowDrug'},size([drug1_FL_plateauPerf_lowLoad,drug1_FL_plateauPerf_highLoad])),...
    repmat({'medDrug'},size([drug2_FL_plateauPerf_lowLoad,drug2_FL_plateauPerf_highLoad])),...
    repmat({'highDrug'},size([drug3_FL_plateauPerf_lowLoad,drug3_FL_plateauPerf_highLoad]))];
FL_plateau_stats_labelLoad = [repmat({'lowLoad'},size(vehicle_FL_plateauPerf_lowLoad)),repmat({'highLoad'},size(vehicle_FL_plateauPerf_highLoad)),...
    repmat({'lowLoad'},size(drug1_FL_plateauPerf_lowLoad)),repmat({'highLoad'},size(drug1_FL_plateauPerf_highLoad)),...
    repmat({'lowLoad'},size(drug2_FL_plateauPerf_lowLoad)),repmat({'highLoad'},size(drug2_FL_plateauPerf_highLoad)),...
    repmat({'lowLoad'},size(drug3_FL_plateauPerf_lowLoad)),repmat({'highLoad'},size(drug3_FL_plateauPerf_highLoad))];
[FL_plateau_p,FL_plateau_table,FL_plateau_stats] = anovan(FL_plateau_stats_data,{FL_plateau_stats_labelLoad,FL_plateau_stats_labelCond},'model','interaction','varnames',{'load','cond'},'display','off');
% multcompare(FL_plateau_stats,'dimension',2)
%effect size
effectSizeGrouptmp = [strcmp(FL_plateau_stats_labelLoad,'highLoad')' (strcmp(FL_plateau_stats_labelCond,'highDrug')*3+strcmp(FL_plateau_stats_labelCond,'medDrug')*2+strcmp(FL_plateau_stats_labelCond,'lowDrug'))'];
mes2way(FL_plateau_stats_data',effectSizeGrouptmp,'eta2','fName',{'Load','Cond'});
computeCohen_d(FL_plateau_stats_data(intersect(find(strcmp(FL_plateau_stats_labelLoad,'lowLoad')), find(strcmp(FL_plateau_stats_labelCond,'medDrug')))),...
    FL_plateau_stats_data(intersect(find(strcmp(FL_plateau_stats_labelLoad,'lowLoad')), find(strcmp(FL_plateau_stats_labelCond,'vehicle')))),'independent');

%plotting plateau perf.
figure
hold on
errorbar (0.95:1:1.95,[nanmean(vehicle_FL_plateauPerf_lowLoad) nanmean(vehicle_FL_plateauPerf_highLoad)],...
    [SEM_AH(vehicle_FL_plateauPerf_lowLoad) SEM_AH(vehicle_FL_plateauPerf_highLoad)],'.-','color',drug_plot_colors(1,:),'MarkerSize',40,'Linewidth',3);
errorbar (1:2,[nanmean(drug1_FL_plateauPerf_lowLoad) nanmean(drug1_FL_plateauPerf_highLoad)],...
    [SEM_AH(drug1_FL_plateauPerf_lowLoad) SEM_AH(drug1_FL_plateauPerf_highLoad)],'.-','color',drug_plot_colors(2,:),'MarkerSize',40,'Linewidth',3);
errorbar (1.05:1:2.05,[nanmean(drug2_FL_plateauPerf_lowLoad) nanmean(drug2_FL_plateauPerf_highLoad)],...
    [SEM_AH(drug2_FL_plateauPerf_lowLoad) SEM_AH(drug2_FL_plateauPerf_highLoad)],'.-','color',drug_plot_colors(3,:),'MarkerSize',40,'Linewidth',3);
errorbar (1.1:1:2.1,[nanmean(drug3_FL_plateauPerf_lowLoad) nanmean(drug3_FL_plateauPerf_highLoad)],...
    [SEM_AH(drug3_FL_plateauPerf_lowLoad) SEM_AH(drug3_FL_plateauPerf_highLoad)],'.-','color',drug_plot_colors(4,:),'MarkerSize',40,'Linewidth',3);
xticks(1:2); xticklabels({'low distractor load', 'high distractor load'});xlim([0.7 2.4]);
ylabel('Plateau perf. (prop correct)');yticks (0.7:0.1:1); ylim([0.7 1]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 20;
set(gcf,'Position',[1 1 563 390]);

% saveas(gcf,[figSave_dir 'FL_plateauPerf'],'epsc')

% % individual monkey temporal progress plot (VU595)
% 
% figure
% subplot(2,1,1)
% hold on
% scatter(Reider_ED,1:3,64,'r','filled');
% scatter(Sindri_ED,0.95:1:2.95,64,'g','filled');
% scatter(Igor_ED,0.9:1:2.9,64,'b','filled');
% scatter(Bard_ED,1.05:1:3.05,64,'c','filled');
% xlabel('ED LP (diff.)');yticks(1:3);yticklabels({'0.3 mg/kg','1 mg/kg', '3 mg/kg'});
% xline(0);ylim([0.5 3.5]);
% set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
% 
% subplot(2,1,2)
% hold on
% scatter(Reider_ID,1:3,64,'r','filled');
% scatter(Sindri_ID,0.95:1:2.95,64,'g','filled');
% scatter(Igor_ID,0.9:1:2.9,64,'b','filled');
% scatter(Bard_ID,1.05:1:3.05,64,'c','filled');
% xlabel('ED LP (diff.)');yticks(1:3);yticklabels({'0.3 mg/kg','1 mg/kg', '3 mg/kg'});
% xline(0);ylim([0.5 3.5]);
% set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
% set(gcf,'Position',[1 1 709 483]);
% 
% % saveas(gcf,[figSave_dir 'monkeyTemporal_ED_ID'],'epsc')

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% FL persv. errors %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% limit based on LME results on LP
persvError_temporal_limit = 7; %restrict blocks used to 1:n

Reider.allFLUblks_featurePersv{26}.prop = [Reider.allFLUblks_featurePersv{26}.prop(1:17) NaN Reider.allFLUblks_featurePersv{26}.prop(18:end)]; % taking into account bad block
Reider.allFLUblks_featurePersv{26}.distProp = [Reider.allFLUblks_featurePersv{26}.distProp(1:17) NaN Reider.allFLUblks_featurePersv{26}.distProp(18:end)]; % taking into account bad block
Reider.allFLUblks_featurePersv{26}.tarProp = [Reider.allFLUblks_featurePersv{26}.tarProp(1:17) NaN Reider.allFLUblks_featurePersv{26}.tarProp(18:end)]; % taking into account bad block
Reider.allFLUblks_featurePersv{26}.distLength = [Reider.allFLUblks_featurePersv{26}.distLength(1:17) NaN Reider.allFLUblks_featurePersv{26}.distLength(18:end)]; % taking into account bad block
Reider.allFLUblks_featurePersv{26}.tarLength = [Reider.allFLUblks_featurePersv{26}.tarLength(1:17) NaN Reider.allFLUblks_featurePersv{26}.tarLength(18:end)]; % taking into account bad block

FL_prop_persvErrors = [cellfun(@(x) [x.prop(1:persvError_temporal_limit)], Reider.allFLUblks_featurePersv, 'un',0),cellfun(@(x) [x.prop(1:persvError_temporal_limit)], Sindri.allFLUblks_featurePersv, 'un',0),...
    cellfun(@(x) [x.prop(1:persvError_temporal_limit)], Igor.allFLUblks_featurePersv, 'un',0),cellfun(@(x) [x.prop(1:persvError_temporal_limit)], Bard.allFLUblks_featurePersv, 'un',0)];
FL_prop_distDim_persvErrors = [cellfun(@(x) [x.distProp(1:persvError_temporal_limit)], Reider.allFLUblks_featurePersv, 'un',0),cellfun(@(x) [x.distProp(1:persvError_temporal_limit)], Sindri.allFLUblks_featurePersv, 'un',0),...
    cellfun(@(x) [x.distProp(1:persvError_temporal_limit)], Igor.allFLUblks_featurePersv, 'un',0),cellfun(@(x) [x.distProp(1:persvError_temporal_limit)], Bard.allFLUblks_featurePersv, 'un',0)];
FL_prop_tarDim_persvErrors = [cellfun(@(x) [x.tarProp(1:persvError_temporal_limit)], Reider.allFLUblks_featurePersv, 'un',0),cellfun(@(x) [x.tarProp(1:persvError_temporal_limit)], Sindri.allFLUblks_featurePersv, 'un',0),...
    cellfun(@(x) [x.tarProp(1:persvError_temporal_limit)], Igor.allFLUblks_featurePersv, 'un',0),cellfun(@(x) [x.tarProp(1:persvError_temporal_limit)], Bard.allFLUblks_featurePersv, 'un',0)];
FL_length_distDim_persvErrors = [cellfun(@(x) [x.distLength(1:persvError_temporal_limit)], Reider.allFLUblks_featurePersv, 'un',0),cellfun(@(x) [x.distLength(1:persvError_temporal_limit)], Sindri.allFLUblks_featurePersv, 'un',0),...
    cellfun(@(x) [x.distLength(1:persvError_temporal_limit)], Igor.allFLUblks_featurePersv, 'un',0),cellfun(@(x) [x.distLength(1:persvError_temporal_limit)], Bard.allFLUblks_featurePersv, 'un',0)];
FL_length_tarDim_persvErrors = [cellfun(@(x) [x.tarLength(1:persvError_temporal_limit)], Reider.allFLUblks_featurePersv, 'un',0),cellfun(@(x) [x.tarLength(1:persvError_temporal_limit)], Sindri.allFLUblks_featurePersv, 'un',0),...
    cellfun(@(x) [x.tarLength(1:persvError_temporal_limit)], Igor.allFLUblks_featurePersv, 'un',0),cellfun(@(x) [x.tarLength(1:persvError_temporal_limit)], Bard.allFLUblks_featurePersv, 'un',0)];

FL_prop_persvErrors_lowDim = cellfun(@(x,y) [x(find(y(1:persvError_temporal_limit) == 0))], FL_prop_persvErrors,allFLU_dim_by_block,'un',0);
FL_prop_distDim_persvErrors_lowDim = cellfun(@(x,y) [x(find(y(1:persvError_temporal_limit) == 0))], FL_prop_distDim_persvErrors,allFLU_dim_by_block,'un',0);
FL_prop_tarDim_persvErrors_lowDim = cellfun(@(x,y) [x(find(y(1:persvError_temporal_limit) == 0))], FL_prop_tarDim_persvErrors,allFLU_dim_by_block,'un',0);
FL_length_distDim_persvErrors_lowDim = cellfun(@(x,y) [x(find(y(1:persvError_temporal_limit) == 0))], FL_length_distDim_persvErrors,allFLU_dim_by_block,'un',0);
FL_length_tarDim_persvErrors_lowDim = cellfun(@(x,y) [x(find(y(1:persvError_temporal_limit) == 0))], FL_length_tarDim_persvErrors,allFLU_dim_by_block,'un',0);
FL_prop_persvErrors_highDim = cellfun(@(x,y) [x(find(y(1:persvError_temporal_limit) == 1))], FL_prop_persvErrors,allFLU_dim_by_block,'un',0);
FL_prop_distDim_persvErrors_highDim = cellfun(@(x,y) [x(find(y(1:persvError_temporal_limit) == 1))], FL_prop_distDim_persvErrors,allFLU_dim_by_block,'un',0);
FL_prop_tarDim_persvErrors_highDim = cellfun(@(x,y) [x(find(y(1:persvError_temporal_limit) == 1))], FL_prop_tarDim_persvErrors,allFLU_dim_by_block,'un',0);
FL_length_distDim_persvErrors_highDim = cellfun(@(x,y) [x(find(y(1:persvError_temporal_limit) == 1))], FL_length_distDim_persvErrors,allFLU_dim_by_block,'un',0);
FL_length_tarDim_persvErrors_highDim = cellfun(@(x,y) [x(find(y(1:persvError_temporal_limit) == 1))], FL_length_tarDim_persvErrors,allFLU_dim_by_block,'un',0);

% individual monkey temporal progress (VU595)
ReiderPersv = cellfun(@(x) [x.prop(1:7)], Reider.allFLUblks_featurePersv, 'un',0);
ReiderPersv = [nanmean(cell2mat(ReiderPersv(find(Reider.drug_1days_ind))))-nanmean(cell2mat(ReiderPersv(Reider_vehicleDays))),...
    nanmean(cell2mat(ReiderPersv(find(Reider.drug_2days_ind))))-nanmean(cell2mat(ReiderPersv(Reider_vehicleDays))),...
    nanmean(cell2mat(ReiderPersv(find(Reider.drug_3days_ind))))-nanmean(cell2mat(ReiderPersv(Reider_vehicleDays)))];
SindriPersv = cellfun(@(x) [x.prop(1:7)], Sindri.allFLUblks_featurePersv, 'un',0);
SindriPersv = [nanmean(cell2mat(SindriPersv(find(Sindri.drug_1days_ind))))-nanmean(cell2mat(SindriPersv(Sindri_vehicleDays))),...
    nanmean(cell2mat(SindriPersv(find(Sindri.drug_2days_ind))))-nanmean(cell2mat(SindriPersv(Sindri_vehicleDays))),...
    nanmean(cell2mat(SindriPersv(find(Sindri.drug_3days_ind))))-nanmean(cell2mat(SindriPersv(Sindri_vehicleDays)))];
IgorPersv = cellfun(@(x) [x.prop(1:7)], Igor.allFLUblks_featurePersv, 'un',0);
IgorPersv = [nanmean(cell2mat(IgorPersv(find(Igor.drug_1days_ind))))-nanmean(cell2mat(IgorPersv(Igor_vehicleDays))),...
    nanmean(cell2mat(IgorPersv(find(Igor.drug_2days_ind))))-nanmean(cell2mat(IgorPersv(Igor_vehicleDays))),...
    nanmean(cell2mat(IgorPersv(find(Igor.drug_3days_ind))))-nanmean(cell2mat(IgorPersv(Igor_vehicleDays)))];
BardPersv = cellfun(@(x) [x.prop(1:7)], Bard.allFLUblks_featurePersv, 'un',0);
BardPersv = [nanmean(cell2mat(BardPersv(find(Bard.drug_1days_ind))))-nanmean(cell2mat(BardPersv(Bard_vehicleDays))),...
    nanmean(cell2mat(BardPersv(find(Bard.drug_2days_ind))))-nanmean(cell2mat(BardPersv(Bard_vehicleDays))),...
    nanmean(cell2mat(BardPersv(find(Bard.drug_3days_ind))))-nanmean(cell2mat(BardPersv(Bard_vehicleDays)))];

ReiderPersv_tarProp = cellfun(@(x) [x.tarProp(1:7)], Reider.allFLUblks_featurePersv, 'un',0);
ReiderPersv_tarProp = [nanmean(cell2mat(ReiderPersv_tarProp(find(Reider.drug_1days_ind))))-nanmean(cell2mat(ReiderPersv_tarProp(Reider_vehicleDays))),...
    nanmean(cell2mat(ReiderPersv_tarProp(find(Reider.drug_2days_ind))))-nanmean(cell2mat(ReiderPersv_tarProp(Reider_vehicleDays))),...
    nanmean(cell2mat(ReiderPersv_tarProp(find(Reider.drug_3days_ind))))-nanmean(cell2mat(ReiderPersv_tarProp(Reider_vehicleDays)))];
SindriPersv_tarProp = cellfun(@(x) [x.tarProp(1:7)], Sindri.allFLUblks_featurePersv, 'un',0);
SindriPersv_tarProp = [nanmean(cell2mat(SindriPersv_tarProp(find(Sindri.drug_1days_ind))))-nanmean(cell2mat(SindriPersv_tarProp(Sindri_vehicleDays))),...
    nanmean(cell2mat(SindriPersv_tarProp(find(Sindri.drug_2days_ind))))-nanmean(cell2mat(SindriPersv_tarProp(Sindri_vehicleDays))),...
    nanmean(cell2mat(SindriPersv_tarProp(find(Sindri.drug_3days_ind))))-nanmean(cell2mat(SindriPersv_tarProp(Sindri_vehicleDays)))];
IgorPersv_tarProp = cellfun(@(x) [x.tarProp(1:7)], Igor.allFLUblks_featurePersv, 'un',0);
IgorPersv_tarProp = [nanmean(cell2mat(IgorPersv_tarProp(find(Igor.drug_1days_ind))))-nanmean(cell2mat(IgorPersv_tarProp(Igor_vehicleDays))),...
    nanmean(cell2mat(IgorPersv_tarProp(find(Igor.drug_2days_ind))))-nanmean(cell2mat(IgorPersv_tarProp(Igor_vehicleDays))),...
    nanmean(cell2mat(IgorPersv_tarProp(find(Igor.drug_3days_ind))))-nanmean(cell2mat(IgorPersv_tarProp(Igor_vehicleDays)))];
BardPersv_tarProp = cellfun(@(x) [x.tarProp(1:7)], Bard.allFLUblks_featurePersv, 'un',0);
BardPersv_tarProp = [nanmean(cell2mat(BardPersv_tarProp(find(Bard.drug_1days_ind))))-nanmean(cell2mat(BardPersv_tarProp(Bard_vehicleDays))),...
    nanmean(cell2mat(BardPersv_tarProp(find(Bard.drug_2days_ind))))-nanmean(cell2mat(BardPersv_tarProp(Bard_vehicleDays))),...
    nanmean(cell2mat(BardPersv_tarProp(find(Bard.drug_3days_ind))))-nanmean(cell2mat(BardPersv_tarProp(Bard_vehicleDays)))];

% separating conditions

vehicle_FL_prop_persvErrors = cell2mat(FL_prop_persvErrors(vehicle_days_ind));
drug1_FL_prop_persvErrors = cell2mat(FL_prop_persvErrors(drug_1days_ind));
drug2_FL_prop_persvErrors = cell2mat(FL_prop_persvErrors(drug_2days_ind));
drug3_FL_prop_persvErrors = cell2mat(FL_prop_persvErrors(drug_3days_ind));
vehicle_FL_prop_persvErrors_lowDim = cell2mat(FL_prop_persvErrors_lowDim(vehicle_days_ind));
drug1_FL_prop_persvErrors_lowDim = cell2mat(FL_prop_persvErrors_lowDim(drug_1days_ind));
drug2_FL_prop_persvErrors_lowDim = cell2mat(FL_prop_persvErrors_lowDim(drug_2days_ind));
drug3_FL_prop_persvErrors_lowDim = cell2mat(FL_prop_persvErrors_lowDim(drug_3days_ind));
vehicle_FL_prop_persvErrors_highDim = cell2mat(FL_prop_persvErrors_highDim(vehicle_days_ind));
drug1_FL_prop_persvErrors_highDim = cell2mat(FL_prop_persvErrors_highDim(drug_1days_ind));
drug2_FL_prop_persvErrors_highDim = cell2mat(FL_prop_persvErrors_highDim(drug_2days_ind));
drug3_FL_prop_persvErrors_highDim = cell2mat(FL_prop_persvErrors_highDim(drug_3days_ind));

vehicle_FL_prop_distDim_persvErrors = cell2mat(FL_prop_distDim_persvErrors(vehicle_days_ind));
drug1_FL_prop_distDim_persvErrors = cell2mat(FL_prop_distDim_persvErrors(drug_1days_ind));
drug2_FL_prop_distDim_persvErrors = cell2mat(FL_prop_distDim_persvErrors(drug_2days_ind));
drug3_FL_prop_distDim_persvErrors = cell2mat(FL_prop_distDim_persvErrors(drug_3days_ind));
vehicle_FL_prop_distDim_persvErrors_lowDim = cell2mat(FL_prop_distDim_persvErrors_lowDim(vehicle_days_ind));
drug1_FL_prop_distDim_persvErrors_lowDim = cell2mat(FL_prop_distDim_persvErrors_lowDim(drug_1days_ind));
drug2_FL_prop_distDim_persvErrors_lowDim = cell2mat(FL_prop_distDim_persvErrors_lowDim(drug_2days_ind));
drug3_FL_prop_distDim_persvErrors_lowDim = cell2mat(FL_prop_distDim_persvErrors_lowDim(drug_3days_ind));
vehicle_FL_prop_distDim_persvErrors_highDim = cell2mat(FL_prop_distDim_persvErrors_highDim(vehicle_days_ind));
drug1_FL_prop_distDim_persvErrors_highDim = cell2mat(FL_prop_distDim_persvErrors_highDim(drug_1days_ind));
drug2_FL_prop_distDim_persvErrors_highDim = cell2mat(FL_prop_distDim_persvErrors_highDim(drug_2days_ind));
drug3_FL_prop_distDim_persvErrors_highDim = cell2mat(FL_prop_distDim_persvErrors_highDim(drug_3days_ind));

vehicle_FL_prop_tarDim_persvErrors = cell2mat(FL_prop_tarDim_persvErrors(vehicle_days_ind));
drug1_FL_prop_tarDim_persvErrors = cell2mat(FL_prop_tarDim_persvErrors(drug_1days_ind));
drug2_FL_prop_tarDim_persvErrors = cell2mat(FL_prop_tarDim_persvErrors(drug_2days_ind));
drug3_FL_prop_tarDim_persvErrors = cell2mat(FL_prop_tarDim_persvErrors(drug_3days_ind));
vehicle_FL_prop_tarDim_persvErrors_lowDim = cell2mat(FL_prop_tarDim_persvErrors_lowDim(vehicle_days_ind));
drug1_FL_prop_tarDim_persvErrors_lowDim = cell2mat(FL_prop_tarDim_persvErrors_lowDim(drug_1days_ind));
drug2_FL_prop_tarDim_persvErrors_lowDim = cell2mat(FL_prop_tarDim_persvErrors_lowDim(drug_2days_ind));
drug3_FL_prop_tarDim_persvErrors_lowDim = cell2mat(FL_prop_tarDim_persvErrors_lowDim(drug_3days_ind));
vehicle_FL_prop_tarDim_persvErrors_highDim = cell2mat(FL_prop_tarDim_persvErrors_highDim(vehicle_days_ind));
drug1_FL_prop_tarDim_persvErrors_highDim = cell2mat(FL_prop_tarDim_persvErrors_highDim(drug_1days_ind));
drug2_FL_prop_tarDim_persvErrors_highDim = cell2mat(FL_prop_tarDim_persvErrors_highDim(drug_2days_ind));
drug3_FL_prop_tarDim_persvErrors_highDim = cell2mat(FL_prop_tarDim_persvErrors_highDim(drug_3days_ind));

vehicle_FL_length_distDim_persvErrors = cell2mat([FL_length_distDim_persvErrors{vehicle_days_ind}]);
drug1_FL_length_distDim_persvErrors = cell2mat([FL_length_distDim_persvErrors{drug_1days_ind}]);
drug2_FL_length_distDim_persvErrors = cell2mat([FL_length_distDim_persvErrors{drug_2days_ind}]);
drug3_FL_length_distDim_persvErrors = cell2mat([FL_length_distDim_persvErrors{drug_3days_ind}]);
vehicle_FL_length_distDim_persvErrors_lowDim = cell2mat([FL_length_distDim_persvErrors_lowDim{vehicle_days_ind}]);
drug1_FL_length_distDim_persvErrors_lowDim = cell2mat([FL_length_distDim_persvErrors_lowDim{drug_1days_ind}]);
drug2_FL_length_distDim_persvErrors_lowDim = cell2mat([FL_length_distDim_persvErrors_lowDim{drug_2days_ind}]);
drug3_FL_length_distDim_persvErrors_lowDim = cell2mat([FL_length_distDim_persvErrors_lowDim{drug_3days_ind}]);
vehicle_FL_length_distDim_persvErrors_highDim = cell2mat([FL_length_distDim_persvErrors_highDim{vehicle_days_ind}]);
drug1_FL_length_distDim_persvErrors_highDim = cell2mat([FL_length_distDim_persvErrors_highDim{drug_1days_ind}]);
drug2_FL_length_distDim_persvErrors_highDim = cell2mat([FL_length_distDim_persvErrors_highDim{drug_2days_ind}]);
drug3_FL_length_distDim_persvErrors_highDim = cell2mat([FL_length_distDim_persvErrors_highDim{drug_3days_ind}]);

vehicle_FL_length_tarDim_persvErrors = cell2mat([FL_length_tarDim_persvErrors{vehicle_days_ind}]);
drug1_FL_length_tarDim_persvErrors = cell2mat([FL_length_tarDim_persvErrors{drug_1days_ind}]);
drug2_FL_length_tarDim_persvErrors = cell2mat([FL_length_tarDim_persvErrors{drug_2days_ind}]);
drug3_FL_length_tarDim_persvErrors = cell2mat([FL_length_tarDim_persvErrors{drug_3days_ind}]);
vehicle_FL_length_tarDim_persvErrors_lowDim = cell2mat([FL_length_tarDim_persvErrors_lowDim{vehicle_days_ind}]);
drug1_FL_length_tarDim_persvErrors_lowDim = cell2mat([FL_length_tarDim_persvErrors_lowDim{drug_1days_ind}]);
drug2_FL_length_tarDim_persvErrors_lowDim = cell2mat([FL_length_tarDim_persvErrors_lowDim{drug_2days_ind}]);
drug3_FL_length_tarDim_persvErrors_lowDim = cell2mat([FL_length_tarDim_persvErrors_lowDim{drug_3days_ind}]);
vehicle_FL_length_tarDim_persvErrors_highDim = cell2mat([FL_length_tarDim_persvErrors_highDim{vehicle_days_ind}]);
drug1_FL_length_tarDim_persvErrors_highDim = cell2mat([FL_length_tarDim_persvErrors_highDim{drug_1days_ind}]);
drug2_FL_length_tarDim_persvErrors_highDim = cell2mat([FL_length_tarDim_persvErrors_highDim{drug_2days_ind}]);
drug3_FL_length_tarDim_persvErrors_highDim = cell2mat([FL_length_tarDim_persvErrors_highDim{drug_3days_ind}]);

%stats
FL_prop_persvErrors_stast_condLabel = [repmat({'vehicle'},size(vehicle_FL_prop_persvErrors)),repmat({'lowDrug'},size(drug1_FL_prop_persvErrors)),...
    repmat({'medDrug'},size(drug2_FL_prop_persvErrors)),repmat({'highDrug'},size(drug3_FL_prop_persvErrors))];
FL_prop_persvErrors_stast_data = [vehicle_FL_prop_persvErrors, drug1_FL_prop_persvErrors, drug2_FL_prop_persvErrors, drug3_FL_prop_persvErrors];
FL_prop_distDim_persvErrors_stast_data = [vehicle_FL_prop_distDim_persvErrors, drug1_FL_prop_distDim_persvErrors, drug2_FL_prop_distDim_persvErrors, drug3_FL_prop_distDim_persvErrors];
FL_prop_tarDim_persvErrors_stast_data = [vehicle_FL_prop_tarDim_persvErrors, drug1_FL_prop_tarDim_persvErrors, drug2_FL_prop_tarDim_persvErrors, drug3_FL_prop_tarDim_persvErrors];

[FL_prop_persvErrors_stast_p FL_prop_persvErrors_stast_table FL_prop_persvErrors_stast_stats] = anova1(FL_prop_persvErrors_stast_data, FL_prop_persvErrors_stast_condLabel,'display','off');
mes1way(FL_prop_persvErrors_stast_data','eta2','group',(strcmp(FL_prop_persvErrors_stast_condLabel,'highDrug')*3+strcmp(FL_prop_persvErrors_stast_condLabel,'medDrug')*2+strcmp(FL_prop_persvErrors_stast_condLabel,'lowDrug'))');
computeCohen_d(FL_prop_persvErrors_stast_data(find(strcmp(FL_prop_persvErrors_stast_condLabel,'medDrug'))),...
    FL_prop_persvErrors_stast_data(find(strcmp(FL_prop_persvErrors_stast_condLabel,'vehicle'))),'independent');

[FL_prop_distDim_persvErrors_stast_p FL_prop_distDim_persvErrors_stast_table FL_prop_distDim_persvErrors_stast_stats] = anova1(FL_prop_distDim_persvErrors_stast_data, FL_prop_persvErrors_stast_condLabel,'display','off');
mes1way(FL_prop_distDim_persvErrors_stast_data','eta2','group',(strcmp(FL_prop_persvErrors_stast_condLabel,'highDrug')*3+strcmp(FL_prop_persvErrors_stast_condLabel,'medDrug')*2+strcmp(FL_prop_persvErrors_stast_condLabel,'lowDrug'))');
computeCohen_d(FL_prop_distDim_persvErrors_stast_data(find(strcmp(FL_prop_persvErrors_stast_condLabel,'medDrug'))),...
    FL_prop_distDim_persvErrors_stast_data(find(strcmp(FL_prop_persvErrors_stast_condLabel,'vehicle'))),'independent');

[FL_prop_tarDim_persvErrors_stast_p FL_prop_tarDim_persvErrors_stast_table FL_prop_tarDim_persvErrors_stast_stats] = anova1(FL_prop_tarDim_persvErrors_stast_data, FL_prop_persvErrors_stast_condLabel,'display','off');
mes1way(FL_prop_tarDim_persvErrors_stast_data','eta2','group',(strcmp(FL_prop_persvErrors_stast_condLabel,'highDrug')*3+strcmp(FL_prop_persvErrors_stast_condLabel,'medDrug')*2+strcmp(FL_prop_persvErrors_stast_condLabel,'lowDrug'))');
computeCohen_d(FL_prop_tarDim_persvErrors_stast_data(find(strcmp(FL_prop_persvErrors_stast_condLabel,'medDrug'))),...
    FL_prop_tarDim_persvErrors_stast_data(find(strcmp(FL_prop_persvErrors_stast_condLabel,'vehicle'))),'independent');

FL_length_distDim_persvErrors_stast_condLabel = [repmat({'vehicle'},size(vehicle_FL_length_distDim_persvErrors)),repmat({'lowDrug'},size(drug1_FL_length_distDim_persvErrors)),...
    repmat({'medDrug'},size(drug2_FL_length_distDim_persvErrors)),repmat({'highDrug'},size(drug3_FL_length_distDim_persvErrors))];
FL_length_distDim_persvErrors_stast_data = [vehicle_FL_length_distDim_persvErrors,drug1_FL_length_distDim_persvErrors,drug2_FL_length_distDim_persvErrors,drug3_FL_length_distDim_persvErrors];
[FL_length_distDim_persvErrors_stast_p FL_length_distDim_persvErrors_stast_table FL_length_distDim_persvErrors_stast_stats] = anova1(FL_length_distDim_persvErrors_stast_data, FL_length_distDim_persvErrors_stast_condLabel,'display','off');

FL_length_tarDim_persvErrors_stast_condLabel = [repmat({'vehicle'},size(vehicle_FL_length_tarDim_persvErrors)),repmat({'lowDrug'},size(drug1_FL_length_tarDim_persvErrors)),...
    repmat({'medDrug'},size(drug2_FL_length_tarDim_persvErrors)),repmat({'highDrug'},size(drug3_FL_length_tarDim_persvErrors))];
FL_length_tarDim_persvErrors_stast_data = [vehicle_FL_length_tarDim_persvErrors,drug1_FL_length_tarDim_persvErrors,drug2_FL_length_tarDim_persvErrors,drug3_FL_length_tarDim_persvErrors];
[FL_length_tarDim_persvErrors_stast_p FL_length_tarDim_persvErrors_stast_table FL_length_tarDim_persvErrors_stast_stats] = anova1(FL_length_tarDim_persvErrors_stast_data, FL_length_tarDim_persvErrors_stast_condLabel,'display','off');
mes1way(FL_length_tarDim_persvErrors_stast_data','eta2','group',(strcmp(FL_length_tarDim_persvErrors_stast_condLabel,'highDrug')*3+strcmp(FL_length_tarDim_persvErrors_stast_condLabel,'medDrug')*2+strcmp(FL_length_tarDim_persvErrors_stast_condLabel,'lowDrug'))');
computeCohen_d(FL_length_tarDim_persvErrors_stast_data(find(strcmp(FL_length_tarDim_persvErrors_stast_condLabel,'highDrug'))),...
    FL_length_tarDim_persvErrors_stast_data(find(strcmp(FL_length_tarDim_persvErrors_stast_condLabel,'vehicle'))),'independent');

%plot persv error props and lengths
figure
subplot(3,2,1)
hold on
tmpBar = bar(1:4,[nanmean(vehicle_FL_prop_persvErrors),nanmean(drug1_FL_prop_persvErrors),nanmean(drug2_FL_prop_persvErrors),nanmean(drug3_FL_prop_persvErrors)],'FaceAlpha',0.6);
tmpBar.FaceColor = 'flat';tmpBar.CData = drug_plot_colors;
errorbar(1:4,[nanmean(vehicle_FL_prop_persvErrors),nanmean(drug1_FL_prop_persvErrors),nanmean(drug2_FL_prop_persvErrors),nanmean(drug3_FL_prop_persvErrors)],...
    [SEM_AH(vehicle_FL_prop_persvErrors),SEM_AH(drug1_FL_prop_persvErrors),SEM_AH(drug2_FL_prop_persvErrors),SEM_AH(drug3_FL_prop_persvErrors)],'color','k','linewidth',1,'linestyle','none');
xlim([0.5 4.5]);xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});
ylabel ('prop. errors'); title ('prop. persv errors');ylim([0.05 0.25]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 20;

subplot(3,2,3)
hold on
tmpBar = bar(1:4,[nanmean(vehicle_FL_prop_distDim_persvErrors),nanmean(drug1_FL_prop_distDim_persvErrors),nanmean(drug2_FL_prop_distDim_persvErrors),nanmean(drug3_FL_prop_distDim_persvErrors)],'FaceAlpha',0.6);
tmpBar.FaceColor = 'flat';tmpBar.CData = drug_plot_colors;
errorbar(1:4,[nanmean(vehicle_FL_prop_distDim_persvErrors),nanmean(drug1_FL_prop_distDim_persvErrors),nanmean(drug2_FL_prop_distDim_persvErrors),nanmean(drug3_FL_prop_distDim_persvErrors)],...
    [SEM_AH(vehicle_FL_prop_distDim_persvErrors),SEM_AH(drug1_FL_prop_distDim_persvErrors),SEM_AH(drug2_FL_prop_distDim_persvErrors),SEM_AH(drug3_FL_prop_distDim_persvErrors)],'color','k','linewidth',1,'linestyle','none');
xlim([0.5 4.5]);xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});
ylabel ('prop. errors'); title ('prop. distDim persv errors');ylim([0.05 0.25]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(3,2,4)
hold on
tmpBar = bar(1:4,[nanmean(vehicle_FL_prop_tarDim_persvErrors),nanmean(drug1_FL_prop_tarDim_persvErrors),nanmean(drug2_FL_prop_tarDim_persvErrors),nanmean(drug3_FL_prop_tarDim_persvErrors)],'FaceAlpha',0.6);
tmpBar.FaceColor = 'flat';tmpBar.CData = drug_plot_colors;
errorbar(1:4,[nanmean(vehicle_FL_prop_tarDim_persvErrors),nanmean(drug1_FL_prop_tarDim_persvErrors),nanmean(drug2_FL_prop_tarDim_persvErrors),nanmean(drug3_FL_prop_tarDim_persvErrors)],...
    [SEM_AH(vehicle_FL_prop_tarDim_persvErrors),SEM_AH(drug1_FL_prop_tarDim_persvErrors),SEM_AH(drug2_FL_prop_tarDim_persvErrors),SEM_AH(drug3_FL_prop_tarDim_persvErrors)],'color','k','linewidth',1,'linestyle','none');
xlim([0.5 4.5]);xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});
ylabel ('prop. errors'); title ('prop. tarDim persv errors');ylim([0.05 0.25]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(3,2,5)
hold on
tmpBar = bar(1:4,[nanmean(vehicle_FL_length_distDim_persvErrors),nanmean(drug1_FL_length_distDim_persvErrors),nanmean(drug2_FL_length_distDim_persvErrors),nanmean(drug3_FL_length_distDim_persvErrors)],'FaceAlpha',0.6);
tmpBar.FaceColor = 'flat';tmpBar.CData = drug_plot_colors;
errorbar(1:4,[nanmean(vehicle_FL_length_distDim_persvErrors),nanmean(drug1_FL_length_distDim_persvErrors),nanmean(drug2_FL_length_distDim_persvErrors),nanmean(drug3_FL_length_distDim_persvErrors)],...
    [SEM_AH(vehicle_FL_length_distDim_persvErrors),SEM_AH(drug1_FL_length_distDim_persvErrors),SEM_AH(drug2_FL_length_distDim_persvErrors),SEM_AH(drug3_FL_length_distDim_persvErrors)],'color','k','linewidth',1,'linestyle','none');
xlim([0.5 4.5]);xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});
ylabel ('avg. persv. error length'); title ('avg. length of distDim persv errors');ylim([1.2 2]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(3,2,6)
hold on
tmpBar = bar(1:4,[nanmean(vehicle_FL_length_tarDim_persvErrors),nanmean(drug1_FL_length_tarDim_persvErrors),nanmean(drug2_FL_length_tarDim_persvErrors),nanmean(drug3_FL_length_tarDim_persvErrors)],'FaceAlpha',0.6);
tmpBar.FaceColor = 'flat';tmpBar.CData = drug_plot_colors;
errorbar(1:4,[nanmean(vehicle_FL_length_tarDim_persvErrors),nanmean(drug1_FL_length_tarDim_persvErrors),nanmean(drug2_FL_length_tarDim_persvErrors),nanmean(drug3_FL_length_tarDim_persvErrors)],...
    [SEM_AH(vehicle_FL_length_tarDim_persvErrors),SEM_AH(drug1_FL_length_tarDim_persvErrors),SEM_AH(drug2_FL_length_tarDim_persvErrors),SEM_AH(drug3_FL_length_tarDim_persvErrors)],'color','k','linewidth',1,'linestyle','none');
xlim([0.5 4.5]);xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});
ylabel ('avg. persv. error length'); title ('avg. length of tarDim persv errors');ylim([1.2 2]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
set(gcf,'Position',[1 1 1226 885]);

% saveas(gcf,[figSave_dir 'FL_feat_persvError'],'epsc')

% % individual monkey temporal progress plot (VU595)
% figure
% subplot(2,1,1)
% hold on
% title('all persv. errors');
% scatter(ReiderPersv,1:3,64,'r','filled');
% scatter(SindriPersv,0.95:1:2.95,64,'g','filled');
% scatter(IgorPersv,0.9:1:2.9,64,'b','filled');
% scatter(BardPersv,1.05:1:3.05,64,'c','filled');
% xlabel('prop. persv, errors (diff.)');yticks(1:3);yticklabels({'0.3 mg/kg','1 mg/kg', '3 mg/kg'});
% xline(0);ylim([0.5 3.5]);
% set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
% 
% subplot(2,1,2)
% hold on
% title('dist. dim. persv. errors');
% scatter(ReiderPersv_tarProp,1:3,64,'r','filled');
% scatter(SindriPersv_tarProp,0.95:1:2.95,64,'g','filled');
% scatter(IgorPersv_tarProp,0.9:1:2.9,64,'b','filled');
% scatter(BardPersv_tarProp,1.05:1:3.05,64,'c','filled');
% xlabel('prop. persv, errors  (diff.)');yticks(1:3);yticklabels({'0.3 mg/kg','1 mg/kg', '3 mg/kg'});
% xline(0);ylim([0.5 3.5]);
% set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
% set(gcf,'Position',[1 1 709 483]);
% 
% % saveas(gcf,[figSave_dir 'monkeyTemporal_persvError'],'epsc')

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% FL RT %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

allFL_RT_by_sess = [Reider.allFLU_search_duration_by_sess, Sindri.allFLU_search_duration_by_sess, Igor.allFLU_search_duration_by_sess, Bard.allFLU_search_duration_by_sess];

%correct trials only
allFL_RT_by_sess_corr_only = allFL_RT_by_sess;
for isess = 1:numel(allFL_RT_by_sess_corr_only)    
    allFL_RT_by_sess_corr_only{isess}(find(all_block_outcomes_prob{isess}==0)) = NaN;
end

lowDim_allFL_RT = cellfun (@(x,y) [x(find(y==0),11:end)], allFL_RT_by_sess_corr_only,allFLU_dim_by_block_forCurves,'un',0);
highDim_allFL_RT = cellfun (@(x,y) [x(find(y==1),11:end)], allFL_RT_by_sess_corr_only,allFLU_dim_by_block_forCurves,'un',0);

% limit based on LME results on LP
temporal_limit_FL_RT = 7; %set to maximum block number to be included (not coded for min)

temporal_match_highDim = cellfun(@(x) [nansum(x(1:temporal_limit_FL_RT))], allFLU_dim_by_block_forCurves); %if 21, change to (1:end)
temporal_match_lowDim = temporal_limit_FL_RT - temporal_match_highDim;

% temporal_match_lowDim(26) = temporal_match_lowDim(26)-1;%if 21, manually change to account for the bad block

lowDim_allFL_RT = cellfun (@(x,y) [x(1:y,:)] ,lowDim_allFL_RT,num2cell(temporal_match_lowDim),'un',0); 
highDim_allFL_RT = cellfun (@(x,y) [x(1:y,:)] ,highDim_allFL_RT,num2cell(temporal_match_highDim),'un',0);

%get mean and SEM
lowDim_allFL_RT_blkMean = cellfun (@(x) [nanmean(x,2)], lowDim_allFL_RT,'un',0);
highDim_allFL_RT_blkMean = cellfun (@(x) [nanmean(x,2)], highDim_allFL_RT,'un',0);

vehicle_lowDim_allFL_RT_blkMean = cell2mat(lowDim_allFL_RT_blkMean(vehicle_days_ind)')';
vehicle_highDim_allFL_RT_blkMean = cell2mat(highDim_allFL_RT_blkMean(vehicle_days_ind)')';
drug1_lowDim_allFL_RT_blkMean = cell2mat(lowDim_allFL_RT_blkMean(drug_1days_ind)')';
drug1_highDim_allFL_RT_blkMean = cell2mat(highDim_allFL_RT_blkMean(drug_1days_ind)')';
drug2_lowDim_allFL_RT_blkMean = cell2mat(lowDim_allFL_RT_blkMean(drug_2days_ind)')';
drug2_highDim_allFL_RT_blkMean = cell2mat(highDim_allFL_RT_blkMean(drug_2days_ind)')';
drug3_lowDim_allFL_RT_blkMean = cell2mat(lowDim_allFL_RT_blkMean(drug_3days_ind)')';
drug3_highDim_allFL_RT_blkMean = cell2mat(highDim_allFL_RT_blkMean(drug_3days_ind)')';

vehicle_lowDim_allFL_RT_blkSEM = SEM_AH(vehicle_lowDim_allFL_RT_blkMean);
vehicle_highDim_allFL_RT_blkSEM = SEM_AH(vehicle_highDim_allFL_RT_blkMean);
drug1_lowDim_allFL_RT_blkSEM = SEM_AH(drug1_lowDim_allFL_RT_blkMean);
drug1_highDim_allFL_RT_blkSEM = SEM_AH(drug1_highDim_allFL_RT_blkMean);
drug2_lowDim_allFL_RT_blkSEM = SEM_AH(drug2_lowDim_allFL_RT_blkMean);
drug2_highDim_allFL_RT_blkSEM = SEM_AH(drug2_highDim_allFL_RT_blkMean);
drug3_lowDim_allFL_RT_blkSEM = SEM_AH(drug3_lowDim_allFL_RT_blkMean);
drug3_highDim_allFL_RT_blkSEM = SEM_AH(drug3_highDim_allFL_RT_blkMean);

lowDim_allFL_RT_sessMean = cellfun (@(x) [nanmean(x(:))], lowDim_allFL_RT,'un',0);
highDim_allFL_RT_sessMean = cellfun (@(x) [nanmean(x(:))], highDim_allFL_RT,'un',0);

vehicle_lowDim_allFL_RT_sessMean = cell2mat(lowDim_allFL_RT_sessMean(vehicle_days_ind));
vehicle_highDim_allFL_RT_sessMean = cell2mat(highDim_allFL_RT_sessMean(vehicle_days_ind));
drug1_lowDim_allFL_RT_sessMean = cell2mat(lowDim_allFL_RT_sessMean(drug_1days_ind));
drug1_highDim_allFL_RT_sessMean = cell2mat(highDim_allFL_RT_sessMean(drug_1days_ind));
drug2_lowDim_allFL_RT_sessMean = cell2mat(lowDim_allFL_RT_sessMean(drug_2days_ind));
drug2_highDim_allFL_RT_sessMean = cell2mat(highDim_allFL_RT_sessMean(drug_2days_ind));
drug3_lowDim_allFL_RT_sessMean = cell2mat(lowDim_allFL_RT_sessMean(drug_3days_ind));
drug3_highDim_allFL_RT_sessMean = cell2mat(highDim_allFL_RT_sessMean(drug_3days_ind));

vehicle_lowDim_allFL_RT_sessSEM = SEM_AH(vehicle_lowDim_allFL_RT_sessMean);
vehicle_highDim_allFL_RT_sessSEM = SEM_AH(vehicle_highDim_allFL_RT_sessMean);
drug1_lowDim_allFL_RT_sessSEM = SEM_AH(drug1_lowDim_allFL_RT_sessMean);
drug1_highDim_allFL_RT_sessSEM = SEM_AH(drug1_highDim_allFL_RT_sessMean);
drug2_lowDim_allFL_RT_sessSEM = SEM_AH(drug2_lowDim_allFL_RT_sessMean);
drug2_highDim_allFL_RT_sessSEM = SEM_AH(drug2_highDim_allFL_RT_sessMean);
drug3_lowDim_allFL_RT_sessSEM = SEM_AH(drug3_lowDim_allFL_RT_sessMean);
drug3_highDim_allFL_RT_sessSEM = SEM_AH(drug3_highDim_allFL_RT_sessMean);

%stats
FL_RT_blkData = [vehicle_lowDim_allFL_RT_blkMean,drug1_lowDim_allFL_RT_blkMean,drug2_lowDim_allFL_RT_blkMean,drug3_lowDim_allFL_RT_blkMean,...
    vehicle_highDim_allFL_RT_blkMean,drug1_highDim_allFL_RT_blkMean,drug2_highDim_allFL_RT_blkMean,drug3_highDim_allFL_RT_blkMean];
FL_RT_blk_loadLabel = [repmat({'lowLoad'},size([vehicle_lowDim_allFL_RT_blkMean,drug1_lowDim_allFL_RT_blkMean,drug2_lowDim_allFL_RT_blkMean,drug3_lowDim_allFL_RT_blkMean])),...
    repmat({'highLoad'},size([vehicle_highDim_allFL_RT_blkMean,drug1_highDim_allFL_RT_blkMean,drug2_highDim_allFL_RT_blkMean,drug3_highDim_allFL_RT_blkMean]))];
FL_RT_blk_condLabel = [repmat({'vehicle'},size(vehicle_lowDim_allFL_RT_blkMean)),repmat({'drugLow'},size(drug1_lowDim_allFL_RT_blkMean)),...
    repmat({'drugMed'},size(drug2_lowDim_allFL_RT_blkMean)),repmat({'drugHigh'},size(drug3_lowDim_allFL_RT_blkMean)),repmat({'vehicle'},size(vehicle_highDim_allFL_RT_blkMean)),...
    repmat({'drugLow'},size(drug1_highDim_allFL_RT_blkMean)),repmat({'drugMed'},size(drug2_highDim_allFL_RT_blkMean)),repmat({'drugHigh'},size(drug3_highDim_allFL_RT_blkMean))];

[FL_RT_anova_blkPool_p,FL_RT_anova_blkPool_table,FL_RT_anova_blkPool_stats] = anovan(FL_RT_blkData(:),{FL_RT_blk_loadLabel(:),FL_RT_blk_condLabel(:)},'model','interaction','varnames',{'load','cond'},'display','off');
% multcompare(FL_RT_anova_blkPool_stats,'Dimension',2)
%effect size
effectSizeGrouptmp = [strcmp(FL_RT_blk_loadLabel,'highLoad')' (strcmp(FL_RT_blk_condLabel,'drugHigh')*3+strcmp(FL_RT_blk_condLabel,'drugMed')*2+strcmp(FL_RT_blk_condLabel,'drugLow'))'];
mes2way(FL_RT_blkData(:),effectSizeGrouptmp,'eta2','fName',{'Load','Cond'});
computeCohen_d(FL_RT_blkData(intersect(find(strcmp(FL_RT_blk_loadLabel,'lowLoad')), find(strcmp(FL_RT_blk_condLabel,'drugMed')))),...
    FL_RT_blkData(intersect(find(strcmp(FL_RT_blk_loadLabel,'lowLoad')), find(strcmp(FL_RT_blk_condLabel,'vehicle')))),'independent');

%plotting FL RT by session and distractor load
figure
hold on
errorbar(1:2,[nanmean(vehicle_lowDim_allFL_RT_blkMean) nanmean(vehicle_highDim_allFL_RT_blkMean)],...
    [vehicle_lowDim_allFL_RT_blkSEM vehicle_highDim_allFL_RT_blkSEM],'.-','color',drug_plot_colors(1,:),'MarkerSize',40,'Linewidth',3);
errorbar(0.95:1:1.95,[nanmean(drug1_lowDim_allFL_RT_blkMean) nanmean(drug1_highDim_allFL_RT_blkMean)],...
    [drug1_lowDim_allFL_RT_blkSEM drug1_highDim_allFL_RT_blkSEM],'.-','color',drug_plot_colors(2,:),'MarkerSize',40,'Linewidth',3);
errorbar(1.05:1:2.05,[nanmean(drug2_lowDim_allFL_RT_blkMean) nanmean(drug2_highDim_allFL_RT_blkMean)],...
    [drug2_lowDim_allFL_RT_blkSEM drug2_highDim_allFL_RT_blkSEM],'.-','color',drug_plot_colors(3,:),'MarkerSize',40,'Linewidth',3);
errorbar(1.1:1:2.1,[nanmean(drug3_lowDim_allFL_RT_blkMean) nanmean(drug3_highDim_allFL_RT_blkMean)],...
    [drug3_lowDim_allFL_RT_blkSEM drug3_highDim_allFL_RT_blkSEM],'.-','color',drug_plot_colors(4,:),'MarkerSize',40,'Linewidth',3);
xticks(1:2);xticklabels({'low distractor load','high distractor load'}); xlim([0.6 2.35]);
ylabel('FL RT (s)'); title ('correct only (block-wise avg.)');
legend({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'},'Location','southeast');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 20;
set(gcf,'Position',[1 1 560 420]);

% saveas(gcf,[figSave_dir 'FL_RT'],'epsc')

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% FL RT fit (altLP) %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fit_lowDim_allFL_RT = cellfun (@(x,y) [x(find(y==0),11:end)], allFL_RT_by_sess,allFLU_dim_by_block_forCurves,'un',0);
fit_highDim_allFL_RT = cellfun (@(x,y) [x(find(y==1),11:end)], allFL_RT_by_sess,allFLU_dim_by_block_forCurves,'un',0);

%params: [max-min L50 (1 or 5) min_value]
% limit based on LME results on LP
fit_temporal_limit = 7; %restrict blocks used for fit to 1:n

fit_temporal_match_highDim = cellfun(@(x) [nansum(x(1:fit_temporal_limit))], allFLU_dim_by_block);
fit_temporal_match_lowDim = fit_temporal_limit - fit_temporal_match_highDim;

fit_temporal_match_lowDim(26) = fit_temporal_match_lowDim(26)-1;%if fit_temporal_limit = 1, account for bad block


[sess_fit_lowDim total_fit_lowDim] = hyperb_fit_AH(fit_lowDim_allFL_RT,30,allFLU_altLP_by_blockNum,fit_temporal_match_lowDim); % 30 trials after block start
[sess_fit_highDim total_fit_highDim] = hyperb_fit_AH(fit_highDim_allFL_RT,30,allFLU_altLP_by_blockNum,fit_temporal_match_highDim); % 30 trials after block start

%halfway trl where RT shifts (may reflect confidence)
FL_lowDim_confidenceRT_trl = cellfun (@(x) [find(diff(x)<0,1)], num2cell(sess_fit_lowDim.curve,2));
FL_highDim_confidenceRT_trl = cellfun (@(x) [find(diff(x)<0,1)], num2cell(sess_fit_highDim.curve,2));

vehicle_FL_lowDim_confidenceRT_trl = FL_lowDim_confidenceRT_trl(vehicle_days_ind);vehicle_FL_lowDim_confidenceRT_trl(find(vehicle_FL_lowDim_confidenceRT_trl<=2)) = NaN;
drug1_FL_lowDim_confidenceRT_trl = FL_lowDim_confidenceRT_trl(drug_1days_ind);drug1_FL_lowDim_confidenceRT_trl(find(drug1_FL_lowDim_confidenceRT_trl<=2)) = NaN;
drug2_FL_lowDim_confidenceRT_trl = FL_lowDim_confidenceRT_trl(drug_2days_ind);drug2_FL_lowDim_confidenceRT_trl(find(drug2_FL_lowDim_confidenceRT_trl<=2)) = NaN;
drug3_FL_lowDim_confidenceRT_trl = FL_lowDim_confidenceRT_trl(drug_3days_ind);drug3_FL_lowDim_confidenceRT_trl(find(drug3_FL_lowDim_confidenceRT_trl<=2)) = NaN;

vehicle_FL_highDim_confidenceRT_trl = FL_highDim_confidenceRT_trl(vehicle_days_ind);vehicle_FL_highDim_confidenceRT_trl(find(vehicle_FL_highDim_confidenceRT_trl<=2)) = NaN;
drug1_FL_highDim_confidenceRT_trl = FL_highDim_confidenceRT_trl(drug_1days_ind);drug1_FL_highDim_confidenceRT_trl(find(drug1_FL_highDim_confidenceRT_trl<=2)) = NaN;
drug2_FL_highDim_confidenceRT_trl = FL_highDim_confidenceRT_trl(drug_2days_ind);drug2_FL_highDim_confidenceRT_trl(find(drug2_FL_highDim_confidenceRT_trl<=2)) = NaN;
drug3_FL_highDim_confidenceRT_trl = FL_highDim_confidenceRT_trl(drug_3days_ind);drug3_FL_highDim_confidenceRT_trl(find(drug3_FL_highDim_confidenceRT_trl<=2)) = NaN;

% individual monkey temporal progress (VU595)

Reider_RTtrl_lowDim = FL_lowDim_confidenceRT_trl(1:ntmp(1));
Reider_RTtrl_lowDim = [nanmean(Reider_RTtrl_lowDim(find(Reider.drug_1days_ind)))-nanmean(Reider_RTtrl_lowDim(Reider_vehicleDays)),...
    nanmean(Reider_RTtrl_lowDim(find(Reider.drug_2days_ind)))-nanmean(Reider_RTtrl_lowDim(Reider_vehicleDays)),...
    nanmean(Reider_RTtrl_lowDim(find(Reider.drug_3days_ind)))-nanmean(Reider_RTtrl_lowDim(Reider_vehicleDays))];
Sindri_RTtrl_lowDim = FL_lowDim_confidenceRT_trl(ntmp(1)+1:ntmp(2));
Sindri_RTtrl_lowDim = [nanmean(Sindri_RTtrl_lowDim(find(Sindri.drug_1days_ind)))-nanmean(Sindri_RTtrl_lowDim(Sindri_vehicleDays)),...
    nanmean(Sindri_RTtrl_lowDim(find(Sindri.drug_2days_ind)))-nanmean(Sindri_RTtrl_lowDim(Sindri_vehicleDays)),...
    nanmean(Sindri_RTtrl_lowDim(find(Sindri.drug_3days_ind)))-nanmean(Sindri_RTtrl_lowDim(Sindri_vehicleDays))];
Igor_RTtrl_lowDim = FL_lowDim_confidenceRT_trl(ntmp(2)+1:ntmp(3));
Igor_RTtrl_lowDim = [nanmean(Igor_RTtrl_lowDim(find(Igor.drug_1days_ind)))-nanmean(Igor_RTtrl_lowDim(Igor_vehicleDays)),...
    nanmean(Igor_RTtrl_lowDim(find(Igor.drug_2days_ind)))-nanmean(Igor_RTtrl_lowDim(Igor_vehicleDays)),...
    nanmean(Igor_RTtrl_lowDim(find(Igor.drug_3days_ind)))-nanmean(Igor_RTtrl_lowDim(Igor_vehicleDays))];
Bard_RTtrl_lowDim = FL_lowDim_confidenceRT_trl(ntmp(3)+1:ntmp(4));
Bard_RTtrl_lowDim = [nanmean(Bard_RTtrl_lowDim(find(Bard.drug_1days_ind)))-nanmean(Bard_RTtrl_lowDim(Bard_vehicleDays)),...
    nanmean(Bard_RTtrl_lowDim(find(Bard.drug_2days_ind)))-nanmean(Bard_RTtrl_lowDim(Bard_vehicleDays)),...
    nanmean(Bard_RTtrl_lowDim(find(Bard.drug_3days_ind)))-nanmean(Bard_RTtrl_lowDim(Bard_vehicleDays))];

Reider_RTtrl_highDim = FL_highDim_confidenceRT_trl(1:ntmp(1));
Reider_RTtrl_highDim = [nanmean(Reider_RTtrl_highDim(find(Reider.drug_1days_ind)))-nanmean(Reider_RTtrl_highDim(Reider_vehicleDays)),...
    nanmean(Reider_RTtrl_highDim(find(Reider.drug_2days_ind)))-nanmean(Reider_RTtrl_highDim(Reider_vehicleDays)),...
    nanmean(Reider_RTtrl_highDim(find(Reider.drug_3days_ind)))-nanmean(Reider_RTtrl_highDim(Reider_vehicleDays))];
Sindri_RTtrl_highDim = FL_highDim_confidenceRT_trl(ntmp(1)+1:ntmp(2));
Sindri_RTtrl_highDim = [nanmean(Sindri_RTtrl_highDim(find(Sindri.drug_1days_ind)))-nanmean(Sindri_RTtrl_highDim(Sindri_vehicleDays)),...
    nanmean(Sindri_RTtrl_highDim(find(Sindri.drug_2days_ind)))-nanmean(Sindri_RTtrl_highDim(Sindri_vehicleDays)),...
    nanmean(Sindri_RTtrl_highDim(find(Sindri.drug_3days_ind)))-nanmean(Sindri_RTtrl_highDim(Sindri_vehicleDays))];
Igor_RTtrl_highDim = FL_highDim_confidenceRT_trl(ntmp(2)+1:ntmp(3));
Igor_RTtrl_highDim = [nanmean(Igor_RTtrl_highDim(find(Igor.drug_1days_ind)))-nanmean(Igor_RTtrl_highDim(Igor_vehicleDays)),...
    nanmean(Igor_RTtrl_highDim(find(Igor.drug_2days_ind)))-nanmean(Igor_RTtrl_highDim(Igor_vehicleDays)),...
    nanmean(Igor_RTtrl_highDim(find(Igor.drug_3days_ind)))-nanmean(Igor_RTtrl_highDim(Igor_vehicleDays))];
Bard_RTtrl_highDim = FL_highDim_confidenceRT_trl(ntmp(3)+1:ntmp(4));
Bard_RTtrl_highDim = [nanmean(Bard_RTtrl_highDim(find(Bard.drug_1days_ind)))-nanmean(Bard_RTtrl_highDim(Bard_vehicleDays)),...
    nanmean(Bard_RTtrl_highDim(find(Bard.drug_2days_ind)))-nanmean(Bard_RTtrl_highDim(Bard_vehicleDays)),...
    nanmean(Bard_RTtrl_highDim(find(Bard.drug_3days_ind)))-nanmean(Bard_RTtrl_highDim(Bard_vehicleDays))];

%stats for fits
FL_RT_fit_data = [vehicle_FL_lowDim_confidenceRT_trl; drug1_FL_lowDim_confidenceRT_trl; drug2_FL_lowDim_confidenceRT_trl; drug3_FL_lowDim_confidenceRT_trl;...
    vehicle_FL_highDim_confidenceRT_trl;drug1_FL_highDim_confidenceRT_trl;drug2_FL_highDim_confidenceRT_trl;drug3_FL_highDim_confidenceRT_trl];
FL_RT_fit_condLabel = [repmat({'vehicle'},size(vehicle_FL_lowDim_confidenceRT_trl));repmat({'drugLow'},size(drug1_FL_lowDim_confidenceRT_trl));...
    repmat({'drugMed'},size(drug2_FL_lowDim_confidenceRT_trl));repmat({'drugHigh'},size(drug3_FL_lowDim_confidenceRT_trl));...
    repmat({'vehicle'},size(vehicle_FL_highDim_confidenceRT_trl));repmat({'drugLow'},size(drug1_FL_highDim_confidenceRT_trl));...
    repmat({'drugMed'},size(drug2_FL_highDim_confidenceRT_trl));repmat({'drugHigh'},size(drug3_FL_highDim_confidenceRT_trl))];
FL_RT_fit_loadLabel = [repmat({'lowDim'}, size([vehicle_FL_lowDim_confidenceRT_trl; drug1_FL_lowDim_confidenceRT_trl; drug2_FL_lowDim_confidenceRT_trl; drug3_FL_lowDim_confidenceRT_trl]));
    repmat({'highDim'}, size([vehicle_FL_highDim_confidenceRT_trl;drug1_FL_highDim_confidenceRT_trl;drug2_FL_highDim_confidenceRT_trl;drug3_FL_highDim_confidenceRT_trl]))];
[FL_RT_fit_p,FL_RT_fit_table,FL_RT_fit_stats]=anovan(FL_RT_fit_data,{FL_RT_fit_loadLabel,FL_RT_fit_condLabel},'model','interaction','varnames',{'load','cond'},'display','off');
% multcompare(FL_RT_fit_stats,'dimension',2)
%effect size
effectSizeGrouptmp = [strcmp(FL_RT_fit_loadLabel,'highDim') (strcmp(FL_RT_fit_condLabel,'drugHigh')*3+strcmp(FL_RT_fit_condLabel,'drugMed')*2+strcmp(FL_RT_fit_condLabel,'drugLow'))];
mes2way(FL_RT_fit_data,effectSizeGrouptmp,'eta2','fName',{'Load','Cond'});

FL_RT_fit_lowDim_data = [vehicle_FL_lowDim_confidenceRT_trl; drug1_FL_lowDim_confidenceRT_trl; drug2_FL_lowDim_confidenceRT_trl; drug3_FL_lowDim_confidenceRT_trl]; 
FL_RT_fit_lowDim_label = [repmat({'vehicle'},size(vehicle_FL_lowDim_confidenceRT_trl));repmat({'drugLow'},size(drug1_FL_lowDim_confidenceRT_trl));...
    repmat({'drugMed'},size(drug2_FL_lowDim_confidenceRT_trl));repmat({'drugHigh'},size(drug3_FL_lowDim_confidenceRT_trl))];
[FL_RT_fit_lowDim_p,FL_RT_fit_lowDim_table,FL_RT_fit_lowDim_stats]=anova1(FL_RT_fit_lowDim_data,FL_RT_fit_lowDim_label,'display','off');
% dunnett(FL_RT_fit_lowDim_stats)
%effect size
mes1way(FL_RT_fit_lowDim_data,'eta2','group',(strcmp(FL_RT_fit_lowDim_label,'drugHigh')*3+strcmp(FL_RT_fit_lowDim_label,'drugMed')*2+strcmp(FL_RT_fit_lowDim_label,'drugLow')));
computeCohen_d(FL_RT_fit_lowDim_data(find(strcmp(FL_RT_fit_lowDim_label,'drugMed'))),...
    FL_RT_fit_lowDim_data(find(strcmp(FL_RT_fit_lowDim_label,'vehicle'))),'independent');

FL_RT_fit_highDim_data = [vehicle_FL_highDim_confidenceRT_trl; drug1_FL_highDim_confidenceRT_trl; drug2_FL_highDim_confidenceRT_trl; drug3_FL_highDim_confidenceRT_trl]; 
FL_RT_fit_highDim_label = [repmat({'vehicle'},size(vehicle_FL_highDim_confidenceRT_trl));repmat({'drugLow'},size(drug1_FL_highDim_confidenceRT_trl));...
    repmat({'drugMed'},size(drug2_FL_highDim_confidenceRT_trl));repmat({'drugHigh'},size(drug3_FL_highDim_confidenceRT_trl))];
[FL_RT_fit_highDim_p,FL_RT_fit_highDim_table,FL_RT_fit_highDim_stats]=anova1(FL_RT_fit_highDim_data,FL_RT_fit_highDim_label,'display','off');
% dunnett(FL_RT_fit_highDim_stats)
%effect size
mes1way(FL_RT_fit_highDim_data,'eta2','group',(strcmp(FL_RT_fit_highDim_label,'drugHigh')*3+strcmp(FL_RT_fit_highDim_label,'drugMed')*2+strcmp(FL_RT_fit_highDim_label,'drugLow')));
computeCohen_d(FL_RT_fit_highDim_data(find(strcmp(FL_RT_fit_highDim_label,'drugMed'))),...
    FL_RT_fit_highDim_data(find(strcmp(FL_RT_fit_highDim_label,'vehicle'))),'independent');

figure
subplot(2,2,1)
hold on
tmpplot1 = shadedErrorBar(1:30,nanmean(sess_fit_lowDim.curve(drug_1days_ind,:)),cellfun(@SEM_AH, num2cell(sess_fit_lowDim.curve(drug_1days_ind,:),1)),'lineProps','g-','patchSaturation',0.2);
tmpplot2 = shadedErrorBar(1:30,nanmean(sess_fit_lowDim.curve(drug_2days_ind,:)),cellfun(@SEM_AH, num2cell(sess_fit_lowDim.curve(drug_2days_ind,:),1)),'lineProps','k-','patchSaturation',0.2);
tmpplot3 = shadedErrorBar(1:30,nanmean(sess_fit_lowDim.curve(drug_3days_ind,:)),cellfun(@SEM_AH, num2cell(sess_fit_lowDim.curve(drug_3days_ind,:),1)),'lineProps','r-','patchSaturation',0.2);
tmpplot4 = shadedErrorBar(1:30,nanmean(sess_fit_lowDim.curve(vehicle_days_ind,:)),cellfun(@SEM_AH, num2cell(sess_fit_lowDim.curve(vehicle_days_ind,:),1)),'lineProps','k-','patchSaturation',0.2);
tmpplot2.patch.FaceColor=drug_plot_colors(3,:);tmpplot2.mainLine.Color=drug_plot_colors(3,:);tmpplot2.edge(1).Color=drug_plot_colors(3,:);tmpplot2.edge(2).Color=drug_plot_colors(3,:);
tmpplot1.mainLine.LineWidth = 2;tmpplot2.mainLine.LineWidth = 2;tmpplot3.mainLine.LineWidth = 2;tmpplot4.mainLine.LineWidth = 2;
xlabel ('Trial since reversal'); ylabel ('RT'); title ('Smoothed lowDim'); ylim([0.7 1.1]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(2,2,2)
hold on
tmpplot1 = shadedErrorBar(1:30,nanmean(sess_fit_highDim.curve(drug_1days_ind,:)),cellfun(@SEM_AH, num2cell(sess_fit_highDim.curve(drug_1days_ind,:),1)),'lineProps','g-','patchSaturation',0.2);
tmpplot2 = shadedErrorBar(1:30,nanmean(sess_fit_highDim.curve(drug_2days_ind,:)),cellfun(@SEM_AH, num2cell(sess_fit_highDim.curve(drug_2days_ind,:),1)),'lineProps','k-','patchSaturation',0.2);
tmpplot3 = shadedErrorBar(1:30,nanmean(sess_fit_highDim.curve(drug_3days_ind,:)),cellfun(@SEM_AH, num2cell(sess_fit_highDim.curve(drug_3days_ind,:),1)),'lineProps','r-','patchSaturation',0.2);
tmpplot4 = shadedErrorBar(1:30,nanmean(sess_fit_highDim.curve(vehicle_days_ind,:)),cellfun(@SEM_AH, num2cell(sess_fit_highDim.curve(vehicle_days_ind,:),1)),'lineProps','k-','patchSaturation',0.2);
tmpplot2.patch.FaceColor=drug_plot_colors(3,:);tmpplot2.mainLine.Color=drug_plot_colors(3,:);tmpplot2.edge(1).Color=drug_plot_colors(3,:);tmpplot2.edge(2).Color=drug_plot_colors(3,:);
tmpplot1.mainLine.LineWidth = 2;tmpplot2.mainLine.LineWidth = 2;tmpplot3.mainLine.LineWidth = 2;tmpplot4.mainLine.LineWidth = 2;
xlabel ('Trial since reversal'); ylabel ('RT'); title ('Smoothed highDim'); ylim([0.7 1.1]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(2,2,3)
hold on
errorbar(1,nanmean(vehicle_FL_lowDim_confidenceRT_trl),SEM_AH(vehicle_FL_lowDim_confidenceRT_trl),'.-','color',drug_plot_colors(1,:),'MarkerSize',40,'linestyle','none');
errorbar(2,nanmean(drug1_FL_lowDim_confidenceRT_trl),SEM_AH(drug1_FL_lowDim_confidenceRT_trl),'.-','color',drug_plot_colors(2,:),'MarkerSize',40,'linestyle','none');
errorbar(3,nanmean(drug2_FL_lowDim_confidenceRT_trl),SEM_AH(drug2_FL_lowDim_confidenceRT_trl),'.-','color',drug_plot_colors(3,:),'MarkerSize',40,'linestyle','none');
errorbar(4,nanmean(drug3_FL_lowDim_confidenceRT_trl),SEM_AH(drug3_FL_lowDim_confidenceRT_trl),'.-','color',drug_plot_colors(4,:),'MarkerSize',40,'linestyle','none');
xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});xlim([0.5 4.5]); ylim([5 10]);
ylabel('trial-to-inflection'); title('first speeding up RT trl lowDim');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 20;

subplot(2,2,4)
hold on
errorbar(1,nanmean(vehicle_FL_highDim_confidenceRT_trl),SEM_AH(vehicle_FL_highDim_confidenceRT_trl),'.-','color',drug_plot_colors(1,:),'MarkerSize',20,'linestyle','none');
errorbar(2,nanmean(drug1_FL_highDim_confidenceRT_trl),SEM_AH(drug1_FL_highDim_confidenceRT_trl),'.-','color',drug_plot_colors(2,:),'MarkerSize',20,'linestyle','none');
errorbar(3,nanmean(drug2_FL_highDim_confidenceRT_trl),SEM_AH(drug2_FL_highDim_confidenceRT_trl),'.-','color',drug_plot_colors(3,:),'MarkerSize',20,'linestyle','none');
errorbar(4,nanmean(drug3_FL_highDim_confidenceRT_trl),SEM_AH(drug3_FL_highDim_confidenceRT_trl),'.-','color',drug_plot_colors(4,:),'MarkerSize',20,'linestyle','none');
xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});xlim([0.5 4.5]); ylim([5 10]);
ylabel('trial-to-inflection'); title('first speeding up RT trl highDim');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 20;
set(gcf,'Position',[1 1 1232 775]);

% saveas(gcf,[figSave_dir 'FL_RT_shiftTrl'],'epsc')

% % individual monkey temporal progress plot (VU595)
% 
% figure
% subplot(2,1,1)
% hold on
% title('lowDim');
% scatter(Reider_RTtrl_lowDim,1:3,64,'r','filled');
% scatter(Sindri_RTtrl_lowDim,0.95:1:2.95,64,'g','filled');
% scatter(Igor_RTtrl_lowDim,0.9:1:2.9,64,'b','filled');
% scatter(Bard_RTtrl_lowDim,1.05:1:3.05,64,'c','filled');
% xlabel('prop. persv, errors (diff.)');yticks(1:3);yticklabels({'0.3 mg/kg','1 mg/kg', '3 mg/kg'});
% xline(0);ylim([0.5 3.5]);
% % legend({'monkey Re','monkey Si','monkey Ig','monkey Ba'},'location','nw')
% set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
% 
% subplot(2,1,2)
% hold on
% title('highDim');
% scatter(Reider_RTtrl_highDim,1:3,64,'r','filled');
% scatter(Sindri_RTtrl_highDim,0.95:1:2.95,64,'g','filled');
% scatter(Igor_RTtrl_highDim,0.9:1:2.9,64,'b','filled');
% scatter(Bard_RTtrl_highDim,1.05:1:3.05,64,'c','filled');
% xlabel('prop. persv, errors  (diff.)');yticks(1:3);yticklabels({'0.3 mg/kg','1 mg/kg', '3 mg/kg'});
% xline(0);ylim([0.5 3.5]);
% set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
% set(gcf,'Position',[1 1 709 483]);
% 
% % saveas(gcf,[figSave_dir 'monkeyTemporal_RTtrl'],'epsc')

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Speed accuracy tradeoff %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% limit based on LME results on LP
SA_tradeoff_temporal_limit = 7; %restrict blocks used to 1:n

SA_tradeoff_pooling = 'block'; %'block' or 'sess'
if strcmp(SA_tradeoff_pooling,'block')
    FL_RT_SA_tradeoff = cellfun(@(x) [nanmean(x(1:SA_tradeoff_temporal_limit,11:end),2)], allFL_RT_by_sess_corr_only,'un',0);
    FL_perf_SA_tradeoff = cellfun(@(x) [nanmean(x(1:SA_tradeoff_temporal_limit, 11:end),2)], all_block_outcomes_prob,'un',0);
    
    vehicle_FL_SA_tradeoff = [cell2mat(FL_RT_SA_tradeoff(vehicle_days_ind)') cell2mat(FL_perf_SA_tradeoff(vehicle_days_ind)')];
    drug1_FL_SA_tradeoff = [cell2mat(FL_RT_SA_tradeoff(drug_1days_ind)') cell2mat(FL_perf_SA_tradeoff(drug_1days_ind)')];
    drug2_FL_SA_tradeoff = [cell2mat(FL_RT_SA_tradeoff(drug_2days_ind)') cell2mat(FL_perf_SA_tradeoff(drug_2days_ind)')];
    drug3_FL_SA_tradeoff = [cell2mat(FL_RT_SA_tradeoff(drug_3days_ind)') cell2mat(FL_perf_SA_tradeoff(drug_3days_ind)')];
    
elseif strcmp(SA_tradeoff_pooling,'sess')
    
    FL_RT_SA_tradeoff = cellfun(@(x) [nanmean(nanmean(x(1:SA_tradeoff_temporal_limit,11:end),2))], allFL_RT_by_sess_corr_only);
    FL_perf_SA_tradeoff = cellfun(@(x) [nanmean(nanmean(x(1:SA_tradeoff_temporal_limit, 11:end),2))], all_block_outcomes_prob);

    vehicle_FL_SA_tradeoff = [FL_RT_SA_tradeoff(vehicle_days_ind)' FL_perf_SA_tradeoff(vehicle_days_ind)'];
    drug1_FL_SA_tradeoff = [FL_RT_SA_tradeoff(drug_1days_ind)' FL_perf_SA_tradeoff(drug_1days_ind)'];
    drug2_FL_SA_tradeoff = [FL_RT_SA_tradeoff(drug_2days_ind)' FL_perf_SA_tradeoff(drug_2days_ind)'];
    drug3_FL_SA_tradeoff = [FL_RT_SA_tradeoff(drug_3days_ind)' FL_perf_SA_tradeoff(drug_3days_ind)'];
end

%remove nans which don't play nice in corr
vehicle_FL_SA_tradeoff(find(isnan(vehicle_FL_SA_tradeoff(:,1))),:) = [];
vehicle_FL_SA_tradeoff(find(isnan(vehicle_FL_SA_tradeoff(:,2))),:) = [];
drug1_FL_SA_tradeoff(find(isnan(drug1_FL_SA_tradeoff(:,2))),:) = [];
drug2_FL_SA_tradeoff(find(isnan(drug2_FL_SA_tradeoff(:,2))),:) = [];
drug3_FL_SA_tradeoff(find(isnan(drug3_FL_SA_tradeoff(:,2))),:) = [];

%get correlations
[vehicle_FL_SA_tradeoff_stats, vehicle_FL_SA_tradeoff_p] = corr (vehicle_FL_SA_tradeoff,'type','Pearson');
[drug1_FL_SA_tradeoff_stats, drug1_FL_SA_tradeoff_p] = corr (drug1_FL_SA_tradeoff,'type','Pearson');
[drug2_FL_SA_tradeoff_stats, drug2_FL_SA_tradeoff_p] = corr (drug2_FL_SA_tradeoff,'type','Pearson');
[drug3_FL_SA_tradeoff_stats, drug3_FL_SA_tradeoff_p] = corr (drug3_FL_SA_tradeoff,'type','Pearson');

%stats comparing significant correlations
vehicle_drug1_FL_SA = compare_correlation_coefficients(vehicle_FL_SA_tradeoff_stats(1,2),drug1_FL_SA_tradeoff_stats(1,2),size(vehicle_FL_SA_tradeoff,1),size(drug1_FL_SA_tradeoff,1));
vehicle_drug2_FL_SA = compare_correlation_coefficients(vehicle_FL_SA_tradeoff_stats(1,2),drug2_FL_SA_tradeoff_stats(1,2),size(vehicle_FL_SA_tradeoff,1),size(drug2_FL_SA_tradeoff,1));
vehicle_drug3_FL_SA = compare_correlation_coefficients(vehicle_FL_SA_tradeoff_stats(1,2),drug3_FL_SA_tradeoff_stats(1,2),size(vehicle_FL_SA_tradeoff,1),size(drug3_FL_SA_tradeoff,1));

%plot SA tradeoff
figure
subplot(1,2,1)
hold on
scatter(vehicle_FL_SA_tradeoff(:,1),vehicle_FL_SA_tradeoff(:,2),64,'k','filled');
scatter(drug1_FL_SA_tradeoff(:,1),drug1_FL_SA_tradeoff(:,2),64,drug_plot_colors(2,:),'filled');
scatter(drug2_FL_SA_tradeoff(:,1),drug2_FL_SA_tradeoff(:,2),64,drug_plot_colors(3,:),'filled');
scatter(drug3_FL_SA_tradeoff(:,1),drug3_FL_SA_tradeoff(:,2),64,drug_plot_colors(4,:),'filled');
Fit_vehicle = polyfit(vehicle_FL_SA_tradeoff(:,1),vehicle_FL_SA_tradeoff(:,2),1);
Fit_drug1 = polyfit(drug1_FL_SA_tradeoff(:,1),drug1_FL_SA_tradeoff(:,2),1);
Fit_drug2 = polyfit(drug2_FL_SA_tradeoff(:,1),drug2_FL_SA_tradeoff(:,2),1);
Fit_drug3 = polyfit(drug3_FL_SA_tradeoff(:,1),drug3_FL_SA_tradeoff(:,2),1);
plot(0.1:0.1:2,polyval(Fit_vehicle,0.1:0.1:2),'k','linewidth',2);plot(0.1:0.1:2,polyval(Fit_drug1,0.1:0.1:2),'color',drug_plot_colors(2,:),'linewidth',2);
plot(0.1:0.1:2,polyval(Fit_drug2,0.1:0.1:2),'color',drug_plot_colors(3,:),'linewidth',2);plot(0.1:0.1:2,polyval(Fit_drug3,0.1:0.1:2),'color',drug_plot_colors(4,:),'linewidth',2);
xlabel ('FL RT');ylabel ('FL perf (% correct)');xlim([0.5 2]);ylim([0.3 1]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(1,2,2)
hold on
errorbar(1,vehicle_FL_SA_tradeoff_stats(1,2),NaN,'.-','color',drug_plot_colors(1,:),'MarkerSize',20,'linestyle','none');
errorbar(2,drug1_FL_SA_tradeoff_stats(1,2),NaN,'.-','color',drug_plot_colors(2,:),'MarkerSize',20,'linestyle','none');
errorbar(3,drug2_FL_SA_tradeoff_stats(1,2),NaN,'.-','color',drug_plot_colors(3,:),'MarkerSize',20,'linestyle','none');
errorbar(4,drug3_FL_SA_tradeoff_stats(1,2),NaN,'.-','color',drug_plot_colors(4,:),'MarkerSize',20,'linestyle','none');
xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});xlim([0.5 4.5]);
ylabel ('correlation coeff (Pearson)'); ylim([-0.4 0]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
set(gcf,'Position',[1 1 976 410]);

% saveas(gcf,[figSave_dir 'FL_SA_tradeoff'],'epsc')

close all

%% VS ana and figures

%dist #, t-d sim, corr only (RT)
distNums = [3 6 9 12];
VS_sim_thirds = [2/3 4/3 2];

VS_data_by_block = [Reider.allVS_data_by_block; Sindri.allVS_data_by_block; Igor.allVS_data_by_block; Bard.allVS_data_by_block];

%categorize t-dSim for each trial: 1 is high TD sim (hard), 3 is low TD sim (easy)
for sim_thirds_id=1:numel(VS_sim_thirds)
    VS_data_tdSim_ind{sim_thirds_id} = cellfun(@(x) [x(:,4) <= VS_sim_thirds(sim_thirds_id)], VS_data_by_block,'un',0);
end
VS_data_tdSim_ind = cellfun(@(x,y,z) [x+y+z], VS_data_tdSim_ind{1},VS_data_tdSim_ind{2},VS_data_tdSim_ind{3}, 'un',0);

%add categoric t-dSim to VS_data_by_block
VS_data_by_block = cellfun(@(x,y) [[x y]], VS_data_by_block, VS_data_tdSim_ind,'un',0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Speed of processing %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VS_SoP = [Reider.famil_RT; Sindri.famil_RT; Igor.famil_RT; Bard.famil_RT];

vehicle_VS_SoP = cellfun(@nanmean, VS_SoP(vehicle_days_ind,:));
drug1_VS_SoP = cellfun(@nanmean, VS_SoP(drug_1days_ind,:));
drug2_VS_SoP = cellfun(@nanmean, VS_SoP(drug_2days_ind,:));
drug3_VS_SoP = cellfun(@nanmean, VS_SoP(drug_3days_ind,:));

%stats blk1 only
VS_SoP_stats_data_blk1 = [vehicle_VS_SoP(:,1);drug1_VS_SoP(:,1);drug2_VS_SoP(:,1);drug3_VS_SoP(:,1)];
VS_SoP_stats_label = [repmat({'vehicle'},size(vehicle_VS_SoP,1),1);repmat({'lowDrug'},size(drug1_VS_SoP,1),1);...
    repmat({'medDrug'},size(drug2_VS_SoP,1),1);repmat({'highDrug'},size(drug3_VS_SoP,1),1)];
[VS_SoP_stats_blk1_p VS_SoP_stats_blk1_table VS_SoP_stats_blk1_stats] = anova1(VS_SoP_stats_data_blk1,VS_SoP_stats_label,'display','off');
% dunnett(VS_SoP_stats_stats);
mes1way(VS_SoP_stats_data_blk1,'eta2','group',(strcmp(VS_SoP_stats_label,'highDrug')*3+strcmp(VS_SoP_stats_label,'medDrug')*2+strcmp(VS_SoP_stats_label,'lowDrug')));
computeCohen_d(VS_SoP_stats_data_blk1(find(strcmp(VS_SoP_stats_label,'medDrug'))),...
    VS_SoP_stats_data_blk1(find(strcmp(VS_SoP_stats_label,'vehicle'))),'independent');

VS_SoP_stats_data_blk2 = [vehicle_VS_SoP(:,2);drug1_VS_SoP(:,2);drug2_VS_SoP(:,2);drug3_VS_SoP(:,2)];
[VS_SoP_stats_blk2_p VS_SoP_stats_blk2_table VS_SoP_stats_blk2_stats] = anova1(VS_SoP_stats_data_blk2,VS_SoP_stats_label,'display','off');
% dunnett(VS_SoP_stats_stats);
mes1way(VS_SoP_stats_data_blk2,'eta2','group',(strcmp(VS_SoP_stats_label,'highDrug')*3+strcmp(VS_SoP_stats_label,'medDrug')*2+strcmp(VS_SoP_stats_label,'lowDrug')));
computeCohen_d(VS_SoP_stats_data_blk2(find(strcmp(VS_SoP_stats_label,'medDrug'))),...
    VS_SoP_stats_data_blk2(find(strcmp(VS_SoP_stats_label,'vehicle'))),'independent');

%plot SoP
figure
hold on
errorbar(1,nanmean(vehicle_VS_SoP(:,1)),SEM_AH(vehicle_VS_SoP(:,1)),'.-','color',drug_plot_colors(1,:),'MarkerSize',20,'linestyle','none');
errorbar(2,nanmean(drug1_VS_SoP(:,1)),SEM_AH(drug1_VS_SoP(:,1)),'.-','color',drug_plot_colors(2,:),'MarkerSize',20,'linestyle','none');
errorbar(3,nanmean(drug2_VS_SoP(:,1)),SEM_AH(drug2_VS_SoP(:,1)),'.-','color',drug_plot_colors(3,:),'MarkerSize',20,'linestyle','none');
errorbar(4,nanmean(drug3_VS_SoP(:,1)),SEM_AH(drug3_VS_SoP(:,1)),'.-','color',drug_plot_colors(4,:),'MarkerSize',20,'linestyle','none');
errorbar(1.1,nanmean(vehicle_VS_SoP(:,2)),SEM_AH(vehicle_VS_SoP(:,2)),'*-','color',drug_plot_colors(1,:),'MarkerSize',20,'linestyle','none');
errorbar(2.1,nanmean(drug1_VS_SoP(:,2)),SEM_AH(drug1_VS_SoP(:,2)),'*-','color',drug_plot_colors(2,:),'MarkerSize',20,'linestyle','none');
errorbar(3.1,nanmean(drug2_VS_SoP(:,2)),SEM_AH(drug2_VS_SoP(:,2)),'*-','color',drug_plot_colors(3,:),'MarkerSize',20,'linestyle','none');
errorbar(4.1,nanmean(drug3_VS_SoP(:,2)),SEM_AH(drug3_VS_SoP(:,2)),'*-','color',drug_plot_colors(4,:),'MarkerSize',20,'linestyle','none');
xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});xlim([0.5 4.5]);
ylabel ('SoP (ms)');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
set(gcf,'Position',[1 1 560 420]);

% saveas(gcf,[figSave_dir 'VS_SoP'],'epsc')

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% RT dist num & t-d %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%correct trials only
allVS_data_by_block_corrOnlyInd = cellfun(@(x) [find(x(:,1))], VS_data_by_block, 'un',0);
allVS_data_by_block_corrOnly = cellfun(@(x,y) [x(y,:)], VS_data_by_block,allVS_data_by_block_corrOnlyInd, 'un',0);

VS_RT_by_distNum_corrOnly = cellfun (@(x) [[nanmean(x(find(x(:,3) == 3),2)),nanmean(x(find(x(:,3) == 6),2)),nanmean(x(find(x(:,3) == 9),2)),nanmean(x(find(x(:,3) == 12),2))]], allVS_data_by_block_corrOnly,'un',0);
VS_RT_by_tdSim_corrOnly = cellfun (@(x) [[nanmean(x(find(x(:,5) == 3),2)),nanmean(x(find(x(:,5) == 2),2)),nanmean(x(find(x(:,5) == 1),2))]], allVS_data_by_block_corrOnly,'un',0);

% %error trials only
% allVS_data_by_block_errOnlyInd = cellfun(@(x) [find(~x(:,1))], VS_data_by_block, 'un',0);
% allVS_data_by_block_errOnly = cellfun(@(x,y) [x(y,:)], VS_data_by_block,allVS_data_by_block_errOnlyInd, 'un',0);
%
% VS_RT_by_distNum_errOnly = cellfun (@(x) [[nanmean(x(find(x(:,3) == 3),2)),nanmean(x(find(x(:,3) == 6),2)),nanmean(x(find(x(:,3) == 9),2)),nanmean(x(find(x(:,3) == 12),2))]], allVS_data_by_block_errOnly,'un',0);
% VS_RT_by_tdSim_errOnly = cellfun (@(x) [[nanmean(x(find(x(:,5) == 1),2)),nanmean(x(find(x(:,5) == 2),2)),nanmean(x(find(x(:,5) == 3),2))]], allVS_data_by_block_errOnly,'un',0);

vehicle_VS_RT_by_distNum_corrOnly_blk1 = cell2mat(VS_RT_by_distNum_corrOnly(vehicle_days_ind,1));
drug1_VS_RT_by_distNum_corrOnly_blk1 = cell2mat(VS_RT_by_distNum_corrOnly(drug_1days_ind,1));
drug2_VS_RT_by_distNum_corrOnly_blk1 = cell2mat(VS_RT_by_distNum_corrOnly(drug_2days_ind,1));
drug3_VS_RT_by_distNum_corrOnly_blk1 = cell2mat(VS_RT_by_distNum_corrOnly(drug_3days_ind,1));
vehicle_VS_RT_by_distNum_corrOnly_blk2 = cell2mat(VS_RT_by_distNum_corrOnly(vehicle_days_ind,2));
drug1_VS_RT_by_distNum_corrOnly_blk2 = cell2mat(VS_RT_by_distNum_corrOnly(drug_1days_ind,2));
drug2_VS_RT_by_distNum_corrOnly_blk2 = cell2mat(VS_RT_by_distNum_corrOnly(drug_2days_ind,2));
drug3_VS_RT_by_distNum_corrOnly_blk2 = cell2mat(VS_RT_by_distNum_corrOnly(drug_3days_ind,2));

vehicle_VS_RT_by_tdSim_corrOnly_blk1 = cell2mat(VS_RT_by_tdSim_corrOnly(vehicle_days_ind,1));
drug1_VS_RT_by_tdSim_corrOnly_blk1 = cell2mat(VS_RT_by_tdSim_corrOnly(drug_1days_ind,1));
drug2_VS_RT_by_tdSim_corrOnly_blk1 = cell2mat(VS_RT_by_tdSim_corrOnly(drug_2days_ind,1));
drug3_VS_RT_by_tdSim_corrOnly_blk1 = cell2mat(VS_RT_by_tdSim_corrOnly(drug_3days_ind,1));
vehicle_VS_RT_by_tdSim_corrOnly_blk2 = cell2mat(VS_RT_by_tdSim_corrOnly(vehicle_days_ind,2));
drug1_VS_RT_by_tdSim_corrOnly_blk2 = cell2mat(VS_RT_by_tdSim_corrOnly(drug_1days_ind,2));
drug2_VS_RT_by_tdSim_corrOnly_blk2 = cell2mat(VS_RT_by_tdSim_corrOnly(drug_2days_ind,2));
drug3_VS_RT_by_tdSim_corrOnly_blk2 = cell2mat(VS_RT_by_tdSim_corrOnly(drug_3days_ind,2));

%stats for each block seperately
VS_RT_by_distNum_blk1Stats_data = [vehicle_VS_RT_by_distNum_corrOnly_blk1; drug1_VS_RT_by_distNum_corrOnly_blk1; drug2_VS_RT_by_distNum_corrOnly_blk1; drug3_VS_RT_by_distNum_corrOnly_blk1];
VS_RT_by_distNum_Stats_condLabel = [repmat({'vehicle'},size(vehicle_VS_RT_by_distNum_corrOnly_blk1));repmat({'lowDrug'},size(drug1_VS_RT_by_distNum_corrOnly_blk1));...
    repmat({'medDrug'},size(drug2_VS_RT_by_distNum_corrOnly_blk1));repmat({'highDrug'},size(drug3_VS_RT_by_distNum_corrOnly_blk1))];
VS_RT_by_distNum_Stats_distNumLabel = [repmat({'3dist'},size(VS_RT_by_distNum_blk1Stats_data,1),1),repmat({'6dist'},size(VS_RT_by_distNum_blk1Stats_data,1),1),...
    repmat({'9dist'},size(VS_RT_by_distNum_blk1Stats_data,1),1),repmat({'12dist'},size(VS_RT_by_distNum_blk1Stats_data,1),1)];
[VS_RT_by_distNum_blk1Stats_p,VS_RT_by_distNum_blk1Stats_table,VS_RT_by_distNum_blk1Stats] = anovan(VS_RT_by_distNum_blk1Stats_data(:),{VS_RT_by_distNum_Stats_distNumLabel(:),VS_RT_by_distNum_Stats_condLabel(:)},'model','interaction','varnames',{'distNum','cond'},'display','off');
% multcompare(VS_RT_by_distNum_blk1Stats,'dimension',2)
%effect size
effectSizeGrouptmp1 = repmat(0:3,size(VS_RT_by_distNum_Stats_distNumLabel,1),1);
effectSizeGrouptmp2 = (strcmp(VS_RT_by_distNum_Stats_condLabel,'highDrug')*3+strcmp(VS_RT_by_distNum_Stats_condLabel,'medDrug')*2+strcmp(VS_RT_by_distNum_Stats_condLabel,'lowDrug'));
effectSizeGrouptmp = [effectSizeGrouptmp1(:) effectSizeGrouptmp2(:)];
mes2way(VS_RT_by_distNum_blk1Stats_data(:),effectSizeGrouptmp,'eta2','fName',{'Load','Cond'});
computeCohen_d(VS_RT_by_distNum_blk1Stats_data(find(strcmp(VS_RT_by_distNum_Stats_condLabel(:,1),'medDrug')),1),...
    VS_RT_by_distNum_blk1Stats_data(find(strcmp(VS_RT_by_distNum_Stats_condLabel(:,1),'vehicle')),1),'independent');
computeCohen_d(VS_RT_by_distNum_blk1Stats_data(find(strcmp(VS_RT_by_distNum_Stats_condLabel(:,4),'medDrug')),4),...
    VS_RT_by_distNum_blk1Stats_data(find(strcmp(VS_RT_by_distNum_Stats_condLabel(:,4),'vehicle')),4),'independent');

VS_RT_by_distNum_blk2Stats_data = [vehicle_VS_RT_by_distNum_corrOnly_blk2; drug1_VS_RT_by_distNum_corrOnly_blk2; drug2_VS_RT_by_distNum_corrOnly_blk2; drug3_VS_RT_by_distNum_corrOnly_blk2];
[VS_RT_by_distNum_blk2Stats_p,VS_RT_by_distNum_blk2Stats_table,VS_RT_by_distNum_blk2Stats] = anovan(VS_RT_by_distNum_blk2Stats_data(:),{VS_RT_by_distNum_Stats_distNumLabel(:),VS_RT_by_distNum_Stats_condLabel(:)},'model','interaction','varnames',{'distNum','cond'},'display','off');
% multcompare(VS_RT_by_distNum_blk2Stats,'dimension',2)
%effect size
mes2way(VS_RT_by_distNum_blk2Stats_data(:),effectSizeGrouptmp,'eta2','fName',{'Load','Cond'});
computeCohen_d(VS_RT_by_distNum_blk2Stats_data(find(strcmp(VS_RT_by_distNum_Stats_condLabel(:,1),'medDrug')),1),...
    VS_RT_by_distNum_blk2Stats_data(find(strcmp(VS_RT_by_distNum_Stats_condLabel(:,1),'vehicle')),1),'independent');
computeCohen_d(VS_RT_by_distNum_blk2Stats_data(find(strcmp(VS_RT_by_distNum_Stats_condLabel(:,4),'medDrug')),4),...
    VS_RT_by_distNum_blk2Stats_data(find(strcmp(VS_RT_by_distNum_Stats_condLabel(:,4),'vehicle')),4),'independent');

VS_RT_by_tdSim_blk1Stats_data = [vehicle_VS_RT_by_tdSim_corrOnly_blk1; drug1_VS_RT_by_tdSim_corrOnly_blk1; drug2_VS_RT_by_tdSim_corrOnly_blk1; drug3_VS_RT_by_tdSim_corrOnly_blk1];
VS_RT_by_tdSim_Stats_condLabel = [repmat({'vehicle'},size(vehicle_VS_RT_by_tdSim_corrOnly_blk1));repmat({'lowDrug'},size(drug1_VS_RT_by_tdSim_corrOnly_blk1));...
    repmat({'medDrug'},size(drug2_VS_RT_by_tdSim_corrOnly_blk1));repmat({'highDrug'},size(drug3_VS_RT_by_tdSim_corrOnly_blk1))];
VS_RT_by_tdSim_Stats_tdSimLabel = [repmat({'lowTD'},size(VS_RT_by_tdSim_blk1Stats_data,1),1),repmat({'medTD'},size(VS_RT_by_tdSim_blk1Stats_data,1),1),...
    repmat({'highTD'},size(VS_RT_by_tdSim_blk1Stats_data,1),1)];
[VS_RT_by_tdSim_blk1Stats_p,VS_RT_by_tdSim_blk1Stats_table,VS_RT_by_tdSim_blk1Stats] = anovan(VS_RT_by_tdSim_blk1Stats_data(:),{VS_RT_by_tdSim_Stats_tdSimLabel(:),VS_RT_by_tdSim_Stats_condLabel(:)},'model','interaction','varnames',{'tdSim','cond'},'display','off');
% multcompare(VS_RT_by_tdSim_blk1Stats,'dimension',2)
%effect size
effectSizeGrouptmp1 = repmat(0:2,size(VS_RT_by_tdSim_Stats_tdSimLabel,1),1);
effectSizeGrouptmp2 = (strcmp(VS_RT_by_tdSim_Stats_condLabel,'highDrug')*3+strcmp(VS_RT_by_tdSim_Stats_condLabel,'medDrug')*2+strcmp(VS_RT_by_tdSim_Stats_condLabel,'lowDrug'));
effectSizeGrouptmp = [effectSizeGrouptmp1(:) effectSizeGrouptmp2(:)];
mes2way(VS_RT_by_tdSim_blk1Stats_data(:),effectSizeGrouptmp,'eta2','fName',{'Load','Cond'});
computeCohen_d(VS_RT_by_tdSim_blk1Stats_data(find(strcmp(VS_RT_by_tdSim_Stats_condLabel(:,1),'medDrug')),1),...
    VS_RT_by_tdSim_blk1Stats_data(find(strcmp(VS_RT_by_tdSim_Stats_condLabel(:,1),'vehicle')),1),'independent');
computeCohen_d(VS_RT_by_tdSim_blk1Stats_data(find(strcmp(VS_RT_by_tdSim_Stats_condLabel(:,3),'medDrug')),3),...
    VS_RT_by_tdSim_blk1Stats_data(find(strcmp(VS_RT_by_tdSim_Stats_condLabel(:,3),'vehicle')),3),'independent');

VS_RT_by_tdSim_blk2Stats_data = [vehicle_VS_RT_by_tdSim_corrOnly_blk2; drug1_VS_RT_by_tdSim_corrOnly_blk2; drug2_VS_RT_by_tdSim_corrOnly_blk2; drug3_VS_RT_by_tdSim_corrOnly_blk2];
[VS_RT_by_tdSim_blk2Stats_p,VS_RT_by_tdSim_blk2Stats_table,VS_RT_by_tdSim_blk2Stats] = anovan(VS_RT_by_tdSim_blk2Stats_data(:),{VS_RT_by_tdSim_Stats_tdSimLabel(:),VS_RT_by_tdSim_Stats_condLabel(:)},'model','interaction','varnames',{'tdSim','cond'},'display','off');
% multcompare(VS_RT_by_tdSim_blk2Stats,'dimension',2)
%effect size
effectSizeGrouptmp = [effectSizeGrouptmp1(:) effectSizeGrouptmp2(:)];
mes2way(VS_RT_by_tdSim_blk2Stats_data(:),effectSizeGrouptmp,'eta2','fName',{'Load','Cond'});
computeCohen_d(VS_RT_by_tdSim_blk2Stats_data(find(strcmp(VS_RT_by_tdSim_Stats_condLabel(:,1),'medDrug')),1),...
    VS_RT_by_tdSim_blk2Stats_data(find(strcmp(VS_RT_by_tdSim_Stats_condLabel(:,1),'vehicle')),1),'independent');
computeCohen_d(VS_RT_by_tdSim_blk2Stats_data(find(strcmp(VS_RT_by_tdSim_Stats_condLabel(:,3),'medDrug')),3),...
    VS_RT_by_tdSim_blk2Stats_data(find(strcmp(VS_RT_by_tdSim_Stats_condLabel(:,3),'vehicle')),3),'independent');

%plot RT by distNum and tdSim
figure
subplot(2,2,1)
hold on
errorbar(2.9:3:11.9,nanmean(vehicle_VS_RT_by_distNum_corrOnly_blk1),cellfun(@SEM_AH, num2cell(vehicle_VS_RT_by_distNum_corrOnly_blk1,1)),'.-','color',drug_plot_colors(1,:),'MarkerSize',20,'Linewidth',1);
errorbar(3:3:12,nanmean(drug1_VS_RT_by_distNum_corrOnly_blk1),cellfun(@SEM_AH, num2cell(drug1_VS_RT_by_distNum_corrOnly_blk1,1)),'.-','color',drug_plot_colors(2,:),'MarkerSize',20,'Linewidth',1);
errorbar(3.1:3:12.1,nanmean(drug2_VS_RT_by_distNum_corrOnly_blk1),cellfun(@SEM_AH, num2cell(drug2_VS_RT_by_distNum_corrOnly_blk1,1)),'.-','color',drug_plot_colors(3,:),'MarkerSize',20,'Linewidth',1);
errorbar(3.2:3:12.2,nanmean(drug3_VS_RT_by_distNum_corrOnly_blk1),cellfun(@SEM_AH, num2cell(drug3_VS_RT_by_distNum_corrOnly_blk1,1)),'.-','color',drug_plot_colors(4,:),'MarkerSize',20,'Linewidth',1);
xticks(3:3:12); xlim([2.5 12.5]); xlabel('dist. number'); ylabel ('RT');ylim([1 1.8]);
legend({'vehicle','VU595 0.3','VU595 1','VU595 3'},'Location','southeast');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(2,2,2)
hold on
errorbar(2.9:3:11.9,nanmean(vehicle_VS_RT_by_distNum_corrOnly_blk2),cellfun(@SEM_AH, num2cell(vehicle_VS_RT_by_distNum_corrOnly_blk2,1)),'.--','color',drug_plot_colors(1,:),'MarkerSize',20,'Linewidth',1);
errorbar(3:3:12,nanmean(drug1_VS_RT_by_distNum_corrOnly_blk2),cellfun(@SEM_AH, num2cell(drug1_VS_RT_by_distNum_corrOnly_blk2,1)),'.--','color',drug_plot_colors(2,:),'MarkerSize',20,'Linewidth',1);
errorbar(3.1:3:12.1,nanmean(drug2_VS_RT_by_distNum_corrOnly_blk2),cellfun(@SEM_AH, num2cell(drug2_VS_RT_by_distNum_corrOnly_blk2,1)),'.--','color',drug_plot_colors(3,:),'MarkerSize',20,'Linewidth',1);
errorbar(3.2:3:12.2,nanmean(drug3_VS_RT_by_distNum_corrOnly_blk2),cellfun(@SEM_AH, num2cell(drug3_VS_RT_by_distNum_corrOnly_blk2,1)),'.--','color',drug_plot_colors(4,:),'MarkerSize',20,'Linewidth',1);
xticks(3:3:12); xlim([2.5 12.5]); xlabel('dist. number'); ylabel ('RT');ylim([1 1.8]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(2,2,3)
hold on
errorbar(0.95:1:2.95,nanmean(vehicle_VS_RT_by_tdSim_corrOnly_blk1),cellfun(@SEM_AH, num2cell(vehicle_VS_RT_by_tdSim_corrOnly_blk1,1)),'.-','color',drug_plot_colors(1,:),'MarkerSize',20,'Linewidth',1);
errorbar(1:3,nanmean(drug1_VS_RT_by_tdSim_corrOnly_blk1),cellfun(@SEM_AH, num2cell(drug1_VS_RT_by_tdSim_corrOnly_blk1,1)),'.-','color',drug_plot_colors(2,:),'MarkerSize',20,'Linewidth',1);
errorbar(1.05:1:3.05,nanmean(drug2_VS_RT_by_tdSim_corrOnly_blk1),cellfun(@SEM_AH, num2cell(drug2_VS_RT_by_tdSim_corrOnly_blk1,1)),'.-','color',drug_plot_colors(3,:),'MarkerSize',20,'Linewidth',1);
errorbar(1.1:1:3.1,nanmean(drug3_VS_RT_by_tdSim_corrOnly_blk1),cellfun(@SEM_AH, num2cell(drug3_VS_RT_by_tdSim_corrOnly_blk1,1)),'.-','color',drug_plot_colors(4,:),'MarkerSize',20,'Linewidth',1);
xticks(1:3); xticklabels({'low TD sim','mid TD sim','high TD sim'}); xlim([0.5 3.5]); ylabel ('RT');ylim([1 1.8]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(2,2,4)
hold on
errorbar(0.95:1:2.95,nanmean(vehicle_VS_RT_by_tdSim_corrOnly_blk2),cellfun(@SEM_AH, num2cell(vehicle_VS_RT_by_tdSim_corrOnly_blk2,1)),'.--','color',drug_plot_colors(1,:),'MarkerSize',20,'Linewidth',1);
errorbar(1:3,nanmean(drug1_VS_RT_by_tdSim_corrOnly_blk2),cellfun(@SEM_AH, num2cell(drug1_VS_RT_by_tdSim_corrOnly_blk2,1)),'.--','color',drug_plot_colors(2,:),'MarkerSize',20,'Linewidth',1);
errorbar(1.05:1:3.05,nanmean(drug2_VS_RT_by_tdSim_corrOnly_blk2),cellfun(@SEM_AH, num2cell(drug2_VS_RT_by_tdSim_corrOnly_blk2,1)),'.--','color',drug_plot_colors(3,:),'MarkerSize',20,'Linewidth',1);
errorbar(1.1:1:3.1,nanmean(drug3_VS_RT_by_tdSim_corrOnly_blk2),cellfun(@SEM_AH, num2cell(drug3_VS_RT_by_tdSim_corrOnly_blk2,1)),'.--','color',drug_plot_colors(4,:),'MarkerSize',20,'Linewidth',1);
xticks(1:3); xticklabels({'low TD sim','mid TD sim','high TD sim'}); xlim([0.5 3.5]); ylabel ('RT');ylim([1 1.8]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
set(gcf,'Position',[1 1 767 629]);

% saveas(gcf,[figSave_dir 'VS_RT_distNum_tdSim'],'epsc')

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% RT slope %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VS_RTslope_sepBlks = [Reider.RTslope_sepBlks, Sindri.RTslope_sepBlks, Igor.RTslope_sepBlks, Bard.RTslope_sepBlks];

% individual monkey temporal progress (VU595)

Reider_RTslope = [nanmean(Reider.RTslope_sepBlks(:,find(Reider.drug_1days_ind)),2)-nanmean(Reider.RTslope_sepBlks(:,Reider_vehicleDays),2),...
    nanmean(Reider.RTslope_sepBlks(:,find(Reider.drug_2days_ind)),2)-nanmean(Reider.RTslope_sepBlks(:,Reider_vehicleDays),2),...
    nanmean(Reider.RTslope_sepBlks(:,find(Reider.drug_2days_ind)),2)-nanmean(Reider.RTslope_sepBlks(:,Reider_vehicleDays),2)];
Sindri_RTslope = [nanmean(Sindri.RTslope_sepBlks(:,find(Sindri.drug_1days_ind)),2)-nanmean(Sindri.RTslope_sepBlks(:,Sindri_vehicleDays),2),...
    nanmean(Sindri.RTslope_sepBlks(:,find(Sindri.drug_2days_ind)),2)-nanmean(Sindri.RTslope_sepBlks(:,Sindri_vehicleDays),2),...
    nanmean(Sindri.RTslope_sepBlks(:,find(Sindri.drug_2days_ind)),2)-nanmean(Sindri.RTslope_sepBlks(:,Sindri_vehicleDays),2)];
Igor_RTslope = [nanmean(Igor.RTslope_sepBlks(:,find(Igor.drug_1days_ind)),2)-nanmean(Igor.RTslope_sepBlks(:,Igor_vehicleDays),2),...
    nanmean(Igor.RTslope_sepBlks(:,find(Igor.drug_2days_ind)),2)-nanmean(Igor.RTslope_sepBlks(:,Igor_vehicleDays),2),...
    nanmean(Igor.RTslope_sepBlks(:,find(Igor.drug_2days_ind)),2)-nanmean(Igor.RTslope_sepBlks(:,Igor_vehicleDays),2)];
Bard_RTslope = [nanmean(Bard.RTslope_sepBlks(:,find(Bard.drug_1days_ind)),2)-nanmean(Bard.RTslope_sepBlks(:,Bard_vehicleDays),2),...
    nanmean(Bard.RTslope_sepBlks(:,find(Bard.drug_2days_ind)),2)-nanmean(Bard.RTslope_sepBlks(:,Bard_vehicleDays),2),...
    nanmean(Bard.RTslope_sepBlks(:,find(Bard.drug_2days_ind)),2)-nanmean(Bard.RTslope_sepBlks(:,Bard_vehicleDays),2)];

% prep
vehicle_VS_RTslope_sepBlks = VS_RTslope_sepBlks(:,vehicle_days_ind);
drug1_VS_RTslope_sepBlks = VS_RTslope_sepBlks(:,drug_1days_ind);
drug2_VS_RTslope_sepBlks = VS_RTslope_sepBlks(:,drug_2days_ind);
drug3_VS_RTslope_sepBlks = VS_RTslope_sepBlks(:,drug_3days_ind);

%stats
VS_RTslope_stats_data = [vehicle_VS_RTslope_sepBlks, drug1_VS_RTslope_sepBlks, drug2_VS_RTslope_sepBlks, drug3_VS_RTslope_sepBlks];
VS_RTslope_stats_condLabel = [repmat({'vehicle'}, size(vehicle_VS_RTslope_sepBlks)),repmat({'lowDrug'}, size(drug1_VS_RTslope_sepBlks)),...
    repmat({'medDrug'}, size(drug2_VS_RTslope_sepBlks)),repmat({'highDrug'}, size(drug3_VS_RTslope_sepBlks))];
[VS_RTslope_stats_blk1_p VS_RTslope_stats_blk1_table VS_RTslope_stats_blk1] = anova1 (VS_RTslope_stats_data(1,:),VS_RTslope_stats_condLabel(1,:),'display','off');
% multcompare(VS_RTslope_stats_blk1)
mes1way(VS_RTslope_stats_data(1,:)','eta2','group',(strcmp(VS_RTslope_stats_condLabel(1,:),'highDrug')*3+strcmp(VS_RTslope_stats_condLabel(1,:),'medDrug')*2+strcmp(VS_RTslope_stats_condLabel(1,:),'lowDrug'))');
computeCohen_d(VS_RTslope_stats_data(1,find(strcmp(VS_RTslope_stats_condLabel(1,:),'medDrug'))),...
    VS_RTslope_stats_data(1,find(strcmp(VS_RTslope_stats_condLabel(1,:),'vehicle'))),'independent');

[VS_RTslope_stats_blk2_p VS_RTslope_stats_blk2_table VS_RTslope_stats_blk2] = anova1 (VS_RTslope_stats_data(2,:),VS_RTslope_stats_condLabel(2,:),'display','off');
% multcompare(VS_RTslope_stats_blk2)
mes1way(VS_RTslope_stats_data(2,:)','eta2','group',(strcmp(VS_RTslope_stats_condLabel(2,:),'highDrug')*3+strcmp(VS_RTslope_stats_condLabel(2,:),'medDrug')*2+strcmp(VS_RTslope_stats_condLabel(2,:),'lowDrug'))');
computeCohen_d(VS_RTslope_stats_data(2,find(strcmp(VS_RTslope_stats_condLabel(2,:),'medDrug'))),...
    VS_RTslope_stats_data(2,find(strcmp(VS_RTslope_stats_condLabel(2,:),'vehicle'))),'independent');

for islope = 1:size(vehicle_VS_RT_by_tdSim_corrOnly_blk2,1)
    [vehicle_RT_tdSlope(islope,:)]= polyfit ([1/3 1 5/3], vehicle_VS_RT_by_tdSim_corrOnly_blk2(islope,:),1);
end
for islope = 1:size(drug1_VS_RT_by_tdSim_corrOnly_blk2,1)
    [drug1_RT_tdSlope(islope,:)]= polyfit ([1/3 1 5/3], drug1_VS_RT_by_tdSim_corrOnly_blk2(islope,:),1);
end
for islope = 1:size(drug2_VS_RT_by_tdSim_corrOnly_blk2,1)
    [drug2_RT_tdSlope(islope,:)]= polyfit ([1/3 1 5/3], drug2_VS_RT_by_tdSim_corrOnly_blk2(islope,:),1);
end
for islope = 1:size(drug3_VS_RT_by_tdSim_corrOnly_blk2,1)
    [drug3_RT_tdSlope(islope,:)]= polyfit ([1/3 1 5/3], drug3_VS_RT_by_tdSim_corrOnly_blk2(islope,:),1);
end

VS_RT_corrOnly_tdSlope_stats_data = [vehicle_RT_tdSlope;drug1_RT_tdSlope;drug2_RT_tdSlope;drug3_RT_tdSlope];
VS_perfSlope_stats_condLabel = [repmat({'vehicle'}, size(vehicle_RT_tdSlope));repmat({'lowDrug'}, size(drug1_RT_tdSlope));...
    repmat({'medDrug'}, size(drug2_RT_tdSlope));repmat({'highDrug'}, size(drug3_RT_tdSlope))];
[VS_RT_tdSlope_stats_blk2_p VS_RT_tdSlope_stats_blk2_table VS_RT_tdSlope_stats_blk2] = anova1 (VS_RT_corrOnly_tdSlope_stats_data(:,2),VS_perfSlope_stats_condLabel(:,2),'display','off');
% multcompare(VS_RT_tdSlope_stats_blk2)
mes1way(VS_RT_corrOnly_tdSlope_stats_data(:,2),'eta2','group',(strcmp(VS_perfSlope_stats_condLabel(:,2),'highDrug')*3+strcmp(VS_perfSlope_stats_condLabel(:,2),'medDrug')*2+strcmp(VS_perfSlope_stats_condLabel(:,2),'lowDrug')));
computeCohen_d(VS_RT_corrOnly_tdSlope_stats_data(find(strcmp(VS_perfSlope_stats_condLabel(:,1),'medDrug')),1),...
    VS_RT_corrOnly_tdSlope_stats_data(find(strcmp(VS_perfSlope_stats_condLabel(:,1),'vehicle')),1),'independent');

[VS_RT_tdSlope_stats_blk1_p VS_RT_tdSlope_stats_blk1_table VS_RT_tdSlope_stats_blk1] = anova1 (VS_RT_corrOnly_tdSlope_stats_data(:,1),VS_perfSlope_stats_condLabel(:,1),'display','off');

%plot RT slope changes
figure
hold on
errorbar(1:4,[nanmean(vehicle_VS_RTslope_sepBlks(2,:)) nanmean(drug1_VS_RTslope_sepBlks(2,:)) nanmean(drug2_VS_RTslope_sepBlks(2,:)) nanmean(drug3_VS_RTslope_sepBlks(2,:))],...
    [SEM_AH(vehicle_VS_RTslope_sepBlks(2,:)) SEM_AH(drug1_VS_RTslope_sepBlks(2,:)) SEM_AH(drug2_VS_RTslope_sepBlks(2,:)) SEM_AH(drug3_VS_RTslope_sepBlks(2,:))],...
    'k.-','MarkerSize',40,'Linewidth',3);
xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});xlim([0.5 4.5]);
ylabel ('Avg. slope'); title('RT (by Dist Num) slope changes');%ylim([0 0.075]); 
set(gca,'tickdir','out');ax = gca; ax.FontSize = 20;
set(gcf,'Position',[1 1 560 420]);

% saveas(gcf,[figSave_dir 'VS_RTdistNum_slope'],'epsc')

figure
hold on
errorbar(1:4,[nanmean(vehicle_RT_tdSlope(:,2)) nanmean(drug1_RT_tdSlope(:,2)) nanmean(drug2_RT_tdSlope(:,2)) nanmean(drug3_RT_tdSlope(:,2))],...
    [SEM_AH(vehicle_RT_tdSlope(:,2)) SEM_AH(drug1_RT_tdSlope(:,2)) SEM_AH(drug2_RT_tdSlope(:,2)) SEM_AH(drug3_RT_tdSlope(:,2))],...
    'k.-','MarkerSize',40,'Linewidth',3);
xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3','VU595 1','VU595 3'});xlim([0.5 4.5]);
ylabel ('Avg. slope'); title('RT (by TDsim) slope changes');%ylim([-0.16 0]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 20;
set(gcf,'Position',[1 1 560 420]);

% saveas(gcf,[figSave_dir 'VS_RTtdSim_slope'],'epsc')


% % individual monkey temporal progress plot (VU595)
% 
% figure
% subplot(2,1,1)
% hold on
% title('blk 1');
% scatter(Reider_RTslope(1,:),1:3,64,'r','filled');
% scatter(Sindri_RTslope(1,:),0.95:1:2.95,64,'g','filled');
% scatter(Igor_RTslope(1,:),0.9:1:2.9,64,'b','filled');
% scatter(Bard_RTslope(1,:),1.05:1:3.05,64,'c','filled');
% xlabel('RT slope (diff.)');yticks(1:3);yticklabels({'0.3 mg/kg','1 mg/kg', '3 mg/kg'});
% xline(0);ylim([0.5 3.5]);
% % legend({'monkey Re','monkey Si','monkey Ig','monkey Ba'},'location','nw')
% set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
% 
% subplot(2,1,2)
% hold on
% title('blk 2');
% scatter(Reider_RTslope(2,:),1:3,64,'r','filled');
% scatter(Sindri_RTslope(2,:),0.95:1:2.95,64,'g','filled');
% scatter(Igor_RTslope(2,:),0.9:1:2.9,64,'b','filled');
% scatter(Bard_RTslope(2,:),1.05:1:3.05,64,'c','filled');
% xlabel('RT slope  (diff.)');yticks(1:3);yticklabels({'0.3 mg/kg','1 mg/kg', '3 mg/kg'});
% xline(0);ylim([0.5 3.5]);
% set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
% set(gcf,'Position',[1 1 709 483]);
% 
% % saveas(gcf,[figSave_dir 'monkeyTemporal_RTslope'],'epsc')
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Perf dist num & t-d %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VS_perf_by_distNum = cellfun (@(x) [[nanmean(x(find(x(:,3) == 3),1)),nanmean(x(find(x(:,3) == 6),1)),nanmean(x(find(x(:,3) == 9),1)),nanmean(x(find(x(:,3) == 12),1))]], VS_data_by_block,'un',0);
VS_perf_by_tdSim = cellfun (@(x) [[nanmean(x(find(x(:,5) == 3),1)),nanmean(x(find(x(:,5) == 2),1)),nanmean(x(find(x(:,5) == 1),1))]], VS_data_by_block,'un',0);

vehicle_VS_perf_by_distNum_blk1 = cell2mat(VS_perf_by_distNum(vehicle_days_ind,1));
drug1_VS_perf_by_distNum_blk1 = cell2mat(VS_perf_by_distNum(drug_1days_ind,1));
drug2_VS_perf_by_distNum_blk1 = cell2mat(VS_perf_by_distNum(drug_2days_ind,1));
drug3_VS_perf_by_distNum_blk1 = cell2mat(VS_perf_by_distNum(drug_3days_ind,1));
vehicle_VS_perf_by_distNum_blk2 = cell2mat(VS_perf_by_distNum(vehicle_days_ind,2));
drug1_VS_perf_by_distNum_blk2 = cell2mat(VS_perf_by_distNum(drug_1days_ind,2));
drug2_VS_perf_by_distNum_blk2 = cell2mat(VS_perf_by_distNum(drug_2days_ind,2));
drug3_VS_perf_by_distNum_blk2 = cell2mat(VS_perf_by_distNum(drug_3days_ind,2));

vehicle_VS_perf_by_tdSim_blk1 = cell2mat(VS_perf_by_tdSim(vehicle_days_ind,1));
drug1_VS_perf_by_tdSim_blk1 = cell2mat(VS_perf_by_tdSim(drug_1days_ind,1));
drug2_VS_perf_by_tdSim_blk1 = cell2mat(VS_perf_by_tdSim(drug_2days_ind,1));
drug3_VS_perf_by_tdSim_blk1 = cell2mat(VS_perf_by_tdSim(drug_3days_ind,1));
vehicle_VS_perf_by_tdSim_blk2 = cell2mat(VS_perf_by_tdSim(vehicle_days_ind,2));
drug1_VS_perf_by_tdSim_blk2 = cell2mat(VS_perf_by_tdSim(drug_1days_ind,2));
drug2_VS_perf_by_tdSim_blk2 = cell2mat(VS_perf_by_tdSim(drug_2days_ind,2));
drug3_VS_perf_by_tdSim_blk2 = cell2mat(VS_perf_by_tdSim(drug_3days_ind,2));

% indiv_monkey_test.m: shows individual monkeys

%stats for each block seperately
VS_perf_by_distNum_blk1Stats_data = [vehicle_VS_perf_by_distNum_blk1; drug1_VS_perf_by_distNum_blk1; drug2_VS_perf_by_distNum_blk1; drug3_VS_perf_by_distNum_blk1];
VS_perf_by_distNum_Stats_condLabel = [repmat({'vehicle'},size(vehicle_VS_perf_by_distNum_blk1));repmat({'lowDrug'},size(drug1_VS_perf_by_distNum_blk1));...
    repmat({'medDrug'},size(drug2_VS_perf_by_distNum_blk1));repmat({'highDrug'},size(drug3_VS_perf_by_distNum_blk1))];
VS_perf_by_distNum_Stats_distNumLabel = [repmat({'3dist'},size(VS_perf_by_distNum_blk1Stats_data,1),1),repmat({'6dist'},size(VS_perf_by_distNum_blk1Stats_data,1),1),...
    repmat({'9dist'},size(VS_perf_by_distNum_blk1Stats_data,1),1),repmat({'12dist'},size(VS_perf_by_distNum_blk1Stats_data,1),1)];
[VS_perf_by_distNum_blk1Stats_p,VS_perf_by_distNum_blk1Stats_table,VS_perf_by_distNum_blk1Stats] = anovan(VS_perf_by_distNum_blk1Stats_data(:),{VS_perf_by_distNum_Stats_distNumLabel(:),VS_perf_by_distNum_Stats_condLabel(:)},'model','interaction','varnames',{'distNum','cond'},'display','off');
% multcompare(VS_perf_by_distNum_blk1Stats,'dimension',2)
%effect size
effectSizeGrouptmp1 = repmat(0:3,size(VS_perf_by_distNum_Stats_distNumLabel,1),1);
effectSizeGrouptmp2 = (strcmp(VS_perf_by_distNum_Stats_condLabel,'highDrug')*3+strcmp(VS_perf_by_distNum_Stats_condLabel,'medDrug')*2+strcmp(VS_perf_by_distNum_Stats_condLabel,'lowDrug'));
effectSizeGrouptmp = [effectSizeGrouptmp1(:) effectSizeGrouptmp2(:)];
mes2way(VS_perf_by_distNum_blk1Stats_data(:),effectSizeGrouptmp,'eta2','fName',{'Load','Cond'});

VS_perf_by_distNum_blk2Stats_data = [vehicle_VS_perf_by_distNum_blk2; drug1_VS_perf_by_distNum_blk2; drug2_VS_perf_by_distNum_blk2; drug3_VS_perf_by_distNum_blk2];
[VS_perf_by_distNum_blk2Stats_p,VS_perf_by_distNum_blk2Stats_table,VS_perf_by_distNum_blk2Stats] = anovan(VS_perf_by_distNum_blk2Stats_data(:),{VS_perf_by_distNum_Stats_distNumLabel(:),VS_perf_by_distNum_Stats_condLabel(:)},'model','interaction','varnames',{'distNum','cond'},'display','off');
% multcompare(VS_perf_by_distNum_blk2Stats,'dimension',2)
%effect size
effectSizeGrouptmp = [effectSizeGrouptmp1(:) effectSizeGrouptmp2(:)];
mes2way(VS_perf_by_distNum_blk2Stats_data(:),effectSizeGrouptmp,'eta2','fName',{'Load','Cond'});

VS_perf_by_tdSim_blk1Stats_data = [vehicle_VS_perf_by_tdSim_blk1; drug1_VS_perf_by_tdSim_blk1; drug2_VS_perf_by_tdSim_blk1; drug3_VS_perf_by_tdSim_blk1];
VS_perf_by_tdSim_Stats_condLabel = [repmat({'vehicle'},size(vehicle_VS_perf_by_tdSim_blk1));repmat({'lowDrug'},size(drug1_VS_perf_by_tdSim_blk1));...
    repmat({'medDrug'},size(drug2_VS_perf_by_tdSim_blk1));repmat({'highDrug'},size(drug3_VS_perf_by_tdSim_blk1))];
VS_perf_by_tdSim_Stats_tdSimLabel = [repmat({'lowTD'},size(VS_perf_by_tdSim_blk1Stats_data,1),1),repmat({'medTD'},size(VS_perf_by_tdSim_blk1Stats_data,1),1),...
    repmat({'highTD'},size(VS_perf_by_tdSim_blk1Stats_data,1),1)];
[VS_perf_by_tdSim_blk1Stats_p,VS_perf_by_tdSim_blk1Stats_table,VS_perf_by_tdSim_blk1Stats] = anovan(VS_perf_by_tdSim_blk1Stats_data(:),{VS_perf_by_tdSim_Stats_tdSimLabel(:),VS_perf_by_tdSim_Stats_condLabel(:)},'model','interaction','varnames',{'tdSim','cond'},'display','off');
% multcompare(VS_perf_by_tdSim_blk1Stats,'dimension',2)
%effect size
effectSizeGrouptmp1 = repmat(0:2,size(VS_perf_by_tdSim_Stats_tdSimLabel,1),1);
effectSizeGrouptmp2 = (strcmp(VS_perf_by_tdSim_Stats_condLabel,'highDrug')*3+strcmp(VS_perf_by_tdSim_Stats_condLabel,'medDrug')*2+strcmp(VS_perf_by_tdSim_Stats_condLabel,'lowDrug'));
effectSizeGrouptmp = [effectSizeGrouptmp1(:) effectSizeGrouptmp2(:)];
mes2way(VS_perf_by_tdSim_blk1Stats_data(:),effectSizeGrouptmp,'eta2','fName',{'Load','Cond'});

VS_perf_by_tdSim_blk2Stats_data = [vehicle_VS_perf_by_tdSim_blk2; drug1_VS_perf_by_tdSim_blk2; drug2_VS_perf_by_tdSim_blk2; drug3_VS_perf_by_tdSim_blk2];
[VS_perf_by_tdSim_blk2Stats_p,VS_perf_by_tdSim_blk2Stats_table,VS_perf_by_tdSim_blk2Stats] = anovan(VS_perf_by_tdSim_blk2Stats_data(:),{VS_perf_by_tdSim_Stats_tdSimLabel(:),VS_perf_by_tdSim_Stats_condLabel(:)},'model','interaction','varnames',{'tdSim','cond'},'display','off');
% multcompare(VS_perf_by_tdSim_blk2Stats,'dimension',2)
%effect size
effectSizeGrouptmp = [effectSizeGrouptmp1(:) effectSizeGrouptmp2(:)];
mes2way(VS_perf_by_tdSim_blk2Stats_data(:),effectSizeGrouptmp,'eta2','fName',{'Load','Cond'});

%plot perf by distNum and tdSim
figure
subplot(2,2,1)
hold on
errorbar(2.9:3:11.9,nanmean(vehicle_VS_perf_by_distNum_blk1),cellfun(@SEM_AH, num2cell(vehicle_VS_perf_by_distNum_blk1,1)),'.-','color',drug_plot_colors(1,:),'MarkerSize',20,'Linewidth',1);
errorbar(3:3:12,nanmean(drug1_VS_perf_by_distNum_blk1),cellfun(@SEM_AH, num2cell(drug1_VS_perf_by_distNum_blk1,1)),'.-','color',drug_plot_colors(2,:),'MarkerSize',20,'Linewidth',1);
errorbar(3.1:3:12.1,nanmean(drug2_VS_perf_by_distNum_blk1),cellfun(@SEM_AH, num2cell(drug2_VS_perf_by_distNum_blk1,1)),'.-','color',drug_plot_colors(3,:),'MarkerSize',20,'Linewidth',1);
errorbar(3.2:3:12.2,nanmean(drug3_VS_perf_by_distNum_blk1),cellfun(@SEM_AH, num2cell(drug3_VS_perf_by_distNum_blk1,1)),'.-','color',drug_plot_colors(4,:),'MarkerSize',20,'Linewidth',1);
xticks(3:3:12); xlim([2.5 12.5]); xlabel('dist. number'); ylabel ('performance'); ylim([0.75 1]);
legend({'vehicle','VU595 0.3','VU595 1','VU595 3'},'Location','southwest');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(2,2,2)
hold on
errorbar(2.9:3:11.9,nanmean(vehicle_VS_perf_by_distNum_blk2),cellfun(@SEM_AH, num2cell(vehicle_VS_perf_by_distNum_blk2,1)),'.--','color',drug_plot_colors(1,:),'MarkerSize',20,'Linewidth',1);
errorbar(3:3:12,nanmean(drug1_VS_perf_by_distNum_blk2),cellfun(@SEM_AH, num2cell(drug1_VS_perf_by_distNum_blk2,1)),'.--','color',drug_plot_colors(2,:),'MarkerSize',20,'Linewidth',1);
errorbar(3.1:3:12.1,nanmean(drug2_VS_perf_by_distNum_blk2),cellfun(@SEM_AH, num2cell(drug2_VS_perf_by_distNum_blk2,1)),'.--','color',drug_plot_colors(3,:),'MarkerSize',20,'Linewidth',1);
errorbar(3.2:3:12.2,nanmean(drug3_VS_perf_by_distNum_blk2),cellfun(@SEM_AH, num2cell(drug3_VS_perf_by_distNum_blk2,1)),'.--','color',drug_plot_colors(4,:),'MarkerSize',20,'Linewidth',1);
xticks(3:3:12); xlim([2.5 12.5]); xlabel('dist. number'); ylabel ('performance');ylim([0.75 1]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(2,2,3)
hold on
errorbar(0.95:1:2.95,nanmean(vehicle_VS_perf_by_tdSim_blk1),cellfun(@SEM_AH, num2cell(vehicle_VS_perf_by_tdSim_blk1,1)),'.-','color',drug_plot_colors(1,:),'MarkerSize',20,'Linewidth',1);
errorbar(1:3,nanmean(drug1_VS_perf_by_tdSim_blk1),cellfun(@SEM_AH, num2cell(drug1_VS_perf_by_tdSim_blk1,1)),'.-','color',drug_plot_colors(2,:),'MarkerSize',20,'Linewidth',1);
errorbar(1.05:1:3.05,nanmean(drug2_VS_perf_by_tdSim_blk1),cellfun(@SEM_AH, num2cell(drug2_VS_perf_by_tdSim_blk1,1)),'.-','color',drug_plot_colors(3,:),'MarkerSize',20,'Linewidth',1);
errorbar(1.1:1:3.1,nanmean(drug3_VS_perf_by_tdSim_blk1),cellfun(@SEM_AH, num2cell(drug3_VS_perf_by_tdSim_blk1,1)),'.-','color',drug_plot_colors(4,:),'MarkerSize',20,'Linewidth',1);
xticks(1:3); xticklabels({'low TD sim','mid TD sim','high TD sim'}); xlim([0.5 3.5]); ylabel ('performance');ylim([0.75 1]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(2,2,4)
hold on
errorbar(0.95:1:2.95,nanmean(vehicle_VS_perf_by_tdSim_blk2),cellfun(@SEM_AH, num2cell(vehicle_VS_perf_by_tdSim_blk2,1)),'.--','color',drug_plot_colors(1,:),'MarkerSize',20,'Linewidth',1);
errorbar(1:3,nanmean(drug1_VS_perf_by_tdSim_blk2),cellfun(@SEM_AH, num2cell(drug1_VS_perf_by_tdSim_blk2,1)),'.--','color',drug_plot_colors(2,:),'MarkerSize',20,'Linewidth',1);
errorbar(1.05:1:3.05,nanmean(drug2_VS_perf_by_tdSim_blk2),cellfun(@SEM_AH, num2cell(drug2_VS_perf_by_tdSim_blk2,1)),'.--','color',drug_plot_colors(3,:),'MarkerSize',20,'Linewidth',1);
errorbar(1.1:1:3.1,nanmean(drug3_VS_perf_by_tdSim_blk2),cellfun(@SEM_AH, num2cell(drug3_VS_perf_by_tdSim_blk2,1)),'.--','color',drug_plot_colors(4,:),'MarkerSize',20,'Linewidth',1);
xticks(1:3); xticklabels({'low TD sim','mid TD sim','high TD sim'}); xlim([0.5 3.5]); ylabel ('performance');ylim([0.75 1]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
set(gcf,'Position',[1 1 767 629]);

% saveas(gcf,[figSave_dir 'VS_perf_distNum_tdSim'],'epsc')

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Perf slope %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VS_perfSlope_sepBlks = [Reider.Perfslope_sepBlks, Sindri.Perfslope_sepBlks, Igor.Perfslope_sepBlks, Bard.Perfslope_sepBlks];

% individual monkey temporal progress

Reider_perfSlope = [nanmean(Reider.Perfslope_sepBlks(:,find(Reider.drug_1days_ind)),2)-nanmean(Reider.Perfslope_sepBlks(:,Reider_vehicleDays),2),...
    nanmean(Reider.Perfslope_sepBlks(:,find(Reider.drug_2days_ind)),2)-nanmean(Reider.Perfslope_sepBlks(:,Reider_vehicleDays),2),...
    nanmean(Reider.Perfslope_sepBlks(:,find(Reider.drug_2days_ind)),2)-nanmean(Reider.Perfslope_sepBlks(:,Reider_vehicleDays),2)];
Sindri_perfSlope = [nanmean(Sindri.Perfslope_sepBlks(:,find(Sindri.drug_1days_ind)),2)-nanmean(Sindri.Perfslope_sepBlks(:,Sindri_vehicleDays),2),...
    nanmean(Sindri.Perfslope_sepBlks(:,find(Sindri.drug_2days_ind)),2)-nanmean(Sindri.Perfslope_sepBlks(:,Sindri_vehicleDays),2),...
    nanmean(Sindri.Perfslope_sepBlks(:,find(Sindri.drug_2days_ind)),2)-nanmean(Sindri.Perfslope_sepBlks(:,Sindri_vehicleDays),2)];
Igor_perfSlope = [nanmean(Igor.Perfslope_sepBlks(:,find(Igor.drug_1days_ind)),2)-nanmean(Igor.Perfslope_sepBlks(:,Igor_vehicleDays),2),...
    nanmean(Igor.Perfslope_sepBlks(:,find(Igor.drug_2days_ind)),2)-nanmean(Igor.Perfslope_sepBlks(:,Igor_vehicleDays),2),...
    nanmean(Igor.Perfslope_sepBlks(:,find(Igor.drug_2days_ind)),2)-nanmean(Igor.Perfslope_sepBlks(:,Igor_vehicleDays),2)];
Bard_perfSlope = [nanmean(Bard.Perfslope_sepBlks(:,find(Bard.drug_1days_ind)),2)-nanmean(Bard.Perfslope_sepBlks(:,Bard_vehicleDays),2),...
    nanmean(Bard.Perfslope_sepBlks(:,find(Bard.drug_2days_ind)),2)-nanmean(Bard.Perfslope_sepBlks(:,Bard_vehicleDays),2),...
    nanmean(Bard.Perfslope_sepBlks(:,find(Bard.drug_2days_ind)),2)-nanmean(Bard.Perfslope_sepBlks(:,Bard_vehicleDays),2)];

%prep
vehicle_VS_perfSlope_sepBlks = VS_perfSlope_sepBlks(:,vehicle_days_ind);
drug1_VS_perfSlope_sepBlks = VS_perfSlope_sepBlks(:,drug_1days_ind);
drug2_VS_perfSlope_sepBlks = VS_perfSlope_sepBlks(:,drug_2days_ind);
drug3_VS_perfSlope_sepBlks = VS_perfSlope_sepBlks(:,drug_3days_ind);

%stats
VS_perfSlope_stats_data = [vehicle_VS_perfSlope_sepBlks, drug1_VS_perfSlope_sepBlks, drug2_VS_perfSlope_sepBlks, drug3_VS_perfSlope_sepBlks];
VS_perfSlope_stats_condLabel = [repmat({'vehicle'}, size(vehicle_VS_perfSlope_sepBlks)),repmat({'lowDrug'}, size(drug1_VS_perfSlope_sepBlks)),...
    repmat({'medDrug'}, size(drug2_VS_perfSlope_sepBlks)),repmat({'highDrug'}, size(drug3_VS_perfSlope_sepBlks))];
[VS_perfSlope_stats_blk1_p VS_perfSlope_stats_blk1_table VS_perfSlope_stats_blk1] = anova1 (VS_perfSlope_stats_data(1,:),VS_perfSlope_stats_condLabel(1,:),'display','off');
% multcompare(VS_perfSlope_stats_blk1)
mes1way(VS_perfSlope_stats_data(1,:)','eta2','group',(strcmp(VS_perfSlope_stats_condLabel(1,:),'highDrug')*3+strcmp(VS_perfSlope_stats_condLabel(1,:),'medDrug')*2+strcmp(VS_perfSlope_stats_condLabel(1,:),'lowDrug'))');
computeCohen_d(VS_perfSlope_stats_data(1,find(strcmp(VS_perfSlope_stats_condLabel(1,:),'medDrug'))),...
    VS_perfSlope_stats_data(1,find(strcmp(VS_perfSlope_stats_condLabel(1,:),'vehicle'))),'independent');

[VS_perfSlope_stats_blk2_p VS_perfSlope_stats_blk2_table VS_perfSlope_stats_blk2] = anova1 (VS_perfSlope_stats_data(2,:),VS_perfSlope_stats_condLabel(2,:),'display','off');
% multcompare(VS_perfSlope_stats_blk2)
mes1way(VS_perfSlope_stats_data(2,:)','eta2','group',(strcmp(VS_perfSlope_stats_condLabel(2,:),'highDrug')*3+strcmp(VS_perfSlope_stats_condLabel(2,:),'medDrug')*2+strcmp(VS_perfSlope_stats_condLabel(2,:),'lowDrug'))');
computeCohen_d(VS_perfSlope_stats_data(2,find(strcmp(VS_perfSlope_stats_condLabel(2,:),'medDrug'))),...
    VS_perfSlope_stats_data(2,find(strcmp(VS_perfSlope_stats_condLabel(2,:),'vehicle'))),'independent');

%plot perf slope changes
figure
hold on
errorbar(1:4,[nanmean(vehicle_VS_perfSlope_sepBlks(1,:)) nanmean(drug1_VS_perfSlope_sepBlks(1,:)) nanmean(drug2_VS_perfSlope_sepBlks(1,:)) nanmean(drug3_VS_perfSlope_sepBlks(1,:))],...
    [SEM_AH(vehicle_VS_perfSlope_sepBlks(1,:)) SEM_AH(drug1_VS_perfSlope_sepBlks(1,:)) SEM_AH(drug2_VS_perfSlope_sepBlks(1,:)) SEM_AH(drug3_VS_perfSlope_sepBlks(1,:))],...
    'k.-','MarkerSize',40,'Linewidth',3);
xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});xlim([0.5 4.5]);
yticks(-0.02:0.005:0);ylim([-0.02 0]);ylabel ('Avg. slope'); %title('Performance (by Dist Num) slope changes');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 20;
set(gcf,'Position',[1 1 560 420]);

% saveas(gcf,[figSave_dir 'VS_perfDistNum_slope'],'epsc')

close all

% % individual monkey temporal progress plot (VU595)
% 
% figure
% subplot(2,1,1)
% hold on
% title('blk 1');
% scatter(Reider_perfSlope(1,:),1:3,64,'r','filled');
% scatter(Sindri_perfSlope(1,:),0.95:1:2.95,64,'g','filled');
% scatter(Igor_perfSlope(1,:),0.9:1:2.9,64,'b','filled');
% scatter(Bard_perfSlope(1,:),1.05:1:3.05,64,'c','filled');
% xlabel('perf slope (diff.)');yticks(1:3);yticklabels({'0.3 mg/kg','1 mg/kg', '3 mg/kg'});
% xline(0);ylim([0.5 3.5]);
% % legend({'monkey Re','monkey Si','monkey Ig','monkey Ba'},'location','nw')
% set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
% 
% subplot(2,1,2)
% hold on
% title('blk 2');
% scatter(Reider_perfSlope(2,:),1:3,64,'r','filled');
% scatter(Sindri_perfSlope(2,:),0.95:1:2.95,64,'g','filled');
% scatter(Igor_perfSlope(2,:),0.9:1:2.9,64,'b','filled');
% scatter(Bard_perfSlope(2,:),1.05:1:3.05,64,'c','filled');
% xlabel('perf slope  (diff.)');yticks(1:3);yticklabels({'0.3 mg/kg','1 mg/kg', '3 mg/kg'});
% xline(0);ylim([0.5 3.5]);
% set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
% set(gcf,'Position',[1 1 709 483]);
% 
% % saveas(gcf,[figSave_dir 'monkeyTemporal_perfSlope'],'epsc')

for islope = 1:size(vehicle_VS_perf_by_tdSim_blk1,1)
    [vehicle_tdSlope(islope,:)]= polyfit ([1/3 1 5/3], vehicle_VS_perf_by_tdSim_blk1(islope,:),1);
end
for islope = 1:size(drug1_VS_perf_by_tdSim_blk1,1)
    [drug1_tdSlope(islope,:)]= polyfit ([1/3 1 5/3], drug1_VS_perf_by_tdSim_blk1(islope,:),1);
end
for islope = 1:size(drug2_VS_perf_by_tdSim_blk1,1)
    [drug2_tdSlope(islope,:)]= polyfit ([1/3 1 5/3], drug2_VS_perf_by_tdSim_blk1(islope,:),1);
end
for islope = 1:size(drug3_VS_perf_by_tdSim_blk1,1)
    [drug3_tdSlope(islope,:)]= polyfit ([1/3 1 5/3], drug3_VS_perf_by_tdSim_blk1(islope,:),1);
end

VS_tdSlope_stats_data = [vehicle_tdSlope;drug1_tdSlope;drug2_tdSlope;drug3_tdSlope];
[VS_tdSlope_stats_blk1_p VS_tdSlope_stats_blk1_table VS_tdSlope_stats_blk1] = anova1 (VS_tdSlope_stats_data(:,1),VS_perfSlope_stats_condLabel(1,:)','display','off');
% multcompare(VS_tdSlope_stats_blk1)
computeCohen_d(VS_tdSlope_stats_data(find(strcmp(VS_perfSlope_stats_condLabel(1,:),'medDrug')),1),...
    VS_tdSlope_stats_data(find(strcmp(VS_perfSlope_stats_condLabel(1,:),'vehicle')),1),'independent');

[VS_tdSlope_stats_blk2_p VS_tdSlope_stats_blk2_table VS_tdSlope_stats_blk2] = anova1 (VS_tdSlope_stats_data(:,2),VS_perfSlope_stats_condLabel(2,:)','display','off');

figure
hold on
errorbar(1:4,[nanmean(vehicle_tdSlope(:,1)) nanmean(drug1_tdSlope(:,1)) nanmean(drug2_tdSlope(:,1)) nanmean(drug3_tdSlope(:,1))],...
    [SEM_AH(vehicle_tdSlope(:,1)) SEM_AH(drug1_tdSlope(:,1)) SEM_AH(drug2_tdSlope(:,1)) SEM_AH(drug3_tdSlope(:,1))],...
    'k.-','MarkerSize',40,'Linewidth',3);
xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3','VU595 1','VU595 3'});xlim([0.5 4.5]);
yticks(-0.16:0.04:0);ylim([-0.16 0]);ylabel ('Avg. slope'); %title('Performance (by td sim) slope changes');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 20;
set(gcf,'Position',[1 1 560 420]);

% saveas(gcf,[figSave_dir 'VS_perfTDSim_slope'],'epsc')

close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% SA tradeoff %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vehicle_VS_SA_tradeoff = cellfun(@(x) [[nanmean(x(:,1)) nanmean(x(:,2))]], VS_data_by_block(vehicle_days_ind,:),'un',0);
drug1_VS_SA_tradeoff = cellfun(@(x) [[nanmean(x(:,1)) nanmean(x(:,2))]], VS_data_by_block(drug_1days_ind,:),'un',0);
drug2_VS_SA_tradeoff = cellfun(@(x) [[nanmean(x(:,1)) nanmean(x(:,2))]], VS_data_by_block(drug_2days_ind,:),'un',0);
drug3_VS_SA_tradeoff = cellfun(@(x) [[nanmean(x(:,1)) nanmean(x(:,2))]], VS_data_by_block(drug_3days_ind,:),'un',0);

vehicle_VS_SA_tradeoff_blk1 = fliplr(cell2mat(vehicle_VS_SA_tradeoff(:,1)));
drug1_VS_SA_tradeoff_blk1 = fliplr(cell2mat(drug1_VS_SA_tradeoff(:,1)));
drug2_VS_SA_tradeoff_blk1 = fliplr(cell2mat(drug2_VS_SA_tradeoff(:,1)));
drug3_VS_SA_tradeoff_blk1 = fliplr(cell2mat(drug3_VS_SA_tradeoff(:,1)));

vehicle_VS_SA_tradeoff_blk2 = fliplr(cell2mat(vehicle_VS_SA_tradeoff(:,2)));
drug1_VS_SA_tradeoff_blk2 = fliplr(cell2mat(drug1_VS_SA_tradeoff(:,2)));
drug2_VS_SA_tradeoff_blk2 = fliplr(cell2mat(drug2_VS_SA_tradeoff(:,2)));
drug3_VS_SA_tradeoff_blk2 = fliplr(cell2mat(drug3_VS_SA_tradeoff(:,2)));

%remove incomplete blocks
vehicle_VS_SA_tradeoff_blk2(find(isnan(vehicle_VS_SA_tradeoff_blk2(:,1))),:) = [];
drug1_VS_SA_tradeoff_blk2(find(isnan(drug1_VS_SA_tradeoff_blk2(:,1))),:) = [];
drug2_VS_SA_tradeoff_blk2(find(isnan(drug2_VS_SA_tradeoff_blk2(:,1))),:) = [];
drug3_VS_SA_tradeoff_blk2(find(isnan(drug3_VS_SA_tradeoff_blk2(:,1))),:) = [];

%get correlations
[vehicle_VS_SA_tradeoff_blk1_stats, vehicle_VS_SA_tradeoff_blk1_p] = corr (vehicle_VS_SA_tradeoff_blk1,'type','Pearson');
[drug1_VS_SA_tradeoff_blk1_stats, drug1_VS_SA_tradeoff_blk1_p] = corr (drug1_VS_SA_tradeoff_blk1,'type','Pearson'); %spearman: n.s.
[drug2_VS_SA_tradeoff_blk1_stats, drug2_VS_SA_tradeoff_blk1_p] = corr (drug2_VS_SA_tradeoff_blk1,'type','Pearson');
[drug3_VS_SA_tradeoff_blk1_stats, drug3_VS_SA_tradeoff_blk1_p] = corr (drug3_VS_SA_tradeoff_blk1,'type','Pearson');
[vehicle_VS_SA_tradeoff_blk2_stats, vehicle_VS_SA_tradeoff_blk2_p] = corr (vehicle_VS_SA_tradeoff_blk2,'type','Pearson');
[drug1_VS_SA_tradeoff_blk2_stats, drug1_VS_SA_tradeoff_blk2_p] = corr (drug1_VS_SA_tradeoff_blk2,'type','Pearson'); %spearman: p=0.053
[drug2_VS_SA_tradeoff_blk2_stats, drug2_VS_SA_tradeoff_blk2_p] = corr (drug2_VS_SA_tradeoff_blk2,'type','Pearson');
[drug3_VS_SA_tradeoff_blk2_stats, drug3_VS_SA_tradeoff_blk2_p] = corr (drug3_VS_SA_tradeoff_blk2,'type','Pearson');

%stats comparing significant correlations: all n.s.
vehicle_drug1_VSblk1_SA = compare_correlation_coefficients(vehicle_VS_SA_tradeoff_blk1_stats(1,2),drug1_VS_SA_tradeoff_blk1_stats(1,2),size(vehicle_VS_SA_tradeoff_blk1,1),size(drug1_VS_SA_tradeoff_blk1,1));
vehicle_drug2_VSblk1_SA = compare_correlation_coefficients(vehicle_VS_SA_tradeoff_blk1_stats(1,2),drug2_VS_SA_tradeoff_blk1_stats(1,2),size(vehicle_VS_SA_tradeoff_blk1,1),size(drug2_VS_SA_tradeoff_blk1,1));
vehicle_drug3_VSblk1_SA = compare_correlation_coefficients(vehicle_VS_SA_tradeoff_blk1_stats(1,2),drug3_VS_SA_tradeoff_blk1_stats(1,2),size(vehicle_VS_SA_tradeoff_blk1,1),size(drug3_VS_SA_tradeoff_blk1,1));
vehicle_drug1_VSblk2_SA = compare_correlation_coefficients(vehicle_VS_SA_tradeoff_blk2_stats(1,2),drug1_VS_SA_tradeoff_blk2_stats(1,2),size(vehicle_VS_SA_tradeoff_blk2,1),size(drug1_VS_SA_tradeoff_blk2,1));
vehicle_drug2_VSblk2_SA = compare_correlation_coefficients(vehicle_VS_SA_tradeoff_blk2_stats(1,2),drug2_VS_SA_tradeoff_blk2_stats(1,2),size(vehicle_VS_SA_tradeoff_blk2,1),size(drug2_VS_SA_tradeoff_blk2,1));
vehicle_drug3_VSblk2_SA = compare_correlation_coefficients(vehicle_VS_SA_tradeoff_blk2_stats(1,2),drug3_VS_SA_tradeoff_blk2_stats(1,2),size(vehicle_VS_SA_tradeoff_blk2,1),size(drug3_VS_SA_tradeoff_blk2,1));

%plot SA tradeoff
figure
subplot(2,2,1)
hold on
scatter(vehicle_VS_SA_tradeoff_blk1(:,1),vehicle_VS_SA_tradeoff_blk1(:,2),64,'k','filled');
scatter(drug1_VS_SA_tradeoff_blk1(:,1),drug1_VS_SA_tradeoff_blk1(:,2),64,drug_plot_colors(2,:),'filled');
scatter(drug2_VS_SA_tradeoff_blk1(:,1),drug2_VS_SA_tradeoff_blk1(:,2),64,drug_plot_colors(3,:),'filled');
scatter(drug3_VS_SA_tradeoff_blk1(:,1),drug3_VS_SA_tradeoff_blk1(:,2),64,drug_plot_colors(4,:),'filled');
Fit_vehicle = polyfit(vehicle_VS_SA_tradeoff_blk1(:,1),vehicle_VS_SA_tradeoff_blk1(:,2),1);
Fit_drug1 = polyfit(drug1_VS_SA_tradeoff_blk1(:,1),drug1_VS_SA_tradeoff_blk1(:,2),1);
Fit_drug2 = polyfit(drug2_VS_SA_tradeoff_blk1(:,1),drug2_VS_SA_tradeoff_blk1(:,2),1);
Fit_drug3 = polyfit(drug3_VS_SA_tradeoff_blk1(:,1),drug3_VS_SA_tradeoff_blk1(:,2),1);
plot(0.5:0.1:3,polyval(Fit_vehicle,0.5:0.1:3),'k','linewidth',2);plot(0.5:0.1:3,polyval(Fit_drug1,0.5:0.1:3),'color',drug_plot_colors(2,:),'linewidth',2);
plot(0.5:0.1:3,polyval(Fit_drug2,0.5:0.1:3),'color',drug_plot_colors(3,:),'linewidth',2);plot(0.5:0.1:3,polyval(Fit_drug3,0.5:0.1:3),'color',drug_plot_colors(4,:),'linewidth',2);
ylabel ('VS perf');xlabel ('VS RT');ylim([0.5 1]);xlim([0.8 2.5]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(2,2,2)
hold on
errorbar(1,vehicle_VS_SA_tradeoff_blk1_stats(1,2),NaN,'.-','color',drug_plot_colors(1,:),'MarkerSize',20,'linestyle','none');
errorbar(2,drug1_VS_SA_tradeoff_blk1_stats(1,2),NaN,'.-','color',drug_plot_colors(2,:),'MarkerSize',20,'linestyle','none');
errorbar(3,drug2_VS_SA_tradeoff_blk1_stats(1,2),NaN,'.-','color',drug_plot_colors(3,:),'MarkerSize',20,'linestyle','none');
errorbar(4,drug3_VS_SA_tradeoff_blk1_stats(1,2),NaN,'.-','color',drug_plot_colors(4,:),'MarkerSize',20,'linestyle','none');
xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});xlim([0.5 4.5]);
ylabel ('correlation coeff (Pearson)');ylim([-0.6 0]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(2,2,3)
hold on
scatter(vehicle_VS_SA_tradeoff_blk2(:,1),vehicle_VS_SA_tradeoff_blk2(:,2),64,'k','filled');
scatter(drug1_VS_SA_tradeoff_blk2(:,1),drug1_VS_SA_tradeoff_blk2(:,2),64,drug_plot_colors(2,:),'filled');
scatter(drug2_VS_SA_tradeoff_blk2(:,1),drug2_VS_SA_tradeoff_blk2(:,2),64,drug_plot_colors(3,:),'filled');
scatter(drug3_VS_SA_tradeoff_blk2(:,1),drug3_VS_SA_tradeoff_blk2(:,2),64,drug_plot_colors(4,:),'filled');
Fit_vehicle = polyfit(vehicle_VS_SA_tradeoff_blk2(:,1),vehicle_VS_SA_tradeoff_blk2(:,2),1);
Fit_drug1 = polyfit(drug1_VS_SA_tradeoff_blk2(:,1),drug1_VS_SA_tradeoff_blk2(:,2),1);
Fit_drug2 = polyfit(drug2_VS_SA_tradeoff_blk2(:,1),drug2_VS_SA_tradeoff_blk2(:,2),1);
Fit_drug3 = polyfit(drug3_VS_SA_tradeoff_blk2(:,1),drug3_VS_SA_tradeoff_blk2(:,2),1);
plot(0.5:0.1:3,polyval(Fit_vehicle,0.5:0.1:3),'k','linewidth',2);plot(0.5:0.1:3,polyval(Fit_drug1,0.5:0.1:3),'color',drug_plot_colors(2,:),'linewidth',2);
plot(0.5:0.1:3,polyval(Fit_drug2,0.5:0.1:3),'color',drug_plot_colors(3,:),'linewidth',2);plot(0.5:0.1:3,polyval(Fit_drug3,0.5:0.1:3),'color',drug_plot_colors(4,:),'linewidth',2);
ylabel ('VS perf');xlabel ('VS RT');ylim([0.5 1]);xlim([0.8 2.5]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(2,2,4)
hold on
errorbar(1,vehicle_VS_SA_tradeoff_blk2_stats(1,2),NaN,'.-','color',drug_plot_colors(1,:),'MarkerSize',20,'linestyle','none');
errorbar(2,drug1_VS_SA_tradeoff_blk2_stats(1,2),NaN,'.-','color',drug_plot_colors(2,:),'MarkerSize',20,'linestyle','none');
errorbar(3,drug2_VS_SA_tradeoff_blk2_stats(1,2),NaN,'.-','color',drug_plot_colors(3,:),'MarkerSize',20,'linestyle','none');
errorbar(4,drug3_VS_SA_tradeoff_blk2_stats(1,2),NaN,'.-','color',drug_plot_colors(4,:),'MarkerSize',20,'linestyle','none');
xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});xlim([0.5 4.5]);
ylabel ('correlation coeff (Pearson)');ylim([-0.6 0]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
set(gcf,'Position',[1 1 802 630]);

% saveas(gcf,[figSave_dir 'VS_SA_tradeoff'],'epsc')

figure 
subplot(1,2,1)
hold on
% title ('VS blk 1');
Fit_vehicle = polyfit(vehicle_VS_SA_tradeoff_blk1(:,1),vehicle_VS_SA_tradeoff_blk1(:,2),1);
Fit_drug1 = polyfit(drug1_VS_SA_tradeoff_blk1(:,1),drug1_VS_SA_tradeoff_blk1(:,2),1);
Fit_drug2 = polyfit(drug2_VS_SA_tradeoff_blk1(:,1),drug2_VS_SA_tradeoff_blk1(:,2),1);
Fit_drug3 = polyfit(drug3_VS_SA_tradeoff_blk1(:,1),drug3_VS_SA_tradeoff_blk1(:,2),1);
plot(1:0.1:1.7,polyval(Fit_vehicle,1:0.1:1.7),'k','linewidth',1);plot(1:0.1:1.7,polyval(Fit_drug1,1:0.1:1.7),'color',drug_plot_colors(2,:),'linewidth',1);
plot(1:0.1:1.7,polyval(Fit_drug2,1:0.1:1.7),'color',drug_plot_colors(3,:),'linewidth',1);plot(1:0.1:1.7,polyval(Fit_drug3,1:0.1:1.7),'color',drug_plot_colors(4,:),'linewidth',1);
tmp1 = errorbar(nanmean(vehicle_VS_SA_tradeoff_blk1(:,1)),nanmean(vehicle_VS_SA_tradeoff_blk1(:,2)),...
    SEM_AH(vehicle_VS_SA_tradeoff_blk1(:,2)),SEM_AH(vehicle_VS_SA_tradeoff_blk1(:,2)),SEM_AH(vehicle_VS_SA_tradeoff_blk1(:,1)),SEM_AH(vehicle_VS_SA_tradeoff_blk1(:,1)),...
    '.','Color',drug_plot_colors(1,:),'MarkerSize',40,'linewidth',2)
tmp2 = errorbar(nanmean(drug1_VS_SA_tradeoff_blk1(:,1)),nanmean(drug1_VS_SA_tradeoff_blk1(:,2)),...
    SEM_AH(drug1_VS_SA_tradeoff_blk1(:,2)),SEM_AH(drug1_VS_SA_tradeoff_blk1(:,2)),SEM_AH(drug1_VS_SA_tradeoff_blk1(:,1)),SEM_AH(drug1_VS_SA_tradeoff_blk1(:,1)),...
    '.','Color',drug_plot_colors(2,:),'MarkerSize',40,'linewidth',2)
tmp3 = errorbar(nanmean(drug2_VS_SA_tradeoff_blk1(:,1)),nanmean(drug2_VS_SA_tradeoff_blk1(:,2)),...
    SEM_AH(drug2_VS_SA_tradeoff_blk1(:,2)),SEM_AH(drug2_VS_SA_tradeoff_blk1(:,2)),SEM_AH(drug2_VS_SA_tradeoff_blk1(:,1)),SEM_AH(drug2_VS_SA_tradeoff_blk1(:,1)),...
    '.','Color',drug_plot_colors(3,:),'MarkerSize',40,'linewidth',2)
tmp4 = errorbar(nanmean(drug3_VS_SA_tradeoff_blk1(:,1)),nanmean(drug3_VS_SA_tradeoff_blk1(:,2)),...
    SEM_AH(drug3_VS_SA_tradeoff_blk1(:,2)),SEM_AH(drug3_VS_SA_tradeoff_blk1(:,2)),SEM_AH(drug3_VS_SA_tradeoff_blk1(:,1)),SEM_AH(drug3_VS_SA_tradeoff_blk1(:,1)),...
    '.','Color',drug_plot_colors(4,:),'MarkerSize',40,'linewidth',2)
ylabel ('performance (% correct)');xlabel ('search times (s)');xlim([1.1 1.7]);ylim([0.75 1]);
legend([tmp1, tmp2, tmp3, tmp4],{'vehicle', '0.3 mg/kg', '1 mg/kg', '3 mg/kg'},'location','ne')
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(1,2,2)
hold on
% title ('VS blk 2');
Fit_vehicle = polyfit(vehicle_VS_SA_tradeoff_blk2(:,1),vehicle_VS_SA_tradeoff_blk2(:,2),1);
Fit_drug1 = polyfit(drug1_VS_SA_tradeoff_blk2(:,1),drug1_VS_SA_tradeoff_blk2(:,2),1);
Fit_drug2 = polyfit(drug2_VS_SA_tradeoff_blk2(:,1),drug2_VS_SA_tradeoff_blk2(:,2),1);
Fit_drug3 = polyfit(drug3_VS_SA_tradeoff_blk2(:,1),drug3_VS_SA_tradeoff_blk2(:,2),1);
plot(1:0.1:1.7,polyval(Fit_vehicle,1:0.1:1.7),'k','linewidth',1);plot(1:0.1:1.7,polyval(Fit_drug1,1:0.1:1.7),'color',drug_plot_colors(2,:),'linewidth',1);
plot(1:0.1:1.7,polyval(Fit_drug2,1:0.1:1.7),'color',drug_plot_colors(3,:),'linewidth',1);plot(1:0.1:1.7,polyval(Fit_drug3,1:0.1:1.7),'color',drug_plot_colors(4,:),'linewidth',1);
errorbar(nanmean(vehicle_VS_SA_tradeoff_blk2(:,1)),nanmean(vehicle_VS_SA_tradeoff_blk2(:,2)),...
    SEM_AH(vehicle_VS_SA_tradeoff_blk2(:,2)),SEM_AH(vehicle_VS_SA_tradeoff_blk2(:,2)),SEM_AH(vehicle_VS_SA_tradeoff_blk2(:,1)),SEM_AH(vehicle_VS_SA_tradeoff_blk2(:,1)),...
    '.','Color',drug_plot_colors(1,:),'MarkerSize',40,'linewidth',2)
errorbar(nanmean(drug1_VS_SA_tradeoff_blk2(:,1)),nanmean(drug1_VS_SA_tradeoff_blk2(:,2)),...
    SEM_AH(drug1_VS_SA_tradeoff_blk2(:,2)),SEM_AH(drug1_VS_SA_tradeoff_blk2(:,2)),SEM_AH(drug1_VS_SA_tradeoff_blk2(:,1)),SEM_AH(drug1_VS_SA_tradeoff_blk2(:,1)),...
    '.','Color',drug_plot_colors(2,:),'MarkerSize',40,'linewidth',2)
errorbar(nanmean(drug2_VS_SA_tradeoff_blk2(:,1)),nanmean(drug2_VS_SA_tradeoff_blk2(:,2)),...
    SEM_AH(drug2_VS_SA_tradeoff_blk2(:,2)),SEM_AH(drug2_VS_SA_tradeoff_blk2(:,2)),SEM_AH(drug2_VS_SA_tradeoff_blk2(:,1)),SEM_AH(drug2_VS_SA_tradeoff_blk2(:,1)),...
    '.','Color',drug_plot_colors(3,:),'MarkerSize',40,'linewidth',2)
errorbar(nanmean(drug3_VS_SA_tradeoff_blk2(:,1)),nanmean(drug3_VS_SA_tradeoff_blk2(:,2)),...
    SEM_AH(drug3_VS_SA_tradeoff_blk2(:,2)),SEM_AH(drug3_VS_SA_tradeoff_blk2(:,2)),SEM_AH(drug3_VS_SA_tradeoff_blk2(:,1)),SEM_AH(drug3_VS_SA_tradeoff_blk2(:,1)),...
    '.','Color',drug_plot_colors(4,:),'MarkerSize',40,'linewidth',2)
ylabel ('performance (% correct)');xlabel ('search times (s)');xlim([1.1 1.7]);ylim([0.75 1]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
set(gcf,'Position',[1 1 680 320]);

% saveas(gcf,[figSave_dir 'VS_SA_tradeoff_altFig'],'epsc')

close all

%% cross-task correlations

crosstask_VS_blockLim = 'both'; %options: 'first' 'second' 'both
crosstask_FL_blockLim = 7; % max block number (1:n)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% RT-RT corr %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch crosstask_VS_blockLim
    case 'first'
        vehicle_crosstask_VSRT= cellfun(@(x) [nanmean(x(:,2))], VS_data_by_block(vehicle_days_ind,1));
        drug1_crosstask_VSRT= cellfun(@(x) [nanmean(x(:,2))], VS_data_by_block(drug_1days_ind,1));
        drug2_crosstask_VSRT= cellfun(@(x) [nanmean(x(:,2))], VS_data_by_block(drug_2days_ind,1));
        drug3_crosstask_VSRT= cellfun(@(x) [nanmean(x(:,2))], VS_data_by_block(drug_3days_ind,1));
    case 'second'
        vehicle_crosstask_VSRT= cellfun(@(x) [nanmean(x(:,2))], VS_data_by_block(vehicle_days_ind,2));
        drug1_crosstask_VSRT= cellfun(@(x) [nanmean(x(:,2))], VS_data_by_block(drug_1days_ind,2));
        drug2_crosstask_VSRT= cellfun(@(x) [nanmean(x(:,2))], VS_data_by_block(drug_2days_ind,2));
        drug3_crosstask_VSRT= cellfun(@(x) [nanmean(x(:,2))], VS_data_by_block(drug_3days_ind,2));
    case 'both'
        vehicle_crosstask_VSRT= cellfun(@(x,y) [nanmean([x(:,2);y(:,2)])], VS_data_by_block(vehicle_days_ind,1),VS_data_by_block(vehicle_days_ind,2));
        drug1_crosstask_VSRT= cellfun(@(x,y) [nanmean([x(:,2);y(:,2)])], VS_data_by_block(drug_1days_ind,1),VS_data_by_block(drug_1days_ind,2));
        drug2_crosstask_VSRT= cellfun(@(x,y) [nanmean([x(:,2);y(:,2)])], VS_data_by_block(drug_2days_ind,1),VS_data_by_block(drug_2days_ind,2));
        drug3_crosstask_VSRT= cellfun(@(x,y) [nanmean([x(:,2);y(:,2)])], VS_data_by_block(drug_3days_ind,1),VS_data_by_block(drug_3days_ind,2));
end

vehicle_crosstask_FLRT = cellfun(@(x) [nanmean(reshape(x(1:crosstask_FL_blockLim,11:end),1,[]))], allFL_RT_by_sess_corr_only(vehicle_days_ind));
drug1_crosstask_FLRT = cellfun(@(x) [nanmean(reshape(x(1:crosstask_FL_blockLim,11:end),1,[]))], allFL_RT_by_sess_corr_only(drug_1days_ind));
drug2_crosstask_FLRT = cellfun(@(x) [nanmean(reshape(x(1:crosstask_FL_blockLim,11:end),1,[]))], allFL_RT_by_sess_corr_only(drug_2days_ind));
drug3_crosstask_FLRT = cellfun(@(x) [nanmean(reshape(x(1:crosstask_FL_blockLim,11:end),1,[]))], allFL_RT_by_sess_corr_only(drug_3days_ind));

%get correlations
[vehicle_crosstaskRT_stats, vehicle_crosstaskRT_p] = corr ([vehicle_crosstask_VSRT vehicle_crosstask_FLRT'],'type','Pearson');
[drug1_crosstaskRT_stats, drug1_crosstaskRT_p] = corr ([drug1_crosstask_VSRT drug1_crosstask_FLRT'],'type','Pearson');
[drug2_crosstaskRT_stats, drug2_crosstaskRT_p] = corr ([drug2_crosstask_VSRT drug2_crosstask_FLRT'],'type','Pearson');
[drug3_crosstaskRT_stats, drug3_crosstaskRT_p] = corr ([drug3_crosstask_VSRT drug3_crosstask_FLRT'],'type','Pearson');

%stats comparing significant correlations: all n.s.
vehicle_drug1_crossTalkRT_SA = compare_correlation_coefficients(vehicle_crosstaskRT_stats(1,2),drug1_crosstaskRT_stats(1,2),size(vehicle_crosstask_VSRT,1),size(drug1_crosstask_VSRT,1));
vehicle_drug2_crossTalkRT_SA = compare_correlation_coefficients(vehicle_crosstaskRT_stats(1,2),drug2_crosstaskRT_stats(1,2),size(vehicle_crosstask_VSRT,1),size(drug2_crosstask_VSRT,1));
vehicle_drug3_crossTalkRT_SA = compare_correlation_coefficients(vehicle_crosstaskRT_stats(1,2),drug3_crosstaskRT_stats(1,2),size(vehicle_crosstask_VSRT,1),size(drug3_crosstask_VSRT,1));

%plot RT-RT crosstask correlations
figure
subplot(1,2,1)
hold on
scatter(vehicle_crosstask_VSRT,vehicle_crosstask_FLRT,64,'k','filled');
scatter(drug1_crosstask_VSRT,drug1_crosstask_FLRT,64,drug_plot_colors(2,:),'filled');
scatter(drug2_crosstask_VSRT,drug2_crosstask_FLRT,64,drug_plot_colors(3,:),'filled');
scatter(drug3_crosstask_VSRT,drug3_crosstask_FLRT,64,drug_plot_colors(4,:),'filled');
Fit_vehicle = polyfit(vehicle_crosstask_VSRT,vehicle_crosstask_FLRT,1);
Fit_drug1 = polyfit(drug1_crosstask_VSRT,drug1_crosstask_FLRT,1);
Fit_drug2 = polyfit(drug2_crosstask_VSRT,drug2_crosstask_FLRT,1);
Fit_drug3 = polyfit(drug3_crosstask_VSRT,drug3_crosstask_FLRT,1);
plot(0.8:0.1:2.5,polyval(Fit_vehicle,0.8:0.1:2.5),'k','linewidth',2);plot(0.8:0.1:2.5,polyval(Fit_drug1,0.8:0.1:2.5),'color',drug_plot_colors(2,:),'linewidth',2);
plot(0.8:0.1:2.5,polyval(Fit_drug2,0.8:0.1:2.5),'color',drug_plot_colors(3,:),'linewidth',2);plot(0.8:0.1:2.5,polyval(Fit_drug3,0.8:0.1:2.5),'color',drug_plot_colors(4,:),'linewidth',2);
xlabel ('VS perf');ylabel ('FL RT');xlim([0.85 2.2]);ylim([0.5 1.6]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(1,2,2)
hold on
errorbar(1,vehicle_crosstaskRT_stats(1,2),NaN,'.-','color',drug_plot_colors(1,:),'MarkerSize',20,'linestyle','none');
errorbar(2,drug1_crosstaskRT_stats(1,2),NaN,'.-','color',drug_plot_colors(2,:),'MarkerSize',20,'linestyle','none');
errorbar(3,drug2_crosstaskRT_stats(1,2),NaN,'.-','color',drug_plot_colors(3,:),'MarkerSize',20,'linestyle','none');
errorbar(4,drug3_crosstaskRT_stats(1,2),NaN,'.-','color',drug_plot_colors(4,:),'MarkerSize',20,'linestyle','none');
xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});xlim([0.5 4.5]);
ylabel ('correlation coeff (Pearson)');ylim([0 1]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
set(gcf,'Position',[1 1 976 410]);

% saveas(gcf,[figSave_dir 'task_crossTalk_RT'],'epsc')

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% perf-perf corr %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch crosstask_VS_blockLim
    case 'first'
        vehicle_crosstask_VSperf= cellfun(@(x) [nanmean(x(:,1))], VS_data_by_block(vehicle_days_ind,1));
        drug1_crosstask_VSperf= cellfun(@(x) [nanmean(x(:,1))], VS_data_by_block(drug_1days_ind,1));
        drug2_crosstask_VSperf= cellfun(@(x) [nanmean(x(:,1))], VS_data_by_block(drug_2days_ind,1));
        drug3_crosstask_VSperf= cellfun(@(x) [nanmean(x(:,1))], VS_data_by_block(drug_3days_ind,1));
    case 'second'
        vehicle_crosstask_VSperf= cellfun(@(x) [nanmean(x(:,1))], VS_data_by_block(vehicle_days_ind,2));
        drug1_crosstask_VSperf= cellfun(@(x) [nanmean(x(:,1))], VS_data_by_block(drug_1days_ind,2));
        drug2_crosstask_VSperf= cellfun(@(x) [nanmean(x(:,1))], VS_data_by_block(drug_2days_ind,2));
        drug3_crosstask_VSperf= cellfun(@(x) [nanmean(x(:,1))], VS_data_by_block(drug_3days_ind,2));
    case 'both'
        vehicle_crosstask_VSperf= cellfun(@(x,y) [nanmean([x(:,1);y(:,1)])], VS_data_by_block(vehicle_days_ind,1),VS_data_by_block(vehicle_days_ind,2));
        drug1_crosstask_VSperf= cellfun(@(x,y) [nanmean([x(:,1);y(:,1)])], VS_data_by_block(drug_1days_ind,1),VS_data_by_block(drug_1days_ind,2));
        drug2_crosstask_VSperf= cellfun(@(x,y) [nanmean([x(:,1);y(:,1)])], VS_data_by_block(drug_2days_ind,1),VS_data_by_block(drug_2days_ind,2));
        drug3_crosstask_VSperf= cellfun(@(x,y) [nanmean([x(:,1);y(:,1)])], VS_data_by_block(drug_3days_ind,1),VS_data_by_block(drug_3days_ind,2));
end

vehicle_crosstask_FLperf = cellfun(@(x) [nanmean(reshape(x(1:crosstask_FL_blockLim,11:end),1,[]))], all_block_outcomes_prob(vehicle_days_ind));
drug1_crosstask_FLperf = cellfun(@(x) [nanmean(reshape(x(1:crosstask_FL_blockLim,11:end),1,[]))], all_block_outcomes_prob(drug_1days_ind));
drug2_crosstask_FLperf = cellfun(@(x) [nanmean(reshape(x(1:crosstask_FL_blockLim,11:end),1,[]))], all_block_outcomes_prob(drug_2days_ind));
drug3_crosstask_FLperf = cellfun(@(x) [nanmean(reshape(x(1:crosstask_FL_blockLim,11:end),1,[]))], all_block_outcomes_prob(drug_3days_ind));

%get correlations
[vehicle_crosstaskperf_stats, vehicle_crosstaskperf_p] = corr ([vehicle_crosstask_VSperf vehicle_crosstask_FLperf'],'type','Pearson');
[drug1_crosstaskperf_stats, drug1_crosstaskperf_p] = corr ([drug1_crosstask_VSperf drug1_crosstask_FLperf'],'type','Pearson');
[drug2_crosstaskperf_stats, drug2_crosstaskperf_p] = corr ([drug2_crosstask_VSperf drug2_crosstask_FLperf'],'type','Pearson');
[drug3_crosstaskperf_stats, drug3_crosstaskperf_p] = corr ([drug3_crosstask_VSperf drug3_crosstask_FLperf'],'type','Pearson');

%stats comparing significant correlations: all n.s.
vehicle_drug1_crossTalkperf_SA = compare_correlation_coefficients(vehicle_crosstaskperf_stats(1,2),drug1_crosstaskperf_stats(1,2),size(vehicle_crosstask_VSperf,1),size(drug1_crosstask_VSperf,1));
vehicle_drug2_crossTalkperf_SA = compare_correlation_coefficients(vehicle_crosstaskperf_stats(1,2),drug2_crosstaskperf_stats(1,2),size(vehicle_crosstask_VSperf,1),size(drug2_crosstask_VSperf,1));
vehicle_drug3_crossTalkperf_SA = compare_correlation_coefficients(vehicle_crosstaskperf_stats(1,2),drug3_crosstaskperf_stats(1,2),size(vehicle_crosstask_VSperf,1),size(drug3_crosstask_VSperf,1));

%plot perf-perf cross-task correlations
figure
subplot(1,2,1)
hold on
scatter(vehicle_crosstask_VSperf,vehicle_crosstask_FLperf,64,'k','filled');
scatter(drug1_crosstask_VSperf,drug1_crosstask_FLperf,64,drug_plot_colors(2,:),'filled');
scatter(drug2_crosstask_VSperf,drug2_crosstask_FLperf,64,drug_plot_colors(3,:),'filled');
scatter(drug3_crosstask_VSperf,drug3_crosstask_FLperf,64,drug_plot_colors(4,:),'filled');
Fit_vehicle = polyfit(vehicle_crosstask_VSperf,vehicle_crosstask_FLperf,1);
Fit_drug1 = polyfit(drug1_crosstask_VSperf,drug1_crosstask_FLperf,1);
Fit_drug2 = polyfit(drug2_crosstask_VSperf,drug2_crosstask_FLperf,1);
Fit_drug3 = polyfit(drug3_crosstask_VSperf,drug3_crosstask_FLperf,1);
plot(0.5:0.1:1.1,polyval(Fit_vehicle,0.5:0.1:1.1),'k','linewidth',2);plot(0.5:0.1:1.1,polyval(Fit_drug1,0.5:0.1:1.1),'color',drug_plot_colors(2,:),'linewidth',2);
plot(0.5:0.1:1.1,polyval(Fit_drug2,0.5:0.1:1.1),'color',drug_plot_colors(3,:),'linewidth',2);plot(0.5:0.1:1.1,polyval(Fit_drug3,0.5:0.1:1.1),'color',drug_plot_colors(4,:),'linewidth',2);
xlabel ('VS perf');ylabel ('FL perf');xlim([0.6 1]);ylim([0.3 1]);
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;

subplot(1,2,2)
hold on
errorbar(1,vehicle_crosstaskperf_stats(1,2),NaN,'.-','color',drug_plot_colors(1,:),'MarkerSize',20,'linestyle','none');
errorbar(2,drug1_crosstaskperf_stats(1,2),NaN,'.-','color',drug_plot_colors(2,:),'MarkerSize',20,'linestyle','none');
errorbar(3,drug2_crosstaskperf_stats(1,2),NaN,'.-','color',drug_plot_colors(3,:),'MarkerSize',20,'linestyle','none');
errorbar(4,drug3_crosstaskperf_stats(1,2),NaN,'.-','color',drug_plot_colors(4,:),'MarkerSize',20,'linestyle','none');
xticks(1:4);xticklabels({'Vehicle', 'VU595 0.3', 'VU595 1', 'VU595 3'});xlim([0.5 4.5]);
ylabel ('correlation coeff (Pearson)');ylim([-0.1 1]);yline(0,'-k')
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
set(gcf,'Position',[1 1 976 410]);

% saveas(gcf,[figSave_dir 'task_crossTalk_perf'],'epsc')

close all

%% individual monkey temporal progress plot (VU595) ALL

indPlot_LP = [Reider_avgLP(1,2) Sindri_avgLP(1,2) Igor_avgLP(1,2) Bard_avgLP(1,2)] ./ 8; % -8
indPlot_porpLearn = [Reider_propLearned(1,2) Sindri_propLearned(1,2) Igor_propLearned(1,2) Bard_propLearned(1,2)] ./ .1; %.1
indPlot_ED = [Reider_ED(2) Sindri_ED(2) Igor_ED(2) Bard_ED(2)] ./ 12; %-12
indPlot_ID = [Reider_ID(2) Sindri_ID(2) Igor_ID(2) Bard_ID(2)] ./ 8; %-8
% indPlot_persvErr = [ReiderPersv(2) SindriPersv(2) IgorPersv(2) BardPersv(2)] ./ .4;% -0.4
indPlot_persvErr_tarDim = [ReiderPersv_tarProp(2) SindriPersv_tarProp(2) IgorPersv_tarProp(2) BardPersv_tarProp(2)] ./ .04;% -0.04
indPlot_RTtrl_lowDim = [Reider_RTtrl_lowDim(2) Sindri_RTtrl_lowDim(2) Igor_RTtrl_lowDim(2) Bard_RTtrl_lowDim(2)] ./ 4;% -4
% indPlot_RTtrl_highDim = [Reider_RTtrl_highDim(2) Sindri_RTtrl_highDim(2) Igor_RTtrl_highDim(2) Bard_RTtrl_highDim(2)] ./ 4;% -4
indPlot_RTslope1 = [Reider_RTslope(1,2) Sindri_RTslope(1,2) Igor_RTslope(1,2) Bard_RTslope(1,2)] ./ .1; %.1
indPlot_RTslope2 = [Reider_RTslope(2,2) Sindri_RTslope(2,2) Igor_RTslope(2,2) Bard_RTslope(2,2)] ./ .1; %.1
indPlot_perfSlope1 = [Reider_perfSlope(1,2) Sindri_perfSlope(1,2) Igor_perfSlope(1,2) Bard_perfSlope(1,2)] ./ .1;%.1
indPlot_perfSlope2 = [Reider_perfSlope(2,2) Sindri_perfSlope(2,2) Igor_perfSlope(2,2) Bard_perfSlope(2,2)] ./ .1;%.1

indPlot_Reider_all = [indPlot_porpLearn(1) indPlot_LP(1) indPlot_ED(1) indPlot_ID(1) indPlot_persvErr_tarDim(1) indPlot_RTtrl_lowDim(1) indPlot_RTslope1(1) indPlot_RTslope2(1) indPlot_perfSlope1(1) indPlot_perfSlope2(1)];
indPlot_Sindri_all = [indPlot_porpLearn(2) indPlot_LP(2) indPlot_ED(2) indPlot_ID(2) indPlot_persvErr_tarDim(2) indPlot_RTtrl_lowDim(2) indPlot_RTslope1(2) indPlot_RTslope2(2) indPlot_perfSlope1(1) indPlot_perfSlope2(2)];
indPlot_Igor_all = [indPlot_porpLearn(3) indPlot_LP(3) indPlot_ED(3) indPlot_ID(3) indPlot_persvErr_tarDim(3) indPlot_RTtrl_lowDim(3) indPlot_RTslope1(3) indPlot_RTslope2(3) indPlot_perfSlope1(1) indPlot_perfSlope2(3)];
indPlot_Bard_all = [indPlot_porpLearn(4) indPlot_LP(4) indPlot_ED(4) indPlot_ID(4) indPlot_persvErr_tarDim(4) indPlot_RTtrl_lowDim(4) indPlot_RTslope1(4) indPlot_RTslope2(4) indPlot_perfSlope1(1) indPlot_perfSlope2(4)];

figure
hold on
scatter(fliplr(indPlot_Reider_all),1:10,64,'r','filled');
scatter(fliplr(indPlot_Sindri_all),0.9:1:9.9,64,'g','filled');
scatter(fliplr(indPlot_Igor_all),1.1:1:10.1,64,'b','filled');
scatter(fliplr(indPlot_Bard_all),1.2:1:10.2,64,'c','filled');
xline(0,'-k'); ylim([0.5 10.5]);
yline(1.5,'--k');yline(2.5,'--k');yline(3.5,'--k');yline(4.5,'-k');yline(5.5,'--k');yline(6.5,'--k');yline(7.5,'--k');yline(8.5,'--k');yline(9.5,'--k');
yticks([1:10]); yticklabels(fliplr({'prop. blocks learned','trial-to-criterion','ED switch cost','ID switch cost','persv. errors (target dim)','trial-to-inflection (low dist. load)',...
    'search time slope (VS blk 1)','search time slope (VS blk 2)','perf. slope (VS blk 1)','perf. slope (VS blk 2)'}));
xticks([-1:0.25:1]);xticklabels(-4:1:4); xlabel('change from vehicle');
legend({'monkey Re','monkey Si','monkey Ig','monkey Ba'},'location','sw');
set(gca,'tickdir','out');ax = gca; ax.FontSize = 14;
set(gcf,'Position',[1 1 579 564]);

% saveas(gcf,[figSave_dir 'indv_monkey_all'],'epsc')



