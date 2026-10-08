function varargout = CervicalCancerAnalysis_GUI(varargin)
% CERVICALCANCERANALYSIS_GUI M-file for CervicalCancerAnalysis_GUI.fig
%      CERVICALCANCERANALYSIS_GUI, by itself, creates a new CERVICALCANCERANALYSIS_GUI or raises the existing
%      singleton*.
%
%      H = CERVICALCANCERANALYSIS_GUI returns the handle to a new CERVICALCANCERANALYSIS_GUI or the handle to
%      the existing singleton*.
%
%      CERVICALCANCERANALYSIS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CERVICALCANCERANALYSIS_GUI.M with the given input arguments.
%
%      CERVICALCANCERANALYSIS_GUI('Property','Value',...) creates a new CERVICALCANCERANALYSIS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CervicalCancerAnalysis_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CervicalCancerAnalysis_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CervicalCancerAnalysis_GUI

% Last Modified by GUIDE v2.5 05-Oct-2017 23:34:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CervicalCancerAnalysis_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CervicalCancerAnalysis_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before CervicalCancerAnalysis_GUI is made visible.
function CervicalCancerAnalysis_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CervicalCancerAnalysis_GUI (see VARARGIN)

% Choose default command line output for CervicalCancerAnalysis_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CervicalCancerAnalysis_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

set(handles.axes1, 'XTick',[],'YTick',[],'XTickLabel',[], 'YTickLabel',[],'XGrid','off','YGrid','off',...
    'XColor',get(handles.axes1,'color'),'YColor',get(handles.axes1,'color'));
set(handles.axes2, 'XTick',[],'YTick',[],'XTickLabel',[], 'YTickLabel',[],'XGrid','off','YGrid','off',...
    'XColor',get(handles.axes2,'color'),'YColor',get(handles.axes2,'color'));
set(handles.axes3, 'XTick',[],'YTick',[],'XTickLabel',[], 'YTickLabel',[],'XGrid','off','YGrid','off',...
    'XColor',get(handles.axes3,'color'),'YColor',get(handles.axes3,'color'));
set(handles.axes4, 'XTick',[],'YTick',[],'XTickLabel',[], 'YTickLabel',[],'XGrid','off','YGrid','off',...
    'XColor',get(handles.axes4,'color'),'YColor',get(handles.axes4,'color'));
set(handles.axes5, 'XTick',[],'YTick',[],'XTickLabel',[], 'YTickLabel',[],'XGrid','off','YGrid','off',...
    'XColor',get(handles.axes5,'color'),'YColor',get(handles.axes5,'color'));
set(handles.axes6, 'XTick',[],'YTick',[],'XTickLabel',[], 'YTickLabel',[],'XGrid','off','YGrid','off',...
    'XColor',get(handles.axes6,'color'),'YColor',get(handles.axes6,'color'));
