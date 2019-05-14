%%%%%%%%%%%%%%%%%%%%%%%%%%
% nima sedghiye 96131051 %
% Project                %
% 2018/07/15             %
%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc

load Yaledatabase.mat
[m,n] = size(data);

nSub=15; % 15 subjects
nPic=11; % each subject has 11 images
nTrain=4; % pick 5 images from each subject for test and rest images for training

Y = zeros(nSub*nPic,1);j=1;
train_set = zeros(nTrain*nSub,n);k=1;y_train = zeros(nTrain*nSub,1);
test_set = zeros((nSub*nPic - nTrain*nSub),n);y_test = zeros((nSub*nPic - nTrain*nSub),1);l=1;

for i=1:nPic:nSub*nPic
    Y(i:i+nPic-1) = j;
    
    
    % train and test data split
    rand_train = randperm(nPic);
    train_set(k:k+nTrain-1,:)= data(rand_train(1:nTrain)+i-1,:);
    y_train(k:k+nTrain-1,1)= j;
    
    test_set(l:l+nPic-nTrain-1,:)= data(rand_train(nTrain+1:nPic)+i-1,:);
    y_test(l:l+nPic-nTrain-1,1)= j;
    
    k = k + nTrain;
    l=l+ nPic- nTrain;
    j = j+1;
end

figure;
dim = [5,10,20,30,40,50,60];

w = PCA_L1AR(train_set,1.1);
accuracy = zeros(size(dim,1),1);i=1;
for dimension = dim
    newTrain = train_set*w(:,1:dimension);
    newTest = test_set *w(:,1:dimension);
    prediction = knnclassify(newTest, newTrain, y_train, 10);
    testError = sum(sum(prediction ~= y_test)/90);
    accuracy(i)=1-testError;
    i= i+1;
end

plot(dim,accuracy,'r-*');
hold on;
xlabel('dimension');ylabel('Recognition Accuracy');


% accuracy = zeros(size(dim,1),1);i=1;
% for dimension = dim
%     w = PCA2DL1S(train_set,1,dimension);
%     newTrain = train_set*w;
%     newTest = test_set *w;
%     prediction = knnclassify(newTest, newTrain, y_train, 10);
%     testError = sum(sum(prediction ~= y_test)/90);
%     accuracy(i)=1-testError;
%     i= i+1;
% end
% plot(dim,accuracy,'b-o');