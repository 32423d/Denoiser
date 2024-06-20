clear; clc;

% Load the unfiltered audio file
[audio, Fs] = audioread("insert_file_name.wav");

% Analyze the frequency content of the unfiltered audio
L = length(audio);
Y = fft(audio);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

% Time vector for plotting audio in time domain
t = (0:L-1)/Fs;

% Plot the unfiltered audio in time domain and its spectrum
figure;
subplot(4,1,1);
plot(t, audio)
title('Amplitude vs. Time for Noisy Signal')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(4,1,3);
plot(f,P1)
title('Single-Sided Amplitude Spectrum of Noisy Signal')
xlabel('Frequency (f)')
ylabel('|P1(f)|')

% Filtering process
lowCutoff1 = 1081;
highCutoff1 = 1126;
lowCutoff2 = 2726;
highCutoff2 = 2783;

Wn1 = [lowCutoff1 highCutoff1] / (Fs/2);
[b1, a1] = butter(4, Wn1, 'stop');
filtered_audio1 = filter(b1, a1, audio);

Wn2 = [lowCutoff2 highCutoff2] / (Fs/2);
[b2, a2] = butter(4, Wn2, 'stop');
filtered_audio2 = filter(b2, a2, filtered_audio1);

audiowrite('butter.wav', filtered_audio2, Fs);
sound(filtered_audio2, Fs);


% Load the filtered audio file
[filtered_audio, Fs_filtered] = audioread("butter.wav");

% Repeat the FFT analysis for the filtered audio
L_filtered = length(filtered_audio);
Y_filtered = fft(filtered_audio);
P2_filtered = abs(Y_filtered/L_filtered);
P1_filtered = P2_filtered(1:L_filtered/2+1);
P1_filtered(2:end-1) = 2*P1_filtered(2:end-1);
f_filtered = Fs_filtered*(0:(L_filtered/2))/L_filtered;

% Time vector for plotting filtered audio in time domain
t_filtered = (0:L_filtered-1)/Fs_filtered;

% Plot the filtered audio in time domain and its spectrum
subplot(4,1,2);
plot(t_filtered, filtered_audio)
title('Amplitude vs. Time for Filtered Signal')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(4,1,4);
plot(f_filtered, P1_filtered)
title('Single-Sided Amplitude Spectrum of Filtered Signal')
xlabel('Frequency (f)')
ylabel('|P1(f)|')

% Spectrogram plots
figure;
subplot(2,1,1);
spectrogram(audio, 128, 120, 128, Fs, 'yaxis');
title('Spectrogram of Noisy Signal');

subplot(2,1,2);
spectrogram(filtered_audio, 128, 120, 128, Fs, 'yaxis');
title('Spectrogram of Filtered Signal');
