
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: Linear Vertical Mixing model to simuluate observations made from drill cuttings.
% Author: Christine Regalla
% Written: August 2024
% Code based on a vertical mixing model produced by IODP Exp 338 shipboard
% scientists. Plots are based on those in IODP Exp 338, 348 and 358
% reports. http://iodp.tamu.edu/publications/PR.html
%
%
% This mixing model assumes that cuttings are mixed over a 20m interval, 
% with a linear decay of contributions of cuttings with distance uphole, 
% within that interval, from 100% at the base of the interval to 0% at the 
% top of the interval. 
%
% The mixing model is mathematically defined by the equation:
%   the integral (∫) from (x-v) to x of mx*dx = 1. 
%   where x = downhole depth, v = the vertical mixing interval and m= the linear mixing gradient. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all;


%% Define Mixing Model Parameters

    % Define total Model Depth range (Z) 
    Z = [1:250]'; 
    
    % Define interval over which mixing occurs (in meters)
    interval = 20; 
    
    % Define linear mixing model from 0 to 20m interval
    MixingModel = [linspace(0,0.1,interval)]'; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Model A - sedimentolgy composition histograms, discrete beds

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Model A - based on a simplified scenario where the background geologic  
%           composition is  Fine silty claystone, punctuated by a) discrete  
%           coarse beds of sand of various thickness (top) and b) by
%           discrete paired beds of silty claystone and sandstone 
%
% Define Sedimentary composition %
    % Sandstone = 3   Silty Claystone = 2  Fine silty claystone = 1;



% Define the number of simulated cuttings fragments produced at each depth
n= 10000; 


    % -------------------%
    % Define the Hypothetical Downhole Lithologic Compositions
    % -------------------%
    ObsB = ones(length(Z),n); % make a matrix of the background lithology
    
    %Make a 1m sandy bed at Z=26 meters
    ObsB(26,:) = 3;
    
    %Make a 3m sandy bed from Z=50-52 meters
    ObsB(50:52,:) = 3;
    
    %Make a 8m sandy bed from Z=81-88 meters
    ObsB(81:88,:) = 3;
    
    %Make a 15m sandy bed from Z=116-130 meters
    ObsB(116:130,:) = 3;
    
    %Make a 20m sandy bed from Z=156-175 meters
    ObsB(156:175,:) = 3;


    %Make a 1m silty clay bed at Z=201 meters
    ObsB(201,:) = 2;
    %Make a 1m sandy bed at Z=202 meters
    ObsB(202,:) = 3;


    %Make a 3m silty clay bed from Z=225-227 meters
    ObsB(225:227,:) = 2;
    %Make a 3m sandy bed from Z=228-230 meters
    ObsB(228:230,:) = 3;
    % -------------------%


    % Tabulate the total % of 1s, 2s, 3s, in each depth interval in the
    % "known" Hypothetical Composition model
    for i=1:Z(end)
        ObsB_sandstone(i) = length(find(ObsB(i,:) ==3))/n*100;          % find all #3s (Sandstone)
        ObsB_silty_claystone(i) = length(find(ObsB(i,:) ==2))/n*100;      % find all #2s (Sintly Claystone)
        ObsB_fine_silty_claystone(i) = length(find(ObsB(i,:) ==1))/n*100;    % find all #1s (Fine Silty Claystone) 
    end
    % -------------------%


% Simulate mixing by pulling a random sample of cuttings from each depth interval in the mixed
% interval, with the number of samples at each depth interval determined by 
% the percent contribution defined in the mixing model

    n_cuttings=round(MixingModel.*n); % define the number of cuttings that should be pulled from each depth within the mixing interval
    ModelB = zeros(size(ObsB)); % make empty place holder matrix
    temp = []; %make empty place holder matrix

for i=interval:Z(end)
        j=[i-interval+1:i];
    for k = 1:length(j)
        temp = [temp, randsample(ObsB(j(k),:), n_cuttings(k))];
    end
 ModelB(i,:) = temp;
 temp = [];
