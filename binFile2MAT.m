function binFile2MAT(~, filenameIn, filenameOut, numColumns, metadata)
%BINFILE2MAT Loads 2-D array of doubles from binary file and saves data to MAT file
% Processes all data in binary file (filenameIn) and saves it to a MAT file without loading
% all data to memory.
% If output MAT file (filenameOut) already exists, data is overwritten (not appended).
% Input binary file is a matrix of doubles with numRows x numColumns
% MAT file (filenameOut) is a MAT file with the following variables
%   timestamps = a column vector ,  the first column in the data from binary file
%   data = a 2-D array of doubles, includes 2nd-last columns in the data from binary file
%   metatada = a structure, which is provided as input argument, used to provide additional
%              data information
%

% If filenameIn does not exist, error out
if ~exist(filenameIn, 'file')
    error('Input binary file ''%s'' not found. Specify a different file name.', filenameIn);
end



% If output MAT file already exists, delete it
if exist(filenameOut, 'file')
    delete(filenameOut)
end

% Determine number of rows in the binary file
% Expecting the number of bytes in the file to be 8*numRows*numColumns
fileInfo = dir(filenameIn);
numRows = floor(fileInfo.bytes/(8*double(numColumns+1)));

% Create matfile object to save data loaded from binary file
matObj = matfile(filenameOut);
matObj.Properties.Writable = true;

% Initialize MAT file
matObj.timestamps(numRows,1) = 0;
matObj.data(1,1) = 0;

% Open input binary file
fid = fopen(filenameIn,'r');

% Specify how many rows to process(load and save) at a time
numRowsPerChunk = 10E+6;

% Keeps track of how many rows have been processed so far
ii = 0;

while(ii < numRows)
    
    % chunkSize = how many rows to process in this iteration
    % If it's the last iteration, it's possible the number of rows left to
    % process is different from the specified numRowsPerChunk
    chunkSize = min(numRowsPerChunk, numRows-ii);
    
    data = fread(fid, [numColumns+1,chunkSize], 'double');
    
    matObj.timestamps((ii+1):(ii+chunkSize), 1) = data(1,:)';
    matObj.data((ii+1):(ii+chunkSize), (1:1:numColumns)) = data(2:end,:)';
    
    ii = ii + chunkSize;
end

fclose(fid);

% Save provided metadata to MAT file
matObj.metadata = metadata;
end
