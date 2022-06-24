clc; clear all; close all;

c = imread('Image.jpg');
inputimage=imresize(c,[512,512]);
figure(1),subplot(1,3,1),imshow(inputimage);
title('Original Input Image')
inputimage=rgb2gray(inputimage);

[CA1,CH1,CV1,CD1] = dwt2(inputimage,'db4');
figure(2)
subplot(2,2,1), imshow(uint8(CA1), [0,80]);
title('Approximated Image')
subplot(2,2,2), imshow(uint8(CH1), [0,40]);
title('Horizontal Edge Detected Image')
subplot(2,2,3), imshow(uint8(CV1), [0,40]);
title('Vertical Edge Detected Image')
subplot(2,2,4), imshow(uint8(CD1), [0,40]);
title('Diagonal Edge Detected Image')
outputimage_1 = idwt2(CA1,CH1,CV1,CD1,'db4');
figure(1), subplot(1,3,2), imshow(uint8(outputimage_1))
title('Reconstructed Image considering all subbands')

%Computing MSE and PSNR with all bands
Q = 255; width = 512;
MSE_withallbands = sum(sum((inputimage-uint8(outputimage_1)).^2))/width /width;
fprintf('The MSE with all bands is %f \n', sum(MSE_withallbands)/3);
fprintf('The psnr performance with all bands is %f dB\n', 10*log10(Q*Q/sum(MSE_withallbands)/3));

%% Compressinng image - STEP 1
cv1=CV1*0;
ch1=CH1*0;
cd1=CD1*0;
outputimage_2 = idwt2(CA1,ch1,cv1,cd1,'db4');
figure(1), subplot(1,3,3), imshow(uint8(outputimage_2))
title('Level 1 LL subband reconstruction');
% Computing MSE and PSNR with LL band
MSE_withLLbands = sum(sum((inputimage-uint8(outputimage_2)).^2))/width / width;
fprintf('The MSE with LL bands is %f \n', sum(MSE_withLLbands)/3);
fprintf('The psnr performance with LL bands is %f dB\n', 10*log10(Q*Q/sum(MSE_withLLbands)/3));

%% Compressing image - STEP 2
[CA2,CH2,CV2,CD2] = dwt2(CA1,'db4');
cv2=CV2*0;
ch2=CH2*0;
cd2=CD2*0;
ca1_int = idwt2(CA2,ch2,cv2,cd2,'db4');
outputimage_3 = idwt2(ca1_int(1:259,1:259),ch1,cv1,cd1,'db4');
figure, subplot(1,3,1), imshow(uint8(outputimage_3))
title('Level 2 LL sbuband reconstruction')
% Compressing MSE and PSNR with LL band
MSE_with_level2LLbands = sum(sum((inputimage-uint8(outputimage_3)).^2))/width /width;
fprintf('The MSE with level2 LL bands is %f \n', sum(MSE_with_level2LLbands)/3);
fprintf('The psnr performance with level 2 LL bands is %f dB\n', 10*log10(Q*Q/(sum(MSE_with_level2LLbands)/3)));

%% Compressing image - STEP 3
[CA3,CH3,CV3,CD3] = dwt2(CA2,'db4');
cv3=CV3*0;
ch3=CH3*0;
cd3=CD3*0;
ca2_int = idwt2(CA3,ch3,cv3,cd3,'db4');
ca2_int_1 = idwt2(ca2_int(1:133,1:133),ch2,cv2,cd2,'db4');
outputimage_4 = idwt2(ca2_int_1(1:259,1:259),ch1,cv1,cd1,'db4');
figure(3), subplot(1,3,2), imshow(uint8(outputimage_4))
title('Level 3 LL subband reconstruction')
% Compressing MSE and PSNR with LL band
MSE_with_level3LLbands = sum(sum((inputimage-uint8(outputimage_4)).^2))/width /width;
fprintf('The MSE with level3 LL bands is %f \n', sum(MSE_with_level3LLbands)/3);
fprintf('The psnr performance with level 3 LL bands is %f dB\n', 10*log10(Q*Q/(sum(MSE_with_level3LLbands)/3)));

%% Compressing image - STEP 4
[CA4,CH4,CV4,CD4] = dwt2(CA3,'db4');
cv4=CV4*0;
ch4=CH4*0;
cd4=CD4*0;
ca3_int = idwt2(CA4,ch4,cv4,cd4,'db4');
ca3_int_1 = idwt2(ca3_int,ch3,cv3,cd3,'db4');
ca3_int_2 = idwt2(ca3_int_1(1:133,1:133),ch2,cv2,cd2,'db4');
outputimage_5 = idwt2(ca3_int_2(1:259,1:259),ch1,cv1,cd1,'db4');
figure(3), subplot(1,3,3), imshow(uint8(outputimage_5))
title('Level 4 LL subband reconstruction')
% Compressing MSE and PSNR with LL band
MSE_with_level3LLbands = sum(sum((inputimage-uint8(outputimage_5)).^2))/width /width;
fprintf('The MSE with level3 LL bands is %f \n', sum(MSE_with_level3LLbands)/3);
fprintf('The psnr performance with level 3 LL bands is %f dB\n', 10*log10(Q*Q/(sum(MSE_with_level3LLbands)/3)));
