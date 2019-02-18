function jpg2png(filename)
    [filepath,name,ext] = fileparts(filename);
    disp(ext);
    if strcmp(ext, '.jpg')
        image = imread(filename);
        write_path = strcat(filepath, '/', name, '.png');
        disp(write_path);
        imwrite(image, write_path);
    end
end