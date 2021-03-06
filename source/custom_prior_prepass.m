function [options, varargout] = custom_prior_prepass(options, varargin)
%% Prepass phase for the custom prior file
% Computes all the necessary variables needed for the reconstruction
% process
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020 Ville-Veikko Wettenhovi, Samuli Summala
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

if nargin > 1
    custom = false;
else
    custom = true;
end

if ~isfield(options,'use_Inveon')
    options.use_Inveon = 0;
end


if ~isfield(options,'SinM')
    options.SinM = [];
end

if options.precompute_lor == false && options.implementation == 3
    error('precompute_lor must be set to true if using method 3')
end

Nx = options.Nx;
Ny = options.Ny;
Nz = options.Nz;
subsets = options.subsets;
% attenuation_correction = options.attenuation_correction;
diameter = options.diameter;
FOVax = options.FOVa_x;
FOVay = options.FOVa_y;
axial_fov = options.axial_fov;
NSinos = options.NSinos;
pseudot = int32(options.pseudot);
rings = options.rings;
det_per_ring = options.det_per_ring;
machine_name = options.machine_name;
Nang = options.Nang;
Ndist = options.Ndist;
% cr_pz = options.cr_pz;
use_raw_data = options.use_raw_data;
TotSinos = options.TotSinos;
% attenuation_datafile = options.attenuation_datafile;
% partitions = options.partitions;
% verbose = options.verbose;

options.N = Nx * Ny * Nz;
% options.U = [];
% options.weights = [];
% options.a_L = [];
% options.fmh_weights = [];
% options.weighted_weights = [];
% options.weights_quad = [];

options.MAP = (options.OSL_MLEM || options.OSL_OSEM || options.BSREM || options.MBSREM || options.ROSEM_MAP || options.RBI_OSL || any(options.COSEM_OSL));
options.empty_weight = false;
options.MBSREM_prepass = true;
    
% if custom
    options.rekot = reko_maker(options);
    pz = cell(length(options.rekot),options.partitions);
% end

temp = pseudot;
if ~isempty(temp) && temp > 0
    for kk = uint32(1) : temp
        pseudot(kk) = uint32(options.cryst_per_block + 1) * kk;
    end
elseif temp == 0
    pseudot = [];
end
options.pseudot = pseudot;
    
if options.precompute_lor
    options.is_transposed = true;
else
    options.is_transposed = false;
end

[gaussK, options] = PSFKernel(options);

