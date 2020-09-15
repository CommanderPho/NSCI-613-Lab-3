% Pho Animated Gif Graph Overlayer
% Pho Hale 09-11-2020

clear all;
% importGifPath = '/Users/pho/Desktop/Screencaps/Movies/4a-001.gif';

importGifPaths = {'/Users/pho/Desktop/Screencaps/Movies/4b-5.gif'};

% importGifPaths = {'/Users/pho/Desktop/Screencaps/Movies/4b-5.gif'
% '/Users/pho/Desktop/Screencaps/Movies/4b-997.gif'
% '/Users/pho/Desktop/Screencaps/Movies/4c-1.gif'
% '/Users/pho/Desktop/Screencaps/Movies/4c-993.gif'
% '/Users/pho/Desktop/Screencaps/Movies/4c-2000.gif'
% '/Users/pho/Desktop/Screencaps/Movies/4d-0001.gif'
% '/Users/pho/Desktop/Screencaps/Movies/4d-002.gif'};
% importGifPath = '/Users/pho/Desktop/Screencaps/Movies/4a-MinProp.gif';


should_output_plot_parts = true;
should_show_figure = false;
should_save_to_disk = false;

num_paths = length(importGifPaths);
for i=1:num_paths
	importGifPath = importGifPaths{i};
	fprintf('Flattening Path[%d/%d]...\n',i,num_paths);
	[outputName, finalOutputPic, axesOnlyImage, plotOutputParts] = flattenGifGraph(importGifPath, should_output_plot_parts, should_show_figure, should_save_to_disk);
	fprintf('\t Finished with %s\n', outputName);
end
disp('done.')


% Add Plots:
combinedFrame = axesOnlyImage;

% + weighted_image;
for i=1:num_paths
	if i == 1
		plotsCombined = plotOutputParts{i}.weighted_image;
	else
		plotsCombined = plotsCombined + plotOutputParts{i}.weighted_image;
	end
end

% plotsCombined = sum(plotOutputParts{:}.weighted_image);

%imshow(plotOutputParts{2}.weighted_image)
figure(1)
imshow(combinedFrame)
hold on;
imshow(plotsCombined)