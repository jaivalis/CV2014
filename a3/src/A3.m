addpath('../a1')
spyros = readPcd('/data/model.pcd');
plot3(spyros(1:200:end,1), spyros(1:200:end, 2), spyros(1:200:end, 3));