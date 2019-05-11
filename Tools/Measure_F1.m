function [F1, TP, FP, TN, FN, prec, recall] = Measure_F1(Y, Y_hat)
% one row, one label
% in case the format is not correct
Y(Y<=0) = 0;
Y(Y>0) = 1;
Y_hat(Y_hat<=0) = 0;
Y_hat(Y_hat>0) = 1;
n = size(Y,2);

G1 = sum(Y_hat, 2);
G2 = sum(Y, 2);

TP = sum(Y&Y_hat, 2);
FP = G1 - TP;
TN = sum(Y==0&Y_hat==0, 2);
FN = n - G1 - TN;


prec = TP ./ G1;
prec(G1==0) = 0;
recall = TP ./ G2;
recall(G2==0) = 0.5;

F1 = 2.*prec.*recall./(prec+recall);
F1(isnan(F1)) = 0;