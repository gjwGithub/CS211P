clear all 
close all

load('set1_cali_matrix.mat');
load('set2_cali_matrix.mat');
load('points.mat');

set1_data_points = cell2mat(matchedSifts(1));
set2_data_points = cell2mat(matchedSifts(4));

mtr1 = cell2mat(set1_cali_matrix(1));
mtr2 = cell2mat(set1_cali_matrix(2));
mtr3 = cell2mat(set2_cali_matrix(3));
mtr4 = cell2mat(set2_cali_matrix(4));

[m1,n1] = size(set1_data_points);
[m2,n2] = size(set2_data_points);

X1 = zeros(1,n1);
Y1 = zeros(1,n1);
Z1 = zeros(1,n1);
for i = 1:n1
    [X1(i),Y1(i),Z1(i)] = find_3Dpoints(mtr1, mtr2, [set1_data_points(1,i),...
                                                  set1_data_points(2,i)],...
                                                  [set1_data_points(5,i),...
                                                   set1_data_points(6,i)]);
                                                 
end
%[x,y,z] = find_3Dpoints(mtr1, mtr2,[2427 986],[2431, 947])
X2 = zeros(1,n2);
Y2 = zeros(1,n2);
Z2 = zeros(1,n2);
for i = 1:n2
    [X2(i),Y2(i),Z2(i)] = find_3Dpoints(mtr3, mtr4, [set2_data_points(1,i),...
                                                  set2_data_points(2,i)],...
                                                  [set2_data_points(5,i),...
                                                   set2_data_points(6,i)]);
end
figure
scatter3(X1(:),Y1(:),Z1(:),'filled')
figure
scatter3(X2(:),Y2(:),Z2(:),'filled')
