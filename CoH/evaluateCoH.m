function[exampleF1, macroF1, microF1, TrainTime, TestTime] = evaluateCoH(trX, trY, tsX, tsY, param)

trX = normr(trX);
tsX = normr(tsX);
% trY = normr(trY);
% tsY = normr(tsY);

meanX = mean(trX,1);
trX = bsxfun(@minus, trX, meanX);
tsX = bsxfun(@minus, tsX, meanX);

%% 
par.mu1 = param.mu1;
par.mu2 = param.mu2;
par.alpha = param.alpha;
par.ru = param.ru;
par.dim = param.dim;
par.r = param.r;
k = param.k;

%% 
TrainTime = tic;
[Wx, Wy, Z, B] = CoH(trX, trY, par);
TrainTime = toc(TrainTime);

%%
TestTime = tic;
tsY_hat = CoH_Decoding(tsX, Wx, B', trY, k);
TestTime = toc(TestTime);

%% evaluation
nTs = size(tsX,1);
nLabel = size(trY, 2);

TexampleF1 = Measure_F1(tsY, tsY_hat);
exampleF1 = mean(TexampleF1);

[TmacroF1, TP, FP, TN, FN, ~, ~] = Measure_F1(tsY', tsY_hat');
macroF1 = mean(TmacroF1);
microF1 = computeF1(sum(TP), sum(FP), sum(FN));

end