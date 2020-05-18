files = dir('*.mat');
for file = files'
    nameOfSignal = regexprep(file.name,'m.mat','m.mat');
    Detector(nameOfSignal);
end