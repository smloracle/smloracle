function [F1] = computeF1(TP, FP, FN)

if TP+FP == 0
    prec = 0;
else
    prec = TP/(TP+FP);
end
if TP + FN == 0
    rec = 0.5;
else
    rec = TP/(TP+FN);
end
if prec+rec == 0
    F1 = 0;
else
    F1 = 2*prec*rec / (prec+rec);
end
    