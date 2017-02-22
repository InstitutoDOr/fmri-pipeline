clear
C=dlmread('C_01_block.txt');

%Put a little jitter between events
numTR=300; %total TRs
TRdur=2;
numTrialsCond=60;
numCond=3;
minISI=1;
maxISI=4;
for i=minISI:maxISI
    ISI(i)=i;
end

%restBegin=10;
%numTR=(numCond*numTrialsCond)+(meanISI/TRdur)*(numCond*numTrialsCond) + (restBegin/TRdur);

%shuffle=zeros(numTR,1);
shuffle(1:60,1)=1;
shuffle(61:120,1)=2;
shuffle(121:180,1)=3;
%plot(shuffle)
p=randperm(numTrialsCond*numCond); %make a random order to allocate each trial
for i=1:(numTrialsCond*numCond)
    jitter(i,1)=randi(length(ISI));
end

for i=1:size(shuffle)
    shuffled(i,1)=shuffle(p(i),1);
end

c=1;
for i=1:size(shuffled,1)
    switch shuffled(i)
        case 0
            %X(i,1)=0;X(i,2)=0;X(i,3)=0;
        case 1
            X(c,1)=1;X(c,2)=0;X(c,3)=0;
            c=c+1;
            for j=1:jitter(i)
                X(c,1)=0;X(c,2)=0;X(c,3)=0;
                c=c+1;
            end
        case 2
            X(c,1)=0;X(c,2)=1;X(c,3)=0;
            c=c+1;
            for j=1:jitter(i)
                X(c,1)=0;X(c,2)=0;X(c,3)=0;
                c=c+1;
            end
        case 3
            X(c,1)=0;X(c,2)=0;X(c,3)=1;
            c=c+1;
            for j=1:jitter(i)
                X(c,1)=0;X(c,2)=0;X(c,3)=0;
                c=c+1;
            end
    end
end

plot(X)

disp('***************************')
disp('     MADE DESIGN:')
disp(['Conditions: ' num2str(numCond)]);
for i=1:size(X,2)
    disp(['   Trials condition ' num2str(i) ' : ' num2str(sum(X(:,i)))]);
end
disp(['Duration: ' char(secs2hms(size(X,1)*TRdur))]);
disp('***************************')