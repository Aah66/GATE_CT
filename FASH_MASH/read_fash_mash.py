# Code created by D. Laurenson, The University of Edinburgh, Feb 2020

import gzip
import os.path
import numpy as np

def read_fash_mash(fname):
    """read_fash_mash reads in the compressed data
    file for the FASH/MASH 3 phantoms, and returns
    the data in an appropriate sized numpy array.
    
    Usage: phantom=read_fash_mash(compressed_filename)
    """

    # Read in the data if the file exists
    if os.path.isfile(fname):
        with gzip.open(fname, 'rb') as f:
            myArr = bytearray(f.read())
            f.close()
    else:
        print("File does not exist")
        return([])

    # To determine the size, we need to analyse the
    # filename.  Start by removing the .dat.gz
    without_ext = fname.split('.dat.gz')

    # and split at underscores
    components = (without_ext[0]).split('_');

    # get size_string which is the last segment, and
    # split it into its individual dimensions
    sizestr = (components[-1]).split('x');

    # Extract the dimensions as integers
    x=int(sizestr[0]);
    y=int(sizestr[1]);
    z=int(sizestr[2]);

    # Reshape the data to the required dimensions
    phantom = np.array(myArr).reshape(x, y, z, order='F')

    return(phantom)

# import matplotlib.pyplot
# 
# fname='FASH_MASH_standing/fash3_sta_442x256x1354.dat.gz'
# phantom=read_fash_mash(fname);
# matplotlib.pyplot.imshow(phantom[:,:,240])
# matplotlib.pyplot.show()
