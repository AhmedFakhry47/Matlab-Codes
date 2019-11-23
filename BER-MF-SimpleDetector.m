%Comm_Lab
%Ahmed Fakhry
S1 = ones(1,10);
S2 = zeros(1,10);
Num_of_bits = 1e4;
%Matched filter is the same as S1.
Hmf = S1-S2;
waveform=[];
Rx_Cor=[];
%generating random binary sequence of 1e6 bit.
bits = randi(2,[1 Num_of_bits]) -1;
for i= 1:length(bits)
    if(bits(i)==1)
        waveform=[waveform S1];
    else
        waveform=[waveform S2];
    end

end
display('I am here ')
%Signal Power Calculations P=sigma(bits^2)
Signal_Power = sum(bits.^2)/length(bits);
Signal_Power_MF = sum(waveform.^2)/length(waveform);
%calculating BER for each SNR 10 times and taking their average.
N=10;
%SNR with from 0 to 30 dB with 2dB steps
SNR = 0:2:30;
%initializing BER matrix with zeroes
BER = zeros(length(SNR),N);
BER_MF = zeros(length(SNR),N);
BER_Cor = zeros(length(SNR),N);
%Vth by which the decision block takes decision zero or one. 
Threshold = 0.5;
Threshold_MF=5;

%This loop calcualtes the average value of BER per SNR and stores the
%results in BER matrix
%each row in this matrix specifies the BER values per SNR
for i = 1:length(SNR)
    for j = 1:N
      %Received sequence after adding noise based on SNR.
      Rx_sequence = awgn(bits,SNR(i),'measured',j);  
%matched filer
Rx_sequence_MF = awgn(waveform,SNR(i),'measured');
Rx_corelator=Rx_sequence_MF;
Rx_sequence_MF = conv(Rx_sequence_MF,Hmf);


%corellator
Decision = zeros(1,length(bits));
for m = 1:10:length(Rx_corelator)-9
   ten_samples= Rx_corelator(m:m+9);
   %integration_result=sum(ten_samples*transpose(S1));
   integration_result=sum(ten_samples);
   Decision(m) = integration_result > Threshold_MF;
   %Rx_Cor =[Rx_Cor Decision];
end
   Rx_Cor=Decision(1:10:length(Decision));
%sampling the received from MF.
Received_Sampled_MF=Rx_sequence_MF(10:10:length(Rx_sequence_MF));

        %Taking decision of one or zero.
RX= Rx_sequence>Threshold;
RX_MF = Received_Sampled_MF>Threshold_MF;
        %xor the sent bits with the received bits to know which of them was
        %received in error.
error = bitxor(RX,bits);
error_MF = bitxor(RX_MF,bits);
error_Cor = bitxor(Rx_Cor,bits);
        %Calculation of BER N times and taking thier average for each SNR
BER(i,j) = sum(error(:)==1)/length(bits);
BER_MF(i,j) = sum(error_MF(:)==1)/length(bits);
BER_Cor(i,j) = sum(error_Cor(:)==1)/length(bits);
    end 
end

%transpose is made in order to use 'sum()' built in function on the matrix
%to tag=ke the average of the N BER values.
BER=transpose(BER);
BER_AVG = sum(BER)/N;

BER_MF=transpose(BER_MF);
BER_AVG_MF = sum(BER_MF)/N;

BER_Cor=transpose(BER_Cor);
BER_AVG_Cor= sum(BER_Cor)/N;
%plotting BER vs SNR
figure
semilogy(SNR,BER_AVG,'LineWidth',2);
grid on;
xlabel('SNR');
ylabel('BER_simpleDetector');
figure
semilogy(SNR,BER_AVG_MF,'LineWidth',2);
grid on;
xlabel('SNR');
ylabel('BERMF');
figure
semilogy(SNR,BER_AVG_Cor,'LineWidth',2);
grid on;
xlabel('SNR');
ylabel('BERCor');
