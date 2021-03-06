function pz = save_image_properties(options, pz, subsets)
%SAVE_IMAGE_PROPERTIES Saves the various reconstruction related variables
%in a struct variable

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
if options.implementation == 1
    image_properties.Implementation = 'MATLAB';
elseif options.implementation == 3
    image_properties.Implementation = 'Matrix-free multi-device OpenCL';
elseif options.implementation == 4
    image_properties.Implementation = 'CPU matrix-free';
elseif options.implementation == 2
    image_properties.Implementation = 'Matrix-free ArrayFire OpenCL';
end
if options.projector_type == 0
    image_properties.Projector = 'Original Siddon''s ray tracer';
elseif options.projector_type == 1
    if options.precompute_lor
        image_properties.Projector = 'Improved Siddon''s ray tracer with 1 ray';
    else
        if options.n_rays_transaxial > 1
            ray = 'rays';
        else
            ray = 'ray';
        end
        if options.n_rays_axial > 1
            aray = 'rays';
        else
            aray = 'ray';
        end
        image_properties.Projector = ['Improved Siddon''s algorithm used with ' num2str(options.n_rays_transaxial) ' transaxial ' ray ' and ' ...
            num2str(options.n_rays_axial) ' axial ' aray '.'];
    end
elseif options.projector_type == 2
    if options.tube_width_z == 0
        image_properties.Projector = 'Orthogonal distance-based ray tracer in 2D';
    else
        image_properties.Projector = 'Orthogonal distance-based ray tracer in 3D';
    end
elseif options.projector_type == 3
    image_properties.Projector = 'Volume-based ray tracer';
end
if options.use_psf
    if options.deblurring
        image_properties.PSF = 'PSF enabled with deblurring';
    else
        image_properties.PSF = 'PSF enabled';
    end
else
    image_properties.PSF = 'No PSF';
end
image_properties.Nx = options.Nx;
image_properties.Ny = options.Ny;
image_properties.Nz = options.Nz;
image_properties.Nang = options.Nang;
image_properties.Ndist = options.Ndist;
image_properties.NSinos = options.NSinos;
image_properties.Niter = options.Niter;
image_properties.subsets = subsets;
image_properties.FOV_y = options.FOVa_y;
image_properties.FOV_x = options.FOVa_x;
image_properties.axial_FOV = options.axial_fov;
image_properties.raw_data = options.use_raw_data;
image_properties.name = options.name;
image_properties.machine_name = options.machine_name;
image_properties.n_time_steps = options.partitions;
image_properties.start_time = options.start;
image_properties.machine_rings = options.rings;
image_properties.detectors_per_ring = options.det_w_pseudo;
image_properties.bore_diameter = options.diameter;
image_properties.blocks_per_ring = options.blocks_per_ring;
image_properties.axial_blocks = options.linear_multip;
image_properties.crystals_per_block = options.cryst_per_block;
image_properties.attenuation = options.attenuation_correction;
image_properties.arc = options.arc_correction;
image_properties.total_time = options.tot_time;
image_properties.subset_type = options.subset_type;
image_properties.normalization = options.normalization_correction;
image_properties.randoms = options.randoms_correction;
image_properties.scatter = options.scatter_correction;
if isfield(options,'DOI')
    image_properties.DOI = options.DOI;
end
if options.corrections_during_reconstruction
    image_properties.correction_weighted_reconstruction = true;
else
    image_properties.correction_weighted_reconstruction = false;
end
% if isfield(options,'rekot')
%     image_properties.implementations = options.rekot;
% end
if options.acosem || options.COSEM_OSL == 1
    image_properties.h = options.h;
end
if options.ramla || options.BSREM
    image_properties.lambda_bsrem = options.lambda0;
end
if options.mramla || options.MBSREM
    image_properties.lambda_mbsrem = options.lam_mbsrem;
end
if options.rosem || options.ROSEM_MAP
    image_properties.lambda_rosem = options.lam_rosem;
