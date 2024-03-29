function P_ook = OOK(N,loopnum,dB,snr,symbol_rate,samples,Fs)


%SER calculation for OOK signal
Rs = symbol_rate;
bitrate = Rs; % cut-off frequency follow Nyquist criteira, bandwidth:  bitrate/2 <= B
L = samples;
P_avg = zeros(1,length(dB));
for n = 1:loopnum
    x=randi([0,1],1,N); % random signal
    x_gauss = pulse_shape(N,Rs,L,x);
    Eav = mean(x.^2);

%     x_gauss = Quantnoise_TX(x_gauss,bitrate); % Quantnoise_Tx


    for i=1:length(dB)
            N0=Eav/snr(i)/2;%计算噪声功率
%             N0_dB=10*log10(N0);%将噪声功率转换为dBW
%             ni=wgn(1,length(x_gauss),N0_dB);%产生高斯噪声

            ni = sqrt(N0)*randn(1,length(x_gauss)); % 1
            yR = x_gauss+ni;

%         yR = awgn(x,dB(i),p);
%         yR = Quantnoise_RX(yR,bitrate);

        samplesPerSymbol = length(yR)/N;
        Etx_downsampled = yR((samplesPerSymbol/2+1):samplesPerSymbol:end);

        y_detect = (sign(Etx_downsampled-0.5)+1)/2;
        bit_R=length(find(x~=y_detect));%统计错误比特数
        P(i)=bit_R/N;%计算误码率
    end
    P_avg = P+P_avg;
end
P_ook = P_avg/loopnum;
end

% plot(f,real(fftshift(fft(x_gauss))),'-.')
% hold on
% plot(f,real(fftshift(fft(x_gauss_filtered))))