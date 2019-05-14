clear all
clc

cd yalefaces
% get a list of all the files in the current directory
[stat, flist] = fileattrib('*');

% Read in jpg and pgm files only; Assume that all files are the same size.
% for the yale face repository all files are gifs
% find number of files
nfiles = max(size(flist));


data = zeros(nfiles,64*64);
facemean = zeros(64,64);
cnt = 0;
for imloop = 1:nfiles
    fn = flist(imloop).Name;
    x = imread(fn,'gif');
    x = double(imresize(x,[64 64]));
    facemean = facemean + x; cnt=cnt+1;
    %figure,imagesc(x);
    data(imloop,:) = reshape(x,1,size(x,1)*size(x,2));
end
cd ..  % get out of images data directory


% display four images
imview = [reshape(data(2,:),64,64),reshape(data(6,:),64,64);reshape(data(8,:),64,64),reshape(data(10,:),64,64)];
figure;imagesc(imview);colormap(gray);title('Different expressions');
imview = [reshape(data(2,:),64,64),reshape(data(13,:),64,64);reshape(data(24,:),64,64),reshape(data(35,:),64,64)];
figure;imagesc(imview);colormap(gray);title('Different Faces');

save imagesall data;
facemean = facemean/cnt; %Find image mean
figure;imagesc(facemean);colormap(gray);title('Image Mean');
% subtract mean from all images
data_mean = data - ones(cnt,1)*reshape(facemean,1,64*64);
% do PCA 
[v,mu] = eig(data_mean*data_mean');
mu=diag(mu);
percent_explained = 100*mu/sum(mu);
figure;pareto(percent_explained)
xlabel('Principal Component')
ylabel('Variance Explained (%)')

% transform data
ef=(data'*v)';
imview = [reshape(ef(4,:),64,64)];
figure;imagesc(imview);colormap(gray);title('First 4 eigenfaces');

save eig ef facemean