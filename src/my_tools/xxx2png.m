filename = './1.jpg';

[filepath,name,ext] = fileparts(filename);
disp(ext);
if ~strcmp(ext, '.png')
    image = imread(filename);
    write_path = strcat(filepath, '/', name, '.png');
    disp(write_path);
    imwrite(image, write_path);
end
