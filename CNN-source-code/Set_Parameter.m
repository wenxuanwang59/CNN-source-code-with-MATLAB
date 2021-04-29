
function cnn=Set_Parameter()
cnn.layers={
   
    struct('type','input-layer')
    
    struct('type','convolution-layer','outputmaps',6,'kernelsize',5);
  
    struct('type','sub-sampling-layer','scale',2)
    
    struct('type','convolution-layer','outputmaps',5,'kernelsize',5)
  
    struct('type','sub-sampling-layer','scale',2)
    };


cnn.options.alpha=0.9937;

cnn.options.batchsize=20;

cnn.options.iterations=50;
