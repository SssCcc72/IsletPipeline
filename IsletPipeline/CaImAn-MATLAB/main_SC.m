clc;clear;close all;
dataFile = 'D:\Image\3.0-��ϼ����\CNMF����';
mainFile = dir(dataFile);
for i = 3:length(mainFile)
    subFile = [dataFile,'/',mainFile(i).name];
    nam = subFile;
    demo_script_SC1(nam);
%     subData = dir(subFile); 
%     for j = 3:length(subData)
%         File = [subFile,'/',subData(j).name];
%         disp(File);
%         demo_linuxFun(File);
%     end
end