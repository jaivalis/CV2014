clear all
run('C:\Users\T\Downloads\vlfeat-0.9.14-bin\vlfeat-0.9.14\toolbox\vl_setup.m');
i1 = single(rgb2gray(imread('TeddyBear/obj02_001.png')));
[i_points1, d1] = vl_sift(i1);




%% plot transformation
figure;  imshow(i1/255);
hold on

plot(i_points1(1:end, 1), i_points1(1:end, 2), 'ro');
hold off

[clustCent,point2cluster,clustMembsCell] = MeanShiftCluster(i_points1(1:2,:),0.75);