function im_vectors = form_image_vectors(options, N)
%FORM_IMAGE_VECTORS This function simply forms the applicable image vectors
%for each reconstruction method
%
%
%
% Copyright (C) 2020 Ville-Veikko Wettenhovi
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

if options.save_iter
    Niter = options.Niter;
else
    Niter = 0;
end
if options.implementation ~= 2
    
    
    MLEM_bool = options.OSL_MLEM || options.MLEM;
    OS_bool = options.OSEM || options.ROSEM || options.RAMLA || options.OSL_OSEM || options.BSREM || options.ROSEM_MAP || options.RBI || options.DRAMA ...
    || options.COSEM || options.ECOSEM || options.ACOSEM || options.OSL_RBI || any(options.OSL_COSEM);
    
    if options.implementation == 4 && OS_bool
        im_vectors.OSEM_apu = ones(N, 1);
    end
    if options.implementation == 4 && MLEM_bool
        im_vectors.MLEM_apu = ones(N, 1);
    end
    if options.OSEM
        im_vectors.OSEM = ones(N,Niter + 1);
        im_vectors.OSEM(:,1) = options.x0(:);
        im_vectors.OSEM_apu = im_vectors.OSEM(:,1);
    end
    if options.MLEM
        im_vectors.MLEM = ones(N,Niter + 1);
        im_vectors.MLEM(:,1) = options.x0(:);
        im_vectors.MLEM_apu = im_vectors.MLEM(:,1);
    end
    if options.MRAMLA
        im_vectors.MRAMLA = ones(N,Niter + 1);
        im_vectors.MRAMLA(:,1) = options.x0(:);
        im_vectors.MRAMLA_apu = im_vectors.MRAMLA(:,1);
    end
    if options.RAMLA
        im_vectors.RAMLA = ones(N,Niter + 1);
        im_vectors.RAMLA(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.RAMLA_apu = im_vectors.RAMLA(:,1);
        end
    end
    if options.ROSEM
        im_vectors.ROSEM = ones(N,Niter + 1);
        im_vectors.ROSEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.ROSEM_apu = im_vectors.ROSEM(:,1);
        end
    end
    if options.RBI
        im_vectors.RBI = ones(N,Niter + 1);
        im_vectors.RBI(:,1) = options.x0(:);
        im_vectors.RBI_apu = im_vectors.RBI(:,1);
    end
    if options.DRAMA
        im_vectors.DRAMA = ones(N,Niter + 1);
        im_vectors.DRAMA(:,1) = options.x0(:);
        im_vectors.DRAMA_apu = im_vectors.DRAMA(:,1);
    end
    if options.COSEM
        im_vectors.COSEM = ones(N,Niter + 1);
        im_vectors.COSEM(:,1) = options.x0(:);
        im_vectors.COSEM_apu = im_vectors.COSEM(:,1);
    end
    if options.ECOSEM
        im_vectors.ECOSEM = ones(N,Niter + 1);
        im_vectors.ECOSEM(:,1) = options.x0(:);
        im_vectors.ECOSEM_apu = im_vectors.ECOSEM(:,1);
        if ~options.OSEM
            im_vectors.OSEM_apu = options.x0(:);
        end
        if ~options.COSEM
            im_vectors.COSEM_apu = options.x0(:);
        end
    end
    if options.ACOSEM
        im_vectors.ACOSEM = ones(N,Niter + 1);
        im_vectors.ACOSEM(:,1) = options.x0(:);
        im_vectors.ACOSEM_apu = im_vectors.ACOSEM(:,1);
    end
    
    if options.MRP && options.OSL_OSEM
        im_vectors.MRP_OSL = ones(N,Niter + 1);
        im_vectors.MRP_OSL(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.MRP_OSL_apu = im_vectors.MRP_OSL(:,1);
        end
    end
    if options.MRP && options.OSL_MLEM
        im_vectors.MRP_OSL_MLEM = ones(N,Niter + 1);
        im_vectors.MRP_MLEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.MRP_MLEM_apu = im_vectors.MRP_MLEM(:,1);
        end
    end
    if options.MRP && options.MBSREM
        im_vectors.MRP_MBSREM = ones(N,Niter + 1);
        im_vectors.MRP_MBSREM(:,1) = options.x0(:);
        im_vectors.MRP_MBSREM_apu = im_vectors.MRP_MBSREM(:,1);
    end
    if options.MRP && options.BSREM
        im_vectors.MRP_BSREM = ones(N,Niter + 1);
        im_vectors.MRP_BSREM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.MRP_BSREM_apu = im_vectors.MRP_BSREM(:,1);
        end
    end
    if options.MRP && options.ROSEM_MAP
        im_vectors.MRP_ROSEM = ones(N,Niter + 1);
        im_vectors.MRP_ROSEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.MRP_ROSEM_apu = im_vectors.MRP_ROSEM(:,1);
        end
    end
    if options.MRP && options.OSL_RBI
        im_vectors.MRP_RBI = ones(N,Niter + 1);
        im_vectors.MRP_RBI(:,1) = options.x0(:);
        im_vectors.MRP_RBI_apu = im_vectors.MRP_RBI(:,1);
    end
    if options.MRP && any(options.OSL_COSEM)
        im_vectors.MRP_COSEM = ones(N,Niter + 1);
        im_vectors.MRP_COSEM(:,1) = options.x0(:);
        im_vectors.MRP_COSEM_apu = im_vectors.MRP_COSEM(:,1);
    end
    
    if options.quad && options.OSL_OSEM
        im_vectors.Quad_OSL = ones(N,Niter + 1);
        im_vectors.Quad_OSL(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.Quad_OSL_apu = im_vectors.Quad_OSL(:,1);
        end
    end
    if options.quad && options.OSL_MLEM
        im_vectors.Quad_OSL_MLEM = ones(N,Niter + 1);
        im_vectors.Quad_MLEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.Quad_MLEM_apu = im_vectors.Quad_MLEM(:,1);
        end
    end
    if options.quad && options.MBSREM
        im_vectors.Quad_MBSREM = ones(N,Niter + 1);
        im_vectors.Quad_MBSREM(:,1) = options.x0(:);
        im_vectors.Quad_MBSREM_apu = im_vectors.Quad_MBSREM(:,1);
    end
    if options.quad && options.BSREM
        im_vectors.Quad_BSREM = ones(N,Niter + 1);
        im_vectors.Quad_BSREM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.Quad_BSREM_apu = im_vectors.Quad_BSREM(:,1);
        end
    end
    if options.quad && options.ROSEM_MAP
        im_vectors.Quad_ROSEM = ones(N,Niter + 1);
        im_vectors.Quad_ROSEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.Quad_ROSEM_apu = im_vectors.Quad_ROSEM(:,1);
        end
    end
    if options.quad && options.OSL_RBI
        im_vectors.Quad_RBI = ones(N,Niter + 1);
        im_vectors.Quad_RBI(:,1) = options.x0(:);
        im_vectors.Quad_RBI_apu = im_vectors.Quad_RBI(:,1);
    end
    if options.quad && any(options.OSL_COSEM)
        im_vectors.Quad_COSEM = ones(N,Niter + 1);
        im_vectors.Quad_COSEM(:,1) = options.x0(:);
        im_vectors.Quad_COSEM_apu = im_vectors.Quad_COSEM(:,1);
    end
    
    if options.Huber && options.OSL_OSEM
        im_vectors.Huber_OSL = ones(N,Niter + 1);
        im_vectors.Huber_OSL(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.Huber_OSL_apu = im_vectors.Huber_OSL(:,1);
        end
    end
    if options.Huber && options.OSL_MLEM
        im_vectors.Huber_OSL_MLEM = ones(N,Niter + 1);
        im_vectors.Huber_MLEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.Huber_MLEM_apu = im_vectors.Huber_MLEM(:,1);
        end
    end
    if options.Huber && options.MBSREM
        im_vectors.Huber_MBSREM = ones(N,Niter + 1);
        im_vectors.Huber_MBSREM(:,1) = options.x0(:);
        im_vectors.Huber_MBSREM_apu = im_vectors.Huber_MBSREM(:,1);
    end
    if options.Huber && options.BSREM
        im_vectors.Huber_BSREM = ones(N,Niter + 1);
        im_vectors.Huber_BSREM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.Huber_BSREM_apu = im_vectors.Huber_BSREM(:,1);
        end
    end
    if options.Huber && options.ROSEM_MAP
        im_vectors.Huber_ROSEM = ones(N,Niter + 1);
        im_vectors.Huber_ROSEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.Huber_ROSEM_apu = im_vectors.Huber_ROSEM(:,1);
        end
    end
    if options.Huber && options.OSL_RBI
        im_vectors.Huber_RBI = ones(N,Niter + 1);
        im_vectors.Huber_RBI(:,1) = options.x0(:);
        im_vectors.Huber_RBI_apu = im_vectors.Huber_RBI(:,1);
    end
    if options.Huber && any(options.OSL_COSEM)
        im_vectors.Huber_COSEM = ones(N,Niter + 1);
        im_vectors.Huber_COSEM(:,1) = options.x0(:);
        im_vectors.Huber_COSEM_apu = im_vectors.Huber_COSEM(:,1);
    end
    
    if options.L && options.OSL_OSEM
        im_vectors.L_OSL = ones(N,Niter + 1);
        im_vectors.L_OSL(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.L_OSL_apu = im_vectors.L_OSL(:,1);
        end
    end
    if options.L && options.OSL_MLEM
        im_vectors.L_OSL_MLEM = ones(N,Niter + 1);
        im_vectors.L_MLEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.L_MLEM_apu = im_vectors.L_MLEM(:,1);
        end
    end
    if options.L && options.MBSREM
        im_vectors.L_MBSREM = ones(N,Niter + 1);
        im_vectors.L_MBSREM(:,1) = options.x0(:);
        im_vectors.L_MBSREM_apu = im_vectors.L_MBSREM(:,1);
    end
    if options.L && options.BSREM
        im_vectors.L_BSREM = ones(N,Niter + 1);
        im_vectors.L_BSREM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.L_BSREM_apu = im_vectors.L_BSREM(:,1);
        end
    end
    if options.L && options.ROSEM_MAP
        im_vectors.L_ROSEM = ones(N,Niter + 1);
        im_vectors.L_ROSEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.L_ROSEM_apu = im_vectors.L_ROSEM(:,1);
        end
    end
    if options.L && options.OSL_RBI
        im_vectors.L_RBI = ones(N,Niter + 1);
        im_vectors.L_RBI(:,1) = options.x0(:);
        im_vectors.L_RBI_apu = im_vectors.L_RBI(:,1);
    end
    if options.L && any(options.OSL_COSEM)
        im_vectors.L_COSEM = ones(N,Niter + 1);
        im_vectors.L_COSEM(:,1) = options.x0(:);
        im_vectors.L_COSEM_apu = im_vectors.L_COSEM(:,1);
    end
    
    if options.FMH && options.OSL_OSEM
        im_vectors.FMH_OSL = ones(N,Niter + 1);
        im_vectors.FMH_OSL(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.FMH_OSL_apu = im_vectors.FMH_OSL(:,1);
        end
    end
    if options.FMH && options.OSL_MLEM
        im_vectors.FMH_OSL_MLEM = ones(N,Niter + 1);
        im_vectors.FMH_MLEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.FMH_MLEM_apu = im_vectors.FMH_MLEM(:,1);
        end
    end
    if options.FMH && options.MBSREM
        im_vectors.FMH_MBSREM = ones(N,Niter + 1);
        im_vectors.FMH_MBSREM(:,1) = options.x0(:);
        im_vectors.FMH_MBSREM_apu = im_vectors.FMH_MBSREM(:,1);
    end
    if options.FMH && options.BSREM
        im_vectors.FMH_BSREM = ones(N,Niter + 1);
        im_vectors.FMH_BSREM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.FMH_BSREM_apu = im_vectors.FMH_BSREM(:,1);
        end
    end
    if options.FMH && options.ROSEM_MAP
        im_vectors.FMH_ROSEM = ones(N,Niter + 1);
        im_vectors.FMH_ROSEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.FMH_ROSEM_apu = im_vectors.FMH_ROSEM(:,1);
        end
    end
    if options.FMH && options.OSL_RBI
        im_vectors.FMH_RBI = ones(N,Niter + 1);
        im_vectors.FMH_RBI(:,1) = options.x0(:);
        im_vectors.FMH_RBI_apu = im_vectors.FMH_RBI(:,1);
    end
    if options.FMH && any(options.OSL_COSEM)
        im_vectors.FMH_COSEM = ones(N,Niter + 1);
        im_vectors.FMH_COSEM(:,1) = options.x0(:);
        im_vectors.FMH_COSEM_apu = im_vectors.FMH_COSEM(:,1);
    end
    
    if options.weighted_mean && options.OSL_OSEM
        im_vectors.Weighted_OSL = ones(N,Niter + 1);
        im_vectors.Weighted_OSL(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.Weighted_OSL_apu = im_vectors.Weighted_OSL(:,1);
        end
    end
    if options.weighted_mean && options.OSL_MLEM
        im_vectors.Weighted_OSL_MLEM = ones(N,Niter + 1);
        im_vectors.Weighted_MLEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.Weighted_MLEM_apu = im_vectors.Weighted_MLEM(:,1);
        end
    end
    if options.weighted_mean && options.MBSREM
        im_vectors.Weighted_MBSREM = ones(N,Niter + 1);
        im_vectors.Weighted_MBSREM(:,1) = options.x0(:);
        im_vectors.Weighted_MBSREM_apu = im_vectors.Weighted_MBSREM(:,1);
    end
    if options.weighted_mean && options.BSREM
        im_vectors.Weighted_BSREM = ones(N,Niter + 1);
        im_vectors.Weighted_BSREM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.Weighted_BSREM_apu = im_vectors.Weighted_BSREM(:,1);
        end
    end
    if options.weighted_mean && options.ROSEM_MAP
        im_vectors.Weighted_ROSEM = ones(N,Niter + 1);
        im_vectors.Weighted_ROSEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.Weighted_ROSEM_apu = im_vectors.Weighted_ROSEM(:,1);
        end
    end
    if options.weighted_mean && options.OSL_RBI
        im_vectors.Weighted_RBI = ones(N,Niter + 1);
        im_vectors.Weighted_RBI(:,1) = options.x0(:);
        im_vectors.Weighted_RBI_apu = im_vectors.Weighted_RBI(:,1);
    end
    if options.weighted_mean && any(options.OSL_COSEM)
        im_vectors.Weighted_COSEM = ones(N,Niter + 1);
        im_vectors.Weighted_COSEM(:,1) = options.x0(:);
        im_vectors.Weighted_COSEM_apu = im_vectors.Weighted_COSEM(:,1);
    end
    
    if options.TV && options.OSL_OSEM
        im_vectors.TV_OSL = ones(N,Niter + 1);
        im_vectors.TV_OSL(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.TV_OSL_apu = im_vectors.TV_OSL(:,1);
        end
    end
    if options.TV && options.OSL_MLEM
        im_vectors.TV_OSL_MLEM = ones(N,Niter + 1);
        im_vectors.TV_MLEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.TV_MLEM_apu = im_vectors.TV_MLEM(:,1);
        end
    end
    if options.TV && options.MBSREM
        im_vectors.TV_MBSREM = ones(N,Niter + 1);
        im_vectors.TV_MBSREM(:,1) = options.x0(:);
        im_vectors.TV_MBSREM_apu = im_vectors.TV_MBSREM(:,1);
    end
    if options.TV && options.BSREM
        im_vectors.TV_BSREM = ones(N,Niter + 1);
        im_vectors.TV_BSREM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.TV_BSREM_apu = im_vectors.TV_BSREM(:,1);
        end
    end
    if options.TV && options.ROSEM_MAP
        im_vectors.TV_ROSEM = ones(N,Niter + 1);
        im_vectors.TV_ROSEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.TV_ROSEM_apu = im_vectors.TV_ROSEM(:,1);
        end
    end
    if options.TV && options.OSL_RBI
        im_vectors.TV_RBI = ones(N,Niter + 1);
        im_vectors.TV_RBI(:,1) = options.x0(:);
        im_vectors.TV_RBI_apu = im_vectors.TV_RBI(:,1);
    end
    if options.TV && any(options.OSL_COSEM)
        im_vectors.TV_COSEM = ones(N,Niter + 1);
        im_vectors.TV_COSEM(:,1) = options.x0(:);
        im_vectors.TV_COSEM_apu = im_vectors.TV_COSEM(:,1);
    end
    
    if options.AD && options.OSL_OSEM
        im_vectors.AD_OSL = ones(N,Niter + 1);
        im_vectors.AD_OSL(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.AD_OSL_apu = im_vectors.AD_OSL(:,1);
        end
    end
    if options.AD && options.OSL_MLEM
        im_vectors.AD_OSL_MLEM = ones(N,Niter + 1);
        im_vectors.AD_MLEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.AD_MLEM_apu = im_vectors.AD_MLEM(:,1);
        end
    end
    if options.AD && options.MBSREM
        im_vectors.AD_MBSREM = ones(N,Niter + 1);
        im_vectors.AD_MBSREM(:,1) = options.x0(:);
        im_vectors.AD_MBSREM_apu = im_vectors.AD_MBSREM(:,1);
    end
    if options.AD && options.BSREM
        im_vectors.AD_BSREM = ones(N,Niter + 1);
        im_vectors.AD_BSREM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.AD_BSREM_apu = im_vectors.AD_BSREM(:,1);
        end
    end
    if options.AD && options.ROSEM_MAP
        im_vectors.AD_ROSEM = ones(N,Niter + 1);
        im_vectors.AD_ROSEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.AD_ROSEM_apu = im_vectors.AD_ROSEM(:,1);
        end
    end
    if options.AD && options.OSL_RBI
        im_vectors.AD_RBI = ones(N,Niter + 1);
        im_vectors.AD_RBI(:,1) = options.x0(:);
        im_vectors.AD_RBI_apu = im_vectors.AD_RBI(:,1);
    end
    if options.AD && any(options.OSL_COSEM)
        im_vectors.AD_COSEM = ones(N,Niter + 1);
        im_vectors.AD_COSEM(:,1) = options.x0(:);
        im_vectors.AD_COSEM_apu = im_vectors.AD_COSEM(:,1);
    end
    
    if options.APLS && options.OSL_OSEM
        im_vectors.APLS_OSL = ones(N,Niter + 1);
        im_vectors.APLS_OSL(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.APLS_OSL_apu = im_vectors.APLS_OSL(:,1);
        end
    end
    if options.APLS && options.OSL_MLEM
        im_vectors.APLS_OSL_MLEM = ones(N,Niter + 1);
        im_vectors.APLS_MLEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.APLS_MLEM_apu = im_vectors.APLS_MLEM(:,1);
        end
    end
    if options.APLS && options.MBSREM
        im_vectors.APLS_MBSREM = ones(N,Niter + 1);
        im_vectors.APLS_MBSREM(:,1) = options.x0(:);
        im_vectors.APLS_MBSREM_apu = im_vectors.APLS_MBSREM(:,1);
    end
    if options.APLS && options.BSREM
        im_vectors.APLS_BSREM = ones(N,Niter + 1);
        im_vectors.APLS_BSREM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.APLS_BSREM_apu = im_vectors.APLS_BSREM(:,1);
        end
    end
    if options.APLS && options.ROSEM_MAP
        im_vectors.APLS_ROSEM = ones(N,Niter + 1);
        im_vectors.APLS_ROSEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.APLS_ROSEM_apu = im_vectors.APLS_ROSEM(:,1);
        end
    end
    if options.APLS && options.OSL_RBI
        im_vectors.APLS_RBI = ones(N,Niter + 1);
        im_vectors.APLS_RBI(:,1) = options.x0(:);
        im_vectors.APLS_RBI_apu = im_vectors.APLS_RBI(:,1);
    end
    if options.APLS && any(options.OSL_COSEM)
        im_vectors.APLS_COSEM = ones(N,Niter + 1);
        im_vectors.APLS_COSEM(:,1) = options.x0(:);
        im_vectors.APLS_COSEM_apu = im_vectors.APLS_COSEM(:,1);
    end
    
    if options.TGV && options.OSL_OSEM
        im_vectors.TGV_OSL = ones(N,Niter + 1);
        im_vectors.TGV_OSL(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.TGV_OSL_apu = im_vectors.TGV_OSL(:,1);
        end
    end
    if options.TGV && options.OSL_MLEM
        im_vectors.TGV_OSL_MLEM = ones(N,Niter + 1);
        im_vectors.TGV_MLEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.TGV_MLEM_apu = im_vectors.TGV_MLEM(:,1);
        end
    end
    if options.TGV && options.MBSREM
        im_vectors.TGV_MBSREM = ones(N,Niter + 1);
        im_vectors.TGV_MBSREM(:,1) = options.x0(:);
        im_vectors.TGV_MBSREM_apu = im_vectors.TGV_MBSREM(:,1);
    end
    if options.TGV && options.BSREM
        im_vectors.TGV_BSREM = ones(N,Niter + 1);
        im_vectors.TGV_BSREM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.TGV_BSREM_apu = im_vectors.TGV_BSREM(:,1);
        end
    end
    if options.TGV && options.ROSEM_MAP
        im_vectors.TGV_ROSEM = ones(N,Niter + 1);
        im_vectors.TGV_ROSEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.TGV_ROSEM_apu = im_vectors.TGV_ROSEM(:,1);
        end
    end
    if options.TGV && options.OSL_RBI
        im_vectors.TGV_RBI = ones(N,Niter + 1);
        im_vectors.TGV_RBI(:,1) = options.x0(:);
        im_vectors.TGV_RBI_apu = im_vectors.TGV_RBI(:,1);
    end
    if options.TGV && any(options.OSL_COSEM)
        im_vectors.TGV_COSEM = ones(N,Niter + 1);
        im_vectors.TGV_COSEM(:,1) = options.x0(:);
        im_vectors.TGV_COSEM_apu = im_vectors.TGV_COSEM(:,1);
    end
    
    if options.NLM && options.OSL_OSEM
        im_vectors.NLM_OSL = ones(N,Niter + 1);
        im_vectors.NLM_OSL(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.NLM_OSL_apu = im_vectors.NLM_OSL(:,1);
        end
    end
    if options.NLM && options.OSL_MLEM
        im_vectors.NLM_OSL_MLEM = ones(N,Niter + 1);
        im_vectors.NLM_MLEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.NLM_MLEM_apu = im_vectors.NLM_MLEM(:,1);
        end
    end
    if options.NLM && options.MBSREM
        im_vectors.NLM_MBSREM = ones(N,Niter + 1);
        im_vectors.NLM_MBSREM(:,1) = options.x0(:);
        im_vectors.NLM_MBSREM_apu = im_vectors.NLM_MBSREM(:,1);
    end
    if options.NLM && options.BSREM
        im_vectors.NLM_BSREM = ones(N,Niter + 1);
        im_vectors.NLM_BSREM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.NLM_BSREM_apu = im_vectors.NLM_BSREM(:,1);
        end
    end
    if options.NLM && options.ROSEM_MAP
        im_vectors.NLM_ROSEM = ones(N,Niter + 1);
        im_vectors.NLM_ROSEM(:,1) = options.x0(:);
        if ~(options.implementation == 4)
            im_vectors.NLM_ROSEM_apu = im_vectors.NLM_ROSEM(:,1);
        end
    end
    if options.NLM && options.OSL_RBI
        im_vectors.NLM_RBI = ones(N,Niter + 1);
        im_vectors.NLM_RBI(:,1) = options.x0(:);
        im_vectors.NLM_RBI_apu = im_vectors.NLM_RBI(:,1);
    end
    if options.NLM && any(options.OSL_COSEM)
        im_vectors.NLM_COSEM = ones(N,Niter + 1);
        im_vectors.NLM_COSEM(:,1) = options.x0(:);
        im_vectors.NLM_COSEM_apu = im_vectors.NLM_COSEM(:,1);
    end
    if options.custom && options.OSL_OSEM
        im_vectors.custom_OSL = ones(N,Niter + 1,'double');
        im_vectors.custom_OSL(:,1) = options.x0(:);
        im_vectors.custom_OSL_apu = im_vectors.custom_OSL(:,1);
    end
    if options.custom && options.OSL_MLEM
        im_vectors.custom_OSL_MLEM = ones(N,Niter + 1,'double');
        im_vectors.custom_MLEM(:,1) = options.x0(:);
        im_vectors.custom_MLEM_apu = im_vectors.custom_MLEM(:,1);
    end
    if options.custom && options.MBSREM
        im_vectors.custom_MBSREM = ones(N,Niter + 1,'double');
        im_vectors.custom_MBSREM(:,1) = options.x0(:);
        im_vectors.custom_MBSREM_apu = im_vectors.custom_MBSREM(:,1);
    end
    if options.custom && options.BSREM
        im_vectors.custom_BSREM = ones(N,Niter + 1,'double');
        im_vectors.custom_BSREM(:,1) = options.x0(:);
        im_vectors.custom_BSREM_apu = im_vectors.custom_BSREM(:,1);
    end
    if options.custom && options.ROSEM_MAP
        im_vectors.custom_ROSEM = ones(N,Niter + 1,'double');
        im_vectors.custom_ROSEM(:,1) = options.x0(:);
        im_vectors.custom_ROSEM_apu = im_vectors.custom_ROSEM(:,1);
    end
    if options.custom && options.OSL_RBI
        im_vectors.custom_RBI = ones(N,Niter + 1,'double');
        im_vectors.custom_RBI(:,1) = options.x0(:);
        im_vectors.custom_RBI_apu = im_vectors.custom_RBI(:,1);
    end
    if options.custom && any(options.OSL_COSEM)
        im_vectors.custom_COSEM = ones(N,Niter + 1,'double');
        im_vectors.custom_COSEM(:,1) = options.x0(:);
        im_vectors.custom_COSEM_apu = im_vectors.custom_COSEM(:,1);
    end
    
else
    if options.OSEM
        im_vectors.OSEM = ones(N,Niter + 1,'single');
        im_vectors.OSEM(:,1) = options.x0(:);
        im_vectors.OSEM_apu = im_vectors.OSEM(:,1);
    end
    if options.MLEM
        im_vectors.MLEM = ones(N,Niter + 1,'single');
        im_vectors.MLEM(:,1) = options.x0(:);
        im_vectors.MLEM_apu = im_vectors.MLEM(:,1);
    end
    if options.MRAMLA
        im_vectors.MRAMLA = ones(N,Niter + 1,'single');
        im_vectors.MRAMLA(:,1) = options.x0(:);
        im_vectors.MRAMLA_apu = im_vectors.MRAMLA(:,1);
    end
    if options.RAMLA
        im_vectors.RAMLA = ones(N,Niter + 1,'single');
        im_vectors.RAMLA(:,1) = options.x0(:);
        im_vectors.RAMLA_apu = im_vectors.RAMLA(:,1);
    end
    if options.ROSEM
        im_vectors.ROSEM = ones(N,Niter + 1,'single');
        im_vectors.ROSEM(:,1) = options.x0(:);
        im_vectors.ROSEM_apu = im_vectors.ROSEM(:,1);
    end
    if options.RBI
        im_vectors.RBI = ones(N,Niter + 1,'single');
        im_vectors.RBI(:,1) = options.x0(:);
        im_vectors.RBI_apu = im_vectors.RBI(:,1);
    end
    if options.DRAMA
        im_vectors.DRAMA = ones(N,Niter + 1,'single');
        im_vectors.DRAMA(:,1) = options.x0(:);
        im_vectors.DRAMA_apu = im_vectors.DRAMA(:,1);
    end
    if options.COSEM
        im_vectors.COSEM = ones(N,Niter + 1,'single');
        im_vectors.COSEM(:,1) = options.x0(:);
        im_vectors.COSEM_apu = im_vectors.COSEM(:,1);
    end
    if options.ECOSEM
        im_vectors.ECOSEM = ones(N,Niter + 1,'single');
        im_vectors.ECOSEM(:,1) = options.x0(:);
        im_vectors.ECOSEM_apu = im_vectors.ECOSEM(:,1);
        if ~options.OSEM
            im_vectors.OSEM_apu = options.x0(:);
        end
        if ~options.COSEM
            im_vectors.COSEM_apu = options.x0(:);
        end
    end
    if options.ACOSEM
        im_vectors.ACOSEM = ones(N,Niter + 1,'single');
        im_vectors.ACOSEM(:,1) = options.x0(:);
        im_vectors.ACOSEM_apu = im_vectors.ACOSEM(:,1);
    end
    
    if options.MRP && options.OSL_OSEM
        im_vectors.MRP_OSL = ones(N,Niter + 1,'single');
        im_vectors.MRP_OSL(:,1) = options.x0(:);
        im_vectors.MRP_OSL_apu = im_vectors.MRP_OSL(:,1);
    end
    if options.MRP && options.OSL_MLEM
        im_vectors.MRP_OSL_MLEM = ones(N,Niter + 1,'single');
        im_vectors.MRP_MLEM(:,1) = options.x0(:);
        im_vectors.MRP_MLEM_apu = im_vectors.MRP_MLEM(:,1);
    end
    if options.MRP && options.MBSREM
        im_vectors.MRP_MBSREM = ones(N,Niter + 1,'single');
        im_vectors.MRP_MBSREM(:,1) = options.x0(:);
        im_vectors.MRP_MBSREM_apu = im_vectors.MRP_MBSREM(:,1);
    end
    if options.MRP && options.BSREM
        im_vectors.MRP_BSREM = ones(N,Niter + 1,'single');
        im_vectors.MRP_BSREM(:,1) = options.x0(:);
        im_vectors.MRP_BSREM_apu = im_vectors.MRP_BSREM(:,1);
    end
    if options.MRP && options.ROSEM_MAP
        im_vectors.MRP_ROSEM = ones(N,Niter + 1,'single');
        im_vectors.MRP_ROSEM(:,1) = options.x0(:);
        im_vectors.MRP_ROSEM_apu = im_vectors.MRP_ROSEM(:,1);
    end
    if options.MRP && options.OSL_RBI
        im_vectors.MRP_RBI = ones(N,Niter + 1,'single');
        im_vectors.MRP_RBI(:,1) = options.x0(:);
        im_vectors.MRP_RBI_apu = im_vectors.MRP_RBI(:,1);
    end
    if options.MRP && any(options.OSL_COSEM)
        im_vectors.MRP_COSEM = ones(N,Niter + 1,'single');
        im_vectors.MRP_COSEM(:,1) = options.x0(:);
        im_vectors.MRP_COSEM_apu = im_vectors.MRP_COSEM(:,1);
    end
    
    if options.quad && options.OSL_OSEM
        im_vectors.Quad_OSL = ones(N,Niter + 1,'single');
        im_vectors.Quad_OSL(:,1) = options.x0(:);
        im_vectors.Quad_OSL_apu = im_vectors.Quad_OSL(:,1);
    end
    if options.quad && options.OSL_MLEM
        im_vectors.Quad_OSL_MLEM = ones(N,Niter + 1,'single');
        im_vectors.Quad_MLEM(:,1) = options.x0(:);
        im_vectors.Quad_MLEM_apu = im_vectors.Quad_MLEM(:,1);
    end
    if options.quad && options.MBSREM
        im_vectors.Quad_MBSREM = ones(N,Niter + 1,'single');
        im_vectors.Quad_MBSREM(:,1) = options.x0(:);
        im_vectors.Quad_MBSREM_apu = im_vectors.Quad_MBSREM(:,1);
    end
    if options.quad && options.BSREM
        im_vectors.Quad_BSREM = ones(N,Niter + 1,'single');
        im_vectors.Quad_BSREM(:,1) = options.x0(:);
        im_vectors.Quad_BSREM_apu = im_vectors.Quad_BSREM(:,1);
    end
    if options.quad && options.ROSEM_MAP
        im_vectors.Quad_ROSEM = ones(N,Niter + 1,'single');
        im_vectors.Quad_ROSEM(:,1) = options.x0(:);
        im_vectors.Quad_ROSEM_apu = im_vectors.Quad_ROSEM(:,1);
    end
    if options.quad && options.OSL_RBI
        im_vectors.Quad_RBI = ones(N,Niter + 1,'single');
        im_vectors.Quad_RBI(:,1) = options.x0(:);
        im_vectors.Quad_RBI_apu = im_vectors.Quad_RBI(:,1);
    end
    if options.quad && any(options.OSL_COSEM)
        im_vectors.Quad_COSEM = ones(N,Niter + 1,'single');
        im_vectors.Quad_COSEM(:,1) = options.x0(:);
        im_vectors.Quad_COSEM_apu = im_vectors.Quad_COSEM(:,1);
    end
    
    if options.L && options.OSL_OSEM
        im_vectors.L_OSL = ones(N,Niter + 1,'single');
        im_vectors.L_OSL(:,1) = options.x0(:);
        im_vectors.L_OSL_apu = im_vectors.L_OSL(:,1);
    end
    if options.L && options.OSL_MLEM
        im_vectors.L_OSL_MLEM = ones(N,Niter + 1,'single');
        im_vectors.L_MLEM(:,1) = options.x0(:);
        im_vectors.L_MLEM_apu = im_vectors.L_MLEM(:,1);
    end
    if options.L && options.MBSREM
        im_vectors.L_MBSREM = ones(N,Niter + 1,'single');
        im_vectors.L_MBSREM(:,1) = options.x0(:);
        im_vectors.L_MBSREM_apu = im_vectors.L_MBSREM(:,1);
    end
    if options.L && options.BSREM
        im_vectors.L_BSREM = ones(N,Niter + 1,'single');
        im_vectors.L_BSREM(:,1) = options.x0(:);
        im_vectors.L_BSREM_apu = im_vectors.L_BSREM(:,1);
    end
    if options.L && options.ROSEM_MAP
        im_vectors.L_ROSEM = ones(N,Niter + 1,'single');
        im_vectors.L_ROSEM(:,1) = options.x0(:);
        im_vectors.L_ROSEM_apu = im_vectors.L_ROSEM(:,1);
    end
    if options.L && options.OSL_RBI
        im_vectors.L_RBI = ones(N,Niter + 1,'single');
        im_vectors.L_RBI(:,1) = options.x0(:);
        im_vectors.L_RBI_apu = im_vectors.L_RBI(:,1);
    end
    if options.L && any(options.OSL_COSEM)
        im_vectors.L_COSEM = ones(N,Niter + 1,'single');
        im_vectors.L_COSEM(:,1) = options.x0(:);
        im_vectors.L_COSEM_apu = im_vectors.L_COSEM(:,1);
    end
    
    if options.FMH && options.OSL_OSEM
        im_vectors.FMH_OSL = ones(N,Niter + 1,'single');
        im_vectors.FMH_OSL(:,1) = options.x0(:);
        im_vectors.FMH_OSL_apu = im_vectors.FMH_OSL(:,1);
    end
    if options.FMH && options.OSL_MLEM
        im_vectors.FMH_OSL_MLEM = ones(N,Niter + 1,'single');
        im_vectors.FMH_MLEM(:,1) = options.x0(:);
        im_vectors.FMH_MLEM_apu = im_vectors.FMH_MLEM(:,1);
    end
    if options.FMH && options.MBSREM
        im_vectors.FMH_MBSREM = ones(N,Niter + 1,'single');
        im_vectors.FMH_MBSREM(:,1) = options.x0(:);
        im_vectors.FMH_MBSREM_apu = im_vectors.FMH_MBSREM(:,1);
    end
    if options.FMH && options.BSREM
        im_vectors.FMH_BSREM = ones(N,Niter + 1,'single');
        im_vectors.FMH_BSREM(:,1) = options.x0(:);
        im_vectors.FMH_BSREM_apu = im_vectors.FMH_BSREM(:,1);
    end
    if options.FMH && options.ROSEM_MAP
        im_vectors.FMH_ROSEM = ones(N,Niter + 1,'single');
        im_vectors.FMH_ROSEM(:,1) = options.x0(:);
        im_vectors.FMH_ROSEM_apu = im_vectors.FMH_ROSEM(:,1);
    end
    if options.FMH && options.OSL_RBI
        im_vectors.FMH_RBI = ones(N,Niter + 1,'single');
        im_vectors.FMH_RBI(:,1) = options.x0(:);
        im_vectors.FMH_RBI_apu = im_vectors.FMH_RBI(:,1);
    end
    if options.FMH && any(options.OSL_COSEM)
        im_vectors.FMH_COSEM = ones(N,Niter + 1,'single');
        im_vectors.FMH_COSEM(:,1) = options.x0(:);
        im_vectors.FMH_COSEM_apu = im_vectors.FMH_COSEM(:,1);
    end
    
    if options.weighted_mean && options.OSL_OSEM
        im_vectors.Weighted_OSL = ones(N,Niter + 1,'single');
        im_vectors.Weighted_OSL(:,1) = options.x0(:);
        im_vectors.Weighted_OSL_apu = im_vectors.Weighted_OSL(:,1);
    end
    if options.weighted_mean && options.OSL_MLEM
        im_vectors.Weighted_OSL_MLEM = ones(N,Niter + 1,'single');
        im_vectors.Weighted_MLEM(:,1) = options.x0(:);
        im_vectors.Weighted_MLEM_apu = im_vectors.Weighted_MLEM(:,1);
    end
    if options.weighted_mean && options.MBSREM
        im_vectors.Weighted_MBSREM = ones(N,Niter + 1,'single');
        im_vectors.Weighted_MBSREM(:,1) = options.x0(:);
        im_vectors.Weighted_MBSREM_apu = im_vectors.Weighted_MBSREM(:,1);
    end
    if options.weighted_mean && options.BSREM
        im_vectors.Weighted_BSREM = ones(N,Niter + 1,'single');
        im_vectors.Weighted_BSREM(:,1) = options.x0(:);
        im_vectors.Weighted_BSREM_apu = im_vectors.Weighted_BSREM(:,1);
    end
    if options.weighted_mean && options.ROSEM_MAP
        im_vectors.Weighted_ROSEM = ones(N,Niter + 1,'single');
        im_vectors.Weighted_ROSEM(:,1) = options.x0(:);
        im_vectors.Weighted_ROSEM_apu = im_vectors.Weighted_ROSEM(:,1);
    end
    if options.weighted_mean && options.OSL_RBI
        im_vectors.Weighted_RBI = ones(N,Niter + 1,'single');
        im_vectors.Weighted_RBI(:,1) = options.x0(:);
        im_vectors.Weighted_RBI_apu = im_vectors.Weighted_RBI(:,1);
    end
    if options.weighted_mean && any(options.OSL_COSEM)
        im_vectors.Weighted_COSEM = ones(N,Niter + 1,'single');
        im_vectors.Weighted_COSEM(:,1) = options.x0(:);
        im_vectors.Weighted_COSEM_apu = im_vectors.Weighted_COSEM(:,1);
    end
    
    if options.TV && options.OSL_OSEM
        im_vectors.TV_OSL = ones(N,Niter + 1,'single');
        im_vectors.TV_OSL(:,1) = options.x0(:);
        im_vectors.TV_OSL_apu = im_vectors.TV_OSL(:,1);
    end
    if options.TV && options.OSL_MLEM
        im_vectors.TV_OSL_MLEM = ones(N,Niter + 1,'single');
        im_vectors.TV_MLEM(:,1) = options.x0(:);
        im_vectors.TV_MLEM_apu = im_vectors.TV_MLEM(:,1);
    end
    if options.TV && options.MBSREM
        im_vectors.TV_MBSREM = ones(N,Niter + 1,'single');
        im_vectors.TV_MBSREM(:,1) = options.x0(:);
        im_vectors.TV_MBSREM_apu = im_vectors.TV_MBSREM(:,1);
    end
    if options.TV && options.BSREM
        im_vectors.TV_BSREM = ones(N,Niter + 1,'single');
        im_vectors.TV_BSREM(:,1) = options.x0(:);
        im_vectors.TV_BSREM_apu = im_vectors.TV_BSREM(:,1);
    end
    if options.TV && options.ROSEM_MAP
        im_vectors.TV_ROSEM = ones(N,Niter + 1,'single');
        im_vectors.TV_ROSEM(:,1) = options.x0(:);
        im_vectors.TV_ROSEM_apu = im_vectors.TV_ROSEM(:,1);
    end
    if options.TV && options.OSL_RBI
        im_vectors.TV_RBI = ones(N,Niter + 1,'single');
        im_vectors.TV_RBI(:,1) = options.x0(:);
        im_vectors.TV_RBI_apu = im_vectors.TV_RBI(:,1);
    end
    if options.TV && any(options.OSL_COSEM)
        im_vectors.TV_COSEM = ones(N,Niter + 1,'single');
        im_vectors.TV_COSEM(:,1) = options.x0(:);
        im_vectors.TV_COSEM_apu = im_vectors.TV_COSEM(:,1);
    end
    
    if options.AD && options.OSL_OSEM
        im_vectors.AD_OSL = ones(N,Niter + 1,'single');
        im_vectors.AD_OSL(:,1) = options.x0(:);
        im_vectors.AD_OSL_apu = im_vectors.AD_OSL(:,1);
    end
    if options.AD && options.OSL_MLEM
        im_vectors.AD_OSL_MLEM = ones(N,Niter + 1,'single');
        im_vectors.AD_MLEM(:,1) = options.x0(:);
        im_vectors.AD_MLEM_apu = im_vectors.AD_MLEM(:,1);
    end
    if options.AD && options.MBSREM
        im_vectors.AD_MBSREM = ones(N,Niter + 1,'single');
        im_vectors.AD_MBSREM(:,1) = options.x0(:);
        im_vectors.AD_MBSREM_apu = im_vectors.AD_MBSREM(:,1);
    end
    if options.AD && options.BSREM
        im_vectors.AD_BSREM = ones(N,Niter + 1,'single');
        im_vectors.AD_BSREM(:,1) = options.x0(:);
        im_vectors.AD_BSREM_apu = im_vectors.AD_BSREM(:,1);
    end
    if options.AD && options.ROSEM_MAP
        im_vectors.AD_ROSEM = ones(N,Niter + 1,'single');
        im_vectors.AD_ROSEM(:,1) = options.x0(:);
        im_vectors.AD_ROSEM_apu = im_vectors.AD_ROSEM(:,1);
    end
    if options.AD && options.OSL_RBI
        im_vectors.AD_RBI = ones(N,Niter + 1,'single');
        im_vectors.AD_RBI(:,1) = options.x0(:);
        im_vectors.AD_RBI_apu = im_vectors.AD_RBI(:,1);
    end
    if options.AD && any(options.OSL_COSEM)
        im_vectors.AD_COSEM = ones(N,Niter + 1,'single');
        im_vectors.AD_COSEM(:,1) = options.x0(:);
        im_vectors.AD_COSEM_apu = im_vectors.AD_COSEM(:,1);
    end
    
    if options.APLS && options.OSL_OSEM
        im_vectors.APLS_OSL = ones(N,Niter + 1,'single');
        im_vectors.APLS_OSL(:,1) = options.x0(:);
        im_vectors.APLS_OSL_apu = im_vectors.APLS_OSL(:,1);
    end
    if options.APLS && options.OSL_MLEM
        im_vectors.APLS_OSL_MLEM = ones(N,Niter + 1,'single');
        im_vectors.APLS_MLEM(:,1) = options.x0(:);
        im_vectors.APLS_MLEM_apu = im_vectors.APLS_MLEM(:,1);
    end
    if options.APLS && options.MBSREM
        im_vectors.APLS_MBSREM = ones(N,Niter + 1,'single');
        im_vectors.APLS_MBSREM(:,1) = options.x0(:);
        im_vectors.APLS_MBSREM_apu = im_vectors.APLS_MBSREM(:,1);
    end
    if options.APLS && options.BSREM
        im_vectors.APLS_BSREM = ones(N,Niter + 1,'single');
        im_vectors.APLS_BSREM(:,1) = options.x0(:);
        im_vectors.APLS_BSREM_apu = im_vectors.APLS_BSREM(:,1);
    end
    if options.APLS && options.ROSEM_MAP
        im_vectors.APLS_ROSEM = ones(N,Niter + 1,'single');
        im_vectors.APLS_ROSEM(:,1) = options.x0(:);
        im_vectors.APLS_ROSEM_apu = im_vectors.APLS_ROSEM(:,1);
    end
    if options.APLS && options.OSL_RBI
        im_vectors.APLS_RBI = ones(N,Niter + 1,'single');
        im_vectors.APLS_RBI(:,1) = options.x0(:);
        im_vectors.APLS_RBI_apu = im_vectors.APLS_RBI(:,1);
    end
    if options.APLS && any(options.OSL_COSEM)
        im_vectors.APLS_COSEM = ones(N,Niter + 1,'single');
        im_vectors.APLS_COSEM(:,1) = options.x0(:);
        im_vectors.APLS_COSEM_apu = im_vectors.APLS_COSEM(:,1);
    end
    
    if options.TGV && options.OSL_OSEM
        im_vectors.TGV_OSL = ones(N,Niter + 1,'single');
        im_vectors.TGV_OSL(:,1) = options.x0(:);
        im_vectors.TGV_OSL_apu = im_vectors.TGV_OSL(:,1);
    end
    if options.TGV && options.OSL_MLEM
        im_vectors.TGV_OSL_MLEM = ones(N,Niter + 1,'single');
        im_vectors.TGV_MLEM(:,1) = options.x0(:);
        im_vectors.TGV_MLEM_apu = im_vectors.TGV_MLEM(:,1);
    end
    if options.TGV && options.MBSREM
        im_vectors.TGV_MBSREM = ones(N,Niter + 1,'single');
        im_vectors.TGV_MBSREM(:,1) = options.x0(:);
        im_vectors.TGV_MBSREM_apu = im_vectors.TGV_MBSREM(:,1);
    end
    if options.TGV && options.BSREM
        im_vectors.TGV_BSREM = ones(N,Niter + 1,'single');
        im_vectors.TGV_BSREM(:,1) = options.x0(:);
        im_vectors.TGV_BSREM_apu = im_vectors.TGV_BSREM(:,1);
    end
    if options.TGV && options.ROSEM_MAP
        im_vectors.TGV_ROSEM = ones(N,Niter + 1,'single');
        im_vectors.TGV_ROSEM(:,1) = options.x0(:);
        im_vectors.TGV_ROSEM_apu = im_vectors.TGV_ROSEM(:,1);
    end
    if options.TGV && options.OSL_RBI
        im_vectors.TGV_RBI = ones(N,Niter + 1,'single');
        im_vectors.TGV_RBI(:,1) = options.x0(:);
        im_vectors.TGV_RBI_apu = im_vectors.TGV_RBI(:,1);
    end
    if options.TGV && any(options.OSL_COSEM)
        im_vectors.TGV_COSEM = ones(N,Niter + 1,'single');
        im_vectors.TGV_COSEM(:,1) = options.x0(:);
        im_vectors.TGV_COSEM_apu = im_vectors.TGV_COSEM(:,1);
    end
    
    if options.NLM && options.OSL_OSEM
        im_vectors.NLM_OSL = ones(N,Niter + 1,'single');
        im_vectors.NLM_OSL(:,1) = options.x0(:);
        im_vectors.NLM_OSL_apu = im_vectors.NLM_OSL(:,1);
    end
    if options.NLM && options.OSL_MLEM
        im_vectors.NLM_OSL_MLEM = ones(N,Niter + 1,'single');
        im_vectors.NLM_MLEM(:,1) = options.x0(:);
        im_vectors.NLM_MLEM_apu = im_vectors.NLM_MLEM(:,1);
    end
    if options.NLM && options.MBSREM
        im_vectors.NLM_MBSREM = ones(N,Niter + 1,'single');
        im_vectors.NLM_MBSREM(:,1) = options.x0(:);
        im_vectors.NLM_MBSREM_apu = im_vectors.NLM_MBSREM(:,1);
    end
    if options.NLM && options.BSREM
        im_vectors.NLM_BSREM = ones(N,Niter + 1,'single');
        im_vectors.NLM_BSREM(:,1) = options.x0(:);
        im_vectors.NLM_BSREM_apu = im_vectors.NLM_BSREM(:,1);
    end
    if options.NLM && options.ROSEM_MAP
        im_vectors.NLM_ROSEM = ones(N,Niter + 1,'single');
        im_vectors.NLM_ROSEM(:,1) = options.x0(:);
        im_vectors.NLM_ROSEM_apu = im_vectors.NLM_ROSEM(:,1);
    end
    if options.NLM && options.OSL_RBI
        im_vectors.NLM_RBI = ones(N,Niter + 1,'single');
        im_vectors.NLM_RBI(:,1) = options.x0(:);
        im_vectors.NLM_RBI_apu = im_vectors.NLM_RBI(:,1);
    end
    if options.NLM && any(options.OSL_COSEM)
        im_vectors.NLM_COSEM = ones(N,Niter + 1,'single');
        im_vectors.NLM_COSEM(:,1) = options.x0(:);
        im_vectors.NLM_COSEM_apu = im_vectors.NLM_COSEM(:,1);
    end
    
    if options.custom && options.OSL_OSEM
        im_vectors.custom_OSL = ones(N,Niter + 1,'single');
        im_vectors.custom_OSL(:,1) = options.x0(:);
        im_vectors.custom_OSL_apu = im_vectors.custom_OSL(:,1);
    end
    if options.custom && options.OSL_MLEM
        im_vectors.custom_OSL_MLEM = ones(N,Niter + 1,'single');
        im_vectors.custom_MLEM(:,1) = options.x0(:);
        im_vectors.custom_MLEM_apu = im_vectors.custom_MLEM(:,1);
    end
    if options.custom && options.MBSREM
        im_vectors.custom_MBSREM = ones(N,Niter + 1,'single');
        im_vectors.custom_MBSREM(:,1) = options.x0(:);
        im_vectors.custom_MBSREM_apu = im_vectors.custom_MBSREM(:,1);
    end
    if options.custom && options.BSREM
        im_vectors.custom_BSREM = ones(N,Niter + 1,'single');
        im_vectors.custom_BSREM(:,1) = options.x0(:);
        im_vectors.custom_BSREM_apu = im_vectors.custom_BSREM(:,1);
    end
    if options.custom && options.ROSEM_MAP
        im_vectors.custom_ROSEM = ones(N,Niter + 1,'single');
        im_vectors.custom_ROSEM(:,1) = options.x0(:);
        im_vectors.custom_ROSEM_apu = im_vectors.custom_ROSEM(:,1);
    end
    if options.custom && options.OSL_RBI
        im_vectors.custom_RBI = ones(N,Niter + 1,'single');
        im_vectors.custom_RBI(:,1) = options.x0(:);
        im_vectors.custom_RBI_apu = im_vectors.custom_RBI(:,1);
    end
    if options.custom && any(options.OSL_COSEM)
        im_vectors.custom_COSEM = ones(N,Niter + 1,'single');
        im_vectors.custom_COSEM(:,1) = options.x0(:);
        im_vectors.custom_COSEM_apu = im_vectors.custom_COSEM(:,1);
    end
end