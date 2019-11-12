function Segmentation = SpectralClustering(data)

% Compute weights with K(i, j) = e^(-gamma * norm(x(i) - x(j))
K = zeros(size(data,1),size(data,1));
gamma = 100;
m = size(data,1);
for i=1:m
    for j=1:m
        if i == j
            K(i, j) = 0;
        else
            K(i, j) = exp(-gamma.*(norm(data(i,:) - data(j, :)).^2));
        end
        if K(i, j) ~= 0
            disp(K(i, j));
        end
    end
end

%disp(K);

Segmentation = 0;
