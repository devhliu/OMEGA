%% Visualization for the PET reconstructions
% Each section has a visualization code for a different purpose
% Only a specific section should be run at a time

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2019  Ville-Veikko Wettenhovi
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <https://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load the saved reconstruction and machine specific variables
image_properties = pz{end,1};

%% Visualize several reconstructions for one time step for all slices, last iterations

algo_char = algorithms_char();

% 1 = MLEM, 2 = OSEM, 3 = MRAMLA, 4 = RAMLA, 5 = ROSEM, 6 = COSEM, 7 = ECOSEM, 8 =
% ACOSEM, 9 = DRAMA, 8 = MRP-OSL, 9 = MRP-BSREM, 10 = Quadratic prior OSL, 11 =
% Quadratic prior BSREM 12 = L-filter OSL, 13 = L-filter BSREM, 14 = FMH
% OSL, 15 = FMH BSREM, 16 = Weighted mean OSL, 17 = Weighted mean BSREM
% 18 = Total variation OSL, 19 = Total variation BSREM, 20 = Anisotropic
% diffusion OSL, 21 = Anisotropic diffusion BSREM, 22 = Asymmetric Parallel
% Level Sets OSL, 23 = Asymmetric Parallel Level Sets BSREM
algorithms = [2];
% Use this value to scale the color scale in the image (higher values make
% low count areas brighter)
color_scale = 1;
% From which reconstruction should the color scale be taken
% NOTE: The numbering is according to the length of the above algorithms
% vector, e.g. if you have algorithms = [2, 4, 5] and color_from_algo = 2
% then the scale will be taken from RAMLA reconstruction (second element of
% algorithms) 
color_from_algo = 1;
% Visualization plane
% Choose the plane where the visualization takes place
% 1 = Transverse, 2 = Coronal/frontal, 3 = Sagittal
v_plane = 1;




img = pz{algorithms(color_from_algo)};
if isempty(img)
    warning('The current selected algorithm does not contain any estimes!')
    fprintf('The following are contained in the input array:\n')
    char_ar = algo_char(~cellfun(@isempty,pz(1:end-1)));
    loc = find(~cellfun(@isempty,pz(1:end-1)));
    for kk = 1 : nnz(~cellfun(@isempty,pz(1:end-1)))
        fprintf('Element %d: %s\n', loc(kk), char_ar(kk))
    end
    return
end

if length(algorithms) > 2
    hh = 2;
else
    hh = 1;
end
if length(algorithms) > 1
    jj = max(2, round(length(algorithms) / 2));
else
    jj = 1;
end
set(0,'units','pixels')
gg = get(0,'ScreenSize');
if jj > 4
    im_size = gg(4)/(2.5 + (jj - 4)/2);
else
    im_size = gg(4)/2.5;
end
figure
set(gcf, 'Position', [gg(3)/2-im_size/2*jj, gg(4)/2-im_size/2*hh, im_size * jj, im_size * hh]);

clim = [0 max(max(max(max(img(:,:,:,end)))))/color_scale];
if v_plane == 2
    koko = size(img,1);
elseif v_plane == 3
    koko = size(img,2);
else
    koko = size(img,3);
end
for kk = 1 : koko
    for ll = 1 : length(algorithms)
        
        img = pz{algorithms(ll)};
        if v_plane == 2
            img = rot90(permute(img, [3 2 1 4]),2);
        elseif v_plane == 3
            img = permute(img, [1 3 2 4]);
        end
        subplot(hh, jj, ll)
        imagesc(img(:,:,kk,end),clim)
        axis image
        title([char(algo_char(algorithms(ll))) ' slice = ' num2str(kk)])
    end
    pause(0.25)
    drawnow
end


%% Visualize N iterations of a single reconstruction for one time step for all slices

algo_char = algorithms_char();

