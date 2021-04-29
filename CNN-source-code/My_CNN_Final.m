clear all
clc

%% load data
load mnist_uint8;
%% Taining Numbers
train_number=2000;
%% Predicting Numbers
test_number=1000;
%%
train_x = double(reshape(train_x(1:train_number,:)',28,28,train_number))/255;
test_x = double(reshape(test_x(1:test_number,:)',28,28,test_number))/255;
train_y = double(train_y(1:train_number,:)');
test_y = double(test_y(1:test_number,:)');

%%  Set network parameters
cnn=Set_Parameter();

%% Initialization
cnn=cnnsetup(cnn,train_x,train_y);

%% %%%%%%%%%% Circulation Calculation %%%%%%%%%%%%%%
%% Record history 
History=[];
for iter=1:cnn.options.iterations
    %% Seperate data
    Number=divid_data(cnn,train_x,train_y);
    %% Tain the seperated data
    for n=1:length(Number)
        
        %% n-th data
        x=train_x(:,:,Number{n});
        y=train_y(:,Number{n});
        %% calculate the network output
        cnn=cnnff(cnn,x);
        %% calculate differential
        cnn=derivative(cnn,x,y);
        %% original data
        cnn_old=cnn;
        
        %% Update weight and threshold
        cnn=Update(cnn,x,y);
    end
    

    %% loss function value
    loss=cnn.Loss;
    %% record
    History(iter)=loss;
    %% print
    disp(['n',num2str(iter),'/',num2str(cnn.options.iterations),'-th iteration error is ',num2str(loss)])
end

%% Predict
predict_y=predict(cnn,test_x);
%% Real Value
[~,real]=max(test_y);
real=real-1;
%% Calculate accuracy
real_ratio=sum(predict_y-real==0)/length(predict_y);
disp(['The accuracy of predicted group: ',num2str(real_ratio*100),'%'])

%% Plot
figure(1)
plot(History,'linewidth',2);
xlabel('Iteration Times');
ylabel('Loss');
title('Loss Function');
