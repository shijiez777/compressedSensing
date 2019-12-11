addpath('../l1minimization/');
addpath('../imgCorruption/');


imgDataDir = "/home/fatken/data/CompressedSensing/CroppedYaleProcessed/data.mat";

data = load(imgDataDir);
data = data.c;
noClasses = data.Count;
classes = string(data.keys);
[imgsPerClass, imgPixels] = size(data(classes(1)));
imgH = 192;
imgW = 168;


% parameters for the dictionary
trainRatio = 0.8;
imgPerClassinDictionary = uint64(imgsPerClass*trainRatio);
testImgNoPerClass = imgsPerClass - imgPerClassinDictionary;


% dimension reduction matrix
reducingConstant = 120;
dimRedMat = randn(reducingConstant, imgPixels);

%% generate phi, psi matrix and test set
phi = zeros(imgPixels, noClasses * imgPerClassinDictionary);
psi = eye(noClasses*imgPerClassinDictionary);
testSet = containers.Map;

for classId = 1: noClasses
    className = classes(classId);
    testSet(className) = zeros(testImgNoPerClass, imgPixels);

    tmpImgMat = data(className);
    randInds = randperm(imgsPerClass);
    for phiIdx = 1:int16(imgPerClassinDictionary)
        phi(:, int16((classId-1) * imgPerClassinDictionary) + phiIdx) = tmpImgMat(randInds(phiIdx), :);
    end
    testImgIdx = randInds(imgsPerClass - testImgNoPerClass +1 : imgsPerClass);
    testSet(className) = tmpImgMat(testImgIdx, :);
end


% reduce dimension of phi
dimRedPhi = dimRedMat * phi;


%% Accuracy - gaussian noise 0.1
% select random image as test
% correctPredictionCount = 0;
% misclassificationIdx = 1;
% for classId = 1:noClasses
%     disp(classId)
%     testDataMat = testSet(classes(classId));
%     for j = 1: testImgNoPerClass
%         y = testDataMat(j, :);
%         y = y(:);
%         % yNoise = y + 0.1 * randn(size(y));
%         yNoise = y;
% 
%         dimRedY = dimRedMat * yNoise;
%         [~, x_hat, itera] = standardLP(dimRedPhi, psi, dimRedY, 0, 0);
%         predictionIdx = predict(x_hat, imgPerClassinDictionary, noClasses);
%         if predictionIdx == classId
%             correctPredictionCount = correctPredictionCount + 1;
%         else
%             result = recover(predictionIdx, x_hat, phi, imgPerClassinDictionary);
%             result = normalize(result, 'range');
%             saveFileName = "/home/fatken/data/CompressedSensing/results/misclassification/" + misclassificationIdx + ".png";
%             displayResult(y, yNoise, result, classId, predictionIdx, 1, saveFileName, misclassificationIdx);
%             % saveas(misclassificationIdx, saveFileName);
%             misclassificationIdx = misclassificationIdx + 1;
%         end
%     end
% end
% sprintf("prediction accuracy: %f\n", correctPredictionCount/double((testImgNoPerClass * noClasses)));





%% Uniform noise clissification and recover
noiseRatios = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]; %
accuracies = zeros(size(noiseRatios));
counter = 1;
for ratioIdx = 1: length(noiseRatios)
    noiseRatio = noiseRatios(ratioIdx);
    
    
    correctPredictionCount = 0;
    misclassificationIdx = 1;
    for classId = 1:noClasses
        disp(classId)
        testDataMat = testSet(classes(classId));
        for j = 1: testImgNoPerClass
            y = testDataMat(j, :);
            y = y(:);
            yNoise = uniformCorrupt(y, noiseRatio);
            % yNoise = y;

            dimRedY = dimRedMat * yNoise;
            [~, x_hat, itera] = standardLP(dimRedPhi, psi, dimRedY, 0, 0);
            predictionIdx = predict(x_hat, imgPerClassinDictionary, noClasses);
            if predictionIdx == classId
                %result = recover(predictionIdx, x_hat, phi, imgPerClassinDictionary);
                %result = normalize(result, 'range');
                %saveFileName = "/home/fatken/data/CompressedSensing/results/uniformRecover/" + counter + ".png";
                %displayResult(y, yNoise, result, classId, predictionIdx, 0, saveFileName, counter);
                correctPredictionCount = correctPredictionCount + 1;
            else
                %result = recover(predictionIdx, x_hat, phi, imgPerClassinDictionary);
                %result = normalize(result, 'range');
                %saveFileName = "/home/fatken/data/CompressedSensing/results/uniformRecoverMisclassification/" + counter + ".png";
                %displayResult(y, yNoise, result, classId, predictionIdx, 0, saveFileName, counter);
                % saveas(misclassificationIdx, saveFileName);
                misclassificationIdx = misclassificationIdx + 1;
            end
            counter = counter + 1;
        end
    end 
    accuracies(ratioIdx) = correctPredictionCount/double((testImgNoPerClass * noClasses));
