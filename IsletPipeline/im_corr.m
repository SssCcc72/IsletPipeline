function [dx,dy,zero_mark] = im_corr(im1,im2,adjust)
%IM_CORR 此处显示有关此函数的摘要
%   此处显示详细说明
if(strcmp(adjust,'adjust'))
       im1 = single(imadjust(uint16(im1)));
       im2 = single(imadjust(uint16(im2)));
end
im1_fft = fft2(im1);
im2_fft = fft2(im2);
im_corr = ifft2(im1_fft.*conj(im2_fft));
im_corr = fftshift(im_corr);
[x, y] = find(im_corr == max(im_corr(:)));
m = max(im_corr(:));
dx = x - round(size(im1, 1) / 2 - .5) - 1;
dy = y - round(size(im1, 2) / 2 - .5) - 1;
zero_mark = 1;
if length(dx)>1
    dx = 0;dy = 0;
    zero_mark = 0;
end
if(abs(dx)>=180||abs(dy)>=80) %200 200
    dx = 0;
    dy = 0;
    zero_mark = 1;
end
end

