function Number=divid_data(net,x,y)
%x=train_x;y=train_y;net=cnn;
%% ѵ����������
Samples_Number=size(x,3);
%% ÿ��Ĺ�ģ
batchsize=net.options.batchsize;
%% ���ֵ�����
Class_Number=ceil(Samples_Number/batchsize);
%% ��������
Number_Sort=randperm(Samples_Number);
%% �������
Number={};
for n=1:Class_Number-1
    Number{n}=Number_Sort((n-1)*batchsize+1:n*batchsize);
end
Number{n}=Number_Sort(n*batchsize+1:end);