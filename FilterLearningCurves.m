function smoothed_curves = FilterLearningCurves(learning_curve,smoothing_window,num_raw_points)
%Written by Seth Koenig 3/11/19, code taken from other scripts
%Code smooths data before the block switch and after the block switch
%seperately. Code also sets 1st 1-2 points point after a block switch to
%the raw data so that the maximum and minimum of the performance is maintained.

if nargin < 2
    smoothing_window = 3;
    num_raw_points = 1;
elseif nargin < 3
    num_raw_points = 1;
end

if any(isnan(learning_curve))
    smoothed_curves = learning_curve;
    disp('Not smoothing data since contains NaNs')
    return
end

if length(learning_curve) == 40
    asd = learning_curve;
    asd1 = asd(1:10);
    asd2 = asd(11:end);
    
    asd1 = [asd1(10:-1:1); asd1; asd1(end:-1:end-9)];
    asd1 = filtfilt(1/smoothing_window*ones(1,smoothing_window),1,asd1);
    asd1 = asd1(11:end-10);
    
    asd2 = [asd2(10:-1:1); asd2; asd2(end:-1:end-9)];
    asd2 = filtfilt(1/smoothing_window*ones(1,smoothing_window),1,asd2);
    asd2 = asd2(11:end-10);
    
    smoothed_curves = [asd1; asd2];
    if num_raw_points == 1
        smoothed_curves(11) = learning_curve(11);
    elseif num_raw_points == 2
        smoothed_curves(11) = learning_curve(11);
        smoothed_curves(12) = learning_curve(12);
    elseif num_raw_points == 3
        smoothed_curves(11) = learning_curve(11);
        smoothed_curves(12) = learning_curve(12);
        smoothed_curves(13) = learning_curve(13);
    else
        smoothed_curves(11) = learning_curve(11);
    end
    
elseif length(learning_curve) == 30
    asd = learning_curve;
    asd1 = asd(1:10);
    asd2 = asd(11:end);
    
    asd1 = [asd1(10:-1:1); asd1; asd1(end:-1:end-9)];
    asd1 = filtfilt(1/smoothing_window*ones(1,smoothing_window),1,asd1);
    asd1 = asd1(11:end-10);
    
    asd2 = [asd2(10:-1:1); asd2; asd2(end:-1:end-9)];
    asd2 = filtfilt(1/smoothing_window*ones(1,smoothing_window),1,asd2);
    asd2 = asd2(11:end-10);
    
    smoothed_curves = [asd1; asd2];
    if num_raw_points == 1
        smoothed_curves(11) = learning_curve(11);
    elseif num_raw_points == 2
        smoothed_curves(11) = learning_curve(11);
        smoothed_curves(12) = learning_curve(12);
    elseif num_raw_points == 3
        smoothed_curves(11) = learning_curve(11);
        smoothed_curves(12) = learning_curve(12);
        smoothed_curves(13) = learning_curve(13);
    else
        smoothed_curves(11) = learning_curve(11);
    end
    
elseif length(learning_curve) == 35
    asd = learning_curve;
    asd1 = asd(1:10);
    asd2 = asd(11:end);
    
    asd1 = [asd1(10:-1:1); asd1; asd1(end:-1:end-9)];
    asd1 = filtfilt(1/smoothing_window*ones(1,smoothing_window),1,asd1);
    asd1 = asd1(11:end-10);
    
    asd2 = [asd2(10:-1:1); asd2; asd2(end:-1:end-9)];
    asd2 = filtfilt(1/smoothing_window*ones(1,smoothing_window),1,asd2);
    asd2 = asd2(11:end-10);
    
    smoothed_curves = [asd1; asd2];
    if num_raw_points == 1
        smoothed_curves(11) = learning_curve(11);
    elseif num_raw_points == 2
        smoothed_curves(11) = learning_curve(11);
        smoothed_curves(12) = learning_curve(12);
    elseif num_raw_points == 3
        smoothed_curves(11) = learning_curve(11);
        smoothed_curves(12) = learning_curve(12);
        smoothed_curves(13) = learning_curve(13);
    else
        smoothed_curves(11) = learning_curve(11);
    end
elseif length(learning_curve) == 45
    asd = learning_curve;
    asd1 = asd(1:10);
    asd2 = asd(11:end);
    
    asd1 = [asd1(10:-1:1); asd1; asd1(end:-1:end-9)];
    asd1 = filtfilt(1/smoothing_window*ones(1,smoothing_window),1,asd1);
    asd1 = asd1(11:end-10);
    
    asd2 = [asd2(10:-1:1); asd2; asd2(end:-1:end-9)];
    asd2 = filtfilt(1/smoothing_window*ones(1,smoothing_window),1,asd2);
    asd2 = asd2(11:end-10);
    
    smoothed_curves = [asd1; asd2];
    if num_raw_points == 1
        smoothed_curves(11) = learning_curve(11);
    elseif num_raw_points == 2
        smoothed_curves(11) = learning_curve(11);
        smoothed_curves(12) = learning_curve(12);
    elseif num_raw_points == 3
        smoothed_curves(11) = learning_curve(11);
        smoothed_curves(12) = learning_curve(12);
        smoothed_curves(13) = learning_curve(13);
    else
        smoothed_curves(11) = learning_curve(11);
    end
else
    error('Unknown Length')
end

end