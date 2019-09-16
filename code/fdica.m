


function y = fdica(x, m)
% Frequency-domain independent component analysis for a microphone array
% x is a column vector of microphone signals
% adapted from 	Bolbrock, Derderian, Gibbons, Maragos. “SLIMA: Source Localization and Isolation with a Microphone Array”. IEEE, 2007.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xlen = length(x);               % length of the signal
wlen = 2^8;                     % window length (recomended to be power of 2)
hop = wlen/4;                   % hop size (recomended to be power of 2)
nfft = 2^12;                    % number of fft points (recomended to be power of 2)
overlap = 0.75*nfft;            % overlap is fft overlap (0.75*nfft is good)    
fs = 44100;                     % fs is sampling frequency
n = m;                          % n is number of sources to estimate
c = 343;                        % Speed of sound (m/s)                                
                                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% STFT
for i=1:size(x,2)
X(i,:,:) = stft(x(:,i), wlen,hop, nfft, fs);
end
[m, halfnfft, t] = size(X);

% Perform ICA for each freq. bin
clust = zeros((halfnfft-1)*n, nchoosek(m,2));
index = zeros((halfnfft-1)*n, 2);
Y = zeros(n, halfnfft, t);
pow = zeros((halfnfft-1)*n,1);

for i=2:halfnfft
    i
Xf = squeeze(X(:,i,:));
[Af, Yf] = jade3(Xf, n); %%  jade 2 is for has to have same source and the inout number
% Scaling
D = diag(Af(1,:));
Yf = D*Yf;
Y(:,i,:) = Yf;
Af = Af*pinv(D);
f = (i-1)*fs/2/(nfft/2-1);
for k=1:n
afk = Af(:, k); 
afk = afk/norm(afk);
comb = nchoosek(1:m,2);
clust((i-2)*n+k,:)=angle(afk(comb(:,1))./afk(comb(:,2)))/(2*pi*f/c);
index((i-2)*n+k,:)=[i k];
pow((i-2)*n+k,:)=sum(Yf(k,:).*conj(Yf(k,:)));
end

end
% First, remove any outlying points
for i=1:5
avg = mean(clust,1);
d = clust-avg(ones(size(clust,1),1),:);
d = sum(d.*d,2);
val = find(d<10*std(d));
size(val)
clust = clust(val,:);
index = index(val,:);
end
% Remove any vectors outside of several standard deviations from centroid
% of cluster and repeat kmeans algorithm
[idx, ctr, sumd, d] = kmeans(clust, n, 'display', 'final','EmptyAction', 'singleton');
for i=1:10
val = ones(size(clust,1),1);
for k=1:n
dk = d(idx==k,k);
val = val & ((d(:,k)<6*std(dk)) | (idx~=k));
end
val = find(val);
clust = clust(val,:);
index = index(val,:);
[idx, ctr, sumd, d] = kmeans(clust, n, 'display', 'final','EmptyAction', 'singleton');
end
% Perform permutation
Y2 = zeros(n, halfnfft, t);
W2 = zeros(n, halfnfft, t);
for u=1:size(index,1)
i = index(u,1);
k = index(u,2);
Y2(idx(u),i,:) = Y(k,i,:);
end
% ISTFT
for i=1:n
y(i,:) = istft(squeeze(Y2(i,:,:)),wlen, hop, nfft, fs);
end