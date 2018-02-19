%Assignment 2
%part1 b

clear all
close all

img = double(rgb2gray(imread('Cross.jpg')));
subplot(2,2,1);
imshow(mat2gray(img));
title("Original Image");

img_dft = fft2(img);
subplot(2,2,2);
imshow(mat2gray(log(fftshift(abs(img_dft)) + 1)));
title("Log Magnitude Plot");

subplot(2,2,3);
imshow(angle(fftshift(img_dft)));
title("Phase Plot");

new_img = [img, img, img, img; 
           img, img, img, img;
           img, img, img, img;
           img, img, img, img];
subplot(2,2,4)
imshow(new_img)
title("Repeated Original Image")

