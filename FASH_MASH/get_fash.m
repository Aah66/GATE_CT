data = read_fash_mash('FASH_MASH_standing/fash3_sta_442x256x1354.dat.gz');

figure()
subplot(131)
imshow(data(101:342,1:256,500))
subplot(132)
imshow(data(101:342,1:256,510))
subplot(133)
imshow(data(101:342,1:256,520))
B=data(101:342,1:256,501:520);
C=reshape(B,[242,256,1,20]);


% dicomwrite(C, '/home/s1606384/GATE-build/Gate-8.2/FBCT_phantom/abdomen2.dcm')


