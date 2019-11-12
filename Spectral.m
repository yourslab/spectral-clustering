classdef Spectral < handle
    %SPECTRAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Gamma {mustBeNumeric}
        K {mustBeNumeric}
        A
        FilteredA
    end
    
    methods
        function obj = Spectral()
            %SPECTRAL Construct an instance of this class
            %   Detailed explanation goes here
        end
   
        function outputClusters = FindClusters(obj)
            % Symmetrize
            obj.FilteredA = (obj.FilteredA + obj.FilteredA') ./ 2;
            D = diag(1 ./ sqrt(sum(obj.FilteredA,2)));
            L = D*obj.FilteredA*D;
            % Top k eigenvectors from L
            [X, ~, ~] = svds(L, 5);
            X = Norm(X, 2);
            % Kmeans, compute C where each row is centroid
            outputClusters = kmeans(X,5);
        end
        
        function ComputeA(obj, data, gamma)
            %computeK Compute weights with K(i, j) = e^(-gamma * norm(x(i) - x(j))
            obj.Gamma = gamma;
            obj.A = zeros(size(data,1),size(data,1));
            m = size(data,1);
            for i=1:m
                for j=1:m
                    if i == j
                        obj.A(i, j) = 0;
                    else
                        obj.A(i, j) = exp(-obj.Gamma.*(norm(data(i,:) - data(j,:)).^2));
                    end
                end
            end
        end
        
        function FilterTopA(obj,k)
            %filterTopK Keep only the top k values and set the rest to zero
            obj.K = k;
            thresholds = mink(maxk(obj.A,obj.K,1),1,1);
            m = size(obj.A,1);
            obj.FilteredA = zeros(size(obj.A,1),size(obj.A,1));
            for i=1:m
                for j=1:m
                    if obj.A(i,j) >= thresholds(j)
                       obj.FilteredA(i,j) = obj.A(i,j);
                    end
                end
            end
        end
    end
end

