y=wavread('discharge.wav',300);
x=fft(y,300);
plot(x)