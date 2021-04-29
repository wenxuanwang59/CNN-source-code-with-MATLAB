function Number=divid_data(net,x,y)
%x=train_x;y=train_y;net=cnn;
%% 训练样本总数
Samples_Number=size(x,3);
%% 每组的规模
batchsize=net.options.batchsize;
%% 划分的组数
Class_Number=ceil(Samples_Number/batchsize);
%% 乱序排列
Number_Sort=randperm(Samples_Number);
%% 样本编号
Number={};
for n=1:Class_Number-1
    Number{n}=Number_Sort((n-1)*batchsize+1:n*batchsize);
end
Number{n}=Number_Sort(n*batchsize+1:end);