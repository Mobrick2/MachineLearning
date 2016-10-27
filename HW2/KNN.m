data = dlmread('pima-indians-diabetes.data');
N = 10;
KNN = ones(1,N);
%k-Nearest Neighbor classifier
K = 1 ;
for j = 1 : N
data = reshape(data,[],9);
%re-order the data
rp = randperm(length(data));
data = data(rp,:);



sample_data = data(1:length(data)*2/3,:);
test_data = data(length(data)*2/3+1:end,:);

%pick feature 2-4
active_feat = 2:4;

%testing
correct = 0 ;
wrong = 0 ;

for i = 1 : length(test_data)
    IDX = knnsearch(sample_data(:,active_feat), test_data(i,active_feat),'K',K);
    
    %since the class is 0 or 1, if sum up the class value equals to the
    %vote of all the K-nearest neibor.
    vote = sum (sample_data(IDX,9));
    if (vote > K/2) && (test_data(i,9) == 1)
        correct = correct + 1 ;
    elseif (vote < K/2) && (test_data(i,9) == 0)
        correct = correct + 1 ;
    else
        wrong = wrong + 1 ;
    end
end

KNN(j) = correct / length(test_data);
end
