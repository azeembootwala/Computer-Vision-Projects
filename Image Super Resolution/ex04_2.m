
%close all 
%clear all 
clc
%load('C:\study\CV\ex04\exercise-04-material\lowResData.mat');
magnification_factor=3;
[len_x_lr,len_y_lr,N]=size(LRImages(:,:,:));
input_images=4;
max_itr=100;
alpha=0.05;
W_set=cell(input_images,1);
intensity_cell=cell(input_images,1);

homographies=cell2mat(motionParams);
for i=1:input_images
lr_vec=zeros(2793,1);  
W_set{i,1} = composeSystemMatrix([len_y_lr,len_x_lr],3,0.5,motionParams{i});
end
W_cat=cat(1,W_set{1,1},W_set{2,1},W_set{3,1},W_set{4,1});


len_x_hr=magnification_factor*len_x_lr;
len_y_hr=magnification_factor*len_y_lr;

[y_gv ,x_gv]=meshgrid(linspace(1,len_x_lr,len_x_hr),linspace(1,len_y_lr,len_y_hr));
v_intensity=zeros(2793,1);

new_imagecod=ones(2793,2);
u=1;
v=1;
for i=1:2793;
    
    new_imagecod(i,1)=u;
    new_imagecod(i,2)=v;
    v=v+1;
    if v>49;
        
      u=u+1;
      v=1;
    end
    if u>57;
       u=1;
    end
  
end

p=1;
q=1;
pixel_intensity=ones(2793,1);

    for j=1:2793;
        
        pixel_intensity(j,1)=LRImages(p,q,1);
        q=q+1;
            if q>49;
            q=1;
            p=p+1;
            end
    end
             if p>57;
                p=1;
             end

up_image=griddata(new_imagecod(:,2),new_imagecod(:,1),pixel_intensity(:,1),x_gv',y_gv','cubic');
    figure()    
imshow(up_image);
title('up image');
y_set=cell(input_images,1);
for j=1:input_images;
    y_set{j}=im2vec(LRImages(:,:,j));
end
Y_big=cat(1,y_set{1,1},y_set{2,1},y_set{3,1},y_set{4,1});
error=zeros(max_itr,1);
x0=im2vec(up_image);
x=x0;
for j=1:max_itr   % ML  estimate where x is the first image and we optimise  X it with equations % 6 $ 5 IN EXERCISE SHEETS 
    error(j)=0;
for i=1:input_images;
    temp=Y_big-W_cat*x;
    
    direction_pt_1=-2*W_cat'*temp;
    
    error(j)=error(j)+norm(temp)^2;
    
   

end
 x=x-alpha.*direction_pt;
end
fprintf('Iteration number: %d\n', j);
fprintf('error: %f\n', error(j));
output=vec2im(x,len_x_hr,len_y_hr);  
figure()
plot(1:max_itr,error);
figure()  
imshow(output);
title('high res ML energy');

%Zomet method 
direction_pt_zomat=zeros(25137,input_images); % here we for first image solve for equations and collect pt in a vector 
for j=1:max_itr;
    error(j)=0;
    for i=1:input_images;
     temp=y_set{i}-W_set{i}*x;
    
    direction_pt_zomat(:,i)=-2*W_set{i}'*temp;
    error(j)=error(j)+norm(temp)^2;
    end
    pt=input_images*median(direction_pt_zomat,2);
    x=x-alpha*pt;
end
figure()
plot(1:max_itr,error);
zomat=vec2im(x,len_x_hr,len_y_hr);
figure()
imshow(zomat)
title(' ML for zomat method');
    

        