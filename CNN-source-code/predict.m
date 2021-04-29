function predict_y=predict(net,x)



net=cnnff(net,x);
predict_y=net.predict;


[Max,Index]=max(predict_y);
predict_y=Index-1;