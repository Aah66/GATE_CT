%this program reads in FBCT projections in the form of .dat files and
%produces a sinogram and from that, a back projection and a filtered back
%projection.


%number of projection files/angles
numfiles =180;

% number of pixels in detector
LENGTH=250;

% Set image contrast (must be between 0 and 1, eg. 0.25)
contrast=0.25;

% Set number of iterations for iterative reconstruction (eg. 50)
iterations=1;




%the following is a quick way of reading in files ct_projection_000.dat to
%ct_projection_180.dat 
image = 0;
for k = 0:9
  file = sprintf('/home/s1606384/GATE-build/Gate-8.2/FBCT_phantom/output/projections/ct_projection_00%d.dat', k);
  fp = fopen(file,'rb');
data = fread(fp,LENGTH*1*1,'float32');
image(1:LENGTH,k+1)=[data];
fclose(fp);
end

for k = 10:99
  file = sprintf('/home/s1606384/GATE-build/Gate-8.2/FBCT_phantom/output/projections/ct_projection_0%d.dat', k);
  fp = fopen(file,'rb');
data = fread(fp,LENGTH*1*1,'float32');
image(1:LENGTH,k+1)=[data];

fclose(fp);
end

for k = 100:179
  file = sprintf('/home/s1606384/GATE-build/Gate-8.2/FBCT_phantom/output/projections/ct_projection_%d.dat', k);
  fp = fopen(file,'rb');
data = fread(fp,LENGTH*1*1,'float32');
image(1:LENGTH,k+1)=[data];

fclose(fp);
end

% rescale max and min values of sinogram to between 0 and 1
image = image - min(min(abs(image)));
image = image/max(max(abs(image)));

% adjust contrast to optimise visibility
image = imadjust(image, [0 contrast], [0 1]);

%invert sinogram 
inverted=imcomplement(image);

% performs unfiltered back projection
I1 = iradon(inverted,0:numfiles-1,'linear','none');

I1 = I1 - min(min(abs(I1)));
I1 = I1/max(max(abs(I1)));

%performs filtered back projection
I2 = iradon(inverted,0:numfiles-1,'linear','Hamming');
I2 = I2 - min(min(abs(I2)));
I2 = I2/max(max(abs(I2)));

%performs iterative reconstruction
I3 = cART(inverted,180, iterations);


%shows unfiltered back projection image
figure();
subplot(131)
imshow(I1(:,:,1),[]); 

%shows filtered back projection image
subplot(132)
imshow(I2(:,:,1),[]); 

%shows filtered back projection image
subplot(133)
imshow(I3(:,:,1),[]); 


%shows inverted sinogram image
figure();
imshow(inverted(:,:,1),[]); 

%shows non-inverted sinogram image
figure();
imshow(image(:,:,1),[]); 


