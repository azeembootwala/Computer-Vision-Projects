close all 
%clear all 
clc
%load('C:\study\CV\ex04\exercise-04-material\lowResData.mat');

magnification_factor=3;
[len_x_lr,len_y_lr,N]=size(LRImages(:,:,:));
input_images=10;
max_itr=200;
alpha=0.05;
lambda=0.001;
W_set=cell(input_images,1);
intensity_cell=cell(input_images,1);

% creating an up sampled version of the first image 
len_x_hr=magnification_factor*len_x_lr;
len_y_hr=magnification_factor*len_y_lr;

[y_gv ,x_gv]=meshgrid(linspace(1,len_x_lr,len_x_hr),linspace(1,len_y_lr,len_y_hr));

%intensity gathering
p=1;
q=1;
pixel_intensity=zeros(2793,1);
for i=1:2793;
    pixel_intensity(i,1)=LRImages(p,q,1);
    q=q+1;
    if q>49;
        q=1;
        p=p+1;
    end
end

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
  [up_image]=griddata(new_imagecod(:,2),new_imagecod(:,1),pixel_intensity(:,1),x_gv',y_gv','cubic'); 
imshow(up_image);


W_set=cell(input_images,1);
Y_set=cell(input_images,1);

for i=1:input_images
  W_set{i,1}=composeSystemMatrix([len_y_lr,len_x_lr],3,0.5,motionParams{1,i});
  Y_set{i,1}=im2vec(LRImages(:,:,i));
end

% Creating regularizers for optimization using gausian prior 
%%Dimentions of the resulting image 
d=[0,1];
e=[0,49];
new_dimentions=len_x_hr*len_y_hr;
Matrix=ones(new_dimentions,2);
Matrix(:,2)=-Matrix(:,1);
Matrix(new_dimentions-1,2)=0;
Q_u=spdiags(Matrix,d,new_dimentions,new_dimentions);
Q_v=spdiags(Matrix,e,new_dimentions,new_dimentions);
R_x_g=(Q_u+Q_v)'*(Q_u+Q_v);
x0=im2vec(up_image);
x=x0;
%optimization process
for j=1:max_itr
    error(j)=0;
for i=1:input_images;
    temp=Y_set{i}- W_set{i}*x;
    
    direction_pt=-2*W_set{i}'*temp+2.*lambda.*R_x_g*x;
   
    error(j)=error(j)+norm(temp)^2;
    x=x-alpha.*direction_pt;
    
end
end
output=vec2im(x,len_x_hr,len_y_hr);
figure()
imshow(output);
title('Gausian prior');
figure()
plot(1:max_itr,error);

%using Tv regularizer

R_x_tv=(1/sqrt(norm(Q_u*x)^2+norm(Q_v*x)^2)*((Q_u'*Q_u)+(Q_v'*Q_v)));
direction_pt_zomat=zeros(25137,input_images);
for j=1:max_itr
    error(j)=0;
for i=1:input_images;
    temp=Y_set{i}- W_set{i}*x;
    
    direction_pt(:,i)=-2*W_set{i}'*temp+lambda.*R_x_tv*x;
   
    error(j)=error(j)+norm(temp)^2;
    
    
end
pt=input_images*median(direction_pt_zomat,2);
x=x-alpha*pt;

end
output_tv=vec2im(x,len_x_hr,len_y_hr);
figure()
imshow(output_tv);
title('tv');





