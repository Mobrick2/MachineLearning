[m,~] = size(testdataset);

%select all the feature vocabulary
active_feat = 1:100;

mean1 = mean(traindataset((label == 1), active_feat));
mean2 = mean(traindataset((label == 2), active_feat));
mean3 = mean(traindataset((label == 3), active_feat));
mean4 = mean(traindataset((label == 4), active_feat));
mean5 = mean(traindataset((label == 5), active_feat));

sigma1 = cov(traindataset((label == 1), active_feat));
sigma2 = cov(traindataset((label == 2), active_feat));
sigma3 = cov(traindataset((label == 3), active_feat));
sigma4 = cov(traindataset((label == 4), active_feat));
sigma5 = cov(traindataset((label == 5), active_feat));

prior1tmp = length(traindataset((label == 1)));
prior2tmp = length(traindataset((label == 2)));
prior3tmp = length(traindataset((label == 3)));
prior4tmp = length(traindataset((label == 4)));
prior5tmp = length(traindataset((label == 5)));


prior1 = prior1tmp/(prior1tmp + prior2tmp + prior3tmp + prior4tmp + ...
    prior5tmp);
prior2 = prior1tmp/(prior1tmp + prior2tmp + prior3tmp + prior4tmp + ...
    prior5tmp);
prior3 = prior1tmp/(prior1tmp + prior2tmp + prior3tmp + prior4tmp + ...
    prior5tmp);
prior4 = prior1tmp/(prior1tmp + prior2tmp + prior3tmp + prior4tmp + ...
    prior5tmp);
prior5 = prior1tmp/(prior1tmp + prior2tmp + prior3tmp + prior4tmp + ...
    prior5tmp);

%testing
correct = 0 ;
wrong = 0 ;

for i = 1 : m
    %2*pi is the same
    lklhood1 = 1/sqrt(det(sigma1))*...
            exp(-1/2*(testdataset(i,active_feat)-mean1)*(inv(sigma1))*...
                                  (testdataset(i,active_feat)-mean1)');
    lklhood2 = 1/sqrt(det(sigma1))*...
            exp(-1/2*(testdataset(i,active_feat)-mean2)*(inv(sigma2))*...
                                  (testdataset(i,active_feat)-mean2)');
    lklhood3 = 1/sqrt(det(sigma1))*...
            exp(-1/2*(testdataset(i,active_feat)-mean3)*(inv(sigma3))*...
                                  (testdataset(i,active_feat)-mean3)');
    lklhood4 = 1/sqrt(det(sigma1))*...
            exp(-1/2*(testdataset(i,active_feat)-mean4)*(inv(sigma4))*...
                                  (testdataset(i,active_feat)-mean4)');
    lklhood5 = 1/sqrt(det(sigma1))*...
            exp(-1/2*(testdataset(i,active_feat)-mean5)*(inv(sigma5))*...
                                  (testdataset(i,active_feat)-mean5)');
   
    post = zeros(1,5);
    post(1) = lklhood1*prior1;
    post(2) = lklhood2*prior2;
    post(3) = lklhood3*prior3;
    post(4) = lklhood4*prior4;
    post(5) = lklhood5*prior5;
    
    maxpost = max(post);
    for j = 1 : 5
        if post(j) == maxpost && testlabel(i) == j
            correct = correct + 1;
            break;
        elseif post(j) == maxpost && testlabel(i) ~= j
            wrong = wrong + 1 ;
            break;
        end
    end
end


