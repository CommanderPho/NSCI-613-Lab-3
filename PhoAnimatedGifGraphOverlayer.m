% Pho Animated Gif Graph Overlayer
% Pho Hale 09-11-2020

clear all;
% importGifPath = '/Users/pho/Desktop/Screencaps/Movies/4a-001.gif';

importGifPaths = {'/Users/pho/Desktop/Screencaps/Movies/4b-5.gif'
'/Users/pho/Desktop/Screencaps/Movies/4b-997.gif'
'/Users/pho/Desktop/Screencaps/Movies/4c-1.gif'
'/Users/pho/Desktop/Screencaps/Movies/4c-993.gif'
'/Users/pho/Desktop/Screencaps/Movies/4c-2000.gif'
'/Users/pho/Desktop/Screencaps/Movies/4d-0001.gif'
'/Users/pho/Desktop/Screencaps/Movies/4d-002.gif'};
% importGifPath = '/Users/pho/Desktop/Screencaps/Movies/4a-MinProp.gif';

num_paths = length(importGifPaths);
for i=1:num_paths
	importGifPath = importGifPaths{i};
	fprintf('Flattening Path[%d/%d]...\n',i,num_paths);
	[outputName, finalOutputPic] = flattenGifGraph(importGifPath);
	fprintf('\t Finished with %s\n', outputName);
end
disp('done.')