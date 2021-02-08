function [] = imageprocess(file_name,directory_name)
%imageprocess: Processes Density Map images
%   file_name should be a .mat file, directory_name is the directory where the
%   images will be saved.
Y = load(file_name);
Y = cell2mat(struct2cell(Y));

[x,y,z] = size(Y);

for i = 1:z
    image_name = strcat(directory_name,num2str(x),'res-t',num2str(i),'.png');
    Im = 1 - Y(:,:,i);
    imwrite(Im,image_name);
end