if custom
    if (options.quad || options.Huber || options.FMH || options.L || options.weighted_mean || options.MRP) && options.MAP
        Ndx = options.Ndx;
        Ndy = options.Ndy;
        Ndz = options.Ndz;
    end
    if options.L && options.MAP
        %     options.a_L = options.a_L;
        if ~isempty(options.a_L)
            if length(options.a_L(:)) < ((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1))
                error(['Weights vector options.a_L is too small, needs to be ' num2str(((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1))) ' in length'])
            elseif length(options.a_L(:)) > ((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1))
                error(['Weights vector options.a_L is too large, needs to be ' num2str(((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1))) ' in length'])
            end
        end
    end
    if (options.quad || options.Huber || options.FMH || options.L || options.weighted_mean) && options.MAP
        %     options.weights = options.weights;
        if ~isempty(options.weights)
            if length(options.weights(:)) < ((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1))
                error(['Weights vector is too small, needs to be ' num2str(((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1))) ' in length'])
            elseif length(options.weights(:)) > ((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1))
                error(['Weights vector is too large, needs to be ' num2str(((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1))) ' in length'])
            end
            if ~isinf(options.weights(ceil(((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1)/2))))
                options.weights(ceil(((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1)/2))) = Inf;
            end
        else
            options.empty_weight = true;
        end
    end
    if options.Huber && options.MAP
        if ~isempty(options.weights_huber)
            if length(options.weights_huber(:)) < ((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1))
                error(['Huber weights vector is too small, needs to be ' num2str(((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1))) ' in length'])
            elseif length(options.weights_huber(:)) > ((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1))
                error(['Huber weights vector is too large, needs to be ' num2str(((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1))) ' in length'])
            end
            if ~isinf(options.weights_huber(ceil(((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1)/2))))
                options.weights_huber(ceil(((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1)/2))) = Inf;
            end
        end
    end
    if options.FMH && options.MAP
        %     options.fmh_weights = options.fmh_weights;
        if ~isempty(options.fmh_weights)
            if Nz == 1 || Ndz == 0
                if length(options.fmh_weights(:)) < (4*(Ndx*2+1))
                    error(['Weights vector options.fmh_weights is too small, needs to be [' num2str(Ndx*2+1) ', 4] in size'])
                elseif length(options.fmh_weights(:)) > (4*(Ndx*2+1))
                    error(['Weights vector options.fmh_weights is too large, needs to be [' num2str(Ndx*2+1) ', 4] in size'])
                end
            else
                if length(options.fmh_weights(:)) < (13*(Ndx*2+1))
                    error(['Weights vector options.fmh_weights is too small, needs to be [' num2str(Ndx*2+1) ', 13] in size'])
                elseif length(options.fmh_weights(:)) > (13*(Ndx*2+1))
                    error(['Weights vector options.fmh_weights is too large, needs to be [' num2str(Ndx*2+1) ', 13] in size'])
                end
            end
        end
    end
    if options.weighted_mean && options.MAP
        %     options.weighted_weights = options.weighted_weights;
        if ~isempty(options.weighted_weights)
            if length(options.weighted_weights(:)) < ((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1))
                error(['Weights vector options.weighted_weights is too small, needs to be ' num2str(((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1))) ' in length'])
            elseif length(options.weighted_weights(:)) > ((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1))
                error(['Weights vector options.weighted_weights is too large, needs to be ' num2str(((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1))) ' in length'])
            end
            if ~isinf(options.weighted_weights(ceil(((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1)/2))))
                options.weighted_weights(ceil(((Ndx*2+1) * (Ndy*2+1) * (Ndz*2+1)/2))) = Inf;
            end
        end
    end
    
    options.im_vectors = form_image_vectors(options, options.N);
    
    if options.use_raw_data
        options.SinM = options.coincidences;
        % Perform corrections if needed
        if options.randoms_correction && ~options.reconstruct_trues && ~options.reconstruct_scatter
            if (options.use_ASCII || options.use_LMF || options.use_root) && options.use_machine == 0
                if options.partitions == 1
                    if options.use_ASCII && options.use_machine == 0
                        load([options.machine_name '_measurements_' options.name '_static_raw_ASCII.mat'], 'delayed_coincidences')
                    elseif options.use_LMF && options.use_machine == 0
                        load([options.machine_name '_measurements_' options.name '_static_raw_LMF.mat'], 'delayed_coincidences')
                    elseif options.use_root && options.use_machine == 0
                        load([options.machine_name '_measurements_' options.name '_static_raw_root.mat'], 'delayed_coincidences')
                    else
                        load([options.machine_name '_measurements_' options.name '_static_raw_listmode.mat'], 'delayed_coincidences')
                    end
                else
                    if options.use_ASCII && options.use_machine == 0
                        load([options.machine_name '_measurements_' options.name '_' num2str(options.partitions) 'timepoints_for_total_of_ ' ...
                            num2str(options.tot_time) 's_raw_ASCII.mat'], 'delayed_coincidences')
                    elseif options.use_LMF && options.use_machine == 0
                        load([options.machine_name '_measurements_' options.name '_' num2str(options.partitions) 'timepoints_for_total_of_ ' ...
                            num2str(options.tot_time) 's_raw_LMF.mat'], 'delayed_coincidences')
                    elseif options.use_root && options.use_machine == 0
                        load([options.machine_name '_measurements_' options.name '_' num2str(options.partitions) 'timepoints_for_total_of_ ' ...
                            num2str(options.tot_time) 's_raw_root.mat'], 'delayed_coincidences')
                    else
                        load([options.machine_name '_measurements_' options.name '_' num2str(options.partitions) 'timepoints_for_total_of_ ' ...
                            num2str(options.tot_time) 's_raw_listmode.mat'], 'delayed_coincidences')
                    end
                end
                if exist('delayed_coincidences','var')
                    if ~options.corrections_during_reconstruction
                        if iscell(options.SinM) && iscell(delayed_coincidences)
                            for kk = 1 : length(options.SinM)
                                options.SinM{kk} = options.SinM{kk} - delayed_coincidences{kk};
                                options.SinM{kk}(options.SinM{kk} < 0) = 0;
                            end
                        else
                            options.SinM = options.SinM - delayed_coincidences;
                            options.SinM(options.SinM < 0) = 0;
                        end
                    end
                else
                    disp('Delayed coincidences not found, randoms correction not performed')
                end
            else
                if iscell(options.SinD)
                    if iscell(options.SinM)
                        for kk = 1 : length(options.SinM)
                            if numel(options.SinD{kk}) ~= numel(options.SinM{kk})
                                error('Size mismatch between randoms correction data and measurement data')
                            end
                            options.SinM{kk} = options.SinM{kk} - single(options.SinD{kk}(:));
                            options.SinM{kk}(options.SinM{kk} < 0) = 0;
                        end
                    else
                        if numel(options.SinD{1}) ~= numel(options.SinM)
                            error('Size mismatch between randoms correction data and measurement data')
                        end
                        options.SinM = options.SinM - single(options.SinD{1}(:));
                        options.SinM(options.SinM < 0) = 0;
                    end
                else
                    if iscell(options.SinM)
                        for kk = 1 : length(options.SinM)
                            if numel(options.SinD) ~= numel(options.SinM{kk})
                                error('Size mismatch between randoms correction data and measurement data')
                            end
                            options.SinM{kk} = options.SinM{kk} - single(options.SinD(:));
                            options.SinM{kk}(options.SinM{kk} < 0) = 0;
                        end
                    else
                        if numel(options.SinD) ~= numel(options.SinM)
                            error('Size mismatch between randoms correction data and measurement data')
                        end
                        options.SinM = options.SinM - single(options.SinD(:));
                        options.SinM(options.SinM < 0) = 0;
                    end
                end
            end
        end
        if options.scatter_correction && ~options.corrections_during_reconstruction
            if iscell(options.ScatterC)
                if iscell(options.SinM)
                    for kk = 1 : length(options.SinM)
                        if numel(options.ScatterC{kk}) ~= numel(options.SinM{kk})
                            error('Size mismatch between scatter correction data and measurement data')
                        end
                        options.SinM{kk} = options.SinM{kk} - single(options.ScatterC{kk}(:));
                        options.SinM{kk}(options.SinM{kk} < 0) = 0;
                    end
                else
                    if numel(options.ScatterC{1}) ~= numel(options.SinM)
                        error('Size mismatch between scatter correction data and measurement data')
                    end
                    options.SinM = options.SinM - single(options.ScatterC{1}(:));
                    options.SinM(options.SinM < 0) = 0;
                end
            else
                if iscell(options.SinM)
                    for kk = 1 : length(options.SinM)
                        if numel(options.ScatterC) ~= numel(options.SinM{kk})
                            error('Size mismatch between scatter correction data and measurement data')
                        end
                        options.SinM{kk} = options.SinM{kk} - single(options.ScatterC(:));
                        options.SinM{kk}(options.SinM{kk} < 0) = 0;
                    end
                else
                    if numel(options.ScatterC) ~= numel(options.SinM)
                        error('Size mismatch between scatter correction data and measurement data')
                    end
                    options.SinM = options.SinM - single(options.ScatterC(:));
                    options.SinM(options.SinM < 0) = 0;
                end
            end
        end
        
        clear coincidences options.coincidences true_coincidences delayed_coincidences
        % Sinogram data
    else
        if options.partitions == 1 && options.randoms_correction && options.corrections_during_reconstruction
            if options.use_machine == 0
                options.SinDelayed = loadStructFromFile([options.machine_name '_' options.name '_sinograms_combined_static_' num2str(options.Ndist) 'x' num2str(options.Nang) 'x' ...
                    num2str(options.TotSinos) '_span' num2str(options.span) '.mat'],'SinDelayed');
            elseif  options.use_machine == 1
                options.SinDelayed = loadStructFromFile([options.machine_name '_' options.name '_sinograms_combined_static_' num2str(options.Ndist) 'x' num2str(options.Nang) 'x' ...
                    num2str(options.TotSinos) '_span' num2str(options.span) '_listmode.mat'],'SinDelayed');
            else
                [dfile, dfpath] = uigetfile('*.mat','Select delayed coincidence datafile');
                if isequal(dfile, 0)
                    error('No file was selected')
                end
                data = load(fullfile(dfpath, dfile));
                variables = fields(data);
                if length(variables) > 1
                    if (any(strcmp('SinDelayed',variables)))
                        options.SinDelayed = double(data.(variables{strcmp('SinDelayed',variables)}));
                    else
                        error('The provided delayed coincidence file contains more than one variable and none of them are named "SinDelayed".')
                    end
                else
                    options.SinDelayed = single(data.(variables{1}));
                end
                clear data variables
            end
        elseif options.randoms_correction && options.corrections_during_reconstruction
            if options.use_machine == 0
                options.SinDelayed = loadStructFromFile([options.machine_name '_' options.name '_sinograms_combined_' num2str(options.partitions) 'timepoints_for_total_of_ ' ...
                    num2str(options.tot_time) 's_' num2str(options.Ndist) 'x' num2str(options.Nang) 'x' num2str(options.TotSinos) '_span' ...
                    num2str(options.span) '.mat'], 'SinDelayed');
            elseif  options.use_machine == 1
                options.SinDelayed = loadStructFromFile([options.machine_name '_' options.name '_sinograms_combined_' num2str(options.partitions) 'timepoints_for_total_of_ ' ...
                    num2str(options.tot_time) 's_' num2str(options.Ndist) 'x' num2str(options.Nang) 'x' num2str(options.TotSinos) '_span' ...
                    num2str(options.span) '_listmode.mat'], 'SinDelayed');
            else
                [options.file, options.fpath] = uigetfile('*.mat','Select delayed coincidence datafile');
                if isequal(options.file, 0)
                    error('No file was selected')
                end
                data = load(fullfile(options.fpath, options.file));
                variables = fields(data);
                if length(variables) > 1
                    if (any(strcmp('SinDelayed',variables)))
                        options.SinDelayed = single(data.(variables{strcmp('SinDelayed',variables)}));
                    else
                        error('The provided delayed coincidence file contains more than one variable and none of them are named "SinDelayed".')
                    end
                else
                    options.SinDelayed = single(data.(variables{1}));
                end
                clear data variables
                if length(options.SinDelayed) < options.partitions && iscell(options.SinDelayed)
                    warning('The number of delayed coincidence sinograms is less than the number of time points. Using the first one')
                    temp = options.SinDelayed;
                    options.SinDelayed = cell(options.partitions,1);
                    if sum(size(temp{1})) > 1
                        if size(temp{1},1) ~= size(options.Nang)
                            temp{1} = permute(temp{1},[2 1 3]);
                        end
                    end
                    for kk = 1 : options.partitions
                        options.SinDelayed{kk} = temp{1};
                    end
                elseif options.partitions > 1
                    warning('The number of delayed coincidence sinograms is less than the number of time points. Using the first one')
                    temp = options.SinDelayed;
                    options.SinDelayed = cell(options.partitions,1);
                    if sum(size(temp)) > 1
                        if size(temp,1) ~= size(options.Nang)
                            temp = permute(temp,[2 1 3]);
                        end
                    end
                    for kk = 1 : options.partitions
                        options.SinDelayed{kk} = temp;
                    end
                else
                    if iscell(options.SinDelayed)
                        for kk = 1 : length(options.SinDelayed)
                            if sum(size(options.SinDelayed{kk})) > 1
                                if size(options.SinDelayed{kk},1) ~= size(options.Nang)
                                    options.SinDelayed{kk} = permute(options.SinDelayed{kk},[2 1 3]);
                                end
                            end
                        end
                    else
                        if sum(size(options.SinDelayed)) > 1
                            if size(options.SinDelayed,1) ~= size(options.Nang)
                                options.SinDelayed = permute(options.SinDelayed,[2 1 3]);
                            end
                        end
                    end
                end
            end
        end
    end
