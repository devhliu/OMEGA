function im = BSREM_subiter(im, lambda, epps, iter, varargin)
%BSREM_SUBITER Computes the Block Sequential Regularized Expectation
%Maximization (BSREM) estimates at sub-iteration level (i.e. RAMLA
%estimates)
%
% INPUTS:
%   im = The current estimate
%   lambda = Relaxation parameter
%   epps = Small constant to prevent division by zero
%   iter = Current iteration number
%   A = The transpose of the (sparse) system matrix at current subset
%   uu = Measurements at current subset
%   is_transposed = true if A matrix is the transpose of it, false if not
%
% OUTPUTS:
%   im = The updated estimate
%
% See also OSEM_im, DRAMA_subiter, ROSEM_subiter, RBI_subiter, COSEM_im,
% ACOSEM_im, ECOSEM_im, MBSREM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2019  Ville-Veikko Wettenhovi, Samuli Summala
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
if nargin == 7
    if varargin{3}
        im = im + lambda(iter).*im.*(varargin{1}*(varargin{2}./(varargin{1}'*im + epps) - 1));
    else
        im = im + lambda(iter).*im.*(varargin{1}'*(varargin{2}./(varargin{1}*im + epps) - 1));
    end
elseif nargin == 6
    im = im + lambda(iter).*im.*((varargin{2} + epps) - varargin{1});
else
    error('Invalid number of input arguments')
end