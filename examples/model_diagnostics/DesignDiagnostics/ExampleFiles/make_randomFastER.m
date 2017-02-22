clear
C=dlmread('C_01_block.txt');

% Make a completely random Fast ER design
numTR=300;
%for i=1:numRegs
numCond=3;
TRdur=2;
numTrialsCond=60;
shuffle(1:60,1)=1;
shuffle(61:120,1)=2;
shuffle(121:180,1)=3;
%plot(shuffle)
shuffle(181:numTR)=0;
p=randperm(300); %make a random order to allocate each trial
for i=1:numTR
    switch shuffle(p(i))
        case 0
            X(i,1)=0;X(i,2)=0;X(i,3)=0;
        case 1
            X(i,1)=1;X(i,2)=0;X(i,3)=0;
        case 2
            X(i,1)=0;X(i,2)=1;X(i,3)=0;
        case 3
            X(i,1)=0;X(i,2)=0;X(i,3)=1;
    end
end 

disp('***************************')
disp('     MADE DESIGN:')
disp(['Conditions: ' num2str(numCond)]);
for i=1:size(X,2)
    disp(['   Trials condition ' num2str(i) ' : ' num2str(sum(X(:,i)))]);
end
disp(['Duration: ' char(secs2hms(size(X,1)*TRdur))]);
disp('***************************')