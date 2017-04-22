%close all
%clear all
clc

 %load('C:\Users\Azeem\AppData\Local\Temp\temp4047026006024658253tmp\lowResData.mat')

%%converting cartisian pixel codinates of the image in to homogenous
%%codinates
magnification_factor=3;

[len_x,len_y,N]=size(LRImages);
length_x_hr=magnification_factor*len_x;
lenght_y_hr=magnification_factor*len_y;

[y_gv ,x_gv]=meshgrid(1:length_x_hr,1:lenght_y_hr);


new_imagecod=ones(2793,3);
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
new_imagecod_f=zeros(2793,3);
new_imagecod_f(:,1)=new_imagecod(:,2);
new_imagecod_f(:,2)=new_imagecod(:,1);
new_imagecod_f(:,3)=new_imagecod(:,3);

%%% in the end we get a N*3 matrix that has pixel codinates for each point
%%% in image 

%%using the magnification factor s=3 as should be greater than s>1 and
%%multiplying the homography with the magnification factor 

%%Multiplying image codinates into scaled homography to get homographic
%%image codinates
corr_cod=zeros(2793,3,26);
X_corr=zeros(72618,1);
Y_corr=zeros(72618,1);

for i=1:N;
    H=motionParams{i};
    for j=1:2793;
       corr_cod(j,1:3,i)=H*new_imagecod_f(j,:)';
       
       corr_cod(j,1,i)=magnification_factor*corr_cod(j,1,i)/corr_cod(j,3,i);
       corr_cod(j,2,i)=magnification_factor*corr_cod(j,2,i)/corr_cod(j,3,i);
    end
end
p=1;
k=1;
    
        for i=1:72618;
            X_corr(i,1)=corr_cod(p,1,k);
            Y_corr(i,1)=corr_cod(p,2,k);
            p=p+1;
            if p>2793;
               p=1;
               k=k+1;
            end
        end
    

frames=26;
intensity=2793;
p=1;
q=1;
pixel_intensity=ones(intensity,frames);
for i=1:frames;
    for j=1:intensity;
        
        pixel_intensity(j,i)=LRImages(p,q,i);
        q=q+1;
            if q>49;
            q=1;
            p=p+1;
            end
    end
             if p>57;
                p=1;
             end
end
p=1;
q=1;
    v=zeros(72618,1);
    for j=1:72618;
        v(j,1)=pixel_intensity(p,q);
        p=p+1;
        if p>2793;
            p=1;
            q=q+1;
        end
    end
    
    
result=griddata(Y_corr,X_corr,v,x_gv,y_gv,'cubic');

figure(1);
imshow(LRImages(:,:,1));
figure(2);
imshow(result);




    
      
        
        
       
       
