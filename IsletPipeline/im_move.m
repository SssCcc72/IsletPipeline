function J = im_move( I,a,b )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%a,bΪƽ������IΪԭͼ��JΪƽ�ƺ�ͼ��
[M,N,G]=size(I);
% I=im2double(I);
J=uint16(ones(M,N,G))*min(min(I));
for i=1:M
    for j=1:N
        if((i+a)>=1&&(i+a)<=M&&(j+b)>=1&&(j+b)<=N)  %�ж�ƽ�ƺ������Ƿ񳬹���Χ
            J(i+a,j+b,:)=I(i,j,:);
        end
    end
    
end