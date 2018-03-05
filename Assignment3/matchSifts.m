function [matchedSifts] = matchSifts(img1,img2,maskImg1,maskImg2)
    img1 = rgb2gray(img1);
    img1 = im2single(img1);
    [sift1, descriptor1] = vl_sift(img1);
    
    img2 = rgb2gray(img2);
    img2 = im2single(img2);
    [sift2, descriptor2] = vl_sift(img2);
    
    [matches, scores] = vl_ubcmatch(descriptor1, descriptor2);
    matches_scores = [matches; scores];
    sorted_matches_scores = sortrows(matches_scores', 3)';
    
    threshold = 2000;
    sorted_matches_scores(:, sorted_matches_scores(3, :) < threshold) = [];
    matchedSifts = zeros(size(sift1, 1) * 2, size(sorted_matches_scores, 2));
    for j = 1:length(sorted_matches_scores)
        matchedSifts(:, j) = [sift1(:, sorted_matches_scores(1, j)); sift2(:, sorted_matches_scores(2, j))];
    end
    
    maskImg1 = rgb2gray(maskImg1);
    maskImg2 = rgb2gray(maskImg2);
    temp = [];
    for j = 1:length(matchedSifts)
        if maskImg1(round(matchedSifts(2, j)), round(matchedSifts(1, j))) == 255 && maskImg2(round(matchedSifts(6, j)), round(matchedSifts(5, j))) == 255
            temp = [temp matchedSifts(:, j)];
        end
    end
    matchedSifts = temp;
end

