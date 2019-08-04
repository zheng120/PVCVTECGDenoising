clear()
PATH= 'path includes raw ECG data';
OutPutFilePath = 'output path to save ECG data after denoising';
OutPcitureFilePath = 'output pictures for vildation';

SourceFileList = dir(PATH);
SourceFileList = struct2table(SourceFileList);
SourceFileList = table2array(SourceFileList(:,1));
SourceFileList = SourceFileList(3:end);

for i=1:length(SourceFileList)
    DataFileName = strcat(PATH,SourceFileList{i});
    RawDataDT = readtable(DataFileName,'ReadVariableNames',true);
    DataFile = table2array(RawDataDT);
    [rows,~] = size(DataFile);
    DenoisingData= zeros(rows,12);
    for j=1:12        
        DenoisingData(:,j) =wdenoise(DataFile(:,j),6, ...
                            'Wavelet', 'coif5', ...
                            'DenoisingMethod', 'SURE', ...
                            'ThresholdRule', 'Soft', ...
                            'NoiseEstimate', 'LevelDependent');
    end 
OutputDT1  = array2table(DenoisingData);
OutputDT1.Properties.VariableNames =RawDataDT.Properties.VariableNames;
OutputfileName =strcat(OutPutFilePath, SourceFileList{i});
writetable(OutputDT1,OutputfileName);
end
