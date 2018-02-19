%Assignment 2
%Part1 a
clear all
close all

img = zeros([512,512]);
for x = 1:512
    for y = 1:512
        img(x,y) = sin(0.2*x)+sin(0.3*x)+cos(0.4*x)+sin(sqrt(x^2+y^2)*0.15)+ ...
                    sin(sqrt(x^2+y^2)*0.35);
    end
end

img_dft = fft2(img);
%Use the log for the perceptual scaling, and +1 since log(0) is
%undefined. Use the mat2gray to scale image btw 0 to 1.
figure
subplot(2,2,1)
imshow(img)
title("Original Image")
subplot(2,2,2)
imshow(mat2gray(log(fftshift(abs(img_dft) + 1))));
title("Log Magnitude Plot")
subplot(2,2,3)
imshow(mat2gray(fftshift(angle(img_dft))));
title("Phase Plot")

new_img_dft = abs(img_dft)*2;
subplot(2,2,4)
new_img = ifft2(new_img_dft.*exp(1i*angle(new_img_dft)));
imshow(new_img)
title("New Image after Doubling the frequency")


            