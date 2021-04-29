
function net=Update(net,x,y)
%%
layers_number=length(net.layers);
%% 
for layer=1:layers_number
    %%
    if strcmp(net.layers{layer}.type,'convolution-layer')
       for j=1:length(net.layers{layer}.output)
          for i=1:length(net.layers{layer-1}.output)
             %% 
             net.layers{layer}.k{i,j}=net.layers{layer}.k{i,j}-net.options.alpha*net.layers{layer}.dk{i,j};
          end
          %%
          net.layers{layer}.b{j}=net.layers{layer}.b{j}-net.options.alpha*net.layers{layer}.db{j};
       end
    end % 
    
end
net.ffW=net.ffW-net.options.alpha*net.dffW;
net.ffb=net.ffb-net.options.alpha*net.dffb;