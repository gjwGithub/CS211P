function [x, y, z] = find_3Dpoints(cali_matrix1, cali_matrix2, twoDset1, twoDset2)
syms X Y Z;
P = [X Y Z 1].';
c1_r1 = cali_matrix1(1,:);
c1_r2 = cali_matrix1(2,:);
c1_r3 = cali_matrix1(3,:);

c2_r1 = cali_matrix2(1,:);
c2_r2 = cali_matrix2(2,:);
c2_r3 = cali_matrix2(3,:);

eqn1 = twoDset1(1)*(c1_r3*P) == c1_r1*P; 
eqn2 = twoDset1(2)*(c1_r3*P) == c1_r2*P; 
%eqn3 = twoDset2(1)*(c2_r3*P) == c2_r1*P; 
eqn3 = twoDset2(2)*(c2_r3*P) == c2_r2*P; 

[A1,B1] = equationsToMatrix([eqn1, eqn2, eqn3],[X,Y,Z]);
M1 = linsolve(A1,B1);
%{
[A2,B2] = equationsToMatrix([eqn1, eqn2, eqn4],[X,Y,Z]);
M2 = linsolve(A2,B2);
[A3,B3] = equationsToMatrix([eqn4, eqn2, eqn3],[X,Y,Z]);
M3 = linsolve(A3,B3);
[A4,B4] = equationsToMatrix([eqn1, eqn4, eqn3],[X,Y,Z]);
M4 = linsolve(A4,B4);
%}
x = eval(M1(1));
y = eval(M1(2));
z = eval(M1(3));


end