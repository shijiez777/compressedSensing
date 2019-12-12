clear all
clc
close all

% addpath('./Utils/rwt-master/src');
addpath('./Data');
addpath('./Recon');
addpath('../../rwt/bin');

% load image
% boat256.tif, brain256.png, phantom.png
imgName = 'phantom.png';
img = imread(imgName);
if length(size(img)) == 3
    
    img = double(rgb2gray(img));
else
    img = double(img);
end
img = img./max(img(:));
[DIM1,DIM2] = size(img);

% n = 8; % patch size
% N = n^2; % vectorization later
K = 10; % sparsity
lambda = 0.1; % regularization parameter for tradeoff btw data fitting and l1 norm
M = round(3*K); % number of measurments
h = daubcqf(4,'min'); % setting for wavelet filter
% L = log2(N); % setting for wavelet filter (level)

param.L = K;
noise = 0;
Ms = [K 2*K 3*K 4*K 5*K];%6*K 7*K 8*K 9*K 10*K
% psnrs = zeros(size(Ms));

% sensingMatrixCase = "gaussian";
% measurementVector = "dct";
% optiAlgoCase = "ALM";

% for MIdx = 1:length(Ms)
%     M = Ms(MIdx);
%     psnrs(MIdx) = experiment(img, n, K, M, DIM1, DIM2, noise, sensingMatrixCase,measurementVector, optiAlgoCase);
% end


psnrsContainer = containers.Map;
sensingMatrixCase = "gaussian";
measurementVector = "dct";
% if measurementVector == "dwt"
%     n = 128;
% else
%     n = 8;
% end
n = 8; % patch size

N = n^2; % vectorization later
L = log2(N); % setting for wavelet filter (level)




optiAlgoCases = ["OMP" "SP" "ALM" "GPSR"];% 
for i = 1:length(optiAlgoCases)
    optiAlgoCase = optiAlgoCases(i);
    psnrs = zeros(size(Ms));
    for MIdx = 1:length(Ms)
        M = Ms(MIdx);
        psnrs(MIdx) = experiment(img, n, K, h, L, M, DIM1, DIM2, noise, lambda, sensingMatrixCase,measurementVector, optiAlgoCase);

    end
        psnrsContainer(optiAlgoCase) = psnrs;

end

drawPsnrs(psnrsContainer, Ms, measurementVector, sensingMatrixCase);
imgNameSplit = split(imgName, '.');
imgNameSplit = imgNameSplit{1};
saveFileName = "/home/fatken/googleDrive/BU/cs591C1 compressed sensing/assignments/hw5/" + imgNameSplit + "_" + measurementVector + "_" + sensingMatrixCase + ".jpg";
saveas(1, saveFileName);




function drawPsnrs(psnrContainer, Ms, measurementVector, sensingMatrixCase)
    tmpkeys = keys(psnrContainer);
    figure()
    for i = 1:length(psnrContainer)
        key = tmpkeys{i};
        hold on
        plot(Ms, psnrContainer(key))
        hold off
    end
    legend(tmpkeys, "Location", "northwest")
    title("measurement vector: " +measurementVector + " sensing matrix: " + sensingMatrixCase)    
end










