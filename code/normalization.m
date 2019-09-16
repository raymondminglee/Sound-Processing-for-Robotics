function normed = normalization(y, j)
normed = [];
Y = [];
for i = 1:1:j
% shift = (0 - min(min(y(:,i))))/((max(max(y(:,i))) - min(min(y(:,i))))/2);
% Y(:,i) = (y(:,i) - min(min(y(:,i)))) ./ ((max(max(y(:,i))) - min(min(y(:,i))))/2);
% Y(:,i) = Y(:,i)- shift;
ref_pt = max(abs(y(:,i)));
ratio = 0.99/ref_pt;
Y(:,i)=y(:,i).* ratio;
end
normed = Y;