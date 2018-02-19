img = imread('psnr2.png');
img = rgb2gray(img);
img = imresize(img, [64 64]);
img = im2double(img);
result = cell(4, 2);
raw = img;
result{1, 1} = raw;

img = fft2(img);
img = fftshift(img);
magnitude = mat2gray(log(abs(img) + 1));
result{1, 2} = magnitude;

subplot(2, 4, 1), imshow(result{1, 1}), title(sprintf('Origin, Size = %d * %d', size(img, 1), size(img, 2)));
subplot(2, 4, 5), imshow(result{1, 2}), title(sprintf('Magnitude Plot, Size = %d * %d', size(img, 1), size(img, 2)));
    
newSize = size(img);
for i = 2:4
    newSize = 2 * newSize;
    newImg = zeros(newSize);
    newImg(1:64, 1:64) = raw;
    result{i, 1} = newImg;
    
    newImg = fft2(newImg);
    newImg = fftshift(newImg);
    magnitude = mat2gray(log(abs(newImg) + 1));
    result{i, 2} = magnitude;
    
    subplot(2, 4, i), imshow(result{i, 1}), title(sprintf('Origin, Size = %d * %d', size(newImg, 1), size(newImg, 2)));
    subplot(2, 4, i + 4), imshow(result{i, 2}), title(sprintf('Magnitude Plot, Size = %d * %d', size(newImg, 1), size(newImg, 2)));
end
