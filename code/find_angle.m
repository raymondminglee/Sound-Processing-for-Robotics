function [sampleDiff, angle] = find_angle(fs, c, dm, data1, data2, sig_extract)
%
% data1= data of the mic determined to have the largest correlation with the
% ICA source seperated file
%
% data2 = the other mic in he mic pair tested

[acor1,lag1] = xcorr(data1,sig_extract);
[~,I1] = max(abs(acor1));
sampleDiff1 = lag1(I1);

[acor2,lag2] = xcorr(sig_extract,data2);
[~,I2] = max(abs(acor2));
sampleDiff2 = lag1(I2);

% subplot(311); plot(data1); title('s1');
% subplot(312); plot(data2); title('s2');
% subplot(313); plot(lag,acor);

sampleDiff = sampleDiff1 - sampleDiff2;
del_t=sampleDiff/fs;
d = c*del_t;
if (abs(d/dm)<= 1)
angle = 180/pi*acos(d/dm) 
elseif (d/dm < -1)
    angle = 180;
else 
    angle = 0;
end
end