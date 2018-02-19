allImgs = ["psnr2.png", "moonlanding.png"];
imgsNum = size(allImgs, 2);
result = cell(imgsNum, 4);

% 1
img = imread('moonlanding.png');
img = im2double(img);
result{1, 1} = img;

img = fft2(img);
img = fftshift(img);
magnitude = mat2gray(log(abs(img) + 1));
result{1, 2} = magnitude;

threshold = 70;
center = size(img) / 2;
distance = 40;
for i = 1:size(img, 1)
    for j = 1:size(img, 2)
        if abs(img(i, j)) > threshold && sqrt((i - center(1)) ^ 2 + (j - center(2)) ^ 2) > distance
            img(i, j) = 0;
        end
    end
end
filteredMagnitude = mat2gray(log(abs(img) + 1));
result{1, 3} = filteredMagnitude;

img = ifftshift(img);
img = ifft2(img);
result{1, 4} = img;

subplot(imgsNum, 4, 1), imshow(result{1, 1}), title('Origin');
subplot(imgsNum, 4, 2), imshow(result{1, 2}), title('Magnitude Plot');
subplot(imgsNum, 4, 3), imshow(result{1, 3}), title('Filtered Magnitude Plot');
subplot(imgsNum, 4, 4), imshow(real(result{1, 4})), title('Final Result');

% % 2
% img = imread('psnr2.png');
% img = rgb2gray(img);
% img = im2double(img);
% result{2, 1} = img;
% 
% img = fft2(img);
% img = fftshift(img);
% magnitude = mat2gray(log(abs(img) + 1));
% result{2, 2} = magnitude;
% 
% threshold = 55;
% center = size(img) / 2;
% distance = 15;
% for i = 1:size(img, 1)
%     for j = 1:size(img, 2)
%         if abs(img(i, j)) < threshold && sqrt((i - center(1)) ^ 2 + (j - center(2)) ^ 2) > distance
%             img(i, j) = 0;
%         end
%     end
% end
% diffs = zeros(size(img));
% for ii = 1:size(img, 1)
%     for jj = 1:size(img, 2)
%         diffCount = 0;
%         if ii > 1 && abs(img(ii - 1, jj)) == 0
%             diffCount = diffCount + 1;
%         end
%         if ii < size(img, 1) && abs(img(ii + 1, jj)) == 0
%             diffCount = diffCount + 1;
%         end
%         if jj > 1 && abs(img(ii, jj - 1)) == 0
%             diffCount = diffCount + 1;
%         end
%         if jj < size(img, 2) && abs(img(ii, jj + 1)) == 0
%             diffCount = diffCount + 1;
%         end
% 
%         if ii > 1 && jj > 1 && abs(img(ii - 1, jj - 1)) == 0
%             diffCount = diffCount + 1;
%         end
%         if ii < size(img, 1) && jj < size(img, 2) && abs(img(ii + 1, jj + 1)) == 0
%             diffCount = diffCount + 1;
%         end
%         if ii < size(img, 1) && jj > 1 && abs(img(ii + 1, jj - 1)) == 0
%             diffCount = diffCount + 1;
%         end
%         if ii > 1 && jj < size(img, 2) && abs(img(ii - 1, jj + 1)) == 0
%             diffCount = diffCount + 1;
%         end
% 
%         if diffCount > 6
%             diffs(ii, jj) = 1;
%         end
%     end
% end
% for i = 1:size(img, 1)
%     for j = 1:size(img, 2)
%         if diffs(i, j) == 1
%             img(i, j) = 0;    
%         end
%     end
% end
% filteredMagnitude = mat2gray(log(abs(img) + 1));
% result{2, 3} = filteredMagnitude;
% 
% img = ifftshift(img);
% img = ifft2(img);
% result{2, 4} = img;
% 
% subplot(imgsNum, 4, 5), imshow(result{2, 1}), title('Origin');
% subplot(imgsNum, 4, 6), imshow(result{2, 2}), title('Magnitude Plot');
% subplot(imgsNum, 4, 7), imshow(result{2, 3}), title('Filtered Magnitude Plot');
% subplot(imgsNum, 4, 8), imshow(real(result{2, 4})), title('Final Result');





% 2
img = imread('psnr2.png');
img = rgb2gray(img);
img = im2double(img);
result{3, 1} = img;

img = fft2(img);
img = fftshift(img);
magnitude = mat2gray(log(abs(img) + 1));
result{3, 2} = magnitude;

threshold = 55;
center = size(img) / 2;
distance = 40;
width = 2;
angles = [-70 -45 79 45 0];
gradient = tand(angles);
distance1 = 50;
distance2 = 120;

for i = 1:size(img, 1)
    for j = 1:size(img, 2)
        if sqrt((i - center(1)) ^ 2 + (j - center(2)) ^ 2) > distance % && abs(img(i, j)) < threshold
            found = false;
            for k = 1:size(gradient, 2)
                if j < gradient(k) * (i - center(1)) + center(2) + width / cosd(angles(k)) && j > gradient(k) * (i - center(1)) + center(2) - width / cosd(angles(k))
                    found = true;
                end
            end
            if i > center(1) - width && i < center(1) + width
               found = true; 
            end
            if ~found
                if sqrt((i - center(1)) ^ 2 + (j - center(2)) ^ 2) > distance1 && sqrt((i - center(1)) ^ 2 + (j - center(2)) ^ 2) < distance2
                    img(i, j) = 0;
                end
            end
        end
    end
end

filteredMagnitude = mat2gray(log(abs(img) + 1));
result{3, 3} = filteredMagnitude;

img = ifftshift(img);
img = ifft2(img);
result{3, 4} = img;

subplot(imgsNum, 4, 5), imshow(result{3, 1}), title('Origin');
subplot(imgsNum, 4, 6), imshow(result{3, 2}), title('Magnitude Plot');
subplot(imgsNum, 4, 7), imshow(result{3, 3}), title('Filtered Magnitude Plot');
subplot(imgsNum, 4, 8), imshow(real(result{3, 4})), title('Final Result');










% % 2
% img = imread('psnr2.png');
% img = rgb2gray(img);
% img = im2double(img);
% result{3, 1} = img;
% 
% img = fft2(img);
% img = fftshift(img);
% magnitude = mat2gray(log(abs(img) + 1));
% result{3, 2} = magnitude;
% 
% threshold = 55;
% center = size(img) / 2;
% distance1 = 50;
% distance2 = 120;
% width = 2;
% angles = [-70 -45 79 45 0];
% gradient = tand(angles);
% 
% for i = 1:size(img, 1)
%     for j = 1:size(img, 2)
%         if sqrt((i - center(1)) ^ 2 + (j - center(2)) ^ 2) > distance1 && sqrt((i - center(1)) ^ 2 + (j - center(2)) ^ 2) < distance2
%             img(i, j) = 1;
%         end
%     end
% end
% 
% filteredMagnitude = mat2gray(log(abs(img) + 1));
% result{3, 3} = filteredMagnitude;
% 
% img = ifftshift(img);
% img = ifft2(img);
% result{3, 4} = img;
% 
% subplot(imgsNum, 4, 5), imshow(result{3, 1}), title('Origin');
% subplot(imgsNum, 4, 6), imshow(result{3, 2}), title('Magnitude Plot');
% subplot(imgsNum, 4, 7), imshow(result{3, 3}), title('Filtered Magnitude Plot');
% subplot(imgsNum, 4, 8), imshow(real(result{3, 4})), title('Final Result');