addpath('.\CNN_Toolbox\');addpath('./nsct_toolbox')
% --- Outputs from this function are returned to the command line.
function varargout = CervicalCancerAnalysis_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in bLoadImage.
function bLoadImage_Callback(hObject, eventdata, handles)
% hObject    handle to bLoadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global testCervicalImage fileTest
[fileTest pathTest] = uigetfile({'*.jpg';'*.png';'*.*'},'Please select an Cervical Image');
testCervicalImage = imread([pathTest fileTest]);
testCervicalImage = imresize(testCervicalImage, [256 256]);
[row col nc] = size(testCervicalImage);
axes(handles.axes1);
imshow(testCervicalImage,[]);
set(handles.uitable1, 'Data', []);
set(handles.edit2, 'String', '');
set(handles.text9, 'String', '');
temp_img = uint8(ones(size(testCervicalImage))*255);
axes(handles.axes2);
imshow(temp_img);
axes(handles.axes3);
imshow(temp_img);
axes(handles.axes4);
imshow(temp_img);
axes(handles.axes5);
imshow(temp_img);
axes(handles.axes6);
imshow(temp_img);
   
% --- Executes on button press in bCNNClassify.
function bCNNClassify_Callback(hObject, eventdata, handles)
% hObject    handle to bCNNClassify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global FeatVectTestImage testCervicalImage fileTest cellBW

load CNN_model.mat
[cnn, convFeatMaps] = ffcnn(cnn, imresize(rgb2gray(testCervicalImage),[128 128]));
[a, C]=max(cnn.layers{cnn.no_of_layers}.outputs, [],1);
if((C ~=0))
    load anfisStruct.mat
    anfisNet = evalfis(norm(FeatVectTestImage(:)),out_fis);
    if(anfisNet>0.6)
        disp('Abornamal Cervical Region');
        set(handles.text9,'string','Abornamal');
        R = testCervicalImage(:,:,1);
        G = testCervicalImage(:,:,2);
        B = testCervicalImage(:,:,3);
        M1 = zeros(size(R));
        M2 = zeros(size(R));
        M1(find(R>B)) = 1;
        M2(find(B>R)) = 1;
        L1 = length(find(M1));
        L2 = length(find(M2));
        
        testCervicalImageGray = rgb2gray(testCervicalImage);
        edgeImg = imfilter(testCervicalImageGray,fspecial('Sobel'));
        threshImg = testCervicalImageGray<80;
        threshImg = imclose(threshImg, strel('disk',2));
        threshImg = bwareaopen(threshImg,50);
        %     figure, imshow(threshImg)
        %     title('Thresholded Image')
        cervicalBW = threshImg;
        %     cervicalBW = imerode(cervicalBW,strel('disk',2));
        cervicalBW = bwareaopen(cervicalBW,50);
        cervicalBW = imclearborder(cervicalBW);
        axes(handles.axes4);
        imshow(cervicalBW,[]);
        [labelled nObjs] = bwlabel(cervicalBW);
        stats = regionprops(labelled,'Area');
        areaAll = [];
        redObj = [];
        cellBW = zeros(size(cervicalBW));
        for n = 1:nObjs
            areaAll = [areaAll stats(n).Area];
            temp = labelled;
            temp(find(temp~=n)) = 0;
            temp1 = uint8(logical(temp)).*testCervicalImage(:,:,1);
            redObj = [redObj max(max(temp1))];
            if(max(max(temp1)) > 180)
                cellBW = cellBW + temp;
            end
        end
        axes(handles.axes3);
        imshow(cellBW,[]);
        cellBW = logical(cellBW);
        cellBWEdge = edge(cellBW);
        %     figure, imshow(cellBWEdge)
        %     title('Edge Image')
        R(find(cellBWEdge~=0)) = 255;
        G(find(cellBWEdge~=0)) = 255;
        B(find(cellBWEdge~=0)) = 0;
        CervicCancerImage = uint8(zeros(size(testCervicalImage)));
        CervicCancerImage(:,:,1) = R;
        CervicCancerImage(:,:,2) = G;
        CervicCancerImage(:,:,3) = B;
        axes(handles.axes5);
        imshow(CervicCancerImage,[]);
        imwrite(uint8(CervicCancerImage), ['.\Images\Results\' strrep(fileTest,'.jpg','.png')]);
        PerformenceComprisionPCA;
        [labelled nObjs] = bwlabel(cellBW);
        if nObjs > 1
            set(handles.edit2,'string','Severe');
        else
            set(handles.edit2,'string','Moderate');
        end
        
    else
        disp('Normal Cervical Region');
        set(handles.text9,'string','Normal');
        axes(handles.axes4);
        imshow(ones(size(testCervicalImage(:,:,1))),[]);
        axes(handles.axes3);
        imshow(ones(size(testCervicalImage(:,:,1))),[]);
        axes(handles.axes5);
        imshow(testCervicalImage,[]);
    end
end
       

    


function eResult_Callback(hObject, eventdata, handles)
% hObject    handle to eResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eResult as text
%        str2double(get(hObject,'String')) returns contents of eResult as a double


% --- Executes during object creation, after setting all properties.
function eResult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bNSCTFeature.
function bNSCTFeature_Callback(hObject, eventdata, handles)
% hObject    handle to bNSCTFeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global testCervicalImage NSCTImage FeatVectTestImage
testCervicalImageTemp = testCervicalImage;
[row col nch] = size(testCervicalImageTemp);
if(nch>1)
    testCervicalImageTemp = rgb2gray(testCervicalImageTemp);
end
testCervicalImageTemp2 = testCervicalImageTemp;
testCervicalImageTemp = imresize(testCervicalImageTemp,[256 256]);
[row col nch] = size(testCervicalImageTemp);

CLPBF1 = 0;
CLPBF2 = 0;
CHPBF1 = 0;
CHPBF2 = 0;
CEF1 = 0;
CEF2 = 0;
RICF1 = 0;
RICF2 = 0;
CICF1 = 0;
CICF2 = 0;

for m = 1: size(NSCTImage{1,1},1)
    for n = 1: size(NSCTImage{1,1},2)
        CLPBF1 = CLPBF1+(NSCTImage{1,1}(m,n)^2)/m;
        CLPBF2 = CLPBF2+(NSCTImage{2,1}(m,n)^2)/m;
        CHPBF1 = CHPBF1+(NSCTImage{1,2}(m,n)^2)/n;
        CHPBF2 = CHPBF2+(NSCTImage{2,2}(m,n)^2)/n;
        CEF1 = CEF1+(NSCTImage{1,2}(m,n)^2)^2;
        CEF2 = CEF2+(NSCTImage{2,2}(m,n)^2)^2;
        RICF1 = RICF1+(NSCTImage{1,2}(m,n)^2)^2 *m;
        RICF2 = RICF2+(NSCTImage{2,2}(m,n)^2)^2 *m;
        CICF1 = CICF1+(NSCTImage{1,2}(m,n)^2)^2 *n;
        CICF2 = CICF2+(NSCTImage{2,2}(m,n)^2)^2 *n;
    end
end

CLPBF = (CLPBF1 + CLPBF2) / 2;
CHPBF = (CHPBF1 + CHPBF2) / 2;
CEF = (CEF1 + CEF2) / 2;
RICF = (RICF1 + RICF2) / 2;
CICF = (CICF1 + CICF2) / 2;
nsctFeat.CLPBF = CLPBF;
nsctFeat.CHPBF = CHPBF;
nsctFeat.CEF = CEF;
nsctFeat.RICF = RICF;
nsctFeat.CICF = CICF;
ldpI_0 = LDP(testCervicalImageTemp, 0);
ldpI_45 = LDP(testCervicalImageTemp, 45);
ldpI_90 = LDP(testCervicalImageTemp, 90);
ldpI_135 = LDP(testCervicalImageTemp, 135);

ldpAll = cell(2,2);
ldpAll{1,1} = ldpI_0;
ldpAll{1,2} = ldpI_45;
ldpAll{2,1} = ldpI_90;
ldpAll{2,2} = ldpI_135;

[LL LH HL HH] = dwt2(testCervicalImageTemp,'db4','mode','per');
waveFeat = [sum(LH.^2) sum(HL.^2) sum(HH.^2)];
[row2 col2] = size(LL);
dwtImg = zeros(size(testCervicalImageTemp));
dwtImg(1:row2,1:row2) = LL(1:row2,1:col2);
dwtImg(1:row2,col2+1:col) = LH(1:row2,1:col2);
dwtImg(row2+1:row,1:col2) = HL(1:row2,1:col2);
dwtImg(row2+1:row,col2+1:col) = HH(1:row2,1:col2);

glcmFeat = GLCM_Features(double(testCervicalImageTemp));
glcmFeatT = [glcmFeat.contr glcmFeat.corrm glcmFeat.energ glcmFeat.homom];
glcmFeat = cell2mat(struct2cell(glcmFeat));
[egy1 egy2] = LawsTextureMeasures(testCervicalImageTemp);
FeatVectTestImage = [waveFeat';glcmFeat;egy1;egy2];

nsctFeatT = [nsctFeat.CLPBF nsctFeat.CHPBF nsctFeat.CEF nsctFeat.RICF nsctFeat.CICF];
set(handles.uitable1, 'Data', nsctFeatT');


% --- Executes on button press in hPreprocess.
function hPreprocess_Callback(hObject, eventdata, handles)
% hObject    handle to hPreprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global testCervicalImage 
[row col nc] = size(testCervicalImage);
if(nc >1)
    ycbcrImage = rgb2ycbcr(testCervicalImage);
    grayImage = ycbcrImage(:,:,1);
    preprocessed_img = adapthisteq(grayImage);
    ycbcrImage(:,:,1) = preprocessed_img;
    testCervicalImage = ycbcr2rgb(ycbcrImage);
else
    testCervicalImage = adapthisteq(testCervicalImage);
end


axes(handles.axes2);
imshow(testCervicalImage,[]);


% --- Executes on button press in hWaterShed.
function hWaterShed_Callback(hObject, eventdata, handles)
% hObject    handle to hWaterShed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bNSCTTransform.
function bNSCTTransform_Callback(hObject, eventdata, handles)
% hObject    handle to bNSCTTransform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global testCervicalImage NSCTImage
if size(testCervicalImage,3)>1
    I = rgb2gray(testCervicalImage);
end
% Parameteters:
nlevels = [0 1] ;        % Decomposition level
pfilter = 'maxflat' ;              % Pyramidal filter
dfilter = 'dmaxflat7' ;              % Directional filter

% Nonsubsampled Contourlet decomposition
NSCTImage=cell(2,2);
coeffs = nsctdec( double(I), nlevels, dfilter, pfilter );
NSCTImage{1,1} = coeffs{1};
NSCTImage{1,2} = coeffs{3}{1};
NSCTImage{2,1} = coeffs{2};
NSCTImage{2,2} = coeffs{3}{2};
axes(handles.axes6);
imshow(cell2mat(NSCTImage),[]);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