% 1 = MLEM, 2 = OSEM, 3 = MRAMLA, 4 = RAMLA, 5 = COSEM, 6 = ECOSEM, 7 =
% ACOSEM, 8 = MRP-OSL, 9 = MRP-BSREM, 10 = Quadratic prior OSL, 11 =
% Quadratic prior BSREM 12 = L-filter OSL, 13 = L-filter BSREM, 14 = FMH
% OSL, 15 = FMH BSREM, 16 = Weighted mean OSL, 17 = Weighted mean BSREM
% 18 = Total variation OSL, 18 = Total variation BSREM, 20 = Anisotropic
% diffusion OSL, 21 = Anisotropic diffusion BSREM, 22 = Asymmetric Parallel
% Level Sets OSL, 23 = Asymmetric Parallel Level Sets BSREM
algorithm = 2;
% Use this value to scale the color scale in the image (higher values make
% low count areas brighter)
color_scale = 1;
% Visualization plane
% Choose the plane where the visualization takes place
% 1 = Transverse, 2 = Coronal/frontal, 3 = Sagittal
v_plane = 1;

% How many iterations in the image 
% Initial values can be included as iterations as they are saved as such
N_iter = 2;

img = pz{algorithm};
if isempty(img)
    warning('The current selected algorithm does not contain any estimes!')
    fprintf('The following are contained in the input array:\n')
    char_ar = algo_char(~cellfun(@isempty,pz(1:end-1)));
    loc = find(~cellfun(@isempty,pz(1:end-1)));
    for kk = 1 : nnz(~cellfun(@isempty,pz(1:end-1)))
        fprintf('Element %d: %s\n', loc(kk), char_ar(kk))
    end
    return
end

% clim = [0 max(max(max(max(img(:,:,:,end)))))/color_scale];

if N_iter > 2
    hh = 2;
else
    hh = 1;
end
if N_iter > 1
    jj = max(2, round(N_iter / 2));
else
    jj = 1;
end
set(0,'units','pixels')
gg = get(0,'ScreenSize');
if jj > 4
    im_size = gg(4)/(2.5 + (jj - 4)/2);
else
    im_size = gg(4)/2.5;
end
figure
set(gcf, 'Position', [gg(3)/2-im_size/2*jj, gg(4)/2-im_size/2*hh, im_size * jj, im_size * hh]);
if v_plane == 2
    koko = size(img,1);
    img = rot90(permute(img, [3 2 1 4]),2);
elseif v_plane == 3
    koko = size(img,2);
    img = permute(img, [1 3 2 4]);
else
    koko = size(img,3);
end
for kk = 1 : koko
    for ll = 1 : N_iter
        clim = [0 max(max(max(max(img(:,:,:,end - ll + 1)))))/color_scale];
        subplot(hh, jj, ll)
        imagesc(img(:,:,kk,end - ll + 1),clim)
        axis image
        title([char(algo_char(algorithm)) ', iteration = ' num2str(size(img,4) - ll) ', slice = ' num2str(kk)])
    end
    pause(0.25)
    drawnow
end

%% Compare several reconstructions for one time step for all slices, last iteration, with the source image obtained from GATE data
% NOTE: This is valid only for GATE data

algo_char = algorithms_char();

% This can be used to compare the achieved reconstruction with the
% coordinates from which the actual radioactive decay happened
% I.e. these allow for the error checking of the reconstructed data