end
if options.drama
    image_properties.lambda_drama = options.lam_drama;
end
if options.mramla || options.MBSREM
    image_properties.U = options.U;
end
if options.MRP
    if options.OSL_OSEM
        image_properties.beta_mrp_osem = options.beta_mrp_osem;
    end
    if options.OSL_MLEM
        image_properties.beta_mrp_mlem = options.beta_mrp_mlem;
    end
    if options.BSREM
        image_properties.beta_mrp_bsrem = options.beta_mrp_bsrem;
    end
    if options.MBSREM
        image_properties.beta_mrp_mbsrem = options.beta_mrp_mbsrem;
    end
    if options.ROSEM_MAP
        image_properties.beta_mrp_rosem = options.beta_mrp_rosem;
    end
    if options.RBI_OSL
        image_properties.beta_mrp_rbi = options.beta_mrp_rbi;
    end
    if any(options.COSEM_OSL)
        image_properties.beta_mrp_cosem = options.beta_mrp_cosem;
    end
end
if options.quad
    if options.OSL_OSEM
        image_properties.beta_quad_osem = options.beta_quad_osem;
    end
    if options.OSL_MLEM
        image_properties.beta_quad_mlem = options.beta_quad_mlem;
    end
    if options.BSREM
        image_properties.beta_quad_bsrem = options.beta_quad_bsrem;
    end
    if options.MBSREM
        image_properties.beta_quad_mbsrem = options.beta_quad_mbsrem;
    end
    if options.ROSEM_MAP
        image_properties.beta_quad_rosem = options.beta_quad_rosem;
    end
    if options.RBI_OSL
        image_properties.beta_quad_rbi = options.beta_quad_rbi;
    end
    if any(options.COSEM_OSL)
        image_properties.beta_quad_cosem = options.beta_quad_cosem;
    end
    image_properties.weights = options.weights;
    image_properties.quadratic_prior_weights = options.weights_quad;
end
if options.Huber
    if options.OSL_OSEM
        image_properties.beta_huber_osem = options.beta_huber_osem;
    end
    if options.OSL_MLEM
        image_properties.beta_huber_mlem = options.beta_huber_mlem;
    end
    if options.BSREM
        image_properties.beta_huber_bsrem = options.beta_huber_bsrem;
    end
    if options.MBSREM
        image_properties.beta_huber_mbsrem = options.beta_huber_mbsrem;
    end
    if options.ROSEM_MAP
        image_properties.beta_huber_rosem = options.beta_huber_rosem;
    end
    if options.RBI_OSL
        image_properties.beta_huber_rbi = options.beta_huber_rbi;
    end
    if any(options.COSEM_OSL)
        image_properties.beta_huber_cosem = options.beta_huber_cosem;
    end
    image_properties.weights_huber = options.weights_huber;
    image_properties.huber_delta = options.huber_delta;
end
if options.L
    if options.OSL_OSEM
        image_properties.beta_L_osem = options.beta_L_osem;
    end
    if options.OSL_MLEM
        image_properties.beta_L_mlem = options.beta_L_mlem;
    end
    if options.BSREM
        image_properties.beta_L_bsrem = options.beta_L_bsrem;
    end
    if options.MBSREM
        image_properties.beta_L_mbsrem = options.beta_L_mbsrem;
    end
    if options.ROSEM_MAP
        image_properties.beta_L_rosem = options.beta_L_rosem;
    end
    if options.RBI_OSL
        image_properties.beta_L_rbi = options.beta_L_rbi;
    end
    if any(options.COSEM_OSL)
        image_properties.beta_L_cosem = options.beta_L_cosem;
    end
    image_properties.L_weights = options.a_L;
end
if options.L || options.quad || options.weighted_mean || options.FMH || options.MRP
    image_properties.Ndx = options.Ndx;
    image_properties.Ndy = options.Ndy;
    image_properties.Ndz = options.Ndz;
