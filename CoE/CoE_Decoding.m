function[testLabel] = CoE_Decoding(testData, W, trU, trainLabel, k)

teB = testData*W;
trB = trU;

%%
[ind,dis] = yael_nn(single(trB'), single(teB'), k, 2);
ind = ind';
dis = dis';

dis = double(dis);
weight = 1./dis;
weight(isinf(weight)) = 0;
weight = NormalizedX(weight, 2, 1);

%%
nTs = size(testData, 1);
len = size(trainLabel,2);
testLabel = false(nTs, len);
for i = 1 : nTs
    tempcomp = weight(i,:) * trainLabel(ind(i,1:k),:);
    testLabel(i, tempcomp>=0.5) = 1;
end


end
