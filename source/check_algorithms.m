function img = check_algorithms(pz, algorithms, color_from_algo)
%CHECK_ALGORITHMS Check if the input algorithm exists
%   This function checks the input cell matrix and whether or not the input
%   algorithm actually exists there. If not, the available algorithms are
%   displayed.

algo_char = algorithms_char();
img = pz{algorithms(color_from_algo)};
for jj = 1:numel(algorithms)
    if isempty(pz{algorithms(jj)})
        warning('The current selected algorithm does not contain any estimes!')
        fprintf('The following are contained in the input array:\n')
        char_ar = algo_char(~cellfun(@isempty,pz));
        loc = find(~cellfun(@isempty,pz));
        for kk = 1 : nnz(~cellfun(@isempty,pz))-1
            fprintf('Element %d: %s\n', loc(kk), char_ar{kk})
        end
        img = [];
        return
    end
end
end
