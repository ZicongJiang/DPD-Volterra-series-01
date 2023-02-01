function [Tx_signal_noise] = Quantnoise_TX(Tx_signal,Bandwidth,Fs)
% LPF
[z,p,k] = besself(5,Bandwidth*2*pi); % cut-off frequency (angular frequency)    (https://zhuanlan.zhihu.com/p/141829105
[b,a]=zp2tf(z,p,k); 
[num, den] = bilinear(b, a,Fs); % sample rate
Tx_signal = filtfilt(num, den, Tx_signal); % sample rate per second


% Quantilization noise
nQuantBits = 12;

nQuantLevels = 2^nQuantBits;

qRange_Tx = (max(Tx_signal)-min(Tx_signal)); %Tx_signal is the signal before the DAC

qNoiseInt_Tx = qRange_Tx/nQuantLevels;

qNoiseVariance_Tx = qNoiseInt_Tx.^2/12;

qNoise_Tx = unifrnd(-qNoiseInt_Tx/2,qNoiseInt_Tx /2,size(Tx_signal))+1j*unifrnd(-qNoiseInt_Tx /2,qNoiseInt_Tx /2,size(Tx_signal)); % you add this noise to Tx_signal

Tx_signal_noise = 2*real(qNoise_Tx) + Tx_signal;
end