function waveGaussianPAM = pulse_shape(N,Rs,L,symbolsPAM)
% L: Total number of samples per symbol; Rs: symbols rate
Ts = 1/Rs; % symbol period
Tsa = Ts/L;
t_sa = 0:Tsa:Ts;
t_sa = t_sa-Ts/2;
time = -Ts/2:Tsa:Ts/2-Tsa;
% gaussian pulse
Tfwhm = 1/(6*Rs);
T0 =Tfwhm/(2*sqrt(log(2)));

Gaussian = exp((-1/2)*(time/T0).^2);

% Gaussian pulse shaping
waveformPAM = repmat(symbolsPAM,L,1);
waveformPAMup = reshape(waveformPAM,1,N*L);

index = 1;
for i = 1:L:(length(waveformPAMup))
    waveGaussianPAM(index,:) = waveformPAMup(i:(i+L-1)).*Gaussian;
    index = index+1;
end
waveGaussianPAM = reshape(waveGaussianPAM',1,N*L);
end