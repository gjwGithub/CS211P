allImgs = ["CARTOON.jpg", "flowergray.jpg", "kitty.jpg", "polarcities.jpg", "text.jpg"];
imgsNum = 5;
imgSize = 256;
levels = log2(imgSize);
pairs = [1 2; 3 4; 5 1];
result1 = cell(size(pairs, 1), levels);
result2 = cell(size(pairs, 1), levels);
masks = cell(size(pairs, 1));
filter = [[0.25, 0.25]; [0.25, 0.25]];

mask = zeros(imgSize);
for i = 1:imgSize
    for j = 1:imgSize
        if i > imgSize / 2
            mask(i,j) = 1;
        else
            mask(i,j) = 0;
        end
    end
end
masks{1} = mask;
for i = 1:imgSize
    for j = 1:imgSize
        if j > imgSize / 2
            mask(i,j) = 1;
        else
            mask(i,j) = 0;
        end
    end
end
masks{2} = mask;
for i = 1:imgSize
    for j = 1:imgSize
        if mod(j, 2) == 0
            mask(i,j) = 1;
        else
            mask(i,j) = 0;
        end
    end
end
masks{3} = mask;

for i = 1:size(pairs, 1)
    img1 = imread(char(allImgs(pairs(i, 1))));
    img1 = im2double(img1);
    
    img2 = imread(char(allImgs(pairs(i, 2))));
    img2 = im2double(img2);
    
    maskRaw = masks{i};
    maskRaw(maskRaw > 0) = 1;
    maskRaw(maskRaw <= 0) = 0;
    
    blend = zeros(imgSize);
    
    raw1 = img1;
    for j = 1:levels
        raw1 = (gp(raw1, filter));  
        result1{i, j} = raw1;   
    end
    for j = 1:levels - 1
        %result1{i, j} = (result1{i, j} - imresize(result1{i, j + 1}, size(result1{i, j}), 'bilinear') + 1) / 2;
        result1{i, j} = result1{i, j} - imresize(result1{i, j + 1}, size(result1{i, j}), 'bilinear');
        result1{i, j} = imresize(result1{i, j}, [imgSize imgSize], 'bilinear');
    end
    result1{i, levels} = imresize(result1{i, levels}, [imgSize imgSize], 'bilinear');
    
    raw2 = img2;
    for j = 1:levels
        raw2 = (gp(raw2, filter));  
        result2{i, j} = raw2;   
    end
    for j = 1:levels - 1
        %result2{i, j} = (result2{i, j} - imresize(result2{i, j + 1}, size(result2{i, j}), 'bilinear') + 1) / 2;
        result2{i, j} = result2{i, j} - imresize(result2{i, j + 1}, size(result2{i, j}), 'bilinear');
        result2{i, j} = imresize(result2{i, j}, [imgSize imgSize], 'bilinear');
    end
    result2{i, levels} = imresize(result2{i, levels}, [imgSize imgSize], 'bilinear');
    
    for j = 1:levels
        maskRaw = (gp(maskRaw, filter));  
        maskRawResize = imresize(maskRaw, [imgSize imgSize], 'bilinear');
        blend = blend + maskRawResize .* result1{i, j} + (1 - maskRawResize) .* result2{i, j};
    end
    
    %blend = blend / levels;
    blend = mat2gray(blend);
    
    subplot(size(pairs, 1),4,(i - 1) * 4 + 1), imshow(img1), title('Origin 1');
    subplot(size(pairs, 1),4,(i - 1) * 4 + 2), imshow(img2), title('Origin 2');
    subplot(size(pairs, 1),4,(i - 1) * 4 + 3), imshow(masks{i}), title('Mask');
    subplot(size(pairs, 1),4,(i - 1) * 4 + 4), imshow(blend), title('Final Result');
end