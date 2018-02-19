function result = gp(A, B)
%     result = conv2(A, B, 'valid');
%     result = imresize(result, 0.5, 'bilinear');
%     result = result(1:2:size(A, 1),1:2:size(A, 2));

    sizeA = size(A);
    heightA = sizeA(1);
    widthA = sizeA(2);
    result = zeros(int8(sizeA) / 2);
    for row = 2:2:heightA
        for col = 2:2:widthA
            result(row / 2, col / 2) = A(row, col) * B(1, 1) + A(row - 1, col) * B(2, 1) + A(row, col - 1) * B(1, 2) + A(row - 1, col - 1) * B(2, 2);
        end
    end
end