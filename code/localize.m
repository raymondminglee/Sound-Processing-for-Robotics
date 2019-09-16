function [mic_num, angle, verti] = localize (sig_extract, signal_normed)
% This script is used to process the angle of the incoming sound
% Senior Capstone Design - Yueyue Li & Mingyang Lee
% Input: 

% Constants
fs = 44100;  
c = 343; % speed of sound
dm = 0.1974; % diagonal distance between two microphones, in meters

mic1 = signal_normed(:,1);
mic2 = signal_normed(:,2);
mic3 = signal_normed(:,3);
mic4 = signal_normed(:,4);
mic5 = signal_normed(:,5);
mic6 = signal_normed(:,6);

corr = [];
for i = 1:4
[acor,lag] = xcorr(sig_extract,signal_normed(:,i));
corr(i,1) = max(abs(acor))
end
%the microphone with the higest correlation to this source
[~, mic_num] = max(corr);

if mic_num == 1
    [sampleDiff,angle] = find_angle(fs, c, dm, mic2, mic3, sig_extract);
    angle = 45+180-angle;
elseif mic_num == 2
    [sampleDiff,angle] = find_angle(fs, c, dm, mic1, mic4, sig_extract);
    angle = angle - 45;
elseif mic_num == 3
    [sampleDiff,angle] = find_angle(fs, c, dm, mic1, mic4, sig_extract);
    angle = (-angle) - 45;
elseif mic_num == 4
    [sampleDiff,angle] = find_angle(fs, c, dm, mic2, mic3, sig_extract);
    angle = 45+180+angle;
end

if angle > 360
    angle = 360 - angle;
end

%%%% the following part is to determine whether the source is 
%%%% above or below the microphone array 
%corr_top = xcorr(sig_extract,signal_normed(:,5));
%corr_btm = xcorr(sig_extract,signal_normed(:,6));
verti = find_angle(fs, c, dm, mic6, mic5, sig_extract);


end


% if angle1 <90 
% incidence_angle = 180+45+ angle2
% else
%     incidence_angle = 45+(180-angle2)
% end