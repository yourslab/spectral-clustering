function Ret = Norm(X, d)

n = sqrt(sum(X.^2,d)); % Compute norms of columns

Ret = bsxfun(@rdivide,X,n);