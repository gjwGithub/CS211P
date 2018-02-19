clear;

A = imread('flowergray.jpg');
A = imresize(A, 100 / 256);
A = im2double(A);

% a
x = A(:);
x = sort(x);
subplot(1,8,1), plot(x), title('a');

% b
subplot(1,8,2);
h = histogram(A);
title('b');
h.NumBins = 32;

% c
t = 0.5;
c = A <= t;
img = mat2gray(c);
subplot(1,8,3), imshow(img), title('c');

% d
avg = mean(A);
d = A - avg;
d(d < 0) = 0;
img = mat2gray(d);
subplot(1,8,4), imshow(img), title('d');

% e
y = 1:8;
s = reshape(y, [4, 2]);

% f
vector = 1:2:99;
AA = A(vector, vector);

% g
filter1 = fspecial('gaussian', 2, 2);
gaussian1 = imfilter(A, filter1, 'replicate');
subplot(1,8,5), imshow(gaussian1), title('g1');
filter2 = fspecial('gaussian', 2, 10);
gaussian2 = imfilter(A, filter2, 'replicate');
subplot(1,8,6), imshow(gaussian2), title('g2');
filter3 = fspecial('gaussian', 10, 2);
gaussian3 = imfilter(A, filter3, 'replicate');
subplot(1,8,7), imshow(gaussian3), title('g3');

% h
gaussian31 = conv2(A, filter3);
subplot(1,8,8), imshow(gaussian31), title('h');