end

% Find the total # of 1s, 2s, 3s, in each depth interval in the Mixed
% Cuttings pulled above

for i=1:Z(end)
    ModelB_sandstone(i) =  length(find(ModelB(i,:) ==3))/n*100;          % find all #3s
    ModelB_silty_claystone(i) = length(find(ModelB(i,:) ==2))/n*100;      % find all #2s
    ModelB_fine_silty_claystone(i) = length(find(ModelB(i,:) ==1))/n*100;    % find all #1s
end

% -------------------%
% PLOTS - compare observed and mixing model data
% -------------------%

figure; set(gcf, 'Position',  [100, 100, 1600, 800]); % change figure window size

% Hypothetical Known Composition
histdata =  [ObsB_sandstone(interval:end)', ObsB_silty_claystone(interval:end)',ObsB_fine_silty_claystone(interval:end)'];
subplot(1,9,1); hold on
h=barh(Z(interval:end),histdata ,'stacked', 'BarWidth', 1, 'EdgeColor',[120,120,120]/265);
xlabel('% Occurrence'); ylabel ('Model Depth (m)'); title (["Hypothetical Lithologic", "Composition"]); ytickangle(90) %add labels
xlim([0,100]);
ax = gca; ax.YDir = 'reverse'; set(gca, 'XAxisLocation', 'top');  %manage axis properties
legend(h, 'Sandstone', 'Silty Claystone', 'Fine Silty Claystone', 'Location','southoutside') 
h(1).FaceColor = [180,170,0]/256; %set sandstone bar color to mustard yellow
h(2).FaceColor = [95, 75, 60]/256; %set silty claystone bar color to brown
h(3).FaceColor = [165, 135, 120]/256; %set fine silty claystone bar color to tan
axP=get(gca, 'Position'); set(gca, 'Position', axP);set(gca,'TickDir','out');  set(gca,'TickLength',[0.005, 0.005])

% Simulated Recovered Cuttings, every 1 m
histdata =  [ModelB_sandstone(interval:end)', ModelB_silty_claystone(interval:end)',ModelB_fine_silty_claystone(interval:end)'];
subplot(1,9,2); hold on
h = barh(Z(interval:end),histdata ,'stacked', 'BarWidth', 1, 'EdgeColor',[120,120,120]/265);
xlabel('% Occurrence'); ylabel ('Model Depth (m)'); title(["Simulated Recovered","Cuttings, every 1m"]); ytickangle(90) %add labels
xlim([0,100]);
ax = gca; ax.YDir = 'reverse'; set(gca, 'XAxisLocation', 'top'); %manage axis properties
legend(h, 'Sandstone', 'Silty Claystone', 'Fine Silty Claystone', 'Location','southoutside')
h(1).FaceColor = [180,170,0]/256; %set sandstone bar color to mustard yellow
h(2).FaceColor = [95, 75, 60]/256; %set silty claystone bar color to brown
h(3).FaceColor = [165, 135, 120]/256; %set fine silty claystone bar color to tan
axP=get(gca, 'Position'); set(gca, 'Position', axP);set(gca,'TickDir','out');  set(gca,'TickLength',[0.005, 0.005])

% Simulated Recovered Cuttings, every 10 m
    % Extract the data from the output model from every 10m depth interval
    histdata10=histdata;
    for i=1:size(histdata,1)
        if rem(i-1,10)>0
            histdata10(i,:)=[0,0,0];
        end
    end

subplot(1,9,3); hold on
h = barh(Z(interval:end),histdata10 ,'stacked', 'BarWidth', 2, 'EdgeColor',[120,120,120]/265);
xlabel('% Occurrence'); ylabel ('Model Depth (m)'); title(["Simulated Cuttings","Obervations, every 10m"]); ytickangle(90) %add labels
xlim([0,100]);
ax = gca; ax.YDir = 'reverse'; set(gca, 'XAxisLocation', 'top'); %manage axis properties
legend(h, 'Sandstone', 'Silty Claystone', 'Fine Silty Claystone', 'Location','southoutside')
h(1).FaceColor = [180,170,0]/256; %set sandstone bar color to mustard yellow
h(2).FaceColor = [95, 75, 60]/256; %set silty claystone bar color to brown
h(3).FaceColor = [165, 135, 120]/256; %set fine silty claystone bar color to tan
axP=get(gca, 'Position'); set(gca, 'Position', axP); set(gca,'TickDir','out');  set(gca,'TickLength',[0.005, 0.005])

%------------------------------------------------



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Model B - discrete fault zones of various thickness and fault fabric intensity

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Model B - Simulate fault zones of various thickness, and various fault rock density. 
%           In this model, Fault zones are marked by the presence of cuttings with scaley fabric 
%           loosely mimicking a fault zone in IODP Site C0002, from 2450 to 2850 mbsf. 
%           Because fault zones and damage can be distributed, and not every cutting 
%           from a fault zone necessarily will contain fault rocks, this model includes 
%           both fault zones where 100% of the cuttings have scaley fabric (which
%           may represent cases where fault fabric spacing is less than cuttings diameter,
%           and those where only 30% of cuttings have scaley fabrics, (which may represent
%           cases where fault fabric spacing is greater than cuttings diameter.

% Define Fault rocks  %
    % scaley fabric = 1   No fault rock = 0;


% Define the number of simulated cuttings fragments produced at each depth
n= 10000; 


    % -------------------%
    % Define the Hypothetical Downhole Fault Compositions
    % -------------------%
    ObsD = zeros(length(Z),n); % Make matrix of 


    % Define different ways to get to 10% cuttings with fault rock %

        %Make a 1m wide fault zone at Z=20 meters, where 100% of retrieved
        %cuttings have fault rock (scaley fabric)
        ObsD(20,1:n) = 1;
        
        %Make a 2m wide fault zone from Z=50-52 meters, containing where 100% of retrieved
        %cuttings have fault rock (scaley fabric)
        ObsD(50:51,1:n) = 1;
        
        %Make a 5m wide fault zone from Z=80-84 meters, containing where 30% of retrieved
        %cuttings have fault rock (scaley fabric)
        ObsD(80:84,1:n*.3) = 1;



     % Define different ways to get 30% cuttings with fault rock %%%%%

        %Make a 5m wide fault zone from Z=120-125 meters, where 100% of retrieved
        %cuttings have fault rock (scaley fabric)
        ObsD(120:124,1:n) = 1;
        
        %Make a 20m wide fault zone from Z=110-113 meters,  where 30% of retrieved
        %cuttings have fault rock (scaley fabric)
        ObsD(160:179,1:n*0.3) = 1;
        
        % make a distributed fault zone, where the entire 20m fault zone contains
        % three 3m concentrated shear zones with scaley fabrics in it, separated by
        % zones with no fault rock (e.g. Rowe et al., 2013, Geology)
        
        ObsD(210:212,1:n) = 1;
        ObsD(220:222,1:n) = 1;
        ObsD(230:232,1:n) = 1;
     % -------------------%



% Tabulate the total % of 1s, 2s, 3s, in each depth interval, in the
% "known" Hypothetical downhole composition
    for i=1:Z(end)
        ObsD_fault(i) = length(find(ObsD(i,:) ==1))/n*100; % find all #1s = fault rock
    end

% Simulate mixing by pulling a random sample of cuttings from each depth interval in the mixed
% interval, with the number of samples at each depth interval determined by 
% the percent contribution in the mixing model

  n_cuttings=round(MixingModel.*n); % define the number of cuttings that should be pulled from each depth within the mixing interval
  ModelD = zeros(size(ObsD)); %make empty place holder matrix
  temp = []; %make empty place holder matrix

for i=interval:Z(end)
       j=[i-interval+1:i];
    for k = 1:length(j)  
        temp = [temp, randsample(ObsD(j(k),:), n_cuttings(k))];
    end
 ModelD(i,:) = temp;
 temp = [];
end



% Tabulate the total % of 1s, 2s, 3s, in each depth interval in the Mixing
% Model Simulation
    for i=1:Z(end)
        ModelD_fault(i) = length(find(ModelD(i,:) ==1))/n*100; % find all #1s = fault rock
    end



% -------------------%
% PLOTS - compare observed and mixing model data
% -------------------%

% Hypothetical Known Composition
histdata =  [ObsD_fault(interval:end)'];
subplot(1,9,4); hold on
h=barh(Z(interval:end),histdata ,'stacked', 'BarWidth', 0.9, 'EdgeColor','none');
xlabel('% Occurrence'); ylabel ('Model Depth (m)'); title (["Hypothetical Faulted", "Intervals"]); ytickangle(90) %add labels
xlim([0,100]);
ax = gca; ax.YDir = 'reverse'; set(gca, 'XAxisLocation', 'top');  %manage axis properties
legend(h, 'Scaley Fabric', 'Location','southoutside') 
h(1).FaceColor = [0.2,0.2,0.2]; %set sandstone bar color to mustard yellow
axP=get(gca, 'Position'); set(gca, 'Position', axP); set(gca,'TickDir','out');  set(gca,'TickLength',[0.005, 0.005])

% Simulated Recovered Cuttings, every 1 m
histdata =  [ModelD_fault(interval:end)'];
subplot(1,9,5); hold on
h=barh(Z(interval:end),histdata ,'stacked', 'BarWidth', 0.9, 'EdgeColor','none');
xlabel('% Occurrence'); ylabel ('Model Depth (m)'); title(["Simulated Recovered","Cuttings, every 1m"]); ytickangle(90) %add labels
xlim([0,100]);
ax = gca; ax.YDir = 'reverse'; set(gca, 'XAxisLocation', 'top');  %manage axis properties
legend(h, 'Scaley Fabric', 'Location','southoutside') 
h(1).FaceColor = [0.2,0.2,0.2]; %set sandstone bar color to mustard yellow
axP=get(gca, 'Position'); set(gca, 'Position', axP); set(gca,'TickDir','out');  set(gca,'TickLength',[0.005, 0.005])


% Simulated Recovered Cuttings, every 10 m
    % Extract the data from the output model from every 10m depth interval
    histdata10=histdata;
    for i=1:size(histdata,1)
        if rem(i-1,10)>0
    histdata10(i)=[0];
        end
    end

subplot(1,9,6); hold on
h=barh(Z(interval:end),histdata10 ,'stacked', 'BarWidth', 2, 'EdgeColor','none');
xlabel('% Occurrence'); ylabel ('Model Depth (m)'); title(["Simulated Cuttings","Obervations, every 10m"]); ytickangle(90) %add labels
xlim([0,100]); %xlim([0,40]);
ax = gca; ax.YDir = 'reverse'; set(gca, 'XAxisLocation', 'top');  %manage axis properties
legend(h, 'Scaley Fabric', 'Location','southoutside') 
h(1).FaceColor = [0.2,0.2,0.2]; %set sandstone bar color to mustard yellow
axP=get(gca, 'Position'); set(gca, 'Position', axP); set(gca,'TickDir','out');  set(gca,'TickLength',[0.005, 0.005])


%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Model C - Mineral or Elemental weight percentages

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Model C - Simulates a down hole variable weight percent composition
%           of an element or mineral, as may be determined from XRF or XRD. The Total composition in 
%           each depth bin is summed, assuming that multiple cuttings fragments 
%           were amalgamated in the wt% composition analysis. This bulk averaging
%           is based on Exp 358 methods for XRD, XRF analyses: 
%              "After lithology description and removing iron contaminants originating
%               from drilling tools and casing, aliquots (23 cm3) of >4 mm intact washed cuttings handpicked by the 
%               lithology group were vacuum dried and ground for X-ray diffraction (XRD), X-ray fluorescence (XRF), and 
%               organic geochemistry analyses (total organic carbon [TOC], total carbon [TC], and total nitrogen [TN])."
%               http://publications.iodp.org/proceedings/358/102/358_102.html



    % -------------------%
    % Define the Hypothetical Downhole Fault Compositions
    % -------------------%
 
    % Define sets of beds 10m thick of alternating high and low percent composition. 
        alternatingbeds1 = [ones(20,1)*4; ones(10,1)*17; ones(10,1)*3; ones(10,1)*13; ones(10,1)*8];  
    % Define sets of beds 5m thick of alternating high and low percent composition. 
        alternatingbeds2 = [ones(7,1)*8; ones(5,1)*17; ones(5,1)*3; ones(5,1)*13; ones(5,1)*6; ones(6,1)*10];
    % Define three graded beds, each 40m thick, grading from high, concentration  at its top to lo concentration at its base. 
    % Then add in the alternating beds defined above. 
        ObsA1 = [ones(23,1)*12; linspace(12,8,40)'; linspace(14,7,40)'; linspace(17,4,40)'; alternatingbeds1; alternatingbeds2; ones(14,1)*10];

    % -------------------%


    % Simulate mixing my averaging the composition of cuttings in the depth
    % interval, scaled by to contribution from each depth interval in the
    % mixing model
        for i=interval:Z(end)
            ModelA1(i) = sum(ObsA1(i+1-interval:i).*MixingModel);
        end


% -------------------%
% PLOTS - compare observed and mixing model data
% -------------------%

% Hypothetical Known Composition
subplot(1,9,7); 
h(1) = plot(ObsA1(interval:end), Z(interval:end), '.-k');
xlabel('Total Clay Wt %'); ylabel ('Model Depth (m)'); title(["Hypothetical Composition", "and Recovered Cuttings"]); ytickangle(90)
ax = gca; ax.YDir = 'reverse'; set(gca, 'XAxisLocation', 'top');
xlim([0,20]); ylim([interval,Z(end)]);
legend (h(1), 'Hypothetical Composition', 'Location','southoutside');
 axP=get(gca, 'Position'); set(gca, 'Position', axP);set(gca,'TickDir','out'); set(gca,'TickLength',[0.005, 0.005])

% Simulated Recovered Cuttings, every 1 m
subplot(1,9,8); 
h(2) = plot(ModelA1(interval:end), Z(interval:end), '.-r'); % if you described cuttings every 1 m
xlabel('Total Clay Wt %'); ylabel ('Model Depth (m)'); title(["Hypothetical Composition", "and Recovered Cuttings"]); ytickangle(90)
ax = gca; ax.YDir = 'reverse'; set(gca, 'XAxisLocation', 'top');
xlim([0,20]); ylim([interval,Z(end)]);
legend (h(2), 'Simulated Recovered Cuttings, every 1m', 'Location','southoutside');
axP=get(gca, 'Position'); set(gca, 'Position', axP);set(gca,'TickDir','out'); set(gca,'TickLength',[0.005, 0.005])

% Simulated Recovered Cuttings, every 10 m
subplot(1,9,9); hold on;
h = plot(ModelA1(interval:10:end), Z(interval:10:end), '.-b', 'MarkerSize',10); % if we only describe cuttings every 10 m
xlabel('Total Clay Wt %'); ylabel ('Model Depth (m)'); title(["Simulated Cuttings","Obervations, Every 10m"]); ytickangle(90)
ax = gca; ax.YDir = 'reverse'; set(gca, 'XAxisLocation', 'top');
xlim([0,20]); ylim([interval,Z(end)]);
legend (h, 'Simulated Observations, every 10m', 'Location','southoutside');
axP=get(gca, 'Position'); set(gca, 'Position', axP); set(gca,'TickDir','out'); set(gca,'TickLength',[0.005, 0.005])


%------------------------------------------------


