clear;

addpath('CoE');
addpath('CoH');
addpath('Dataset');
addpath('Tools');

load cal500;

X = double(X);
Y = double(Y);

k = 10;
%% cv index
nRun = 10; % cross validataion parameter

nLabel = size(Y,2);
[m,~]=size(X);

s = RandStream('mt19937ar', 'Seed', 1);% set random seed make the experiment can repeat
RandStream.setGlobalStream(s);
indices = crossvalind('Kfold', m, nRun);

mu = 1;
ru = 100;
dim = 100;
%%
for r = 1 : nRun

    %% dataset split
    tsInd = (indices == r); 
    trInd = ~tsInd;
    trX=X(trInd,:);      
    tsX=X(tsInd,:);
    trY=Y(trInd,:);
    tsY=Y(tsInd,:);


    ProposedPar.mu1 = mu;
    ProposedPar.mu2 = mu;
    ProposedPar.ru = ru;
    ProposedPar.alpha = 1;
    ProposedPar.dim = dim;
    ProposedPar.k = k;
    ProposedPar.r = 50;

    %% CoE
    [exampleF1_CoE, ...
        macroF1_CoE, ...
        microF1_CoE, ...
        TrainTime_CoE, ...
        TestTime_CoE] = evaluateCoE(trX, trY, tsX, tsY, ProposedPar);

    %% CoH
    [exampleF1_CoH, ...
        macroF1_CoH, ...
        microF1_CoH, ...
        TrainTime_CoH, ...
        TestTime_CoH] = evaluateCoH(trX, trY, tsX, tsY, ProposedPar);
    
end
