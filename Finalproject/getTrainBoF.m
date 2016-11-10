run('/Users/Morbrick/Downloads/vlfeat-0.9.20/toolbox/vl_setup');
N = length(annotations);

unclusterdataset = zeros(600000,128);
scope = zeros(N,2);
count = 0 ;
index = 0 ;
for i = 1 : N
    
    if annotations(i).class > 5
       continue; 
    end
    
    %count how many pictures from class 1 to 5
    count = count + 1;
    
    pathname = 'cars_train/'; 
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
    unclusterdataset(index+1:index+m,:) = d;
    scope(count,1) = index+1;
    scope(count,2) = index+m;
    index = index + m ;
    
end

unclusterdataset = unclusterdataset(1:index,:);
scope = scope(1:count,:);

%use kmeans to get the bag of features
tic
[idx,C] = kmeans(unclusterdataset,200);
toc

dataset = zeros(count,500);
for i =  1 : count
   for j = scope(i,1) : scope(i,2)
      dataset(i,idx(j)) = dataset(i,idx(j)) + 1;
   end
   %total = sum(dataset(i,:));
   total = 1;
   dataset(i,:) = dataset(i,:) / total;
end

index = 1 ;
label = zeros(1,203);
for i = 1 : N
    if annotations(i).class <= 5
       label(index) = annotations(i).class;
       index = index + 1 ;
    end   
end