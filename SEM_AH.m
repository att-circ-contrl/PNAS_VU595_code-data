function SEM = SEM_AH(data,varargin)
% calculates SEMean / SEMedian: input data and 'mean', 'median', or 'prop'
% will treat matrix as a vector. If data is binary, use 'prop' for SEMean.
% For prop data, 1 is value of interest and 0 is not.
data = data(:);

if isempty(data)
    warning('not data input')
end

if isempty(varargin)
    avg_mode = 'mean';
elseif numel(varargin) > 1
    error ('too many inputs')
else
    avg_mode = varargin{1};
end

if numel(data) == 1
    SEM = NaN;
else
    switch avg_mode
        case 'median'
            SEM = nanstd(data)/sqrt(numel(data)) * 1.2533;
        case 'mean'
            SEM = nanstd(data)/sqrt(numel(data));
        case 'prop'
            tmp_p = nansum(data) / numel(data);
            SEM = 1.96*(sqrt((tmp_p*(1-tmp_p))/numel(data))); %1.96 is z value for 95% confidence
    end
end

end