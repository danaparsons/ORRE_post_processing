%% ------------------------------ Header ------------------------------- %%
% Filename:     init_filters.m
% Description:  Initialize filter specifications for ORRE Post Processing
% Author:       J. Davis
% Created on:   6-23-21
% Last updated: 6-23-21 by J. Davis
%% --------------------------------------------------------------------- %%
function filtout = init_filters(filtopts)

numfilts = length(filtopts.type);

% if numfilts == 1
%     filtout.type = filtopts.type;
%     filtout.subtype = filtopts.subtype;
%     filtout.order = filtopts.order;
%     filtout.cutoff_margin = filtopts.cutoff_margin;
% else
filtout = cell(1,numfilts);
for i = 1:numfilts
    filtout{1,i}.type = filtopts.type{i};
    filtout{1,i}.subtype = filtopts.subtype{i};
    filtout{1,i}.order = filtopts.order{i};
    if isfield(filtopts,'cutoff_margin') && ~isempty(filtopts.cutoff_margin{i})
        filtout{1,i}.cutoff_margin = filtopts.cutoff_margin{i};
    end
    if isfield(filtopts,'f_cutoff') && ~isempty(filtopts.f_cutoff{i})
        filtout{1,i}.f_cutoff = filtopts.f_cutoff{i};
    end
end
% end
end

