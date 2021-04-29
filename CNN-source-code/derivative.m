
function net=derivative(net,x,y)

layers_number=length(net.layers);

Picture_Number=size(x,3);
%Picture_Number=1;

error=net.predict-y;
net.error=error;

Loss=(sum(error(:).^2))/2/size(error,2);
net.Loss=Loss;


net.d_predict=net.error.*different(net.predict);

net.d_ffv=net.ffW'*net.d_predict;

if strcmp(net.layers{end}.type,'convolution-layer')
    net.d_ffv=net.d_ffv*different(net.ffv);
end

mapsize=size(net.layers{end}.output{1});
fvnum=mapsize(1)*mapsize(2);

for j=1:length(net.layers{end}.output)
   
    output=net.d_ffv((j-1)*fvnum+1:j*fvnum,:);
 
    net.layers{end}.d{j}=reshape(output,mapsize(1),mapsize(2),mapsize(3));
end

%% 
for layer=(layers_number-1):-1:1
    %% 
    if strcmp(net.layers{layer}.type,'convolution-layer')
        %% 
        outputmaps=length(net.layers{layer}.output);
        %%
        for j=1:outputmaps % 
            %% 
            output=net.layers{layer}.output{j};
            %%
            dj_add_1=net.layers{layer+1}.d{j};
            %% 
            scale=net.layers{layer+1}.scale;
            %% 
            dj=different(output);
            %%
            dj=dj.*(expand(dj_add_1,[scale,scale,1])/(scale^2));
            %%
            net.layers{layer}.d{j}=dj;
        end
    end
    
    %% 
    if strcmp(net.layers{layer}.type,'sub-sampling-layer')
        %% 
        output=net.layers{layer}.output;
        %% 
        mapsize=size(output{1});
        %%
        for i=1:length(net.layers{layer}.output)
            output=zeros(mapsize);
            for j=1:length(net.layers{layer+1}.output)
                output=output+convn(net.layers{layer+1}.d{j},rot180(net.layers{layer+1}.k{i,j}),'full');
            end
            %%
            net.layers{layer}.d{i}=output;
        end
    end
    
end


for layer=1:layers_number
     
    if strcmp(net.layers{layer}.type,'convolution-layer')
       for j=1:length(net.layers{layer}.output)
          for i=1:length(net.layers{layer-1}.output)
            
             net.layers{layer}.dk{i,j}=convn(flipall(net.layers{layer-1}.output{i}),net.layers{layer}.d{j},'valid')/Picture_Number;
          end
          
         
          net.layers{layer}.db{j}=sum(net.layers{layer}.d{j}(:))/Picture_Number;
       end
    end
    
end


net.dffW=net.d_predict*(net.ffv)'/size(net.d_predict,2);
net.dffb=mean(net.d_predict,2);