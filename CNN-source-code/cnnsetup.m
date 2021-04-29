%%  %%%%%%%%%% Initialization%%%%%%%%%%%%%%
function net=cnnsetup(net,x,y)
%net=cnn;


layers_number=length(net.layers);


inputmaps=1;

outputmaps=1; 


mapsize=size(x(:,:,1));


for layer=2:layers_number
   
    if strcmp(net.layers{layer}.type,'sub-sampling-layer')
        
        scale=net.layers{layer}.scale;
        
        mapsize=mapsize/scale;
       
        for j=1:inputmaps
            net.layers{layer}.b{j}=0;
        end
    end
    
 
    if strcmp(net.layers{layer}.type,'convolution-layer')
        
       mapsize=mapsize-net.layers{layer}.kernelsize+1;
        
        for j=1:net.layers{layer}.outputmaps 
         
            fan_out=net.layers{layer}.outputmaps*net.layers{layer}.kernelsize^2;
          
            for i=1:inputmaps
               
                fan_in=inputmaps*net.layers{layer}.kernelsize^2;
               
                net.layers{layer}.k{i,j}=(rand(net.layers{layer}.kernelsize)-0.5)*2*sqrt(6/(fan_in+fan_out));
            end
           
            net.layers{layer}.b{j}=0;
        end
      
        inputmaps=net.layers{layer}.outputmaps;
    end
    
end 

fvnum=prod(mapsize)*inputmaps;

onum=size(y,1);


net.ffW=(rand(onum,fvnum)-0.5)*2*sqrt(6/(onum+fvnum));

net.ffb=zeros(onum,1);