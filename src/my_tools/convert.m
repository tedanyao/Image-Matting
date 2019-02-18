function [image, salient, trimap, scribble] = convert(image_name, salient_name, trimap_name, scribble_name)
    % image
    image = im2double(imread(image_name));
    salient = [];
    trimap = [];
    scribble = [];
    
    % salient
    if ~isempty(salient_name)
        salient = im2double(imread(salient_name));
        % salient should be m*n*1 dimension
        if size(salient, 3) == 3
            salient = salient(:, :, 1);
        end
        
        % configs to generate scibble or trimap
        % thres_up = 0.9;
        thres_down = 0.1;
        white = imerode((salient >= thres_down), ones(20));
        black = imerode((salient < thres_down), ones(40));
        others = ~white & ~black;
    end
    
    % trimap
    if ~isempty(trimap_name)
        trimap = im2double(imread(trimap_name));
        % salient should be m*n*1 dimension
        if size(trimap, 3) == 3
            trimap = trimap(:, :, 1);
        end
    else
        if ~isempty(salient_name)
            % generate trimap
            disp('generating trimap...');
            trimap = double(white) * 1 ...
                          + double(black) * 0 ...
                          + double(others) * 0.5;
            %gen_trimap_name = strcat('tri_',salient_name);
            %imwrite(trimap, gen_trimap_name);
        end
    end
    
    
    % scribble
    if ~isempty(scribble_name)
        scribble = im2double(imread(scribble_name));
        % salient should be m*n*1 dimension
        if size(scribble, 3) == 3
            scribble = scribble(:, :, 1);
        end
    else
        if ~isempty(salient_name)
            % generate scribble
            disp('generating scribble...');
            scribble = double(white) * 1 ...
                          + double(black) * 0 ...
                          + double(others) .* image;
            %gen_scribble_name = strcat('scri_',salient_name);
            %imwrite(scribble, gen_scribble_name);
        end
    end
    
    % error
    if isempty(salient_name) && isempty(trimap_name) && isempty(scribble_name)
        error('missing salient name or trimap_name or scribble_name')
    end
        
end