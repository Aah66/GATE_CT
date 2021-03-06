function A = read_fash_mash(fname)
% read_fash_mash  Read data from compressed FASH/MASH file
%   data = read_fash_mash(filename) reads data from the FASH
%     or MASH phantom file.
%
%   Written by D. Laurenson, The University of Edinburgh, Feb 2020

% First, check that the file exists!
if ~isfile(fname)
    error('read_fash_mash: The file %s does not exist', fname);
end

% Extract the dimensions from the file name (only works as files are named
% in a standard way)
[~,basename,~]=fileparts(fname);
dimensions=sscanf(basename,'%*cash3_s%*c%*c_%dx%dx%d')';

% Calculate the number of bytes in the image
data_size=prod(dimensions);

% Use Java to read, and uncompress the file as a stream - this is faster
% than uncompressing to disk and reading the larger disk file
fileStr=java.io.FileInputStream(fname);
fileStrClose=onCleanup(@()fileStr.close); % Close the stream on exit
inflatedStr=java.util.zip.GZIPInputStream(fileStr);
inflatedStrClose=onCleanup(@()inflatedStr.close); % Close the stream on exit

% Read the data into the destination array, and reshape it to the required
% size
A=reshape(toByteArray(org.apache.commons.io.IOUtils, inflatedStr, ...
    data_size), dimensions);

% Clean up the file streams
inflatedStr.close;
fileStr.close;

end