end

%% This part is used when the observation matrix is calculated on-the-fly
% Compute the indices for the subsets used.
% For Sinogram data, five different methods to select the subsets are
% available. For raw list-mode data, three methods are available.
[options.index, options.pituus, options.subsets] = index_maker(Nx, Ny, Nz, subsets, use_raw_data, machine_name, options, Nang, Ndist, TotSinos, NSinos);


%%

% Diameter of the PET-device (bore) (mm)
R=double(diameter);
% Transaxial FOV (x-direction, horizontal) (mm)
FOVax=double(FOVax);
% Transaxial FOV (y-direction, vertical) (mm)
FOVay=double(FOVay);
% Axial FOV (mm)
axial_fow = double(axial_fov);
% Number of rings
options.blocks=int32(rings + length(pseudot) - 1);
% First ring
options.block1=int32(0);

options.NSinos = int32(NSinos);
options.NSlices = int32(Nz);
options.TotSinos = int32(TotSinos);

[x, y, z_det, options] = get_coordinates(options, options.blocks, options.pseudot);

if ~custom
    options.randoms_correction = false;
    options.scatter_correction = false;
end

[options.normalization_correction, options.randoms_correction, options] = set_up_corrections(options, options.blocks, [], []);

if options.implementation == 2 || options.implementation == 3 || options.implementation == 5
    options.x = single(x);
    options.y = single(y);
    options.z_det = single(z_det);
