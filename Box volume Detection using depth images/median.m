AX=A0(:,:,1);
AY=A0(:,:,2);
AZ=A0(:,:,3);
%%AXF=medfilt2(AX); Filteration for the x & y axis of the image 
%%AYF=medfilt2(AY);
AZF=medfilt2(AZ);
subplot(2,2,1);
imagesc(AZ);
title('OG image');
subplot(2,2,2);
imagesc(AZF);
title('median filtered image');
figure(2);
scatter3(AX(:),AY(:),AZ(:));
hold on
[bestparameter,bestnormal,maxinliers]=RANSAC_imp(A0,0.05,40);
