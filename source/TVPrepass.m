function options = TVPrepass(options)
%TVPREPASS Precomputation phase for TV
%   Precomputes necessary (anatomical prior) variables
% Anatomical prior
TVdata = [];
if options.TV_use_anatomical
    apu = load(options.TV_reference_image);
    variables = fields(apu);
    alkuarvo = double(apu.(variables{1}));
    if size(alkuarvo,2) == 1
        koko_apu = sqrt(length(alkuarvo)/double(options.Nz));
        if floor(koko_apu) ~= koko_apu
            error('Reference image has to be square')
        else
            alkuarvo = reshape(alkuarvo, koko_apu,koko_apu,options.Nz);
            if koko_apu ~= options.Nx
                alkuarvo = imresize(alkuarvo, options.Nx, options.Ny, options.Nz);
            end
        end
    else
        if size(alkuarvo,2) ~= options.Nx
            alkuarvo = imresize(alkuarvo, options.Nx, options.Ny, options.Nz);
        end
    end
    alkuarvo = alkuarvo - min(min(min(alkuarvo)));
    alkuarvo = alkuarvo/max(max(max(alkuarvo)));
    if options.TVtype == 1
        S = assembleS(alkuarvo,options.T,options.Ny,options.Nx,options.Nz);
        if options.implementation == 2
            TVdata.s1 = single(S(1:3:end,1));
            TVdata.s2 = single(S(1:3:end,2));
            TVdata.s3 = single(S(1:3:end,3));
            TVdata.s4 = single(S(2:3:end,1));
            TVdata.s5 = single(S(2:3:end,2));
            TVdata.s6 = single(S(2:3:end,3));
            TVdata.s7 = single(S(3:3:end,1));
            TVdata.s8 = single(S(3:3:end,2));
            TVdata.s9 = single(S(3:3:end,3));
        else
            TVdata.s1 = S(1:3:end,1);
            TVdata.s2 = S(1:3:end,2);
            TVdata.s3 = S(1:3:end,3);
            TVdata.s4 = S(2:3:end,1);
            TVdata.s5 = S(2:3:end,2);
            TVdata.s6 = S(2:3:end,3);
            TVdata.s7 = S(3:3:end,1);
            TVdata.s8 = S(3:3:end,2);
            TVdata.s9 = S(3:3:end,3);
        end
    end
    if options.implementation == 2
        TVdata.reference_image = single(alkuarvo);
        TVdata.T = single(options.T);
        TVdata.C = single(options.C);
    else
        TVdata.reference_image = alkuarvo;
        TVdata.T = options.T;
        TVdata.C = options.C;
    end
    clear apu variables alkuarvo S
end
if options.implementation == 2
    options.tau = single(options.tau);
    TVdata.beta = single(options.TVsmoothing);
    TVdata.C = single(options.C);
    TVdata.T = single(options.T);
    options.TVdata = TVdata;
    options.TVtype = uint32(options.TVtype);
    if isfield(options,'SATVPhi')
        options.SATVPhi = single(options.SATVPhi);
    else
        options.SATVPhi = single(0);
    end
else
    options.TVdata = TVdata;
end
clear TVdata;
end

