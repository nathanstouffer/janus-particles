function make_histograms(in_dir)

    d = dir(in_dir);
    for i = 3:numl(d)       % start at 3 to skip . and ..
        if (d(i).isdir)
            densityviz(in_dir);
        end
    end

end