% 1 = MLEM, 2 = OSEM, 3 = MRAMLA, 4 = RAMLA, 5 = COSEM, 6 = ECOSEM, 7 =
% ACOSEM, 8 = MRP-OSL, 9 = MRP-BSREM, 10 = Quadratic prior OSL, 11 =
% Quadratic prior BSREM 12 = L-filter OSL, 13 = L-filter BSREM, 14 = FMH
% OSL, 15 = FMH BSREM, 16 = Weighted mean OSL, 17 = Weighted mean BSREM
% 18 = Total variation OSL, 18 = Total variation BSREM, 20 = Anisotropic
% diffusion OSL, 21 = Anisotropic diffusion BSREM, 22 = Asymmetric Parallel
% Level Sets OSL, 23 = Asymmetric Parallel Level Sets BSREM
algorithms = [2];
% Use this value to scale the color scale in the image (higher values make
% low count areas brighter)
color_scale = 1;
% From according to which reconstruction should the color scale be taken
% NOTE: The numbering is according to the length of algorithms vector, e.g.
% if you have algorithms = [2, 4, 5] and color_from_algo = 2 then the scale
% will be taken from RAMLA reconstruction (second element of algorithms)
color_from_algo = 1;
% How is the source image formed?
% 1 = Form the source image by using only singles (coincidences) that
% originate from the very same location (source coordinates are the same)
% 2 = Form the source image by using only the first single
% 3 = Form the source image by using only the second single
% 4 = Form the source image by using both singles and then dividing the
% counts by two
% 5 = Form the source image by using the average coordinates from both
% singles
% 6 = Form the source image by using the true coincidences (requires
% obtain_trues = true) (GATE only)
source_coordinates = 1;

% The source data was obtained from
% 1 = ASCII, 2 = LMF, 3 = ROOT
source = 1;

img = pz{algorithms(color_from_algo)};
if isempty(img)
    warning('The current selected algorithm does not contain any estimes!')
    fprintf('The following are contained in the input array:\n')
    char_ar = algo_char(~cellfun(@isempty,pz(1:end-1)));
    loc = find(~cellfun(@isempty,pz(1:end-1)));
    for kk = 1 : nnz(~cellfun(@isempty,pz(1:end-1)))
        fprintf('Element %d: %s\n', loc(kk), char_ar(kk))
    end
    return
end

if length(algorithms) + 1 > 2
    hh = 2;
else
    hh = 1;
end
jj = max(2, round((length(algorithms)+1) / 2));
set(0,'units','pixels')
gg = get(0,'ScreenSize');
if jj > 4
    im_size = gg(4)/(2.5 + (jj - 4)/2);
else
    im_size = gg(4)/2.5;
end
figure
set(gcf, 'Position', [gg(3)/2-im_size/2*jj, gg(4)/2-im_size/2*hh, im_size * jj, im_size * hh]);

if source == 1
    load([image_properties.machine_name '_Ideal_image_coordinates_' image_properties.name '_ASCII.mat'])
elseif source == 2
    load([image_properties.machine_name '_Ideal_image_coordinates_' image_properties.name '_LMF.mat'])
elseif source == 3
    load([image_properties.machine_name '_Ideal_image_coordinates_' image_properties.name '_ROOT.mat'])
end

if source_coordinates == 1
    FOV = C{1};
elseif source_coordinates == 2
    FOV = C{2};
elseif source_coordinates == 3
    FOV = C{3};
elseif source_coordinates == 4
    FOV = C{4};
elseif source_coordinates == 5
    FOV = C{5};
elseif source_coordinates == 6
    FOV = C{6};
end


clim = [0 max(max(max(max(img(:,:,:,end)))))/color_scale];
clim2 = [0 max(max(max(max(FOV(:,:,:)))))/color_scale];
if v_plane == 2
    koko = size(img,1);
    FOV = rot90(permute(FOV, [3 2 1]),2);
elseif v_plane == 3
    koko = size(img,2);
    FOV = permute(FOV, [1 3 2]);
else
    koko = size(img,3);
end
for kk = 1 : koko
    for ll = 1 : length(algorithms)
        img = pz{algorithms(ll)};
        if v_plane == 2
            img = rot90(permute(img, [3 2 1 4]),2);
        elseif v_plane == 3
            img = permute(img, [1 3 2 4]);
        end
        subplot(hh, jj, ll)
        imagesc(img(:,:,kk,end),clim)
        axis image
        title([char(algo_char(algorithms(ll))) ' slice = ' num2str(kk)])
    end
    subplot(hh, jj, ll + 1)
    imagesc(FOV(:,:,kk),clim2)
    axis image
    title(['Original decay image, slice = ' num2str(kk)])
    pause(0.25)
    drawnow
