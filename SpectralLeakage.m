%{
Using different window functions (Rect - Hann-Hamm) to minimize spectral
leakage for discretized input signal(sinusoidal signal)
Students :
- Ahmed Fakhry Mustafa Kamal      29 
- Ahmed Adel Youssef Youssef Attia       24
- Salah Eldin Mohamed Ashraf Hegazy      146
 %}

%Sampling parameters
fs = 1000;
T  = 1/fs;
N  = 1000  %One thousand samples per one second 
n  = 0:N-1 %Discrete time 
t   = n*T     %Sampling times  per one second

%Input signal
fm  = 7.5   %7.5 cycles per one second
x    = cos(2*pi* fm *t)

x_pad = [x zeros(1, 99000)]; %zero padding for my signal
x_pad_t= abs(fft(x_pad));

figure;
%Plotting input signal
subplot(2,1,1);
plot(n,x);
xlabel('Time Samples/Discretized Time')
ylabel('Amplitude');

% Plot magnitude spectrum against frequency in Hertz
subplot(2,1,2);
w = [0:100000-1]*fs/100000;
plot(w(1:1500), x_pad_t(1:1500));
xlabel('Frequency (Hertz)');
ylabel('Magnitude');

%{
From the signal spectrum we can easily find that there is spectral
leakage around central frequency of the signal (7.5 ) 
%}


%First Applying Rectangular,hann,hamming windows
%Rectangular Window 
rectw = rectwin(N)';
x_pad_rwin = [x.*rectw zeros( 1,99000)];
x_pad_rwin_t = abs(fft(x_pad_rwin));   

%Hann window 
hann = hanning(N)';
x_pad_hwin= [x.*hann zeros(1,99000)];
x_pad_hwin_t = abs(fft(x_pad_hwin));

%Hamm window 
hamm = hamming(N)';
x_pad_hmwin= [x.*hamm zeros(1,99000)];
x_pad_hmwin_t = abs(fft(x_pad_hmwin));

figure;
hold;
%= x_pad .* rectw_pad;
subplot(1,1,1)
%plot windowed signal against frequency
xlabel('Discretized Frequency');
ylabel('Amplitude');
plot(w(1:1500),x_pad_rwin_t(1:1500),'r');
plot(w(1:1500),x_pad_hwin_t(1:1500),'b');
plot(w(1:1500),x_pad_hmwin_t(1:1500),'g');



