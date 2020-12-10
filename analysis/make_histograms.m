function make_histograms(in_dir)

    d = dir(in_dir);
    for i = 3:numel(d)       % start at 3 to skip . and ..
        if (d(i).isdir)
            fname = strcat(in_dir, d(i).name);
            densityviz(fname);
        end
    end

end