end

%% Examine the entire volume for one reconstruction
% NOTE: Use of this section requires vol3D v2
% Download: 
% https://se.mathworks.com/matlabcentral/fileexchange/22940-vol3d-v2

algo_char = algorithms_char();

% 1 = MLEM, 2 = OSEM, 3 = MRAMLA, 4 = RAMLA, 5 = COSEM, 6 = ECOSEM, 7 =
% ACOSEM, 8 = MRP-OSL, 9 = MRP-BSREM, 10 = Quadratic prior OSL, 11 =
% Quadratic prior BSREM 12 = L-filter OSL, 13 = L-filter BSREM, 14 = FMH
% OSL, 15 = FMH BSREM, 16 = Weighted mean OSL, 17 = Weighted mean BSREM
% 18 = Total variation OSL, 18 = Total variation BSREM, 20 = Anisotropic
% diffusion OSL, 21 = Anisotropic diffusion BSREM, 22 = Asymmetric Parallel
% Level Sets OSL, 23 = Asymmetric Parallel Level Sets BSREM
algorithm = 1;
% The scale value for the pixel alpha values. Higher values will make the
% pixels more transparent, allowing areas of higher activity to be seen
% through background noise
alpha_scale = 5;

img = pz{algorithm};
if isempty(img)
    warning('The current selected algorithm does not contain any estimes!')
    fprintf('The following are contained in the input array:\n')
    char_ar = algo_char(~cellfun(@isempty,pz(1:end-1)));
    loc = find(~cellfun(@isempty,pz(1:end-1)));
    for kk = 1 : nnz(~cellfun(@isempty,pz(1:end-1)))
        fprintf('Element %d: %s\n', loc(kk), char_ar(kk))
    end
    return
end

alpha_scaling = max(max(max(img(:,:,:,end)))) * alpha_scale;
alpha = img(:,:,:,end);
alpha = alpha./alpha_scaling;
alpha(alpha > 1) = 1;

vol3d('CData', img(:,:,:,end), 'Alpha', alpha);

%% Dynamic visualization
% Time series of images, n reconstructions, optionally also the
% "true" image

algo_char = algorithms_char();

% 1 = MLEM, 2 = OSEM, 3 = MRAMLA, 4 = RAMLA, 5 = COSEM, 6 = ECOSEM, 7 =
% ACOSEM, 8 = MRP-OSL, 9 = MRP-BSREM, 10 = Quadratic prior OSL, 11 =
% Quadratic prior BSREM 12 = L-filter OSL, 13 = L-filter BSREM, 14 = FMH
% OSL, 15 = FMH BSREM, 16 = Weighted mean OSL, 17 = Weighted mean BSREM
% 18 = Total variation OSL, 18 = Total variation BSREM, 20 = Anisotropic
% diffusion OSL, 21 = Anisotropic diffusion BSREM, 22 = Asymmetric Parallel
% Level Sets OSL, 23 = Asymmetric Parallel Level Sets BSREM
algorithms = [2,3,4,5,6,7];
% algorithms = [8,9,10,11,12,13,14,15];
% Use this value to scale the color scale in the image (higher values make
% low count areas brighter)
color_scale = 1;
% From according to which reconstruction should the color scale be taken
% NOTE: The numbering is according to the length of algorithms vector, e.g.
% if you have algorithms = [2, 4, 5] and color_from_algo = 2 then the scale
% will be taken from RAMLA reconstruction (second element of algorithms)
color_from_algo = 1;
% Visualization plane
% Choose the plane where the visualization takes place
% 1 = Transverse, 2 = Coronal/frontal, 3 = Sagittal
v_plane = 3;
% From which slice is the dynamic time series obtained?
slice = 40;
% The source data was obtained from
% 0 = No source image, 1 = ASCII, 2 = LMF, 3 = ROOT
source = 0;
% How is the source image formed?
% 1 = Form the source image by using only singles (coincidences) that
% originate from the very same location (source coordinates are the same)
% 2 = Form the source image by using only the first single
% 3 = Form the source image by using only the second single
% 4 = Form the source image by using both singles and then dividing the
% counts by two
% 5 = Form the source image by using the average coordinates from both
% singles
% 6 = Form the source image by using the true coincidences (requires
% obtain_trues = true) (GATE only)
source_coordinates = 1;

