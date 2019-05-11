function[Wx, Wy, Z, B] = CoH(X, Y, opt)

%% initilization
% Y = NormalizedX(Y, 2, 2);
% 
% % A = sum(F*F', 2); all ones
% F = NormalizedX(Y, 2, 1);

r = opt.r;
[~, anchor] = litekmeans(Y, r, 'MaxIter', 30);% better use kmeans
[F] = get_Z(Y, anchor, 2, 0);
F = full(F);

temp = sum(F,1);
ind = find(temp~=0);
F(:,ind) = bsxfun(@rdivide, F(:,ind), sqrt(temp(ind)));

[n, dim1] = size(X);
[~, dim2] = size(Y);
%%
dim = opt.dim;
mu1 = opt.mu1;
mu2 = opt.mu2;
alpha = opt.alpha;
ru = opt.ru;

%%
pcaOpt.ReducedDim = dim;
[W, ~] = PCA(Y, pcaOpt);
Z = normr(Y*W)';
% Z = NormalizedX(Y*W, 2, 2)';
B = sign(Z);

%%
% [U,SI,V] = svd(F, 'econ');
% Z = U(:,2:dim+1)'*sqrt(n);
% % Z = NormalizedX(Y*W, 2, 2)';
% B = sign(Z);


%% test1
% [B, Q, ~] = ITQ(Z', 50);
% B = B';

Wx = (X'*X+0.001*eye(dim1)) \ (X'*B');
Wy = (Y'*Y+0.001*eye(dim2)) \ (Y'*B');

%% test2
% [Wx, Wy, Z] = Proposed(X, Y, opt);
% [B, Q, ~] = ITQ(Z, 50);
% Wx = Wx * Q;
% Wy = Wy * Q;
% Z = Z';
% B = B';

%%
Sx = X'*X;
Sy = Y'*Y;

%%
maxIter = 100;

for iter = 1 : maxIter
    
    %% update B
    B = UpdateB(mu1*Wx'*X'+mu2*Wy'*Y', F', Z, B, alpha, ru);
    
    %% update Wx, Wy
    Wx = (Sx+0.001*eye(dim1)) \ (X'*B');
    Wy = (Sy+0.001*eye(dim2)) \ (Y'*B');
    
    %% update Z
%     JB = bsxfun(@minus, B, mean(B,2));
    JB = B;
    [U,SI,V] = svd(JB, 'econ');
    Z = sqrt(n) * U * V';
    
    %% Compute the Obj
    Obj(iter) = norm(Wx'*X'-B,'fro')^2 + norm(Wy'*Y'-B,'fro')^2 - alpha*trace(B*F*F'*B') + ru/2*norm(B-Z,'fro')^2;
%     Ori_Obj(iter) = norm(Wx'*X'-B,'fro')^2 + norm(Wy'*Y'-B,'fro')^2 + alpha*trace(B*B') - alpha*trace(B*F*F'*B');
    if (iter >= 2) && (abs(Obj(iter)-Obj(iter-1))/abs(Obj(iter)) < 0.01 ) % 1e-5
        break;
    end
    
end

end


function[B] = UpdateB(A, F, Z, B, alpha, ru)

maxIter = 100;

for i = 1 : maxIter

    H = 2*B*F'*F + (2*A+ru*Z) / alpha;
    ind = (H==0);
    H(ind) = B(ind);
    B = sign(H);
    
    Obj(i) = trace(B*F'*F*B') + trace(2*A*B'+ru*Z*B') / alpha;
    
    if (i>=2) && (abs(Obj(i)-Obj(i-1))/Obj(i) < 1e-5)
        break;
    end
end

end