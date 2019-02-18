%%
%   Description: 
%
%   Author: Yang-Yao Lin
%   
%   Date: 2019.2.10
%
%   Last Modified: 2019.2.18
%
%   Description:
%   It performs closed-form matting and KNN matting, stores the results
%   in according directories, and show the comparison.
%   
%   Note that if you want to run native kmeans(), do not include path in
%   ../KNN/vlfeat-0.9.21



%%
addpath(genpath('./'));

%close all;
%clear;
   
image_path = '../data/segmentation_test_imgs/resize_rgb_png';
salient_path = '../data/segmentation_test_imgs/resize_salient_png';
result_path = '../data/segmentation_test_imgs/result_tmp';

for i = 1:3
    image_name = sprintf('%s/%d.png', image_path, i);
    salient_name = sprintf('%s/%d.png', salient_path, i);
    
    %% Closed-form
    disp('calculating closed-form matting...')
    [image, salient, trimap, scribble] = convert(image_name, salient_name, '', '');
    tic; alpha_CF = runMatting(image, scribble); toc;
    [F_CF,B_CF] = solveFB(image,alpha_CF);
     
    %% KNN
    disp('calculating KNN matting...')
    [image, salient, trimap, scribble] = convert(image_name, salient_name, '', '');
    tic; alpha_KNN = knn_matting(image, trimap); toc;
    [F_KNN,B_KNN] = solveFB(image,alpha_KNN);
    
    
    %% overall show image
    imageArray = [image, repmat(trimap, [1,1,3]), scribble;
        repmat(alpha_CF, [1,1,3]), F_CF.*repmat(alpha_CF,[1,1,3]), B_CF.*repmat(1-alpha_CF,[1,1,3]);
        repmat(alpha_KNN, [1,1,3]), F_KNN.*repmat(alpha_KNN,[1,1,3]), B_KNN.*repmat(1-alpha_KNN,[1,1,3])];
    figure, imshow(imageArray, 'InitialMagnification', 200);
    drawnow
    
    %% write files
    disp('writing images...');
    mkdir (result_path);
    mkdir (strcat(result_path, '/cf'));
    mkdir (strcat(result_path, '/knn'));
    mkdir (strcat(result_path, '/compare'));
    
    tmp_name = sprintf('%s/%s/%d_cf.png', result_path, 'cf',i);
    imwrite(alpha_CF, tmp_name);
    tmp_name = sprintf('%s/%s/%d_knn.png', result_path, 'knn',i);
    imwrite(alpha_KNN, tmp_name);
    tmp_name = sprintf('%s/%s/%d_compare.png', result_path, 'compare', i);
    imwrite(imageArray, tmp_name);
end