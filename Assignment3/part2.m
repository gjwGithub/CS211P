%Following code are used to generate the Calibration matries for images
%Following are the hand-picked points

%(DSCF4177 DSCF4178) (DSCF4186 DSCF4187)

set1_3D_points = {[64 64 29;32 80 67;48 48 48;32 48 48;180 180 0.01;160 120 0.01],...
                  [64, 0.01, 0.01;180, 180, 0.01;32, 80, 48;64, 64, 29;48, 16, 29;32, 80, 29],...
                  [0.01 80 29;32 80 67;32 48 48;160 120 0.01;0.01 64 19;180 40 0.01],...
                  [32 80 67;0.01 80 48;48 48 48;0.01 80 29;180 40 0;160 60 0]};

set1_2D_points = {[1034 1149;814 682;790 1062;666 1000;2427 986;2124 1266],...
                  [514, 1162;2431, 947;870, 258;946, 718;514, 822;910, 542],...
                  [2723 85;2411 482;2299 618;966 1478;2647 918;858 1142],...
                  [2082 267;2319 402;1755 414;2299 590;486 1118;760 1162]};
                 
%(DSCF4181 DSCF4182) (DSCF4188 DSCF4189) 
set2_3D_points = {[16 16 48;32 48 67;0.01 80 29;0.01 48 48;180 180 0.01;20 180 0.01],...
                  [16 16 48;32 80 67;0.01 64 0.01;0.01 80 29;180 180 0.01;20 180 0.01],...
                  [32 80 67;0.01 80 29;32 80 29;63 0.01 29;180 20 0.01;160 60 0.01],...
                  [32 80 67;64 0.01 29;0.01 80 67;180 20 0.01;20 180 0.01;140 60 0.01]};

set2_2D_points = {[1843 1434;1539 1078;1103 1546;1407 1470;2219 934;433 1401],...
                  [2494 1306;1675 1006;1891 1902;1965 1642;2042 788;490 1750],...
                  [1904 274;2031 534;1895 458;1135 578;400 1370;886 1442],...
                  [1711 320;1026 653;1867 278;250 1292;2669 1074;867 1256]};

set1_cali_matrix = {4};
set2_cali_matrix = {4};

for i = 1:4
    set1_cali_matrix{i} = find_cali_matrix(cell2mat(set1_3D_points(i)), cell2mat(set1_2D_points(i)));
    set2_cali_matrix{i} = find_cali_matrix(cell2mat(set2_3D_points(i)), cell2mat(set2_2D_points(i)));
end
