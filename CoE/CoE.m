function[Wx, Wy, B] = CoE(X, Y, opt)

Y = normr(Y);

Z = Y .* repmat(1./sum(Y,2),1,size(Y,2));
temp = sum(Z,1);
ind = (temp>0);
Z(:, ind) = Z(:,ind) * diag(1./sqrt(temp(ind)));

[n, dim1] = size(X);
[~, dim2] = size(Y);
%%
dim = opt.dim;
mu1 = opt.mu1;
mu2 = opt.mu2;
alpha = opt.alpha;

%% initialization

pcaOpt.ReducedDim = dim;
[W, ~] = PCA(Y, pcaOpt);
B = normc(Y*W);

Sx = X'*X;
Sy = Y'*Y;

opts.mxitr  = 20;
opts.xtol = 1e-3;
opts.gtol = 1e-3;
opts.ftol = 1e-5;
opts.record = 0;

maxIter = 100;
Obj(1) = inf;
for iter = 2 : maxIter

    % update Wx, Wy
    Wx = (Sx+0.001*eye(dim1)) \ (X'*B);
    Wy = (Sy+0.001*eye(dim2)) \ (Y'*B);
    
    Tx = X * Wx;
    Ty = Y * Wy;
    % update B
    [B, Out]= OptStiefelGBB(B, @funB, opts, mu1, mu2, alpha, Tx, Ty, Z);
    Obj(iter) = Out.fval;
    if abs(Obj(iter)-Obj(iter-1)) / Obj(iter) < 0.01 % is better %1e-5  is not good
        break;
    end
end

end

function [Obj, G] = funB(B, mu1, mu2, alpha, Tx, Ty, Z)

    Obj = mu1*norm(B-Tx,'fro').^2 + mu2*norm(B-Ty,'fro').^2 + alpha*trace(B'*B-B'*Z*Z'*B);

    G = 2 * ((mu1+mu2+alpha)*B - (mu1*Tx + mu2*Ty + alpha*Z*(Z'*B)));
end