end
if options.FMH
    image_properties.fmh_center_weight = options.fmh_center_weight;
    image_properties.fmh_weights = options.fmh_weights;
    if options.OSL_OSEM
        image_properties.beta_fmh_osem = options.beta_fmh_osem;
    end
    if options.OSL_MLEM
        image_properties.beta_fmh_mlem = options.beta_fmh_mlem;
    end
    if options.BSREM
        image_properties.beta_fmh_bsrem = options.beta_fmh_bsrem;
    end
    if options.MBSREM
        image_properties.beta_fmh_mbsrem = options.beta_fmh_mbsrem;
    end
    if options.ROSEM_MAP
        image_properties.beta_fmh_rosem = options.beta_fmh_rosem;
    end
    if options.RBI_OSL
        image_properties.beta_fmh_rbi = options.beta_fmh_rbi;
    end
    if any(options.COSEM_OSL)
        image_properties.beta_fmh_cosem = options.beta_fmh_cosem;
    end
end
if options.weighted_mean
    image_properties.weighted_mean_center_weight = options.weighted_center_weight;
    if options.OSL_OSEM
        image_properties.beta_weighted_osem = options.beta_weighted_osem;
    end
    if options.OSL_MLEM
        image_properties.beta_weighted_mlem = options.beta_weighted_mlem;
    end
    if options.BSREM
        image_properties.beta_weighted_bsrem = options.beta_weighted_bsrem;
    end
    if options.MBSREM
        image_properties.beta_weighted_mbsrem = options.beta_weighted_mbsrem;
    end
    if options.ROSEM_MAP
        image_properties.beta_weighted_rosem = options.beta_weighted_rosem;
    end
    if options.RBI_OSL
        image_properties.beta_weighted_rbi = options.beta_weighted_rbi;
    end
    if any(options.COSEM_OSL)
        image_properties.beta_weighted_cosem = options.beta_weighted_cosem;
    end
    image_properties.weighted_mean_weights = options.weighted_weights;
    image_properties.mean_type = options.mean_type;
end
if options.TV
    image_properties.TVsmoothing_beta = options.TVsmoothing;
    image_properties.TV_use_anatomical = options.TV_use_anatomical;
    if options.TV_use_anatomical
        image_properties.TVtype = options.TVtype;
        image_properties.TV_reference_image = options.TV_reference_image;
        image_properties.T_weighting_parameter = options.T;
        if options.TVtype == 3
            image_properties.C_original_image_weight = options.C;
        end
        image_properties.tau = options.tau;
    end
    if options.OSL_OSEM
        image_properties.beta_TV_osem = options.beta_TV_osem;
    end
    if options.OSL_MLEM
        image_properties.beta_TV_mlem = options.beta_TV_mlem;
    end
    if options.BSREM
        image_properties.beta_TV_bsrem = options.beta_TV_bsrem;
    end
    if options.MBSREM
        image_properties.beta_TV_mbsrem = options.beta_TV_mbsrem;
    end
    if options.ROSEM_MAP
        image_properties.beta_TV_rosem = options.beta_TV_rosem;
    end
    if options.RBI_OSL
        image_properties.beta_TV_rbi = options.beta_TV_rbi;
    end
    if any(options.COSEM_OSL)
        image_properties.beta_TV_cosem = options.beta_TV_cosem;
    end
