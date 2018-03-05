function [fundamentalMatrices1, fundamentalMatrices2, epipoles1, epipoles2, matchedSifts] = part3(matchedSifts)
    %%Matching data
    matchedPoints = {...
        [1390 1477 1659 2064 2027 2383 2338 2406 2535 1591 2002 2302; 842 1051 942 1215 1054 541 396 354 681 588 998 547; 1436 1496 1720 1931 2001 2179 2152 2260 2294 1571 1898 2119; 547 771 728 1048 902 370 216 187 545 320 814 371] ...
        [685 768 628 1080 1227 1893; 149 151 361 1503 1665 1615; 785 801 732 1139 1437 1997; 146 116 400 1518 1672 1458]
        };

    %%Compute fundamental matrix
    set1Filenames = loadFiles('set1\');
    set2Filenames = loadFiles('set2\');
    set1PairSize = length(set1Filenames) / 2;
    set2PairSize = length(set2Filenames) / 2;
    fundamentalMatrices1 = cell(set1PairSize, 1);
    fundamentalMatrices2 = cell(set2PairSize, 1);
    epipoles1 = cell(set1PairSize, 2);
    epipoles2 = cell(set2PairSize, 2);
    
    for i = 1:set1PairSize
        x1 = matchedSifts{1, i}(1, :);
        y1 = matchedSifts{1, i}(2, :);
        x2 = matchedSifts{1, i}(5, :);
        y2 = matchedSifts{1, i}(6, :);
        points1 = [x1 ; y1 ; ones(1, length(x1))];
        points2 = [x2 ; y2 ; ones(1, length(x2))];
        [normalizedPoints1, ~] = normalise2dpts(points1);
        [normalizedPoints2, ~] = normalise2dpts(points2);
        [fundamentalMatrices1{i, 1}, epipoles1{i, 1}, epipoles1{i, 2}] = fundmatrix(normalizedPoints1, normalizedPoints2);
        a = computeFundamentalMatrix(points1, points2);
    end
    
    for i = 1:set2PairSize
        x1 = matchedSifts{2, i}(1, :);
        y1 = matchedSifts{2, i}(2, :);
        x2 = matchedSifts{2, i}(5, :);
        y2 = matchedSifts{2, i}(6, :);
        points1 = [x1 ; y1 ; ones(1, length(x1))];
        points2 = [x2 ; y2 ; ones(1, length(x2))];
        [normalizedPoints1, ~] = normalise2dpts(points1);
        [normalizedPoints2, ~] = normalise2dpts(points2);
        [fundamentalMatrices2{i, 1}, epipoles2{i, 1}, epipoles2{i, 2}] = fundmatrix(normalizedPoints1, normalizedPoints2);
    end
    
    %% Compute epipolar lines
    for i = 1:set1PairSize
        img1 = imread(set1Filenames{1, i * 2 - 1});
        img2 = imread(set1Filenames{1, i * 2});
        x1 = matchedSifts{1, i}(1, :);
        y1 = matchedSifts{1, i}(2, :);
        x2 = matchedSifts{1, i}(5, :) + size(img1, 2);
        y2 = matchedSifts{1, i}(6, :);
        ks = zeros(1, length(x2));
        for j = 1:length(x2)
           ks(j) = (y2(j) - y1(j)) / (x2(j) - x1(j)); 
        end
        avgK = median(ks);
        points1 = [x1; y1; ones(1, length(x1))];
        points2 = [x2; y2; ones(1, length(x2))];
        [normalizedPoints1, ~] = normalise2dpts(points1);
        [normalizedPoints2, ~] = normalise2dpts(points2);
        epipolarLines = epipolarLine(fundamentalMatrices1{i, 1}, normalizedPoints1);
        temp = [];
        for j = 1:length(x2)
%             for k = 1:size(epipolarLines, 2)
%                 if abs(epipolarLines(:, k)' * normalizedPoints2(:, j)) < 0.0002
%                     temp = [temp matchedSifts{1, i}(:, j)];
%                 end
%             end
            k = (y2(j) - y1(j)) / (x2(j) - x1(j));
            minCoefficient = 0.7;
            maxCoefficient = 2 - minCoefficient;
            if k < 0 && maxCoefficient * avgK < k && k < minCoefficient * avgK
                temp = [temp matchedSifts{1, i}(:, j)];
            end
            if k > 0 && minCoefficient * avgK < k && k < maxCoefficient * avgK
                temp = [temp matchedSifts{1, i}(:, j)];
            end
        end
        matchedSifts{1, i} = temp;
        showMatches(img1, img2, matchedSifts{1, i});
        saveas(gcf, ['part3Results\' num2str(i) '.png']);
    end
    
    for i = 1:set2PairSize
        img1 = imread(set2Filenames{1, i * 2 - 1});
        img2 = imread(set2Filenames{1, i * 2});
        x1 = matchedSifts{2, i}(1, :);
        y1 = matchedSifts{2, i}(2, :);
        x2 = matchedSifts{2, i}(5, :) + size(img1, 2);
        y2 = matchedSifts{2, i}(6, :);
        ks = zeros(1, length(x2));
        for j = 1:length(x2)
           ks(j) = (y2(j) - y1(j)) / (x2(j) - x1(j)); 
        end
        avgK = median(ks);
        points1 = [x1; y1; ones(1, length(x1))];
        points2 = [x2; y2; ones(1, length(x2))];
        [normalizedPoints1, ~] = normalise2dpts(points1);
        [normalizedPoints2, ~] = normalise2dpts(points2);
        epipolarLines = epipolarLine(fundamentalMatrices2{i, 1}, normalizedPoints1);
        temp = [];
        for j = 1:length(x2)
%             for k = 1:size(epipolarLines, 2)
%                 if abs(epipolarLines(:, k)' * normalizedPoints2(:, j)) < 0.002
%                     temp = [temp matchedSifts{2, i}(:, j)];
%                 end
%             end
            k = (y2(j) - y1(j)) / (x2(j) - x1(j));
            minCoefficient = 0.7;
            maxCoefficient = 2 - minCoefficient;
            if k < 0 && maxCoefficient * avgK < k && k < minCoefficient * avgK
                temp = [temp matchedSifts{2, i}(:, j)];
            end
            if k > 0 && minCoefficient * avgK < k && k < maxCoefficient * avgK
                temp = [temp matchedSifts{2, i}(:, j)];
            end
        end
        matchedSifts{2, i} = temp;
        showMatches(img1, img2, matchedSifts{2, i});
        saveas(gcf, ['part3Results\' num2str(i + set1PairSize) '.png']);
    end
end

function [epipolarLines] = epipolarLine(fundamentalMatrix, points)
    epipolarLines = fundamentalMatrix * points;
end

function [ fund_matrix ] = computeFundamentalMatrix(mPointsA, mPointsB )
    aU = mPointsA(:,1);
    aV = mPointsA(:,2);
    bU = mPointsB(:,1);
    bV = mPointsB(:,2);

    A = zeros(length(aU),9);
    for x = 1:length(aU)
        [u,v] = deal(aU(x),aV(x));
        [up,vp] = deal(bU(x),bV(x));
        A(x,:) = [u*up, v*up, up, u*vp, v*vp, vp, u, v, 1];
    end

    % solve Af=0 using SVD
    [~,~,V] = svd(A);
    f = V(:,end);
    F = reshape(f,[3,3])'; 

    % enforce det(F)=0 using svd
    [U,S,V] = svd(F);
    S(3,3) = 0;
    fund_matrix = U*S*V';
end