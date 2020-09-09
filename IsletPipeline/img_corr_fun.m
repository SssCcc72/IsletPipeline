function [im_reg] = img_corr_fun(im,im_ad,frames)
%IMG_CORR_FUN 此处显示有关此函数的摘要
%   此处显示详细说明
n=frames;
im_reg = single(zeros(size(im_ad(:,:,1),1),size(im_ad(:,:,1),2),n));
tic
im_reg(:,:,1) = im(:,:,1); 
move_mark = zeros(n,3);
parfor i = 2:n
    [dx,dy,zero_mark] = im_corr(im_ad(:,:,1),im_ad(:,:,i));
    im_reg(:,:,i) = im_move(im(:,:,i),dx,dy);
end
toc
end