end
if options.AD
    image_properties.TimeStepAD = options.TimeStepAD;
    image_properties.KAD = options.KAD;
    image_properties.NiterAD = options.NiterAD;
    if options.FluxType == 1
        image_properties.FluxTypeAD = 'exponential';
    else
        image_properties.FluxTypeAD = 'quadratic';
    end
    image_properties.DiffusionTypeAD = options.DiffusionType;
    if options.OSL_OSEM
        image_properties.beta_ad_osem = options.beta_ad_osem;
    end
    if options.OSL_MLEM
        image_properties.beta_ad_mlem = options.beta_ad_mlem;
    end
    if options.BSREM
        image_properties.beta_ad_bsrem = options.beta_ad_bsrem;
    end
    if options.MBSREM
        image_properties.beta_ad_mbsrem = options.beta_ad_mbsrem;
    end
    if options.ROSEM_MAP
        image_properties.beta_ad_rosem = options.beta_ad_rosem;
    end
    if options.RBI_OSL
        image_properties.beta_ad_rbi = options.beta_ad_rbi;
    end
    if any(options.COSEM_OSL)
        image_properties.beta_ad_cosem = options.beta_ad_cosem;
    end
end
if options.APLS
    image_properties.APLSsmoothing_beta = options.APLSsmoothing;
    image_properties.APLS_reference_image = options.APLS_reference_image;
    image_properties.eta = options.eta;
    if options.OSL_OSEM
        image_properties.beta_APLS_osem = options.beta_APLS_osem;
    end
    if options.OSL_MLEM
        image_properties.beta_APLS_mlem = options.beta_APLS_mlem;
    end
    if options.BSREM
        image_properties.beta_APLS_bsrem = options.beta_APLS_bsrem;
    end
    if options.MBSREM
        image_properties.beta_APLS_mbsrem = options.beta_APLS_mbsrem;
    end
    if options.ROSEM_MAP
        image_properties.beta_APLS_rosem = options.beta_APLS_rosem;
    end
    if options.RBI_OSL
        image_properties.beta_APLS_rbi = options.beta_APLS_rbi;
    end
    if any(options.COSEM_OSL)
        image_properties.beta_APLS_cosem = options.beta_APLS_cosem;
    end
end
if options.TGV
    image_properties.alphaTGV = options.alphaTGV;
    image_properties.betaTGV = options.betaTGV;
    image_properties.NiterTGV = options.NiterTGV;
    if options.OSL_OSEM
        image_properties.beta_TGV_osem = options.beta_TGV_osem;
    end
    if options.OSL_MLEM
        image_properties.beta_TGV_mlem = options.beta_TGV_mlem;
    end
    if options.BSREM
        image_properties.beta_TGV_bsrem = options.beta_TGV_bsrem;
    end
    if options.MBSREM
        image_properties.beta_TGV_mbsrem = options.beta_TGV_mbsrem;
    end
    if options.ROSEM_MAP
        image_properties.beta_TGV_rosem = options.beta_TGV_rosem;
    end
    if options.RBI_OSL
        image_properties.beta_TGV_rbi = options.beta_TGV_rbi;
    end
    if any(options.COSEM_OSL)
        image_properties.beta_TGV_cosem = options.beta_TGV_cosem;
    end
end
if options.NLM
    image_properties.Nlx = options.Nlx;
    image_properties.Nly = options.Nly;
    image_properties.Nlz = options.Nlz;
    image_properties.sigma = options.sigma;
    image_properties.NLM_use_anatomical = options.NLM_use_anatomical;
    image_properties.NLM_MRP = options.NLM_MRP;
    if options.OSL_OSEM
        image_properties.beta_NLM_osem = options.beta_NLM_osem;
    end
    if options.OSL_MLEM
        image_properties.beta_NLM_mlem = options.beta_NLM_mlem;
    end
    if options.BSREM
        image_properties.beta_NLM_bsrem = options.beta_NLM_bsrem;
    end
    if options.MBSREM
        image_properties.beta_NLM_mbsrem = options.beta_NLM_mbsrem;
    end
    if options.ROSEM_MAP
        image_properties.beta_NLM_rosem = options.beta_NLM_rosem;
    end
    if options.RBI_OSL
        image_properties.beta_NLM_rbi = options.beta_NLM_rbi;
    end
    if any(options.COSEM_OSL)
        image_properties.beta_NLM_cosem = options.beta_NLM_cosem;
    end
end

pz{end,1} = image_properties;
