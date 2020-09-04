function  Step3_8_GenerateFijiRoi(Fusion_temp,Path,Name)
%%
%Step3_8_GenerateFijiRoi - FUNCTION Write ImageJ ROI.
%
%Usage: Generate Fiji ROI documents from yeastbow Result
%
% need StandardFijiROI.mat and Output.mat 
%%

% Step1: read standard Fiji ROI document
load StandardFijiROI.mat

% Step2: read yeastbow output

Yeastbow_ROI  = ROIs; % Copy standard Fiji ROI
% roi_width = 6;
m=0;
    % Step3.2: Revise Fiji ROI for Image_i: name, boundary,coordinates
    for i=1:length(Fusion_temp)
                       m = m+1;
        Yeastbow_ROI(m)  = Yeastbow_ROI(1); 
        
       T      = Fusion_temp(i).T2_Real;
       signal = Fusion_temp(i).signal;
            X = Fusion_temp(i).x;
            Y = Fusion_temp(i).y;
     
      for s =1:length(T)   
       Yeastbow_ROI{m}.strName        = [num2str(round(T(s))) '-' num2str(round(X(1))) '-' num2str(round(Y(1))) '-' num2str(round(signal(s)))];
%         Yeastbow_ROI{m}.strName       = [num2str(m) '_t_' num2str(T(s)) '_s_' num2str(signal(s))];
        Yeastbow_ROI{m}.mnCoordinates = [X' Y'];
        Yeastbow_ROI{m}.vnRectBounds  = [min(Yeastbow_ROI{m}.mnCoordinates(:,2)) min(Yeastbow_ROI{m}.mnCoordinates(:,1)) max(Yeastbow_ROI{m}.mnCoordinates(:,2)) max(Yeastbow_ROI{m}.mnCoordinates(:,1))];
        m=m+1;
       Yeastbow_ROI(m)  = Yeastbow_ROI(1); 
      end
        
    end

    % Step3.2: write Fiji ROI for Image_i
    
    WriteImageJROI(Yeastbow_ROI,[Path,'\isletRoi'],Name)

%     imwrite(imadjust(Output(i).Image),[Path, 'YeastbowROI/', File(i).name(1:end-4),'.png'])
    


