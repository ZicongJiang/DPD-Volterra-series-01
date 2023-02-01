function [Rx_signal_noise] = Quantnoise_RX(Rx_signal,Bandwidth,Fs)
% Quantilization noise
nQuantBits = 12;

nQuantLevels = 2^nQuantBits;

qRange_Rx = (max(Rx_signal)-min(Rx_signal)); %Rx_signal is the signal before the ADC

qNoiseInt_Rx = qRange_Rx/nQuantLevels;

qNoiseVariance_Rx = qNoiseInt_Rx.^2/12;

qNoise_Rx = unifrnd(-qNoiseInt_Rx /2,qNoiseInt_Rx /2,size(Rx_signal))+1j*unifrnd(-qNoiseInt_Rx /2,qNoiseInt_Rx /2,size(Rx_signal)); % you add this noise to Rx_signal

Rx_signal_noise = 2*real(qNoise_Rx) + Rx_signal;

% LPF
[z,p,k] = besself(5,Bandwidth*2*pi); % cut-off frequency     (https://zhuanlan.zhihu.com/p/141829105
[a,b]=zp2tf(z,p,k); 
[num, den] = bilinear(a, b,Fs); % sample rate
% [num,den]=impinvar(a,b,Fs);
Rx_signal_noise = filtfilt(num, den, Rx_signal_noise); % sample rate per second


% [b,a] = besself(5,Bandwidth); % cut-off frequency     (https://zhuanlan.zhihu.com/p/141829105
% [a,b]=zp2tf(z,p,k); 
% [num, den] = bilinear(a, b,2*Bandwidth); % sample rate
% Rx_signal_noise = filter(b, a, Rx_signal_noise); % sample rate per second
end