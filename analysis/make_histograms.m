function make_histograms(in_dir, dim, t_start)

    d = dir(in_dir);
    for i = 3:numel(d)       % start at 3 to skip . and ..
        if (d(i).isdir)
            if (strcmp(d(i).name, 'hists') == 0)
                dir_name = strcat(in_dir, d(i).name);
                densityviz(dir_name, dim, t_start);
            end
        end
    end

end
