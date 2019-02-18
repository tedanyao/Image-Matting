% convert scribbles image

aa = salient;
thres_up = 0.9;
thres_down = 0.1;
white = imerode((aa >= thres_down), ones(5));
black = imerode((aa < thres_down), ones(40));
others = ~white & ~black;
blackAndWhite = double(white) ...
              + double(black) .* 0 ...
              + double(others) .* 0.5;
%blackAndWhite = double(aa > thres_up) ...
%              + double(aa < thres_down) .* 0 ...
%              + double(aa <= thres_up & aa >= thres_down) .* 0.5;
%figure, imshow(blackAndWhite);
%figure,imshow([bb, aa, maskWhite, maskBlack, dd]);
%newname = strcat('scri_',scribs_img_name);
imwrite(blackAndWhite, "test.png");
trimap = blackAndWhite(:,:,1);