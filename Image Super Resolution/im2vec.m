function [ output_vector ] = im2vec( image )
    
[p,q]=size(image);
output_vector=zeros(p*q,1);
output_vector=reshape(image,p*q,1);


end

