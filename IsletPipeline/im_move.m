function J = im_move( I,a,b )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%a,b为平移量，I为原图像，J为平移后图像
[M,N,G]=size(I);
% I=im2double(I);
J=uint16(ones(M,N,G))*min(min(I));
for i=1:M
    for j=1:N
        if((i+a)>=1&&(i+a)<=M&&(j+b)>=1&&(j+b)<=N)  %判断平移后行列是否超过范围
            J(i+a,j+b,:)=I(i,j,:);
        end
    end
    
end