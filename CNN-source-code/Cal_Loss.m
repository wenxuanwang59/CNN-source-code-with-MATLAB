function Loss=Cal_Loss(net,x,y)
%% Calculate loss
%% Use network to calculate function value
%% Calculate predict value
net0=cnnff(net,x);
predict_y=net0.predict;
error=predict_y-y;
%% Calculate loss function and mean square error
Loss=(sum(error(:).^2))/2/size(error,2);