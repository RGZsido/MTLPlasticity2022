%Written by Luisa Kurth and Rachel Zsido

clear all, close all 

%%%PREPARE ROI

%load mask 
cd / %change to directory containing mask
path_mask = "" %mask from Taliarch; resized beforehand
MX = niftiread(path_mask)

%create index with mask so that it can be applied to CBF-map 
ind = find(MX > 0)



%%%APPLY ROI TO EACH CBF MAP, CALCUALTE MEAN AND EXPORT EXCEL FILE

%create excels to store data per timepoint 
cd / %change to main directory

timepoints = ["M", "PREO", "O", "POSTO", "MIDL", "PREM"]

for i=1:length(timepoints)
    
    header = "Mean_CBF_" + timepoints(i)
    matrix = ["Participant", header ]
    filename = timepoints(i) + '.xls'
    writematrix(matrix, filename)
    
end


paths = ["","", "", "" ,"", ""] %insert paths to six timepoint directories

%analyse all niftis within each timefolder:
for i=1:length(paths)
  
    get_path= paths(i)
    filePattern = fullfile(get_path, '*_cbf.nii'); %get each cbf image
    theFiles = dir(filePattern); 

    %for each nifit within timefolder i:
    for k = 1 : length(theFiles) 
        baseFileName = theFiles(k).name;
        fullFileName = fullfile(theFiles(k).folder, baseFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);

        %read in nifti
        VX = niftiread(fullFileName)

        %extract array of CBF values within ROI/index
        CBF_values_in_ROI = VX(ind)

        %cacluclate mean value of that array
        CBF_mean = mean(CBF_values_in_ROI)


        %get participant id to store with value
        tag = baseFileName

        pat = "MCP" + digitsPattern(2) %creates a search pattern

        tag = extract(tag, pat) %apply and extract the search pattern to the filename 


        %append participant ID and CBF_mean_value to the timepoint-excel  
        matrix_to_append = [tag, CBF_mean]
         
        match = wildcardPattern + "/" %use path name and delete all characters all before timpoint
        name_excel = erase(paths(i),match)
        name_excel = name_excel + ".xls"
        
        writecell(matrix_to_append,name_excel,'WriteMode','append')

    end

end


%%%MERGE INTO ONE FINAL EXCEL FILE CONTAININNG MEAN CBF-VALUES PER TIMEPOINT BY
%PARTICIPANT

%read in each excel as table
cd %change to main directory

for i=1:length(timepoints)
    
    variablename = "data" + timepoints(i)
    filename = timepoints(i) + '.xls'
    
    variablename = readtable(filename)
end  


%merge by outerjoin. This will add missings if no matching key is found. 
T= outerjoin(dataM, dataPREO, "MergeKeys", true)
T= outerjoin(T, dataO, "MergeKeys", true)
T= outerjoin(T, dataPOSTO, "MergeKeys", true)
T= outerjoin(T, dataMIDL, "MergeKeys", true)
T= outerjoin(T, dataPREM, "MergeKeys", true)


%EXPORT FINAL DATASET
writetable(T, "CBFMeans_Final.xls")