function[exampleF1, macroF1, microF1, proposedTrainTime, proposedTestTime] = evaluateCoE(trX, trY, tsX, tsY, param)

trX = normr(trX);
tsX = normr(tsX);

%% 
par.mu1 = param.mu1;
par.mu2 = param.mu2;
par.alpha = param.alpha;
par.dim = param.dim;
k = param.k;


%% 
tic;
[Wx, Wy, F] = CoE(trX, trY, par);
proposedTrainTime(1) = toc;

%% 
tic;

tsY_hat = CoE_Decoding(tsX, Wx, F, trY, k);% for large problem
proposedTestTime(1) = toc;

%% evaluation
nTs = size(tsX,1);
nLabel = size(trY, 2);

TexampleF1 = Measure_F1(tsY, tsY_hat);
exampleF1(1) = mean(TexampleF1);

[TmacroF1, TP, FP, TN, FN, ~, ~] = Measure_F1(tsY', tsY_hat');
macroF1(1) = mean(TmacroF1);
microF1(1) = computeF1(sum(TP), sum(FP), sum(FN));

exampleF1 = full(exampleF1);
macroF1 = full(macroF1);
microF1 = full(microF1);

end
