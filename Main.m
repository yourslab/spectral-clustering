function Ret = Main()

data = load('data/spectral_clustering_data.mat');

% Segment Original Features
if isfile('original_clusters.mat')
    original_data = load('original_clusters.mat');
    Original_segmentation = original_data.segmentation;
else
    gammas = [0.1:0.1:0.9 1:10];
    ks = 2:15;
    Original = Norm(data.Original_features', 1);
    Original_segmentation = zeros(size(Original, 1), length(gammas)*length(ks));
    for gamma = gammas
        spectral = Spectral();
        disp('computeA');
        spectral.ComputeA(Original, gamma);
        for k = ks
            disp('filterTopA');
            spectral.FilterTopA(k);
            idx = (find(gammas==gamma)-1)*length(ks) + find(ks==k);
            fprintf('Iteration %d',idx);
            Original_segmentation(:,idx) = spectral.FindClusters();
        end
    end
    save('original_clusters');
end

% Segment Transformed Features
if isfile('transformed_clusters.mat')
    transformed_data = load('transformed_clusters.mat');
    Transformed_segmentation = transformed_data.segmentation;
else
    gammas = [0.1:0.1:0.9 1:10];
    ks = 2:15;
    Transformed = Norm(data.Transformed_features', 1);
    Transformed_segmentation = zeros(size(Transformed, 1), length(gammas)*length(ks));
    for gamma = gammas
        spectral = Spectral();
        disp('computeA');
        spectral.ComputeA(Original, gamma);
        for k = ks
            disp('filterTopA');
            spectral.FilterTopA(k);
            idx = (find(gammas==gamma)-1)*length(ks) + find(ks==k);
            fprintf('Iteration %d',idx);
            Transformed_segmentation(:,idx) = spectral.FindClusters();
        end
    end
    save('transformed_clusters');
end

% Measure missclassification rate
Original_missrate = Misclassification(Original_segmentation,data.Labels);
Transformed_missrate = Misclassification(Transformed_segmentation,data.Labels);
Original_missrate_matrix = reshape(Original_missrate,14,19)';
Transformed_missrate_matrix = reshape(Transformed_missrate,14,19)';

plot(2:15, mink(Original_missrate_matrix,1));
hold on
plot(2:15, mink(Transformed_missrate_matrix,1));
title('Minimum Missrates');
xlabel('k = [2:15]');
ylabel('Min Missrate Over Gammas'); 
legend({'Original','Transformed'},'Location','southeast');
% csvwrite('original_missrate.csv', Original_missrate_matrix);
% csvwrite('transformed_missrate.csv', Transformed_missrate_matrix);

Ret = 0;