N = length(annotations);

%test if this ordinate is to locate the car in the picture


for i = 1 : N
    %read the picture and trancate it and transfer to gray pic
    pathname = '../cars_train/'; 
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
    %I2 = im2uint8(eigen);
    %imshow(I2);
    
    %save the eigen cars
    s = num2str(i);
    s = strcat(s,'.jpg');
    imwrite(eigen,s,'JPEG');
end
