%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MingYang Lee & YueYue Li
% The Cooper Union 
% Senior Project 2017-2018
% Multi-source seperation using FDICA and Localization using TDOA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%

load('1.mat');
%data=table2array(data);
c = 343;                    % speed of sound
dm = 0.1974;                % diagonal distance between two microphones, in meters
Fs = 44100;

%numSrc = size(data,2)-1;%number of input (microphones), for us is 6
numSrc = size(data, 2)-3;% when using two reference + 6 microphones



signal=[];

%This is the data table without the time colum, so pure sound signal matrix
for i = 1:1:numSrc
    signal(:,i) = data(:,i+1);
end

% 2 reference are recordered
ref = [];
ref(:,1) = data(:, 8);
ref(:,2) = data(:, 9);

%scale the signal for better computation result. Scaling factor can change
signal_scaled = signal.*1000;

% perfiorm ica algorithm
m = 3; % number of source3 you want to extract
y = [];
y = fdica(signal_scaled, m);
y = y';

%signal is then normalized
signal_normed = normalization(signal_scaled, numSrc);

%reference is normalized
ref_normed = normalization (ref, 2);

%ica result is then normalized
Y = [];
Y = normalization(y, m);

%%%%
%localization for each source
%construct a matrix to store location info
location = [];
for i = 1:1:m
    [mic_num, angle, verti] = localize(Y(:,i), signal_normed);
    location(i,1) = mic_num;
    location(i,2) = angle;
    location(i,3) = verti; 
end

%%%%
%the GUI for audio
audio = [];

% True waveforms
for i = 1:2
    audio(end + 1).y = ref_normed(:,i)'; %#ok
    audio(end).Fs    = Fs;
    audio(end).name  = sprintf('true - %d',i);
end

% Mixed waveforms
for i = 1:6
    audio(end + 1).y = signal_normed(:,i); %#ok
    audio(end).Fs    = Fs;
    audio(end).name  = sprintf('mixed - %d',i);
end

%  ICA waveforms
for i = 1:m
    audio(end + 1).y = Y(:,i)'; %#ok
    audio(end).Fs    = Fs;
    audio(end).name  = sprintf('ICA - %d',i);
end

% Play audio
PlayAudio(audio);


