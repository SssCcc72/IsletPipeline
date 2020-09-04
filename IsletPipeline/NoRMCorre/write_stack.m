function  write_stack(img0,filetop,filesuf,bit)
%WRITE_TIF_UINT16 此处显示有关此函数的摘要
%   use tagstruct write to tif file  uint16!!
% img = int16(img0);
img = img0;
tagstruct.ImageLength = size(img,1);
tagstruct.ImageWidth = size(img,2);
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample = bit;
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
    imwrite(img(:,:,i),img_path0,'WriteMode','append','Compression','none');
end
end

