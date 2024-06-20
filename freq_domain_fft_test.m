% Load the music file
[y, Fs] = audioread('insert_file_name.wav'); % y is the audio signal, Fs is the sampling frequency

% Apply Fourier Transform
Y = fft(y);
L = length(y); % Signal length

% Frequency vector
f = Fs*(0:(L/2))/L;

% Plot the spectrum
P2 = abs(Y/L); % Two-sided spectrum
P1 = P2(1:L/2+1); % Single-sided spectrum
P1(2:end-1) = 2*P1(2:end-1);
plot(f, P1) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (f), Hz')
ylabel('|P1(f)|')

% Interference frequencies identified visually
frequencies = [1102.49, 2756.27];
width = 10; % Adjust width as needed

% Remove interference for each identified frequency
for i = 1:length(frequencies)
    f0 = frequencies(i);
    idx = f > f0-width & f < f0+width;
    Y(idx) = 0;
    % Find the mirror index for negative frequencies, adjust to handle complex conjugate
    mirror_idx = length(Y) - idx + 1;
    Y(mirror_idx) = 0;
end

% Apply Inverse Fourier Transform
y_filtered = ifft(Y, 'symmetric');

% Play the filtered sound
sound(y_filtered, Fs);

% Save the filtered music file
audiowrite('freq_domain_filtered.wav', y_filtered, Fs);