else
    options.x = double(x);
    options.y = double(y);
    options.z_det = double(z_det);
end

if options.use_raw_data
    options.size_x = uint32(options.det_w_pseudo);
else
    options.size_x = uint32(options.Nang*options.Ndist);
    if options.sampling > 1 && ~options.precompute_lor
        options.size_x = options.size_x * options.sampling;
    end
end

if options.precompute_lor && options.subsets > 1 || options.implementation == 2  && options.subsets > 1 || options.implementation == 4 && options.subsets > 1
    options.pituus = [0;cumsum(options.pituus)];
    if iscell(options.index)
        options.index = cell2mat(options.index);
    end
    indeksi = options.index;
elseif options.implementation == 1
    options.pituus = [0;cumsum(options.pituus)];
    if iscell(options.index)
        options.index = cell2mat(options.index);
    end
    indeksi = options.index;
else
    if iscell(options.index)
        options.index = cell2mat(options.index);
    end
    indeksi = options.index;
end

if options.use_raw_data
    if isempty(options.pseudot)
        options.pseudot = int32(1e5);
    else
        options.pseudot = options.pseudot - 1;
    end
end

% for the precomputed version, index vectors are needed

[options, options.lor_a, options.xy_index, options.z_index, options.LL, options.summa, options.pituus, options.SinM, options.lor_orth] = ...
    form_subset_indices(options, options.pituus, subsets, indeksi, options.size_x, options.y, options.z_det, rings, false, options.SinM);
