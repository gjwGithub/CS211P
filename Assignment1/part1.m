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
        rawResize = imresize(raw, [imgSize imgSize], 'bilinear');
        result{i, j} = rawResize;
        subplot(imgsNum,levels,(i - 1) * levels + j), imshow(result{i, j}), title(sprintf('Level %d', j));
    end
end