clear
clc

%pitri dish coordinates%
Cx = 2400;
Cy = 1600;
radius = 580;
sense = 0.83
range = [2 15]
myFolder = 'C:\Users\aleja\OneDrive\Documents\MATLAB Real\Unanalyzed Data\Trial 1s\28 Degrees\1[B6]_28\1[B6]P28\Input';


filePattern = fullfile(myFolder, '*.jpg');
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

hold on 
imshow(ThresholdedImage) 
PitriDish = images.roi.Circle(gca,'Center',[Cx Cy],'Radius',radius)

BW = PitriDish.createMask(ThresholdedImage);
Inew = ThresholdedImage.*BW;

% VerticalLine = line([Cx Cx],[0 Height]);
% HorizontalLine = line([0 Width],[Cy Cy]);
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



% figure;imshow(Q1);
% viscircles(Q1c, Q1r, 'EdgeColor', 'b')
% %saveas(gcf,['C:\Users\aleja\OneDrive\Documents\MATLAB Real\Unanalyzed Data\Trial 1s\28 Degrees\1[A8]_28\1[A8]Y28\Output\Q1_.',theFiles(K).name,'.jpg'])
% close all
% 
% figure;imshow(Q2);
% viscircles(Q2c, Q2r, 'EdgeColor', 'r');
% %saveas(gcf,['C:\Users\aleja\OneDrive\Documents\MATLAB Real\Unanalyzed Data\Trial 1s\28 Degrees\1[A8]_28\1[A8]Y28\Output\Q2_.',theFiles(K).name,'.jpg'])
% close all
% 
% figure;imshow(Q3);
% viscircles(Q3c, Q3r, 'EdgeColor', 'g');
% %saveas(gcf,['C:\Users\aleja\OneDrive\Documents\MATLAB Real\Unanalyzed Data\Trial 1s\28 Degrees\1[A8]_28\1[A8]Y28\Output\Q3_.',theFiles(K).name,'.jpg'])
% close all
% 
% figure;imshow(Q4);
% viscircles(Q4c, Q4r, 'EdgeColor', 'y');
% %saveas(gcf,['C:\Users\aleja\OneDrive\Documents\MATLAB Real\Unanalyzed Data\Trial 1s\28 Degrees\1[A8]_28\1[A8]Y28\Output\Q4_.',theFiles(K).name,'.jpg'])
% close all
% 
% 
% Q1circ = imread(['C:\Users\aleja\OneDrive\Documents\MATLAB Real\Unanalyzed Data\Trial 1s\28 Degrees\1[A8]_28\1[A8]P28\Output\Q1_.',theFiles(K).name,'.jpg']);
% Q1circcrop = imcrop(Q1circ,[932 452 401 309]);
% 
% 
% Q2circ = imread(['C:\Users\aleja\OneDrive\Documents\MATLAB Real\Unanalyzed Data\Trial 1s\28 Degrees\1[A8]_28\1[A8]P28\Output\Q2_.',theFiles(K).name,'.jpg']);
% Q2circcrop = imcrop(Q2circ,[154 464 339 313]);
% imshow(Q2circcrop)
% 
% Q3circ = imread(['C:\Users\aleja\OneDrive\Documents\MATLAB Real\Unanalyzed Data\Trial 1s\28 Degrees\1[A8]_28\1[A8]P28\Output\Q3_.',theFiles(K).name,'.jpg']);
% Q3circcrop = imcrop(Q3circ,[671 40 250 261]);
% 
% 
% Q4circ = imread(['C:\Users\aleja\OneDrive\Documents\MATLAB Real\Unanalyzed Data\Trial 1s\28 Degrees\1[A8]_28\1[A8]P28\Output\Q4_.',theFiles(K).name,'.jpg']);
% Q4circcrop = imcrop(Q4circ,[117 24 350 248]);
% imshow(Q4circcrop);

% AllImages(K).First = Q1circcrop
% AllImages(K).Second = Q2circcrop
% AllImages(K).Third = Q3circcrop
% AllImages(K).Fourth = Q4circcrop



AllQuadrants(K).First = Q1r
AllQuadrants(K).Second = Q2r
AllQuadrants(K).Third = Q3r
AllQuadrants(K).Fourth = Q4r

Q2rM = median(Q2r) 
AllQuadrants(K).NormFirst = (Q1r/Q2rM)
AllQuadrants(K).NormSecond = (Q2r/Q2rM)
AllQuadrants(K).NormThird = (Q3r/Q2rM)
AllQuadrants(K).NormFourth = (Q4r/Q2rM)
 
end



