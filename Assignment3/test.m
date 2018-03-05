matched = [1390 1477 1659 2064 2027 2383 2338 2406 2535 1591 2002 2302; 842 1051 942 1215 1054 541 396 354 681 588 998 547; 1436 1496 1720 1931 2001 2179 2152 2260 2294 1571 1898 2119; 547 771 728 1048 902 370 216 187 545 320 814 371];
x1 = matched(1, :);
y1 = matched(2, :);
x2 = matched(3, :) + 2848;
y2 = matched(4, :);

d = zeros(1, length(y2));
for i = 1:length(y2)
   d(i) = (y2(i) - y1(i)) / (x2(i) - x1(i));
end
mean(d)
(y2 - y1) / (x2 - x1)

points1 = [x1 ; y1 ; ones(1, length(x1))];
points2 = [x2 ; y2 ; ones(1, length(x2))];
[normalizedPoints1, ~] = normalise2dpts(points1);
[normalizedPoints2, ~] = normalise2dpts(points2);
%[f, e1, e2] = fundmatrix(normalizedPoints1, normalizedPoints2);
f = computeFundamentalMatrix(normalizedPoints1, normalizedPoints2);
[-1.78233226842411;-0.0780248460855191;1]'* f * [-1.94637343237245;0.232453192150166;1]


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
