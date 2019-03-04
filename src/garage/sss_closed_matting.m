function alpha = sss_closed_matting(image, scribble, features)
    if (~exist('thr_alpha','var'))
      thr_alpha=[];
    end
    if (~exist('epsilon','var'))
      epsilon=[];
    end
    if (~exist('win_size','var'))
      win_size=[];
    end

    if (~exist('levels_num','var'))
      levels_num=1;
    end
    if (~exist('active_levels_num','var'))
      active_levels_num=1;
    end

    I = image;
    mI = scribble;
    consts_map=(sum(abs(I-mI),3)>0.1);
    if (size(I,3)==3)
      consts_vals=rgb2gray(mI).*consts_map;
    end
    if (size(I,3)==1)
      consts_vals=mI.*consts_map;
    end
   %% 
    disp('Semantic Soft Segmentation')
    % Prepare the inputs and superpixels
    image = im2double(image);
    if size(features, 3) > 3 % If the features are raw, hyperdimensional, preprocess them
        features = preprocessFeatures(features, image);
    else
        features = im2double(features);
    end
    superpixels = Superpixels(image);
    [h, w, ~] = size(image);

    disp('     Computing affinities')
    % Compute the affinities and the Laplacian
    affinities{1} = mattingAffinity(image);
    affinities{2} = superpixels.neighborAffinities(features); % semantic affinity
    affinities{3} = superpixels.nearbyAffinities(image); % non-local color affinity
    Laplacian = affinityMatrixToLaplacian(affinities{1} + 0.01 * affinities{2} + 0.1 * affinities{3}); % Equation 6
    
    %Laplacian = affinityMatrixToLaplacian(affinities{1});
    %Laplacian = affinityMatrixToLaplacian(affinities{2});
    %Laplacian = affinityMatrixToLaplacian(affinities{3});
    
   %% 
    [h,w,~]=size(I);
    img_size=w*h;
    %L=getLaplacian1(I, consts_map);
    L = Laplacian;
    D=spdiags(consts_map(:),0,img_size,img_size);
    lambda=100;
    x=(L+lambda*D)\(lambda*consts_map(:).*consts_vals(:));


    alpha=max(min(reshape(x,h,w),1),0);

end
