load knndata;
[m,~] = size(testdataset);

K = 5;
correct = 0 ;
wrong = 0 ;

for i = 1 : m
   vote = zeros(1,5);
   IDX = knnsearch(traindataset, testdataset(i,:),'K',K);
   
   for j = 1 : length(IDX)
      vote(label(IDX(j))) = vote(label(IDX(j))) + 1;
   end
   
   majority = max(vote);
   for j = 1 : 5
      if vote(j) == majority && testlabel(i) == j
          correct = correct + 1;
          break;
      elseif vote(j) == majority && testlabel(i) ~= j
          wrong = wrong + 1;
          break;
      end
   end
end
ratio = correct / 201;
improve = (ratio - 0.2)/0.2 * 100;