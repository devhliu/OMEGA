function [im, C_co] = COSEM_OSL(im, D, beta, dU, A, uu, epps, C_co, h, COSEM_MAP, osa_iter)
%COSEM_OSL Computes the One-Step Late COSEM (OSL-COSEM) MAP estimates
%
% Example:
%   [im, C_co] = COSEM_OSL(im, D, beta, dU, A, uu, epps, C_co, h, COSEM_MAP, osa_iter)
% INPUTS:
%   im = The current estimate
%   D = Sum of the complete data system matrix (D = sum(B,2), where B =
%   [A_1,A_2,...,A_subsets]
%   beta = Regularization parameter
%   dU = Gradient of the prior
%   A = The transpose of the (sparse) system matrix at current subset
%   uu = Measurements at current subset
%   epps = Small constant to prevent division by zero
%   C_co = Complete-data matrix
%   h = Acceleration parameter (ACOSEM)
%   COSEM_MAP = Whether COSEM or ACOSEM is used
%   osa_iter = Current subset (sub-iteration)
%
% OUTPUTS:
%   im = The updated estimate
%   C_co = Updated Complete-data matrix
% 
%   See also COSEM_im, ACOSEM_im, MBSREM, OSL_OSEM, BSREM_iter, RBI_subiter

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
if COSEM_MAP == 1
    C_co(:,osa_iter) = full(sum((spdiags(im.^(1/h),0,size(A,1),size(A,1))*A)*spdiags(uu./(A'*im + epps),0,size(A,2),size(A,2)),2));
    im = (sum(C_co,2)./(D + beta * dU)).^h;
    im = (im)*sum(uu)/(sum(A'*im));
    im(im < 0) = epps;
else
    C_co(:,osa_iter) = full(sum((spdiags(im,0,size(A,1),size(A,1))*A)*spdiags(uu./(A'*im+epps),0,size(A,2),size(A,2)),2));
    im = (sum(C_co,2)./(D + beta * dU));
end