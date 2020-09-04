function  write_tif_uint16(img0,filetop,filesuf)
%WRITE_TIF_UINT16 此处显示有关此函数的摘要
%   此处显示详细说明
% img = int16(img0);
img = img0;
tagstruct.ImageLength = size(img,1);
tagstruct.ImageWidth = size(img,2);
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample = 16;
tagstruct.SamplesPerPixel = 1;
tagstruct.RowsPerStrip = 512;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.SampleFormat = Tiff.SampleFormat.UInt;
tagstruct.Software = 'MATLAB';


if(ndims(img) == 3)
    n = size(img,3);
else
    n = 1;
end
img_path0 = [filetop,'\',filesuf,'.tif'];
for i =1:n
%     a = img(:,:,i);
%     img_path=[filetop,'\seq',num2str(i),'.tif'];
%     t = Tiff(img_path,'w');
%     setTag(t,tagstruct)
%     write(t,img(:,:,i));
%     img_path0 = [filetop,'\',filesuf,'.tif'];
    imwrite(img(:,:,i),img_path0,'WriteMode','append','Compression','none');
end
end

