clc
clear all
gcp;
addpath('CaImAn-MATLAB');
addpath('NoRMCorre');
%% path 是需要修改的地方
path = 'D:\Image\1.0-胰岛数据';

%% 数据读写参数
rigW = 0; % 0为不存储刚性配准结果，1表示存储刚性配准结果
rigR = 1; % 0为只运行刚性配准程序，后面的pipeline不运行了;1表示刚性配准完成后继续接下来的pipeline
noRigW = 1;% 0为不保存非刚性配准的结果，1表示保存非刚性配准的结果（通常这个结果是我们需要的，目前无需改动，恒为1）
noRigR = 1;% 0为程序只运行到非刚性配准，剩下的就不做了;1表示程序运行完非刚性配准后继续接下来的pipeline
cRongR = 1;% 0为不运行细胞识别的程序，1表示运行该程序。

%% 非刚性配准参数
grid_size = [32,32];    % 网格大小
mot_uf    = 4;          % pathc的上采样参数     可参考的参数： 4 8 
bin_width = 50;         % 与参考图像更新有关的参数  可参考的参数： [20,150] 图像抖动越厉害，值越小越好
max_shift = 12;         % 最大刚性位移量           可参考的参数： [4,20]   图像越稳定，这个值越小
max_dev   = 8;          % 刚性位移中patch的最大偏移量 可参考的参数： [4,20]   图像越稳定，这个值越小。
us_fac    = 50;         % 亚像素配准的上采样参数
init_batch = 50;        % 初始参考图像计算相关的参数 可参考的参数： [20,150] 图像抖动越厉害，值越小越好
iter      = 1;          % 配准迭代次数          可参考的参数： 1 2 3 4 5  配准结果差的话可增加迭代次数

%% 细胞识别参数
K = 40;                                % 设定初始ROI个数                               [40,150] 
p=1;                                   % 自回归参数                                     1 2
tau=7;                                % 设定的细胞（ROI）的大小（半径）---像素点为单位   [5,15]
merge_thr=0.10;                        % ROI合并的参数  0.8                            (0,1]
nb=1;                                  % 有几个背景成分                                 1 2
min_SNR=0.01;                          % 信号的最低信噪比 3                               (0,10]
space_thresh=0.1;                      % 与空间不同成分合并有关的参数 0.5                (0,1]
cnn_thr=0.01;                          % CNN分类器阈值  0.2                            （0,1]

%% pipeline run
fileDir = dir(path);
for i = 3 :length(fileDir)
    subpath = fileDir(i).folder;
    subname = fileDir(i).name;
    subfile = dir([subpath,'\',subname,'\*raw.tif']);
    for j = 1:length(subfile)
        disp(subfile(j).name);
        subTiff = [subfile(j).folder,'\',subfile(j).name];
        info = imfinfo(subTiff);
        Width = info(1).Width;
        Height = info(1).Height;
        frames = size(info,1);
%         im_tif_3D = zeros(Width,Height,frames);
%         im_tif_ad = zeros(Width,Height,frames);
        Y         = single(zeros(Width,Height,frames));
        %% 配准（刚性+非刚性）
        [Y] = im_tif_read(subTiff,frames,0,Y);
        Y = Y - min(min(min(Y)));
        n=frames;
        InitY = Y(:,:,1);   % 不能直接把Y（:,:,1）放到其中，会报错
        parfor ii = 2:n
            [dx,dy,zero_mark] = im_corr(InitY,Y(:,:,ii),'adjust');
            Y(:,:,ii) = im_move(Y(:,:,ii),dx,dy);
        end
        if (rigW == 1)
            write_tif_uint16(Y,subfile(j).folder,[subfile(j).name(1:end-4),'_Cor']);
        end
        if (rigR == 0)
            continue
        end
        Y = single(Y);                 % convert to single precision
        T = size(Y,ndims(Y));
        Ymin = min(Y(:));
        Y = Y - min(Y(:));
            %% now try non-rigid motion correction (also in parallel)
        options_nonrigid = NoRMCorreSetParms('d1',size(Y,1),'d2',size(Y,2),'grid_size',grid_size,'mot_uf',mot_uf,'bin_width',bin_width,'max_shift',max_shift,'max_dev',max_dev,'us_fac',us_fac,'init_batch',init_batch,'iter',iter);
        tic; [Y,shifts2,template2,options_nonrigid] = normcorre_batch(Y,options_nonrigid); toc
        write_stack(uint16(Y),subfile(j).folder,[subfile(j).name(1:end-4),'-NoRMC'],16); 
       histeq
        %% 细胞识别
        if(cRongR == 1)
%             Y = Y;
            roi_Name = subfile(j).name(1:end-4);
            roi_Path = subfile(j).folder;
            cell_Recong_CaImAn;
        end
    end
end