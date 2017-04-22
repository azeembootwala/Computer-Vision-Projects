function[outliers]= mask(pointcloud,bestparameter,bestnormal,threshold)
Msk=pointcloud;
       
    [rows,columns,k] = size(Msk);
   
        
            for i=1:rows;
                for p=1:columns;
                    
                     x1= Msk(i,p,1);
    
                     y1= Msk(i,p,2);
   
                     z1=Msk(i,p,3);
                     point=[x1,y1,z1];
                     
                
          
                distance = bestparameter+dot(bestnormal,point);
            if  abs(distance)<threshold;
                Msk(i,p,1:k)=0;
            else
                Msk(i,p,1:k)=1;
               
            end
             end
         end
                
         
            
        
      figure 
      
       imagesc(Msk(:,:,3));
       se = strel('rectangle',[2,2]);
       a1 = imclose(Msk(:,:,3),se);
      a1=imopen(a1,se);
      cc=bwconncomp(a1);
       outliers = pointcloud.*Msk;
     
       figure
       imagesc(a1);
    
  
