function make_hist(in_dir)

    d = dir('in_dir').name
    dfolder = d([d(:).isdir])
    
    densityviz(in_dir);
    
end