img = pz{algorithms(color_from_algo)};
if isempty(img)
    warning('The current selected algorithm does not contain any estimes!')
    fprintf('The following are contained in the input array:\n')
    char_ar = algo_char(~cellfun(@isempty,pz(1:end-1)));
    loc = find(~cellfun(@isempty,pz(1:end-1)));
    for kk = 1 : nnz(~cellfun(@isempty,pz(1:end-1)))
        fprintf('Element %d: %s\n', loc(kk), char_ar(kk))
    end
    return
end

if length(algorithms) + nnz(source) > 2
    hh = 2;
else
    hh = 1;
end
if length(algorithms) + nnz(source) > 1
    jj = max(2, round((length(algorithms) + nnz(source)) / 2));
else
    jj = 1;
end
set(0,'units','pixels')
gg = get(0,'ScreenSize');
if jj > 4
    im_size = gg(4)/(2.5 + (jj - 4)/2);
else
    im_size = gg(4)/2.5;
end
figure
set(gcf, 'Position', [gg(3)/2-im_size/2*jj, gg(4)/2-im_size/2*hh, im_size * jj, im_size * hh]);

if source == 1
    load([image_properties.machine_name '_Ideal_image_coordinates_' image_properties.name '_ASCII.mat'])
elseif source == 2
    load([image_properties.machine_name '_Ideal_image_coordinates_' image_properties.name '_LMF.mat'])
elseif source == 3
    load([image_properties.machine_name '_Ideal_image_coordinates_' image_properties.name '_ROOT.mat'])
end

if source > 0
    clim2 = [0 max(max(max(max(FOV(:,:,:)))))/color_scale];
end
clim = [0 max(max(max(max(img(:,:,:,end)))))/color_scale];
if v_plane == 2
    koko = size(img,1);
elseif v_plane == 3
    koko = size(img,2);
else
    koko = size(img,3);
end
if slice > koko
    error("Selected slice exceeds image size in the specified dimension/plane")
end
for kk = 1 : image_properties.n_time_steps
    for ll = 1 : length(algorithms)
        
        img = pz{algorithms(ll),kk};
        if v_plane == 2
            img = rot90(permute(img, [3 2 1 4]),2);
        elseif v_plane == 3
            img = permute(img, [1 3 2 4]);
        end
        subplot(hh, jj, ll)
        imagesc(img(:,:,slice,end),clim)
        axis image
        title([char(algo_char(algorithms(ll))) ' time step = ' num2str(kk)])
    end
    if source > 0
        if source_coordinates == 1
            FOV = C{1,kk};
        elseif source_coordinates == 2
            FOV = C{2,kk};
        elseif source_coordinates == 3
            FOV = C{3,kk};
        elseif source_coordinates == 4
            FOV = C{4,kk};
        elseif source_coordinates == 5
            FOV = C{5,kk};
        elseif source_coordinates == 6
            FOV = C{6,kk};
        end
        if v_plane == 2
            FOV = permute(FOV, [1 3 2]);
        elseif v_plane == 3
            FOV = rot90(permute(FOV, [3 2 1]),2);
        end
        subplot(hh, jj, ll + 1)
        imagesc(FOV(:,:,slice),clim2)
        axis image
        title(['Original decay image, time step = ' num2str(kk)])
    end
    pause(0.25)
    drawnow
end