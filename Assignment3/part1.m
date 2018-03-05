function [result] = part1()
    set1Filenames = loadFiles('set1\');
    set2Filenames = loadFiles('set2\');
    maskSet1Filenames = loadFiles('maskSet1\');
    maskSet2Filenames = loadFiles('maskSet2\');
    result = cell(2, length(set1Filenames) / 2);

    for i = 1:2:length(set1Filenames)
        img1 = imread(set1Filenames{1, i});
        img2 = imread(set1Filenames{1, i + 1});
        maskImg1 = imread(maskSet1Filenames{1, i});
        maskImg2 = imread(maskSet1Filenames{1, i + 1});
        matchedSifts = matchSifts(img1, img2, maskImg1, maskImg2);
        result{1, (i + 1) / 2} = matchedSifts;
        showMatches(img1, img2, matchedSifts);
        saveas(gcf, ['part1Results\' num2str((i + 1) / 2) '.png']);
    end

    for i = 1:2:length(set2Filenames)
        img1 = imread(set2Filenames{1, i});
        img2 = imread(set2Filenames{1, i + 1});
        maskImg1 = imread(maskSet2Filenames{1, i});
        maskImg2 = imread(maskSet2Filenames{1, i + 1});
        matchedSifts = matchSifts(img1, img2, maskImg1, maskImg2);
        result{2, (i + 1) / 2} = matchedSifts;
        showMatches(img1, img2, matchedSifts);
        saveas(gcf, ['part1Results\' num2str((i + 1 + length(set1Filenames)) / 2) '.png']);
    end
end