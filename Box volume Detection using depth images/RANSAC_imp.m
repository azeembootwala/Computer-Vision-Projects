
function[bestpoint,bestnormal,maxinliers,minoutliers]= RANSAC_imp(pointM,threshold,iteration)

maxinliers=0;
bestpoint=0;
minoutliers=0;
points = zeros(3);
length = size(pointM);




for i=1:iteration
    inliers=0;
   outl=0;
     rand_row_index=randperm(length(1),3);
             for i=1:3
                points(i,:)=pointM(rand_row_index(i),:);
             end
               
    v1=points(1,:)-points(2,:);
    v2=points(1,:)-points(3,:);

    c=cross(v1,v2);
    c=c/norm(c);
    d=dot(-c,points(1,:));
    
    
    % PLANE EQ
       
    for j=1:length(1);
       
        point4 = pointM(j,:);
       
       
 
        distance= d+dot(c,point4);
      

        if abs(distance)<threshold;
            inliers=inliers+1;
            
        else
            outl=outl+1;
        end
    end
    
    
    if maxinliers<inliers;
        maxinliers=inliers;
       
        bestnormal=c;
        bestpoint=d;
        minoutliers=outl;
        
    end
        
end



[xx,yy]=ndgrid(1:10,1:10);

zz = (-bestnormal(1)*xx - bestnormal(2)*yy - bestpoint)/bestnormal(3);
figure (2);
surf(xx,yy,zz);
hold on

