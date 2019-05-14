% function add_noise(database)
clear all
close all
clc

load Yaledatabase.mat
[m,n] = size(data);

nSub=15; % 15 subjects
nPic=11; % each subject has 11 images
nTrain=5; % pick 5 images from each subject for test and rest images for training

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

noise_size = 20;original_image_x = 64;
for i=1:nTrain*nSub
    noise=255*randi([0,1],[noise_size,noise_size]);
    temp = reshape(train_set(i,:),[original_image_x,original_image_x]);
    random = randperm(original_image_x - noise_size);
    temp(random(1):random(1)+noise_size-1,random(1):random(1)+noise_size-1)=noise;
    train_set(i,:) = reshape(temp,[1,n]);
end
imshow(uint8(temp))
% % save(sprintf('%s_noise',database),'x_noise','ix_noise');