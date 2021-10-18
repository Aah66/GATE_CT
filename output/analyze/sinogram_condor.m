%this program reads in FBCT projections in the form of .dat files and
%produces a sinogram. From that, a back projection, filtered back
%projection, and an iterative reconstruction are produced.

%projection set (1-4)
projection_set=1;

%number of projection files/angles
numfiles =180;

% number of pixels in detector
LENGTH=512;

%number of splits in cluster
splits=90;

% Set image contrast (must be between 0 and 1, eg. 0.25)
contrast=0.18;

% Set number of iterations for iterative reconstruction (eg. 50)
iterations=1;




%the following is a quick way of reading in files ct_projection_000.dat to
%ct_projection_180.dat 
i=0;
image=0;

for k = 0:9
if (k>(numfiles*i/splits)-2)
    i=i+1;
end     
 

  file = sprintf('../projections%d/ct_projection%d_00%d.dat', projection_set, i, k);
  fp = fopen(file,'rb');
data = fread(fp,LENGTH*1*1,'float32');
image(1:LENGTH,k+1)=[data];
fclose(fp);

 
end

for k = 10:99

if (k>(numfiles*i/splits)-2)
    i=i+1;
end

file = sprintf('../projections%d/ct_projection%d_0%d.dat', projection_set, i, k);
fp = fopen(file,'rb');
data = fread(fp,LENGTH*1*1,'float32');
image(1:LENGTH,k+1)=[data];
fclose(fp);

end

for k = 100:numfiles-2

if (k>(numfiles*i/splits)-2)
    i=i+1;
end     
    
file = sprintf('../projections%d/ct_projection%d_%d.dat', projection_set, i, k);
fp = fopen(file,'rb');
data = fread(fp,LENGTH*1*1,'float32');
image(1:LENGTH,k+1)=[data];

fclose(fp);

end

for k = numfiles-1

if (k>(numfiles*i/splits)-1)
    i=i+1;
end     
    
file = sprintf('../projections%d/ct_projection%d_%d.dat', projection_set, i, k);
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
I1 = iradon(inverted,0:numfiles-1,'linear','none',LENGTH);
I1 = I1 - min(min(abs(I1)));
I1 = I1/max(max(abs(I1)));
I1=imrotate(I1, 270);
I1=flip(I1,2);

%performs filtered back projection
I2 = iradon(inverted,0:numfiles-1,'linear','hann', LENGTH);
I2 = I2 - min(min(abs(I2)));
I2 = I2/max(max(abs(I2)));
I2=imrotate(I2, 270);
I2=flip(I2,2);


%performs iterative reconstruction
I3 = cART(inverted,numfiles, iterations);
I3 = I3 - min(min(abs(I3)));
I3 = I3/max(max(abs(I3)));
I3=imrotate(I3,180);


%shows unfiltered back projection image
figure();
subplot(131)
imshow(I1(:,:,1),[0.5 1]); 

%shows filtered back projection image
subplot(132)
imshow(I2(:,:,1),[0.1 0.5]); 

%shows iterative back projection image
subplot(133)
imshow(I3(:,:,1),[0.1 0.65]); 



%shows inverted sinogram image
figure();
imshow(inverted(:,:,1),[]); 

% %shows non-inverted sinogram image
% figure();
% imshow(image(:,:,1),[]); 
