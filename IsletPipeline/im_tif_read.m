function [tif_raw] = im_tif_read(tifname,read_num,off_set,tif_raw)
%IM_TIF_READ 此处显示有关此函数的摘要
%   此处显示详细说明
h=waitbar(0,'Reading Image, Please wait...');
% source = 'raw_tif\';
% tif_path = [source,tifname,'.tif'];
tif_path = tifname;
% Info = imfinfo(tif_path);
% img_num = size(Info,1);
if off_set == 0
    istart = 1;
else 
    istart = off_set+1;
end
iend = read_num;
for i =istart:iend
    tif_raw(:,:,i) =single(imread(tif_path,i));
    waitbar(i/iend,h,'Reading Image, Please wait...');
end
close(h);
end

