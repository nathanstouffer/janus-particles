function make_histograms(in_dir, dim, t_start)

    d = dir(in_dir);
    for i = 3:numel(d)       % start at 3 to skip . and ..
        if (d(i).isdir)
            if (strcmp(d(i).name, 'hists') == 0)
                fname = strcat(in_dir, d(i).name);
                densityviz(fname, dim, t_start);
            end
        end
    end

end