if ~options.precompute_lor
    options.lor_a = uint16(0);
end


% Pixels
etaisyys_x=(R-FOVax)/2;
etaisyys_y=(R-FOVay)/2;
if options.implementation == 2 || options.implementation == 4
    options.zz=linspace(single(0),single(axial_fow),Nz+1);
    options.xx = single(linspace(etaisyys_x,R-etaisyys_x,Nx+1));
    options.yy = single(linspace(etaisyys_y,R-etaisyys_y,Ny+1));
else
    options.zz=linspace(double(0),double(axial_fow),Nz+1);
    options.xx = double(linspace(etaisyys_x,R-etaisyys_x,Nx+1));
    options.yy = double(linspace(etaisyys_y,R-etaisyys_y,Ny+1));
end
options.zz=options.zz(2*options.block1+1:2*options.blocks+2);

% Distance of adjacent pixels
options.dx=diff(options.xx(1:2));
options.dy=diff(options.yy(1:2));
options.dz=diff(options.zz(1:2));

% Distance of image from the origin
options.bx=options.xx(1);
options.by=options.yy(1);
options.bz=options.zz(1);

% Number of pixels
options.Ny=int32(Ny);
options.Nx=int32(Nx);
options.Nz=int32(Nz);

options.N=(Nx)*(Ny)*(Nz);
options.det_per_ring = int32(det_per_ring);

