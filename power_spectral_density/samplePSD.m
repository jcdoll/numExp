clear all
close all
clc

% Define the sampling rate and time
Fs = 1e5; % samples/sec
numSamples = 1e6;
tFinal = numSamples/Fs;
t = 0:1/Fs:tFinal;

% Calculate the mock signal
johnsonLevel = 1e-9;
whiteNoise = 20*johnsonLevel*randn(size(t));
pinkNoise = cumsum(whiteNoise)*1e-1;
totalNoise = whiteNoise + pinkNoise;

% Calulate the FFT
window = 1e4;
noverlap = window/2;
Hs = spectrum.welch('Hann', window, 100*noverlap/window);

psdOut = psd(Hs, totalNoise, 'Fs', Fs, 'ConfLevel', 0.99);
freq = psdOut.frequencies(2:end);
psdData = sqrt(psdOut.data(2:end));
confInterval = sqrt(psdOut.ConfInterval(2:end,:));

% Plot the signal vs. time
figure
subplot(3,1,1)
plot(t, whiteNoise)
legend('White Noise');

subplot(3,1,2)
plot(t, pinkNoise)
legend('Pink Noise');

subplot(3,1,3)
plot(t, totalNoise)
legend('White Noise + Pink Noise');


% Plot the PSD with confidence intervals
figure
hold on
plot(freq, psdData)
hold off
set(gca, 'xscale', 'log', 'yscale', 'log');
xlim([min(freq) max(freq)])


% Plot the PSD with confidence intervals
freqFill = [freq ; flipud(freq)];
confIntervalFill = [confInterval(:,1) ; flipud(confInterval(:,2))];

figure
hold on
f = fill(freqFill, confIntervalFill, 'r');
plot(freq, psdData)
hold off
set(gca, 'xscale', 'log', 'yscale', 'log');
xlim([min(freq) max(freq)])

resolution = mean(diff(freq))