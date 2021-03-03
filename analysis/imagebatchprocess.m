function [] = imagebatchprocess(in_dir)
%imagebatchprocess: Processes Density Map images
%   in_dir is where the .mat files are stored and where the .png files
%   will be saved

d = dir(in_dir);
    for i = 3:numel(d)       % start at 3 to skip . and ..
        [path, name, ext] = fileparts(d(i).name);
        if (strcmp(ext, '.mat'))
            in_name = strcat(in_dir, name, ext);
            X = cell2mat(struct2cell(load(in_name)));
            normed = X./max(max(X));
            Im = 1 - normed;
            out_name = strcat(in_dir, name, '.png');
            imwrite(Im, out_name)
        end
    end
end

