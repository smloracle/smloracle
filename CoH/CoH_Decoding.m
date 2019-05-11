function[testLabel] = CoH_Decoding(testData, W, trU, trainLabel, k)

teB = compactbit(testData*W>0);
trB = compactbit(trU>0);

%% fill to 8*N bits
n = size(trB,2);
rN = rem(n, 8);
if rN ~= 0
    trB = [trB, uint8(zeros(size(trB,1),8-rN))];
    teB = [teB, uint8(zeros(size(teB,1),8-rN))];
end

dis = yael_hamming(teB', trB');
% [dis, ind] = yael_kmin(single(dis'), k);

sDis = [];
ind = [];
num = size(dis, 1);
block = 10;
n = floor(num / block);
for i = 1 : block
    if i < block
        index = (i-1)*n+1:i*n;
    else
        index = (i-1)*n+1:num;
    end
    [TempDis, TempInd] = yael_kmin(single(dis(index,:)'), k);
    sDis = [sDis, TempDis];
    ind = [ind, TempInd];
end
dis = sDis;

weight = 1./dis(1:k,:);
weight(isinf(weight)) = 10;%0;
% [weight, ~] = yael_vecs_normalize (weight, 1, 0);
weight = NormalizedX(weight, 1, 1);

nTs = size(testData, 1);
for i = 1 : nTs
    tempcomp = weight(:,i)' * trainLabel(ind(1:k,i),:);
    testLabel(i,:) = (tempcomp>=0.5);
end

end