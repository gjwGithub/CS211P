%Making plot
close all
clc

load('set1_cali_matrix.mat');
load('set2_cali_matrix.mat');
mtr1 = cell2mat(set1_cali_matrix(1));
mtr2 = cell2mat(set1_cali_matrix(2));
mtr3 = cell2mat(set2_cali_matrix(3));
mtr4 = cell2mat(set2_cali_matrix(4));

[in_1, r_1, t_1] = cali_decompose(mtr1);
[in_2, r_2, t_2] = cali_decompose(mtr2);
[in_3, r_3, t_3] = cali_decompose(mtr3);
[in_4, r_4, t_4] = cali_decompose(mtr4);

a = linspace(0,10,10);
cor_gol = zeros([30,3]);
cor_gol(1:10,1) = a;
cor_gol(11:20,2) = a;
cor_gol(21:30,3) = a;

cor_set1_c1 = zeros(30,3);
cor_set1_c2 = zeros(30,3);
cor_set2_c1 = zeros(30,3);
cor_set2_c2 = zeros(30,3);

cor_temp = cor_gol * r_1;

cor_set1_c1(:,1) = cor_temp(:,1)+150;
cor_set1_c1(:,2) = cor_temp(:,2)-50;
cor_set1_c1(:,3) = cor_temp(:,3)+100;

cor_temp = cor_gol * r_2;

cor_set1_c2(:,1) = cor_temp(:,1)+200;
cor_set1_c2(:,2) = cor_temp(:,2)-50;
cor_set1_c2(:,3) = cor_temp(:,3)+150;

cor_temp = cor_gol * r_3;

cor_set2_c1(:,1) = cor_temp(:,1)+260;
cor_set2_c1(:,2) = cor_temp(:,2)+260;
cor_set2_c1(:,3) = cor_temp(:,3)+90;


cor_temp = cor_gol * (-r_4);

cor_set2_c2(:,1) = cor_temp(:,1)+260;
cor_set2_c2(:,2) = cor_temp(:,2)+260;
cor_set2_c2(:,3) = cor_temp(:,3)+120;

figure
scatter3(X1(:)+50,Y1(:)+15,Z1(:).*1.8,'filled')
hold on
plot3(cor_set1_c1(:,1), cor_set1_c1(:,2), cor_set1_c1(:,3),'g','linewidth',4)
hold on
plot3(cor_set1_c2(:,1), cor_set1_c2(:,2), cor_set1_c2(:,3), 'r','linewidth',4)
hold on
scatter3(X2(:),Y2(:),(Z2(:)-50),'filled')
hold on
plot3(cor_set2_c1(:,1), cor_set2_c1(:,2), cor_set2_c1(:,3),'g','linewidth',4)
hold on
plot3(cor_set2_c2(:,1), cor_set2_c2(:,2), cor_set2_c2(:,3), 'r','linewidth',4)
title("reconstrcted image from both sets")