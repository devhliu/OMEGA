function [normalization_correction, randoms_correction, options] = set_up_corrections(options, rings)
%% SET UP CORRECTIONS
% This function sets up (loads) the necessary corrections that are applied.
% Included are attenuation correction, normalization correction and randoms
% and/or scatter correction. The variables used for correction are saved in
% the options-struct that also contains the input variables except for the
% number of rings in the current machine.


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

folder = fileparts(which('set_up_corrections.m'));
folder = strrep(folder, 'source','mat-files/');
folder = strrep(folder, '\','/');


block1 = 0;
if options.attenuation_correction
    if ~isfield(options,'vaimennus')
        data = load(options.attenuation_datafile);
        variables = fields(data);
        options.vaimennus = double(data.(variables{1}));
        if size(options.vaimennus,1) ~= options.Nx || size(options.vaimennus,2) ~= options.Ny || size(options.vaimennus,3) ~= options.Nz
            if size(options.vaimennus,1) ~= options.Nx*options.Ny*options.Nz
                error('Error: Attenuation data is of different size than the reconstructed image')
            end
        end
        if size(options.vaimennus,3) == 1
            options.vaimennus = options.vaimennus(2*block1+1:(2*rings+1)*options.Nx*options.Ny);
        else
            options.vaimennus = options.vaimennus(:,:,2*block1+1:2*rings+1);
        end
        options.vaimennus = options.vaimennus(:) / 10;
        if options.implementation == 2 || options.implementation == 3 || options.implementation == 5
            options.vaimennus = single(options.vaimennus);
        end
        clear data
    end
else
    if options.implementation == 2 || options.implementation == 3 || options.implementation == 5
        options.vaimennus = single(0);
    else
        options.vaimennus = 0;
    end
end

% Load (or compute) options.normalization correction coefficients
if (options.normalization_correction && options.corrections_during_reconstruction) && ~options.use_user_normalization
    normalization_correction = true;
    if ~isfield(options,'normalization')
        if options.use_raw_data
            norm_file = [folder options.machine_name '_normalization_listmode.mat'];
            if exist(norm_file, 'file') == 2
                options.normalization = loadStructFromFile(norm_file,'normalization');
            else
                error('Normalization correction selected, but no normalization data found')
            end
        else
            norm_file = [folder options.machine_name '_normalization_' num2str(options.Ndist) 'x' num2str(options.Nang) '_span' num2str(options.span) '.mat'];
            if exist(norm_file, 'file') == 2
                options.normalization = loadStructFromFile(norm_file,'normalization');
            else
                error('Normalization correction selected, but no normalization data found')
            end
        end
        options.normalization = options.normalization(:);
        if (options.implementation == 1 || options.implementation == 4)
            options.normalization = double(options.normalization);
        else
            options.normalization = single(options.normalization);
        end
    end
elseif options.normalization_correction && options.use_user_normalization && options.corrections_during_reconstruction
    normalization_correction = true;
    if ~isfield(options,'normalization')
        [file, ~] = uigetfile({'*.nrm;*.mat'},'Select normalization datafile');
        if isequal(file, 0)
            error('No file was selected')
        end
        if any(strfind(file, '.nrm'))
            if options.use_raw_data
                error('Inveon normalization data cannot be used with raw list-mode data')
            end
            fid = fopen(file);
            options.normalization = fread(fid, inf, 'single=>single',0,'l');
            fclose(fid);
            if numel(options.normalization) ~= options.Ndist * options.Nang * options.NSinos && ~options.use_raw_data
                error('Size mismatch between the current data and the normalization data file')
            end
%             options.normalization = 1 ./ options.normalization;
        else
            data = load(file);
            variables = fields(data);
            options.normalization = data.(variables{1});
            clear data
            if numel(options.normalization) ~= options.Ndist * options.Nang * options.NSinos && ~options.use_raw_data
                error('Size mismatch between the current data and the normalization data file')
            elseif numel(options.normalization) ~= sum(1:options.detectors) && options.use_raw_data
                error('Size mismatch between the current data and the normalization data file')
            end
        end
        if (options.implementation == 1 || options.implementation == 4)
            options.normalization = double(options.normalization);
        else
            options.normalization = single(options.normalization);
        end
        options.normalization = options.normalization(:);
    end
elseif options.normalization_correction && options.use_raw_data && ~options.corrections_during_reconstruction
    normalization_correction = false;
    if options.use_user_normalization
        [file, ~] = uigetfile({'*.nrm;*.mat'},'Select normalization datafile');
        if isequal(file, 0)
            error('No file was selected')
        end
        if any(strfind(file, '.nrm'))
            fid = fopen(file);
            normalization = fread(fid, inf, 'single=>single',0,'l');
            fclose(fid);
        else
            data = load(file);
            variables = fields(data);
            normalization = data.(variables{1});
            clear data
            if numel(normalization) ~= numel(options.SinM{1})
                error('Size mismatch between the current data and the normalization data file')
            end
        end
        normalization = normalization(:);
        if any(strfind(file, '.nrm'))
            normalization = 1 ./ normalization;
        end
    else
        norm_file = [folder options.machine_name '_normalization_listmode.mat'];
        if exist(norm_file, 'file') == 2
            normalization = loadStructFromFile(norm_file,'normalization');
        else
            normalization_coefficients(options);
            normalization = loadStructFromFile(norm_file,'normalization');
        end
        normalization = normalization(:);
    end
    for kk = 1 : options.partitions
        options.SinM{kk} = options.SinM{kk} .* normalization;
    end
    if options.implementation == 2 || options.implementation == 3 || options.implementation == 5
        options.normalization = single(0);
    else
        options.normalization = 0;
    end
else
    normalization_correction = false;
    if options.implementation == 2 || options.implementation == 3 || options.implementation == 5
        options.normalization = single(0);
    else
        options.normalization = 0;
    end
end

% Apply randoms and scatter (if available) correction
% Apply randoms smoothing/variance reduction
if (options.randoms_correction || options.scatter_correction) && options.corrections_during_reconstruction && ~options.reconstruct_trues...
        && ~options.reconstruct_scatter
    randoms_correction = true;
    r_exist = isfield(options,'SinDelayed');
    if options.randoms_correction && ~r_exist
        options = loadDelayedData(options);
    end
    if options.scatter_correction && ~isfield(options,'ScatterC')
        options = loadScatterData(options);
    end
    if r_exist
        if iscell(options.SinDelayed)
            for kk = 1 : options.partitions
                % SinM{kk} = SinM{kk} + SinDelayed{kk};
                % SinDelayed{kk} = 2 * SinDelayed{kk};
                options.SinDelayed{kk} = options.SinDelayed{kk}(:);
                if options.use_raw_data == false && options.NSinos ~= options.TotSinos
                    options.SinDelayed{kk} = options.SinDelayed{kk}(1:options.NSinos*options.Ndist*options.Nang);
                end
                if options.scatter_correction
                    if sum(size(options.ScatterC)) > 1 && ~iscell(options.ScatterC)
                        if size(options.ScatterC,1) ~= options.Ndist && ~options.use_raw_data
                            options.ScatterC = permute(options.ScatterC,[2 1 3]);
                        end
                        if normalization_correction && options.normalize_scatter
                            options.ScatterC = double(options.ScatterC) .* normalization;
                        end
                        if options.scatter_smoothing
                            options.ScatterC = randoms_smoothing(double(options.ScatterC), options);
                        end
                    elseif iscell(options.ScatterC)
                        if sum(size(options.ScatterC{1})) > 1
                            if size(options.ScatterC{kk},1) ~= options.Ndist && ~options.use_raw_data
                                options.ScatterC{kk} = permute(options.ScatterC{kk},[2 1 3]);
                            end
                        end
                        if normalization_correction && options.normalize_scatter
                            options.ScatterC{kk} = double(options.ScatterC{kk}) .* normalization;
                        end
                        if options.scatter_smoothing
                            options.ScatterC{kk} = randoms_smoothing(double(options.ScatterC{kk}), options);
                        end
                    end
                    if options.implementation == 2 || options.implementation == 3 || options.implementation == 5
                        options.SinDelayed{kk} = single(options.SinDelayed{kk}) + single(options.ScatterC{kk}(:));
                    else
                        options.SinDelayed{kk} = double(options.SinDelayed{kk}) + double(options.ScatterC{kk}(:));
                    end
                end
            end
        else
            options.SinDelayed = options.SinDelayed(:);
            if options.use_raw_data == false && options.NSinos ~= options.TotSinos
                options.SinDelayed = options.SinDelayed(1:options.NSinos*options.Ndist*options.Nang);
            end
            % Sino = Sino + SinDelayed;
            % SinDelayed = 2 * SinDelayed;
            if options.scatter_correction && isfield(options,'ScatterC')
                if sum(size(options.ScatterC)) > 1 && ~iscell(options.ScatterC)
                    if size(options.ScatterC,1) ~= options.Ndist && ~options.use_raw_data
                        options.ScatterC = permute(options.ScatterC,[2 1 3]);
                    end
                    % if options.variance_reduction
                    %    options.ScatterC = Randoms_variance_reduction(double(options.ScatterC), options);
                    % end
                    if normalization_correction && options.normalize_scatter
                        options.ScatterC = double(options.ScatterC) .* normalization;
                    end
                    if options.scatter_smoothing
                        options.ScatterC = randoms_smoothing(double(options.ScatterC), options);
                    end
                    if options.use_raw_data == false && options.NSinos ~= options.TotSinos
                        options.ScatterC = options.ScatterC(1:options.NSinos*options.Ndist*options.Nang);
                    end
                    if options.implementation == 2 || options.implementation == 3 || options.implementation == 5
                        options.SinDelayed = single(options.SinDelayed) + single(options.ScatterC(:));
                    else
                        options.SinDelayed = double(options.SinDelayed) + double(options.ScatterC(:));
                    end
                elseif iscell(options.ScatterC)
                    for kk = 1 : options.partitions
                        if sum(size(options.ScatterC{kk})) > 1
                            if size(options.ScatterC{kk},1) ~= options.Ndist && ~options.use_raw_data
                                options.ScatterC{kk} = permute(options.ScatterC{kk},[2 1 3]);
                            end
                        end
                        if normalization_correction && options.normalize_scatter
                            options.ScatterC{kk} = double(options.ScatterC{kk}) .* normalization;
                        end
                        if options.scatter_smoothing
                            options.ScatterC{kk} = randoms_smoothing(double(options.ScatterC{kk}), options);
                        end
                        if options.use_raw_data == false && options.NSinos ~= options.TotSinos
                            options.ScatterC{kk} = options.ScatterC{kk}(1:options.NSinos*options.Ndist*options.Nang);
                        end
                        if options.implementation == 2 || options.implementation == 3 || options.implementation == 5
                            options.SinDelayed = single(options.SinDelayed) + single(options.ScatterC{kk}(:));
                        else
                            options.SinDelayed = double(options.SinDelayed) + double(options.ScatterC{kk}(:));
                        end
                    end
                end
            end
        end
    else
        if options.randoms_correction && iscell(options.SinDelayed)
            for kk = 1 : options.partitions
                % SinM{kk} = SinM{kk} + SinDelayed{kk};
                % SinDelayed{kk} = 2 * SinDelayed{kk};
                if options.variance_reduction
                    options.SinDelayed{kk} = Randoms_variance_reduction(double(options.SinDelayed{kk}), options);
                end
                if options.randoms_smoothing
                    options.SinDelayed{kk} = randoms_smoothing(double(options.SinDelayed{kk}), options);
                end
                options.SinDelayed{kk} = options.SinDelayed{kk}(:);
                if options.use_raw_data == false && options.NSinos ~= options.TotSinos
                    options.SinDelayed{kk} = options.SinDelayed{kk}(1:options.NSinos*options.Ndist*options.Nang);
                end
                if options.scatter_correction
                    if sum(size(options.ScatterC)) > 1 && ~iscell(options.ScatterC)
                        if size(options.ScatterC,1) ~= options.Ndist && ~options.use_raw_data
                            options.ScatterC = permute(options.ScatterC,[2 1 3]);
                        end
                        if normalization_correction && options.normalize_scatter
                            options.ScatterC = double(options.ScatterC) .* normalization;
                        end
                        if options.scatter_smoothing
                            options.ScatterC = randoms_smoothing(double(options.ScatterC), options);
                        end
                    elseif iscell(options.ScatterC)
                        if sum(size(options.ScatterC{1})) > 1
                            if size(options.ScatterC{kk},1) ~= options.Ndist && ~options.use_raw_data
                                options.ScatterC{kk} = permute(options.ScatterC{kk},[2 1 3]);
                            end
                        end
                        if normalization_correction && options.normalize_scatter
                            options.ScatterC{kk} = double(options.ScatterC{kk}) .* normalization;
                        end
                        if options.scatter_smoothing
                            options.ScatterC{kk} = randoms_smoothing(double(options.ScatterC{kk}), options);
                        end
                    end
                    if options.implementation == 2 || options.implementation == 3 || options.implementation == 5
                        options.SinDelayed{kk} = single(options.SinDelayed{kk}) + single(options.ScatterC{kk}(:));
                    else
                        options.SinDelayed{kk} = double(options.SinDelayed{kk}) + double(options.ScatterC{kk}(:));
                    end
                end
            end
        elseif options.randoms_correction
            if options.variance_reduction
                options.SinDelayed = Randoms_variance_reduction(double(options.SinDelayed), options);
            end
            if options.randoms_smoothing
                options.SinDelayed = randoms_smoothing(double(options.SinDelayed), options);
            end
            options.SinDelayed = options.SinDelayed(:);
            if options.use_raw_data == false && options.NSinos ~= options.TotSinos
                options.SinDelayed = options.SinDelayed(1:options.NSinos*options.Ndist*options.Nang);
            end
            % Sino = Sino + SinDelayed;
            % SinDelayed = 2 * SinDelayed;
            if options.scatter_correction && isfield(options,'ScatterC')
                if sum(size(options.ScatterC)) > 1 && ~iscell(options.ScatterC)
                    if size(options.ScatterC,1) ~= options.Ndist && ~options.use_raw_data
                        options.ScatterC = permute(options.ScatterC,[2 1 3]);
                    end
                    % if options.variance_reduction
                    %    options.ScatterC = Randoms_variance_reduction(double(options.ScatterC), options);
                    % end
                    if normalization_correction && options.normalize_scatter
                        options.ScatterC = double(options.ScatterC) .* normalization;
                    end
                    if options.scatter_smoothing
                        options.ScatterC = randoms_smoothing(double(options.ScatterC), options);
                    end
                    if options.use_raw_data == false && options.NSinos ~= options.TotSinos
                        options.ScatterC = options.ScatterC(1:options.NSinos*options.Ndist*options.Nang);
                    end
                    if options.implementation == 2 || options.implementation == 3 || options.implementation == 5
                        options.SinDelayed = single(options.SinDelayed) + single(options.ScatterC(:));
                    else
                        options.SinDelayed = double(options.SinDelayed) + double(options.ScatterC(:));
                    end
                elseif iscell(options.ScatterC)
                    for kk = 1 : options.partitions
                        if sum(size(options.ScatterC{kk})) > 1
                            if size(options.ScatterC{kk},1) ~= options.Ndist && ~options.use_raw_data
                                options.ScatterC{kk} = permute(options.ScatterC{kk},[2 1 3]);
                            end
                        end
                        if normalization_correction && options.normalize_scatter
                            options.ScatterC{kk} = double(options.ScatterC{kk}) .* normalization;
                        end
                        if options.scatter_smoothing
                            options.ScatterC{kk} = randoms_smoothing(double(options.ScatterC{kk}), options);
                        end
                        if options.use_raw_data == false && options.NSinos ~= options.TotSinos
                            options.ScatterC{kk} = options.ScatterC{kk}(1:options.NSinos*options.Ndist*options.Nang);
                        end
                        if options.implementation == 2 || options.implementation == 3 || options.implementation == 5
                            options.SinDelayed = single(options.SinDelayed) + single(options.ScatterC{kk}(:));
                        else
                            options.SinDelayed = double(options.SinDelayed) + double(options.ScatterC{kk}(:));
                        end
                    end
                end
            end
        elseif options.scatter_correction
            if sum(size(options.ScatterC)) > 1 && ~iscell(options.ScatterC)
                if size(options.ScatterC,1) ~= options.Ndist && ~options.use_raw_data
                    options.ScatterC = permute(options.ScatterC,[2 1 3]);
                end
                if normalization_correction && options.normalize_scatter
                    options.ScatterC = double(options.ScatterC) .* normalization;
                end
                if options.scatter_smoothing
                    options.ScatterC = randoms_smoothing(double(options.ScatterC), options);
                end
                if options.implementation == 2 || options.implementation == 3 || options.implementation == 5
                    options.SinDelayed = single(options.ScatterC(:));
                else
                    options.SinDelayed = double(options.ScatterC(:));
                end
            elseif iscell(options.ScatterC)
                options.SinDelayed = cell(length(options.ScatterC),1);
                for kk = 1 : options.partitions
                    if sum(size(options.ScatterC{1})) > 1
                        if size(options.ScatterC{kk},1) ~= options.Ndist && ~options.use_raw_data
                            options.ScatterC{kk} = permute(options.ScatterC{kk},[2 1 3]);
                        end
                    end
                    if normalization_correction && options.normalize_scatter
                        options.ScatterC{kk} = double(options.ScatterC{kk}) .* normalization;
                    end
                    if options.scatter_smoothing
                        options.ScatterC{kk} = randoms_smoothing(double(options.ScatterC{kk}), options);
                    end
                    if options.implementation == 2 || options.implementation == 3 || options.implementation == 5
                        options.SinDelayed{kk} = single(options.ScatterC{kk}(:));
                    else
                        options.SinDelayed{kk} = double(options.ScatterC{kk}(:));
                    end
                end
            end
        end
    end
else
    randoms_correction = false;
    if options.implementation == 2 || options.implementation == 3 || options.implementation == 5
        options.SinDelayed = {single(0)};
    else
        options.SinDelayed = {0};
    end
end