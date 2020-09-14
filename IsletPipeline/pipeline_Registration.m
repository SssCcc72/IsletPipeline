clc
clear all
gcp;
addpath('CaImAn-MATLAB');
addpath('NoRMCorre');
%% path ����Ҫ�޸ĵĵط�
path = 'D:\Image\1.0-�ȵ�����';

%% ���ݶ�д����
rigW = 0; % 0Ϊ���洢������׼�����1��ʾ�洢������׼���
rigR = 1; % 0Ϊֻ���и�����׼���򣬺����pipeline��������;1��ʾ������׼��ɺ������������pipeline
noRigW = 1;% 0Ϊ������Ǹ�����׼�Ľ����1��ʾ����Ǹ�����׼�Ľ����ͨ����������������Ҫ�ģ�Ŀǰ����Ķ�����Ϊ1��
noRigR = 1;% 0Ϊ����ֻ���е��Ǹ�����׼��ʣ�µľͲ�����;1��ʾ����������Ǹ�����׼�������������pipeline
cRongR = 1;% 0Ϊ������ϸ��ʶ��ĳ���1��ʾ���иó���

%% �Ǹ�����׼����
grid_size = [32,32];    % �����С
mot_uf    = 4;          % pathc���ϲ�������     �ɲο��Ĳ����� 4 8 
bin_width = 50;         % ��ο�ͼ������йصĲ���  �ɲο��Ĳ����� [20,150] ͼ�񶶶�Խ������ֵԽСԽ��
max_shift = 12;         % ������λ����           �ɲο��Ĳ����� [4,20]   ͼ��Խ�ȶ������ֵԽС
max_dev   = 8;          % ����λ����patch�����ƫ���� �ɲο��Ĳ����� [4,20]   ͼ��Խ�ȶ������ֵԽС��
us_fac    = 50;         % ��������׼���ϲ�������
init_batch = 50;        % ��ʼ�ο�ͼ�������صĲ��� �ɲο��Ĳ����� [20,150] ͼ�񶶶�Խ������ֵԽСԽ��
iter      = 1;          % ��׼��������          �ɲο��Ĳ����� 1 2 3 4 5  ��׼�����Ļ������ӵ�������

%% ϸ��ʶ�����
K = 40;                                % �趨��ʼROI����                               [40,150] 
p=1;                                   % �Իع����                                     1 2
tau=7;                                % �趨��ϸ����ROI���Ĵ�С���뾶��---���ص�Ϊ��λ   [5,15]
merge_thr=0.10;                        % ROI�ϲ��Ĳ���  0.8                            (0,1]
nb=1;                                  % �м��������ɷ�                                 1 2
min_SNR=0.01;                          % �źŵ��������� 3                               (0,10]
space_thresh=0.1;                      % ��ռ䲻ͬ�ɷֺϲ��йصĲ��� 0.5                (0,1]
cnn_thr=0.01;                          % CNN��������ֵ  0.2                            ��0,1]

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
        %% ��׼������+�Ǹ��ԣ�
        [Y] = im_tif_read(subTiff,frames,0,Y);
        Y = Y - min(min(min(Y)));
        n=frames;
        InitY = Y(:,:,1);   % ����ֱ�Ӱ�Y��:,:,1���ŵ����У��ᱨ��
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
        %% ϸ��ʶ��
        if(cRongR == 1)
%             Y = Y;
            roi_Name = subfile(j).name(1:end-4);
            roi_Path = subfile(j).folder;
            cell_Recong_CaImAn;
        end
    end
end