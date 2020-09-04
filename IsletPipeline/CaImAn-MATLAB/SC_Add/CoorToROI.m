for i = 1:size(Coor,1)
    Fusion_temp(i).T2_Real = i;
    Fusion_temp(i).signal = i;
    Fusion_temp(i).x = Coor{i}(1,:);
    Fusion_temp(i).y = Coor{i}(2,:);
end
    Step3_8_GenerateFijiRoi(Fusion_temp,roi_Path,roi_Name);