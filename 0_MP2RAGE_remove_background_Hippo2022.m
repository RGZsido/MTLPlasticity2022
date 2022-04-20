%Adapted from original code from https://github.com/JosePMarques/MP2RAGE-related-scripts
%O'Brien KR, Kober T, Hagmann P, Maeder P, Marques J, Lazeyras F, et al. (2014): Robust T1-weighted structural brain imaging and morphometry at 7T using MP2RAGE. PLoS ONE. 9:e99676.
%Adapted by Rachel Zsido

clear;
clc;

addpath(genpath('.'))
MainFolder = ''; %insert path to main directory
DATA = fullfile(MainFolder, ''); %insert path to directory containing MP2RAGE niftis

subjList = dir(fullfile(DATA, 'MCP*'));
nSubjects = length(subjList);

%after testing regularization factor for several participants, choose an
%appropriate factor and loop through all participants. For more info on the
%regularization process, see O'Brien et al., 2014

for idx = 1 : nSubjects
    
dayList = dir(fullfile(DATA, subjList(idx).name));
nDay = length(dayList);
 for ij = 3:nDay
     
MP2RAGE.filenameUNI=fullfile(DATA, subjList(idx).name, dayList(ij).name, 'anat', 'MP2RAGE', 'MP2RAGE_UNI_Images.nii'); %standard MP2RAGE T1w image;
MP2RAGE.filenameINV1=fullfile(DATA, subjList(idx).name, dayList(ij).name, 'anat', 'MP2RAGE', 'MP2RAGE_INV1.nii'); %Inversion Time 1 MP2RAGE T1w image;
MP2RAGE.filenameINV2=fullfile(DATA, subjList(idx).name, dayList(ij).name, 'anat', 'MP2RAGE', 'MP2RAGE_INV2.nii'); %Inversion Time 2 MP2RAGE T1w image;
MP2RAGE.filenameOUT=fullfile(DATA, subjList(idx).name, dayList(ij).name, 'anat', 'MP2RAGE', 'MP2RAGE_denoised.nii'); %image without background noise;
 
regularization = 5 ; %insert appropriate regularization factor here
[MP2RAGEimgRobustPhaseSensitive]=RobustCombination(MP2RAGE,regularization)
 end 


end