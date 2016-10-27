data = dlmread('pima-indians-diabetes.data');
% experiment times
N = 10 ;

%maximum likelihood estimation
MLE = zeros(1,N);
for j = 1 : N
    data = reshape(data,[],9);
    %re-order the data
    rp = randperm(length(data));
    data = data(rp,:);

    train_data = data(1:length(data)/2,:);
    test_data = data(length(data)/2+1:end,:);

    %pick feature 2-4
    active_feat = 2:4;


    mean1 = mean(train_data(train_data(:,9)==0, active_feat));
    mean2 = mean(train_data(train_data(:,9)==1, active_feat));

    sigma1 = cov(train_data(train_data(:,9)==0, active_feat));
    sigma2 = cov(train_data(train_data(:,9)==1, active_feat));

    prior1tmp = length(train_data(train_data(:,9)==0));
    prior2tmp = length(train_data(train_data(:,9)==1));

    prior1 = prior1tmp/(prior1tmp + prior2tmp);
    prior2 = prior2tmp/(prior1tmp + prior2tmp);

    %testing
    correct = 0 ;
    wrong = 0 ;

    for i = 1 : length(test_data)
        %2*pi is the same
        lklhood1 = 1/sqrt(det(sigma1))*...
            exp(-1/2*(test_data(i,active_feat)-mean1)*inv(sigma1)*...
                                     (test_data(i,active_feat)-mean1)');
        lklhood2 = 1/sqrt(det(sigma2))*...
            exp(-1/2*(test_data(i,active_feat)-mean2)*inv(sigma2)*...
                                     (test_data(i,active_feat)-mean2)');
   
        post1 = lklhood1*prior1;
        post2 = lklhood2*prior2;
   
        if (post1 > post2 && test_data(i,9)==0)
            correct = correct + 1 ;
        elseif (post1 < post2 && test_data(i,9)==1)
            correct = correct + 1 ;
        else
            wrong = wrong + 1 ;
        end
    end
    MLE(j) = correct / length(test_data);
end

%Naive Bayes Esitimation
NBE = zeros(1,N);
for j = 1 : N
    data = reshape(data,[],9);
    %re-order the data
    rp = randperm(length(data));
    data = data(rp,:);

    train_data = data(1:length(data)/2,:);
    test_data = data(length(data)/2+1:end,:);

    %pick feature 2-4
    active_feat = 2:4;
    
    mean1 = mean(train_data(train_data(:,9)==0, active_feat));
    mean2 = mean(train_data(train_data(:,9)==1, active_feat));
    
    var1 = var(train_data(train_data(:,9)==0,active_feat));
    var2 = var(train_data(train_data(:,9)==1,active_feat));
    
    prior1tmp = length(train_data(train_data(:,9)==0));
    prior2tmp = length(train_data(train_data(:,9)==1));

    prior1 = prior1tmp/(prior1tmp + prior2tmp);
    prior2 = prior2tmp/(prior1tmp + prior2tmp);
    
    %testing
    correct = 0 ;
    wrong = 0 ;
    for i = 1 : length(test_data)
        %2*pi is the same
        lklhood1 = prod((exp(-(test_data(i,active_feat)-mean1).^2./...
                    (2*var1))./sqrt(var1)));
        lklhood2 = prod((exp(-(test_data(i,active_feat)-mean2).^2./...
                    (2*var2))./sqrt(var2)));
                
        post1 = lklhood1*prior1;
        post2 = lklhood2*prior2;
        
        if (post1 > post2 && test_data(i,9)==0)
            correct = correct + 1 ;
        elseif (post1 < post2 && test_data(i,9)==1)
            correct = correct + 1 ;
        else
            wrong = wrong + 1 ;
        end
    end
    NBE(j) = correct / length(test_data);
end
