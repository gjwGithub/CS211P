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
    
    lpo = [-1/8 -1/8 -1/8; -1/8 1 -1/8; -1/8 -1/8 -1/8];
    pixelVariances = cell(levels);
    
    for j = 1:levels
        raw = gp(raw, filter);
        rawResize = imresize(raw, [imgSize imgSize], 'bilinear');
        result{i, j} = rawResize;
        %1
        pixelVariances{j} = stdfilt(result{i, j}).^2;
        result{i, j} = imfilter(result{i, j}, lpo);
        %2
        result{i, j} = result{i, j} > 0;
        %3 & 4
        diffs = zeros(imgSize);
        for ii = 1:imgSize
            for jj = 1:imgSize
                diffCount = 0;
                if ii > 1 && result{i, j}(ii - 1, jj) ~= result{i, j}(ii, jj)
                    diffCount = diffCount + 1;
                end
                if ii < imgSize && result{i, j}(ii + 1, jj) ~= result{i, j}(ii, jj)
                    diffCount = diffCount + 1;
                end
                if jj > 1 && result{i, j}(ii, jj - 1) ~= result{i, j}(ii, jj)
                    diffCount = diffCount + 1;
                end
                if jj < imgSize && result{i, j}(ii, jj + 1) ~= result{i, j}(ii, jj)
                    diffCount = diffCount + 1;
                end
                
                if ii > 1 && jj > 1 && result{i, j}(ii - 1, jj - 1) ~= result{i, j}(ii, jj)
                    diffCount = diffCount + 1;
                end
                if ii < imgSize && jj < imgSize && result{i, j}(ii + 1, jj + 1) ~= result{i, j}(ii, jj)
                    diffCount = diffCount + 1;
                end
                if ii < imgSize && jj > 1 && result{i, j}(ii + 1, jj - 1) ~= result{i, j}(ii, jj)
                    diffCount = diffCount + 1;
                end
                if ii > 1 && jj < imgSize && result{i, j}(ii - 1, jj + 1) ~= result{i, j}(ii, jj)
                    diffCount = diffCount + 1;
                end
                
                if diffCount > 0
                    diffs(ii, jj) = 1;
                end
            end
        end
        threshold = 0.0003;
        for ii = 1:imgSize
            for jj = 1:imgSize
                if diffs(ii, jj) == 1 && pixelVariances{j}(ii,jj) > threshold
                    result{i, j}(ii, jj) = 0;
                else
                    result{i, j}(ii, jj) = 1;
                end
            end
        end

        subplot(imgsNum,levels,(i - 1) * levels + j), imshow(result{i, j}), title(sprintf('Level %d', j));
    end
    
end