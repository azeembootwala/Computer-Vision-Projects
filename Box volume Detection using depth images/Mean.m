AZ=A0(:,:,3);
subplot(2,2,3);
h=fspecial('gaussian',3);
BZ=filter2(h,AZ);

imagesc(BZ);
title('Gaussian filtered');
h=fspecial('average',3);
MZ=filter2(h,AZ);
subplot(2,2,4);
imagesc(MZ);
title('mean filtered');


    x= A0(:,:,1);%%generation of 3 matrices from a 3 -D mesh that forms an image 
    x=x(:);%% the x component of the image in vector form  
    y= A0(:,:,2);
    y=y(:);%% Y component of the image in vector form 
    z=A0(:,:,3);
    z=z(:);%% z component of the image in vector form sdss
    length = size(x);
    pointM=zeros(length(1),3);
    for i=1:length(1)
        pointM(i,1)=x(i);
        pointM(i,2)=y(i);
        pointM(i,3)=z(i);
    end
    

[bestparameter,bestnormal,maxinliersF,maxoutliersF]= RANSAC_imp(pointM,0.04,40);
[outliers]=mask(A0,bestparameter,bestnormal,0.04);



    x= outliers(:,:,1);%%generation of 3 matrices from a 3 -D mesh that forms an image 
    x1=x(:);%% the x component of the image in vector form  
    y= outliers(:,:,2);
    y1=y(:);%% Y component of the image in vector form 
    z=outliers(:,:,3);
    z1=z(:);%% z component of the image in vector form sdss
    length = size(x1);
    pointM=zeros(length(1),3);
    
    for i=1:length(1)
        pointM(i,1)=x1(i);
        pointM(i,2)=y1(i);
        pointM(i,3)=z1(i);
    end
    
%find indexes correponding to values not equal to zero
value_pts=find(pointM(:,3)~=0);
posSZ=size(value_pts);
pointN=zeros(posSZ(1),3);
    for i = 1:posSZ(1)
        pointN(i,:)=pointM(value_pts(i),:);
                 
    end
[bestparameter_T,bestnormal_T,maxinliersT,maxoutliersT]=RANSAC_imp(pointN,0.032,40);
    mask(A0,bestparameter_T,bestnormal_T,0.032);

%[bestparameter,bestnormal,maxoutliers]=RANSAC_imp(outliers,0.04,40);
%{
Hz=reshape(Z,[144,176]);
MZ=MZ*Hz
imagesc(Mz);
%}