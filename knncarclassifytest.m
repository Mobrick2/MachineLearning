N = length(annotations);
label = zeros(1,N);
for i = 1 : N
    %read the picture and trancate it and transfer to gray pic
    pathname = 'cars_test/'; 
    pathname = strcat(pathname,annotations(i).fname);
    pic = imread(pathname);
    subimg = pic(annotations(i).bbox_y1:annotations(i).bbox_y2,...
        annotations(i).bbox_x1:annotations(i).bbox_x2,:);
    
    if size(subimg,3) > 1
        subimg = rgb2gray(subimg);
    end
    %imshow(subimg);
    
    %adjust the image to the same size
    %[m,n]=size(subimg);
    %if n >= 500
        temp = imresize(subimg,[300,500]);
    %end
    
    %get eigen vector for each class
    dim = 50;
    [V,S,U]=svd(im2double(temp));
    v = V(:,1:dim);
    s = S(1:dim,:);
    u = U(1:dim,:);
    eigen = v*s*u';
    eigen = reshape(eigen,1,15000);
    IDX = knnsearch(data,eigen,'K',5);
    classarray = zeros(1,196);
    for j = 1 : length(IDX)
       classarray( annotationsT(IDX(j)).class ) = ...
           classarray( annotationsT(IDX(j)).class ) + 1;
    end
    %decide label
    index = find(classarray == max(classarray));
    %if have mutiple max, choose the first one
    label(i) = index(1);
end
