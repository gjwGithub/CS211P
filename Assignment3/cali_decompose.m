function [in_matrix, rot_matrix, trans_matrix] = cali_decompose(cali_matrix)
M = cali_matrix(1:3,1:3);
c4 = cali_matrix(:,4);
[in_matrix, rot_matrix] = rq(M);
trans_matrix = M\c4;
end