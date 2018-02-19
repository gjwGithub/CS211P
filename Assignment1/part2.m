allImgs = ["CARTOON.jpg", "flowergray.jpg", "kitty.jpg", "polarcities.jpg", "text.jpg"];
imgsNum = 5;
imgSize = 256;
levels = log2(imgSize);
result = cell(imgsNum, levels);

for i = 1:imgsNum
    img = imread(char(allImgs(i)));
    img = im2double(img);
    filter = [[0.25, 0.25]; [0.25, 0.25]];
    raw = img;
    for j = 1:levels
        raw = gp(raw, filter);  
        result{i, j} = raw;   
%         
%         raw = interp2(raw);
%         raw = imresize(raw, 256 / 255);
%         delta = raw - prev;
%         result{i, j} = delta;
%         subplot(imgsNum,levels,(i - 1) * levels + j), imshow(result{i, j});
%         prev = raw;
    end
    for j = 1:levels - 1
        %result{i, j} = (result{i, j} - imresize(result{i, j + 1}, size(result{i, j}), 'bilinear') + 1) / 2;
        result{i, j} = result{i, j} - imresize(result{i, j + 1}, size(result{i, j}), 'bilinear');
        result{i, j} = mat2gray(result{i, j});
        result{i, j} = imresize(result{i, j}, [imgSize imgSize], 'bilinear');
        subplot(imgsNum,levels,(i - 1) * levels + j), imshow(result{i, j}), title(sprintf('Level %d', j));
    end
    subplot(imgsNum,levels,i * levels), imshow(result{i, levels}), title(sprintf('Level %d', levels));
    
end