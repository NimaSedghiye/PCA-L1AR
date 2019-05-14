%%%%%%%%%%%%%%%%%%%%%%%%%%
% nima sedghiye 96131051 %
% Project                %
% 2018/07/15             %
%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc

mu = [0,0];
sigma = [10,8;8,10]; 
data = zeros(104,2);
data(1:100,:) = mvnrnd(mu,sigma,100);
data(101:104,:)= [-33,4;-28,7;-30,12;-25,16];

figure;
[COEFF,SCORE] = princomp(data);
[Qopt, Bopt] = PCA_L1(data,2);

w = PCA2DL1S(data',1,3);
w2 = PCA_L1AR(data,1.1);

m = COEFF(2)/COEFF(1);fun=@(x)m*x;
m2 = Bopt(2)/Bopt(1);fun2=@(x)m2*x;
m3 = w(2)/w(1);fun3=@(x)m3*x;
m4 = w2(2)/w2(1);fun4=@(x)m4*x;

h= fplot(fun,[-40,20]);hold on;set(h, 'Color', 'r');
h2= fplot(fun2,[-40,20]);hold on;set(h2, 'Color', 'k');
h3= fplot(fun3,[-40,20]);hold on;set(h3, 'Color', 'g');
h4= fplot(fun4,[-40,20]);hold on;set(h4, 'Color', 'm');
legend('PCA','PCA-l2','PCA-L1S','PCA-l1/AR','data','Location','southeast')

plot(data(:,1),data(:,2),'k*');xlim([-40 20]);ylim([-50 30]);




