function im_vectors = ACOSEM_coefficient(im_vectors, options, Nx, Ny, Nz, dx, dz, dy, bx, by, bz, z_det, x, y, yy, xx, NSinos, NSlices, size_x, ...
    zmax, norm_input, SinD, pituus, osa_iter, attenuation_correction, normalization_correction, randoms_correction, lor_a_input, ...
    xy_index_input, z_index_input, L_input, pseudot, det_per_ring, use_raw_data, epps, uu, dc_z, x_center, y_center, z_center, dec, bmin, ...
    bmax, Vmax, V, gaussK)
%ACOSEM_COEFFICIENT Computes the scaling coefficient for ACOSEM
%   This function computes the scaling coefficient for ACOSEM when using
%   implementation 4

if options.use_psf
    OSEM_apu = computeConvolution(im_vectors.OSEM_apu, options, Nx, Ny, Nz, gaussK);
else
    OSEM_apu = im_vectors.OSEM_apu;
end
no_norm_acosem = false;
if options.projector_type == 1
    [~, rhs_acosem] = projector_mex( Ny, Nx, Nz, dx, dz, by, bx, bz, z_det, x, y, dy, yy, xx , NSinos, NSlices, size_x, zmax, options.vaimennus, ...
        norm_input, SinD, pituus(osa_iter + 1) - pituus(osa_iter), attenuation_correction, normalization_correction, randoms_correction,...
        options.global_correction_factor, lor_a_input, xy_index_input, z_index_input, NSinos, L_input, pseudot, det_per_ring, options.verbose, ...
        (use_raw_data), uint32(1), epps, uu, OSEM_apu, uint32(options.projector_type), no_norm_acosem, options.precompute_lor, true, ...
        options.n_rays_transaxial, options.n_rays_axial, dc_z);
elseif options.projector_type == 2
    [~, rhs_acosem] = projector_mex( Ny, Nx, Nz, dx, dz, by, bx, bz, z_det, x, y, dy, yy, xx , NSinos, NSlices, size_x, zmax, options.vaimennus, ...
        norm_input, SinD, pituus(osa_iter + 1) - pituus(osa_iter), attenuation_correction, normalization_correction, randoms_correction,...
        options.global_correction_factor, lor_a_input, xy_index_input, z_index_input, NSinos, L_input, pseudot, det_per_ring, options.verbose, ...
        (use_raw_data), uint32(1), epps, uu, OSEM_apu, uint32(options.projector_type), no_norm_acosem, options.precompute_lor, true, options.tube_width_xy, ...
        x_center, y_center, z_center, options.tube_width_z, dec);
elseif options.projector_type == 3
    [~, rhs_acosem] = projector_mex( Ny, Nx, Nz, dx, dz, by, bx, bz, z_det, x, y, dy, yy, xx , NSinos, NSlices, size_x, zmax, options.vaimennus, ...
        norm_input, SinD, pituus(osa_iter + 1) - pituus(osa_iter), attenuation_correction, normalization_correction, randoms_correction,...
        options.global_correction_factor, lor_a_input, xy_index_input, z_index_input, NSinos, L_input, pseudot, det_per_ring, options.verbose, ...
        (use_raw_data), uint32(1), epps, uu, OSEM_apu, uint32(options.projector_type), no_norm_acosem, options.precompute_lor, true, ...
        x_center, y_center, z_center, dec, bmin, bmax, Vmax, V);
else
    error('Unsupported projector')
end
[im_vectors.OSEM_apu, ~] = ACOSEM_im(im_vectors.OSEM_apu, rhs_acosem, uu, [], [], [], [], [], [], []);
end

