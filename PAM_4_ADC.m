function P_4 = PAM_4_ADC(N,loopnum,snr,~,symbol_rate,samples)
%SER calculation for 4PAM signal
Rs = symbol_rate;
L = samples;
alpha4pam = [-3 -1 1 3];
alpha4pam_2 = [0 1 2 3];

% x = randsrc(1,N,alpha4pam);
P_avg = zeros(1,length(snr));
for n = 1:loopnum
    x_4= randsrc(1,N,alpha4pam_2);
    x_gauss = pulse_shape(N,Rs,L,x_4);
    Eav = mean(x_4.^2);

    x_gauss = Quantnoise_TX(x_gauss,N,L*2); % Quantnoise_Tx

    for i=1:length(snr)
        N0=Eav/snr(i)/2;% calculate the power of noise

        ni = sqrt(N0)*randn(1,length(x_gauss));
        yR_4 = x_gauss+ni;

        yR_4 = Quantnoise_RX(yR_4,N,L*2);

        samplesPerSymbol = length(x_gauss)/N;
        Etx_downsampled = yR_4((samplesPerSymbol/2+1):samplesPerSymbol:end);

        for k = 1:length(Etx_downsampled)
            if Etx_downsampled(k)< 1/2
                y_detect_4(k) = 0;
            elseif Etx_downsampled(k) < 3/2
                y_detect_4(k) = 1;
            elseif Etx_downsampled(k) < 5/2
                y_detect_4(k) = 2;
            else
                y_detect_4(k) = 3;
            end
        end

        bit_R_4=length(find(x_4~=y_detect_4));% Error Bits
        P_4(i)=bit_R_4/N;% BER
    end
    P_avg = P_4+P_avg;
end
P_4 = P_avg/loopnum;
end


% plot(yR_4(1:160),'LineWidth',2)
% hold on
% scatter((samplesPerSymbol/2+1):samplesPerSymbol:160,yR_4((samplesPerSymbol/2+1):samplesPerSymbol:160),'*','LineWidth',2)
% hold on
% stem((samplesPerSymbol/2+1):samplesPerSymbol:160,y_detect_4(1:10),'LineWidth',2)
% grid on
% hold on
% line([1 160],[0.5 0.5],'LineWidth',1.2,'Color','red','LineStyle','--')
% hold on
% line([1 160],[3/2 3/2],'LineWidth',1.2,'Color','red','LineStyle','--')
% hold on
% line([1 160],[5/2 5/2],'LineWidth',1.2,'Color','red','LineStyle','--')