end    
    
% sprintf("prediction accuracy: %f\n", correctPredictionCount/double((testImgNoPerClass * noClasses)));






%% Visualization
% display the original image, the corrupted image, the recovery result, and
% difference
function displayResult(y, yNoise, result, label, prediction, saveFlag, saveFileName, misclassificationIdx)
    difference = abs(y - result);
    % montage([reshape(y, 192, 168), reshape(yNoise, 192, 168), reshape(result, 192, 168), reshape(difference, 192, 168)]);

    % figure(1);
    figure('Name', '1', 'Position', [100, 100, 1200, 300]);
    subplot(1,4,1)
    imshow(reshape(y, 192, 168));
    title(['original: ' num2str(label)]);
    
    subplot(1,4,2)
    imshow(reshape(yNoise, 192, 168));
    title('corrupted');
    
    subplot(1,4,3)
    imshow(reshape(result, 192, 168));
    title(['recovered: ' num2str(prediction)]);
    
    subplot(1,4,4)
    imshow(reshape(difference, 192, 168));
    title('diff');
    if saveFlag
        saveas(misclassificationIdx, saveFileName);
    end
end


% % select random image as test
% yClass = randperm(length(classes), 1);
% yImgIdx = randperm(imgsPerClass, 1);
% yTmpMat = data(classes(yClass));
% y = yTmpMat(yImgIdx, :);
% y = y(:);
% 
% % noise generating function
% % gaussian noise 
% yNoise = y + 0.1 * randn(size(y));
% dimRedY = dimRedMat * yNoise;
% 
% [~, x_hat, itera] = standardLP(dimRedPhi, psi, dimRedY, 0, 0);
% 
% predictionIdx = predict(x_hat, imgPerClassinDictionary, noClasses);
% result = recover(predictionIdx, x_hat, phi, imgPerClassinDictionary);
% result = normalize(result, 'range');
% 
% % res = phi*x_hat;
% 
% 
% 
% 
% 
% 
% difference = abs(y - result);
% montage([reshape(y, 192, 168), reshape(yNoise, 192, 168), reshape(result, 192, 168), reshape(difference, 192, 168)]);
% 






%% Funcitions
function [predictionIdx]= predict(x_hat, imgPerClassinDictionary, noClasses)
    % Find the class by the largest sum of values of a class
    maxSum = 0;
    predictionIdx = 0;
    for classIdx = 1:noClasses
        tmpSum = sum(x_hat((classIdx -1)*imgPerClassinDictionary +1:classIdx * imgPerClassinDictionary, 1));
        if tmpSum > maxSum
            maxSum = tmpSum;
            predictionIdx = classIdx;
        end
    end
end


function [result]= recover(predictionIdx, x_hat, phi, imgPerClassinDictionary)
    % keep values in x_hat only related to predictionIdx and set all other
    % cells to 0.
    % generate recovered image by result = phi * new_x_hat
    new_x_hat = zeros(size(x_hat));
    new_x_hat((predictionIdx -1)*imgPerClassinDictionary +1:predictionIdx * imgPerClassinDictionary, 1) = x_hat((predictionIdx -1)*imgPerClassinDictionary +1:predictionIdx * imgPerClassinDictionary, 1);
    result = phi * new_x_hat;
end









