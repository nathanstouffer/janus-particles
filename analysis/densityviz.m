function rho = densityvis(dir_name, dim, t_start)
  
    tic;
    %prefix = "../data/n-200_a-0.785_p-6.283_t-31.83098861837907_v-0.0008_d-12.08.2020_t-13.41.45/";
    postfix = ".csv";

    %% figure out values of num and alpha and the perception strength
    num = split(dir_name, '/');
    num = num(numel(num));
    num = split(num, 'n-');
    num = num(2);
    num = split(num, '_');
    num = num(1);
    
    alpha = split(dir_name, '/');
    alpha = alpha(numel(alpha));
    alpha = split(alpha, '_a-');
    alpha = alpha(2);
    alpha = split(alpha, '_');
    alpha = alpha(1);

    thresh = split(dir_name, '/');
    thresh = thresh(numel(thresh));
    thresh = split(thresh, '_t-');
    thresh = thresh(2);
    thresh = split(thresh, '_');
    thresh = thresh(1);

    %% reading in

    seq = t_start:10:20000;  % these are the files we have
    seqlen = length(seq); % how many frames?

    % process all files
    for i = 1:seqlen
        infilename = dir_name + "/" + seq(i) + postfix;
        D{i} = csvread(infilename,1,1);
    end

    D = cat(3,D{:});


    %%
    %dim = 64;
    x = round((dim-0.0001)*squeeze(1-D(:,2,:))+0.5);  % second MATLAB coordinate, downwards
    y = round((dim-0.0001)*squeeze(D(:,1,:))+0.5); % first MATLAB coordinate
    theta = round(14.99/2/pi*squeeze(D(:,3,:))+0.5);
    s = squeeze(D(:,4,:));

    phi = linspace(0,360,16);

    %figure('Name', 'Long term density overall');
    rho = full(sparse(x(:),y(:), ones(length(x(:)),1), dim,dim));
    %imagesc(rho);
    %axis equal;
    %axis off;
    fout_name = join(['../data/convergence_d-02.26.2021_t-16.51.35/hists/n', num, '_t' , num2str(t_start), '_res', num2str(dim), '.mat'], '');
    %join(['../data/phase-portrait/sim/histograms/500-agents/particlesim-alpha-', alpha, '-percep-', thresh, '.mat'], '');
    save(fout_name, 'rho')

    % figure('Name', 'Long term density by orientation');
    % for i = 1:15 
    %     subplot(4,4,i);
    %     idx = (theta == i);
    %     rho = full(sparse(x(idx(:)),y(idx(:)), ones(nnz(idx),1), 32,32));
    %     imagesc(rho);
    %     axis equal;
    %     axis off;
    %     title("Orientation " + phi(i));
    % end
    % 
    % figure('Name', 'Long term density by state');
    % for state = 0:1
    %     subplot(1,2,state+1);
    %     idx = (s == state);
    %     rho = full(sparse(x(idx(:)),y(idx(:)), ones(nnz(idx),1), 32,32));
    %     imagesc(rho);
    %     axis equal;
    %     axis off;
    %     if state
    %         title('Active');
    %     else
    %         title('Passive');
    %     end
    % end

    toc
end
