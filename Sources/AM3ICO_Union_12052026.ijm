print("\\Clear");
yesno=newArray("Yes", "No");
items=newArray("Browser", "Analysis","Exit");
browsingitems=newArray("Browser", "Exit");
bigfbrowsingitems=newArray("Channel Selection (Map)", "ROI-Selection for High Resolution View", "Multichannel High-Resolution View", "Exit");
settingsitems=newArray("Settings", "Exit");
analysisitems=newArray("Background Subtraction", "Minimum Cell Size", "Maximum Cell Size", "Threshold", "Whole Cell Analysis");
SlideIndex=0;
maincheck=true;
browsingcheck=true;
settingscheck=true;
dir=getDirectory("");
list=getFileList(dir);
total=list.length;
Array.sort(list);
nd2check=indexOf(list[0],".nd2");
choice=items[0];
colors=newArray("Red","Green","Blue","Grays","Cyan","Yellow", "Magenta");
colcoeff=newArray(1,0,0,0,1,0,0,0,1,1,1,1,0,1,1,1,1,0,1,0,1);
runlabels=newArray("Execute Analysis", "Online Analysis");
DAPIID=0;
indexthreshold=0;
segment=newArray("Default","Huang", "Intermodes", "IsoData", "Li", "MaxEntropy", "Mean", "MinError", "Minimum", "Moments", "Otsu", "Percentile", "RenyiEntropy", "Shanbhag", "Triangle", "Yen");
///////////////file type and channel recognition /////////////////////////////////
id = dir + list[0];
file=list[0];
lengthf=File.length(id)/pow(1024, 2);
//print("Dimension: "+d2s(lengthf, 2)+" MB");
if(indexOf(id,".nd2")>0){
nd2check=0;
} else {
nd2check=-1;
}
run("Bio-Formats Macro Extensions");
print("Checking Image Acquisition Parameters...please be patient");
tstart=getTime();
run("Bio-Formats", "open=["+id+"] autoscale color_mode=Default display_metadata rois_import=[ROI manager] view=[Metadata only] stack_order=Default");
tstop=getTime();
print(d2s((tstop-tstart)/1000,0)+" seconds elapsed");
selectWindow("Original Metadata - "+list[0]);
xmlstring=getInfo("window.contents");
bitdepth=parseInt(substring(xmlstring,indexOf(xmlstring,"BitsPerPixel")+lengthOf("BitsPerPixel"),indexOf(xmlstring, "\n", indexOf(xmlstring,"BitsPerPixel"))));
channels=parseInt(substring(xmlstring,indexOf(xmlstring,"SizeC")+lengthOf("SizeC"),indexOf(xmlstring, "\n", indexOf(xmlstring,"SizeC"))));
imagewidth=parseInt(substring(xmlstring,indexOf(xmlstring,"SizeX")+lengthOf("SizeX"),indexOf(xmlstring, "\n", indexOf(xmlstring,"SizeX"))));
imageheight=parseInt(substring(xmlstring,indexOf(xmlstring,"SizeY")+lengthOf("SizeY"),indexOf(xmlstring, "\n", indexOf(xmlstring,"SizeY"))));
sizeZ=parseInt(substring(xmlstring,indexOf(xmlstring,"SizeZ")+lengthOf("SizeZ"),indexOf(xmlstring, "\n", indexOf(xmlstring,"SizeZ"))));
stackOrder="XYZCT";
specify="c_";
///////////multiplane files are considered multichannels; equivalent to modify stack order by swapping c and z dimension////////
if((sizeZ>1)&&(channels==1)){
channels=sizeZ;
sizeZ=1;
stackOrder="XYCZT";
specify="z_";
}
if(channels>1){
multichannelcheck=0;
} else {
multichannelcheck=-1;
}
//////////////////////////channel naming////////////////
if(multichannelcheck>-1){
canali=newArray(channels);
canalixml=newArray(channels);
if(indexOf(xmlstring, "Name #1")>-1){
for(i=0; i<channels; i++){
canali[i]=substring(xmlstring,indexOf(xmlstring,"\nName #"+d2s(i+2,0))+lengthOf("\nName #"+d2s(i+2,0)),indexOf(xmlstring, "\n", indexOf(xmlstring,"\nName #"+d2s(i+2,0))+1));
}
} else {
for(i=0; i<channels; i++){
canali[i]="Channel"+String.pad(d2s(i,0), 2) ;
}
if(getBoolean("Do you want to insert a description for the channels?")){
Dialog.create("Channels Description");
for(i=0; i<channels; i++){
Dialog.addString("Channel"+d2s(i+1,0)+": ", canali[i]);
} 
Dialog.show();
for(i=0; i<channels; i++){
canali[i]=Dialog.getString();
}
Array.show(canali);
}
}
} else {
if(nd2check<0){
firstch=substring(list[0], lastIndexOf(list[0], "-"), indexOf(list[0], ".tif"));
} else {
firstch=substring(list[0], lastIndexOf(list[0], "_"), indexOf(list[0], ".nd2"));
}
for (ch=1; ch<total; ch++){
if(indexOf(list[ch],firstch)<0){
channels=channels+1;
} else {
ch=total;
}
}
canali=newArray(channels);
for (ch=0; ch<channels; ch++){
if(nd2check<0){
canali[ch]=substring(list[ch], lastIndexOf(list[ch], "-")+1, indexOf(list[ch], ".tif"));
} else {
canali[ch]=substring(list[ch], lastIndexOf(list[ch], "_")+1, indexOf(list[ch], ".nd2"));
}
}
}
selectWindow("Original Metadata - "+list[0]);
run("Close");
print(channels);
if(multichannelcheck<0){
positions=total/channels;
} else {
positions=total;
}
channelsize=(bitdepth/8)*(imagewidth*imageheight/pow(1024, 2));
/////////////////////if file size is big only a centered region of fixed size will be opened during the set up of the analysis parameters: the limit is set to 4096*4096 for 16-bit and 2048*2048 for 32-bit images//////////
if(channelsize>32){
bigfcheck=true;
wpreview=2048;
hpreview=2048;
xpreview=imagewidth/2-wpreview/2;
ypreview=imageheight/2-hpreview/2;
print("Warning: cropping of images for analysis settings will be activated");
} else {
bigfcheck=false;
wpreview=imagewidth;
hpreview=imageheight;
xpreview=0;
ypreview=0;
}
if(channels>7){
bigfcheck=true;
print("Warning: big file browsing activated");
}
bgsub=newArray(channels);
///////////////////////
if(bigfcheck){
mapcount=0;
labelindex=0;
labelch=canali[0];
checkArray=newArray(7);
prmtArray=newArray("--None--","--None--","--None--","--None--","--None--","--None--","--None--");
chanArray=newArray(7);
colorArray=newArray("Red", "Green", "Blue", "Grays", "Cyan", "Magenta", "Yellow");
labels=newArray("--None--");
labels=Array.concat(canali, labels);
}
//print("\\Clear");
lutcoeff=newArray(1,0,0,0,1,0,0,0,1,1,1,1);
analysisindex=newArray(channels*channels);
Array.fill(analysisindex, false);
bgsub=newArray(channels);
subfilterlist=newArray("None", "LaplaceofGaussian(LoG)", "Top-Hat", "Variance", "RollingBallSpot");
subcompindex=newArray(channels);
Array.fill(subcompindex, 0);
subcellindex=newArray(channels);
Array.fill(subcompindex, 0);
subcomplabels=newArray(channels);
for(ch=0; ch<channels; ch++){
subcomplabels[ch]=canali[ch];
}
subminsize=newArray(channels);
submaxsize=newArray(channels);
subthreshold=newArray(channels);
subfilterspot=newArray(channels);
subgammafactor=newArray(channels);
subautothreshold=newArray(channels);
subsubindex=newArray(channels);
subdistindex=newArray(channels);
for(subl=0; subl<channels; subl++){
subfilterspot[subl]=" ";
subautothreshold[subl]=" ";
}
subchID=0;
firsttime=0;
wholecell=0;
online=false;
///////////////////////////Main Dialog///////////////////
while(maincheck){
Dialog.create("A.M.I.CO-Union");
Dialog.addRadioButtonGroup("", items,1,3,0);
Dialog.addMessage("Working Directory: "+"\n"+dir);
Dialog.addMessage("File Size: "+d2s(lengthf, 2)+" MB"+"\n# of Channels: "+channels+"\nChannel Size: "+d2s(channelsize,2)+" MB");
Dialog.addMessage("Current Slide Index: "+SlideIndex+"\n"+file);
Dialog.show();
choice=Dialog.getRadioButton();
//dir=Dialog.getString();
if(choice==items[0]){
browsingcheck=true;
while(browsingcheck){
if(!(bigfcheck)){
Dialog.createNonBlocking("Browsing") ;
Dialog.addRadioButtonGroup("", browsingitems,2,1,browsingitems[0]);
Dialog.addSlider("Image Selection: ", 0, positions-1, SlideIndex);
Dialog.addMessage("Current File: "+file);
ChannelString="";
for (ch=0; ch<channels; ch++){
ChannelString=ChannelString+"\nChannel"+d2s(ch,0)+": "+canali[ch];
}
Dialog.addMessage(ChannelString);
Dialog.show();
browsingchoice=Dialog.getRadioButton();
///////////////////////////////////Image Browsing Section///////////////////////////////////////////////////////////////////////
if(browsingchoice!=browsingitems[1]){
print("\\Update0:"+"Working Directory: "+dir) ;
print("\\Update1:"+items[0]) ;
SlideIndex=Dialog.getNumber();
if(isOpen("seq5d")){
selectImage("seq5d");
close();
}
if(isOpen("RGB")){
selectImage("RGB");
close();
}
if(isOpen("Map")){
selectImage("Map");
close();
}
if(multichannelcheck>-1){
print("\\Update2: File Index: "+(SlideIndex));
print("\\Update3: "+list[SlideIndex]);
file=list[SlideIndex];
path=dir+file;
run("Bio-Formats", "open=["+path+"] autoscale color_mode=Default rois_import=[ROI manager] view=Image5D stack_order=XYCZT");
RGBID=getImageID();
rename("RGB");
for(ich=0; ich<channels; ich++){
run("Set Position", "x-position=1 y-position=1 channel="+(ich+1)+" slice=1 frame=1 display=tiled");
//run(colors[ich]);
run("Smooth");
run("Enhance Contrast", "saturated=0.1");
}
} else {
print("\\Update2: File Index: "+(channels*SlideIndex));
print("\\Update3: "+list[channels*SlideIndex]);
setBatchMode(true);
for(ich=0; ich<channels; ich++){
file=list[channels*SlideIndex+ich];
path=dir+file;
run("Bio-Formats", "open=["+path+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
setBatchMode("exit and display");
if(channels>1){
run("Concatenate...", "all_open title=seq5d");
run("Stack to Image5D", "3rd=ch 4th=z 3rd_dimension_size="+channels+" 4th_dimension_size=1 assign");
RGBID=getImageID();
rename("RGB");
for(ich=0; ich<channels; ich++){
run("Set Position", "x-position=1 y-position=1 channel="+(ich+1)+" slice=1 frame=1 display=tiled");
run("Smooth");
run("Enhance Contrast", "saturated=0.1");
}
}
}
} else {
browsingcheck=false;
//maincheck=true;
}
} else {
//file=list[channels*SlideIndex];
//path=dir+file;
Dialog.createNonBlocking("Big-Files Browsing");
Dialog.addRadioButtonGroup("", bigfbrowsingitems, 1, 3, 0);
Dialog.addSlider("Image Selection: ", 0, positions-1, SlideIndex);
Dialog.addMessage("Current File: "+file);
Dialog.addChoice("Select the parameter to build the Map of the current position: ", labels, labels[labelindex]);
Dialog.addMessage("Channels Selection for Full-Resolution Image: ");
for(i=0; i<7; i++){
Dialog.addCheckbox(d2s(i+1,0)+": "+colorArray[i], checkArray[i]);
Dialog.addToSameRow();
if(checkArray[i]){
Dialog.addChoice("", labels, prmtArray[i]);
} else {
Dialog.addChoice("", labels, labels[lengthOf(labels)-1]);
}
}
Dialog.show();
bigfbrowsingchoice=Dialog.getRadioButton();
SlideIndex=Dialog.getNumber();
labelch=Dialog.getChoice();
for(ich=0; ich<lengthOf(canali); ich++){
if(labelch==canali[ich]){
labelindex=ich;
}
}
for(i=0; i<7; i++){
checkArray[i]=Dialog.getCheckbox();
prmtArray[i]=Dialog.getChoice();
}
Array.show(prmtArray);
if(bigfbrowsingchoice==bigfbrowsingitems[0]){
if(isOpen("Map")){
selectImage("Map");
close();
}
if(multichannelcheck>-1){
print("Slide Index: "+d2s(SlideIndex,0)+"; " +list[SlideIndex]);
file=list[SlideIndex];
path=dir+file;
run("Bio-Formats", "open=["+path+"] autoscale color_mode=Default rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(labelindex+1)+" "+specify+"end="+(labelindex+1)+" "+specify+"step=1");
mapID=getImageID();
rename("Map");
Property.setSliceLabel(labelch);
run("Grays");
} else {
file=list[channels*SlideIndex+labelindex];
path=dir+file;
if(nd2check<0){
open(path);
} else {
run("Bio-Formats", "open=["+path+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
mapID=getImageID();
rename("Map");
Property.setSliceLabel(labelch);
}
}
if(bigfbrowsingchoice==bigfbrowsingitems[1]){
if(!(isOpen("Map"))){
if(multichannelcheck>-1){
file=list[SlideIndex];
path=dir+file;
run("Bio-Formats", "open=["+path+"] autoscale color_mode=Default rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(labelindex+1)+" "+specify+"end="+(labelindex+1)+" "+specify+"step=1");
mapID=getImageID();
rename("Map");
run("Grays");
} else {
file=list[channels*SlideIndex+labelindex];
path=dir+file;
if(nd2check<0){
open(file);
} else {
run("Bio-Formats", "open=["+path+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
mapID=getImageID();
rename("Map");
}
selectImage("Map");
Property.setSliceLabel(labelch);
}
selectImage(mapID);
wpreview=minOf(imagewidth,2048);
hpreview=minOf(imageheight,2048);
xpreview=imagewidth/2-wpreview/2;
ypreview=imageheight/2-hpreview/2;
makeRectangle(xpreview, ypreview, wpreview, hpreview);
mapch=false;
setTool("Rectangle");
waitForUser("Move the Region to the target area (if not central portion will be selected; size is fixed to 2048x2048)");
getSelectionBounds(xpreview, ypreview, wroi, hroi);
wpreview=wroi;
hpreview=hroi;
setTool("hand");
}
if(bigfbrowsingchoice==bigfbrowsingitems[2]){
if(isOpen("RGB")){
selectImage("RGB");
close();
}
setBatchMode(true);
chch=0;
metastring=list[SlideIndex]+"\n";
for(i=0; i<7; i++){
for(ich=0; ich<lengthOf(canali); ich++){
if(prmtArray[i]==canali[ich]){
file=list[SlideIndex];
path=dir+file;
print("Opening Image "+list[SlideIndex]+"--"+prmtArray[i]+": please be patient...");
if(multichannelcheck>-1){
run("Bio-Formats", "open=["+path+"] autoscale color_mode=Default crop rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(ich+1)+" "+specify+"end="+(ich+1)+" "+specify+"step=1 x_coordinate_1="+xpreview+" y_coordinate_1="+ypreview+" width_1="+wpreview+" height_1="+hpreview);
} else {
path=dir+list[channels*SlideIndex+ich];
run("Bio-Formats", "open=["+path+"] autoscale color_mode=Default crop rois_import=[ROI manager] view=[Standard ImageJ] stack_order="+stackOrder+" step=1 x_coordinate_1="+xpreview+" y_coordinate_1="+ypreview+" width_1="+wpreview+" height_1="+hpreview);
}
rename(list[SlideIndex]+"--"+prmtArray[i]);
Property.setSliceLabel(list[SlideIndex]+"--"+prmtArray[i]);
metastring=metastring+prmtArray[i]+"--"+colorArray[i]+"\n";}
chch=chch+1;
}
}
if(chch==0){
showMessage("Define at least one parameter");
} else {
chanArray=split(metastring,"\n");
Array.show(colorArray, prmtArray, chanArray);
if(chch>1){
run("Images to Stack", "name=RGB title="+list[SlideIndex]+"-- use");
run("Stack to Hyperstack...", "order=xyczt(default) channels="+nSlices+" slices=1 frames=1 display=Color");
for(i=1; i<nSlices+1; i++){
Stack.setChannel(i);
setMetadata("Label", chanArray[i]);
run(substring(chanArray[i],lastIndexOf(chanArray[i],"-")+1));
run("Enhance Contrast", "saturated=0.1");
}
run("Brightness/Contrast...");
run("Channels Tool...");
//Property.set("CompositeProjection", "Sum");
Property.set("CompositeProjection", "Max");
Stack.setDisplayMode("composite");
//Property.set("CompositeProjection", "null");
//Stack.setDisplayMode("color");
} 
}
setBatchMode("exit and display");
updateDisplay();
//waitForUser("First Check");

}
if(bigfbrowsingchoice==bigfbrowsingitems[3]){
browsingcheck=false;
}
}
}
}
////////////////////////////////////////Analysis Settings Section/////////////////////////////////////////////////////////////////
if(choice==items[1]) {
if(isOpen("seq5d")){
selectImage("seq5d");
close();
}
if(isOpen("RGB")){
selectImage("RGB");
close();
}
if(isOpen("Map")){
selectImage("Map");
close();
}
for (ch=0; ch<channels; ch++){
if(indexOf(canali[ch],"segm")==0){
canali[ch]=substring(canali[ch],4);
}
}
Dialog.create("Select Channel for Cell (Nuclei) Identification");
Dialog.addChoice("Cell Identifier: ", canali);
Dialog.show();
cellchannel=Dialog.getChoice();
for (ch=0; ch<channels; ch++){
if(canali[ch]==cellchannel){
chDAPI=ch;
}
}
canali[chDAPI]="segm"+canali[chDAPI];
Array.show(canali);
if(multichannelcheck<0){
fileDAPI=dir+list[channels*SlideIndex+chDAPI];
} else {
fileDAPI=dir+list[SlideIndex];
}
//////////////////////////////////////////Analysis window///////////////////////
settingscheck=true;
WholeCellString="";
while(settingscheck){
if(firsttime<4){
settingschoice=settingsitems[0];
analysischoice=analysisitems[firsttime];
subcompchoice="";
executionchoice="";
firsttime=firsttime+1;
} else {
Dialog.create("Analysis Settings");
Dialog.addRadioButtonGroup("", settingsitems,1,2, settingsitems[0]);
Dialog.addMessage("Cell Identification Parameters", 12, "#0000ff");
Dialog.addMessage("Cell (Nuclei) Identifier: "+canali[chDAPI]);
Dialog.addRadioButtonGroup("", analysisitems,5,1,0);
Dialog.addMessage(WholeCellString);
Dialog.addMessage("SubCompartment Settings", 12, "#0000ff");
Dialog.addRadioButtonGroup("Channels:", subcomplabels,channels/5,1,0);
Dialog.addRadioButtonGroup("Run Analysis: ", runlabels,0,2,0);
Dialog.show();
settingschoice=Dialog.getRadioButton();
analysischoice=Dialog.getRadioButton();
subcompchoice=Dialog.getRadioButton();
executionchoice=Dialog.getRadioButton();
}
////////////////Exit Button//////////////////
if(settingschoice==settingsitems[1]){
settingscheck=false;
if(isOpen("Nuclei Channel")){
selectImage("Nuclei Channel");
close();
}
} else {
///////////////////////Background Subtraction/////////////////////////////////////////////////////
if(analysischoice==analysisitems[0]){
analysisitems[0]="Background Subtraction";
bgdefarray=newArray("None", "Manual", "RollingBall", "FlatfieldCorr(Deprecated)");
ffcheck=false;
autobgcheck=false;
Dialog.create("Background Subtraction Definition");
Dialog.addChoice("Select Background Subtraction Mode", bgdefarray, bgdefarray[2]);
//Dialog.addCheckbox("Flatfield Illumination Correction", false);
//Dialog.addCheckbox("Adjust background to the current experiment settings (for FlatfieldCorr)", false);
Dialog.addCheckbox("Apply Watershed to separate clusters", true);
Dialog.addCheckbox("Fill Internal Holes (e.g. to include nucleoli)", true);
Dialog.show();
bgsubmode=Dialog.getChoice();
//ffcorr=Dialog.getCheckbox();
ffcorr=0;
//bgadjcheck=Dialog.getCheckbox();
watercheck=Dialog.getCheckbox();
fillholescheck=Dialog.getCheckbox();
if(ffcorr){
flatfielddir=getDirectory("Choose the directory containing the flatfield images");
fflist=getFileList(flatfielddir);
ffchannels=newArray(channels);
Dialog.create("Flatfield Illumination Correction");
for(ich=0; ich<channels; ich++){
Dialog.addChoice(canali[ich], fflist);
}
Dialog.show();
for(ich=0; ich<channels; ich++){
ffchannels[ich]=Dialog.getChoice();
}
}
analysisitems[0]=analysisitems[0]+": "+bgsubmode;
if(bgsubmode==bgdefarray[0]){
Array.fill(bgsub,0);
} else {
if(isOpen(DAPIID)){
selectImage(DAPIID);
close();
}
if(bgsubmode==bgdefarray[1]){
print("Opening Images: please be patient...");
if(multichannelcheck<0){
if(nd2check<0){
open(fileDAPI);
} else {
run("Bio-Formats", "open=["+fileDAPI+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
DAPIID=getImageID();
} else {
tstart=getTime();
run("Bio-Formats", "open=["+fileDAPI+"] autoscale color_mode=Default crop rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(chDAPI+1)+" "+specify+"end="+(chDAPI+1)+" "+specify+"step=1 x_coordinate_1="+xpreview+" y_coordinate_1="+ypreview+" width_1="+wpreview+" height_1="+hpreview);
tstop=getTime();
print(d2s((tstop-tstart)/1000,0)+" seconds elapsed");
DAPIID=getImageID();
}
selectImage(DAPIID);
run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel global");
run("Select None");
width=getWidth();
height=getHeight();
size=0;
while((size==0) || (size==width*height)){
Dialog.createNonBlocking("Setting Background...");
Dialog.addMessage("Draw a ROI to set the Image Background");
Dialog.show();
getSelectionBounds(xbg, ybg, widthbg, heightbg);
size=widthbg*heightbg;
}
run("Set Measurements...", "mean standard decimal=3");
setBatchMode(true);
print("Opening Images for background correction");
for(ibg=0; ibg<channels; ibg++){
if(multichannelcheck<0){
filech=dir+list[SlideIndex+ibg];
if(nd2check<0){
open(filech);
} else {
run("Bio-Formats", "open=["+filech+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
chID=getImageID();
} else {
filech=dir+list[SlideIndex];
//open(filech);
run("Bio-Formats", "open=["+filech+"] autoscale color_mode=Default crop rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(ibg+1)+" "+specify+"end="+(ibg+1)+" "+specify+"step=1 x_coordinate_1="+xpreview+" y_coordinate_1="+ypreview+" width_1="+wpreview+" height_1="+hpreview);
//run("Bio-Formats", "open=["+filech+"] autoscale color_mode=Default rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(ibg+1)+" "+specify+"end="+(ibg+1)+" "+specify+"step=1");
chID=getImageID();
}
selectImage(chID);
makeRectangle(xbg, ybg, widthbg, heightbg);
run("Measure");
meanbg=getResult("Mean", ibg);
stdDevbg=getResult("StdDev", ibg);
if(!(bgsub[ibg]<0)){
bgsub[ibg]=meanbg+3*stdDevbg;
}
selectImage(chID);
close();
}
selectImage(DAPIID);
run("Select None");
run("Subtract...", "value="+bgsub[chDAPI]);
}
if(bgsubmode==bgdefarray[2]){
autobgcheck=true;
Array.fill(bgsub, 0);
print("Opening Images: please be patient...");
if(multichannelcheck<0){
if(nd2check<0){
open(fileDAPI);
} else {
run("Bio-Formats", "open=["+fileDAPI+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
DAPIID=getImageID();
} else {
tstart=getTime();
run("Bio-Formats", "open=["+fileDAPI+"] autoscale color_mode=Default crop rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(chDAPI+1)+" "+specify+"end="+(chDAPI+1)+" "+specify+"step=1 x_coordinate_1="+xpreview+" y_coordinate_1="+ypreview+" width_1="+wpreview+" height_1="+hpreview);
tstop=getTime();
print(d2s((tstop-tstart)/1000,0)+" seconds elapsed");
DAPIID=getImageID();
}
rollcheck=yesno[1];
while(rollcheck==yesno[1]){
Dialog.createNonBlocking("Rolling ball bg subtraction");
Dialog.addNumber("Minimal Radius for Rolling Ball bg subtraction", 200);
Dialog.show();
rollingbg=Dialog.getNumber();
selectImage(DAPIID);
getLocationAndSize(xID, yID, widthID, heightID);
xID=0;
yID=0;
setLocation(xID, yID, widthID, heightID);
setBatchMode(true);
title="RollingRadius:"+rollingbg+"pixels";
run("Duplicate...", "title="+title);
run("Subtract Background...", "rolling="+rollingbg);
if(ffcorr){
if(!isOpen(ffchannels[chDAPI])){
open(flatfielddir+File.separator+ffchannels[chDAPI]);
ffDAPIID=getImageID();
}
imageCalculator("divide create 32-bit", title, ffDAPIID);
resultID=getImageID();
selectImage(title);
close();
selectImage(resultID);
rename(title);
}
setBatchMode("exit and display");
setLocation(xID+widthID, yID);
Dialog.createNonBlocking("Rolling Ball Settings");
Dialog.addRadioButtonGroup("Is the radius OK?", yesno, 1, 2, yesno[0]);
//rollcheck=getBoolean("Is the radius OK?");
Dialog.show();
rollcheck=Dialog.getRadioButton();
if(rollcheck==yesno[0]){
selectImage(DAPIID);
close();
if(ffcorr){
if(isOpen(ffDAPIID)){
selectImage(ffDAPIID);
close();
}
}
selectImage(title);
DAPIID=getImageID();
} else {
selectImage(title);
close();
}
}
selectImage(DAPIID);
rename("Nuclei Channel");
run("Select None");
setLocation(xID, yID, widthID, heightID);
}
if(bgsubmode==bgdefarray[3]){
flatfielddir=getDirectory("Choose the directory containing the flatfield and background images");
bgcanali=newArray(channels);
ffchannels=newArray(channels);
for(ich=0; ich<channels; ich++){
pathff=flatfielddir+"ff"+canali[ich]+".tif";
pathbg=flatfielddir+"bg"+canali[ich]+".tif";
if((File.exists(pathff))&&(File.exists(pathbg))){
bgsub[ich]=-1;
ffcheck=true;
} else {
showMessage("Missing Background and/or Flatfield Reference Image for the "+canali[ich]+" channel. \n Remember to set background value or to exclude it from the analysis to avoid errors.");
ffcheck=false;      
}
}
if(bgadjcheck){
print("Opening Images: please be patient...");
if(multichannelcheck<0){
if(nd2check<0){
open(fileDAPI);
} else {
run("Bio-Formats", "open=["+fileDAPI+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
DAPIID=getImageID();
} else {
tstart=getTime();
run("Bio-Formats", "open=["+fileDAPI+"] autoscale color_mode=Default crop rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(chDAPI+1)+" "+specify+"end="+(chDAPI+1)+" "+specify+"step=1 x_coordinate_1="+xpreview+" y_coordinate_1="+ypreview+" width_1="+wpreview+" height_1="+hpreview);
tstop=getTime();
print(d2s((tstop-tstart)/1000,0)+" seconds elapsed");
DAPIID=getImageID();
}
selectImage(DAPIID);
width=getWidth();
height=getHeight();
size=0;
while((size==0) || (size==width*height)){
Dialog.createNonBlocking("Setting Background...");
Dialog.addMessage("Draw a ROI to set the Image Background");
Dialog.show();
getSelectionBounds(xbg, ybg, widthbg, heightbg);
size=widthbg*heightbg;
}
rollingbg=widthbg*heightbg;
close();
run("Set Measurements...", "mean standard decimal=3");
setBatchMode(true);
print("Opening Images for background correction");
for(ibg=0; ibg<channels; ibg++){
if(!isOpen(chID)){
if(multichannelcheck<0){
filech=dir+list[SlideIndex+ibg];
if(nd2check<0){
open(filech);
} else {
run("Bio-Formats", "open=["+filech+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
chID=getImageID();
} else {
filech=dir+list[SlideIndex];
//open(filech);
run("Bio-Formats", "open=["+filech+"] autoscale color_mode=Default crop rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(ibg+1)+" "+specify+"end="+(ibg+1)+" "+specify+"step=1 x_coordinate_1="+xpreview+" y_coordinate_1="+ypreview+" width_1="+wpreview+" height_1="+hpreview);
//run("Bio-Formats", "open=["+filech+"] autoscale color_mode=Default rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(ibg+1)+" "+specify+"end="+(ibg+1)+" "+specify+"step=1");
chID=getImageID();
}
}
selectImage(chID);
makeRectangle(xbg, ybg, widthbg, heightbg);
run("Measure");
meanbg=getResult("Mean", ibg);
stdDevbg=getResult("StdDev", ibg);
if(!(bgsub[ibg]<0)){
bgsub[ibg]=meanbg+3*stdDevbg;
}
selectImage(chID);
close();
if(bgsubmode==bgdefarray[3]){
if(ffcheck){
open(flatfielddir+"bg"+canali[ibg]+".tif");
run("32-bit");
makeRectangle(xbg, ybg, widthbg, heightbg);
run("Measure");
run("Select All");
corrbgvalue=(getResult("Mean", 2*ibg)/getResult("Mean", 2*ibg+1));
if(isNaN(corrbgvalue)){
print(getResult("Mean", 2*ibg);
print(getResult("Mean", 2*ibg+1);
}
run("Multiply...", "value="+(getResult("Mean", 2*ibg)/getResult("Mean", 2*ibg+1)));
bgsub[ibg]=-getResult("Mean", 2*ibg)/getResult("Mean", 2*ibg+1);
waitForUser("Bg subtraction problem");
save(flatfielddir+"bg"+canali[ibg]+".tif");
print("Saved "+flatfielddir+"bg"+canali[ibg]+".tif; Correction Factor = "+(getResult("Mean", 2*ibg)/getResult("Mean", 2*ibg+1)));
close();
} else {
showMessage("Missing Background and/or Flatfield Reference Image.  Reset background value to avoid errors.");
}
}
}
if(isOpen("Results")){
selectWindow("Results");
run("Close");
}
setBatchMode("exit and display");
}                                     
}
}
}
/////////////////////////////////////////Minimum Cell Size////////////////////////////////////////////////////////////////////
if(analysischoice==analysisitems[1]){
analysisitems[1]="Minimum Cell Size";
mincellsize=0;
if(!isOpen(DAPIID)){
print("Please set the Background Subtraction Mode before...");
analysischoice=analysisitems[0];
} else {
while(mincellsize==0){
Dialog.createNonBlocking("Minimum cell size");
Dialog.addNumber("Min. Cell Size", 0, 0, 10, "pixels");
Dialog.addCheckbox("Get from ROI (Draw a ROI on the Nuclei Channel before pressing OK)", false);
Dialog.show();
mincellsize=Dialog.getNumber();
ROIcheck=Dialog.getCheckbox();
if(ROIcheck){
getSelectionBounds(x, y, width, height);
size=width*height;
if(size==imagewidth*imageheight){
selectImage(DAPIID);
showMessage("Please select a ROI");
} else {
mincellsize=size;
}
}
}
run("Select None");
analysisitems[1]=analysisitems[1]+": "+d2s(mincellsize,0);
}
}
/////////////////////////////////////////////Maximum Cell Size//////////////////////////////////////////////////////////////
if(analysischoice==analysisitems[2]){
analysisitems[2]="Maximum Cell Size";
maxcellsize=0;
if(!isOpen(DAPIID)){
print("Please set the Background Subtraction Mode before...");
analysischoice=analysisitems[0];
} else {
while(maxcellsize==0||(maxcellsize<=mincellsize)){
Dialog.createNonBlocking("Maximum cell size");
Dialog.addNumber("Max. Cell Size", 0, 0, 10, "pixels");
Dialog.addCheckbox("Get from ROI (Draw a ROI on the Nuclei Channel before pressing OK)", false);
Dialog.show();
maxcellsize=Dialog.getNumber();
ROIcheck=Dialog.getCheckbox();
if(ROIcheck){
getSelectionBounds(x, y, width, height);
size=width*height;
if(size==imagewidth*imageheight){
selectImage(DAPIID);
showMessage("Please select a ROI");
} else {
maxcellsize=size;
}
}
}
run("Select None");
analysisitems[2]=analysisitems[2]+": "+d2s(maxcellsize,0);
}
}
///////////////////////////////Threshold//////////////////////////////
if(analysischoice==analysisitems[3]){
analysisitems[3]="Threshold";
autothresholdindex=1;
if(!isOpen(DAPIID)){
if(multichannelcheck<0){
if(nd2check<0){
open(fileDAPI);
} else {
run("Bio-Formats", "open=["+fileDAPI+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
DAPIID=getImageID();
} else {
tstart=getTime();
run("Bio-Formats", "open=["+fileDAPI+"] autoscale color_mode=Default crop rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(chDAPI+1)+" "+specify+"end="+(chDAPI+1)+" "+specify+"step=1 x_coordinate_1="+xpreview+" y_coordinate_1="+ypreview+" width_1="+wpreview+" height_1="+hpreview);
tstop=getTime();
print(d2s((tstop-tstart)/1000,0)+" seconds elapsed");
DAPIID=getImageID();
}

selectImage(DAPIID);
if(bgsubmode==bgdefarray[3]){
FlatFieldCorr(chDAPI, DAPIID, false);
run("Smooth");
}else{
if(bgsubmode==bgdefarray[2]){
if(ffcorr){
FlatFieldCorr(chDAPI, DAPIID, true);
}
run("Subtract Background...", "rolling="+rollingbg);
} else {
if(bgsubmode==bgdefarray[1]){
run("Subtract...", "value="+bgsub[chDAPI]);
}
}
}
} else {
selectImage(DAPIID);
}
selectImage(DAPIID);
run("Select All");
setAutoThreshold();
run("Threshold...");
imagedepth=bitDepth();
selectWindow("Threshold");
waitForUser("Test the segmenting algorithms, press Set and set the choosen one from the list");
Dialog.create("Auto Thresholding");
Dialog.addChoice("Segmenting Algorithm: ", segment);
Dialog.addNumber("Erosion Factor (0-5): ", 3);
Dialog.show();
segmeth=Dialog.getChoice();
erosion=Dialog.getNumber();
if(isOpen("Threshold")){
selectWindow("Threshold");
run("Close");
}
selectImage(DAPIID);
getThreshold(lowthresh, upthresh);
if(upthresh<2^imagedepth){
upthresh=2^imagedepth;
}
resetThreshold();
analysisitems[3]=analysisitems[3]+": "+segmeth;
}
/////////////////////////////////////////Whole cell analysis Settings///////////////////////
if(analysischoice==analysisitems[4]){
analysisitems[4]="Whole Cell Analysis";
WholeCellString="";
wholecell=1;
Dialog.create("Whole Cell Analysis");
Dialog.addMessage("Select Channel to delimit Cell Membranes/Borders and Cytoplasm \n If Nuclei channel is selected, a Voronoi-based cell separation cab be selected");
Dialog.addChoice("Membrane Channel Identifier: ", canali);
Dialog.addCheckbox("Voronoi-based Cell Recognition (for nuclear markers e.g. DAPI)",false);
Dialog.addCheckbox("Apply Background Subtraction to Membrane Channel", false);
Dialog.addChoice("Cytoplasm Channel Identifier: ", canali);
Dialog.addCheckbox("Apply Background Subtraction to Cytoplasm Channel", false);
//Dialog.addNumber("Erosion Factor (0-5): ", 0);
Dialog.show();
membchannel=Dialog.getChoice();
VoronoiCheck=Dialog.getCheckbox();
bgMEMB=Dialog.getCheckbox();
cytochannel=Dialog.getChoice();
bgCELL=Dialog.getCheckbox();
//erosion=Dialog.getNumber();
for (ch=0; ch<channels; ch++){
if(canali[ch]==membchannel){
chMEMB=ch;
}
}
if(multichannelcheck<0){
fileMEMB=dir+list[channels*SlideIndex+chMEMB];
} else {
fileMEMB=dir+list[SlideIndex];
}
for (ch=0; ch<channels; ch++){
if(canali[ch]==cytochannel){
chCELL=ch;
}
}
if(multichannelcheck<0){
fileCELL=dir+list[channels*SlideIndex+chCELL];
} else {
fileCELL=dir+list[SlideIndex];
}
print("Opening Images: please be patient...");
if(!VoronoiCheck){
if(multichannelcheck<0){
if(nd2check<0){
open(fileMEMB);
} else {
run("Bio-Formats", "open=["+fileMEMB+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
MEMBID=getImageID();
run("Enhance Contrast", "saturated=0.5");
} else {
tstart=getTime();
run("Bio-Formats", "open=["+fileMEMB+"] autoscale color_mode=Default crop rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(chMEMB+1)+" "+specify+"end="+(chMEMB+1)+" "+specify+"step=1 x_coordinate_1="+xpreview+" y_coordinate_1="+ypreview+" width_1="+wpreview+" height_1="+hpreview);
tstop=getTime();
print(d2s((tstop-tstart)/1000,0)+" seconds elapsed");
MEMBID=getImageID();
}
selectImage(MEMBID);
if(ffcorr){
FlatFieldCorr(chMEMB, MEMBID, true);
MEMBID=getImageID();
}
rename("Membrane Channel");
//run("Add Image...", "image=[Nuclei Channel] x=0 y=0 opacity=50");
check=false;
while(!(check)){
Dialog.createNonBlocking("Find Maxima Settings to delineate membranes");
Dialog.addNumber("prominence value for Find Maxima", 200);
Dialog.addCheckbox("Light Background (Check if you are detecting membranes markers)", true);
Dialog.addCheckbox("Apply bg subtraction",false);
Dialog.show();
prom=Dialog.getNumber();
bgFindMax=Dialog.getCheckbox();
bgMEMB=Dialog.getCheckbox();
if(bgFindMax){
FindMaxString=" light ";
} else {
FindMaxString=" ";
}
if(bgMEMB){
if(!(isOpen("MembraneBGsub"))){
run("Duplicate...", "title=MembraneBGsub");
run("Subtract Background...", "rolling="+rollingbg);
MEMBID=getImageID();
}
}
selectImage(MEMBID);
MEMBIDtitle=getTitle();
run("Find Maxima...", "prominence="+prom+FindMaxString+"output=[Segmented Particles]");
selectImage(MEMBIDtitle+" Segmented");
run("Invert");
selectImage(MEMBID);
run("Add Image...", "image=["+MEMBIDtitle+" Segmented] x=0 y=0 opacity=50");
waitForUser("Check the Membrane Segmentation");
check=getBoolean("Is the result OK?", "Yes", "No");
if(!(check)){
run("Remove Overlay");
selectImage(MEMBIDtitle+" Segmented");
close();
//prom=getNumber("prominence value for Find Maxima", prom);
}
}
selectImage(MEMBIDtitle+" Segmented");
membranemaskID=getImageID();
rename("Membrane Mask");
run("Invert");
}
selectImage("Nuclei Channel");
run("Select All");
run("Duplicate...", "title=[Nuclei Mask]");
if(autothresholdindex==1){
setAutoThreshold(segmeth+" dark");
getThreshold(lowthresh, upthresh);
}
upthresh=655360;
setThreshold(maxOf(20,lowthresh), upthresh);
run("Convert to Mask");
//run("Watershed");
run("Duplicate...", "title=[Voronoi Mask]");
run("Voronoi");
setThreshold(1,255);
run("Convert to Mask");
if((chMEMB==chDAPI)&&VoronoiCheck){
run("Duplicate...", "title=[Membrane Mask]");
run("Invert");
}
selectImage("Nuclei Mask");
run("Duplicate...", "title=[Eroded Nuclei Mask]");
for(m=0; m<erosion; m++){
run("Erode");
}
selectImage("Voronoi Mask");
waitForUser("Voronoi Check");
run("Subtract...", "value=1");
//rename("Voronoi Mask");
if(multichannelcheck<0){
if(nd2check<0){
open(fileCELL);
} else {
run("Bio-Formats", "open=["+fileCELL+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
CELLID=getImageID();
} else {
tstart=getTime();
run("Bio-Formats", "open=["+fileCELL+"] autoscale color_mode=Default crop rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(chCELL+1)+" "+specify+"end="+(chCELL+1)+" "+specify+"step=1 x_coordinate_1="+xpreview+" y_coordinate_1="+ypreview+" width_1="+wpreview+" height_1="+hpreview);
tstop=getTime();
print(d2s((tstop-tstart)/1000,0)+" seconds elapsed");
CELLID=getImageID();
}                                                                     
selectImage(CELLID);
if(ffcorr){
FlatFieldCorr(chCELL, CELLID, true);
CELLID=getImageID();
}
rename("Cyto Channel");
check=false;
while(!(check)){
selectImage("Cyto Channel");
CELLID=getImageID();
if(bgCELL){
if(!(isOpen("CytoBGsub"))){
run("Duplicate...", "title=CytoBGsub");
run("Subtract Background...", "rolling="+rollingbg);
CELLID=getImageID();
}
}
run("Threshold...");
resetThreshold();
selectImage(CELLID);
setAutoThreshold(segmeth+" dark");
run("Threshold...");
Dialog.createNonBlocking("Cytoplasm "+canali[chCELL]+" Detection Settings: Select the threshold method");
//Dialog.create("Cytoplasm Thresholding:");
Dialog.addMessage("Choose the thresholding method for the cytoplasm");
Dialog.addChoice("Segmenting Algorithm: ", segment);
Dialog.addCheckbox("Apply Background Subtraction", bgCELL);
Dialog.show();
cytothreshold=Dialog.getChoice();
bgCELL=Dialog.getCheckbox();
if(startsWith(cytothreshold,segment[0])){
waitForUser("Cytoplasm "+canali[chCELL]+" Detection Settings", "Adjust the threshold to be applied to the images for subcompartment detection");
getThreshold(lowcyto, upcyto);
check=true;
setThreshold(lowcyto, upcyto);
} else { 
selectImage(CELLID);
run("Duplicate...", "title=Cyto Thresholded");
setAutoThreshold(cytothreshold+" dark");
setOption("BlackBackground", true);
//run("Convert to Mask");
check=getBoolean("Is the result OK?", "Yes", "No");
if(!check){
run("Close");
}
}
}
run("Convert to Mask");
cytoID=getImageID();
rename("Cyto Thresholded");
imageCalculator("min create", "Membrane Mask", "Cyto Thresholded");
//cellID=getImageID();
rename("Cell Mask");
imageCalculator("max", "Cell Mask", "Eroded Nuclei Mask");
imageCalculator("subtract create", "Cell Mask", "Voronoi Mask");
rename("Cell Comp Mask");
selectImage("Nuclei Mask");
run("Subtract...", "value=2");
imageCalculator("subtract ", "Cell Comp Mask", "Nuclei Mask");
selectImage("Cyto Thresholded");
close();
selectImage("Cell Mask");
close();
selectImage("Nuclei Mask");
close();
selectImage("Eroded Nuclei Mask");
close();
selectImage("Voronoi Mask");
close();
selectImage("Membrane Mask");
close();
if(isOpen("Membrane Channel")){
selectImage("Membrane Channel");
close();
}
if(isOpen("Cyto Channel")){
selectImage("Cyto Channel");
close();
}
analysisitems[4]=analysisitems[4]+": Active";
WholeCellString="Membrane Channel: "+membchannel+"; Cytoplasm Channel: "+cytochannel;
}////////end of if(analysischoice==analysisitems[4])/////////////////////
//////////Begin of subcomp detection settings////////////////////////////
for(ch=0; ch<channels; ch++){
if(subcompchoice==subcomplabels[ch]){
subcompindex[ch]=1;
Dialog.create("Subcompartment Description:");
Dialog.addMessage("Enter a tag for the subcompartment (type none to delete the choice)");
Dialog.addString("Description: ", " ");
Dialog.addCheckbox("Whole Cell Subcompartment: ", false);
Dialog.addCheckbox("Distance Measurements (Border)", false);
Dialog.show();
subcomptag=Dialog.getString();
if(subcomptag=="none"){
subcompindex[ch]=0;
subcomplabels[ch]=canali[ch];
} else {
subsubindex[ch]=subcomptag+"("+canali[ch]+")";
subcellindex[ch]=Dialog.getCheckbox();
if((subcellindex[ch])){
if(!(wholecell)){
showMessage("Whole Cell subcompartments can be activated with Whole Cell Analysis activated");
subcellindex[ch]=0;
}
}
subdistindex[ch]=Dialog.getCheckbox();
subcomplabels[ch]=subsubindex[ch];
Dialog.create("Analysed Channels for: \n"+subsubindex[ch]);
for(ksub=0; ksub<channels; ksub++){
Dialog.addCheckbox(canali[ksub],analysisindex[ch*channels+ksub]);
}
Dialog.show();
for(ksub=0; ksub<channels; ksub++){
analysisindex[ch*channels+ksub]=Dialog.getCheckbox();
if((subdistindex[ch]!=0)&&!(analysisindex[ch*channels+ksub])){
if(subdistindex[ch]<channels){
analysisindex[ch*channels+ksub]=1;
subdistindex[ch]=channels+ksub;
}
}
if(analysisindex[ch*channels+ksub]){
print(subsubindex[ch]+"["+canali[ksub]+"]");
}
}
Dialog.create("Subcompartment Minimum Size:");
Dialog.addMessage("Enter the minimal area (pixel) for the compartment");
Dialog.addNumber("Min Area: ", 0);
Dialog.show();
subminsize[ch]=Dialog.getNumber();
Dialog.create("Subcompartment Maximum Size:");
Dialog.addMessage("Enter the maximal area (pixel) for the compartment");
Dialog.addNumber("Max Area: ", maxcellsize);
Dialog.show();
submaxsize[ch]=Dialog.getNumber();
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////start of subcomp detection settings)//////////////////////////
print("Identifying cells...");
run("ROI Manager...");
if(!isOpen("Nuclei Channel")){
print("Opening Images: please be patient...");
tstart=getTime();
if(multichannelcheck<0){
if(nd2check<0){
open(fileDAPI);
} else {
run("Bio-Formats", "open=["+fileDAPI+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
DAPIID=getImageID();
} else {
run("Bio-Formats", "open=["+fileDAPI+"] autoscale color_mode=Default crop rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(chDAPI+1)+" "+specify+"end="+(chDAPI+1)+" "+specify+"step=1 x_coordinate_1="+xpreview+" y_coordinate_1="+ypreview+" width_1="+wpreview+" height_1="+hpreview);
//run("Bio-Formats", "open=["+fileDAPI+"] autoscale color_mode=Default rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(chDAPI+1)+" "+specify+"end="+(chDAPI+1)+" "+specify+"step=1");
DAPIID=getImageID();
}
if(bgsubmode==bgdefarray[3]){
FlatFieldCorr(chDAPI, DAPIID, false);
run("Smooth");
}else{
if(bgsubmode==bgdefarray[2]){
if(ffcorr){
FlatFieldCorr(chDAPI, DAPIID, true);
}
run("Subtract Background...", "rolling="+rollingbg);
}else{
if(bgsubmode==bgdefarray[1]){
run("Subtract...", "value="+bgsub[chDAPI]);
}
}
}
tstop=getTime();
print(d2s((tstop-tstart)/1000,0)+" seconds elapsed");
}
selectImage(DAPIID);
DAPIIDTitle=getTitle();
run("Select All");
if(autothresholdindex==1){
selectImage(DAPIID);
setAutoThreshold(segmeth+" dark");
getThreshold(lowthresh, upthresh);
}
upthresh=655360;
setThreshold(maxOf(20,lowthresh), upthresh);
run("Select None");
run("Set Measurements...", "area centroid center shape redirect=None decimal=3");
if(fillholescheck){
run("Analyze Particles...", "size="+mincellsize+"-"+maxcellsize+" pixel circularity=0.00-1.00 show=Masks exclude clear include");
} else {
run("Analyze Particles...", "size="+mincellsize+"-"+maxcellsize+" pixel circularity=0.00-1.00 show=Masks exclude clear");
}
//////////////////////////test excluding fill holes on a preexisting mask//////////
//selectImage(DAPIID);
//close();
if(nResults>0){
selectImage("Mask of "+DAPIIDTitle);
maskID=getImageID();
selectImage(maskID);
run("Grays");
for(m=0; m<erosion; m++){
run("Erode");
}
if(watercheck){
run("Watershed");
setOption("BlackBackground", true);
run("Erode");
run("Open");
}
run("ROI Manager...");
if(fillholescheck){
run("Analyze Particles...", "size="+mincellsize+"-"+maxcellsize+" pixel circularity=0.00-1.00 show=Nothing exclude clear include add");
} else {
run("Analyze Particles...", "size="+mincellsize+"-"+maxcellsize+" pixel circularity=0.00-1.00 show=Nothing exclude clear add");
}
selectImage(maskID);
close();
cellcount=roiManager("count");
if(cellcount!=nResults){
waitForUser("something went wrong");
}
print(nResults+" cells found");
if(subcellindex[ch]){
selectImage("Cell Comp Mask");
for(ic=0; ic<cellcount; ic++){
setThreshold(1,255);
roiManager("select", ic);
Roi.getBounds(x, y, width, height);
doWand(x+width/2,y+height/2, 1, "4-connected smooth");
//waitForUser("Check cell "+d2s(ic+1,0));
setThreshold(2,2);
run("Analyze Particles...", "size="+mincellsize+"-"+maxcellsize+" pixel circularity=0.00-1.00 show=Nothing  clear include");
if(nResults>1){
setThreshold(2,255);
run("Select None");
doWand(x+width/2,y+height/2, 1, "4-connected smooth");
//waitForUser("check splitting nuclei");
} 
name="0";
for(jc=0; jc<3-lengthOf(d2s(ic,0)); jc++){
name=name+"0";
}
name=name+d2s(ic,0);
Roi.setName(name);
roiManager("Add");
//waitForUser("Check cell "+name);
}
indexes=Array.getSequence(cellcount);
roiManager("select", indexes);
roiManager("delete");
}
////////////////////////////creation of images for subfilter method setting////////////////////////////////////////
setBatchMode(true);
if(!isOpen(subchID)){
print("Opening Images for subcomp "+subsubindex[ch]+": please be patient...");
tstart=getTime();
if(multichannelcheck<0){
filesubch=dir+list[channels*SlideIndex+ch];
if(nd2check<0){
open(filesubch);
} else {
run("Bio-Formats", "open=["+filesubch+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
} else {
filesubch=dir+list[SlideIndex];
run("Bio-Formats", "open=["+fileDAPI+"] autoscale color_mode=Default crop rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(ch+1)+" "+specify+"end="+(ch+1)+" "+specify+"step=1 x_coordinate_1="+xpreview+" y_coordinate_1="+ypreview+" width_1="+wpreview+" height_1="+hpreview);
//run("Bio-Formats", "open=["+filesubch+"] autoscale color_mode=Default rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(ch+1)+" "+specify+"end="+(ch+1)+" "+specify+"step=1");
}
subchID=getImageID();
tstop=getTime();
print(d2s((tstop-tstart)/1000,0)+" seconds elapsed");
}
print("No spot filter...");
selectImage(subchID);
if(bgsubmode==bgdefarray[3]){
FlatFieldCorr(ch, subchID, true);
run("Smooth");
} else {
if(bgsubmode==bgdefarray[2]){
if(ffcorr){
FlatFieldCorr(ch, subchID, true);
}
run("Subtract Background...", "rolling="+rollingbg);
}else{
if(bgsubmode==bgdefarray[1]){
run("Subtract...", "value="+bgsub[chDAPI]);
}
}
}
subchID=getImageID();
rename(subsubindex[ch]);
selectImage(subchID);
width=getWidth();
height=getHeight();
print("LoG Kernel...");
run("Duplicate...", "title="+subfilterlist[1]);
if(!isOpen("LoG kernel of "+canali[ch])){
LoGKernel(sqrt(subminsize[ch])/2, canali[ch]);
}
//run("Convolve 3D", "image="+subfilterlist[1]+" point=[LoG kernel of "+canali[ch]+"] extension=Mirror output=LoGsub["+canali[ch]+"]");
run("Convolve 3D", "image="+subfilterlist[1]+" point=[LoG kernel of "+canali[ch]+"] extension=Mirror normalize output=LoGsub["+canali[ch]+"]");
LoGID=getImageID();
rename("LoG_"+subsubindex[ch]);
selectImage(subfilterlist[1]);
close();
selectImage("LoG kernel of "+canali[ch]);
close();
//////end of creation of LoG setting image ///////////////////////////////
print("TopHat ...");
selectImage(subchID);
run("Duplicate...", "title="+subfilterlist[2]+"sub");
run("Duplicate...", "title=minmaxsub");
run("Minimum...", "radius="+sqrt(subminsize[ch]));
run("Maximum...", "radius="+sqrt(subminsize[ch]));
imageCalculator("subtract create", subfilterlist[2]+"sub", "minmaxsub");
THID=getImageID();
rename("TopHat_"+subsubindex[ch]);
selectImage(subfilterlist[2]+"sub");
close();
selectImage("minmaxsub");
close();
//////end of creation of TopHat setting image ///////////////////////////////
selectImage(subchID);
print("Variance filter ...");
run("Duplicate...", "title="+subfilterlist[3]+"sub");
run("Variance...", "radius="+sqrt(subminsize[ch])/2);
rename("Variance_"+subsubindex[ch]);
EDID=getImageID();
///////////////////////end of creation of Variance setting image ///////////////////////////////
selectImage(subchID);
print("RollingBall Spot Radius ...");
run("Duplicate...", "title="+subfilterlist[4]+"sub");
run("Subtract Background...", "rolling="+subminsize[ch]);
run("Smooth");
rename("RollingBallSpot_"+subsubindex[ch]);
//run("Minimum...", "radius="+sqrt(subminsize[ch]));
///////////Rolling Ball Spot Radius/////////////////////
run("Images to Stack", "method=[Copy (center)] name=subStack title="+subsubindex[ch]+" use");
subchID=getImageID();
setBatchMode("exit and display");
//run("ROI Manager...");
roiManager("select",0);
selectImage(subchID);
setAutoThreshold(segmeth+" dark");
run("Threshold...");
waitForUser("Subcompartment "+canali[ch]+" Detection Settings", "Select the subcompartment detection filter and threshold method");
Dialog.create("Subcompartment Detection Filter:");
Dialog.addMessage("Choose the Image Filtering process for the Subcompartment Detection");
Dialog.addChoice("Filtering Method: ", subfilterlist);
Dialog.show();
subfilterspot[ch]=Dialog.getChoice();
subgammafactor[ch]=-1;
Dialog.create("Subcompartment Thresholding:");
Dialog.addMessage("Choose the thresholding method for the subcompartment");
Dialog.addChoice("Segmenting Algorithm: ", segment);
Dialog.show();
subautothreshold[ch]=Dialog.getChoice();
if(startsWith(subautothreshold[ch],segment[0])){
waitForUser("Subcompartment "+canali[ch]+" Detection Settings", "Adjust the threshold to be applied to the images for subcompartment detection");
getThreshold(sublow, subup);
subthreshold[ch]=sublow;
}
///// end of subcomp setting for detection////////////////////////////////////
selectImage(subchID);
close();
}///////////////////nResults > 0 (check on the number of cells)//////////////
}////////////////////End of subcomp settings (subcomptag!="")////////////////
}/////////////////////End of subcompchoiche==...//////////////////////////////
}//////////////////////End of channels loop for subcomp choice////////////////
}///////////////////////End of settingschoice choice//////////////////////////
if(executionchoice==runlabels[0]){
Dialog.create("Saving Results")
resultsdir=File.getParent(dir);
File.setDefaultDir(resultsdir);
Dialog.create("Insert a short description for data (it will be used in the results filename)");
Dialog.addString("Experiment tag", "Ctrl");
Dialog.show();
tag=Dialog.getString();
batchlist=dir+"\t"+tag+"\n";
batchyesno=getBoolean("Do you have other directories to be analysed?");
while(batchyesno){
dir=getDirectory("Choose a Directory");
batchlist=batchlist+dir+"\t";
Dialog.create("Insert a short description for data (it will be used in the results filename)");
Dialog.addString("Experiment tag", "Ctrl");
Dialog.show();
tag=Dialog.getString();
batchlist=batchlist+tag+"\n";
batchyesno=getBoolean("Do you want to select another directory to be analysed?");
}
if(isOpen("Log")){
selectWindow("Log");
run("Close");
}
print(batchlist);
waitForUser("Do you want to proceed?");
Dialog.create("Test Run");
Dialog.addCheckbox("Execute a Test Run for the Analyis", false);
Dialog.addNumber("Number of test images: ", 1);
Dialog.show();
testcheck=Dialog.getCheckbox();
imgnumber=Dialog.getNumber();
resultsdir=getDirectory("Choose the directory to store results");
dirtaglist=split(batchlist, "\n");
for(ilist=0; ilist<lengthOf(dirtaglist); ilist++){
dirlist=split(dirtaglist[ilist], "\t");
dir=dirlist[0];
list=getFileList(dir);
Array.sort(list);
tag=dirlist[1];
total=list.length;
close("*");
analysedchannels=0;
subanalysedchannels=0;
run("Options...", "iterations=1 count=1 black edm=Overwrite");
lastrow="*"+"\t"+"*"+"\t"+"*"+"\t";
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
resultsfilepath=resultsdir+File.separator+tag+"_"+year+"_"+(month+1)+"_"+dayOfMonth+"_"+hour+"_"+minute+".txt";
resultsprint=File.open(resultsfilepath);
string="FilePath\t X\t Y\t  0: Cell_N.\t 0: Cell_Xc\t 0: Cell_Yc\t 0: Cell_Area\t 0: Cell_Circularity";
for(k=0; k<channels; k++){
string=string+"\t 0: Cell_Mean["+canali[k]+"] "+"\t 0: Cell_Total Intensity["+canali[k]+"]"+"\t 0: Cell_StdDev["+canali[k]+"] ";
analysedchannels=analysedchannels+1;
}
if(wholecell){
string=string+"\t 0: Cell_Whole_Area\t 0: Cell_Whole_Circularity"; 
for(k=0; k<channels; k++){
string=string+"\t 0: Cell__Whole_Mean["+canali[k]+"] "+"\t 0: Cell_Whole_Total Intensity["+canali[k]+"]"+"\t 0: Cell_Whole_StdDev["+canali[k]+"] ";   
}
string=string+"\t 0: Cell_Cyto_Area\t 0: Cell_Cyto_Circularity"; 
for(k=0; k<channels; k++){
string=string+"\t 0: Cell__Cyto_Mean["+canali[k]+"] "+"\t 0: Cell_Cyto_Total Intensity["+canali[k]+"]"+"\t 0: Cell_Cyto_StdDev["+canali[k]+"] ";   
}
}
for(k=0; k<channels; k++){
if(subcompindex[k]==1){
subanalysedchannels=subanalysedchannels+1;
string=string+"\t 0: Cell_Number ("+subsubindex[k]+")"+"\t 0: Cell_Average Size ("+subsubindex[k]+")"+"\t 0: Cell_Area ("+subsubindex[k]+")"+"\t 0: Cell_Area Fraction ("+subsubindex[k]+")" ;
for(kch=0; kch<channels; kch++){
if(kch==subdistindex[k]-channels){
string=string+"\t 0: Cell_Mean[BorderDistance] ("+subsubindex[k]+")"+"\t 0: Cell_Min[BorderDistance] ("+subsubindex[k]+")"+"\t 0: Cell_Max[BorderDistance] ("+subsubindex[k]+")";
} else {
string=string+"\t 0: Cell_Mean["+canali[kch]+"] ("+subsubindex[k]+")"+"\t 0: Cell_Total Intensity["+canali[kch]+"] ("+subsubindex[k]+")"+"\t 0: Cell_Fractional Intensity["+canali[kch]+"] ("+subsubindex[k]+")";
}
}
}
}////////end of Cell parameters data headings
subanalysedchannels=0;
for(k=0; k<channels; k++){
if(subcompindex[k]==1){
subanalysedchannels=subanalysedchannels+1;
string=string+"\t "+subanalysedchannels+": "+subsubindex[k]+"_# spot"+"\t "+subanalysedchannels+": "+subsubindex[k]+"_XM spot"+"\t "+subanalysedchannels+": "+subsubindex[k]+"_YM spot"+"\t "+subanalysedchannels+": "+subsubindex[k]+"_Area Spot"+"\t "+subanalysedchannels+": "+subsubindex[k]+"_Circ. Spot";                       
for(kch=0; kch<channels; kch++){
if(kch==subdistindex[k]-channels){
string=string+"\t "+subanalysedchannels+": "+subsubindex[k]+"_MeanSpot[BorderDistance]"+"\t "+subanalysedchannels+": "+subsubindex[k]+"_IntDenSpot[BorderDistance]"+"\t "+subanalysedchannels+": "+subsubindex[k]+"_StdDevSpot[BorderDistance]";
} else {
string=string+"\t "+subanalysedchannels+": "+subsubindex[k]+"_MeanSpot["+canali[kch]+"]"+"\t "+subanalysedchannels+": "+subsubindex[k]+"_IntDenSpot["+canali[kch]+"]"+"\t "+subanalysedchannels+": "+subsubindex[k]+"_StdDevSpot["+canali[kch]+"]";
}
}
}
}
//////////////////////////////////////////////////////////////////////end of heading construction//////////////////////////////////
print(resultsprint, string);
totspotNumber=newArray(subanalysedchannels);                                                           
setBatchMode(true);
h=0;
call("java.lang.System.gc");
if(!testcheck){
if(multichannelcheck<0){
imgnumber=total/channels;
} else {
imgnumber=total;
}
}
////////////insert above a stopping value imgnumber=* to limit the number of processed images for an initial test////
for(i=0; i<imgnumber; i++){
for(ick=1; ick<=nImages; ick++){
selectImage(ick);
title=getTitle();
if((indexOf(title, "Nuclei")>=0)||indexOf(title, "Mask")>=0||isOpen(DAPIID)){
selectImage(ick);
close();
}
}
waitingtime=0;
ank=0;
if(multichannelcheck<0){
file=dir+list[chDAPI+channels*i];
} else {
file=dir+list[i];
}
print("Analysed File Path: "+file);
if(multichannelcheck<0){
if((i+1)<imgnumber){
nextfile=dir+list[chDAPI+channels*(i+1)];
} else {
nextfile=dir+list[chDAPI+channels*i];
}
} else {
if((i+1)<imgnumber){
nextfile=dir+list[i+1];
} else {
nextfile=dir+list[i];
}
}
if(online){
if(!File.exists(file)){
print("The file:\n"+file+"\n is missing");
}
while((!File.exists(file))&&(!File.exists(nextfile))&&(waitingtime<300000)){
print("The file:\n"+file+"\n is missing at present...\n Waiting " + (5-waitingtime/60000)+" minutes");
wait(60000);
waitingtime=waitingtime+60000;
}
}
if(File.exists(file)){
IJ.redirectErrorMessages();
//run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel global");
while(!isOpen(DAPIID)){
if(multichannelcheck<0){
if(nd2check<0){
open(file);
} else {
run("Bio-Formats", "open=["+file+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
DAPIID=getImageID();
} else {
run("Bio-Formats", "open=["+file+"] autoscale color_mode=Default rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(chDAPI+1)+" "+specify+"end="+(chDAPI+1)+" "+specify+"step=1");
DAPIID=getImageID();
}
}
selectImage(DAPIID);
run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel global");
print("Actual image: "+getTitle());
if(bgsubmode==bgdefarray[3]){
FlatFieldCorr(chDAPI, DAPIID, false);
run("Smooth");
} else {
if(bgsubmode==bgdefarray[2]){
if(ffcorr){
FlatFieldCorr(chDAPI, DAPIID, true);
} 
run("Subtract Background...", "rolling="+rollingbg);
}else{
if(bgsubmode==bgdefarray[1]){
run("Subtract...", "value="+bgsub[chDAPI]);
}
}
}
DAPIID=getImageID();
rename("Nuclei Channel");
if(autothresholdindex==1){
selectImage(DAPIID);
setAutoThreshold(segmeth+" dark");
getThreshold(lowthresh, upthresh);
}
upthresh=65536;
setThreshold(maxOf(20,lowthresh), upthresh);
run("Select None");
run("Set Measurements...", "area centroid center shape redirect=None decimal=3");
if(fillholescheck){
run("Analyze Particles...", "size="+mincellsize+"-"+maxcellsize+" pixel circularity=0.00-1.00 show=Masks exclude clear include");
} else {
run("Analyze Particles...", "size="+mincellsize+"-"+maxcellsize+" pixel circularity=0.00-1.00 show=Masks exclude clear");
}
if(multichannelcheck<0){
findex=chDAPI+channels*i;
} else {
findex=i;
}
if(isOpen("Mask of Nuclei Channel")){
selectImage("Mask of Nuclei Channel");
rename("Nuclei");
maskID=getImageID();
}
if(nResults>0){
selectImage(maskID);
run("Grays");
if(watercheck){
run("Watershed");
setOption("BlackBackground", true);
run("Erode");
run("Open");
}
if(wholecell){
if(multichannelcheck<0){
fileMEMB=dir+list[channels*i+chMEMB];
} else {
fileMEMB=dir+list[i];
}
if(multichannelcheck<0){
fileCELL=dir+list[channels*i+chCELL];
} else {
fileCELL=dir+list[i];
}

if(multichannelcheck<0){
if(nd2check<0){
open(fileMEMB);
} else {
run("Bio-Formats", "open=["+fileMEMB+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
MEMBID=getImageID();
run("Enhance Contrast", "saturated=0.5");
} else {                                  
tstart=getTime();
run("Bio-Formats", "open=["+fileMEMB+"] autoscale color_mode=Default crop rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(chMEMB+1)+" "+specify+"end="+(chMEMB+1)+" "+specify+"step=1");
tstop=getTime();
print(d2s((tstop-tstart)/1000,0)+" seconds elapsed");
MEMBID=getImageID();
}
selectImage(MEMBID);
if(ffcorr){
FlatFieldCorr(chMEMB, MEMBID, true);
MEMBID=getImageID();
}
if(bgMEMB){
run("Subtract Background...", "rolling="+rollingbg);
MEMBID=getImageID();
}
rename("Membrane Channel");
if(!VoronoiCheck){
run("Find Maxima...", "prominence="+prom+FindMaxString+"output=[Segmented Particles]");
selectImage("Membrane Channel Segmented");
membranemaskID=getImageID();
rename("Membrane Mask");
selectImage("Nuclei");

} 
if(autothresholdindex==1){
selectImage(DAPIID);
setAutoThreshold(segmeth+" dark");
getThreshold(lowthresh, upthresh);
}
upthresh=65536;
setThreshold(maxOf(20,lowthresh), upthresh);
run("Convert to Mask");
run("Select All");
if(watercheck){
run("Watershed");
setOption("BlackBackground", true);
run("Erode");
run("Open");
}
run("Select All");
run("Duplicate...", "title=[Nuclei Mask]");
run("Duplicate...", "title=[Voronoi Mask]");
run("Voronoi");
setThreshold(1,255);
run("Convert to Mask");
if((chMEMB==chDAPI)&&VoronoiCheck){
run("Duplicate...", "title=[Membrane Mask]");
run("Invert");
}
selectImage("Nuclei Mask");
run("Duplicate...", "title=[Eroded Nuclei Mask]");
for(m=0; m<erosion; m++){
run("Erode");
}
selectImage("Voronoi Mask");
run("Subtract...", "value=1");
if(multichannelcheck<0){
if(nd2check<0){
open(fileCELL);
} else {
run("Bio-Formats", "open=["+fileCELL+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
CELLID=getImageID();
} else {
tstart=getTime();
run("Bio-Formats", "open=["+fileCELL+"] autoscale color_mode=Default crop rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(chCELL+1)+" "+specify+"end="+(chCELL+1)+" "+specify+"step=1");
tstop=getTime();
print(d2s((tstop-tstart)/1000,0)+" seconds elapsed");
CELLID=getImageID();
}
selectImage(CELLID);
if(ffcorr){
FlatFieldCorr(chCELL, CELLID, true);
CELLID=getImageID();
}
if(bgCELL){
run("Subtract Background...", "rolling="+rollingbg);
}
rename("Cyto Channel");
if(startsWith(cytothreshold,segment[0])){
setThreshold(lowcyto, 65536);
} else {
setAutoThreshold(cytothreshold+ " dark");
}
run("Convert to Mask");
cytoID=getImageID();
rename("Cyto Thresholded");
imageCalculator("min create", "Membrane Mask", "Cyto Thresholded");
cellID=getImageID();
rename("Cell Mask");
imageCalculator("max", "Cell Mask", "Eroded Nuclei Mask");
imageCalculator("subtract create", "Cell Mask", "Voronoi Mask");
rename("Cell Comp Mask");
selectImage("Nuclei Mask");
run("Subtract...", "value=2");
imageCalculator("subtract ", "Cell Comp Mask", "Nuclei Mask");
selectImage("Cyto Thresholded");
close();
selectImage("Cell Mask");
close();
selectImage("Nuclei Mask");
close();
selectImage("Eroded Nuclei Mask");
close();
selectImage("Voronoi Mask");
close();
selectImage("Membrane Mask");
close();
if(isOpen("Membrane Channel")){
selectImage("Membrane Channel");
close();
}
}
selectImage(maskID);
run("Select None");
run("Analyze Particles...", "size="+mincellsize+"-"+maxcellsize+" pixel circularity=0.00-1.00 show=Nothing exclude clear include");
nCells=nResults;
cellarea=newArray(nResults);
cellcircularity=newArray(nResults);
particlexcoord=newArray(nResults);
particleycoord=newArray(nResults);
xcoord=newArray(nResults);
ycoord=newArray(nResults);
if(wholecell){
wholecellarea=newArray(nResults);
wholecellcircularity=newArray(nResults);
wholeparticlexcoord=newArray(nResults);
wholeparticleycoord=newArray(nResults);
cytoarea=newArray(nResults);
cytocircularity=newArray(nResults);
}
for(j=0; j<nCells; j++){
cellarea[j]=getResult("Area", j);
cellcircularity[j]=getResult("Circ.",j);
xcoord[j]=getResult("X",j);
ycoord[j]=getResult("Y",j);
particlexcoord[j]=":";
particleycoord[j]=":";
selectImage(maskID);
doWand(getResult("X",j),getResult("Y",j),1, "4-connected smooth");
getSelectionCoordinates(xc,yc);
for(ipxc=0; ipxc<xc.length; ipxc++){
particlexcoord[j]=particlexcoord[j]+d2s(xc[ipxc],0)+":";
particleycoord[j]=particleycoord[j]+d2s(yc[ipxc],0)+":";
}
}
if(wholecell){
for(j=0; j<nCells; j++){
particlexcoord[j]=particlexcoord[j]+"|";
particleycoord[j]=particleycoord[j]+"|";
selectImage("Cell Comp Mask");
setThreshold(1,255);
doWand(xcoord[j],ycoord[j],1, "4-connected smooth");
setThreshold(2,2);
run("Analyze Particles...", "size="+mincellsize+"-"+maxcellsize+" pixel circularity=0.00-1.00 show=Nothing include");
if(nResults>1){
setThreshold(2,255);
doWand(xcoord[j],ycoord[j],1, "4-connected smooth");
}
List.setMeasurements;
wholecellarea[j]=maxOf(cellarea[j],List.getValue("Area"));
wholecellcircularity[j]=maxOf(0,List.getValue("Circ."));
if(wholecellarea[j]==cellarea[j]){
wholecellcircularity[j]=cellcircularity[j];
}
cytoarea[j]=maxOf(0,wholecellarea[j]-cellarea[j]);
cytocircularity[j]=wholecellcircularity[j];
getSelectionCoordinates(xc,yc);
for(ipxc=0; ipxc<xc.length; ipxc++){
particlexcoord[j]=particlexcoord[j]+d2s(xc[ipxc],0)+":";
particleycoord[j]=particleycoord[j]+d2s(yc[ipxc],0)+":";
}
}
}
selectImage(maskID);
run("Select All");
mean=newArray(analysedchannels*nResults);
max=newArray(analysedchannels*nResults);
totalfluo=newArray(analysedchannels*nResults);
if(wholecell){
meanwholecell=newArray(analysedchannels*nResults);
maxwholecell=newArray(analysedchannels*nResults);
totalfluowholecell=newArray(analysedchannels*nResults);
meancyto=newArray(analysedchannels*nResults);
maxcyto=newArray(analysedchannels*nResults);
totalfluocyto=newArray(analysedchannels*nResults);
}
for(k=0; k<channels; k++){
if(multichannelcheck<0){
file=dir+list[k+channels*i];
if(nd2check<0){
open(file);
} else {
run("Bio-Formats", "open=["+file+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
chID=getImageID();
} else {
file=dir+list[i];
run("Bio-Formats", "open=["+file+"] autoscale color_mode=Default rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(k+1)+" "+specify+"end="+(k+1)+" "+specify+"step=1");
chID=getImageID();
}
selectImage(chID);
if(bgsubmode==bgdefarray[3]){
FlatFieldCorr(k, chID, false);
run("Smooth");
}else{
if(bgsubmode==bgdefarray[2]){
if(ffcorr){
FlatFieldCorr(k, chID, true);
}
run("Subtract Background...", "rolling="+rollingbg);
} else {
if(bgsubmode==bgdefarray[1]){
run("Subtract...", "value="+bgsub[chDAPI]);
}
}
}
chID=getImageID();
rename(canali[k]);
print(canali[k]);
name="["+canali[k]+"]";
run("Set Measurements...", " mean standard centroid integrated redirect="+name+" decimal=3");
selectImage(maskID);
run("Select None");
run("Analyze Particles...", "size="+mincellsize+"-"+maxcellsize+" pixel circularity=0.00-1.00 show=Nothing exclude clear include");
for(j=0; j<nResults; j++){
max[ank+analysedchannels*j]=maxOf(0,getResult("StdDev", j));
mean[ank+analysedchannels*j]=maxOf(0,getResult("Mean",j));
totalfluo[ank+analysedchannels*j]=mean[ank+analysedchannels*j]*cellarea[j];
}
if(wholecell){
run("Clear Results");
for(j=0; j<nCells; j++){
selectImage(canali[k]);
wholexcoord=split(particlexcoord[j],"|");
wholeycoord=split(particleycoord[j],"|");
wholecellxcoord=split(wholexcoord[1],":");
wholecellycoord=split(wholeycoord[1],":");
makeSelection("polygon",wholecellxcoord, wholecellycoord);
List.setMeasurements;
maxwholecell[ank+analysedchannels*j]=maxOf(0,List.getValue("StdDev"));
meanwholecell[ank+analysedchannels*j]=maxOf(0,List.getValue("Mean"));
totalfluowholecell[ank+analysedchannels*j]=maxOf(0,List.getValue("IntDen"));
maxcyto[ank+analysedchannels*j]=maxwholecell[ank+analysedchannels*j];
totalfluocyto[ank+analysedchannels*j]=totalfluowholecell[ank+analysedchannels*j]-totalfluo[ank+analysedchannels*j];
if(cytoarea[j]==0){
meancyto[ank+analysedchannels*j]=0;
} else {
meancyto[ank+analysedchannels*j]=totalfluocyto[ank+analysedchannels*j]/cytoarea[j];
}
if(totalfluowholecell[ank+analysedchannels*j]<=totalfluo[ank+analysedchannels*j]){
totalfluowholecell[ank+analysedchannels*j]=totalfluo[ank+analysedchannels*j];
maxwholecell[ank+analysedchannels*j]=max[ank+analysedchannels*j];
meanwholecell[ank+analysedchannels*j]=mean[ank+analysedchannels*j];
totalfluocyto[ank+analysedchannels*j]=0;
maxcyto[ank+analysedchannels*j]=0;
meancyto[ank+analysedchannels*j]=0;
}
}
}
ank=ank+1;
selectImage(chID);
}
/////////////////////end of k cycle////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
subcompArea=newArray(nCells*subanalysedchannels);
spotNumber=newArray(nCells*subanalysedchannels);
spotArea=newArray(nCells*subanalysedchannels);
spotCirc=newArray(nCells*subanalysedchannels);
spotXM=newArray(nCells*subanalysedchannels);
spotYM=newArray(nCells*subanalysedchannels);
for(ixs=0; ixs<nCells*subanalysedchannels; ixs++){
spotArea[ixs]="|";
spotCirc[ixs]="|";
spotXM[ixs]="|";
spotYM[ixs]="|";
}
subcompAverSize=newArray(nCells*subanalysedchannels);
subcompNumber=newArray(nCells*subanalysedchannels);
subcompFracSize=newArray(nCells*subanalysedchannels);
subcompMeanFluo=newArray(nCells*subanalysedchannels*analysedchannels);
spotFluoMean=newArray(nCells*subanalysedchannels*analysedchannels);
spotFluoMax=newArray(nCells*subanalysedchannels*analysedchannels);
spotFluoInt=newArray(nCells*subanalysedchannels*analysedchannels);
for(ixs=0; ixs<nCells*subanalysedchannels*analysedchannels; ixs++){
spotFluoMean[ixs]="|";
spotFluoMax[ixs]="|";
spotFluoInt[ixs]="|";
}
subcompTotFluo=newArray(nCells*subanalysedchannels*analysedchannels);
subcompFracFluo=newArray(nCells*subanalysedchannels*analysedchannels);
isub=0;
run("Clear Results");
for(ksub=0; ksub<channels; ksub++){
if(subcompindex[ksub]!=0){
print("Subcomp "+canali[ksub]);
print("Distance from Border: "+subdistindex[ksub]);
if(isOpen("SubC"+canali[ksub])){
selectImage("SubC"+canali[ksub]);
close();
}
if(subdistindex[ksub]>0){
if(!isOpen("EDM_Nuclei")){
run("Options...", "iterations=1 count=1 black edm=16-bit");
selectImage(maskID);
run("Distance Map");
rename("EDM_Nuclei");
run("Options...", "iterations=1 count=1 black edm=Overwrite");
}
}
selectImage(canali[ksub]);
run("Select None");
if(startsWith(subfilterspot[ksub],subfilterlist[0])){
run("Duplicate...", "title=SubC"+canali[ksub]);
}
if(startsWith(subfilterspot[ksub], subfilterlist[1])){
if(!isOpen("LoG kernel of "+canali[ksub])){
LoGKernel(sqrt(subminsize[ksub])/2, canali[ksub]);
}
//run("Convolve 3D", "image="+canali[ksub]+" point=[LoG kernel of "+canali[ksub]+"] extension=Mirror output=SubC"+canali[ksub]);
run("Convolve 3D", "image="+canali[ksub]+" point=[LoG kernel of "+canali[ksub]+"] extension=Mirror normalize output=SubC"+canali[ksub]);
selectImage("LoG kernel of "+canali[ksub]);
close();
selectImage("SubC"+canali[ksub]);
}
if(startsWith(subfilterspot[ksub],subfilterlist[2])){
run("Duplicate...", "title=SubCstart");
run("Duplicate...", "title=SubCminmax");
run("Minimum...", "radius="+sqrt(subminsize[ksub])/2);
run("Maximum...", "radius="+sqrt(subminsize[ksub])/2);
imageCalculator("subtract create", "SubCstart", "SubCminmax");
rename("SubC"+canali[ksub]);
selectImage("SubCstart");
close();
selectImage("SubCminmax");
close();
selectImage("SubC"+canali[ksub]);
}
if(startsWith(subfilterspot[ksub],subfilterlist[3])){
run("Duplicate...", "title=SubC"+canali[ksub]);
run("Variance...", "radius="+sqrt(subminsize[ksub])/2);
}
if(startsWith(subfilterspot[ksub],subfilterlist[4])){
run("Duplicate...", "title=SubC"+canali[ksub]);
run("Subtract Background...", "rolling="+subminsize[ksub]);
run("Smooth");
}

for(j=0; j<nCells; j++){
particlexcoord[j]=particlexcoord[j]+"*";
particleycoord[j]=particleycoord[j]+"*";
if(subcellindex[ksub]==1){
selectImage("SubC"+canali[ksub]);
wholetruncx=substring(particlexcoord[j],0,indexOf(particlexcoord[j],"*"));
wholetruncy=substring(particleycoord[j],0,indexOf(particleycoord[j],"*"));
wholexcoord=split(wholetruncx,"|");
wholeycoord=split(wholetruncy,"|");
wholecellxcoord=split(wholexcoord[1],":");
wholecellycoord=split(wholeycoord[1],":");
//Array.show(wholecellxcoord, wholecellycoord);
makeSelection("polygon",wholecellxcoord, wholecellycoord);
} else {
selectImage(maskID);
run("Select None");
doWand(xcoord[j], ycoord[j],1, "4-connected smooth");
getSelectionCoordinates(xsubcoord,ysubcoord);
selectImage("SubC"+canali[ksub]);
makeSelection("polygon", xsubcoord, ysubcoord);
}
if(startsWith(subautothreshold[ksub],segment[0])){
setThreshold(subthreshold[ksub],1000000000);
} else {
setAutoThreshold(subautothreshold[ksub]+" dark");
getThreshold(lowpr,highpr);
}
run("Analyze Particles...", "size="+subminsize[ksub]+"-"+submaxsize[ksub]+" pixel circularity=0.00-1.00 show=Masks clear include");
if(nResults>0){
print("Found "+nResults+" spots for cell "+d2s(j,0));
selectImage("Mask of SubC"+canali[ksub]);
subcompmaskID=getImageID();
selectImage("Mask of SubC"+canali[ksub]);
run("Grays");
run("Watershed");
if(subcellindex[ksub]==1){
run("Set Measurements...", "area mean standard bounding shape integrated redirect=[Cell Comp Mask] decimal=3");
selectImage("Mask of SubC"+canali[ksub]);
makeSelection("polygon",wholecellxcoord, wholecellycoord);
} else {
selectImage(maskID);
doWand(xcoord[j], ycoord[j],1, "4-connected smooth");
getSelectionCoordinates(xsubcoord,ysubcoord);
selectImage("Mask of SubC"+canali[ksub]);
makeSelection("polygon", xsubcoord, ysubcoord);
run("Set Measurements...", "area mean standard bounding shape integrated redirect=[Nuclei] decimal=3");
}
run("Analyze Particles...", "size="+subminsize[ksub]+"-"+submaxsize[ksub]+" pixel circularity=0.00-1.00 show=Nothing clear include");
subcompfilter=newArray(nResults);
nspotsfiltered=0;
spotNumber[isub*nCells+j]=nResults;
for(ip=0; ip<nResults; ip++){
particlexcoord[j]=particlexcoord[j]+"|"+getResult("BX", ip)+":"+getResult("Width", ip);
particleycoord[j]=particleycoord[j]+"|"+getResult("BY", ip)+":"+getResult("Height", ip);
spotArea[isub*nCells+j]=spotArea[isub*nCells+j]+d2s(getResult("Area",ip),0)+"|";
subcompArea[isub*nCells+j]=subcompArea[isub*nCells+j]+getResult("Area",ip);
spotCirc[isub*nCells+j]=spotCirc[isub*nCells+j]+d2s(getResult("Circ.",ip),0)+"|";
nspotsfiltered=nspotsfiltered+1;
subcompfilter[ip]=1;

}
subcompNumber[isub*nCells+j]=nspotsfiltered;
if(nspotsfiltered!=0){
subcompAverSize[isub*nCells+j]=subcompArea[isub*nCells+j]/nspotsfiltered;
subcompFracSize[isub*nCells+j]=100*subcompArea[isub*nCells+j]/cellarea[j];
}
if(spotNumber[isub*nCells+j]!=0){
ich=0;
for(kch=0; kch<channels; kch++){
if(analysisindex[ksub*channels+kch]){
if(kch==subdistindex[ksub]-channels){
run("Set Measurements...", "mean standard min centroid center integrated redirect=EDM_Nuclei decimal=3");
} else {
run("Set Measurements...", "mean standard min centroid center integrated redirect="+canali[kch]+" decimal=3");
}
selectImage("Mask of SubC"+canali[ksub]);
run("Analyze Particles...", "size="+subminsize[ksub]+"-"+submaxsize[ksub]+" pixel circularity=0.00-1.00 show=Nothing clear include");
for(ip=0; ip<nResults; ip++){
if(kch==ksub){
spotXM[isub*nCells+j]=spotXM[isub*nCells+j]+d2s(getResult("XM",ip),0)+"|";
spotYM[isub*nCells+j]=spotYM[isub*nCells+j]+d2s(getResult("YM",ip),0)+"|";
}
if(kch==subdistindex[ksub]-channels){
spotFluoMean[j+nCells*ich+nCells*analysedchannels*isub]=spotFluoMean[j+nCells*ich+nCells*analysedchannels*isub]+d2s(maxOf(0,getResult("Mean",ip)),3)+"|";
spotFluoMax[j+nCells*ich+nCells*analysedchannels*isub]=spotFluoMax[j+nCells*ich+nCells*analysedchannels*isub]+d2s(maxOf(0,getResult("Min",ip)),3)+"|";
spotFluoInt[j+nCells*ich+nCells*analysedchannels*isub]=spotFluoInt[j+nCells*ich+nCells*analysedchannels*isub]+d2s(maxOf(0,getResult("Max",ip)),3)+"|";
} else {
spotFluoMean[j+nCells*ich+nCells*analysedchannels*isub]=spotFluoMean[j+nCells*ich+nCells*analysedchannels*isub]+d2s(maxOf(0,getResult("Mean",ip)),3)+"|";
spotFluoMax[j+nCells*ich+nCells*analysedchannels*isub]=spotFluoMax[j+nCells*ich+nCells*analysedchannels*isub]+d2s(maxOf(0,getResult("StdDev",ip)),3)+"|";
spotFluoInt[j+nCells*ich+nCells*analysedchannels*isub]=spotFluoInt[j+nCells*ich+nCells*analysedchannels*isub]+d2s(maxOf(0,getResult("IntDen",ip)),3)+"|";
}
if(subcompfilter[ip]==1){
subcompTotFluo[j+nCells*ich+nCells*analysedchannels*isub]=subcompTotFluo[j+nCells*ich+nCells*analysedchannels*isub]+maxOf(0,getResult("IntDen",ip));
}
}
if(nspotsfiltered!=0){
subcompMeanFluo[j+nCells*ich+nCells*analysedchannels*isub]=subcompTotFluo[j+nCells*ich+nCells*analysedchannels*isub]/nspotsfiltered;
subcompFracFluo[j+nCells*ich+nCells*analysedchannels*isub]=100*subcompTotFluo[j+nCells*ich+nCells*analysedchannels*isub]/totalfluo[analysedchannels*j+ich];
}

}
ich=ich+1;
}
//////////////////////////end loop on channels (kch)////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
////////////////////////////end if condition on the number of spots//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
selectImage("Mask of SubC"+canali[ksub]);
close();
}
//////////////////////////end if condition on nResults///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if(isOpen("Mask of SubC"+canali[ksub])){
selectImage("Mask of SubC"+canali[ksub]);
close();
}
}
//////////////////////////end loop on cells (j)///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
isub=isub+1;
selectImage("SubC"+canali[ksub]);
run("Close");
}
//////////////////////////end if condition on subcompindex/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
//////////////////////end of subcompartment analysis (ksub)////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
selectImage(maskID);
close();
if(isOpen("EDM_Nuclei")){
selectImage("EDM_Nuclei");
close();
}
for(k=0; k<channels; k++){
if(isOpen(canali[k])){
selectImage(canali[k]);
close();
}
}
for(j=0; j<nCells; j++){
h=h+1;
if(multichannelcheck<0){
fileindex=toString(channels*i);
} else {
fileindex=toString(i);
}
resultstring=fileindex+"\t "+particlexcoord[j]+"\t "+particleycoord[j]+"\t "+toString(h)+"\t "+xcoord[j]+"\t "+ycoord[j]+"\t "+cellarea[j]+"\t "+cellcircularity[j];
for(k=0; k<analysedchannels; k++){
resultstring=resultstring+"\t "+mean[k+analysedchannels*j]+"\t "+totalfluo[k+analysedchannels*j]+"\t "+max[k+analysedchannels*j];
}
if(wholecell){
resultstring=resultstring+"\t "+wholecellarea[j]+"\t "+wholecellcircularity[j];
for(k=0; k<analysedchannels; k++){
resultstring=resultstring+"\t "+meanwholecell[k+analysedchannels*j]+"\t "+totalfluowholecell[k+analysedchannels*j]+"\t "+maxwholecell[k+analysedchannels*j];
}
resultstring=resultstring+"\t "+cytoarea[j]+"\t "+cytocircularity[j];
for(k=0; k<analysedchannels; k++){
resultstring=resultstring+"\t "+meancyto[k+analysedchannels*j]+"\t "+totalfluocyto[k+analysedchannels*j]+"\t "+maxcyto[k+analysedchannels*j];
}
}
for(isub=0; isub<subanalysedchannels; isub++){
resultstring=resultstring+"\t "+subcompNumber[isub*nCells+j]+"\t "+subcompAverSize[isub*nCells+j]+"\t "+subcompArea[isub*nCells+j]+"\t "+subcompFracSize[isub*nCells+j];
for(ich=0; ich<analysedchannels; ich++){
resultstring=resultstring+"\t "+subcompMeanFluo[j+nCells*ich+nCells*analysedchannels*isub]+"\t "+subcompTotFluo[j+nCells*ich+nCells*analysedchannels*isub]+"\t "+subcompFracFluo[j+nCells*ich+nCells*analysedchannels*isub];
}
}
for(isub=0; isub<subanalysedchannels; isub++){
totspotNumber[isub]=totspotNumber[isub]+spotNumber[isub*nCells+j];
resultstring=resultstring+"\t"+spotNumber[isub*nCells+j]+"\t"+spotXM[isub*nCells+j]+"\t"+spotYM[isub*nCells+j]+"\t"+spotArea[isub*nCells+j]+"\t"+spotCirc[isub*nCells+j];
for(ich=0; ich<analysedchannels; ich++){
resultstring=resultstring+"\t"+spotFluoMean[j+nCells*ich+nCells*analysedchannels*isub]+"\t"+spotFluoInt[j+nCells*ich+nCells*analysedchannels*isub]+"\t"+spotFluoMax[j+nCells*ich+nCells*analysedchannels*isub];
}
}
print(resultsprint, resultstring);
}
///////////////////end of j cycle////////////////////////
if(wholecell){
if(isOpen(cellID)){
selectImage(cellID);
close();
}
}
} else {
print("No cells");
}
//////////////////end of if condition on particle detection (nResults>0)////////
if(isOpen(maskID)){
selectImage(maskID);
close();
}
if(isOpen(DAPIID)){
selectImage(DAPIID);
close();
}
} else {                                                         
if(i+1<imgnumber){
//wait(120000);
}
print("File Missing: "+file);
}
////////////////////////end of if condition on File.exists(file)////////////////
for(ick=1; ick<=nImages; ick++){
selectImage(ick);
title=getTitle();
if((indexOf(title, "Mask")>=0)||isOpen(DAPIID)){
selectImage(ick);
close();
}
}
}
///////////////////end of i cycle
for(k=0; k<channels; k++){
if(isOpen("LoG kernel of "+canali[k])){
selectImage("LoG kernel of "+canali[k]);
close();
}
if(isOpen("ff"+canali[k]+".tif")){
selectImage("ff"+canali[k]+".tif");
close();
}
if(isOpen("bg"+canali[k]+".tif")){
selectImage("bg"+canali[k]+".tif");
close();
}
}
lastrow=lastrow+toString(h)+"\t"+"*"+"\t"+"*"+"\t"+"*"+"\t"+"*";
for(k=0; k<analysedchannels; k++){
lastrow=lastrow+"\t"+"*"+"\t"+"*"+"\t"+"*";
}
for(isub=0; isub<subanalysedchannels; isub++){
lastrow=lastrow+"\t"+"*"+"\t"+"*"+"\t"+"*"+"\t"+"*";
for(ich=0; ich<analysedchannels; ich++){
lastrow=lastrow+"\t"+"*"+"\t"+"*"+"\t"+"*";
}
}
if(wholecell){
lastrow=lastrow+"\t"+"*"+"\t"+"*";
for(k=0; k<analysedchannels; k++){
lastrow=lastrow+"\t"+"*"+"\t"+"*"+"\t"+"*";
}
lastrow=lastrow+"\t"+"*"+"\t"+"*";
for(k=0; k<analysedchannels; k++){
lastrow=lastrow+"\t"+"*"+"\t"+"*"+"\t"+"*";
}
}
for(isub=0; isub<subanalysedchannels; isub++){
lastrow=lastrow+"\t"+totspotNumber[isub]+"\t"+"*"+"\t"+"*"+"\t"+"*"+"\t"+"*";
for(ich=0; ich<analysedchannels; ich++){
lastrow=lastrow+"\t"+"*"+"\t"+"*"+"\t"+"*";
}
}
print(resultsprint, lastrow);
print(resultsprint, dir+"_"+year+"_"+month+"_"+dayOfMonth+"_"+hour+"_"+minute);
print(resultsprint, "Analysis Parameters:");
print(resultsprint, "Segmentation Channel:\t"+canali[chDAPI]);
print(resultsprint, "Background Subtraction Mode:\t"+bgsubmode);
print(resultsprint, "Watershed:\t"+watercheck);       
print(resultsprint, "Watershed Radius:\t"+rollingbg);
print(resultsprint, "Segmentation Threshold Mode:\t"+segmeth);
print(resultsprint, "Minimun Cell Size:\t"+mincellsize);
print(resultsprint, "Maximum Cell Size:\t"+maxcellsize);
if(wholecell){
print(resultsprint, "Whole Cell Analysis:\t"+wholecell);
print(resultsprint, "Membrane Channel Identifier:\t"+membchannel);
print(resultsprint, "Voronoi Separation:\t"+VoronoiCheck);
print(resultsprint, "Background Subtraction for Membrane Channel:\t"+bgMEMB);
print(resultsprint, "Cytoplasm Channel Identifier:\t"+cytochannel);
print(resultsprint, "Background Subtraction for Cytoplasm Channel:\t"+bgCELL);
print(resultsprint, "Erosion Factor:\t"+erosion);
}
print(resultsprint, "Subcompartments:\t");

for(ch=0; ch<channels; ch++){
if(subcompindex[ch]==1){
print(resultsprint, "Channel:\t"+canali[ch]);
print(resultsprint, "Description:\t"+subsubindex[ch]);///////subcomplabels[ch] is identical to subsubindex[ch]/////////
print(resultsprint, "Whole Cell Subcompartment:\t"+subcellindex[ch]);
print(resultsprint, "Distance from border:\t"+subdistindex[ch]);
print(resultsprint, "Analysed channels:");
for(ksub=0; ksub<channels; ksub++){
print(resultsprint, canali[ksub]+"\t"+analysisindex[ch*channels+ksub]);
}
print(resultsprint, "Subcompartment Minimum Size:\t"+subminsize[ch]);
print(resultsprint, "Subcompartment Maximum Size:\t"+submaxsize[ch]);
print(resultsprint, "Filtering Method:\t"+subfilterspot[ch]);///////subgammafactor[ch]=-1;//////////
print(resultsprint, "Segmenting Algorithm:\t"+subautothreshold[ch]);
if(startsWith(subautothreshold[ch],segment[0])){
print(resultsprint, "Manual low subthreshold:\t"+subthreshold[ch]);
}
}
}
File.close(resultsprint);
print("Online Analysis executed");
selectWindow("Log");
setBatchMode("exit and display");
}////////////////////////End of Run Analysis Cycle///////////////////////////
}////////////////////////End of runlabels[0] if condition///////////////////////////
}////////////////////////End of While(settings check)/////////////////////////
}//////////////End of choice==item[1] (Analysis)//////////////////////////////
if(choice==items[2]) {
maincheck=false;
}
}//////////////End of while(maincheck)///////////////////////////////////////

/////////////////functions///////////////////////////////////////////////////
function LoGKernel(sigma, color){
newImage("LoG kernel of "+color, "32-bit black", 6*sigma+1, 6*sigma+1, 1);
for(x=0; x<6*sigma+1; x++){
for(y=0; y<6*sigma+1; y++){
xi=x-3*sigma;
yi=y-3*sigma;
sigma2=sigma*sigma;
//kernel=((xi*xi)/sigma2-1/sigma2*sigma2+(yi*yi)/sigma2-1/sigma2*sigma2)*exp(-0.5*(xi*xi+yi*yi)/sigma2);
/////old kernel. The next one has been modified to coincide with the LoG 3D plugin according to the standard formula////
kernel=(1/(2*PI*sigma2*sigma2))*((xi*xi)/(sigma2)-1+(yi*yi)/(sigma2)-1)*exp(-0.5*(xi*xi+yi*yi)/sigma2);
setPixel(x,y,kernel);
}
}
}
///////////////////////////////end of LoGKernel function////////////////////

function FlatFieldCorr(indchannel, IDchannel, fileclose){
BMcheck=is("Batch Mode");
selectImage(IDchannel);
//run("Subtract Background...", "rolling="+rollingbg+" sliding");
if(!isOpen(ffchannels[indchannel])){
open(flatfielddir+File.separator+ffchannels[indchannel]);
}
imageCalculator("divide create 32-bit", IDchannel, ffchannels[indchannel]);
rename("Result");
if(fileclose){
selectImage(ffchannels[indchannel]);
close();
} 
selectImage(IDchannel);
title=getTitle();
close();
selectImage("Result");
rename(title);
IDchannel=getImageID();
print("IDchannel: "+IDchannel);
changeValues(-1E99, 0, 0);
}
/////////////////////end of FlatFieldCorr function//////////////////////////
