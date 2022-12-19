function P_ook = OOK(N,loopnum,dB,snr)
%SER calculation for OOK signal
P_avg = zeros(1,length(dB));
for n = 1:loopnum
    x=randi([0,1],1,N); %产生随机信号
    Eav = norm(x)^2/N; % 1
%     p = pow2db(mean(x.^2));
    for i=1:length(dB)
            N0=Eav/snr(i)/2;%计算噪声功率
%             N0_dB=10*log10(N0);%将噪声功率转换为dBW
%             ni=wgn(1,N,N0_dB);%产生高斯噪声

            ni = sqrt(N0)*randn(1,N); % 1
            yR = x+ni;

%         yR = awgn(x,dB(i),p);

        y_detect = (sign(yR-0.5)+1)/2;
        bit_R=length(find(x~=y_detect));%统计错误比特数
        P(i)=bit_R/N;%计算误码率
    end
    P_avg = P+P_avg;
end
P_ook = P_avg/loopnum;
end