hold on
% %Images for Generations 1-4
% subplot(4,4,1);subimage(AllImages(1).First);title(count(1).Q1)
% subplot(4,4,2);subimage(AllImages(1).Second);title(count(1).Q2)
% subplot(4,4,3);subimage(AllImages(1).Third);title(count(1).Q3)
% subplot(4,4,4);subimage(AllImages(1).Fourth);title(count(1).Q4)
% 
% subplot(4,4,5);subimage(AllImages(2).First);title(count(2).Q1)
% subplot(4,4,6);subimage(AllImages(2).Second);title(count(2).Q2)
% subplot(4,4,7);subimage(AllImages(2).Third);title(count(2).Q3)
% subplot(4,4,8);subimage(AllImages(2).Fourth);title(count(2).Q4)
% 
% subplot(4,4,9);subimage(AllImages(3).First);title(count(3).Q1)
% subplot(4,4,10);subimage(AllImages(3).Second); title(count(3).Q2)
% subplot(4,4,11);subimage(AllImages(3).Third);title(count(3).Q3)
% subplot(4,4,12);subimage(AllImages(3).Fourth);title(count(3).Q4)
% 
% subplot(4,4,13);subimage(AllImages(4).First);title(count(4).Q1)
% subplot(4,4,14);subimage(AllImages(4).Second);title(count(4).Q2)
% subplot(4,4,15);subimage(AllImages(4).Third);title(count(4).Q3)
% subplot(4,4,16);subimage(AllImages(4).Fourth);title(count(4).Q4)
% 
% %Images for Gen 5 -8
% subplot(4,4,1);subimage(AllImages(5).First);title(count(5).Q1)
% subplot(4,4,2);subimage(AllImages(5).Second);title(count(5).Q2)
% subplot(4,4,3);subimage(AllImages(5).Third);title(count(5).Q3)
% subplot(4,4,4);subimage(AllImages(5).Fourth);title(count(5).Q4)
% 
% subplot(4,4,5);subimage(AllImages(6).First);title(count(6).Q1)
% subplot(4,4,6);subimage(AllImages(6).Second);title(count(6).Q2)
% subplot(4,4,7);subimage(AllImages(6).Third);title(count(6).Q3)
% subplot(4,4,8);subimage(AllImages(6).Fourth);title(count(6).Q4)
% 
% subplot(4,4,9);subimage(AllImages(7).First);title(count(7).Q1)
% subplot(4,4,10);subimage(AllImages(7).Second);title(count(7).Q2)
% subplot(4,4,11);subimage(AllImages(7).Third);title(count(7).Q3)
% subplot(4,4,12);subimage(AllImages(7).Fourth);title(count(7).Q4)
% 
% subplot(4,4,13);subimage(AllImages(8).First);title(count(8).Q1)
% subplot(4,4,14);subimage(AllImages(8).Second);title(count(8).Q2)
% subplot(4,4,15);subimage(AllImages(8).Third);title(count(8).Q3)
% subplot(4,4,16);subimage(AllImages(8).Fourth);title(count(8).Q4)
% 
% 
% 
% 
% 
% 
% 
% %Images for Gen 9-10
% subplot(1,4,1);subimage(AllImages(9).First);title(count(9).Q1)
% subplot(1,4,2);subimage(AllImages(9).Second);title(count(9).Q2)
% subplot(1,4,3);subimage(AllImages(9).Third);title(count(9).Q3)
% subplot(1,4,4);subimage(AllImages(9).Fourth);title(count(9).Q4)
% 
% subplot(2,4,5);subimage(AllImages(10).First);title(count(10).Q1)
% subplot(2,4,6);subimage(AllImages(10).Second);title(count(10).Q2)
% subplot(2,4,7);subimage(AllImages(10).Third);title(count(10).Q3)
% subplot(2,4,8);subimage(AllImages(10).Fourth);title(count(10).Q4)



% function createtextbox(figure1)
% 
% 
% % Create title
% annotation(figure1,'textbox',...
%     [0.0125830115830116 0.884654994850669 0.0960766685052399 0.0751802265705458],...
%     'String',{'1[B6]Y28'},...
%     'FitBoxToText','off');
% 
% % Create Genotype labels
% annotation(figure1,'textbox',...
%     [0.136686707115279 0.925849639546859 0.753550468836183 0.0453141091658085],...
%     'String',{'DBF4-1                                                    WILD TYPE                                              DM                                                            CDC13-2'},...
%     'FitBoxToText','off');
% 
% %Gen 9
% annotation(figure1,'textbox',...
%     [0.02526916712631 0.728115345005149 0.0679464975179261 0.0957775489186404],...
%     'String',{'Gen 9'},...
%     'FitBoxToText','off');
% 
% 
% %Gen10
% annotation(figure1,'textbox',...
%     [0.0208565912851627 0.222451081359423 0.0712559293987865 0.0895983522142122],...
%     'String',{'Gen 10'},...
%     'FitBoxToText','off');
% 
% %input info%
% annotation(figure1,'textbox',...
%     [0.917264202978489 0.340885684860968 0.0761169332597904 0.269824922760042],...
%     'String',{'Cx =',Cx ;,'Cy =' Cy;,'radius =' radius;,'sense =' sense,'range =' range},...
%     'FitBoxToText','off');
% 
% end










% %Creates Boxplot
% A = padcat (AllQuadrants(:).First, AllQuadrants(:).Second, AllQuadrants(:).Third, AllQuadrants(:).Fourth)
% 
% 
% [F G] = size(A)
% figure('Color', 'w');
% c = colormap('Winter');
% C = [c; ones(1,3); c];  % this is the trick for coloring the boxes
% 
% 
% 
% g1 = repmat([1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4],F,1);
% g2 = repmat('ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',F,1);
% zv = A(:);
% gp1 = g1(:);
% gp2 = g2(:);
% boxplot(zv,{gp1,gp2},'factorgap',[50,0],'colors', C, 'plotstyle', 'compact');


%Normalized Plot%
A = padcat (AllQuadrants(:).NormFirst, AllQuadrants(:).NormSecond, AllQuadrants(:).NormThird, AllQuadrants(:).NormFourth)


[F G] = size(A)
figure('Color', 'w');
c = colormap('Winter');
C = [c; ones(1,3); c];  % this is the trick for coloring the boxes



g1 = repmat([1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4],F,1);
g2 = repmat('ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-_+=',F,1);
zv = A(:);
gp1 = g1(:);
gp2 = g2(:);
boxplot(zv,{gp1,gp2},'factorgap',[50,0],'colors', C, 'plotstyle', 'compact');
