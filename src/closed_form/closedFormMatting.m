function alpha = closedFormMatting(image, scribble_or_trimap)
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
    mI = scribble_or_trimap;
    % if scribble is used
    if (size(scribble_or_trimap, 3) == 3)
        consts_map=(sum(abs(I-mI),3)>0.1);
        if (size(I,3)==3)
          consts_vals=rgb2gray(mI).*consts_map;
        end
        if (size(I,3)==1)
          consts_vals=mI.*consts_map;
        end
    end
    % if trimap is used
    if (size(scribble_or_trimap, 3) == 1)
        consts_map = (mI > 0.99) | (mI < 0.01);
        consts_vals = consts_map .* mI;
    end


    alpha=solveAlphaC2F(I,consts_map,consts_vals,levels_num, ...
                        active_levels_num,thr_alpha,epsilon,win_size);

    %figure, imshow(alpha);


    %[F,B]=solveFB(I,alpha);
    %imageArray = [I, I, mI; repmat(alpha,[1,1,3]), F.*repmat(alpha,[1,1,3]),B.*repmat(1-alpha,[1,1,3])];
    %figure, imshow(imageArray);
    %imwrite(imageArray, result_name);

    %figure, imshow(F.*repmat(alpha,[1,1,3]))
    %figure, imshow(I.*repmat(alpha,[1,1,3]))
end