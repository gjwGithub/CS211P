function cali_matrix = find_cali_matrix(threeD_points, twoD_points)
%{
syms r1x r1y r1z r2x r2y r2z r3x r3y r3z r1w r2w;
r1 = [r1x r1y r1z];
r2 = [r2x r2y r2z];
r3 = [r3x r3y r3z];

%Equations:
eqn1 = twoD_points(1,1)*(r3*treeD_points(1,:).' + 1) == r1*treeD_points(1,:).' + r1w;
eqn2 = twoD_points(1,2)*(r3*treeD_points(1,:).' + 1) == r2*treeD_points(1,:).' + r2w;

eqn3 = twoD_points(2,1)*(r3*treeD_points(2,:).' + 1) == r1*treeD_points(2,:).' + r1w;
eqn4 = twoD_points(2,2)*(r3*treeD_points(2,:).' + 1) == r2*treeD_points(2,:).' + r2w;

eqn5 = twoD_points(3,1)*(r3*treeD_points(3,:).' + 1) == r1*treeD_points(3,:).' + r1w;
eqn6 = twoD_points(3,2)*(r3*treeD_points(3,:).' + 1) == r2*treeD_points(3,:).' + r2w;

eqn7 = twoD_points(4,1)*(r3*treeD_points(4,:).' + 1) == r1*treeD_points(4,:).' + r1w;
eqn8 = twoD_points(4,2)*(r3*treeD_points(4,:).' + 1) == r2*treeD_points(4,:).' + r2w;

eqn9 = twoD_points(5,1)*(r3*treeD_points(5,:).' + 1) == r1*treeD_points(5,:).' + r1w;
eqn10 = twoD_points(5,2)*(r3*treeD_points(5,:).' + 1) == r2*treeD_points(5,:).' + r2w;

eqn11 = twoD_points(6,1)*(r3*treeD_points(6,:).' + 1) == r1*treeD_points(6,:).' + r1w;
%eqn12 = twoD_points(6,2)*(r3*treeD_points(6,:).' + 1) == r2*treeD_points(6,:).' + r2w;

[A,B] = equationsToMatrix([eqn1, eqn2, eqn3, eqn4, eqn5, eqn6, eqn7, eqn8, eqn9, eqn10, eqn11], ...
    [r1x, r1y, r1z, r1w, r2x, r2y, r2z, r2w, r3x, r3y, r3z]);
X = linsolve(A,B);
cali_matrix = eval([X(1) X(2) X(3) X(4); X(5) X(6) X(7) X(8); X(9) X(10) X(11) 1]);
%}

D3matrix = [threeD_points.';ones([1,6])];
D2matrix = [twoD_points.';ones([1,6])];
cali_matrix = D2matrix/D3matrix;
end