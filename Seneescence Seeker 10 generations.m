clear
clc

Cx = 2328; 
Cy = 1430;
radius = 653;
sense = 0.80;
range = [2 40]

basefolder = 'C:\Users\aleja\OneDrive\Desktop\1[B6]Y28\'
InputFolder = strcat(basefolder,'Input\')
OutputFolder = strcat(basefolder,'Output\')

PennyPos = [2500,200,900,600]

filePattern = fullfile(InputFolder, '*.jpg');
theFiles = dir(filePattern);
SE = offsetstrel('ball',100,5);

A = {};




%Preprocessing
for K = [1:length(theFiles)]
    
    OriginalImage = imread(theFiles(K).name);		%Loads image into workspace
    GrayImage = rgb2gray(OriginalImage);	%Converts to black and white
    InvertedGrayImage = 255-GrayImage;       %inverts the colors, white to black
    NoBack = imtophat(InvertedGrayImage,SE);	%Subtracts Background
    ThresholdedImage = NoBack <= 20;        %Thresholds image
    [Height, Width] = size(ThresholdedImage);
    fprintf(theFiles(K).name)

%imshow(ThresholdedImage)
hold on 
PennyRegion = images.roi.Rectangle(gca,'Position',PennyPos);
PennyRegionMask = PennyRegion.createMask(ThresholdedImage);
IInew = ThresholdedImage.*PennyRegionMask;
imshow(IInew)

[Penny1center,Penny1radius] = imfindcircles(IInew,[100,150],'ObjectPolarity','dark','Sensitivity',.99);

figure;imshow(IInew);
viscircles(Penny1center, Penny1radius, 'EdgeColor', 'b')

ConvPix2MM = (9.525/150)
    
    
    

PitriDish = images.roi.Circle(gca,'Center',[Cx Cy],'Radius',radius)

BW = PitriDish.createMask(ThresholdedImage);
Inew = ThresholdedImage.*BW;

VerticalLine = line([Cx Cx],[0 Height]);
HorizontalLine = line([0 Width],[Cy Cy]);
hold off

Q1 = Inew([1:int16(Cy)],[1:int16(Cx)]);
Q2 = Inew([1:int16(Cy)],[int16(Cx):Width]);
Q3 = Inew([int16(Cy):Height],[1:int16(Cx)]);
Q4 = Inew([int16(Cy):Height],[int16(Cx):Width]);


[Q1c,Q1r] = imfindcircles(Q1,range,'ObjectPolarity','dark', ...
'Sensitivity',sense,'Method','twostage');
[count(K).Q1,trash] = size(Q1c)

[Q2c,Q2r] = imfindcircles(Q2,range,'ObjectPolarity','dark', ...
'Sensitivity',sense,'Method','twostage');
[count(K).Q2,trash] = size(Q2c)

[Q3c,Q3r] = imfindcircles(Q3,range,'ObjectPolarity','dark', ...
'Sensitivity',sense,'Method','twostage');
[count(K).Q3,trash] = size(Q3c)

[Q4c,Q4r] = imfindcircles(Q4,range,'ObjectPolarity','dark', ...
'Sensitivity',sense,'Method','twostage');
[count(K).Q4,trash] = size(Q4c)



figure;imshow(Q1);
viscircles(Q1c, Q1r, 'EdgeColor', 'b')
saveas(gcf,[OutputFolder,'Q1_',theFiles(K).name])
close all

figure;imshow(Q2);
viscircles(Q2c, Q2r, 'EdgeColor', 'r');
saveas(gcf,[OutputFolder,'Q2_',theFiles(K).name])
close all

figure;imshow(Q3);
viscircles(Q3c, Q3r, 'EdgeColor', 'g');
saveas(gcf,[OutputFolder,'Q1_',theFiles(K).name])
close all

figure;imshow(Q4);
viscircles(Q4c, Q4r, 'EdgeColor', 'y');
saveas(gcf,[OutputFolder,'Q4_',theFiles(K).name])
close all


Q1circ = imread([OutputFolder,'Q1_',theFiles(K).name]);
Q1circcrop = imcrop(Q1circ,[117 24 350 248]);


Q2circ = imread([OutputFolder,'Q2_',theFiles(K).name]);
Q2circcrop = imcrop(Q2circ,[117 24 350 248]);
imshow(Q2circcrop)

Q3circ = imread([OutputFolder,'Q2_',theFiles(K).name]);
Q3circcrop = imcrop(Q3circ,[117 24 350 248]);
imshow(Q3circcrop)

Q4circ = imread([OutputFolder,'Q1_',theFiles(K).name]);
Q4circcrop = imcrop(Q4circ,[117 24 350 248]);
imshow(Q4circcrop);

AllImages(K).First = Q1circcrop
AllImages(K).Second = Q2circcrop
AllImages(K).Third = Q3circcrop
AllImages(K).Fourth = Q4circcrop



AllQuadrants(K).First = times(Q1r,ConvPix2MM)
AllQuadrants(K).Second = times(Q2r,ConvPix2MM)
AllQuadrants(K).Third = times(Q3r,ConvPix2MM)
AllQuadrants(K).Fourth = times(Q4r,ConvPix2MM)

FirstAv = median(AllQuadrants(1).First)
SecondAv = median(AllQuadrants(1).Second)
ThirdAv = median(AllQuadrants(1).Third)
FourthAv = median(AllQuadrants(1).Fourth)

Corrected(K).First = (AllQuadrants(K).First/FirstAv)
Corrected(K).Second = (AllQuadrants(K).Second/SecondAv)
Corrected(K).Third = (AllQuadrants(K).Third/ThirdAv)
Corrected(K).Fourth = (AllQuadrants(K).Fourth/FourthAv)


Q2rM = median(Q2r) 
AllQuadrants(K).NormFirst = (Q1r/Q2rM)
AllQuadrants(K).NormSecond = (Q2r/Q2rM)
AllQuadrants(K).NormThird = (Q3r/Q2rM)
AllQuadrants(K).NormFourth = (Q4r/Q2rM)
 
end

SizeTable = struct2table(count)
SizeArray = table2array(SizeTable)
for P = [1:10]


%First
   if(SizeArray(P,1) > 80)
    MyColor(P).First =  "g"
   elseif(SizeArray(P,1)>40)
       MyColor(P).First = "y"
   else
       MyColor(P).First = "r"
   end   
  %Second
   if(SizeArray(P,2) > 80)
    MyColor(P).Second =  "g"
   elseif(SizeArray(P,1)>40)
       MyColor(P).Second = "y"
   else
       MyColor(P).Second = "r"   
       
   end   
 %Third
   if(SizeArray(P,2) > 80)
    MyColor(P).Third =  "g"
   elseif(SizeArray(P,1)>40)
       MyColor(P).Third = "y"
   else
       MyColor(P).Third = "r"  
   end    
  %Fourth
 if(SizeArray(P,2) > 80)
    MyColor(P).Fourth =  "g"
   elseif(SizeArray(P,1)>40)
       MyColor(P).Fourth = "y"
   else
       MyColor(P).Fourth = "r"  
       
 end
end
TestColor = struct2cell(MyColor)

TestColor2 = reshape(TestColor,[40,1])
  
TestColor2 = flip(reshape(TestColor,[40,1]))


hold on
%Images for Generations 1-4
subplot(4,4,1);subimage(AllImages(1).First);title(count(1).Q1)
subplot(4,4,2);subimage(AllImages(1).Second);title(count(1).Q2)
subplot(4,4,3);subimage(AllImages(1).Third);title(count(1).Q3)
subplot(4,4,4);subimage(AllImages(1).Fourth);title(count(1).Q4)

subplot(4,4,5);subimage(AllImages(2).First);title(count(2).Q1)
subplot(4,4,6);subimage(AllImages(2).Second);title(count(2).Q2)
subplot(4,4,7);subimage(AllImages(2).Third);title(count(2).Q3)
subplot(4,4,8);subimage(AllImages(2).Fourth);title(count(2).Q4)

subplot(4,4,9);subimage(AllImages(3).First);title(count(3).Q1)
subplot(4,4,10);subimage(AllImages(3).Second); title(count(3).Q2)
subplot(4,4,11);subimage(AllImages(3).Third);title(count(3).Q3)
subplot(4,4,12);subimage(AllImages(3).Fourth);title(count(3).Q4)

subplot(4,4,13);subimage(AllImages(4).First);title(count(4).Q1)
subplot(4,4,14);subimage(AllImages(4).Second);title(count(4).Q2)
subplot(4,4,15);subimage(AllImages(4).Third);title(count(4).Q3)
subplot(4,4,16);subimage(AllImages(4).Fourth);title(count(4).Q4)

%Images for Gen 5 -8
subplot(4,4,1);subimage(AllImages(5).First);title(count(5).Q1)
subplot(4,4,2);subimage(AllImages(5).Second);title(count(5).Q2)
subplot(4,4,3);subimage(AllImages(5).Third);title(count(5).Q3)
subplot(4,4,4);subimage(AllImages(5).Fourth);title(count(5).Q4)

subplot(4,4,5);subimage(AllImages(6).First);title(count(6).Q1)
subplot(4,4,6);subimage(AllImages(6).Second);title(count(6).Q2)
subplot(4,4,7);subimage(AllImages(6).Third);title(count(6).Q3)
subplot(4,4,8);subimage(AllImages(6).Fourth);title(count(6).Q4)

subplot(4,4,9);subimage(AllImages(7).First);title(count(7).Q1)
subplot(4,4,10);subimage(AllImages(7).Second);title(count(7).Q2)
subplot(4,4,11);subimage(AllImages(7).Third);title(count(7).Q3)
subplot(4,4,12);subimage(AllImages(7).Fourth);title(count(7).Q4)

subplot(4,4,13);subimage(AllImages(8).First);title(count(8).Q1)
subplot(4,4,14);subimage(AllImages(8).Second);title(count(8).Q2)
subplot(4,4,15);subimage(AllImages(8).Third);title(count(8).Q3)
subplot(4,4,16);subimage(AllImages(8).Fourth);title(count(8).Q4)







%Images for Gen 9-10
subplot(2,4,1);subimage(AllImages(9).First);title(count(9).Q1)
subplot(2,4,2);subimage(AllImages(9).Second);title(count(9).Q2)
subplot(2,4,3);subimage(AllImages(9).Third);title(count(9).Q3)
subplot(2,4,4);subimage(AllImages(9).Fourth);title(count(9).Q4)

subplot(2,4,5);subimage(AllImages(10).First);title(count(10).Q1)
subplot(2,4,6);subimage(AllImages(10).Second);title(count(10).Q2)
subplot(2,4,7);subimage(AllImages(10).Third);title(count(10).Q3)
subplot(2,4,8);subimage(AllImages(10).Fourth);title(count(10).Q4)



%RawPlot:
A = padcat (AllQuadrants(:).First, AllQuadrants(:).Second, AllQuadrants(:).Third, AllQuadrants(:).Fourth)

[F G] = size(A)

g1 = repmat([1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4],F,1);
g2 = repmat('ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-_+=',F,1);
zv1 = A(:);
gp1 = g1(:);
gp2 = g2(:);
boxplot(zv1,{gp1,gp2},'factorgap',[50,0],'plotstyle', 'compact');
handle = get(get(gca,'children'),'children');
for r = [1:10]
set(handle(241-r),'Color',string(TestColor2(40-(times(4,r)-3))))
end
for r = [0:9]
set(handle(230-r),'Color', string(TestColor2(40-(times(4,r)+2))))
end
for r = [0:9]
set(handle(220-r),'Color', string(TestColor2(40-(times(4,r)+3))))
end
for r = [0:9]
set(handle(210-r),'Color', string(TestColor2(40-(times(4,r)))))
end


%Normalized Plot%
A = padcat (AllQuadrants(:).NormFirst, AllQuadrants(:).NormSecond, AllQuadrants(:).NormThird, AllQuadrants(:).NormFourth) 

[F G] = size(A)


g3 = repmat([1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4],F,1);
g4 = repmat('ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-_+=',F,1);
zv2 = A(:);
gp3 = g3(:);
gp4 = g4(:);
boxplot(zv2,{gp3,gp4},'factorgap',[50,0],'plotstyle', 'compact');
handle = get(get(gca,'children'),'children');
for r = [1:10]
set(handle(241-r),'Color',string(TestColor2(40-(times(4,r)-3))))
end
for r = [0:9]
set(handle(230-r),'Color', string(TestColor2(40-(times(4,r)+2))))
end
for r = [0:9]
set(handle(220-r),'Color', string(TestColor2(40-(times(4,r)+3))))
end
for r = [0:9]
set(handle(210-r),'Color', string(TestColor2(40-(times(4,r)))))
end



%CorrectedPlot:
A = padcat (Corrected(:).First, Corrected(:).Second, Corrected(:).Third, Corrected(:).Fourth)


[F G] = size(A)

g5 = repmat([1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4],F,1);
g6 = repmat('ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-_+=',F,1);
zv3 = A(:);
gp5 = g5(:);
gp6 = g6(:);
boxplot(zv3,{gp5,gp6},'factorgap',[50,0], 'plotstyle', 'compact');
handle = get(get(gca,'children'),'children');
for r = [1:10]
set(handle(241-r),'Color',string(TestColor2(40-(times(4,r)-3))))
end
for r = [0:9]
set(handle(230-r),'Color', string(TestColor2(40-(times(4,r)+2))))
end
for r = [0:9]
set(handle(220-r),'Color', string(TestColor2(40-(times(4,r)+3))))
end
for r = [0:9]
set(handle(210-r),'Color', string(TestColor2(40-(times(4,r)))))
end




for (n = [1:10])
    [h,p,ci,stats] = ttest2(AllQuadrants(n).Second,AllQuadrants(n).First)
RejectNull(n).FirsttoSecond = h
PVals(n).FirsttoSecond = p

   [h,p,ci,stats] = ttest2(AllQuadrants(n).Second,AllQuadrants(n).Third)
RejectNull(n).ThirdtoSecond = h
PVals(n).ThirdtoSecond = p

 [h,p,ci,stats] = ttest2(AllQuadrants(n).Second,AllQuadrants(n).Fourth)
RejectNull(n).FourthtoSecond = h
PVals(n).FourthtoSecond = p

    [h,p,ci,stats] = ttest2(AllQuadrants(n).Fourth,AllQuadrants(n).Third)
RejectNull(n).FourthtoThird = h
PVals(n).FourthtoThird = p

  [h,p,ci,stats] = ttest2(AllQuadrants(n).First,AllQuadrants(n).Third)
RejectNull(n).FirsttoThird = h
PVals(n).FirsttoThird = p
end


RejectNullTable = struct2table(RejectNull);
     disp(RejectNullTable)

PValsTab = struct2table(PVals)
disp(PValsTab)
