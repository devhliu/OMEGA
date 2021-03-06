function im_vectors = initialize_im_vectors(im_vectors, iter, options)

if options.osem
    im_vectors.OSEM_apu = im_vectors.OSEM(:,iter);
end
if options.mlem
    im_vectors.MLEM_apu = im_vectors.MLEM(:,iter);
end
if options.mramla
    im_vectors.MRAMLA_apu = im_vectors.MRAMLA(:,iter);
end
if options.ramla
    im_vectors.RAMLA_apu = im_vectors.RAMLA(:,iter);
end
if options.rosem
    im_vectors.ROSEM_apu = im_vectors.ROSEM(:,iter);
end
if options.rbi
    im_vectors.RBI_apu = im_vectors.RBI(:,iter);
end
if options.drama
    im_vectors.DRAMA_apu = im_vectors.DRAMA(:,iter);
end
if options.cosem
    im_vectors.COSEM_apu = im_vectors.COSEM(:,iter);
end
if options.ecosem
    im_vectors.ECOSEM_apu = im_vectors.ECOSEM(:,iter);
    if ~options.osem
        im_vectors.OSEM_apu = im_vectors.COSEM(:,iter);
    end
    if ~options.cosem
        im_vectors.COSEM_apu = im_vectors.OSEM(:,iter);
    end
end
if options.acosem
    im_vectors.ACOSEM_apu = im_vectors.ACOSEM(:,iter);
end

if options.MRP && options.OSL_OSEM
    im_vectors.MRP_OSL_apu = im_vectors.MRP_OSL(:,iter);
end
if options.MRP && options.OSL_MLEM
    im_vectors.MRP_MLEM_apu = im_vectors.MRP_MLEM(:,iter);
end
if options.MRP && options.MBSREM
    im_vectors.MRP_MBSREM_apu = im_vectors.MRP_MBSREM(:,iter);
end
if options.MRP && options.BSREM
    im_vectors.MRP_BSREM_apu = im_vectors.MRP_BSREM(:,iter);
end
if options.MRP && options.ROSEM_MAP
    im_vectors.MRP_ROSEM_apu = im_vectors.MRP_ROSEM(:,iter);
end
if options.MRP && options.RBI_OSL
    im_vectors.MRP_RBI_apu = im_vectors.MRP_RBI(:,iter);
end
if options.MRP && any(options.COSEM_OSL)
    im_vectors.MRP_COSEM_apu = im_vectors.MRP_COSEM(:,iter);
end

if options.quad && options.OSL_OSEM
    im_vectors.Quad_OSL_apu = im_vectors.Quad_OSL(:,iter);
end
if options.quad && options.OSL_MLEM
    im_vectors.Quad_MLEM_apu = im_vectors.Quad_MLEM(:,iter);
end
if options.quad && options.MBSREM
    im_vectors.Quad_MBSREM_apu = im_vectors.Quad_MBSREM(:,iter);
end
if options.quad && options.BSREM
    im_vectors.Quad_BSREM_apu = im_vectors.Quad_BSREM(:,iter);
end
if options.quad && options.ROSEM_MAP
    im_vectors.Quad_ROSEM_apu = im_vectors.Quad_ROSEM(:,iter);
end
if options.quad && options.RBI_OSL
    im_vectors.Quad_RBI_apu = im_vectors.Quad_RBI(:,iter);
end
if options.quad && any(options.COSEM_OSL)
    im_vectors.Quad_COSEM_apu = im_vectors.Quad_COSEM(:,iter);
end

if options.Huber && options.OSL_OSEM
    im_vectors.Huber_OSL_apu = im_vectors.Huber_OSL(:,iter);
end
if options.Huber && options.OSL_MLEM
    im_vectors.Huber_MLEM_apu = im_vectors.Huber_MLEM(:,iter);
end
if options.Huber && options.MBSREM
    im_vectors.Huber_MBSREM_apu = im_vectors.Huber_MBSREM(:,iter);
end
if options.Huber && options.BSREM
    im_vectors.Huber_BSREM_apu = im_vectors.Huber_BSREM(:,iter);
end
if options.Huber && options.ROSEM_MAP
    im_vectors.Huber_ROSEM_apu = im_vectors.Huber_ROSEM(:,iter);
end
if options.Huber && options.RBI_OSL
    im_vectors.Huber_RBI_apu = im_vectors.Huber_RBI(:,iter);
end
if options.Huber && any(options.COSEM_OSL)
    im_vectors.Huber_COSEM_apu = im_vectors.Huber_COSEM(:,iter);
end

