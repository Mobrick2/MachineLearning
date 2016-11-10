run('/Users/Morbrick/Downloads/vlfeat-0.9.20/toolbox/vl_setup');
N = length(annotations);
testlabel = zeros(1,N);
testdataset = zeros(N,200);
count = 0 ;
for i = 1 : N
    if annotations(i).class > 5
       continue; 
    end
    
    %count how many pictures from class 1 to 5
    count = count + 1;
    testlabel(count) = annotations(i).class;
    
    pathname = 'cars_test/'; 
    pathname = strcat(pathname,annotations(i).fname);
    pic = imread(pathname);
    
    %locate the car in the picture
    subimg = pic(annotations(i).bbox_y1:annotations(i).bbox_y2,...
        annotations(i).bbox_x1:annotations(i).bbox_x2,:);
    
    %image(subimg);
    
    if size(subimg,3) > 1
        subimg = rgb2gray(subimg);
    end
    
    %convert the image to single pricision
    I = single(subimg);
    %get the features decriptor and the frame
    [f,d] = vl_sift(I) ;
    d = d';
    [m,~] = size(d);
    
    %cluster to the decriptor to the 200 centers by knn
    for j = 1 : m
        idx = knnsearch(C,double(d(j,:)));
        testdataset(count,idx) = testdataset(count,idx)+1;
    end
end

testlabel = testlabel(1:count);
testdataset = testdataset(1:count,:);
for i =  1 : count
   %total = sum(testdataset(i,:));
   total = 1;
   testdataset(i,:) = testdataset(i,:) / total;
end
