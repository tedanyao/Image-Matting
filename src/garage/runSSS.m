close all;
clear;

addpath(genpath('./SemanticSoftSegmentation-master'));

image_path = '../data/segmentation_test_imgs/resize_rgb_png';
salient_path = '../data/segmentation_test_imgs/resize_salient_png';
feature_path = '../data/segmentation_test_imgs/resize_feature_png';
result_path = '../data/segmentation_test_imgs/result_tmp_sss';

for i = 1:1
    image_name = sprintf('%s/%d.png', image_path, i);
    salient_name = sprintf('%s/%d.png', salient_path, i);
    feature_name = sprintf('%s/%d.png', feature_path, i);



    features = im2double(imread(feature_name));

    [image, salient, trimap, scribble] = convert(image_name, salient_name, '', '');
    %tic; alpha_SSS = sss_closed_matting(image, scribble, features); toc;
    tic; alpha_SSS = SemanticSoftSegmentation(image, features); toc;
    [F_SSS,B_SSS] = solveFB(image,alpha_SSS);
    figure, imshow([repmat(alpha_SSS, [1,1,3]) F_SSS.*repmat(alpha_SSS, [1,1,3]) B_SSS.*repmat(1-alpha_SSS, [1,1,3])], 'InitialMagnification', 200);
    %drawnow
    
    % There's also an implementation of Spectral Matting included
    %sm = SpectralMatting(image);
    % You can group the soft segments from Spectral Matting using
    % semantic features, the way we presented our comparisons in the paper.
    %sm_gr = groupSegments(sm, features);
    %figure; imshow([image visualizeSoftSegments(sm) visualizeSoftSegments(sm_gr)]);
    %title('Matting components');
    
end