if options.L && options.OSL_OSEM
    im_vectors.L_OSL_apu = im_vectors.L_OSL(:,iter);
end
if options.L && options.OSL_MLEM
    im_vectors.L_MLEM_apu = im_vectors.L_MLEM(:,iter);
end
if options.L && options.MBSREM
    im_vectors.L_MBSREM_apu = im_vectors.L_MBSREM(:,iter);
end
if options.L && options.BSREM
    im_vectors.L_BSREM_apu = im_vectors.L_BSREM(:,iter);
end
if options.L && options.ROSEM_MAP
    im_vectors.L_ROSEM_apu = im_vectors.L_ROSEM(:,iter);
end
if options.L && options.RBI_OSL
    im_vectors.L_RBI_apu = im_vectors.L_RBI(:,iter);
end
if options.L && any(options.COSEM_OSL)
    im_vectors.L_COSEM_apu = im_vectors.L_COSEM(:,iter);
end

if options.FMH && options.OSL_OSEM
    im_vectors.FMH_OSL_apu = im_vectors.FMH_OSL(:,iter);
end
if options.FMH && options.OSL_MLEM
    im_vectors.FMH_MLEM_apu = im_vectors.FMH_MLEM(:,iter);
end
if options.FMH && options.MBSREM
    im_vectors.FMH_MBSREM_apu = im_vectors.FMH_MBSREM(:,iter);
end
if options.FMH && options.BSREM
    im_vectors.FMH_BSREM_apu = im_vectors.FMH_BSREM(:,iter);
end
if options.FMH && options.ROSEM_MAP
    im_vectors.FMH_ROSEM_apu = im_vectors.FMH_ROSEM(:,iter);
end
if options.FMH && options.RBI_OSL
    im_vectors.FMH_RBI_apu = im_vectors.FMH_RBI(:,iter);
end
if options.FMH && any(options.COSEM_OSL)
    im_vectors.FMH_COSEM_apu = im_vectors.FMH_COSEM(:,iter);
end

if options.weighted_mean && options.OSL_OSEM
    im_vectors.Weighted_OSL_apu = im_vectors.Weighted_OSL(:,iter);
end
if options.weighted_mean && options.OSL_MLEM
    im_vectors.Weighted_MLEM_apu = im_vectors.Weighted_MLEM(:,iter);
end
if options.weighted_mean && options.MBSREM
    im_vectors.Weighted_MBSREM_apu = im_vectors.Weighted_MBSREM(:,iter);
end
if options.weighted_mean && options.BSREM
    im_vectors.Weighted_BSREM_apu = im_vectors.Weighted_BSREM(:,iter);
end
if options.weighted_mean && options.ROSEM_MAP
    im_vectors.Weighted_ROSEM_apu = im_vectors.Weighted_ROSEM(:,iter);
end
if options.weighted_mean && options.RBI_OSL
    im_vectors.Weighted_RBI_apu = im_vectors.Weighted_RBI(:,iter);
end
if options.weighted_mean && any(options.COSEM_OSL)
    im_vectors.Weighted_COSEM_apu = im_vectors.Weighted_COSEM(:,iter);
end

if options.TV && options.OSL_OSEM
    im_vectors.TV_OSL_apu = im_vectors.TV_OSL(:,iter);
end
if options.TV && options.OSL_MLEM
    im_vectors.TV_MLEM_apu = im_vectors.TV_MLEM(:,iter);
end
if options.TV && options.MBSREM
    im_vectors.TV_MBSREM_apu = im_vectors.TV_MBSREM(:,iter);
end
if options.TV && options.BSREM
    im_vectors.TV_BSREM_apu = im_vectors.TV_BSREM(:,iter);
end
if options.TV && options.ROSEM_MAP
    im_vectors.TV_ROSEM_apu = im_vectors.TV_ROSEM(:,iter);
end
if options.TV && options.RBI_OSL
    im_vectors.TV_RBI_apu = im_vectors.TV_RBI(:,iter);
end
if options.TV && any(options.COSEM_OSL)
    im_vectors.TV_COSEM_apu = im_vectors.TV_COSEM(:,iter);
end

if options.AD && options.OSL_OSEM
    im_vectors.AD_OSL_apu = im_vectors.AD_OSL(:,iter);
end
if options.AD && options.OSL_MLEM
    im_vectors.AD_MLEM_apu = im_vectors.AD_MLEM(:,iter);
end
if options.AD && options.MBSREM
    im_vectors.AD_MBSREM_apu = im_vectors.AD_MBSREM(:,iter);
end
if options.AD && options.BSREM
    im_vectors.AD_BSREM_apu = im_vectors.AD_BSREM(:,iter);
