function [] = showMatches(img1,img2,matchedSifts)
    img = cat(2, img1, img2);
    imshow(img);
    x1 = matchedSifts(1, :);
    y1 = matchedSifts(2, :);
    x2 = matchedSifts(5, :) + size(img1, 2);
    y2 = matchedSifts(6, :);
    h = line([x1 ; x2], [y1 ; y2]);
    set(h, 'linewidth', 0.1, 'color', 'r');
    vl_plotframe(matchedSifts(1:4, :));
    matchedSifts(5, :) = matchedSifts(5, :) + size(img1, 2) ;
    vl_plotframe(matchedSifts(5:8, :));
end