%This program can be used to check the similarities between signals
%
T1 = Y(:,1);
T2 = Y(:,2);
S = ref_normed(:,2);



[C2,lag2] = xcorr(T2,S);        

figure
ax(1) = subplot(2,1,1); 
plot(lag1/Fs,C1,'k')
ylabel('Amplitude')
grid on
title('Cross-correlation between Template 1 and Signal')
ax(2) = subplot(2,1,2); 
plot(lag2/Fs,C2,'r')
ylabel('Amplitude') 
grid on
title('Cross-correlation between Template 2 and Signal')
xlabel('Time(secs)') 
axis(ax(1:2),[-1.5 1.5 -700 700 ])