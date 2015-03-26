clear all; 
clc; 

folder = 'gambar 1'; 
dirImage = dir( folder ); 

numData = size(dirImage,1); 

M ={} ; 

% baca data gambar
for i=1:numData
    nama = dirImage(i).name;  
    if regexp(nama, '(lion|tiger)-[0-9]{1,2}.jpg')
        B = cell(1,2); 
        if regexp(nama, 'lion-[0-9]{1,2}.jpg')
            B{1,1} = double(imread([folder, '/', nama]));
            B{1,2} = 1; 
        elseif regexp(nama, 'tiger-[0-9]{1,2}.jpg')
            B{1,1} = double(imread([folder, '/', nama]));
            B{1,2} = -1; 
        end
        M = cat(1,M,B); 
    end 
end

% konversi gambar untuk keperluan SVM
numDataTrain = size(M,1); 
class = zeros(numDataTrain,1);
arrayImage = zeros(numDataTrain, 300 * 300);

for i=1:numDataTrain
    im = M{i,1} ;
    im = rgb2gray(im); 
    im = imresize(im, [300 300]); 
    im = reshape(im', 1, 300*300); 
    arrayImage(i,:) = im; 
    class(i) = M{i,2}; 
end

SVMStruct = svmtrain(arrayImage, class);

% test untuk lion
lionTest = double(imread('gambar 1/lion-test.jpg' )); 
lionTest = rgb2gray(lionTest); 
lionTest = imresize(lionTest, [300 300]); 
lionTest = reshape(lionTest',1, 300*300); 
result = svmclassify(SVMStruct, lionTest);  

result 



