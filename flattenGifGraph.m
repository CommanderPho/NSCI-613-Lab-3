function [outputName, finalOutputPic] = flattenGifGraph(importGifPath)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
	[parentPath, baseName, ext] = fileparts(importGifPath);

	outputDir = '/Users/pho/Desktop/Screencaps/Movies/Flattened';
	outputName = fullfile(outputDir, [baseName '.png']);

	% Import the file
	[activeGif.cdata] = gifread(importGifPath);

	% Get the number of frames in the animated gif
	numberOfFrames = size(activeGif.cdata,4);

	if numberOfFrames < 1
		error('no frames!')
	end

	%% Get the Axes from the first frame:
	currFrame = activeGif.cdata(:,:,:,1);
	currInvertedFrame = imcomplement(currFrame);	
	[~, axesOnlyImage, ~] = removeWhiteAxes(currInvertedFrame);

	% When done, take the combinedFrame to be the blue channel of the data:
	finalOutputPic = axesOnlyImage; % Start with axes image:

	use_color_version = true;

	color_map = jet(numberOfFrames);
	per_frame_opacity = 255/numberOfFrames;

	for i=1:numberOfFrames
		currFrame = activeGif.cdata(:,:,:,i);
		currInvertedFrame = imcomplement(currFrame);

		% Binarize the image:
		[fixedImage, ~, ~] = removeWhiteAxes(currInvertedFrame);
		fixedImage_grey = rgb2gray(fixedImage);
		fixedImage_BW = imbinarize(fixedImage_grey);

		if use_color_version
	% 		curr_color = color_map(i,:);
			curr_inv_color = color_map(i,:);
			curr_color = ([1 1 1]- curr_inv_color);

			curr_flat_image = uint8(fixedImage_BW)*255*0.6;

			weighted_image(:,:,1) = curr_flat_image .* curr_color(1); % Multiply by red component of current color
			weighted_image(:,:,2) = curr_flat_image .* curr_color(2); % Multiply by green component of current color
			weighted_image(:,:,3) = curr_flat_image .* curr_color(3); % Multiply by blue component of current color

		else
			weighted_image = uint8(fixedImage_BW .* (i * per_frame_opacity));
		end	

		if i == 1
			if use_color_version
				combinedFrame = weighted_image;
			else
				combinedFrame = uint8(weighted_image);
			end	

		else
			% Should work for both versions
			combinedFrame = combinedFrame + weighted_image;
		end
	end


	if use_color_version
		finalOutputPic = finalOutputPic + combinedFrame;
	else
		finalOutputPic(:,:,2) = finalOutputPic(:,:,2) + combinedFrame; %Add plots to the red channel
		finalOutputPic(:,:,3) = finalOutputPic(:,:,3) + combinedFrame; %Add plots to the red channel
	end

	% Invert to get back to original pic:
	finalOutputPic = imcomplement(finalOutputPic);	

	figure(2)
	clf
	imshow(finalOutputPic)

	% write out the image to the destination directory:
	imwrite(finalOutputPic, outputName);

end


function [dataOnlyImage, axesOnlyImage, excludedPixelsMask] = removeWhiteAxes(originalImage)
	% excludedPixelsMask: includes everywhere except for the plotted lines
	height = size(originalImage,1);
	width = size(originalImage,2);
	color_depth = size(originalImage,3);
	
	tolerance = 5;
	
% 	axesPixelsMask = logical(zeros([height, width]));
	excludedPixelsMask = logical(zeros([height, width]));
	dataOnlyImage = originalImage; % Initially copy the originalImage to the fixedImage
	axesOnlyImage = originalImage; % Initially copy the originalImage to the fixedImage
	
	
	for i = 1:height
		for j = 1:width
			% Loop through all pixels of the image:
			
			% Test if the pixel is white/grey/black:
			%% TODO: could also use the HSV curve's saturation value right?
			curr_RGB_pixel = originalImage(i,j,:);
			% They're white/gray/black if all color components are approximately
			% equal.
			curr_RGB_pixel_diff = curr_RGB_pixel - curr_RGB_pixel(1); % Subtract the first component away from all three, see if they're outside that range.
			curr_is_outside_tolerance = false;
			
			if abs(curr_RGB_pixel_diff(2)) < tolerance
				curr_is_outside_tolerance = true;
			elseif abs(curr_RGB_pixel_diff(3)) < tolerance
				curr_is_outside_tolerance = true;
			else
				curr_is_outside_tolerance = false;
			end
			
			if curr_is_outside_tolerance
				excludedPixelsMask(i,j) = true; % Set the mask to indicate that this is an excluded value.
				dataOnlyImage(i,j,:) = [0, 0, 0]; % Set it to pure black.
			else
				%For white/grey/black pixels, enable them.
				axesOnlyImage(i,j,:) = [0, 0, 0]; % Set it to pure black for all channels
			end
		end
	end
end