end
if options.AD && options.ROSEM_MAP
    im_vectors.AD_ROSEM_apu = im_vectors.AD_ROSEM(:,iter);
end
if options.AD && options.RBI_OSL
    im_vectors.AD_RBI_apu = im_vectors.AD_RBI(:,iter);
end
if options.AD && any(options.COSEM_OSL)
    im_vectors.AD_COSEM_apu = im_vectors.AD_COSEM(:,iter);
end

if options.APLS && options.OSL_OSEM
    im_vectors.APLS_OSL_apu = im_vectors.APLS_OSL(:,iter);
end
if options.APLS && options.OSL_MLEM
    im_vectors.APLS_MLEM_apu = im_vectors.APLS_MLEM(:,iter);
end
if options.APLS && options.MBSREM
    im_vectors.APLS_MBSREM_apu = im_vectors.APLS_MBSREM(:,iter);
end
if options.APLS && options.BSREM
    im_vectors.APLS_BSREM_apu = im_vectors.APLS_BSREM(:,iter);
end
if options.APLS && options.ROSEM_MAP
    im_vectors.APLS_ROSEM_apu = im_vectors.APLS_ROSEM(:,iter);
end
if options.APLS && options.RBI_OSL
    im_vectors.APLS_RBI_apu = im_vectors.APLS_RBI(:,iter);
end
if options.APLS && any(options.COSEM_OSL)
    im_vectors.APLS_COSEM_apu = im_vectors.APLS_COSEM(:,iter);
end

if options.TGV && options.OSL_OSEM
    im_vectors.TGV_OSL_apu = im_vectors.TGV_OSL(:,iter);
end
if options.TGV && options.OSL_MLEM
    im_vectors.TGV_MLEM_apu = im_vectors.TGV_MLEM(:,iter);
end
if options.TGV && options.MBSREM
    im_vectors.TGV_MBSREM_apu = im_vectors.TGV_MBSREM(:,iter);
end
if options.TGV && options.BSREM
    im_vectors.TGV_BSREM_apu = im_vectors.TGV_BSREM(:,iter);
end
if options.TGV && options.ROSEM_MAP
    im_vectors.TGV_ROSEM_apu = im_vectors.TGV_ROSEM(:,iter);
end
if options.TGV && options.RBI_OSL
    im_vectors.TGV_RBI_apu = im_vectors.TGV_RBI(:,iter);
end
if options.TGV && any(options.COSEM_OSL)
    im_vectors.TGV_COSEM_apu = im_vectors.TGV_COSEM(:,iter);
end

if options.NLM && options.OSL_OSEM
    im_vectors.NLM_OSL_apu = im_vectors.NLM_OSL(:,iter);
end
if options.NLM && options.OSL_MLEM
    im_vectors.NLM_MLEM_apu = im_vectors.NLM_MLEM(:,iter);
end
if options.NLM && options.MBSREM
    im_vectors.NLM_MBSREM_apu = im_vectors.NLM_MBSREM(:,iter);
end
if options.NLM && options.BSREM
    im_vectors.NLM_BSREM_apu = im_vectors.NLM_BSREM(:,iter);
end
if options.NLM && options.ROSEM_MAP
    im_vectors.NLM_ROSEM_apu = im_vectors.NLM_ROSEM(:,iter);
end
if options.NLM && options.RBI_OSL
    im_vectors.NLM_RBI_apu = im_vectors.NLM_RBI(:,iter);
end
if options.NLM && any(options.COSEM_OSL)
    im_vectors.NLM_COSEM_apu = im_vectors.NLM_COSEM(:,iter);
end


if options.OSL_OSEM && options.custom
    im_vectors.custom_OSL_apu = im_vectors.custom_OSL(:,iter);
end
if options.OSL_MLEM && options.custom
    im_vectors.custom_MLEM_apu = im_vectors.custom_MLEM(:,iter);
end
if options.MBSREM && options.custom
    im_vectors.custom_MBSREM_apu = im_vectors.custom_MBSREM(:,iter);
end
if options.BSREM && options.custom
    im_vectors.custom_BSREM_apu = im_vectors.custom_BSREM(:,iter);
end
if options.ROSEM_MAP && options.custom
    im_vectors.custom_ROSEM_apu = im_vectors.custom_ROSEM(:,iter);
end
if options.RBI_OSL && options.custom
    im_vectors.custom_RBI_apu = im_vectors.custom_RBI(:,iter);
end
if any(options.COSEM_OSL) && options.custom
    im_vectors.custom_COSEM_apu = im_vectors.custom_COSEM(:,iter);
end