function[X] = NormalizedX(X, direc, normL)
%% the core is doing normalizing in column, which is faster than in row in sparse setting

%% direc 2: row direction. 1, column direction
%% normL 1: 1 norm. 2: 2 norm.

if direc == 2
    X = X';
end

if normL == 2
    normZ = sqrt(sum(X.^2, 1));
elseif normL == 1
    normZ = sum(X, 1);
end

ind = find(normZ ~= 0);

X(:,ind) = bsxfun(@rdivide, X(:,ind), normZ(ind));

% X = bsxfun(@rdivide, X, normZ);

if direc == 2
    X = X';
end

end

%% still very slow
% function[X] = NormalizedX(X, direc, normL)
% 
% %% direc 2: row direction. 1, column direction
% %% normL 1: 1 norm. 2: 2 norm.
% 
% if direc ~= 2
%     X = X';
% end
% 
% if normL == 2
%     normZ = sqrt(sum(X.^2, 2));
% elseif normL == 1
%     normZ = sum(X, 2);
% end
% 
% ind = find(normZ ~= 0);
% 
% X(ind,:) =  bsxfun(@rdivide, X(ind,:), normZ(ind));
% 
% 
% if direc ~= 2
%     X = X';
% end
% 
% 
% end

%% solw
% function[X] = NormalizedX(X, direc, normL, u)
% 
% %% direc 2: row direction. 1, column direction
% %% normL 1: 1 norm. 2: 2 norm.
% 
% if direc ~= 2
%     X = X';
% end
% 
% [n, m] = size(X);
% 
% % u = 1e4;
% l = floor(n / u); r = mod(n, u);
% 
% parfor i = 1 : l
%     Xi = X((i-1)*u + [1:u], :);
% 
%     if normL == 2
%         Z{i,1} = normr(Xi);
%     elseif normL == 1
%         ZTemp = sparse(zeros(u, m));
%         temp = sum(Xi,2);
%         ind = find(temp~=0);
%         ZTemp(ind, :) = diag(1./temp) * Xi(ind,:);
%         Z{i,1} = ZTemp;
%     end
%     i
% end
% 
% % clear Xi;
% if r > 0
%     Xi = X(l*u +1 : end,:);
%     
%     if normL == 2
%         Z{l+1,1} = normr(Xi);
%     elseif normL == 1
%         ZTemp = sparse(zeros(size(Xi)));
%         temp = sum(Xi,2);
%         ind = find(temp~=0);
%         ZTemp(ind, :) = diag(1./temp) * Xi(ind,:);
%         Z{l+1,1} = ZTemp;
%     end
% 
% end
% 
% X = cell2mat(Z);
% 
% if direc ~= 2
%     X = X';
% end
% 
% 
% end

% function[X] = NormalizedX(X, direc, normL, u)
% 
% %% direc 2: row direction. 1, column direction
% %% normL 1: 1 norm. 2: 2 norm.
% 
% if direc ~= 2
%     X = X';
% end
% 
% [n, m] = size(X);
% 
% % u = 1e4;
% l = floor(n / u); r = mod(n, u);
% 
% for i = 1 : l
%     Xi = X((i-1)*u + [1:u], :);
% 
%     if normL == 2
%         X((i-1)*u + [1:u], :) = normr(Xi);
%     elseif normL == 1
%         temp = sum(Xi,2);
%         indTemp = find(temp~=0);
%         ind = ((i-1)*u + [1:u]);
%         ind = ind(indTemp);
%         
%         X(ind, :) = diag(1./temp) * Xi(indTemp,:);
%     end
%     i
% end
% 
% clear Xi;
% if r > 0
%     Xi = X(l*u +1 : end,:);
%     
%     if normL == 2
%         X(l*u + 1 : end,:) = normr(Xi);
%     elseif normL == 1
%         temp = sum(Xi,2);
%         indTemp = find(temp~=0);
%         ind = ((i-1)*u + [1:u]);
%         ind = ind(indTemp);
%         
%         X(ind, :) = diag(1./temp) * Xi(indTemp,:);
%     end
% 
% end
% 
% 
% if direc ~= 2
%     X = X';
% end
% 
% 
% end