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
addpath(genpath('./my_tools'));
%close all;
%clear;

% inputs
image_path = '../data/test_imgs/original_png';
salient_path = '../data/test_imgs/salient_png';
% input - optional
trimap_path = '../data/test_imgs/trimap_png'; % not used now
scribble_path = '../data/test_imgs/scribble_png'; % not used now
feature_path = '../data/test_imgs/feature_png'; % not used now
% outputs
result_path = '../data/test_imgs/result_tmp';

for i = 1:17
    image_name = sprintf('%s/%d.png', image_path, i);
    salient_name = sprintf('%s/%d.png', salient_path, i);
    trimap_name = sprintf('%s/%d.png', trimap_path, i);
    scribble_name = sprintf('%s/%d.png', scribble_path, i);
    
    %% Closed-form
    addpath(genpath('./closed_form'));
    disp('calculating closed-form matting...')
    [image, salient, trimap, scribble] = convert(image_name, salient_name, trimap_name, scribble_name);
    %tic; alpha_CF = closedFormMatting(image, scribble); toc;
    tic; alpha_CF = closedFormMatting(image, trimap); toc;
    [F_CF,B_CF] = solveFB(image,alpha_CF);
    rmpath(genpath('./closed_form'));
    
    %% KNN
    addpath(genpath('./KNN'));
    disp('calculating KNN matting...')
    [image, salient, trimap, scribble] = convert(image_name, salient_name, trimap_name, scribble_name);
    tic; alpha_KNN = knn_matting(image, trimap); toc;
    [F_KNN,B_KNN] = solveFB(image,alpha_KNN);
    rmpath(genpath('./KNN'));
    
    %% Information-flow
    addpath(genpath('./information_flow'));
    disp('calculating closed-form matting...')
    [image, salient, trimap, scribble] = convert(image_name, salient_name, trimap_name, scribble_name);
    tic; alpha_INFO = informationFlowMatting(image, trimap); toc;
    [F_INFO,B_INFO] = solveFB(image,alpha_INFO);
    rmpath(genpath('./information_flow'));
    
    %% SSS
%     addpath(genpath('./SemanticSoftSegmentation-master'));
%     features = im2double(imread(feature_name));
%     [image, salient, trimap, scribble] = convert(image_name, salient_name, '', '');
%     tic; seg_SSS = SemanticSoftSegmentation(image, features); toc;
%     rmpath(genpath('./SemanticSoftSegmentation-master'));
    
    %% overall show image
    
    imageArray = [
        image, repmat(trimap, [1,1,3]), scribble;
        repmat(alpha_CF, [1,1,3]), F_CF.*repmat(alpha_CF,[1,1,3]), B_CF.*repmat(1-alpha_CF,[1,1,3]);
        repmat(alpha_KNN, [1,1,3]), F_KNN.*repmat(alpha_KNN,[1,1,3]), B_KNN.*repmat(1-alpha_KNN,[1,1,3]);
        repmat(alpha_INFO, [1,1,3]), F_INFO.*repmat(alpha_INFO,[1,1,3]), B_INFO.*repmat(1-alpha_INFO,[1,1,3]);
    ];
    imageArray2 = [
        %image, repmat(trimap, [1,1,3]), scribble;
        repmat(alpha_CF, [1,1,3]), F_CF.*repmat(alpha_CF,[1,1,3]) + (1 - alpha_CF), B_CF.*repmat(1-alpha_CF,[1,1,3]) + alpha_CF;
        repmat(alpha_KNN, [1,1,3]), F_KNN.*repmat(alpha_KNN,[1,1,3]) + double(1 - alpha_KNN).*1, B_KNN.*repmat(1-alpha_KNN,[1,1,3]) + alpha_KNN;
        repmat(alpha_INFO, [1,1,3]), F_INFO.*repmat(alpha_INFO,[1,1,3]) + double(1 - alpha_INFO), B_INFO.*repmat(1-alpha_INFO,[1,1,3]) + alpha_INFO;
    ];
    %figure, imshow(imageArray2, 'InitialMagnification', 200);
    %drawnow
    % imshow([alpha_CF alpha_KNN alpha_INFO]);
    
    %% write files
    disp('writing images...');
    mkdir (result_path);
    
    mkdir (strcat(result_path, '/cf'));
    tmp_name = sprintf('%s/%s/%d_cf.png', result_path, 'cf',i);
    imwrite(alpha_CF, tmp_name);
    
    mkdir (strcat(result_path, '/knn'));
    tmp_name = sprintf('%s/%s/%d_knn.png', result_path, 'knn',i);
    imwrite(alpha_KNN, tmp_name);
    
    mkdir (strcat(result_path, '/info'));
    tmp_name = sprintf('%s/%s/%d_info.png', result_path, 'info',i);
    imwrite(alpha_INFO, tmp_name);
    
    mkdir (strcat(result_path, '/compare'));
    tmp_name = sprintf('%s/%s/%d_compare.png', result_path, 'compare', i);
    imwrite(imageArray, tmp_name);
    disp('done');
end