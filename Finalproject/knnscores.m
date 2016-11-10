run('/Users/Morbrick/Downloads/vlfeat-0.9.20/toolbox/vl_setup');
load newdataset.mat;
load testdata.mat;
load('truth.mat');
load('cars_train_annos.mat');
%number of the training data
N = length(dataset);
%number of the test data
n = length(testdataset);
label = zeros(n,1);

%set the k here:
k = 5 ;

for i = 1 : n
    dis = ones(1,N);
    %decriptors of test picture 
    temp1 = reshape(testdataset(i,:),128,50);
    for j = 1 : N
       %decriptors of training picture
        temp2 = reshape(dataset(j,:),128,50);
        
        %for each descriptor in test picture, vl_ubcmatch finds the closest 
        %descriptor in trainig picture, scores is the distance for each
        %match, the thrid argument 1.5 is the threshold which let distance 
        %d(D1,D2) multiplied by it is not greater than the distance of D1 
        %to all other descriptors
        [matches, scores] = vl_ubcmatch(temp1, temp2,1.5) ;
        
        %I only store the number of matches that satisfy the threshold as
        %measurement of "similarity" between the two pictures
        %the more discriptors match the closer the distance
        if isempty(matches)
            dis(j) = inf ;
        else
           dis(j) = 1/mean(scores);
        end
    end
    
    %find the k minimum element,i.e knn
    IDX = zeros(k,1);
    for j = 1 : k
        [IDX(j),index] = min(dis);
        % set it the next iteration the last smallest value:
        dis(index) = 1;
        IDX(j) = index ;
    end
    
    %classify the picture by mojority voting
    classarray = zeros(1,196);
    for j = 1 : length(IDX)
       classarray( annotations(IDX(j)).class ) = ...
           classarray( annotations(IDX(j)).class ) + 1;
    end
    %decide label
    index = find(classarray == max(classarray));
    %if have mutiple max, choose the first one
    label(i) = index(1);    
end


%calculate the accuary
accuracy = sum(label == truth) / n