%%  %%%%%%%%%% Calculate the network output  %%%%%%%%%%%%%%
function net=cnnff(net,x)
%% layers{}.output:record every layer output
%net=cnn;
%% layer numbers
layers_number=length(net.layers);
inputmaps=1;% no convolution in 1st layer

%% image size
mapsize=size(x(:,:,1));

%% original image
net.layers{1}.output{1}=x;

%%calculation from wnd layer
for layer=2:layers_number
    %% if it is convolution layer
    if strcmp(net.layers{layer}.type,'convolution-layer')
        %% update image size
        mapsize=mapsize-net.layers{layer}.kernelsize+1;
        %% use different kernal
        for j=1:net.layers{layer}.outputmaps
            
            % save convolution resullt
            output=zeros(mapsize);
            % calculate convolution and sum
            for i=1:inputmaps
                % weight
                k=net.layers{layer}.k{i,j};
                % input
                input=net.layers{layer-1}.output{i};
                % convolution
                output=output+convn(input,k,'valid');
            end
            % add threshold
            output=output+net.layers{layer}.b{j};
            % activate activation function
            output=TransferFunction(output);
            % save output
            net.layers{layer}.output{j}=output;
        end % calculate convolution layer
        
        %% modify the next input numbers
        inputmaps=net.layers{layer}.outputmaps;
    end
    
    %% if it is a downsampling layer
    if strcmp(net.layers{layer}.type,'sub-sampling-layer')
        %% size
        scale=net.layers{layer}.scale;
        %%update size
        mapsize=mapsize/scale;
        %%  reduce size
        for i=1:inputmaps
            
            k=ones(scale)/(scale^2);
         
            input=net.layers{layer-1}.output{i};
           
            output=convn(input,k,'valid');
          
            output=output(1:scale:end,1:scale:end,:);
          
            j=i;
            net.layers{layer}.output{j}=output;
        end
    end 
    
    
end 

%% the output layer. let output be 1-D
ffv=[];
% the output
end_output=net.layers{end}.output;

for j=1:length(end_output)
    
    output=end_output{j};
    
    mapsize=size(output);
    
    ffv=[ffv;reshape(output,mapsize(1)*mapsize(2),mapsize(3))];
end

predict=net.ffW*ffv+net.ffb;

predict=TransferFunction(predict);

net.predict=predict;

net.ffv=ffv;