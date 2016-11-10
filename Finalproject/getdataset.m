run('/Users/Morbrick/Downloads/vlfeat-0.9.20/toolbox/vl_setup');
N = length(annotations);
testdataset = uint8(zeros(N,128*50));
for i = 1 : 1
    pathname = 'cars_train/'; 
    pathname = strcat(pathname,annotations(i).fname);
    pic = imread(pathname);
    
    %locate the car in the picture
    subimg = pic(annotations(i).bbox_y1:annotations(i).bbox_y2,...
        annotations(i).bbox_x1:annotations(i).bbox_x2,:);
    
    image(subimg);
    
    if size(subimg,3) > 1
        subimg = rgb2gray(subimg);
    end
    
    %convert the image to single pricision
    I = single(subimg);
    %get the features decriptor and the frame
    [f,d] = vl_sift(I) ;
    perm = randperm(size(f,2)) ;
    perm_len = length(perm);
    
    if  perm_len >= 50 
       sel = perm(1:50);
       dd = d(:,sel);
       %reshape and store the features
       testdataset(i,:) = dd(:)'; 
    else
       sel = perm(1:perm_len);
       dd = d(:,sel);
       testdataset(i,1:perm_len*128) = dd(:)'; 
    end
end