% How much memory is preallocated
if use_raw_data == false
    options.ind_size = int32(NSinos/options.subsets*(det_per_ring)* Nx * (Ny));
else
    options.ind_size = int32((det_per_ring)^2/options.subsets* Nx * (Ny));
end


options.zmax = max(max(options.z_det));
if options.zmax==0
    if options.implementation == 2 || options.implementation == 4
        options.zmax = single(1);
    else
        options.zmax = double(1);
    end
end
% Coordinates of the centers of the voxels
if options.projector_type == 2
    options.x_center = options.xx(1 : end - 1)' + options.dx/2;
    options.y_center = options.yy(1 : end - 1)' + options.dy/2;
    options.z_center = options.zz(1 : end - 1)' + options.dz/2;
    temppi = min([options.FOVa_x / options.Nx, options.axial_fov / options.Nz]);
    if options.tube_width_z > 0
        temppi = max([1,round(options.tube_width_z / temppi)]);
    else
        temppi = max([1,round(options.tube_width_xy / temppi)]);
    end
    temppi = temppi * temppi * 3;
    if options.apply_acceleration
        if options.tube_width_z == 0
            options.dec = uint32(sqrt(options.Nx^2 + options.Ny^2) * temppi);
        else
            options.dec = uint32(sqrt(options.Nx^2 + options.Ny^2 + options.Nz^2) * temppi);
        end
    else
        options.dec = uint32(0);
    end
else
    options.x_center = options.xx(1);
    options.y_center = options.yy(1);
    options.z_center = options.zz(1);
    options.dec = uint32(0);
end


if options.projector_type == 3
    dp = max([options.dx,options.dy,options.dz]);
    options.voxel_radius = sqrt(2) * options.voxel_radius * (dp / 2);
    bmax = options.tube_radius + options.voxel_radius;
    b = linspace(0, bmax, 10000)';
    b(options.tube_radius > (b + options.voxel_radius)) = [];
    b = unique(round(b*10^3)/10^3);
    V = volumeIntersection(options.tube_radius, options.voxel_radius, b);
    diffis = [diff(V);0];
    b = b(diffis <= 0);
    V = V(diffis <= 0);
    Vmax = (4*pi)/3*options.voxel_radius^3;
    bmin = min(b);
else
    V = 0;
    Vmax = 0;
    bmin = 0;
    bmax = 0;
end
if options.implementation == 2 || options.implementation == 3
    options.V = single(V);
    options.Vmax = single(Vmax);
    options.bmin = single(bmin);
    options.bmax = single(bmax);
else
    options.V = (V);
    options.Vmax = (Vmax);
    options.bmin = (bmin);
    options.bmax = (bmax);
end
%%

[options, options.D, options.C_co, options.C_aco, options.C_osl, options.Amin, options.E] = ...
    prepass_phase(options, options.pituus, options.index, options.SinM, options.pseudot, options.x, options.y, options.xx, options.yy, options.z_det, options.dz, options.dx, options.dy, ...
    options.bz, options.bx, options.by, options.NSlices, options.zmax, options.size_x, options.block1, options.blocks, options.normalization_correction, options.randoms_correction, ...
    options.xy_index, options.z_index, options.lor_a, options.lor_orth, options.summa, options.LL, options.is_transposed, options.x_center, options.y_center, options.z_center, 0, ...
    gaussK, options.bmin, options.bmax, options.Vmax, options.V);


if options.MBSREM || options.mramla
    if iscell(options.SinDelayed)
        if iscell(options.SinM)
            options.epsilon_mramla = MBSREM_epsilon(options.SinM{1}, options.epps, options.randoms_correction, options.SinDelayed{llo}, options.E);
        else
            options.epsilon_mramla = MBSREM_epsilon(options.SinM, options.epps, options.randoms_correction, options.SinDelayed{llo}, options.E);
        end
    else
        if iscell(options.SinM)
            options.epsilon_mramla = MBSREM_epsilon(options.SinM{1}, options.epps, options.randoms_correction, options.SinDelayed, options.E);
        else
            options.epsilon_mramla = MBSREM_epsilon(options.SinM, options.epps, options.randoms_correction, options.SinDelayed, options.E);
        end
    end
end
% if custom
    varargout{1} = pz;
% end
end