/////// Stage position retrieval replaced by routine to generate position for images extracted from a high resolution map (Cattoretti: retrieval of the coordinates in the low resolution map starting from the high res images used for analysis//////////
/////////210918: Correct bug in retrieval of image pictures from different regions in the Show stats routine/////
///////buttons=newArray("Dot Plot"+resultsfilepath,"Histogram");
var dCut=20;
///////////////////dCut is the square of the cut off distance to avoid re-imaging of neighbouring cells; 30 um is the field of view linear size for single cell confocal acquisition with A1R 512x512 50 nm pixelsize//////////////
var autocheck=0;
var execheck=0;
var autostatscheck=0;
var recautostatscheck=0;
var autodistcheck=0;
var recautodistcheck=0;
var batchautostatscheck=false;
var ibatch=0;
var resultsfilename;
var firsttime;
var dotplotID;
var datatable;
var rawdatatable;
var listpict;
var maximum;
var minimum;
var checkautomax;
var checkautomin;
var counts;
var dir;
var resultsarray;
var activerenorm=false;
var jrenorm;
var jDAPI=0;
var renormgate="None";
var resultsfilepath;
var imagesdir;
var imageslist;
var analysedparameters;
var analysedparameterslist;
var analysedparameterslisttemp;
var subspotn;
var analysedchannels=0;
var checkwholecell;
var checkparam;
var checkstatslimit;
var counts;
var datatable;
var automaximum;
var autominimum;
var manualmaximum;
var manualminimum;
var maximum;
var minimum;
var smoothfactor;
var mean;
var fileIndex;
var cellIndex;
var spotnumber;
var Xcoord;
var Ycoord;
var voltage;
var offset;
var offsetxroi;
var offsetyroi;
var savedvoltage;
var savedoffset;
var jactcomp;
var jx;
var jy;
var listpict;
var listpictsize;
var updregionlist;
var regionlist;
var gatelist;
var updgatelist;
var activegateindex;
var updactivegateindex;
var arraygates;
var activegate;
var updactivegate;
var activegateweights;
var distancegateweights;
var renormweights;
var dsubI;
var dsubII;
var dsubIII;
var distcutoff;
var jdistI;
var jdistII;
var confdata=false;
var xmlmetadata;
var xmlsettingfile;
var listMSA;
var Field;
var FieldSpacing;
var pixdim;
var pixnumber;
var xmlTemplate;
var arrayrows;
var arraycolumns;
var stackslices=0;
var stacksdir;
var confdata=0;
var projmeth="Max Intensity";
var subcomp=0;
var subcomparray;
var jactcomp;
var subcompindexstart;
var subcompindexend;
var subcompcounts;
var fullanalysedparameters;
var activegateindexdp;
var checkstascomp;
var meanfilterDP=2;
var addchratio;
var addchnorm;
var addZfileindex;
var stagecoordcheck;
var Xstagecoor;
var Ystagecoor;
var Zfocuscoor;
var num;
var den;
var ratioxnum;
var ratioxden;
var axnum;
var bxnum;
var axden;
var bxden;
var normx;
var normxvalue;
var availablechind;
var chprefix;
var label;
var nd2check;
var multichannelcheck;
var canali;
var channels;
var stayon;
var stackOrder;
var specify;
var recordcheck=0;
recorder=newArray("Record","Execute","Stop");
x1array=newArray(1);
x1array[0]=-1;
y1array=newArray(1);
y1array[0]=-1;
reccellgallcheck=newArray(1);
recscalefactor=newArray(1);
reccheckstatsDP=newArray(1);
reccellmaskcheck=newArray(1);
recdCut=newArray(1);
recstageposcheck=newArray(1);
recdsubI=newArray(1);
recdsubII=newArray(1);
recdsubIII=newArray(1);
recdsubI[0]="None";
recdsubII[0]="None";
recdsubIII[0]="None";
recdistcutoff=newArray(1);
bgsub=0;
smoothfactor=0;
shiftobjx=0;
shiftobjy=30;
setFont("Sans Serif", 12, "bold");
//newImage("Results Panel", "RGB White", 512, 512, 1);
dplistID=10;
stayon=true;
alt=8;
leftButton=16;
xr=x=-1;
yr=y=-1;
jx=jy=-1;
jxcheck=0;
jycheck=0;
sliceDP=0;
sliceDPtag="";
jxstring="";
jystring="";
jactstring="";
agistring="";
mafdatastring="";
jxdp="|00:---|";
jydp="|00:---|";
jactcompdp="|00:00|";
//activegateindexdp="|00:0;None,0|";
//checkautoxmax=0;
//checkautoymax=0;
activegateindex=0;
offsetxroi=0;
offsetyroi=0;
dotplotindex=-1;
sliceCheck=false;
regionlist="Begin";
gatelist="None";
arraygates=split(gatelist,"\n");
firsttime=true;
resultsfilepath=File.openDialog("Select a File");
dir=File.getDirectory(resultsfilepath);
File.setDefaultDir(dir);
dataloading(resultsfilepath, firsttime);
firsttime=false;
regionindex=newArray(subcomp+1);
voltage=newArray(fullanalysedparameters);
Array.fill(voltage, 1);
offset=newArray(fullanalysedparameters);
Array.fill(offset, 0);
savedvoltage=newArray(fullanalysedparameters);
Array.fill(savedvoltage, -1);
savedoffset=newArray(fullanalysedparameters);
Array.fill(savedoffset, -1000);
//for(j=1; j<analysedparameters;j++){
//offset[j]=minOf(floor(minimum[j]/(maximum[j]/1)),1);
//}
//converteddata=newArray((counts-2)*(analysedparameters-1));
histogramdata=newArray(1024*(analysedparameters-1));
//multichannelcheck=0;
channels=1;
run("Bio-Formats Macro Extensions");
setBatchMode(true);
newImage("Dot Plot"+resultsfilepath, "RGB White", 1200, 1200, 1);
//toolselect=newArray( "rectangle", "roundrect", "elliptical", "brush", "polygon", "freehand", "line", "polyline", "freeline", "arrow", "angle", "point", "multipoint", "wand", "text", "zoom", "hand","dropper");
sliceDP=1;
sliceDPL=1;
dotplotID=getImageID();
dotplotscheme();
setBatchMode(false);
updateDisplay();
itool=0;
while(stayon){
selectImage("Dot Plot"+resultsfilepath);
if(isKeyDown("Alt")){
waitForUser("Break in the Macro Execution");
}
/////while(isOpen("Dot Plot"+resultsfilepath)){
while(getTitle()=="Dot Plot"+resultsfilepath){
if(execheck){
if(autocheck>0){
x1=x1array[lengthOf(x1array)-autocheck];
y1=y1array[lengthOf(y1array)-autocheck];
print("x1="+x1+"; y1="+y1);
autocheck=autocheck-1;
} else {
execheck=0;
}
} else {
getCursorLoc(x1,y1,z1,flags);
}
if(getTitle()!="Dot Plot"+resultsfilepath){
selectImage("Dot Plot"+resultsfilepath);
dotplotID=getImageID();
print("Done");
}

//print("dotplot ID is "+dotplotID+" with Title "+getTitle()+" Status: "+isActive(dotplotID)+" active; x1="+x1+";y1="+y1);
setFont("Sans Serif", 12, "bold");
run("Line Width...", "line=1");
if(!((y1<1045)&&(x1<1039))){
if(IJ.getToolName()!="hand"){
setTool(12);
print("changed");
}
} else {
if(is("Caps Lock Set")){
itool=2;
} else {
itool=0;
}
if(toolID!=itool){
setTool(itool);
} 
}
if((getSliceNumber()!=sliceDPL)&&(jx!=-1)&&(jy!=-1)){
sliceCheck=true;
}

//print("sliceCheck="+sliceCheck+"; leftButton="+leftButton);


if(((flags&leftButton !=0)&&((x1!=x)||(y1!=y)))||sliceCheck){ 
x=x1; y=y1;
///////////////////////////////start of location of pressed button//////////////////////
if((x1>15)&&(x1<59)&&(y1>1055)&&(y1<1070)){
choiceparameterslist="|";
for(ich=0; ich<(subcompindexend[jactcomp]-subcompindexstart[jactcomp]);ich++){
if(checkparam[subcompindexstart[jactcomp]+ich]){
choiceparameterslist=choiceparameterslist+"|"+analysedparameterslist[subcompindexstart[jactcomp]+ich];
}
}
choiceparameters=split(choiceparameterslist, "|");
while(jxcheck==0){
Dialog.create("Parameters:");
if(jactcomp==0){
Dialog.addChoice("X axis: ", choiceparameters, choiceparameters[jDAPI]);
} else {
Dialog.addChoice("X axis: ", choiceparameters);
}
Dialog.show();
axis=Dialog.getChoice();
for(ch=0; ch<fullanalysedparameters; ch++){
if(axis==analysedparameterslist[ch]){
jx=ch;
selectImage(dotplotID);
sliceDP=getSliceNumber();
print("Slice Number: "+sliceDP+"; Axis Index: "+jx);
if(sliceDP<11){sliceDPtag="0"+d2s(sliceDP-1,0);} else {sliceDPtag=d2s(sliceDP-1,0);}
if(jx<100){if(jx<10){jxstring="00"+d2s(jx,0);}else{jxstring="0"+d2s(jx,0);}} else {jxstring=d2s(jx,0);}
if(lengthOf(jxdp)>sliceDP*7){
jxdp=replace(jxdp,substring(jxdp, (sliceDP-1)*7+1,sliceDP*7), sliceDPtag+":"+jxstring);
} else {
jxdp=jxdp+sliceDPtag+":"+jxstring+"|";
}
print("jxdp: "+jxdp);
}
}
if(jx>0){jxcheck=1;}
}
jxcheck=0;
setColor(255,255,255);
fillRect(70, 1058, 300, 12);
fillRect(175, 1078, 30, 12);
fillRect(360, 1078, 30, 12);
setColor(0,0,0);
drawString(analysedparameterslist[jx]+";", 70, 1070);
drawString(d2s(voltage[jx],2), 175, 1090);
drawString(offset[jx], 360, 1090);
setColor(255,255,255);
fillRect(71, 1077, 98, 12);
setColor(0,0,255);
fillRect(71, 1077, voltage[jx]/0.1, 12);
setColor(255,255,255);
fillRect(251, 1077, 98, 12);
setColor(0,0,255);
fillRect(251, 1077, 50+offset[jx]/10, 12);
setColor(0,0,0);
if(jy!=-1){

gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);

}
}
////////////////////////////////////////////////////////////////////end of x axis choice//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>15)&&(x1<59)&&(y1>1095)&&(y1<1110)){
choiceparameterslist="|";
print("Active Compartment: "+subcomparray[jactcomp]+"; jactcomp: "+jactcomp);
for(ich=0; ich<(subcompindexend[jactcomp]-subcompindexstart[jactcomp]);ich++){
if(checkparam[subcompindexstart[jactcomp]+ich]){
choiceparameterslist=choiceparameterslist+"|"+analysedparameterslist[subcompindexstart[jactcomp]+ich];
}
}
choiceparameters=split(choiceparameterslist, "|");
Dialog.create("Parameters:");
Dialog.addChoice("Y axis: ", choiceparameters);
Dialog.addNumber("Histogram Smooth Factor (HSF) (average over the HSF- elements before and after each point)", smoothfactor);
Dialog.show();
axis=Dialog.getChoice();
smoothfactor=Dialog.getNumber();
for(ch=0; ch<fullanalysedparameters; ch++){
if(axis==analysedparameterslist[ch]){
jy=ch;
selectImage(dotplotID);
sliceDP=getSliceNumber();
print("Slice Number: "+sliceDP);
if(sliceDP<11){sliceDPtag="0"+d2s(sliceDP-1,0);} else {sliceDPtag=d2s(sliceDP-1,0);}
if(jy<100){if(jy<10){jystring="00"+d2s(jy,0);}else{jystring="0"+d2s(jy,0);}} else {jystring=d2s(jy,0);}
if(lengthOf(jydp)>(sliceDP)*7){
jydp=replace(jydp,substring(jydp, (sliceDP-1)*7+1,sliceDP*7), sliceDPtag+":"+jystring);
} else {
jydp=jydp+sliceDPtag+":"+jystring+"|";
}
print("jydp: "+jydp);
}
}
setColor(255,255,255);
fillRect(70, 1098, 300, 12);
fillRect(175, 1118, 30, 12);
fillRect(360, 1118, 30, 12);
setColor(0,0,0);
drawString(analysedparameterslist[jy]+";", 70, 1110);
drawString(d2s(voltage[jy],2), 175, 1130);
drawString(offset[jy], 360, 1130);
setColor(255,255,255);
fillRect(71, 1117, 98, 12);
setColor(0,0,255);
fillRect(71, 1117, voltage[jy]/0.1, 12);
setColor(255,255,255);
fillRect(251, 1117, 98, 12);
setColor(0,0,255);
fillRect(251, 1117, 50+offset[jy]/10, 12);
setColor(0,0,0);
if(jx!=-1){

gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);
 
}
}
////////////////////////////////////////////////////////////////////end of y axis choice//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1044)&&(x1<1114)&&(y1>778)&&(y1<795)){
if(jx!=-1){
minimum[jx]=autominimum[jx];
checkautomin[jx]=0;
}
if(jy!=-1){

gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);

}
}
///////////////////////////////////////////////////////////////////end of autoScale Min X///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1044)&&(x1<1114)&&(y1>838)&&(y1<855)){
if(jx!=-1){
Dialog.create("Manual Scale X-axis:");
Dialog.addNumber("X minimum value:", autominimum[jx]);
Dialog.show();
manualminimum[jx]=Dialog.getNumber();
minimum[jx]=manualminimum[jx];
checkautomin[jx]=1;
}
if(jy!=-1){

gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);

}
}
//////////////////////////////////////////////////////////////////end of ManualScale Min X/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1044)&&(x1<1114)&&(y1>918)&&(y1<935)){
if(jy!=-1){
minimum[jy]=autominimum[jy];
checkautomin[jy]=0;
}
if(jx!=-1){

gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);

}
}
///////////////////////////////////////////////////////////////////end of autoScale Min Y////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1044)&&(x1<1114)&&(y1>978)&&(y1<995)){
if(jy!=-1){
Dialog.create("Manual Scale Y-axis:");
Dialog.addNumber("Y minimum value:", autominimum[jy]);
Dialog.show();
manualminimum[jy]=Dialog.getNumber();
minimum[jy]=manualminimum[jy];
checkautomin[jy]=1;
}
if(jx!=-1){

gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);

}
}
//////////////////////////////////////////////////////////////////end of ManualScale Min Y///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1121)&&(x1<1191)&&(y1>778)&&(y1<795)){
if(jx!=-1){
maximum[jx]=automaximum[jx];
checkautomax[jx]=0;
}
if(jy!=-1){

gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);

}
}
///////////////////////////////////////////////////////////////////end of autoScale X///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1121)&&(x1<1191)&&(y1>838)&&(y1<855)){
if(jx!=-1){
Dialog.create("Manual Scale X-axis:");
Dialog.addNumber("X maximum value:", automaximum[jx]);
Dialog.show();
manualmaximum[jx]=Dialog.getNumber();
maximum[jx]=manualmaximum[jx];
checkautomax[jx]=1;
}
if(jy!=-1){

gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);

}
}
//////////////////////////////////////////////////////////////////end of ManualScale X/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1121)&&(x1<1197)&&(y1>918)&&(y1<935)){
if(jy!=-1){
maximum[jy]=automaximum[jy];
checkautomax[jy]=0;
}
if(jx!=-1){

gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);

}
}
///////////////////////////////////////////////////////////////////end of autoScale Y////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1121)&&(x1<1191)&&(y1>978)&&(y1<995)){
if(jy!=-1){
Dialog.create("Manual Scale Y-axis:");
Dialog.addNumber("Y maximum value:", automaximum[jy]);
Dialog.show();
manualmaximum[jy]=Dialog.getNumber();
maximum[jy]=manualmaximum[jy];
checkautomax[jy]=1;
}
if(jx!=-1){

gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);

}
}
//////////////////////////////////////////////////////////////////end of ManualScale Y///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1121)&&(x1<1191)&&(y1>8)&&(y1<25)){
setTool("point");
xpict=-1; ypict=-1;
activeretrieval=1;
stageposcheck=0;
while(activeretrieval==1){
run("Show Overlay");
getCursorLoc(x2,y2,z2,flags);

if((flags&leftButton !=0)&&((x2!=xpict)||(y2!=ypict))){
xpict=x2; ypict=y2;

if((xpict>8)&&(xpict<1031)&&(ypict>8)&&(ypict<1031)&&!(((getPixel(xpict,ypict)>>16)&0xff==255)&&((getPixel(xpict,ypict)>>8)&0xff==255)&&((getPixel(xpict,ypict))&0xff==255))){
if(jy==0){ypict=8;}
picture=split(listpict[xpict-8+1024*(ypict-8)], ":");

////////////begin new procedure////////////////
if(picture.length>1){
displayedrange=newArray(2*analysedchannels);
xmidraw=newArray(1);
ymidraw=newArray(1);
for(ich=0; ich<analysedchannels; ich++){
displayedrange[2*ich]=65536;
displayedrange[2*ich+1]=0;
}
scalefactor=2;
setBatchMode(true);
subind=0;
subnumb=0;
for(ijsub=1; ijsub<jactcomp; ijsub++){
subind=subind+(5+3*analysedchannels)*subcompcounts[ijsub];
subnumb=subnumb+subcompcounts[ijsub];
}
chkimgch=newArray(analysedchannels);
cellgallcheck=1;               
Array.fill(chkimgch,1);
flx=1*(xpict-8);
fly=1023-1*(ypict-8);
rtvdimagename=analysedparameterslist[jx]+": "+d2s(flx,0)+", "+analysedparameterslist[jy]+": "+d2s(fly,0);
concstring="[Gallery_"+rtvdimagename+"]";
concstringimgnames=rtvdimagename+"\n";
concstringcell="[Cell_Gallery_"+rtvdimagename+"]";
k=1;
kcell=0;
for(i=1; i<lengthOf(picture); i++){
if(jactcomp==0){
indicecell=parseInt(picture[i]);
} else {
indicecell=cellIndex[parseInt(picture[i])];
}
fileID=parseInt(fileIndex[indicecell]);
if(lengthOf(picture)<2){
//regcellIndexarray[0]=indicecell;
xmidraw[0]=datatable[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))*analysedparameters+subind+(parseInt(picture[i])-subnumb)*(5+3*analysedchannels)+1];
ymidraw[0]=datatable[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))*analysedparameters+subind+(parseInt(picture[i])-subnumb)*(5+3*analysedchannels)+2];

} else {
//regcellIndexarray=Array.concat(regcellIndexarray,indicecell);
xmidraw=Array.concat(xmidraw,datatable[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))*analysedparameters+subind+(parseInt(picture[i])-subnumb)*(5+3*analysedchannels)+1]);
ymidraw=Array.concat(ymidraw,datatable[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))*analysedparameters+subind+(parseInt(picture[i])-subnumb)*(5+3*analysedchannels)+2]);
}

if(!isOpen("FileID_"+fileID)){
if(!confdata){
if(multichannelcheck<1){
for(it=0; it<analysedchannels; it++){
if(chkimgch[it]>0){
target=imagesdir+imageslist[fileID+it];
if(nd2check<0){
open(target);
} else {
run("Bio-Formats", "open=["+target+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
}
}
if(nd2check<0){
run("Images to Stack", "method=[Copy (center)] name="+substring(imageslist[fileID], 0, lastIndexOf(imageslist[fileID], "--"))+" title="+substring(imageslist[fileID], 0, lastIndexOf(imageslist[fileID], "--"))+" use");
} else {
infostring=Property.getInfo();
infoarray=split(infostring, "\n");
////Array.show(infoarray);
for(ii=0; ii<lengthOf(infoarray); ii++){
if(indexOf(infoarray[ii],"SizeC")>0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
sizeC=parseInt(C[1]);
print("sizeC: "+C[1]);
}
if(indexOf(infoarray[ii],"SizeX")>0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
sizeX=parseInt(C[1]);
print("sizeX: "+sizeX);
}
if(indexOf(infoarray[ii],"SizeY")>0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
sizeY=parseInt(C[1]);
print("sizeY: "+sizeY);
}
if(indexOf(infoarray[ii],"dCalibration")>=0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
pixelsizeX=pixelsizeY=parseFloat(C[1]);
print("pixelsizeX: "+pixelsizeX);
}
if(indexOf(infoarray[ii],"Number of Picture Planes")>=0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
imageCount=parseInt(C[1]);
print("Planes: "+imageCount);
}
if(indexOf(infoarray[ii],"dXPos")>=0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
stagepositionX=parseFloat(C[1]);
print("stageXpos: "+stagepositionX);
}
if(indexOf(infoarray[ii],"dYPos")>=0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
stagepositionY=parseFloat(C[1]);
print("stageYpos: "+stagepositionY);
}
if(indexOf(infoarray[ii],"dZPos")>=0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
stagepositionZ=parseFloat(C[1]);
print("stageZpos: "+stagepositionZ);
}
}
xcenter=sizeX/2;
ycenter=sizeY/2;
run("Images to Stack", "method=[Copy (center)] name="+substring(imageslist[fileID], 0, lastIndexOf(imageslist[fileID], "_"))+" title="+substring(imageslist[fileID], 0, lastIndexOf(imageslist[fileID], "_"))+" use");
}
sequenceID=getImageID();
} else {
target=imagesdir+imageslist[fileID];
print("target: "+target);
run("Bio-Formats", "open=["+target+"] autoscale color_mode=Default rois_import=[ROI manager] view=[Standard ImageJ] stack_order=XYCZT ");
sequenceID=getImageID();
run("Subtract Background...", "rolling=100");
infostring=Property.getInfo();
infoarray=split(infostring, "\n");
////Array.show(infoarray);
for(ii=0; ii<lengthOf(infoarray); ii++){
if(indexOf(infoarray[ii],"SizeC")>0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
sizeC=parseInt(C[1]);
print("sizeC: "+C[1]);
}
if(indexOf(infoarray[ii],"SizeX")>0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
sizeX=parseInt(C[1]);
print("sizeX: "+sizeX);
}
if(indexOf(infoarray[ii],"SizeY")>0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
sizeY=parseInt(C[1]);
print("sizeY: "+sizeY);
}
if(indexOf(infoarray[ii],"dCalibration")>=0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
pixelsizeX=pixelsizeY=parseFloat(C[1]);
print("pixelsizeX: "+pixelsizeX);
}
if(indexOf(infoarray[ii],"Number of Picture Planes")>=0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
imageCount=parseInt(C[1]);
print("Planes: "+imageCount);
}
if(indexOf(infoarray[ii],"dXPos")>=0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
stagepositionX=parseFloat(C[1]);
print("stageXpos: "+stagepositionX);
}
if(indexOf(infoarray[ii],"dYPos")>=0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
stagepositionY=parseFloat(C[1]);
print("stageYpos: "+stagepositionY);
}
if(indexOf(infoarray[ii],"dZPos")>=0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
stagepositionZ=parseFloat(C[1]);
print("stageZpos: "+stagepositionZ);
}
}
xcenter=sizeX/2;
ycenter=sizeY/2;
//Ext.setId(target);
//Ext.getSizeX(sizeX);
//Ext.getSizeY(sizeY);
//Ext.getPixelsPhysicalSizeX(pixelsizeX);
//Ext.getPixelsPhysicalSizeY(pixelsizeY);
//Ext.getPixelsPhysicalSizeZ(pixelsizeZ);
//Ext.getSizeC(sizeC);
//Ext.getSizeT(sizeT);
//print("Image Physical Size is " + sizeX + " x " + sizeY);
//print("Focal plane spacing = " + sizeZ);
//Ext.getImageCount(imageCount);
//positionX = newArray(imageCount);
//positionY = newArray(imageCount);
//positionZ = newArray(imageCount);
//Ext.getPlanePositionX(stagepositionX, 0);
//Ext.getPlanePositionY(stagepositionY, 0);
//Ext.getPlanePositionZ(stagepositionZ, 0);
//print("\tplane #" + (0 + 1));
//print("\t\tX = " + positionX);
//print("\t\tY = " + positionY);
//print("\t\tZ = " + positionZ);
}
} else {


}

selectImage(sequenceID);
depthseq=bitDepth();
setSlice(nSlices);
for(sl=0; sl<subcomp+1; sl++){
run("Add Slice");
}
if(checkwholecell){
run("Add Slice");
}
rename("FileID_"+fileID);
concstring=concstring+" image"+d2s(k,0)+"=FileID_"+fileID;
concstringimgnames=concstringimgnames+"FileID_"+fileID+"\n";
k=k+1;
}
selectImage("FileID_"+fileID);
setSlice(analysedchannels+1);
setColor(255);
XcoordIndex=newArray(subcomp+2);
YcoordIndex=newArray(subcomp+2);
for(icoord=1; icoord<subcomp+1; icoord++){
XcoordIndex[icoord]=indexOf(Xcoord[indicecell], "*", XcoordIndex[icoord-1]+1);
YcoordIndex[icoord]=indexOf(Ycoord[indicecell], "*", YcoordIndex[icoord-1]+1);
}
XcoordIndex[subcomp+1]=lengthOf(Xcoord[indicecell]);
YcoordIndex[subcomp+1]=lengthOf(Ycoord[indicecell]);
Xtemp=newArray(subcomp+1);
Ytemp=newArray(subcomp+1);
for(icoord=0; icoord<subcomp+1; icoord++){
Xtemp[icoord]=substring(Xcoord[indicecell], XcoordIndex[icoord],XcoordIndex[icoord+1]);
Ytemp[icoord]=substring(Ycoord[indicecell], YcoordIndex[icoord],YcoordIndex[icoord+1]);
}
if(checkwholecell){
WholeXtemp=split(Xtemp[0],"\|");
WholeYtemp=split(Ytemp[0],"\|");
Xtempii=split(WholeXtemp[0],"\:");
Ytempii=split(WholeYtemp[0],"\:");
WholeXtempii=split(WholeXtemp[1],"\:");
WholeYtempii=split(WholeYtemp[1],"\:");
} else {
Xtempii=split(Xtemp[0],"\:");
Ytempii=split(Ytemp[0],"\:");
}
X=newArray(Xtempii.length-1);
Y=newArray(Ytempii.length-1);
for(ix=1; ix<Xtempii.length; ix++){
X[ix-1]=parseInt(Xtempii[ix]);
Y[ix-1]=parseInt(Ytempii[ix]);
}
makeSelection("polygon", X, Y);
run("Colors...", "foreground=white background=black selection=yellow");
run("Line Width...", "line=5");
//run("Draw", "slice");
run("Fill", "slice");
if(checkwholecell){
setSlice(analysedchannels+2);
X=newArray(WholeXtempii.length-1);
Y=newArray(WholeYtempii.length-1);
for(ix=1; ix<WholeXtempii.length; ix++){
X[ix-1]=parseInt(WholeXtempii[ix]);
Y[ix-1]=parseInt(WholeYtempii[ix]);
}
makeSelection("polygon", X, Y);
Color.set(128);
//run("Colors...", "foreground=white background=black selection=yellow");
//run("Draw", "slice");
run("Fill", "slice");
}
run("Line Width...", "line=1");
for(ipcont=1; ipcont<lengthOf(Xtemp); ipcont++){
subindraw=0;
subnumbdraw=0;
for(ijsub=1; ijsub<ipcont; ijsub++){
subnumbdraw=subnumbdraw+subcompcounts[ijsub];
subindraw=subindraw+(5+3*analysedchannels)*subcompcounts[ijsub];
}
if(checkwholecell){
setSlice(analysedchannels+2+ipcont);
} else {
setSlice(analysedchannels+1+ipcont);
}
Xtempi=split(Xtemp[ipcont],"\|");
Ytempi=split(Ytemp[ipcont],"\|");
for(ipconti=1; ipconti<lengthOf(Xtempi); ipconti++){
bdrectX=split(Xtempi[ipconti],"\:");
bdrectY=split(Ytempi[ipconti],"\:");
if((activegateweights[subcompcounts[0]+subnumbdraw+minOf(1,indicecell)*spotnumber[(ipcont-1)*subcompcounts[0]+maxOf(0,indicecell
-1)]+ipconti-1]*distancegateweights[subcompcounts[0]+subnumbdraw+minOf(1,indicecell)*spotnumber[(ipcont-1)*subcompcounts[0]+maxOf(0,indicecell-1)]+ipconti-1])!=0){
setColor(255);
fillOval(bdrectX[0],bdrectY[0],bdrectX[1],bdrectY[1]);
} else {
setColor(64);
fillOval(bdrectX[0],bdrectY[0],bdrectX[1],bdrectY[1]);
}
if(ipcont==jactcomp){
Xo=xmidraw[i];
Yo=ymidraw[i];
print(Xo+","+Yo+"; "+bdrectX[0]+","+bdrectY[0]);
if(((Xo>bdrectX[0])&&(Xo<bdrectX[0]+bdrectX[1]))&&((Yo>bdrectY[0])&&(Yo<bdrectY[0]+bdrectY[1]))){
drawOval(bdrectX[0]-2,bdrectY[0]-2,bdrectX[1]+4,bdrectY[1]+4);
//print("Got It!");
}
} 
}
}

for(ich=0; ich<analysedchannels; ich++){
if(depthseq!=96){
setSlice(ich+1);
resetMinAndMax();
run("Enhance Contrast", "saturated=0.5");
getMinAndMax(dmin,dmax);
if(displayedrange[2*ich]>dmin){displayedrange[2*ich]=dmin;}
if(displayedrange[2*ich+1]<dmax){displayedrange[2*ich+1]=dmax;}
} else {
displayedrange[2*ich]=0;
displayedrange[2*ich+1]=255;
}
}
if(cellgallcheck){

run("Scale... ", "x="+scalefactor+" y="+scalefactor+" centered");
run("Duplicate...", "title=Cell_"+d2s(i,0)+" duplicate");
concstringcell=concstringcell+" image"+d2s(i,0)+"=Cell_"+d2s(i,0);
kcell=kcell+1;

}

}
////////////////////end of looping for picture retrieval//////////////////


/////////////end of if condition on images for the region//////

if(k>2){
run("Concatenate...", "  title="+concstring);
} else {
selectImage(sequenceID);
rename("Gallery_"+rtvdimagename);
}
selectImage("Gallery_"+rtvdimagename);
if(checkwholecell){
Dsize=analysedchannels+2+subcomp;
} else {
Dsize=analysedchannels+1+subcomp;
}
run("Stack to Image5D", "3rd=ch 4th=z 3rd_dimension_size="+Dsize+" 4th_dimension_size="+(k-1)+" assign");
rename("Gallery5D_"+rtvdimagename);
run("Set... ", "zoom=50");
run("Set Channel Labels", label);
for(ich=0; ich<analysedchannels; ich++){
//selectImage("Gallery_"+rtvdimagename);
run("Set Position", "x-position=1 y-position=1 channel="+(ich+1)+" slice=1 frame=1 display=tiled");
run("Brightness/Contrast...");
//print("Ch0"+(ich+1)+"\n Min: "+displayedrange[2*ich]+"; Max: "+displayedrange[2*ich+1]);
setMinAndMax(displayedrange[2*ich], displayedrange[2*ich+1]);
}
if(checkwholecell){
run("Set Position", "x-position=1 y-position=1 channel="+(analysedchannels+2)+" slice=1 frame=1 display=tiled");
run("Rainbow RGB");
run("Enhance Contrast", "saturated=0.5");
}
setBatchMode("show");
if(isOpen("Gallery_"+rtvdimagename)){
selectImage("Gallery_"+rtvdimagename);
close();
}
if(cellgallcheck){
print(concstringcell);
if(kcell>1){
run("Concatenate...", "  title="+concstringcell);
} else {
selectImage("Cell_1");
rename("Cell_Gallery_"+rtvdimagename);
}

selectImage("Cell_Gallery_"+rtvdimagename);
run("Stack to Image5D", "3rd=ch 4th=z 3rd_dimension_size="+Dsize+" 4th_dimension_size="+nSlices/(analysedchannels+1+subcomp)+" assign");
rename("Cell_Gallery5D_"+rtvdimagename);
//setBatchMode("show");
//waitForUser("5D");
//run("To Selection");
run("Set... ", "zoom=50");
run("Set Channel Labels", label);
for(ich=0; ich<analysedchannels; ich++){
//selectImage("Gallery_"+rtvdimagename);
run("Set Position", "x-position=1 y-position=1 channel="+(ich+1)+" slice=1 frame=1 display=tiled");
run("Brightness/Contrast...");
print("Ch0"+(ich+1)+"\n Min: "+displayedrange[2*ich]+"; Max: "+displayedrange[2*ich+1]);
setMinAndMax(displayedrange[2*ich], displayedrange[2*ich+1]);
}
run("Set Position", "x-position=1 y-position=1 channel="+(analysedchannels+1)+" slice=1 frame=1 display=tiled");
run("Grays");
if(checkwholecell){
run("Set Position", "x-position=1 y-position=1 channel="+(analysedchannels+2)+" slice=1 frame=1 display=tiled");
run("Rainbow RGB");
run("Enhance Contrast", "saturated=0.5");
}
if(isOpen("Cell_Gallery_"+rtvdimagename)){
selectImage("Cell_Gallery_"+rtvdimagename);
close();
}
}
run("Set Position", "x-position=1 y-position=1 channel=1 slice=1 frame=1 display=tiled");
setBatchMode(false);
updateDisplay();
activeretrieval=0;
}
////////////////////new retrieval procedure/////
}
} 
}
selectImage(dotplotID);
run("Hide Overlay");
run("Scale to Fit");
}
//////////////////////////////////////////////////////////////////end of Picture Retrieval Mode///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1121)&&(x1<1191)&&(y1>28)&&(y1<45)){
resultsfilepath=File.openDialog("Select a File");
dataloading(resultsfilepath, firsttime);
}
////////////////////////////////////////////////////////////////////end of data loading//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1121)&&(x1<1191)&&(y1>48)&&(y1<65)){
jycheck=false;
close("Multicolor*");
close("Corr*");
for(ij=0; ij<subcomp+1; ij++){
if(jy==subcompindexstart[ij]){
jycheck=true;
}
}
if((jx!=-1)&&(!jycheck)){
selectImage(dotplotID);
updateregionlist();
transferID=0;
scalex=(maximum[jx]-minimum[jx])/(voltage[jx]*1);
scaley=(maximum[jy]-minimum[jy])/(voltage[jy]*1);
lista=split(regionlist, "\n");
regnames=newArray(lista.length);
regionchoice="All|";
if(lista.length>1){
for(j=0; j<lista.length; j++){
if(jactcomp<10){stringa="0"+d2s(jactcomp,0);}else{stringa=d2s(jactcomp,0);}
if(startsWith(lista[j],stringa)){
regionchoice=regionchoice+lista[j]+"|";
}
}
arrayregchoice=split(regionchoice,"\|");
if(arrayregchoice.length>1){
regcolor=newArray(arrayregchoice.length);
corrcolor=newArray(arrayregchoice.length);
newImage("Control Panel","RGB White", 240, 24*(arrayregchoice.length-1), 1);
for(i=1; i<arrayregchoice.length; i++){
regnamesarray=split(arrayregchoice[i], "\t");
setColor(0,0,0);
setFont("Arial", 18);
drawString(regnamesarray[0], 5, 24*i-2);
fillRect(180,24*(i-1)+2,20, 20);
//drawRect(0,24*(i-1),240,25);
//fillRect(210,24*(i-1)+2,20, 20);
}
controlID=getImageID();
if(!isOpen("CP")){
run("Color Picker...");
}

ncolorregions=0;
ncorrregions=0;
while(isOpen(controlID)){
if(isActive(controlID)){
getCursorLoc(x2, y2, z2, flags);
if((flags&leftButton!=0)&&(x2!=xr)&&(y2!=yr)){
xr=x2; yr=y2;
secondtime=false;
if((x2>180)&&(x2<200)){
iy=floor(yr/24);
waitForUser("Click on the CP to choose the region color (Press OK when done)");
regcolor[iy+1]=getValue("foreground.color");
setColor((regcolor[iy+1]>>16)&0xff,(regcolor[iy+1]>>8)&0xff,(regcolor[iy+1])&0xff);
fillRect(180,24*(iy)+2,20, 20);
}
if((x2>210)&&(x2<230)){
iy=floor(yr/24);
if(corrcolor[iy+1]==0){
setColor((regcolor[iy+1]>>16)&0xff,(regcolor[iy+1]>>8)&0xff,(regcolor[iy+1])&0xff);
fillRect(210,24*(iy)+2,20, 20);
corrcolor[iy+1]=regcolor[iy+1];
} else {
setColor(0,0,0);
fillRect(180,24*(iy)+2,20, 20);
corrcolor[iy+1]=0;
}
}
}
}
}
selectWindow("Dot Plot"+resultsfilepath);
setFont("Sans Serif", 12, "bold");

setBatchMode(true);
for(j=1; j<arrayregchoice.length; j++){
if(regcolor[j]!=0){
if(!isOpen("PSF")){
run("Gaussian PSF 3D", "width="+(2*meanfilterDP+1)+" height="+(2*meanfilterDP+1)+" number=1 dc-level=1 horizontal=1 vertical=1 depth=1");
}
arrayjx="|";
arrayjy="|";
ncolorregions=ncolorregions+1;
newImage("transfer", "8-bit Black", 1038, 1038,1);
transferID=getImageID();
parameters=split(arrayregchoice[j], "\t");
heading=parameters[0];
jxroi=parseInt(parameters[1]);
jyroi=parseInt(parameters[4]);
voltagexroi=parseFloat(parameters[2]);
voltageyroi=parseFloat(parameters[5]);
minimumxroi=parseFloat(parameters[3]);
minimumyroi=parseFloat(parameters[6]);
//offsetxroi=parseFloat(parameters[3]);
//offsetyroi=parseFloat(parameters[6]);
scalexroi=(parseFloat(parameters[7])-minimumxroi)/(voltagexroi*1);
scaleyroi=(parseFloat(parameters[8])-minimumyroi)/(voltageyroi*1);
for(jroi=0; jroi<roiManager("count"); jroi++){
if(heading==call("ij.plugin.frame.RoiManager.getName", jroi)){
roiManager("select", jroi);
setColor(255);
fill();
}
}
selectWindow("Dot Plot"+resultsfilepath);
//run("Duplicate...", "title=Multicolor_"+heading);
newImage("Multicolor_"+heading, "32-bit black",1040,1040,1);
subind=0;
subnumb=0;

for(ijsub=1; ijsub<jactcomp; ijsub++){
subind=subind+(5+3*analysedchannels)*subcompcounts[ijsub];
subnumb=subnumb+subcompcounts[ijsub];
}
for(i=0; i<subcompcounts[jactcomp]; i++){
if(activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i]*distancegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i]){
if(jactcomp==0){
indicexroi=jxroi+analysedparameters*i;
indiceyroi=jyroi+analysedparameters*i;
indicecell=i;
} else {
indicexroi=subcompcounts[0]*analysedparameters+subind+i*(5+3*analysedchannels)+(jxroi-subcompindexstart[jactcomp]);
indiceyroi=subcompcounts[0]*analysedparameters+subind+i*(5+3*analysedchannels)+(jyroi-subcompindexstart[jactcomp]);
indicecell=cellIndex[subnumb+i];
}
selectImage(transferID);
jyroicheck=false;
for(ij=0; ij<subcomp+1; ij++){
if(jyroi==subcompindexstart[ij]){
jyroicheck=true;
}
}
if(jyroicheck){
weight=getPixel(8+floor(minOf(offsetxroi+maxOf((datatable[indicexroi]-minimumxroi),0)/scalexroi, 1)*1023), 8+(0.5*1023))/255;
} else {
weight=getPixel(8+floor(minOf(offsetxroi+maxOf(0,(datatable[indicexroi]-minimumxroi))/scalexroi, 1)*1023), 8+floor((1-minOf(offsetyroi+maxOf((datatable[indiceyroi]-minimumyroi),0)/scaleyroi, 1))*1023))/255;
}
if(weight!=0){
selectWindow("Dot Plot"+resultsfilepath);
if(jactcomp==0){
indicex=jx+analysedparameters*i;
indicey=jy+analysedparameters*i;
indicecell=i;
} else {
indicex=subcompcounts[0]*analysedparameters+subind+i*(5+3*analysedchannels)+(jx-subcompindexstart[jactcomp]);
indicey=subcompcounts[0]*analysedparameters+subind+i*(5+3*analysedchannels)+(jy-subcompindexstart[jactcomp]);
//indicecell=cellIndex[subnumb+i];
indicecell=subnumb+i;
}
selectImage("PSF");
run("Copy");
selectImage("Multicolor_"+heading);
makeRectangle(8+floor(minOf(offset[jx]+maxOf((datatable[indicex]-minimum[jx]),0)/scalex, 1)*1023)-meanfilterDP, 8+floor((1-minOf(offset[jy]+maxOf((datatable[indicey]-minimum[jy]),0)/scaley, 1))*1023)-meanfilterDP,2*meanfilterDP+1,2*meanfilterDP+1);
setPasteMode("Add");
run("Paste");
if(corrcolor[j]!=0){
arrayjx=arrayjx+d2s(datatable[indicex], 8)+"|";
arrayjy=arrayjy+d2s(datatable[indicey], 8)+"|";
//arrayjx=arrayjx+d2s(minOf(offset[jx]+datatable[indicex]/scalex, 1)*1023, 0)+"|";
//arrayjy=arrayjy+d2s(minOf(offset[jy]+datatable[indicey]/scaley, 1)*1023, 0)+"|";
}
selectWindow("Dot Plot"+resultsfilepath);

}
}
}
selectImage(transferID);
close();
if(corrcolor[j]!=0){
ncorrregions=ncorrregions+1;
arrayx=split(arrayjx, "|");
arrayy=split(arrayjy, "|");
arrayxy=newArray(lengthOf(arrayx));
for(jstats=0; jstats<lengthOf(arrayx); jstats++){
arrayx[jstats]=parseFloat(arrayx[jstats]);
arrayy[jstats]=parseFloat(arrayy[jstats]);
arrayxy[jstats]=arrayx[jstats]*arrayy[jstats];
}
Array.getStatistics(arrayx, minx, maxx, meanx, stdDevx);
Array.getStatistics(arrayy, miny, maxy, meany, stdDevy);
Array.getStatistics(arrayxy, minxy, maxxy, meanxy, stdDevxy);
statscount=lengthOf(arrayx);
Pearson=(meanxy-meanx*meany)/(stdDevx*stdDevy);
if(statscount<8000){
Fit.doFit("y = a*x+b", arrayx, arrayy);
} else {
redarrayx=Array.trim(arrayx, 8000);
redarrayy=Array.trim(arrayy, 8000);
Fit.doFit("y = a*x+b", redarrayx, redarrayy);
}

selectImage("Multicolor_"+heading);
makeRectangle(0,0,1200,1200);
run("Duplicate...", "title=Correlation_"+heading);
xmeandraw=8+floor(minOf(offset[jx]+maxOf(0, (meanx-minimum[jx])/scalex), 1)*1023);
ymeandraw=8+floor((1-minOf(offset[jy]+maxOf(0, (meany-minimum[jy])/scaley), 1))*1023);
//xmeandraw=8+meanx;
//ymeandraw=8+1023-meany;
//adraw=8+floor((1-minOf(offset[jy]+(Fit.p(0)*(maxx)+Fit.p(1))/scaley, 1))*1023);
//bdraw=8+floor((1-minOf(offset[jy]+(Fit.p(0)*(minx)+Fit.p(1))/scaley, 1))*1023);
setLineWidth(3);
setColor(255,255,255);
drawLine(xmeandraw,8,xmeandraw,1039);
drawLine(8,ymeandraw, 1039, ymeandraw);
setColor(255,0,255);
//for(xaxis=0; xaxis<49; xaxis++){
//drawLine(8+floor(minOf(offset[jx]+(minx+xaxis*floor((maximum[jx]-minx)/50))/scalex, 1)*1023),8+floor((1-minOf(offset[jy]+(Fit.p(0)*(minx+(xaxis*floor((maximum[jx]-minx)/50)))+Fit.p(1))/scaley, 1))*1023),8+floor(minOf(offset[jx]+(minx+((xaxis+1)*floor((maximum[jx]-minx)/50)))/scalex, 1)*1023),8+floor((1-minOf(offset[jy]+(Fit.p(0)*(minx+((xaxis+1)*floor((maximum[jx]-minx)/50)))+Fit.p(1))/scaley, 1))*1023));
//}
xymax=(maximum[jy]-Fit.p(1))/Fit.p(0);
drawLine(8, 8+floor((1-(offset[jy]+maxOf(((Fit.p(0)*minimum[jx]+Fit.p(1))-minimum[jy])/scaley,0)))*1023), 8+floor(offset[jx]+maxOf(0, (xymax-minimum[jx])/scalex)*1023), 8);
print(((Fit.p(0)*maximum[jx]/2+Fit.p(1))-minimum[jy]));
setLineWidth(1);
setColor(255,255,255);
fillRect(1040,0,160,1200);
setColor(0,0,0);
drawString("Pearson:",1048,24);
drawString(d2s(Pearson,5),1048,44);
drawString("Linear Regression:", 1048,64);
drawString("Rsquared:", 1048, 84);
drawString(d2s(Fit.rSquared,5),1048,104);
drawString("Slope:", 1048,124);
drawString(d2s(Fit.p(0),5),1048,144);
drawString("Intercept: ", 1048,164);
drawString(d2s(Fit.p(1),5),1048,184);
drawString("Mean x:", 1048, 204);
drawString(meanx, 1048, 224);
drawString("Mean y:", 1048, 244);
drawString(meany, 1048, 264);
drawString("Mean xy:", 1048, 284);
drawString(meanxy, 1048, 304);
drawString("Dev St x:", 1048, 324);
drawString(stdDevx, 1048, 344);
drawString("Dev St y:", 1048, 364);
drawString(stdDevy, 1048, 384);
drawString("Dev St xy:", 1048, 404);
drawString(stdDevxy, 1048, 424);

}
selectImage("Multicolor_"+heading);
selectWindow("Dot Plot"+resultsfilepath);
}
}
if(ncolorregions>0){
selectWindow("Dot Plot"+resultsfilepath);
run("Duplicate...", "title=Multicolor");
makeRectangle(0,0,1040,1040);
run("Crop");
run("32-bit");
run("Invert");
run("Duplicate...", "title=OverlayMulticolor");
setColor(0,0,0);
fillRect(8,8,1024,1024);
selectImage("PlottingPSF");
run("Copy");
setPasteMode("Copy");
selectImage("Multicolor");
setColor(0,0,0);
fillRect(0,0,1040,1040);
makeRectangle(8,8,1024,1024);
run("Paste");
run("Images to Stack", "name=Multicolor title=Multicolor use");
run("Stack to Image5D", "3rd=ch 4th=z 3rd_dimension_size="+(ncolorregions+2)+" 4th_dimension_size=1 assign");
rename("Multicolor DP");
//run("Add Image...", "image=[OverlayMcolor] x=0 y=0 opacity=100 zero");
if(isOpen("OverlayMulticolor")){
selectImage("OverlayMulticolor");
close();
}
if(isOpen("Multicolor")){
selectWindow("Multicolor");
close();
}
}
if(ncorrregions>0){
run("Images to Stack", "name=Multicolor_Correlation title=Correlation use");
}
if(isOpen("PSF")){
selectImage("PSF");
run("Close");
}
setBatchMode("exit and display");
updateDisplay();
selectImage(dotplotID);
}
}
}
setPasteMode("Copy");
}
////////////////////////////////////////////////////////////////////end of Multicolor gating///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if(((x1>1121)&&(x1<1191)&&(y1>88)&&(y1<105))||sliceCheck){
sliceCheck=false;
if((jx!=-1)&&(jy!=-1)){
DPx=split(jxdp,"\|");
DPy=split(jydp,"\|");
selectImage(dotplotID);
choiceDP=newArray(lengthOf(DPx));
print("Length of DPx: "+lengthOf(DPx)+"; "+nSlices);
for(j=0; j<nSlices; j++){
choiceDP[j]=substring(DPx[j],0,2)+". X: "+analysedparameterslist[parseInt(substring(DPx[j],3,6))]+"  Y: "+analysedparameterslist[parseInt(substring(DPy[j],3,6))];
}
Dialog.create("Dot Plot Selection");
Dialog.addMessage("Enter the corresponding slice number ");
Dialog.addChoice("Dot Plot: ", choiceDP, choiceDP[sliceDPL-1]);
Dialog.show();
sliceDPL=parseInt(substring(Dialog.getChoice(),0,2))+1;
selectImage(dotplotID);
setSlice(sliceDPL);
print("sliceDPL: "+sliceDPL);
jactcomp=parseInt(substring(jactcompdp, (sliceDPL-1)*6+4,sliceDPL*6));
print("Active Compartment: "+subcomparray[jactcomp]);
if(jx!=-1){
jx=parseInt(substring(jxdp, (sliceDPL-1)*7+4,sliceDPL*7));
if(jy!=-1){
jy=parseInt(substring(jydp, (sliceDPL-1)*7+4,sliceDPL*7));
dotplotscheme();
setColor(255,255,255);
fillRect(70, 1058, 300, 12);
fillRect(175, 1078, 30, 12);
fillRect(360, 1078, 30, 12);
setColor(0,0,0);
drawString(analysedparameterslist[jx]+";", 70, 1070);
drawString(d2s(voltage[jx],2), 175, 1090);
drawString(offset[jx], 360, 1090);
setColor(255,255,255);
fillRect(71, 1077, 98, 12);
setColor(0,0,255);
fillRect(71, 1077, voltage[jx]/0.1, 12);
setColor(255,255,255);
fillRect(251, 1077, 98, 12);
setColor(0,0,255);
fillRect(251, 1077, 50+offset[jx]/10, 12);
setColor(0,0,0);
setColor(255,255,255);
fillRect(70, 1098, 300, 12);
fillRect(175, 1118, 30, 12);
fillRect(360, 1118, 30, 12);
setColor(0,0,0);
drawString(analysedparameterslist[jy]+";", 70, 1110);
drawString(d2s(voltage[jy],2), 175, 1130);
drawString(offset[jy], 360, 1130);
setColor(255,255,255);
fillRect(71, 1117, 98, 12);
setColor(0,0,255);
fillRect(71, 1117, voltage[jy]/0.1, 12);
setColor(255,255,255);
fillRect(251, 1117, 98, 12);
setColor(0,0,255);
fillRect(251, 1117, 50+offset[jy]/10, 12);
setColor(0,0,0);
setBatchMode(false);
updateDisplay();

//activegateindex=parseInt(substring(activegateindexdp, (sliceDPL-1)*6+4,sliceDPL*6));
DPgate=split(activegateindexdp,"\|");
activegateindex=parseInt(substring(DPgate[sliceDPL-1],3,4));
arraygateDP=split(DPgate[sliceDPL-1],"\;");
for(ic=0; ic<subcomp+1; ic++){
activegate[2*ic]=substring(arraygateDP[ic+1],0, indexOf(arraygateDP[ic+1],","));
activegate[2*ic+1]=parseInt(substring(arraygateDP[ic+1], indexOf(arraygateDP[ic+1],",")+1,indexOf(arraygateDP[ic+1],",")+2));
}
}
}
selectImage(dotplotID);
setSlice(sliceDPL);
gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);

}
}
////////////////////////////////////////////////////////////////////end of DP slice////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1121)&&(x1<1191)&&(y1>108)&&(y1<125)){
updateDP();
}
////////////////////////////////////////////////////////////////////end of DP update////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1121)&&(x1<1191)&&(y1>68)&&(y1<85)){
RLfilepath=File.openDialog("Select a Region List File (Name must contain 'RL'): must be in .csv file format");
if(indexOf(RLfilepath,"RL")>=0){
//setBatchMode(true);
regionlistfile=File.openAsString(RLfilepath);
//roisetfile=File.getParent(RLfilepath)+"/RoiSet.zip";
while(roiManager("count")!=0){
roiManager("select",roiManager("count")-1);
roiManager("Delete");
}
lista=split(regionlistfile, "\n");
regionlist="Begin";
gatelist="None";
//roiManager("reset");
for(jlista=1; jlista<lengthOf(lista); jlista++){
roiparameters=split(lista[jlista],"\,");
regionlist=regionlist+"\n"+roiparameters[0];
gatelist=gatelist+"\n"+roiparameters[0];
regionindex[parseInt(substring(roiparameters[0],0,3))]=parseInt(substring(roiparameters[0],4,6));
for(jxtroi=0; jxtroi<analysedparameterslist.length; jxtroi++){
if(roiparameters[1]==analysedparameterslist[jxtroi]){
regionlist=regionlist+"\t"+d2s(jxtroi,0);
print("jxtroi of "+roiparameters[1]+"= "+jxtroi);
}
}
regionlist=regionlist+"\t"+roiparameters[2]+"\t"+roiparameters[3];
for(jytroi=0; jytroi<analysedparameterslist.length; jytroi++){
if(roiparameters[5]==analysedparameterslist[jytroi]){
regionlist=regionlist+"\t"+d2s(jytroi,0);
}
}
regionlist=regionlist+"\t"+roiparameters[6]+"\t"+roiparameters[7];
regionlist=regionlist+"\t"+roiparameters[4]+"\t"+roiparameters[8];
regionlist=regionlist+"\t"+roiparameters[lengthOf(roiparameters)-2]+"\t"+roiparameters[lengthOf(roiparameters)-1];
XRLtemp=split(roiparameters[lengthOf(roiparameters)-2],"\:");
YRLtemp=split(roiparameters[lengthOf(roiparameters)-1],"\:");
for(k=0; k<lengthOf(XRLtemp); k++){
XRLtemp[k]=parseInt(XRLtemp[k]);
YRLtemp[k]=parseInt(YRLtemp[k]);
}
makeSelection("polygon", XRLtemp, YRLtemp);
roiManager("Add");
roiManager("select", roiManager("count")-1);
roiManager("Rename", roiparameters[0]);
}

} else {
showMessage("Please select a File with 'RL' in the name");
}
lista=split(regionlist, "\n");
Array.show(lista);
if(lista.length>1){
title1 = "Region List";
  title2 = "["+title1+"]";
  f = title2;
  if (isOpen(title1))
     print(f, "\\Clear");
  else
    {run("Table...", "name="+title2+" width=250 height=600");}
  print(f, "\\Headings:Region\tX\tVoltageX\tMinimumX\tMaximumX\tY\tVoltageY\tMinimumY\tMaximumY\tXcoord.\tYcoord.");
for(j=1; j<lista.length; j++){
parameters=split(lista[j], "\t");
heading=parameters[0];
jxroi=parseInt(parameters[1]);
jyroi=parseInt(parameters[4]);
voltagexroi=parseFloat(parameters[2]);
voltageyroi=parseFloat(parameters[5]);
//offsetxroi=parseFloat(parameters[3]);
minimumxroi=parseFloat(parameters[3]);
//offsetyroi=parseFloat(parameters[6]);
minimumyroi=parseFloat(parameters[6]);
scalexroi=(parseFloat(parameters[7])-minimumxroi)/(voltagexroi*1);
scaleyroi=(parseFloat(parameters[8])-minimumyroi)/(voltageyroi*1);
 print(f, heading+"\t"+analysedparameterslist[jxroi]+"\t" +voltagexroi+"\t"+minimumxroi+"\t"+parameters[7]+"\t"+analysedparameterslist[jyroi]+"\t" +voltageyroi+"\t"+minimumyroi+"\t"+parameters[8]+"\t"+parameters[9]+"\t"+parameters[10]);
}
}
//regionindex=parseInt(substring(roiparameters[0],1,3));
}

/////////////////////////////////////////////////////////////////////end of RL Load/////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>70)&&(x1<170)&&(y1>1076)&&(y1<1090)){
if(jx!=-1){
voltage[jx]=(x1-70)*0.1;
setvoltage(jx, 0, voltage[jx]);
}
if(jy!=-1){

gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);

}
}
////////////////////////////////////////////////////////////////////end of x voltage setting//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>70)&&(x1<170)&&(y1>1116)&&(y1<1130)){
if(jy!=-1){
voltage[jy]=(x1-70)*0.1;
setvoltage(jy, 1, voltage[jy]);
}
if(jx!=-1){

gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);

}
}
////////////////////////////////////////////////////////////////////end of y voltage setting//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>250)&&(x1<350)&&(y1>1076)&&(y1<1090)){
if(jx!=-1){
offset[jx]=(-50+(x1-250))*0.05;
setoffset(jx, 0,offset[jx]);
}
if(jy!=-1){

gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);

}
}
////////////////////////////////////////////////////////////////////end of x offset setting//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>250)&&(x1<350)&&(y1>1116)&&(y1<1130)){
if(jy!=-1){
offset[jy]=(-50+(x1-250))*0.05;
setoffset(jy, 1,offset[jy]);
}
if(jx!=-1){

gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);

}
}
////////////////////////////////////////////////////////////////////end of yoffset setting//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1044)&&(x1<1114)&&(y1>8)&&(y1<25)){
if((jx!=-1)&&(jy!=-1)){
selectWindow("Dot Plot"+resultsfilepath);
sliceDP=getSliceNumber();
jactcomp=parseInt(substring(jactcompdp,(sliceDP-1)*6+4,sliceDP*6));
getSelectionBounds(xh, yh, widthroi, heigthroi);
if((xh!=0)&&(yh!=0)&&(widthroi!=getWidth())&&(heigthroi!=getHeight)){
if(jy==0){
makeRectangle(xh, 8, widthroi, 1024);
}
getSelectionCoordinates(xroi, yroi);
Xreg="";
Yreg="";
for(i=0; i<lengthOf(xroi); i++){
Xreg=Xreg+":"+d2s(xroi[i],0);
Yreg=Yreg+":"+d2s(yroi[i],0);
}
roiManager("Add");
regionindex[jactcomp]=regionindex[jactcomp]+1;
if(jactcomp<10){
regionname="0"+jactcomp+"_";
} else {
regionname=jactcomp+"_";
}
if(regionindex[jactcomp]<10){
regionname=regionname+"r0"+regionindex[jactcomp];
} else {
regionname=regionname+"r"+regionindex[jactcomp];
}
regionlist=regionlist+"\n"+regionname+"\t"+jx+"\t"+voltage[jx]+"\t"+minimum[jx]+"\t"+jy+"\t"+voltage[jy]+"\t"+minimum[jy]+"\t"+maximum[jx]+"\t"+maximum[jy]+"\t"+Xreg+"\t"+Yreg;
roiManager("select", roiManager("count")-1);
roiManager("Rename", regionname);
gatelist=gatelist+"\n"+regionname;
}
Color.setForeground("Red");
run("Draw", "slice");
updateregionlist();

}
}
//////////////////////////////////////////////////////////////////////////////end of Set Region////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1044)&&(x1<1114)&&(y1>28)&&(y1<45)){
updateregionlist();
Dialog.create("New Gate");
Dialog.addMessage("Insert the logical gate expression using the AND, OR operators \nwithout inserting spaces in the formula. \nUse !( ) for NOT, always enclosing the argument between parenthesis");
Dialog.addChoice("Choose the relative compartment: ", subcomparray);
Dialog.addString("Logic expression: ", "!(r01)AND(r02ORr03)");
Dialog.show();
setactivecomp=Dialog.getChoice();
for(ic=0; ic<subcomp+1; ic++){
if(setactivecomp==subcomparray[ic]){
setjactcomp=ic;
}
}
if(setjactcomp<10){
compname="0"+setjactcomp+"_";
} else {
compname=setjactcomp+"_";
}
gatestring=replace(Dialog.getString(), "r",compname+"r");
gatelist=gatelist+"\n"+gatestring;
print(gatelist);
}
//////////////////////////////////////////////////////////////////////////////end of Set Gate////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1044)&&(x1<1114)&&(y1>48)&&(y1<65)){
if((jx!=-1)&&(jy!=-1)){
if(recordcheck){
autocheck=autocheck+1;
autostatscheck=autostatscheck+1;
  if (!isOpen("Recording")){
     run("Text Window...", "name=[Recording] width=72 height=72 menu");
     }
print("[Recording]","Show Stats.\n");

if(x1array[0]<0){
x1array[0]=x1;
y1array[0]=y1;
} else {
x1array=Array.concat(x1array,x1);
y1array=Array.concat(y1array,y1);
}
}
updateregionlist();
transferID=0;
scalex=(maximum[jx]-minimum[jx])/(voltage[jx]*1);
scaley=(maximum[jy]-minimum[jy])/(voltage[jy]*1);
if(isOpen("Results")){
selectWindow("Results");
run("Close");
}
lista=split(regionlist, "\n");
regnames=newArray(lista.length);    
nregImages=0;
chkimgch=newArray(analysedchannels);
Array.fill(chkimgch,1);
regionchoice="All|";
if(lista.length>1){
for(j=0; j<lista.length; j++){
if(jactcomp<10){stringa="0"+d2s(jactcomp,0);}else{stringa=d2s(jactcomp,0);}
if(startsWith(lista[j],stringa)){
regionchoice=regionchoice+lista[j]+"|";
}
}
}                                                                           
arrayregchoice=split(regionchoice,"\|");  
regImages=newArray(arrayregchoice.length);
if(recordcheck){
temprecregImages=newArray(arrayregchoice.length);
temprecchkimgch=newArray(analysedchannels);
if(autostatscheck==1){
recregImages=newArray(arrayregchoice.length);
recchkimgch=newArray(analysedchannels);
} else {
recregImages=Array.concat(recregImages,temprecregImages);
recchkimgch=Array.concat(recchkimgch,temprecchkimgch);
}
}
if(arrayregchoice.length>1){
stack5Dname="Gallery--"+File.getName(resultsfilepath);
for(j=1; j<arrayregchoice.length;j++){
regnamesarray=split(arrayregchoice[j], "\t");
regnames[j]=regnamesarray[0];
}
if(execheck==0){
Dialog.create("Images retrieval from Regions");
Dialog.addMessage("Select the regions for picture retrieval:");
dysplayedIm=newArray("Not calculated","0", "5", "10", "25", "50", "100", "250", "500", "1000000");
for(j=1; j<arrayregchoice.length;j++){
Dialog.addChoice(regnames[j], dysplayedIm, dysplayedIm[1]);
}
scaling=newArray(10,20,30,40,50,60,70,80,90,100);
Dialog.addCheckbox("Single Cell Gallery", false);
Dialog.addNumber("View Factor ",2);
Dialog.addCheckbox("Limit Stats to DP Parameters", false);
Dialog.addCheckbox("Save Cell Masks (Binaries will be saved in a folder with the region name)", false);
Dialog.addCheckbox("Retrieve stage positions (.nd2 files only)",false);
Dialog.addNumber("Imaging Cutoff Distance", dCut);
Dialog.show();
for(j=1; j<arrayregchoice.length; j++){
regImages[j]=parseInt(Dialog.getChoice());
if(recordcheck){
recregImages[j+(autostatscheck-1)*arrayregchoice.length]=regImages[j];
  if (!isOpen("Recording")){
     run("Text Window...", "name=[Recording] width=72 height=72 menu");
     }
print("[Recording]",regnames[j]+": "+recregImages[j+(autostatscheck-1)*arrayregchoice.length]+" images.\n");
}
}
cellgallcheck=Dialog.getCheckbox();
scalefactor=Dialog.getNumber();
checkstatsDP=Dialog.getCheckbox();
cellmaskcheck=Dialog.getCheckbox();
dCut=Dialog.getNumber();
//dCut=dCut*dCut;
if(nd2check>0){                   
stageposcheck=Dialog.getCheckbox();
} else {stageposcheck=0;}
if(recordcheck){
if(autostatscheck==1){
reccellgallcheck[0]=cellgallcheck;
recscalefactor[0]=scalefactor;
reccheckstatsDP[0]=checkstatsDP;
reccellmaskcheck[0]=cellmaskcheck;
recdCut[0]=dCut;
recstageposcheck[0]=stageposcheck;
} else {
reccellgallcheck=Array.concat(reccellgallcheck,cellgallcheck);
recscalefactor=Array.concat(recscalefactor,scalefactor);
reccheckstatsDP=Array.concat(reccheckstatsDP,checkstatsDP);
reccellmaskcheck=Array.concat(reccellmaskcheck,cellmaskcheck);
recdCut=Array.concat(recdCut,dCut);
recstageposcheck=Array.concat(recstageposcheck,stageposcheck);
}
}
} else {
  if (!isOpen("Executing")){
     run("Text Window...", "name=[Executing] width=72 height=72 menu");
     }
print("[Executing]","Images per Region.\n");
for(j=1; j<arrayregchoice.length; j++){
regImages[j]=recregImages[j+(recautostatscheck-autostatscheck)*arrayregchoice.length];
  if (!isOpen("Executing")){
     run("Text Window...", "name=[Executing] width=72 height=72 menu");
     }
print("[Executing]","Step Stats: "+(recautostatscheck-autostatscheck)+"\n"+regnames[j]+": "+recregImages[j+(recautostatscheck-autostatscheck)*arrayregchoice.length]+" images.\n");
}
cellgallcheck=reccellgallcheck[recautostatscheck-autostatscheck];
scalefactor=recscalefactor[recautostatscheck-autostatscheck];
checkstatsDP=reccheckstatsDP[recautostatscheck-autostatscheck];
cellmaskcheck=reccellmaskcheck[recautostatscheck-autostatscheck];
dCut=recdCut[recautostatscheck-autostatscheck];
stageposcheck=recstageposcheck[recautostatscheck-autostatscheck];
}
for(j=1; j<arrayregchoice.length; j++){
if(isNaN(regImages[j])){regImages[j]=-1;}
if(regImages[j]>0){
nregImages=nregImages+1;
stack5Dname=stack5Dname+"_"+regnames[j];
}
}
if(nregImages>0){
if(execheck==0){
Dialog.create("Select the channels to be displayed: ");
for(it=0; it<analysedchannels; it++){
if((multichannelcheck<1)&&(nd2check<0)){
Dialog.addCheckbox(substring(imageslist[it], lastIndexOf(imageslist[it], "--")+2, lastIndexOf(imageslist[it], ".tif")), false);
} else {
Dialog.addCheckbox(canali[it], false);
}
}
Dialog.show();
for(it=0; it<analysedchannels; it++){
chkimgch[it]=Dialog.getCheckbox();
if(recordcheck){
recchkimgch[it+(autostatscheck-1)*analysedchannels]=chkimgch[it];
}
}
} else {
for(it=0; it<analysedchannels; it++){
chkimgch[it]=recchkimgch[it+(recautostatscheck-autostatscheck)*analysedchannels];
}
}
displayedchannels=0;
imgdestdir=true;
for(it=0; it<analysedchannels; it++){
if(chkimgch[it]){
displayedchannels=displayedchannels+chkimgch[it];
if(displayedchannels==1){
if(multichannelcheck<1){
if(nd2check<0){
label="1="+substring(imageslist[it], lastIndexOf(imageslist[it], "-")+1, indexOf(imageslist[it], ".tif"));
} else {
label="1="+substring(imageslist[it], lastIndexOf(imageslist[it], "_")+1, indexOf(imageslist[it], ".nd2"));
}
} else {
label="1="+canali[it];
}
} else {
if(multichannelcheck<1){
if(nd2check<0){
label=label+" "+d2s(displayedchannels,0)+"\="+substring(imageslist[it], lastIndexOf(imageslist[it], "-")+1, indexOf(imageslist[it], ".tif"));
} else {
label=label+" "+d2s(displayedchannels,0)+"\="+substring(imageslist[it], lastIndexOf(imageslist[it], "_")+1, indexOf(imageslist[it], ".nd2"));
}
} else {
label=label+" "+d2s(displayedchannels,0)+"\="+canali[it];
}
}
}                                                                       
}
chl=displayedchannels;
label=label+" "+d2s(chl+1,0)+"\=CellIndex";
chl=chl+1;
for(ir=0; ir<subcomp+1; ir++){
label=label+" "+d2s(chl+1,0)+"\="+substring(subcomparray[ir],indexOf(subcomparray[ir],"\:")+2);
chl=chl+1;
if((ir==0)&&(checkwholecell)){
label=label+" "+d2s(chl+1,0)+"\=WholeCell";
chl=chl+1;
}
}

//////array to store cell indexes from all the regions where pictures are required//////
regImgarray=newArray(arrayregchoice.length);
}
idyspreg=0;
displayedrange=newArray(2*analysedchannels);
for(ich=0; ich<analysedchannels; ich++){
displayedrange[2*ich]=65536;
displayedrange[2*ich+1]=0;
}
} else {
checkstatsDP=getBoolean("Limit stats to the Dot Plot parameters");
}
////////////Start of Statitics Execution///////////
if(!recordcheck){
if(execheck>0){
if(autostatscheck>0){
autostatscheck=autostatscheck-1;
}
}
///////array to store the number of cells in the region////////////////
nregarray=newArray(arrayregchoice.length);
updateStats();
setBatchMode(true);
for(j=0; j<arrayregchoice.length; j++){
if(regImages[j]>=0){
regcellIndexarray=newArray(1);
regcellIndexarray[0]=-1;
xmidraw=newArray(1);
ymidraw=newArray(1);
checknIm=0;
ngate=0;
//Array.fill(nregarray,0);
nj=0;
nregion=0;
weight=0;
meanstats=newArray(subcompindexend[jactcomp]-subcompindexstart[jactcomp]);
Array.fill(meanstats,0);
if(j>0){
newImage("transfer", "8-bit Black", 1038, 1038,1);
idyspreg=idyspreg+minOf(1,regImages[j]);
transferID=getImageID();
parameters=split(arrayregchoice[j], "\t");
heading=parameters[0];
jxroi=parseInt(parameters[1]);
jyroi=parseInt(parameters[4]);
voltagexroi=parseFloat(parameters[2]);
voltageyroi=parseFloat(parameters[5]);
//offsetxroi=parseFloat(parameters[3]);
minimumxroi=parseFloat(parameters[3]);
//offsetyroi=parseFloat(parameters[6]);
minimumyroi=parseFloat(parameters[6]);
scalexroi=(parseFloat(parameters[7])-minimumxroi)/(voltagexroi*1);
scaleyroi=(parseFloat(parameters[8])-minimumyroi)/(voltageyroi*1);
 print(f, heading+"\t"+analysedparameterslist[jxroi]+"\t" +voltagexroi+"\t"+minimumxroi+"\t"+parameters[7]+"\t"+analysedparameterslist[jyroi]+"\t" +voltageyroi+"\t"+minimumyroi+"\t"+parameters[8]+"\t"+parameters[9]+"\t"+parameters[10]);
for(jroi=0; jroi<roiManager("count"); jroi++){
if(heading==call("ij.plugin.frame.RoiManager.getName", jroi)){
roiManager("select", jroi);
setColor(255);
fill();
}
}
} else {
  title1 = "Region List for Stats";
  title2 = "["+title1+"]";
  f = title2;
  if (isOpen(title1))
     print(f, "\\Clear");
  else
    {run("Table...", "name="+title2+" width=250 height=600");}
  print(f, "\\Headings:Region\tX\tVoltageX\tMinimumX\tMaximumX\tY\tVoltageY\tMinimumY\tMaximumY\tXcoord.\tYcoord.");
setResult("Label", 0, "Events");
setResult("Label", 1, "% of Events (Total)");
setResult("Label", 2, "% of Events (Gated)");
rowResult=2;
for(jstats=subcompindexstart[jactcomp]+1; jstats<subcompindexend[jactcomp]; jstats++){
if(checkstatsDP){
if((jstats==jx)||(jstats==jy)){
checkstatslimit=1;
//waitForUser(jstats+";"+jx+","+jy+"\n"+checkstatslimit);
} else {
checkstatslimit=0;
}
} else {
if(checkparam[jstats]){
checkstatslimit=1;
} else {
checkstatslimit=0;
}
}
if(checkstatslimit){
rowResult=rowResult+1;
setResult("Label", rowResult, "Mean ["+analysedparameterslist[jstats]+"] "+checkparam[jstats]);
}
}
heading="All";
}
fileIDcheck=-1;
subind=0;
subnumb=0;
////Array.show(fileIndex);
for(ijsub=1; ijsub<jactcomp; ijsub++){
subind=subind+(5+3*analysedchannels)*subcompcounts[ijsub];
subnumb=subnumb+subcompcounts[ijsub];
}
it=0;
to=getTime();
for(i=0; i<subcompcounts[jactcomp]; i++){
if(i>(it/100)*subcompcounts[jactcomp]){
print(it+"% of "+subcompcounts[jactcomp]+" events in subcompartment "+jactcomp);
it=it+10;
}
ngate=ngate+activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i]*distancegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i];
if(j>0){
if(jactcomp==0){
indicex=jxroi+analysedparameters*i;
indicey=jyroi+analysedparameters*i;
indicecell=i;
} else {
indicex=subcompcounts[0]*analysedparameters+subind+i*(5+3*analysedchannels)+(jxroi-subcompindexstart[jactcomp]);
indicey=subcompcounts[0]*analysedparameters+subind+i*(5+3*analysedchannels)+(jyroi-subcompindexstart[jactcomp]);
indicecell=cellIndex[subnumb+i];
}
selectImage(transferID);
jyroicheck=false;
for(ij=0; ij<subcomp+1; ij++){
if(jyroi==subcompindexstart[ij]){
jyroicheck=true;
}
}
if(jyroicheck){
weight=getPixel(8+floor(minOf(offsetxroi+maxOf((datatable[indicex]-minimumxroi),0)/scalexroi, 1)*1023), 8+(0.5*1023))/255;
} else {
weight=getPixel(8+floor(minOf(maxOf((datatable[indicex]-minimumxroi),0)/scalexroi, 1)*1023), 8+floor((1-minOf(maxOf((datatable[indicey]-minimumyroi),0)/scaleyroi, 1))*1023))/255;
//weight=getPixel(8+floor(minOf(offsetxroi+maxOf((datatable[indicex]-minimumxroi),0)/scalexroi, 1)*1023), 8+floor((1-minOf(offsetyroi+maxOf((datatable[indicey]-minimumjyroi),0)/scaleyroi, 1))*1023))/255;
}
} else {
weight=1;
}
//nregarray[j]=nregarray[j]+weight;

statscomp=0;
if(statscomp+1<=subcomp){
checkstatscomp=(activegate[2*statscomp+2]!="None");
} else {
checkstatscomp=false;
}
for(jstats=1; jstats<subcompindexend[jactcomp]-subcompindexstart[jactcomp]; jstats++){
if(checkstatsDP){
if((subcompindexstart[jactcomp]+jstats==jx)||(subcompindexstart[jactcomp]+jstats==jy)){
checkstatslimit=1;
} else {
checkstatslimit=0;
}
} else {
if(checkparam[subcompindexstart[jactcomp]+jstats]){
checkstatslimit=1;
} else {
checkstatslimit=0;
}
}
if(checkstatslimit){
if(jactcomp==0){
indicestats=jstats+analysedparameters*i;
if(subcompindexstart[jactcomp]+jstats==5+3*analysedchannels+statscomp*(4+3*analysedchannels)){
statscomp=statscomp+1;
if(statscomp+1<=subcomp){
checkstatscomp=(activegate[2*statscomp+2]!="None");
} else {
checkstatscomp=false;
}
//print("Increase statscomp>"+statscomp);
}
} else {
indicestats=subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))*analysedparameters+subind+i*(5+3*analysedchannels)+jstats;
}
meanstats[jstats]=meanstats[jstats]+datatable[indicestats]*weight*activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i]*distancegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i];
//print("jstats="+jstats+" indicestats="+indicestats+" datatable="+datatable[indicestats]+" weight="+weight+" activegateweight= "+activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i]+" distancegateweight= "+distancegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i]);
}
}
//print("End of recalc");
nregarray[j]=nregarray[j]+weight*activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i]*distancegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i];
if((weight*activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i]*distancegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i]!=0)&&(j>0)){
//fileID=parseInt(fileIndex[indicecell]);

if(regImages[j]>0){
if(regcellIndexarray[0]<0){
regcellIndexarray[0]=indicecell;
xmidraw[0]=datatable[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))*analysedparameters+subind+i*(5+3*analysedchannels)+1];
ymidraw[0]=datatable[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))*analysedparameters+subind+i*(5+3*analysedchannels)+2];

} else {
regcellIndexarray=Array.concat(regcellIndexarray,indicecell);
xmidraw=Array.concat(xmidraw,datatable[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))*analysedparameters+subind+i*(5+3*analysedchannels)+1]);
ymidraw=Array.concat(ymidraw,datatable[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))*analysedparameters+subind+i*(5+3*analysedchannels)+2]);
}
}
////////////////////////end if condition on nImcheck////////////////////////////

}
///////////////////////// end  if condition on weight*activegate///////////////////////////////////
}   
///////end of i cycle
print("End of i-event cycle for region "+heading+" "+d2s((getTime()-to)/1000,3));
setResult(heading, 0, nregarray[j]);
setResult(heading, 1, 100*nregarray[j]/subcompcounts[jactcomp]);
setResult(heading, 2, 100*nregarray[j]/ngate);
if(activegateindex>0){setResult(heading, 2, 100*nregarray[j]/ngate);}
rowResult=2;
for(jstats=1; jstats<subcompindexend[jactcomp]-subcompindexstart[jactcomp]; jstats++){
if(checkstatsDP){
if((subcompindexstart[jactcomp]+jstats==jx)||(subcompindexstart[jactcomp]+jstats==jy)){
checkstatslimit=1;
} else {
checkstatslimit=0;
}
} else {
if(checkparam[subcompindexstart[jactcomp]+jstats]){
checkstatslimit=1;
} else {
checkstatslimit=0;
}
}
if(checkstatslimit){
rowResult=rowResult+1;
setResult(heading, rowResult, meanstats[jstats]/nregarray[j]);
}
}
if(isOpen(transferID)){
selectImage(transferID);
close();
}
////Array.show(meanstats);
}
///////////////// end of statistics calculation for a region (if regIm[j]>=0)////////////////////////
if(regImages[j]>nregarray[j]){
regImages[j]=nregarray[j];
}
if(regImages[j]>0){
for(ij=1; ij<j; ij++){
nj=nj+nregarray[j];
}
if(stageposcheck){
  title1 = "Position Table "+heading;
  title2 = "["+title1+"]";
  f1 = title2;
  if (isOpen(title1))
     print(f, "\\Clear");
  else
     run("Text Window...", "name="+title2+" width=72 height=8 menu");
//run("Table...", "name="+title2+" width=250 height=600");
//print(f1, "\\Headings: N.\tXcoord.\tYcoord.\tZcoord.");
print(f1,"<variant version=\"1.0\">\n<no_name runtype=\"CLxListVariant\">\n<bIncludeZ runtype=\"bool\" value=\"true\"/>\n<bPFSEnabled runtype=\"bool\" value=\"false\"/>");
ndCut=0;
stgXPos=newArray(1);
stgYPos=newArray(1);
stgZPos=newArray(1);
xmlstgXPos=newArray(1);
xmlstgYPos=newArray(1);
xml=0;
}
concstring="[Gallery_"+regnames[j]+"]";
concstringimgnames=regnames[j]+"\n";
concstringcell="[Cell_Gallery_"+regnames[j]+"]";
k=1;
kcell=0;
endcell=regImages[j];
for(i=0; i<endcell; i++){
fileID=parseInt(fileIndex[regcellIndexarray[i]]);
////////////qui/////////////
if(!isOpen("FileID_"+fileID)){
if(!confdata){
if(multichannelcheck<1){
for(it=0; it<analysedchannels; it++){
if(chkimgch[it]>0){
target=imagesdir+imageslist[fileID+it];
if(nd2check<0){
open(target);
} else {
run("Bio-Formats", "open=["+target+"] color_mode=Default open_files rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
}
}
//run("Subtract Background...", "rolling=100");
}
if(nd2check<0){
run("Images to Stack", "method=[Copy (center)] name="+substring(imageslist[fileID], 0, lastIndexOf(imageslist[fileID], "--"))+" title="+substring(imageslist[fileID], 0, lastIndexOf(imageslist[fileID], "--"))+" use");
} else {
infostring=Property.getInfo();
infoarray=split(infostring, "\n");
sizeC=-1;
sizeX=-1;
sizeY=-1;
pixelsizeX=-1;
imageCount=-1;
stagepositionX=-1;
stagepositionY=-1;
stagepositionZ=-1;
for(ii=0; ii<lengthOf(infoarray); ii++){
if((indexOf(infoarray[ii],"SizeC")>0)&&sizeC<0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
sizeC=parseInt(C[1]);
print("sizeC: "+C[1]);
}
if(indexOf(infoarray[ii],"SizeX")>0&&sizeX<0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
sizeX=parseInt(C[1]);
print("sizeX: "+sizeX);
}
if(indexOf(infoarray[ii],"SizeY")>0&&sizeY<0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
sizeY=parseInt(C[1]);
print("sizeY: "+sizeY);
}
if(indexOf(infoarray[ii],"dCalibration")>=0&&pixelsizeX<0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
pixelsizeX=pixelsizeY=parseFloat(C[1]);
print("pixelsizeX: "+pixelsizeX);
}
if(indexOf(infoarray[ii],"Number of Picture Planes")>=0&&imageCount<0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
imageCount=parseInt(C[1]);
print("Planes: "+imageCount);
}
if(indexOf(infoarray[ii],"dXPos")>=0&&stagepositionX<0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
stagepositionX=parseFloat(C[1]);
print("stageXpos: "+stagepositionX);
}
if(indexOf(infoarray[ii],"dYPos")>=0&&stagepositionY<0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
stagepositionY=parseFloat(C[1]);
print("stageYpos: "+stagepositionY);
}
if((indexOf(infoarray[ii],"dZPos")>=0)&&(stagepositionZ<0)){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
stagepositionZ=parseFloat(C[1]);
print("stageZpos: "+stagepositionZ);
}
}
xcenter=sizeX/2;
ycenter=sizeY/2;
run("Images to Stack", "method=[Copy (center)] name="+substring(imageslist[fileID], 0, lastIndexOf(imageslist[fileID], "_"))+" title="+substring(imageslist[fileID], 0, lastIndexOf(imageslist[fileID], "_"))+" use");
}
sequenceID=getImageID();
} else {
target=imagesdir+imageslist[fileID];
for(it=0; it<analysedchannels; it++){
if(chkimgch[it]>0){
run("Bio-Formats", "open=["+target+"] autoscale color_mode=Default rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order="+stackOrder+" "+specify+"begin="+(it+1)+" "+specify+"end="+(it+1)+" "+specify+" step=1");
//setBatchMode("show");
rename("Channel"+d2s(it+1,0));
}
infostring=Property.getInfo();
infoarray=split(infostring, "\n");
sizeC=-1;
sizeX=-1;
sizeY=-1;
pixelsizeX=-1;
imageCount=-1;
stagepositionX=-1;
stagepositionY=-1;
stagepositionZ=-1;
for(ii=0; ii<lengthOf(infoarray); ii++){
if((indexOf(infoarray[ii],"SizeC")>0)&&sizeC<0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
sizeC=parseInt(C[1]);
print("sizeC: "+C[1]);
}
if(indexOf(infoarray[ii],"SizeX")>0&&sizeX<0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
sizeX=parseInt(C[1]);
print("sizeX: "+sizeX);
}
if(indexOf(infoarray[ii],"SizeY")>0&&sizeY<0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
sizeY=parseInt(C[1]);
print("sizeY: "+sizeY);
}
if(indexOf(infoarray[ii],"dCalibration")>=0&&pixelsizeX<0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
pixelsizeX=pixelsizeY=parseFloat(C[1]);
print("pixelsizeX: "+pixelsizeX);
}
if(indexOf(infoarray[ii],"Number of Picture Planes")>=0&&imageCount<0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
imageCount=parseInt(C[1]);
print("Planes: "+imageCount);
}
if(indexOf(infoarray[ii],"dXPos")>=0&&stagepositionX<0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
stagepositionX=parseFloat(C[1]);
print("stageXpos: "+stagepositionX);
}
if(indexOf(infoarray[ii],"dYPos")>=0&&stagepositionY<0){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
stagepositionY=parseFloat(C[1]);
print("stageYpos: "+stagepositionY);
}
if((indexOf(infoarray[ii],"dZPos")>=0)&&(stagepositionZ<0)){
//print(infoarray[ii]);
C=split(infoarray[ii], "=");
stagepositionZ=parseFloat(C[1]);
print("stageZpos: "+stagepositionZ);
}
}
}
run("Images to Stack", "method=[Copy (center)] name="+fileID+" title=Channel use");
xcenter=sizeX/2;
ycenter=sizeY/2;
sequenceID=getImageID();
}
} else {

}
selectImage(sequenceID);
//r=0;
depthseq=bitDepth();
setSlice(nSlices);
for(sl=0; sl<subcomp+2; sl++){
run("Add Slice");
}
if(checkwholecell){
run("Add Slice");
}
rename("FileID_"+fileID);
concstring=concstring+" image"+d2s(k,0)+"=FileID_"+fileID;
concstringimgnames=concstringimgnames+"FileID_"+fileID+"\n";
k=k+1;
}
selectImage("FileID_"+fileID);

setSlice(displayedchannels+1);
setColor(65535);
XcoordIndex=newArray(subcomp+2);
YcoordIndex=newArray(subcomp+2);
for(icoord=1; icoord<subcomp+1; icoord++){
XcoordIndex[icoord]=indexOf(Xcoord[regcellIndexarray[i]], "*", XcoordIndex[icoord-1]+1);
YcoordIndex[icoord]=indexOf(Ycoord[regcellIndexarray[i]], "*", YcoordIndex[icoord-1]+1);
}
XcoordIndex[subcomp+1]=lengthOf(Xcoord[regcellIndexarray[i]]);
YcoordIndex[subcomp+1]=lengthOf(Ycoord[regcellIndexarray[i]]);
Xtemp=newArray(subcomp+1);
Ytemp=newArray(subcomp+1);
for(icoord=0; icoord<subcomp+1; icoord++){
Xtemp[icoord]=substring(Xcoord[regcellIndexarray[i]], XcoordIndex[icoord],XcoordIndex[icoord+1]);
Ytemp[icoord]=substring(Ycoord[regcellIndexarray[i]], YcoordIndex[icoord],YcoordIndex[icoord+1]);
}
if(checkwholecell){
WholeXtemp=split(Xtemp[0],"\|");
WholeYtemp=split(Ytemp[0],"\|");
Xtempii=split(WholeXtemp[0],"\:");
Ytempii=split(WholeYtemp[0],"\:");
WholeXtempii=split(WholeXtemp[1],"\:");
WholeYtempii=split(WholeYtemp[1],"\:");
} else {
Xtempii=split(Xtemp[0],"\:");
Ytempii=split(Ytemp[0],"\:");
}
X=newArray(Xtempii.length-1);
Y=newArray(Ytempii.length-1);
for(ix=1; ix<Xtempii.length; ix++){
X[ix-1]=parseInt(Xtempii[ix]);
Y[ix-1]=parseInt(Ytempii[ix]);
}
makeSelection("polygon", X, Y);
getSelectionBounds(xb, yb, widthb, heightb);

setSlice(displayedchannels+1);
setColor(65535);
setFont("SansSerif", 18, "italic");
drawString(kcell, xb+widthb/2, yb+heightb/2);
if((i==regImages[j]-1)||(regcellIndexarray[i]!=regcellIndexarray[minOf(i+1,regImages[j]-1)])){
kcell=kcell+1;
}
if(stageposcheck){
if(i==0){
stgXPos[i]=stagepositionX-pixelsizeX*((xb+widthb/2)-xcenter);
stgYPos[i]=stagepositionY+pixelsizeY*((yb+heightb/2)-ycenter);
stgZPos[i]=stagepositionZ;
} else {
stgXPos=Array.concat(stgXPos,stagepositionX-pixelsizeX*((xb+widthb/2)-xcenter));
stgYPos=Array.concat(stgYPos,stagepositionY+pixelsizeY*((yb+heightb/2)-ycenter));
stgZpos=Array.concat(stgZpos,stagepositionZ);
}
//print(f1, (i+1)+"\t"+stgXPos+"\t"+stgYPos+"\t"+stagepositionZ);
if(i>0){
dPos=dCut;
for(h=0; h<xmlstgXPos.length; h++){
distance=Math.sqrt((stgXPos[i]-xmlstgXPos[h])*(stgXPos[i]-xmlstgXPos[h])+(stgYPos[i]-xmlstgYPos[h])*(stgYPos[i]-xmlstgYPos[h]));
print("Cell "+i+" - Stored Cell "+h+" Distance: "+distance);
if(distance<dPos){
dPos=distance;
}
}
print("Cell "+i+" - Closest Acquired Cell Distance: "+dPos);
} else {
dPos=dCut+1;
}
if(i>=endcell-1){
print("endcell="+endcell);
if(ndCut<regImages[j]){
if(endcell<nregarray[j]){
endcell=endcell+1;
}
}
print("endcell="+endcell+"; i="+i);
}
if(dPos>=dCut){
ndCut=ndCut+1;
//////////ndCut: number of really retrieved positions; cutoff distance applied to avoid repeated imaging/////////
if(i>0){
retrstageIndex=Array.concat(retrstageIndex, i);
} else {
retrstageIndex=newArray(1);
retrstageIndex[0]=0;
}
pointstring="Point";
for(kl=0; kl<5-lengthOf(d2s(ndCut,0)); kl++){
pointstring=pointstring+"0";
}
pointstring=pointstring+d2s(ndCut,0);
xmlstring="<"+pointstring;
xmlstring=xmlstring+" runtype=\"NDSetupMultipointListItem\">\n";
xmlstring=xmlstring+"<bChecked runtype=\"bool\" value=\"true\"/>\n";
xmlstring=xmlstring+"<strName runtype=\"CLxStringW\" value=\"\"/>\n";
xmlstring=xmlstring+"<dXPosition runtype=\"double\" value=\""+d2s(stgXPos[i],15)+"\"/>\n";
xmlstring=xmlstring+"<dYPosition runtype=\"double\" value=\""+d2s(stgYPos[i],15)+"\"/>\n";
xmlstring=xmlstring+"<dZPosition runtype=\"double\" value=\""+d2s(stagepositionZ,15)+"\"/>\n";
xmlstring=xmlstring+"<dPFSOffset runtype=\"double\" value=\"7274.000000000000000\"/>\n";
xmlstring=xmlstring+"<baUserData runtype=\"CLxByteArray\" value=\"\"/>\n";
xmlstring=xmlstring+"</"+pointstring+">\n";
print(f1, xmlstring);
setFont("SansSerif", 24, "bold");
setColor("black");
drawString(ndCut, xb, yb+heightb/2, "gray");
run("Line Width...", "line=8");
if(xml>0){
xmlstgXPos=Array.concat(xmlstgXPos,stgXPos[i]);
xmlstgYPos=Array.concat(xmlstgYPos,stgYPos[i]);
} else {
xmlstgXPos[0]=stgXPos[i];
xmlstgYPos[0]=stgYPos[i];
}
xml=xml+1;
} else {
run("Line Width...", "line=2");
}
} else { 
run("Line Width...", "line=3");
}
setSlice(displayedchannels+2);
Color.setForeground("#ffffff");
run("Draw", "slice");
if(checkwholecell){
setSlice(displayedchannels+3);
X=newArray(WholeXtempii.length-1);
Y=newArray(WholeYtempii.length-1);
for(ix=1; ix<WholeXtempii.length; ix++){
X[ix-1]=parseInt(WholeXtempii[ix]);
Y[ix-1]=parseInt(WholeYtempii[ix]);
}
makeSelection("polygon", X, Y);
if((X.length>1)&&(Y.length>1)){

Color.setForeground("#ffffff");
//run("Fill", "slice");
run("Line Width...", "line=5");
run("Draw", "slice");
}
}
run("Line Width...", "line=1");
for(ipcont=1; ipcont<lengthOf(Xtemp); ipcont++){
subindraw=0;
subnumbdraw=0;
for(ijsub=1; ijsub<ipcont; ijsub++){
subnumbdraw=subnumbdraw+subcompcounts[ijsub];
subindraw=subindraw+(5+3*analysedchannels)*subcompcounts[ijsub];
}
if(checkwholecell){
setSlice(displayedchannels+3+ipcont);
} else {
setSlice(displayedchannels+2+ipcont);
}
Xtempi=split(Xtemp[ipcont],"\|");
Ytempi=split(Ytemp[ipcont],"\|");
for(ipconti=1; ipconti<lengthOf(Xtempi); ipconti++){
bdrectX=split(Xtempi[ipconti],"\:");
bdrectY=split(Ytempi[ipconti],"\:");
if((activegateweights[subcompcounts[0]+subnumbdraw+minOf(1,regcellIndexarray[i])*spotnumber[(ipcont-1)*subcompcounts[0]+maxOf(0,regcellIndexarray[i]-1)]+ipconti-1]*distancegateweights[subcompcounts[0]+subnumbdraw+minOf(1,regcellIndexarray[i])*spotnumber[(ipcont-1)*subcompcounts[0]+maxOf(0,regcellIndexarray[i]-1)]+ipconti-1])!=0){
setColor(65535);
drawOval(bdrectX[0],bdrectY[0],bdrectX[1],bdrectY[1]);
} else {
setColor(16384);
drawOval(bdrectX[0],bdrectY[0],bdrectX[1],bdrectY[1]);
}
if(ipcont==jactcomp){
Xo=xmidraw[i];
Yo=ymidraw[i];
if(((Xo>bdrectX[0])&&(Xo<bdrectX[0]+bdrectX[1]))&&((Yo>bdrectY[0])&&(Yo<bdrectY[0]+bdrectY[1]))){
setColor(65535);
fillOval(bdrectX[0],bdrectY[0],bdrectX[1],bdrectY[1]);
//print("Got It!");
//print(Xo+","+Yo+"; "+bdrectX[0]+","+bdrectY[0]);
}
} else {
if((activegateweights[subcompcounts[0]+subnumbdraw+minOf(1,regcellIndexarray[i])*spotnumber[(ipcont-1)*subcompcounts[0]+maxOf(0,regcellIndexarray[i]-1)]+ipconti-1]*distancegateweights[subcompcounts[0]+subnumbdraw+minOf(1,regcellIndexarray[i])*spotnumber[(ipcont-1)*subcompcounts[0]+maxOf(0,regcellIndexarray[i]-1)]+ipconti-1])!=0){
//print("Subcomp: "+ ipcont+" Active Comp: "+jactcomp+" cell index: "+i+" weight index: "+(subcompcounts[0]+subnumbdraw+minOf(1,regcellIndexarray[i])*spotnumber[(ipcont-1)*subcompcounts[0]+maxOf(0,regcellIndexarray[i]-1)]+ipconti-1));
//drawOval(bdrectX[0]-2,bdrectY[0]-2,bdrectX[1]+4,bdrectY[1]+4);
}
}
}
}

for(ich=0; ich<displayedchannels; ich++){
if(depthseq!=96){
setSlice(ich+1);
resetMinAndMax();
run("Enhance Contrast", "saturated=0.5");
getMinAndMax(dmin,dmax);
if(displayedrange[2*ich]>dmin){displayedrange[2*ich]=dmin;}
if(displayedrange[2*ich+1]<dmax){displayedrange[2*ich+1]=dmax;}
} else {
displayedrange[2*ich]=0;
displayedrange[2*ich+1]=65535;
}
}
if(cellgallcheck){
//print("Event: "+i+"; Cell: "+regcellIndexarray[minOf(i+1,regImages[j]-1)]);
if((i==regImages[j]-1)||(regcellIndexarray[i]!=regcellIndexarray[minOf(i+1,regImages[j]-1)])){
if(scalefactor<10){
run("Scale... ", "x="+scalefactor+" y="+scalefactor+" centered");
//kcell=kcell+1;
run("Duplicate...", "title=Cell_"+d2s(kcell,0)+" duplicate");
concstringcell=concstringcell+" image"+d2s(kcell,0)+"=Cell_"+d2s(kcell,0);
}
}
}
}
////////////////////end of looping for picture retrieval//////////////////
if(cellmaskcheck){
imgregfiles=split(concstringimgnames,"\n");
//Array.show(imgregfiles);
if(imgdestdir){
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
TimeString ="RegionMasks_"+year;
month=month+1;       
     if (month<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+month;
     if (dayOfMonth<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+dayOfMonth+"_";     
     if (hour<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+hour;
     if (minute<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+minute;
     File.makeDirectory(dir+File.separator+TimeString);
     imgdestdir=false;
}
File.makeDirectory(dir+File.separator+TimeString+File.separator+regnames[j]);
for(irf=1; irf<lengthOf(imgregfiles); irf++){
selectImage(imgregfiles[irf]);
run("Select All");
fileID=parseInt(substring(imgregfiles[irf],indexOf(imgregfiles[irf],"_")+1, lengthOf(imgregfiles[irf])));
//print("File_ID: "+substring(imgregfiles[irf],indexOf(imgregfiles[irf],"_")+1, lengthOf(imgregfiles[irf])));
setSlice(displayedchannels+2);
target=imagesdir+imageslist[fileID];
fname=File.getNameWithoutExtension(target)+"--"+regnames[j]+"Mask.tif";
run("Duplicate...", " ");
rename(fname);
run("Select All");
setMinAndMax(0, 255);
run("8-bit");
save(dir+File.separator+TimeString+File.separator+regnames[j]+File.separator+fname);
close();
print("Saved: "+dir+File.separator+TimeString+File.separator+regnames[j]+File.separator+fname);
}
}

/////////////end of if condition on images for the region//////


print(concstring);
if(checkwholecell){
Dsize=displayedchannels+3+subcomp;                    
} else {
Dsize=displayedchannels+2+subcomp;
}
if(k>2){
run("Concatenate...", "  title="+concstring);
} else {
selectImage(sequenceID);
rename("Gallery_"+regnames[j]);
}

selectImage("Gallery_"+regnames[j]);
//setBatchMode("exit and display");
run("Stack to Image5D", "3rd=ch 4th=z 3rd_dimension_size="+Dsize+" 4th_dimension_size="+(k-1)+" assign");
rename("Gallery5D_"+regnames[j]);
run("To Selection");
//waitForUser("5D");
run("Set... ", "zoom=50");
run("Set Channel Labels", label);
for(ich=0; ich<displayedchannels; ich++){
//selectImage("Gallery_"+regnames[j]);
run("Set Position", "x-position=1 y-position=1 channel="+(ich+1)+" slice=1 frame=1 display=tiled");
run("Brightness/Contrast...");
//print("Ch0"+(ich+1)+"\n Min: "+displayedrange[2*ich]+"; Max: "+displayedrange[2*ich+1]);
setMinAndMax(displayedrange[2*ich], displayedrange[2*ich+1]);
}
run("Set Position", "x-position=1 y-position=1 channel="+(displayedchannels+1)+" slice=1 frame=1 display=tiled");
run("Rainbow RGB");
run("Enhance Contrast", "saturated=0.5");
//run("Grays");
if(checkwholecell){
run("Set Position", "x-position=1 y-position=1 channel="+(displayedchannels+3)+" slice=1 frame=1 display=tiled");
run("Rainbow RGB");
run("Enhance Contrast", "saturated=0.5");
}
if(isOpen("Gallery_"+regnames[j])){
selectImage("Gallery_"+regnames[j]);
close();
}
if(cellgallcheck){
//print(concstringcell);
if(kcell>1){
run("Concatenate...", "  title="+concstringcell);
} else {
selectImage("Cell_"+d2s(kcell,0));
rename("Cell_Gallery_"+regnames[j]);
}
selectImage("Cell_Gallery_"+regnames[j]);
run("Stack to Image5D", "3rd=ch 4th=z 3rd_dimension_size="+Dsize+" 4th_dimension_size="+kcell+" assign");
rename("Cell_Gallery5D_"+regnames[j]);
//setBatchMode("show");
//waitForUser("5D");
//run("To Selection");
run("Set... ", "zoom=50");
run("Set Channel Labels", label);
for(ich=0; ich<analysedchannels; ich++){
//selectImage("Gallery_"+regnames[j]);
run("Set Position", "x-position=1 y-position=1 channel="+(ich+1)+" slice=1 frame=1 display=tiled");
run("Brightness/Contrast...");
print("Ch0"+(ich+1)+"\n Min: "+displayedrange[2*ich]+"; Max: "+displayedrange[2*ich+1]);
setMinAndMax(displayedrange[2*ich], displayedrange[2*ich+1]);
}
if(checkwholecell){
run("Set Position", "x-position=1 y-position=1 channel="+(displayedchannels+2)+" slice=1 frame=1 display=tiled");
run("Rainbow RGB");
run("Enhance Contrast", "saturated=0.5");
}
if(isOpen("Cell_Gallery_"+regnames[j])){
selectImage("Cell_Gallery_"+regnames[j]);
close();
}
}
if(stageposcheck){
print(f1,"</no_name>\n</variant>");
}
}

}
////////////////////////end of looping over regions////////
updateResults();
setBatchMode("exit and display");
selectImage(dotplotID);
}
///////////////////////end of recordcheck (Command Recording Phase)//////////////////////
}
//////////////////////end of check of empty DP (jx or jy != -1)///////////////////////////////////

if(is("BatchMode")){
print("BatchModedisactivated: "+is("BatchMode")+";"+jx+","+jy);
setBatchMode(false);
updateDisplay();
}
if(execheck>0){
Table.rename("Results", resultsfilename+"_"+dsubI+"_"+dsubII+"_"+dsubIII+"_dist="+distcutoff);
if(batchautostatscheck){
selectWindow(resultsfilename+"_"+dsubI+"_"+dsubII+"_"+dsubIII+"_dist="+distcutoff);
Table.save(autosavedir+File.separator+"AutoStatsResults"+File.separator+resultsfilename+"_"+substring(dsubI,4)+"_"+substring(dsubII,4)+"_"+substring(dsubIII,4)+"_dist="+distcutoff+".txt"); 
//run("Close");
}
}
}
///////////////////////////////////////////////////////////////end of Show Stats////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1044)&&(x1<1090)&&(y1>1055)&&(y1<1070)){
updateregionlist();
arraygates=split(gatelist, "\n");
Dialog.create("Gate List");
Dialog.addCheckbox("Gating Active: ", true);
Dialog.addMessage("Select a gate for each compartment. \n Mark the checkbox to activate intercompartment gating");
for(ic=0; ic<subcomp+1; ic++){
gateschoice="|";
for(j=0; j<arraygates.length; j++){
if(ic<10){stringa="0"+d2s(ic,0)+"_";}else{stringa=d2s(ic,0)+"_";}
if((indexOf(arraygates[j],stringa)>=0)||(arraygates[j]=="None")){
gateschoice=gateschoice+arraygates[j]+"|";
}
}
arraygateschoice=split(gateschoice, "\|");
Dialog.addMessage("Gate for "+subcomparray[ic]);
Dialog.addChoice("Gate: ", arraygateschoice);
Dialog.addCheckbox("Active on other compartments: ", false);
}
Dialog.show();
activegateindex=Dialog.getCheckbox();
agistring=d2s(activegateindex,0);
for(ic=0; ic<subcomp+1; ic++){
activegate[2*ic]=Dialog.getChoice();
activegate[2*ic+1]=Dialog.getCheckbox();
agistring=agistring+";"+activegate[2*ic]+","+activegate[2*ic+1];
}
selectImage(dotplotID);
sliceDP=getSliceNumber(); 
if(sliceDP<11){sliceDPtag="0"+d2s(sliceDP-1,0);} else {sliceDPtag=d2s(sliceDP-1,0);}
print("activegateindexDP: "+activegateindexdp);
print(substring(activegateindexdp, indexOf(activegateindexdp,sliceDPtag+":"),indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":")+1)));
//activegateindexdp=replace(activegateindexdp,substring(activegateindexdp, indexOf(activegateindexdp,sliceDPtag+":"),indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":"))), sliceDPtag+":"+agistring);
old=substring(activegateindexdp, indexOf(activegateindexdp,sliceDPtag+":"),indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":")));
new=sliceDPtag+":"+agistring;
activegateindexdp=substring(activegateindexdp, 0, indexOf(activegateindexdp, old))+new+substring(activegateindexdp,indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":")));
print("sliceDP: "+sliceDPtag+"; AGi: "+agistring+"; Index: "+activegateindex);
print("activegateindexDP: "+activegateindexdp);

gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);

}
/////////////////////////////////////////////////////////end of Gate////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>14)&&(x1<110)&&(y1>1145)&&(y1<1160)){
Dialog.create("Compartments List");
Dialog.addChoice("Compartment: ", subcomparray);
Dialog.show();
activecomp=Dialog.getChoice();
setColor(255,255,255);
fillRect(0,650,690,20);
selectImage(dotplotID);
sliceDP=getSliceNumber();
print("Slice Number: "+sliceDP);
if(sliceDP<11){sliceDPtag="0"+d2s(sliceDP-1,0);} else {sliceDPtag=d2s(sliceDP-1,0);}
for(ic=0; ic<subcomp+1; ic++){
if(activecomp==subcomparray[ic]){
//print("non capisco: "+sliceDPtag+" "+activecomp+" "+subcomparray[ic]+" "+jactcompdp);
jactcomp=ic;
if(jactcomp<10){jactstring="0"+d2s(jactcomp,0);} else {jactstring=d2s(jactcomp,0);}
if(lengthOf(jactcompdp)>sliceDP*6){
jactcompdp=replace(jactcompdp,substring(jactcompdp, (sliceDP-1)*6+1,sliceDP*6), sliceDPtag+":"+jactstring);
} else {
jactcompdp=jactcompdp+sliceDPtag+":"+jactstring+"|";
}
print("jactcomp: "+jactcompdp);
}
}
selectImage(dotplotID);
setBatchMode(true);
dotplotscheme();
jx=jy=-1;
activegateindex=0;
setBatchMode(false);
updateDisplay();
}
/////////////////////////////////////////////////////////end of Compartments////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1121)&&(x1<1191)&&(y1>128)&&(y1<145)){
if((jx!=-1)&&(jy!=-1)){
updateregionlist();
transferID=0;
scalex=(maximum[jx]-minimum[jx])/(voltage[jx]*1);
scaley=(maximum[jy]-minimum[jy])/(voltage[jy]*1);
if(isOpen("Results")){
selectWindow("Results");
run("Close");
}
lista=split(regionlist, "\n");
regnames=newArray(lista.length);
nregImages=0;
regionchoice="All|";
if(lista.length>1){
for(j=0; j<lista.length; j++){
if(jactcomp<10){stringa="0"+d2s(jactcomp,0);}else{stringa=d2s(jactcomp,0);}
if(startsWith(lista[j],stringa)){
regionchoice=regionchoice+lista[j]+"|";
}
}
}
arrayregchoice=split(regionchoice,"\|");
nregarray=newArray(arrayregchoice.length);
Array.fill(nregarray,0);
regMaps=newArray(arrayregchoice.length);
if(arrayregchoice.length>1){
stack5Dname="Gallery--"+File.getName(resultsfilepath);
Dialog.create("Cell ROIs Map from Regions");
Dialog.addMessage("Select the regions for map creation:");
for(j=1; j<arrayregchoice.length;j++){
regnamesarray=split(arrayregchoice[j], "\t");
regnames[j]=regnamesarray[0];
Dialog.addCheckbox(regnames[j], false);
//Dialog.addCheckbox("Create Map", false);
}
Dialog.show();
for(j=1; j<arrayregchoice.length; j++){
regMaps[j]=parseInt(Dialog.getCheckbox());
}

Array.getStatistics(regMaps,minmap,maxmap);
if(maxmap>0){

mapfilepath=File.openDialog("Select the Map Generation File (low resolution image of the sample)");
run("Bio-Formats", "open="+mapfilepath+" autoscale color_mode=Default display_metadata rois_import=[ROI manager] view=[Standard ImageJ] stack_order=Default");
rename("Map");
selectWindow("Original Metadata - "+File.getName(mapfilepath));
mapinfo=getInfo("window.contents");
mapinfolines=split(mapinfo, "\n");
sizearray=split(mapinfolines[10],"\t");
mapwidth=parseInt(sizearray[1],0);
sizearray=split(mapinfolines[11],"\t");
mapheight=parseInt(sizearray[1],0);
for(imap=0; imap<mapinfolines.length; imap++){
if(indexOf(mapinfolines[imap],"dCalibration")>=0){
C=split(mapinfolines[imap], "\t");
pixelmapX=pixelmapY=parseFloat(C[1]);
}
if(indexOf(mapinfolines[imap],"dXPos")>=0){
C=split(mapinfolines[imap], "\t");
mapXcenter=parseFloat(C[1]);
}
if(indexOf(mapinfolines[imap],"dYPos")>=0){
C=split(mapinfolines[imap], "\t");
mapYcenter=parseFloat(C[1]);
}
}
selectWindow("Original Metadata - "+File.getName(mapfilepath));
run("Close");
}
}
setBatchMode(true);
for(j=0; j<arrayregchoice.length; j++){
regcellIndexarray=newArray(1);
regcellIndexarray[0]=-1;
//if(regMaps[j]>0){
ngate=0;
nregion=0;
weight=0;
meanstats=newArray(subcompindexend[jactcomp]-subcompindexstart[jactcomp]);
Array.fill(meanstats,0);
if(j>0){
newImage("transfer", "8-bit Black", 1038, 1038,1);
transferID=getImageID();
parameters=split(arrayregchoice[j], "\t");
heading=parameters[0];
jxroi=parseInt(parameters[1]);
jyroi=parseInt(parameters[4]);
voltagexroi=parseFloat(parameters[2]);
voltageyroi=parseFloat(parameters[5]);
//offsetxroi=parseFloat(parameters[3]);
minimumxroi=parseFloat(parameters[3]);
//offsetyroi=parseFloat(parameters[6]);
minimumyroi=parseFloat(parameters[6]);
scalexroi=(parseFloat(parameters[7])-minimumxroi)/(voltagexroi*1);
scaleyroi=(parseFloat(parameters[8])-minimumyroi)/(voltageyroi*1);
 print(f, heading+"\t"+analysedparameterslist[jxroi]+"\t" +voltagexroi+"\t"+minimumxroi+"\t"+parameters[7]+"\t"+analysedparameterslist[jyroi]+"\t" +voltageyroi+"\t"+minimumyroi+"\t"+parameters[8]+"\t"+parameters[9]+"\t"+parameters[10]);
for(jroi=0; jroi<roiManager("count"); jroi++){
if(heading==call("ij.plugin.frame.RoiManager.getName", jroi)){
roiManager("select", jroi);
setColor(255);
fill();
}
}
} else {
  title1 = "Region List";
  title2 = "["+title1+"]";
  f = title2;
  if (isOpen(title1))
     print(f, "\\Clear");
  else
    {run("Table...", "name="+title2+" width=250 height=600");}
  print(f, "\\Headings:Region\tX\tVoltageX\tMinimumX\tMaximumX\tY\tVoltageY\tMinimumY\tMaximumY\tXcoord.\tYcoord.");
setResult("Label", 0, "Events");
setResult("Label", 1, "% of Events (Total)");
setResult("Label", 2, "% of Events (Gated)");
rowResult=2;
for(jstats=subcompindexstart[jactcomp]+1; jstats<subcompindexend[jactcomp]; jstats++){
if(checkparam[jstats]){
rowResult=rowResult+1;
setResult("Label", rowResult, "Mean ["+analysedparameterslist[jstats]+"] "+checkparam[jstats]);
}
}
heading="All";
}
fileIDcheck=-1;
subind=0;
subnumb=0;

for(ijsub=1; ijsub<jactcomp; ijsub++){
subind=subind+(5+3*analysedchannels)*subcompcounts[ijsub];
subnumb=subnumb+subcompcounts[ijsub];
}
for(i=0; i<subcompcounts[jactcomp]; i++){
ngate=ngate+activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i]*distancegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i];
if(j>0){
if(jactcomp==0){
indicex=jxroi+analysedparameters*i;
indicey=jyroi+analysedparameters*i;
indicecell=i;
} else {
indicex=subcompcounts[0]*analysedparameters+subind+i*(5+3*analysedchannels)+(jxroi-subcompindexstart[jactcomp]);
indicey=subcompcounts[0]*analysedparameters+subind+i*(5+3*analysedchannels)+(jyroi-subcompindexstart[jactcomp]);
indicecell=cellIndex[subnumb+i];
}
selectImage(transferID);
jyroicheck=false;
for(ij=0; ij<subcomp+1; ij++){
if(jyroi==subcompindexstart[ij]){
jyroicheck=true;
}
}
if(jyroicheck){
weight=getPixel(8+floor(minOf(offsetxroi+maxOf((datatable[indicex]-minimumxroi),0)/scalexroi, 1)*1023), 8+(0.5*1023))/255;
} else {
weight=getPixel(8+floor(minOf(maxOf((datatable[indicex]-minimumxroi),0)/scalexroi, 1)*1023), 8+floor((1-minOf(maxOf((datatable[indicey]-minimumyroi),0)/scaleyroi, 1))*1023))/255;
//weight=getPixel(8+floor(minOf(offsetxroi+maxOf((datatable[indicex]-minimumxroi),0)/scalexroi, 1)*1023), 8+floor((1-minOf(offsetyroi+maxOf((datatable[indicey]-minimumjyroi),0)/scaleyroi, 1))*1023))/255;
}
} else {
weight=1;
}


statscomp=0;
if(statscomp+1<=subcomp){
checkstatscomp=(activegate[2*statscomp+2]!="None");
} else {
checkstatscomp=false;
}
for(jstats=1; jstats<subcompindexend[jactcomp]-subcompindexstart[jactcomp]; jstats++){
if(checkparam[subcompindexstart[jactcomp]+jstats]){
if(jactcomp==0){
indicestats=jstats+analysedparameters*i;
if(subcompindexstart[jactcomp]+jstats==5+3*analysedchannels+statscomp*(4+3*analysedchannels)){
statscomp=statscomp+1;
if(statscomp+1<=subcomp){
checkstatscomp=(activegate[2*statscomp+2]!="None");
} else {
checkstatscomp=false;
}
//print("Increase statscomp>"+statscomp);
}
} else {
indicestats=subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))*analysedparameters+subind+i*(5+3*analysedchannels)+jstats;
}
meanstats[jstats]=meanstats[jstats]+datatable[indicestats]*weight*activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i];
}
}
//print("End of recalc");
nregarray[j]=nregarray[j]+weight*activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i]*distancegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i];
if((weight*activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i]*distancegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i]!=0)&&(j>0)){
if(regMaps[j]>0){
if(regcellIndexarray[0]<0){
regcellIndexarray[0]=indicecell;
} else {
regcellIndexarray=Array.concat(regcellIndexarray,indicecell);
}
}
////////////////////////end if condition////////////////////////////
}
///////////////////////// end  if condition on weight*activegate///////////////////////////////////
}   
///////end of i cycle
setResult(heading, 0, nregarray[j]);
setResult(heading, 1, 100*nregarray[j]/subcompcounts[jactcomp]);
setResult(heading, 2, 100*nregarray[j]/ngate);
if(activegateindex>0){setResult(heading, 2, 100*nregarray[j]/ngate);}
rowResult=2;
for(jstats=1; jstats<subcompindexend[jactcomp]-subcompindexstart[jactcomp]; jstats++){
if(checkparam[subcompindexstart[jactcomp]+jstats]){
rowResult=rowResult+1;
setResult(heading, rowResult, meanstats[jstats]/nregarray[j]);
}
}
if(isOpen(transferID)){
selectImage(transferID);
close();
}

//}
///////////////// end of statistics calculation for a region////////////////////////

if(regMaps[j]>0){
if(!isOpen("PSF")){
run("Gaussian PSF 3D", "width="+3*(2*meanfilterDP+1)+" height="+3*(2*meanfilterDP+1)+" number=1 dc-level="+(100/nregarray[j])+" horizontal=1 vertical=1 depth=1");
}
selectImage("PSF");
run("Copy");
Array.show(regcellIndexarray);
concstring="[Map_"+regnames[j]+"]";
concstringcell="[Cell_Map_"+regnames[j]+"]";
selectImage("Map");
run("32-bit");
run("Add Slice");
setSlice(nSlices);
//newImage(concstringcell, "16-bit black", mapwidth, mapheight, 1);
//setColor(65535);
limit=minOf(100,nregarray[j]);
mapx=newArray(nregarray[j]);
mapy=newArray(nregarray[j]);
for(i=0; i<nregarray[j]; i++){
/////insert here the recalculation of the position of the event in the map image using the stage coordinates///
if(indexOf(resultsarray[0], "XStage")>0){
mapx[i]=mapwidth/2-(datatable[7+analysedparameters*(regcellIndexarray[i])]-mapXcenter)/pixelmapX;
mapy[i]=mapheight/2+(datatable[10+analysedparameters*(regcellIndexarray[i])]-mapYcenter)/pixelmapY;
} else {
mapx[i]=mapwidth/2-(datatable[availablechind[addZfileindex]+analysedparameters*(regcellIndexarray[i])]-mapXcenter)/pixelmapX;
mapy[i]=mapheight/2+(datatable[availablechind[addZfileindex+1]+analysedparameters*(regcellIndexarray[i])]-mapYcenter)/pixelmapY;
}
makeRectangle(mapx[i]-3*meanfilterDP+shiftobjx, mapy[i]-3*meanfilterDP+shiftobjy,3*(2*meanfilterDP+1),3*(2*meanfilterDP+1));
setPasteMode("Add");
run("Paste");
//fillOval(mapx[i], mapy[i], 20, 20);
}
////////////////////end of looping for cell drawing//////////////////
}
/////////////end of if condition on images for the region//////
//run("Concatenate...", "  title=[Concatenated Stacks] image1=Acquired-5.tif image2=Acquired-4.tif image3=[-- None --]");

}
////////////////////////end of looping over regions////////
setPasteMode("Copy");
if(isOpen("PSF")){
selectImage("PSF");
close();
}
selectImage("Map");
setBatchMode(false);
updateDisplay();
updateResults();
run("Stack to Image5D", "3rd=ch 4th=z 3rd_dimension_size="+nSlices+" 4th_dimension_size=1 assign");
}
}

///////////////////////////////////////////////////////////////end of Coordinate Generation////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if((x1>1121)&&(x1<1191)&&(y1>148)&&(y1<165)){
if(recordcheck){
autocheck=autocheck+1;
autodistcheck=autodistcheck+1;
if (!isOpen("Recording")){
run("Text Window...", "name=[Recording] width=72 height=72 menu");
}
print("[Recording]","Set Distance Gating: Step"+autodistcheck+".\n");
if(x1array[0]<0){
x1array[0]=x1;
y1array[0]=y1;
} else {
x1array=Array.concat(x1array,x1);
y1array=Array.concat(y1array,y1);
}
}
subcompchoice=Array.concat("None", Array.slice(subcomparray,1,subcomparray.length));
selectImage(dotplotID);
if(execheck==0){
Dialog.create("Distance Gating Definition");
Dialog.addChoice("Choose the target compartment (I): ", subcompchoice, dsubI);
Dialog.addChoice("Choose the target compartment (II): ", subcompchoice, dsubII);
Dialog.addChoice("Choose the target compartment (III): ", subcompchoice, dsubIII);
Dialog.addNumber("Define the cutoff distance in pixels (0 for no cutoff): ", distcutoff);
Dialog.show();
dsubI=Dialog.getChoice();
dsubII=Dialog.getChoice();
dsubIII=Dialog.getChoice();
distcutoff=Dialog.getNumber();
if(recordcheck){
if(autodistcheck==1){
recdsubI[0]=dsubI;
recdsubII[0]=dsubII;
recdsubIII[0]=dsubIII;
recdistcutoff[0]=distcutoff;
} else {
recdsubI=Array.concat(recdsubI,dsubI);
recdsubII=Array.concat(recdsubII,dsubII);
recdsubIII=Array.concat(recdsubIII,dsubIII);
recdistcutoff=Array.concat(recdistcutoff,distcutoff);
////Array.show(recdsubI, recdsubII, recdsubIII, recdistcutoff);
}
if (!isOpen("Recording")){
run("Text Window...", "name=[Recording] width=72 height=72 menu");
}
print("[Recording]","Sub Comp I: "+recdsubI[autodistcheck-1]+"\nSub Comp II: "+recdsubII[autodistcheck-1]+"\nSub Comp III: "+recdsubIII[autodistcheck-1]+"\nDistance Cutoff: "+recdistcutoff[autodistcheck-1]+"\n");
}
} else {
dsubI=recdsubI[recautodistcheck-autodistcheck];
dsubII=recdsubII[recautodistcheck-autodistcheck];
dsubIII=recdsubIII[recautodistcheck-autodistcheck];
distcutoff=recdistcutoff[recautodistcheck-autodistcheck];
}
////////////Start of Distance Calculation///////////
if(!recordcheck){
if(execheck>0){
if (!isOpen("Executing")){
run("Text Window...", "name=[Executing] width=72 height=72 menu");
}
print("[Executing]","Distance Gating Step: "+recautodistcheck-autodistcheck+"\nSub Comp I: "+recdsubI[recautodistcheck-autodistcheck]+"\nSub Comp II: "+recdsubII[recautodistcheck-autodistcheck]+"\nSub Comp III: "+recdsubIII[recautodistcheck-autodistcheck]+"\nDistance Cutoff: "+recdistcutoff[recautodistcheck-autodistcheck]+"\n");
if(autodistcheck>0){
autodistcheck=autodistcheck-1;
}
}
if(distcutoff==0){
dsubI=subcompchoice[0];
dsubII=subcompchoice[0];
dsubIII=subcompchoice[0];
}
gateddotplot(jactcomp,jx,jy,voltage[jx],offset[jx],voltage[jy],offset[jy]);
}
}
//////////////////////////////////////////////////////////end of Distance Gating////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1121)&&(x1<1191)&&(y1>168)&&(y1<185)){
selectImage(dotplotID);
DPold=nSlices;
DPstack=0;
firsttimeDP=true;
while(DPstack<DPold){
Dialog.create("Dot Plot Stack Definition");
Dialog.addNumber("Specify the number of slices for the Dot Plot Stack", DPold);
Dialog.addMessage("The number must be greater or equal to "+DPold);
Dialog.show();
DPstack=Dialog.getNumber();
}
setBatchMode(true);
for(i=0; i<DPstack; i++){
if(i<DPold){

} else {
sliceDPlist=i+1;
setSlice(i);
run("Add Slice");

jactcomp=0;
activegateindex=0;
for(ic=0; ic<subcomp+1; ic++){
activegate[2*ic]="None";
activegate[2*ic+1]=false;
}
dotplotscheme();
if(sliceDPlist<11){sliceDPtag="0"+d2s(sliceDPlist-1,0);} else {sliceDPtag=d2s(sliceDPlist-1,0);}
agistring=d2s(activegateindex,0);
for(ic=0; ic<subcomp+1; ic++){
agistring=agistring+";None,0";
}
activegateindexdp=activegateindexdp+sliceDPtag+":"+agistring+"|";
if(jactcomp<10){jactstring="0"+d2s(jactcomp,0);} else {jactstring=d2s(jactcomp,0);}

jactcompdp=jactcompdp+sliceDPtag+":"+jactstring+"|";
jxdp=jxdp+sliceDPtag+":---|";
jydp=jydp+sliceDPtag+":---|";
}
}

while((indexOf(jxdp,"---",0)>0)||(indexOf(jydp,"---",0)>0)||firsttimeDP){
firsttimeDP=false;
if(!(isOpen("Dot Plot Stack Settings"))){
newImage("Dot Plot Stack Settings","RGB White", 1850, 24*(DPstack+1), 1);
DPscpID=getImageID();
setColor(0,0,255);
fillRect(0,0, 50, 24);
fillRect(50,0, 200, 24);
fillRect(250,0, 300,24);
fillRect(550,0, 100,24);
fillRect(650,0, 100, 24);
fillRect(750,0,100,24);
fillRect(850,0,300,24);
fillRect(1150,0,100,24);
fillRect(1250,0,100, 24);
fillRect(1350,0,100,24);
fillRect(1450,0,400,24);
setColor(255,255,255);
drawString("Slice", 4,20);
drawString("Compartment", 54,20);
drawString("X-Axis", 254,20);
drawString("X-Scale: Min", 554,20);
drawString ("X-Scale: Max", 654, 20);
drawString("X-Voltage", 754,20);
drawString("Y-Axis", 854,20);
drawString("Y-Scale: Min", 1154,20);
drawString("Y-Scale: Max", 1254,20);
drawString("Y-Voltage", 1354,20);
drawString("Gates", 1454,20);
setColor(0,0,0);
drawRect(0,0, 50, 24);
drawRect(50,0, 200, 24);
drawRect(250,0, 300,24);
drawRect(550,0, 100,24);
drawRect(650,0, 100, 24);
drawRect(750,0,100,24);
drawRect(850,0,300,24);
drawRect(1150,0,100,24);
drawRect(1250,0,100, 24);
drawRect(1350,0,400,24);
drawRect(1450,0,400,24);
for(i=1; i<DPstack+1; i++){
drawRect(0,24*i, 50, 24);
drawRect(50,24*i, 200, 24);
drawRect(250,24*i, 300, 24);
drawRect(550,24*i, 100, 24);
drawRect(650,24*i,100, 24);
drawRect(750,24*i,100, 24);
drawRect(850,24*i,300, 24);
drawRect(1150,24*i,100, 24);
drawRect(1250,24*i,100, 24);
drawRect(1350,24*i,100, 24);
drawRect(1450,24*i,400,24);
drawString(d2s(i,0),4, 20+24*i);
drawString(subcomparray[d2s(substring(jactcompdp,(i-1)*6+4,i*6),0)],54,20+24*i);
drawGate=split(activegateindexdp, "|");
drawString(drawGate[i-1]+";", 1454, 20+24*i);
if(substring(jxdp, (i-1)*7+4, i*7)!="---"){
drawString(analysedparameterslist[d2s(substring(jxdp, (i-1)*7+4, i*7),0)]+";", 254, 20+24*i);
drawString(d2s(minimum[parseInt(substring(jxdp, (i-1)*7+4, i*7))],0), 554, 20+24*i);
drawString(d2s(maximum[parseInt(substring(jxdp, (i-1)*7+4, i*7))],0), 654, 20+24*i);
drawString(d2s(voltage[parseInt(substring(jxdp, (i-1)*7+4, i*7))],2), 754, 20+24*i);
}
if(substring(jydp, (i-1)*7+4, i*7)!="---"){
drawString(analysedparameterslist[d2s(substring(jydp, (i-1)*7+4, i*7),0)]+";", 854, 20+24*i);
drawString(d2s(minimum[parseInt(substring(jydp, (i-1)*7+4, i*7))],0),1154,20+24*i);
drawString(d2s(maximum[parseInt(substring(jydp, (i-1)*7+4, i*7))],0),1254,20+24*i);
drawString(d2s(voltage[parseInt(substring(jydp, (i-1)*7+4, i*7))],2), 1354, 20+24*i);
}
}
setBatchMode("show");
showMessage("Check that all axis have been specified before closing the panel");
}


while(isOpen("Dot Plot Stack Settings")){
if(isActive(DPscpID)){
getCursorLoc(x2, y2, z2, flags);
if((flags&leftButton!=0)&&(x2!=xr)&&(y2!=yr)){
xr=x2; yr=y2;
secondtime=false;
sliceDP=floor(yr/24);
if(yr>24){
if((x2>50)&&(x2<250)){
Dialog.create("Compartments List");
Dialog.addChoice("Compartment: ", subcomparray);
Dialog.show();
compDP=Dialog.getChoice();
print("Slice Number: "+sliceDP);
if(sliceDP<11){sliceDPtag="0"+d2s(sliceDP-1,0);} else {sliceDPtag=d2s(sliceDP-1,0);}
for(ic=0; ic<subcomp+1; ic++){
if(compDP==subcomparray[ic]){
jcompDP=ic;
if(jcompDP<10){jactstring="0"+d2s(jcompDP,0);} else {jactstring=d2s(jcompDP,0);}
if(lengthOf(jactcompdp)>sliceDP*6){
//jactcompdp=replace(jactcompdp,substring(jactcompdp, (sliceDP-1)*6+1,sliceDP*6), sliceDPtag+":"+jactstring);
jactcompdp=substring(jactcompdp, 0,(sliceDP-1)*6+1)+sliceDPtag+":"+jactstring+substring(jactcompdp, sliceDP*6,lengthOf(jactcompdp));
} else {
jactcompdp=jactcompdp+sliceDPtag+":"+jactstring+"|";
}
print("jactcomp: "+jactcompdp);
}
}
selectImage(DPscpID);
setColor(255,255,255);
fillRect(50,24*sliceDP, 200,24);
fillRect(250,24*sliceDP, 300,24);
jxdp=replace(jxdp,substring(jxdp, (sliceDP-1)*7+1,sliceDP*7), sliceDPtag+":---");
fillRect(550,24*sliceDP, 100,24);
fillRect(650,24*sliceDP, 100,24);
fillRect(750,24*sliceDP, 100,24);
fillRect(850,24*sliceDP, 300,24);
jydp=replace(jydp,substring(jydp, (sliceDP-1)*7+1,sliceDP*7), sliceDPtag+":---");
fillRect(1150,24*sliceDP, 100,24);
fillRect(1250,24*sliceDP, 100,24);
fillRect(1350,24*sliceDP, 100,24);
fillRect(1450,24*sliceDP, 400,24);
activegateindex=0;
agistring=d2s(activegateindex,0);
for(ic=0; ic<subcomp+1; ic++){
agistring=agistring+";None,0";
}
//activegateindexdp=replace(activegateindexdp,substring(activegateindexdp, indexOf(activegateindexdp,sliceDPtag+":"),indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":"))), sliceDPtag+":"+agistring);
old=substring(activegateindexdp, indexOf(activegateindexdp,sliceDPtag+":"),indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":")));
new=sliceDPtag+":"+agistring;
activegateindexdp=substring(activegateindexdp, 0, indexOf(activegateindexdp, old))+new+substring(activegateindexdp,indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":")));
setColor(0,0,0);
drawRect(50,24*sliceDP, 200,24);
drawString(subcomparray[jcompDP],54,20+24*sliceDP);
drawRect(250,24*sliceDP, 300,24);
drawRect(550,24*sliceDP, 100,24);
drawRect(650,24*sliceDP, 100,24);
drawRect(750,24*sliceDP, 100,24);
drawRect(850,24*sliceDP, 300,24);
drawRect(1150,24*sliceDP, 100,24);
drawRect(1250,24*sliceDP, 100,24);
drawRect(1350,24*sliceDP, 100,24);
drawRect(1450,24*sliceDP, 400,24);
drawString(sliceDPtag+":"+agistring,1254,20+24*sliceDP);
}

if((x2>250)&&(x2<550)){
jactcompdplist=split(jactcompdp,"|");
jcompdp=d2s(substring(jactcompdplist[sliceDP-1],3,5),0);
choiceparameterslist="|";
for(ich=0; ich<(subcompindexend[jcompdp]-subcompindexstart[jcompdp]);ich++){
if(checkparam[subcompindexstart[jcompdp]+ich]){
choiceparameterslist=choiceparameterslist+"|"+analysedparameterslist[subcompindexstart[jcompdp]+ich];
}
}
choiceparameters=split(choiceparameterslist, "|");
jxdpcheck=0;
while(jxdpcheck==0){
Dialog.create("Parameters:");
Dialog.addChoice("X axis: ", choiceparameters, choiceparameters[jDAPI]);
Dialog.show();
axis=Dialog.getChoice();
for(ch=0; ch<fullanalysedparameters; ch++){
if(axis==analysedparameterslist[ch]){
jxdplist=ch;
if(sliceDP<11){sliceDPtag="0"+d2s(sliceDP-1,0);} else {sliceDPtag=d2s(sliceDP-1,0);}
if(jxdplist<100){if(jxdplist<10){jxstring="00"+d2s(jxdplist,0);}else{jxstring="0"+d2s(jxdplist,0);}} else {jxstring=d2s(jxdplist,0);}
if(lengthOf(jxdp)>sliceDP*7){
jxdp=replace(jxdp,substring(jxdp, (sliceDP-1)*7+1,sliceDP*7), sliceDPtag+":"+jxstring);
} else {
jxdp=jxdp+sliceDPtag+":"+jxstring+"|";
}
print("jxdp: "+jxdp);
}
}
if(jxdplist>0){jxdpcheck=1;}
}
jxdpcheck=0;
selectImage(DPscpID);
setColor(255,255,255);
fillRect(250,24*sliceDP, 300,24);
setColor(0,0,0);
drawRect(250,24*sliceDP, 300,24);
drawString(analysedparameterslist[jxdplist]+";", 254, 20+24*sliceDP);
setColor(255,255,255);
fillRect(550,24*sliceDP, 100,24);
fillRect(650,24*sliceDP, 100,24);
fillRect(750,24*sliceDP, 100,24);
setColor(0,0,0);
drawRect(550,24*sliceDP, 100,24);
drawRect(650,24*sliceDP, 100,24);
drawRect(650,24*sliceDP, 100,24);
drawString(d2s(minimum[jxdplist],0), 554, 20+24*sliceDP);
drawString(d2s(maximum[jxdplist],0), 654, 20+24*sliceDP);
drawString(d2s(voltage[jxdplist],2), 754, 20+24*sliceDP);
}
if ((x2>550)&&(x2<650)){
jxdplist=substring(jxdp, (sliceDP-1)*7+4,sliceDP*7);
if(jxdplist!="---"){
Dialog.create("Manual Scale X-axis:");
Dialog.addNumber("X minimum value: ", autominimum[jxdplist]);
Dialog.show();
manualminimum[jxdplist]=Dialog.getNumber();
minimum[jxdplist]=manualminimum[jxdplist];
checkautomin[jxdplist]=1;
selectImage(DPscpID);
setColor(255,255,255);
fillRect(550,24*sliceDP, 100,24);
setColor(0,0,0);
drawRect(550,24*sliceDP, 100,24);
drawString(d2s(minimum[jxdplist],0), 554, 20+24*sliceDP);
for(i=0; i<DPstack; i++){
if(parseInt(substring(jxdp, i*7+4, (i+1)*7))==jxdplist){
setColor(255,255,255);
fillRect(550,24+24*i,100,24);
setColor(0,0,0);
drawRect(550,24+24*i,100,24);
drawString(d2s(minimum[jxdplist],0), 554, 24+20+24*i);
}
}
}
}
if ((x2>650)&&(x2<750)){
jxdplist=substring(jxdp, (sliceDP-1)*7+4,sliceDP*7);
if(jxdplist!="---"){
Dialog.create("Manual Scale X-axis:");
Dialog.addNumber("X maximum value: ", automaximum[jxdplist]);
Dialog.show();
manualmaximum[jxdplist]=Dialog.getNumber();
maximum[jxdplist]=manualmaximum[jxdplist];
checkautomax[jxdplist]=1;
selectImage(DPscpID);
setColor(255,255,255);
fillRect(650,24*sliceDP, 100,24);
setColor(0,0,0);
drawRect(650,24*sliceDP, 100,24);
drawString(d2s(maximum[jxdplist],0), 654, 20+24*sliceDP);
for(i=0; i<DPstack; i++){
if(parseInt(substring(jxdp, i*7+4, (i+1)*7))==jxdplist){
setColor(255,255,255);
fillRect(650,24+24*i,100,24);
setColor(0,0,0);
drawRect(650,24+24*i,100,24);
drawString(d2s(maximum[jxdplist],0), 654, 24+20+24*i);
}
}
}
}
if ((x2>750)&&(x2<850)){
jxdplist=substring(jxdp, (sliceDP-1)*7+4,sliceDP*7);
if(jxdplist!="---"){
Dialog.create("Voltage X-axis:");
Dialog.addNumber("Voltage value (1.00-10.00): ", voltage[jxdplist]);
Dialog.show();
voltage[jxdplist]=Dialog.getNumber();
selectImage(DPscpID);
setColor(255,255,255);
fillRect(750,24*sliceDP, 100,24);
setColor(0,0,0);
drawRect(750,24*sliceDP, 100,24);
drawString(d2s(voltage[jxdplist],2), 754, 20+24*sliceDP);
for(i=0; i<DPstack; i++){
if(parseInt(substring(jxdp, i*7+4, (i+1)*7))==jxdplist){
setColor(255,255,255);
fillRect(750,24+24*i,100,24);
setColor(0,0,0);
drawRect(750,24+24*i,100,24);
drawString(d2s(voltage[jxdplist],2), 754, 24+20+24*i);
}
}
}
}
if ((x2>850)&&(x2<1150)){
jactcompdplist=split(jactcompdp,"|");
jcompdp=d2s(substring(jactcompdplist[sliceDP-1],3,5),0);
choiceparameterslist="|";
for(ich=0; ich<(subcompindexend[jcompdp]-subcompindexstart[jcompdp]);ich++){
if(checkparam[subcompindexstart[jcompdp]+ich]){
choiceparameterslist=choiceparameterslist+"|"+analysedparameterslist[subcompindexstart[jcompdp]+ich];
}
}
choiceparameters=split(choiceparameterslist, "|");
Dialog.create("Parameters:");
Dialog.addChoice("Y axis: ", choiceparameters);
Dialog.show();
axis=Dialog.getChoice();
for(ch=0; ch<fullanalysedparameters; ch++){
if(axis==analysedparameterslist[ch]){
jydplist=ch;
if(sliceDP<11){sliceDPtag="0"+d2s(sliceDP-1,0);} else {sliceDPtag=d2s(sliceDP-1,0);}
if(jydplist<100){if(jydplist<10){jystring="00"+d2s(jydplist,0);}else{jystring="0"+d2s(jydplist,0);}} else {jystring=d2s(jydplist,0);}
if(lengthOf(jydp)>sliceDP*7){
jydp=replace(jydp,substring(jydp, (sliceDP-1)*7+1,sliceDP*7), sliceDPtag+":"+jystring);
} else {
jydp=jydp+sliceDPtag+":"+jystring+"|";
}
print("jydp: "+jydp);
}
}

selectImage(DPscpID);
setColor(255,255,255);
fillRect(850,24*sliceDP, 300,24);
setColor(0,0,0);
drawRect(850,24*sliceDP, 300,24);
drawString(analysedparameterslist[jydplist]+";", 854, 20+24*sliceDP);
setColor(255,255,255);
fillRect(1150,24*sliceDP, 100,24);
fillRect(1250,24*sliceDP, 100,24);
fillRect(1350,24*sliceDP, 100,24);
setColor(0,0,0);
drawRect(1150,24*sliceDP, 100,24);
drawRect(1250,24*sliceDP, 100,24);
drawRect(1350,24*sliceDP, 100,24);
drawString(d2s(minimum[jydplist],0), 1154, 20+24*sliceDP);
drawString(d2s(maximum[jydplist],0), 1254, 20+24*sliceDP);
drawString(d2s(voltage[jydplist],2), 1354, 20+24*sliceDP);
}
if ((x2>1150)&&(x2<1250)){
jydplist=substring(jydp, (sliceDP-1)*7+4,sliceDP*7);
if(jydplist!="---"){
Dialog.create("Manual Scale Y-axis:");
Dialog.addNumber("Y minimum value: ", automaximum[jydplist]);
Dialog.show();
manualminimum[jydplist]=Dialog.getNumber();
minimum[jydplist]=manualminimum[jydplist];
checkautomin[jydplist]=1;
selectImage(DPscpID);
setColor(255,255,255);
fillRect(1150,24*sliceDP, 100,24);
setColor(0,0,0);
drawRect(1150,24*sliceDP, 100,24);
drawString(d2s(minimum[jydplist],0), 1154, 20+24*sliceDP);
for(i=0; i<DPstack; i++){
if(parseInt(substring(jydp, i*7+4, (i+1)*7))==jydplist){
setColor(255,255,255);
fillRect(1150,24+24*i,100,24);
setColor(0,0,0);
drawRect(1150,24+24*i,100,24);
drawString(d2s(minimum[jydplist],0), 1154, 24+20+24*i);
}
}
}
}
if ((x2>1250)&&(x2<1350)){
jydplist=substring(jydp, (sliceDP-1)*7+4,sliceDP*7);
if(jydplist!="---"){
Dialog.create("Manual Scale Y-axis:");
Dialog.addNumber("Y maximum value: ", automaximum[jydplist]);
Dialog.show();
manualmaximum[jydplist]=Dialog.getNumber();
maximum[jydplist]=manualmaximum[jydplist];
checkautomax[jydplist]=1;
selectImage(DPscpID);
setColor(255,255,255);
fillRect(1250,24*sliceDP, 100,24);
setColor(0,0,0);
drawRect(1250,24*sliceDP, 100,24);
drawString(d2s(maximum[jydplist],0), 1254, 20+24*sliceDP);
for(i=0; i<DPstack; i++){
if(parseInt(substring(jydp, i*7+4, (i+1)*7))==jydplist){
setColor(255,255,255);
fillRect(1250,24+24*i,100,24);
setColor(0,0,0);
drawRect(1250,24+24*i,100,24);
drawString(d2s(maximum[jydplist],0), 1254, 24+20+24*i);
}
}
}
}
if ((x2>1350)&&(x2<1450)){
jydplist=substring(jydp, (sliceDP-1)*7+4,sliceDP*7);
if(jydplist!="---"){
Dialog.create("Voltage Y-axis:");
Dialog.addNumber("Voltage value (1.00-10.00): ", voltage[jydplist]);
Dialog.show();
voltage[jydplist]=Dialog.getNumber();
selectImage(DPscpID);
setColor(255,255,255);
fillRect(1350,24*sliceDP, 100,24);
setColor(0,0,0);
drawRect(1350,24*sliceDP, 100,24);
drawString(d2s(voltage[jydplist],2), 1354, 20+24*sliceDP);
for(i=0; i<DPstack; i++){
if(parseInt(substring(jydp, i*7+4, (i+1)*7))==jydplist){
setColor(255,255,255);
fillRect(1350,24+24*i,100,24);
setColor(0,0,0);
drawRect(1350,24+24*i,100,24);
drawString(d2s(voltage[jydplist],2), 1354, 24+20+24*i);
}
}
}
}
if ((x2>1450)&&(x2<1850)){
updateregionlist();
arraygates=split(gatelist, "\n");
Dialog.create("Gate List");
Dialog.addCheckbox("Gating Active: ", true);
Dialog.addMessage("Select a gate for each compartment. \n Mark the checkbox to activate intercompartment gating");
for(ic=0; ic<subcomp+1; ic++){
gateschoice="|";
for(j=0; j<arraygates.length; j++){
if(ic<10){stringa="0"+d2s(ic,0)+"_";}else{stringa=d2s(ic,0)+"_";}
if((indexOf(arraygates[j],stringa)>=0)||(arraygates[j]=="None")){
gateschoice=gateschoice+arraygates[j]+"|";
}
}
arraygateschoice=split(gateschoice, "\|");
Dialog.addMessage("Gate for "+subcomparray[ic]);
Dialog.addChoice("Gate: ", arraygateschoice);
Dialog.addCheckbox("Active on other compartments: ", false);
}
Dialog.show();
DPgateindex=Dialog.getCheckbox();
agistring=d2s(DPgateindex,0);
for(ic=0; ic<subcomp+1; ic++){
//activegate[2*ic]=Dialog.getChoice();
//activegate[2*ic+1]=Dialog.getCheckbox();
agistring=agistring+";"+Dialog.getChoice()+","+Dialog.getCheckbox();
}

if(sliceDP<11){sliceDPtag="0"+d2s(sliceDP-1,0);} else {sliceDPtag=d2s(sliceDP-1,0);}
//activegateindexdp=replace(activegateindexdp,substring(activegateindexdp, indexOf(activegateindexdp,sliceDPtag+":"),indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":"))), sliceDPtag+":"+agistring);
old=substring(activegateindexdp, indexOf(activegateindexdp,sliceDPtag+":"),indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":")));
new=sliceDPtag+":"+agistring;
activegateindexdp=substring(activegateindexdp, 0, indexOf(activegateindexdp, old))+new+substring(activegateindexdp,indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":")));
print("activegateindexDP: "+activegateindexdp);
selectImage(DPscpID);
setColor(255,255,255);
fillRect(1450,24*sliceDP, 400,24);
setColor(0,0,0);
drawRect(1450,24*sliceDP, 400,24);
drawGate=split(activegateindexdp, "|");
drawString(drawGate[sliceDP-1]+";", 1454, 20+24*sliceDP);
}
}
}
}
}
print("DPStack over; jxdp index: "+indexOf(jxdp,"---",0)+" jydpindex: "+indexOf(jydp,"---",0)+" firtstimeDP: "+firsttimeDP);
}
selectWindow("Dot Plot"+resultsfilepath);
updateDP();
setBatchMode("exit and display");
updateDisplay();
}

////////////////////////////////////////////////////////////////////end of DP Stack creation/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1121)&&(x1<1191)&&(y1>188)&&(y1<205)){
endautostats=false;
//recordcheck=0;
if((batchautostatscheck)&&(execheck)){
if(ibatch<listautofiles.length-1){
if(autocheck==0){
firsttime=false;
ibatch=ibatch+1;
resultsfilepath=autostatsdir+File.separator+listautofiles[ibatch];
print("Opening: "+listautofiles[ibatch]);
dataloading(resultsfilepath, firsttime);
autocheck=recautocheck;
autostatscheck=recautostatscheck;
autodistcheck=recautodistcheck;
}
} else {
batchautostatscheck=false;
waitForUser("Autocheck: "+autocheck+"\n Batch Auto Stats concluded");
endautostats=true;
}
} else {
Dialog.create("Recorder");
Dialog.addRadioButtonGroup("Actions: ", recorder, 3, 1, "exit");
Dialog.show();
RecAction=Dialog.getRadioButton();
if(RecAction==recorder[0]){
recordcheck=1;
execheck=0;
if (isOpen("Recording")){
recsavecheck=getBoolean("Do you want to save the Recorded List?");
print("Saving Recorder");
}
if (isOpen("Recording")){
selectWindow("Recording");
run("Close");
}
if (isOpen("Executing")){
selectWindow("Executing");
run("Close");
}
run("Text Window...", "name=[Recording] width=72 height=72 menu");
print("[Recording]", "Start Command Recording: recordcheck=1.\n");
}
if(RecAction==recorder[1]){
if(recordcheck>0){
autocheck=autocheck+1;
autostatscheck=autostatscheck+1;
  if (!isOpen("Recording")){
     run("Text Window...", "name=[Recording] width=72 height=72 menu");
     }
print("[Recording]","Auto Stats.\n");
if(x1array[0]<0){
x1array[0]=x1;
y1array[0]=y1;
} else {
x1array=Array.concat(x1array,x1);
y1array=Array.concat(y1array,y1);
}
}
recordcheck=0;
execheck=1;
recautocheck=autocheck;
recautostatscheck=autostatscheck;
recautodistcheck=autodistcheck;
Dialog.create("Auto Stats Execution: Autocheck="+autocheck);
Dialog.addCheckbox("Batch Analysis: ", batchautostatscheck);
Dialog.addDirectory("Dir with files to be analysed: ", dir);
Dialog.show();
batchautostatscheck=Dialog.getCheckbox();
if(batchautostatscheck){
autostatsdir=Dialog.getString();
listautofiles=getFileList(autostatsdir);
autosavedir=File.getParent(dir);
File.makeDirectory(autosavedir+File.separator+"AutoStatsResults");
}
  if (!isOpen("Executing")){
     run("Text Window...", "name=[Executing] width=72 height=72 menu");
}
print("[Executing]", "Start Command Execution: execheck=1.\n");
}
if(RecAction==recorder[2]){
endautostats=true;
}
}
if(endautostats){
ibatch=0;
batchautostatscheck=false;
autocheck=0;
execheck=0;
recordcheck=0;
recautostatscheck=autostatscheck=0;
recautodistcheck=autodistcheck=0;
x1array=newArray(1);
x1array[0]=-1;
y1array=newArray(1);
y1array[0]=-1;
reccellgallcheck=newArray(1);
recscalefactor=newArray(1);
reccheckstatsDP=newArray(1);
reccellmaskcheck=newArray(1);
recdCut=newArray(1);
recstageposcheck=newArray(1);
recdsubI=newArray(1);
recdsubII=newArray(1);
recdsubIII=newArray(1);
recdsubI[0]="None";
recdsubII[0]="None";
recdsubIII[0]="None";
recdistcutoff=newArray(1);
}
}
///////////////////////////////////////////////////////////////////end of Auto Stats////////////////////////////////
if((x1>1044)&&(x1<1114)&&(y1>68)&&(y1<85)){
selectImage(dotplotID);
setSlice(nSlices);
setBatchMode(true);
run("Add Slice");
sliceDPL=nSlices;
jx=jy=-1;
jactcomp=0;
activegateindex=0;
for(ic=0; ic<subcomp+1; ic++){
activegate[2*ic]="None";
activegate[2*ic+1]=false;
}
dotplotscheme();
if(sliceDPL<11){sliceDPtag="0"+d2s(sliceDPL-1,0);} else {sliceDPtag=d2s(sliceDPL-1,0);}
agistring=d2s(activegateindex,0);
for(ic=0; ic<subcomp+1; ic++){
agistring=agistring+";None,0";
}
activegateindexdp=activegateindexdp+sliceDPtag+":"+agistring+"|";
if(jactcomp<10){jactstring="0"+d2s(jactcomp,0);} else {jactstring=d2s(jactcomp,0);}

jactcompdp=jactcompdp+sliceDPtag+":"+jactstring+"|";
print(activegateindexdp);
jx=jy=-1;
setBatchMode(false);
updateDisplay();
}
//////////////////////////////////////////////////////////end of New Dot ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1044)&&(x1<1114)&&(y1>88)&&(y1<105)){
updateregionlist();
arraygates=split(gatelist, "\n");
Dialog.create("Renormalizing Parameters");
Dialog.addCheckbox("Activate Renormalization", activerenorm);
Dialog.addChoice("Channel to be renormalized: ", analysedparameterslist, analysedparameterslist[jDAPI]);
Dialog.addCheckbox("Extend to all channels", false);
Dialog.addNumber("Renormalizing value: ", 16000000);
arraygates=split(gatelist, "\n");
Dialog.addCheckbox("Gating Active: ", true);
Dialog.addMessage("Select the gate to be used for images renormalization. It will be set as active gate");
/////renorm limited to cell compartment value (index ic=0); when extending to all subcomp use for(ic=0; ic<subcomp+1; ic++)
for(ic=0; ic<1; ic++){
gateschoice="|";
for(j=0; j<arraygates.length; j++){
if(ic<10){stringa="0"+d2s(ic,0)+"_";}else{stringa=d2s(ic,0)+"_";}
if((indexOf(arraygates[j],stringa)>=0)||(arraygates[j]=="None")){
gateschoice=gateschoice+arraygates[j]+"|";
}
}
arraygateschoice=split(gateschoice, "\|");
Dialog.addMessage("Gate for "+subcomparray[ic]);
Dialog.addChoice("Gate: ", arraygateschoice, renormgate);
Dialog.addCheckbox("Active on other compartments: ", false);
}
Dialog.addMessage("\n \nSecond Renormalization Gating (i.e. 4N DNA value)");
Dialog.addCheckbox("Activate Additional Gating", false);
Dialog.addNumber("Ratio to the Normalizing value (e.g. 2 for 4N DNA content): ", 2);
Dialog.addMessage("Select a second gate to be used for images renormalization.");
/////renorm limited to cell compartment value (index ic=0); when extending to all subcomp use for(ic=0; ic<subcomp+1; ic++)
for(ic=0; ic<1; ic++){
gateschoice="|";
for(j=0; j<arraygates.length; j++){
if(ic<10){stringa="0"+d2s(ic,0)+"_";}else{stringa=d2s(ic,0)+"_";}
if((indexOf(arraygates[j],stringa)>=0)||(arraygates[j]=="None")){
gateschoice=gateschoice+arraygates[j]+"|";
}
}
arraygateschoice=split(gateschoice, "\|");
Dialog.addMessage("Gate for "+subcomparray[ic]);
Dialog.addChoice("Gate: ", arraygateschoice, renormgate);
Dialog.addCheckbox("Active on other compartments: ", false);
}
Dialog.show();
activerenorm=Dialog.getCheckbox(); 
if(activerenorm){
renormalizedchannel=Dialog.getChoice();
renormcheck=Dialog.getCheckbox();
renormvalue=Dialog.getNumber();
activegateindex=Dialog.getCheckbox();
agistring=d2s(activegateindex,0);
/////renorm limited to cell compartment value (index ic=0); when extending to all subcomp use for(ic=0; ic<subcomp+1; ic++)
//renormgate=Dialog.getChoice();
//renormgatecomp=Dialog.getCheckbox();
for(ic=0; ic<1; ic++){
activegate[2*ic]=Dialog.getChoice();
activegate[2*ic+1]=Dialog.getCheckbox();
agistring=agistring+";"+activegate[2*ic]+","+activegate[2*ic+1];
}
renormgate=activegate[0];
selectImage(dotplotID);
sliceDP=getSliceNumber();
if(sliceDP<11){sliceDPtag="0"+d2s(sliceDP-1,0);} else {sliceDPtag=d2s(sliceDP-1,0);}
//activegateindexdp=replace(activegateindexdp,substring(activegateindexdp, indexOf(activegateindexdp,sliceDPtag+":"),indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":"))), sliceDPtag+":"+agistring);
old=substring(activegateindexdp, indexOf(activegateindexdp,sliceDPtag+":"),indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":")));
new=sliceDPtag+":"+agistring;
activegateindexdp=substring(activegateindexdp, 0, indexOf(activegateindexdp, old))+new+substring(activegateindexdp,indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":")));
gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);
renormgateweights=Array.trim(activegateweights, subcompcounts[0]);
activesecond=Dialog.getCheckbox();
if(activesecond){
activesecondfactor=Dialog.getNumber();
//secondgate=Dialog.getChoice();
//secondgatecomp=Dialog.getChoice();
for(ic=0; ic<1; ic++){
activegate[2*ic]=Dialog.getChoice();
activegate[2*ic+1]=Dialog.getCheckbox();
agistring=agistring+";"+activegate[2*ic]+","+activegate[2*ic+1];
}
selectImage(dotplotID);
sliceDP=getSliceNumber();
if(sliceDP<11){sliceDPtag="0"+d2s(sliceDP-1,0);} else {sliceDPtag=d2s(sliceDP-1,0);}
//activegateindexdp=replace(activegateindexdp,substring(activegateindexdp, indexOf(activegateindexdp,sliceDPtag+":"),indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":"))), sliceDPtag+":"+agistring);
old=substring(activegateindexdp, indexOf(activegateindexdp,sliceDPtag+":"),indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":")));
new=sliceDPtag+":"+agistring;
activegateindexdp=substring(activegateindexdp, 0, indexOf(activegateindexdp, old))+new+substring(activegateindexdp,indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":")));
gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);
secondgate=activegate[0];
secondgateweights=Array.trim(activegateweights, subcompcounts[0]);
}
for(ch=0; ch<fullanalysedparameters; ch++){
if(renormalizedchannel==analysedparameterslist[ch]){
jrenorm=ch;
}
}
for(i=0; i<subcompcounts[0]; i++){
ni=0;
renormav=0;
renormcelln=0;
nicheck=true;
while(nicheck){
if((i+ni)<subcompcounts[0]){
if((fileIndex[i+ni]==fileIndex[i])){
renormav=renormav+renormgateweights[i+ni]*datatable[jrenorm+analysedparameters*(i+ni)];
renormcelln=renormcelln+renormgateweights[i+ni];
if(activesecond){
renormav=renormav+secondgateweights[i+ni]*datatable[jrenorm+analysedparameters*(i+ni)]/activesecondfactor;
renormcelln=renormcelln+secondgateweights[i+ni];
}
//print("cell: "+(i+ni)+", renormcellnumber :"+renormcelln+", fileIndex: "+fileIndex[i+ni]+", gate: "+activegateweights[i+ni]+", rawdata: "+datatable[jrenorm+analysedparameters*(i+ni)]+", renormav: "+renormav);
ni=ni+1;
} else {
nicheck=false;
}
} else {
nicheck=false;
}

}
for(j=0; j<ni; j++){
if(renormav!=0){
renormweights[i+j]=renormcelln/renormav;
} else {
renormweights[i+j]=0;
}
if(renormcheck){
for(ch=0; ch<analysedchannels; ch++){
datatable[6+3*ch+analysedparameters*(i+j)]=renormvalue*renormweights[i+j]*datatable[6+3*ch+analysedparameters*(i+j)];
datatable[5+3*ch+analysedparameters*(i+j)]=datatable[6+3*ch+analysedparameters*(i+j)]/datatable[3+analysedparameters*(i+j)];
}
} else {
datatable[jrenorm+analysedparameters*(i+j)]=renormvalue*renormweights[i+j]*datatable[jrenorm+analysedparameters*(i+j)];
datatable[jrenorm-1+analysedparameters*(i+j)]=datatable[jrenorm+analysedparameters*(i+j)]/datatable[3+analysedparameters*(i+j)];
}
}

i=i+ni-1;

}

} else {
Array.fill(renormweights,1);
for(i=0; i<subcompcounts[0]; i++){
for(ch=0; ch<analysedchannels; ch++){
datatable[6+3*ch+analysedparameters*i]=rawdatatable[6+3*ch+analysedparameters*i];
datatable[5+3*ch+analysedparameters*i]=rawdatatable[5+3*ch+analysedparameters*i];
}
}
}

agistring=d2s(activegateindex,0);
/////renorm limited to cell compartment value (index ic=0); when extending to all subcomp use for(ic=0; ic<subcomp+1; ic++)

for(ic=0; ic<subcomp+1; ic++){
activegate[2*ic]=arraygateschoice[0];
activegate[2*ic+1]=false;
agistring=agistring+";"+activegate[2*ic]+","+activegate[2*ic+1];
}
selectImage(dotplotID);
sliceDP=getSliceNumber();
if(sliceDP<11){sliceDPtag="0"+d2s(sliceDP-1,0);} else {sliceDPtag=d2s(sliceDP-1,0);}
//activegateindexdp=replace(activegateindexdp,substring(activegateindexdp, indexOf(activegateindexdp,sliceDPtag+":"),indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":"))), sliceDPtag+":"+agistring);
old=substring(activegateindexdp, indexOf(activegateindexdp,sliceDPtag+":"),indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":")));
new=sliceDPtag+":"+agistring;
activegateindexdp=substring(activegateindexdp, 0, indexOf(activegateindexdp, old))+new+substring(activegateindexdp,indexOf(activegateindexdp,"\|",indexOf(activegateindexdp,sliceDPtag+":")));
updateDP();
}
//////////////////////////////////////////////////////////end of Renormalize ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if((x1>1044)&&(x1<1114)&&(y1>108)&&(y1<125)){
splitfile=getBoolean("Do you want to split the results according to the file of origin?");
rowstart=0;
rowend=subcompcounts[0];
exportcheck=true;
if((activegateindex!=0)||splitfile){
while(exportcheck>0){
//showMessage("Creating a new txt file with the gated events (working only for cells now)");
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
exportname=File.getNameWithoutExtension(resultsfilepath)+"Gated_"+(rowstart+1)+"_"+year+"_"+(month+1)+"_"+dayOfMonth+"_"+hour+"_"+minute+"_"+second+".txt";
exportpath=dir+File.separator+exportname;
exportfileprint=File.open(exportpath);
print(exportfileprint, resultsarray[0]);
newcounts=0;
for(i=rowstart; i<rowend; i++){
//rowend=minOf(rowend+1, subcompcounts[0]);
if(activegateweights[i]!=0){
newcounts=newcounts+1;
print(exportfileprint, resultsarray[i+1]);
}
if(splitfile){
if(i<=subcompcounts[0]-2){
if(fileIndex[i]!=fileIndex[i+1]){
rowstart=i+1;
i=rowend;
}
}
}
if(i==subcompcounts[0]-1){
exportcheck=false;
waitForUser("Cell ExportConcluded");
}
}
exportlastrow=split(resultsarray[counts], "\t");
exportlastrow[3]=d2s(newcounts,0);
exportlast="*"+"\t"+"*"+"\t"+"*"+"\t"+d2s(newcounts-1,0);
exportlast="*";
for(j=1; j<lengthOf(exportlastrow);j++){
exportlast=exportlast+"\t"+exportlastrow[j];
}
print(exportlast);
print(exportfileprint, exportlast);
print(exportfileprint, resultsarray[counts+1]);
replace(resultsarray[counts], subcompcounts[0], newcounts);
//print(resultsarray[counts]);
print("Created "+exportpath);
File.close(exportfileprint);
if(newcounts>0){
exportedsubcompcounts=newArray(subcomp+1);
Array.fill(exportedsubcompcounts, 0);
exportedtable=File.openAsString(exportpath);
exportedrows=split(exportedtable, "\n");
////Array.show(exportindicecell);
exportedtable=exportedrows[0];
ipercent=0;
print("Exported data recalculation");
for(i=1; i<lengthOf(exportedrows)-1; i++){
if(100*i/lengthOf(exportedrows)>ipercent){
print("Analyzed "+ipercent+" % of the cells");
ipercent=ipercent+10;
}
exportedcolumns=split(exportedrows[i], "\t");
if(i!=lengthOf(exportedrows)-2){
exportedcolumns[3]=i;
for(h=1; h<subcomp+1; h++){
exportedsubcompcounts[h]=exportedsubcompcounts[h]+exportedcolumns[3+subcompindexstart[h]];
}
} else {
exportedcolumns[3]=lengthOf(exportedrows)-3;
for(h=1; h<subcomp+1; h++){
exportedcolumns[3+subcompindexstart[h]]=exportedsubcompcounts[h];
}
}
exportedrows[i]=exportedcolumns[0];
for(j=1; j<lengthOf(exportedcolumns); j++){
exportedrows[i]=exportedrows[i]+"\t"+exportedcolumns[j];
}
exportedtable=exportedtable+"\n"+exportedrows[i];
}


exportedtable=exportedtable+"\n"+exportedrows[lengthOf(exportedrows)-1];
File.saveString(exportedtable, exportpath);
} else {
File.delete(exportpath);
}
}
print("Export Concluded");
}
}
//////////////////////////////////////////////////////////end of Export Gated Data/////////////////////////////////////
if((x1>1044)&&(x1<1114)&&(y1>128)&&(y1<145)){
if(recordcheck){
autocheck=autocheck+1;
if(x1array[0]<0){
x1array[0]=x1;
y1array[0]=y1;
} else {
x1array=Array.concat(x1array,x1);
y1array=Array.concat(y1array,y1);
}
  if (!isOpen("Recording")){
     run("Text Window...", "name=[Recording] width=72 height=72 menu");
     }
print("[Recording]","Pause.\n");
} 
if(execheck){
  if (!isOpen("Executing")){
     run("Text Window...", "name=[Executing] width=72 height=72 menu");
     }
print("[Executing]","Pause.\n");
}
waitForUser("Break in the Macro Execution:\nRecording: "+recordcheck+"\nExecuting: "+execheck+"\nAutocheck: "+autocheck);
}
///////////////////end Of Pause//////////////////////////////////////////
}
}
//////}
///waitForUser("Do you really want to exit?");
stayon=true;
}
waitForUser("Macro unexpectedly stopped");

/////////////////////////////////////////////////////////////////////////////////////functions///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 function setvoltage(jx, axis, voltage) {
selectImage(dotplotID);
setColor(255,255,255);
fillRect(71, 1077+40*axis, 98, 12);
fillRect(175, 1078+40*axis, 30, 12);
setColor(0,0,255);
fillRect(71, 1077+40*axis, voltage/0.1, 12);
setColor(0,0,0);
drawString(d2s(voltage,2), 175, 1090+40*axis);
}

function setoffset(jx, axis,offset) {
selectImage(dotplotID);
setColor(255,255,255);
fillRect(251, 1077+40*axis, 98, 12);
fillRect(360, 1078+40*axis, 60, 12);
setColor(0,0,255);
fillRect(251, 1077+40*axis, 50+offset/0.005, 12);
setColor(0,0,0);
drawString(d2s(offset,3), 360, 1090+40*axis);

}

function gateddotplot(jactcomp,jx, jy, voltagex, offsetx, voltagey, offsety) {
selectWindow("Dot Plot"+resultsfilepath);
sliceNow=getSliceNumber();
setColor(200, 255, 255);
fillRect(8,8, 1024, 1024);
setColor(0,0,0);
updateregionlist();
setBatchMode(true);
jxgatecheck=false;
jygatecheck=false;
subind=0;
subnumb=0;
for(ijsub=1; ijsub<jactcomp; ijsub++){
subind=subind+(5+3*analysedchannels)*subcompcounts[ijsub];
subnumb=subnumb+subcompcounts[ijsub];
}

Array.fill(activegateweights,1);
Array.fill(distancegateweights,1);
if((activegateindex!=0)||(distcutoff>0)){
//Array.show(activegateweights);
for(agind=subcomp; agind>-1; agind--){
activegatecomp=agind;
if(activegatecomp==0){
if(distcutoff>0){
for(ic=0; ic<subcomp+1; ic++){
if(dsubI==subcomparray[ic]){jdistI=ic;}
if(dsubII==subcomparray[ic]){jdistII=ic;}
if(dsubIII==subcomparray[ic]){jdistIII=ic;}
}
//waitForUser("Distance Gating");
//Array.fill(distancegateweights,0);
neighbors=0;
subindI=0;
subnumbI=0;
for(ijsub=1; ijsub<jdistI; ijsub++){
subindI=subindI+(5+3*analysedchannels)*subcompcounts[ijsub];
subnumbI=subnumbI+subcompcounts[ijsub];
}
for(ijsub=0; ijsub<subcompcounts[jdistI]; ijsub++){
distancegateweights[subcompcounts[0]+subnumbI+ijsub]=0;
}
subindII=0;
subnumbII=0;
for(ijsub=1; ijsub<jdistII; ijsub++){
subindII=subindII+(5+3*analysedchannels)*subcompcounts[ijsub];
subnumbII=subnumbII+subcompcounts[ijsub];
}
for(ijsub=0; ijsub<subcompcounts[jdistII]; ijsub++){
distancegateweights[subcompcounts[0]+subnumbII+ijsub]=0;
}
if(dsubIII!="None"){
subindIII=0;
subnumbIII=0;
for(ijsub=1; ijsub<jdistIII; ijsub++){
subindIII=subindIII+(5+3*analysedchannels)*subcompcounts[ijsub];
subnumbIII=subnumbIII+subcompcounts[ijsub];
}
for(ijsub=0; ijsub<subcompcounts[jdistIII]; ijsub++){
distancegateweights[subcompcounts[0]+subnumbIII+ijsub]=0;
}
}
jdstart=0;
jdstop=0;
idstart=0;
idstop=0;
kdstart=0;
kdstop=0;
step=0;
for(ic=0; ic<subcompcounts[0]; ic++){
distancegateweights[ic]=1;
progress=100*ic/subcompcounts[0];
if(progress>=step){
print("Calculating distance gating: "+progress+"%; identified neighboring dots: "+neighbors+"; cell: "+ic);
step=step+10;
}
idstart=idstop;
jdstart=jdstop;
kdstart=kdstop;
while((cellIndex[subnumbI+idstop]<=ic)&&(idstop+1<subcompcounts[jdistI])){
//print("Calculating distance gating: "+progress+"%; identified neighboring dots: "+neighbors+"; cell: "+ic+"; cellIndex: "+cellIndex[subnumbI+idstop]+"; idstart: "+(subnumbI+idstart)+"; idstop: "+(subnumbI+idstop)+"; jdstart: "+(subnumbII+jdstart)+"; jdstop"+(subnumbII+jdstop));
datatable[subcompcounts[0]*analysedparameters+subindI+idstop*(5+3*analysedchannels)+4]=0;
idstop=idstop+1;
}
//print("idstop="+idstop);
while((cellIndex[subnumbII+jdstop]<=ic)&&(jdstop+1<subcompcounts[jdistII])){
//print("Calculating distance gating: "+progress+"%; identified neighboring dots: "+neighbors+"; cell: "+ic+"; cellIndex: "+cellIndex[subnumbII+jdstop]+"; idstart: "+(subnumbI+idstart)+"; idstop: "+(subnumbI+idstop)+"; jdstart: "+(subnumbII+jdstart)+"; jdstop"+(subnumbII+jdstop));
datatable[subcompcounts[0]*analysedparameters+subindII+jdstop*(5+3*analysedchannels)+4]=0;
jdstop=jdstop+1;
}
if(dsubIII!="None"){
while((cellIndex[subnumbIII+kdstop]<=ic)&&(kdstop+1<subcompcounts[jdistIII])){
//print("Calculating distance gating: "+progress+"%; identified neighboring dots: "+neighbors+"; cell: "+ic+"; cellIndex: "+cellIndex[subnumbII+jdstop]+"; idstart: "+(subnumbI+idstart)+"; idstop: "+(subnumbI+idstop)+"; jdstart: "+(subnumbII+jdstart)+"; jdstop"+(subnumbII+jdstop));
datatable[subcompcounts[0]*analysedparameters+subindIII+kdstop*(5+3*analysedchannels)+4]=0;
kdstop=kdstop+1;
}
}
for(id=idstart; id<=idstop; id++){
if(activegateweights[subcompcounts[0]+subnumbI+id]!=0){
neighbors=0;
xmi=datatable[subcompcounts[0]*analysedparameters+subindI+id*(5+3*analysedchannels)+1];
ymi=datatable[subcompcounts[0]*analysedparameters+subindI+id*(5+3*analysedchannels)+2];
for(jd=jdstart; jd<=jdstop; jd++){
if(activegateweights[subcompcounts[0]+subnumbII+jd]!=0){
xmj=datatable[subcompcounts[0]*analysedparameters+subindII+jd*(5+3*analysedchannels)+1];
ymj=datatable[subcompcounts[0]*analysedparameters+subindII+jd*(5+3*analysedchannels)+2];
if(((ymi-ymj)*(ymi-ymj))/(distcutoff*distcutoff)<1){
if(((xmi-xmj)*(xmi-xmj))/(distcutoff*distcutoff)<1){
distij=(xmi-xmj)*(xmi-xmj)+(ymi-ymj)*(ymi-ymj);
if(floor(distij/(distcutoff*distcutoff))==0){
print("Count in distance "+distcutoff+" pixels: "+(neighbors+1));
if(dsubIII!="None"){
for(kd=kdstart; kd<=kdstop; kd++){
if(activegateweights[subcompcounts[0]+subnumbIII+kd]!=0){
xmk=datatable[subcompcounts[0]*analysedparameters+subindIII+kd*(5+3*analysedchannels)+1];
ymk=datatable[subcompcounts[0]*analysedparameters+subindIII+kd*(5+3*analysedchannels)+2];
if(((ymi-ymk)*(ymi-ymk)/(distcutoff*distcutoff)<1)&&((ymj-ymk)*(ymj-ymk)/(distcutoff*distcutoff)<1)){
if(((xmi-xmk)*(xmi-xmk)/(distcutoff*distcutoff)<1)&&((xmj-xmk)*(xmj-xmk)/(distcutoff*distcutoff)<1)){
distik=(xmi-xmk)*(xmi-xmk)+(ymi-ymk)*(ymi-ymk);
distkj=(xmk-xmj)*(xmk-xmj)+(ymk-ymj)*(ymk-ymj);
if((floor(distik/(distcutoff*distcutoff))==0)&&(floor(distkj/(distcutoff*distcutoff))==0)){
//print("Triple Event: "+distik+", "+distkj+"; Neighbors: "+neighbors);
distancegateweights[subcompcounts[0]+subnumbI+id]=1;
distancegateweights[subcompcounts[0]+subnumbII+jd]=1;
distancegateweights[subcompcounts[0]+subnumbIII+kd]=1;
neighbors=neighbors+1;
datatable[subcompcounts[0]*analysedparameters+subindI+id*(5+3*analysedchannels)+4]=datatable[subcompcounts[0]*analysedparameters+subindI+id*(5+3*analysedchannels)+4]+1;
datatable[subcompcounts[0]*analysedparameters+subindII+jd*(5+3*analysedchannels)+4]=datatable[subcompcounts[0]*analysedparameters+subindII+jd*(5+3*analysedchannels)+4]+1;
datatable[subcompcounts[0]*analysedparameters+subindIII+kd*(5+3*analysedchannels)+4]=datatable[subcompcounts[0]*analysedparameters+subindIII+kd*(5+3*analysedchannels)+4]+1;
}
}
} else {
if((ymk>ymi+distcutoff)||(ymk>ymj+distcutoff)){
//print("Tri-Spot "+id+" stopped after "+kd+" steps; Distance > "+(maxOf((ymk-ymj)*(ymk-ymj)/(distcutoff*distcutoff),(ymk-ymi)*(ymk-ymi)/(distcutoff*distcutoff)));
kd=kdstop;
} else {
if((ymk<ymi-distcutoff)||(ymk<ymj-distcutoff)){
//print("Tri-Spot "+id+" stopped after "+kd+" steps; Distance > "+(maxOf((ymk-ymj)*(ymk-ymj)/(distcutoff*distcutoff),(ymk-ymi)*(ymk-ymi)/(distcutoff*distcutoff)));
//kdstart=kd;
} 
}
}
}
}
} else {
distancegateweights[subcompcounts[0]+subnumbI+id]=1;
distancegateweights[subcompcounts[0]+subnumbII+jd]=1;
neighbors=neighbors+1;
datatable[subcompcounts[0]*analysedparameters+subindI+id*(5+3*analysedchannels)+4]=datatable[subcompcounts[0]*analysedparameters+subindI+id*(5+3*analysedchannels)+4]+1;
datatable[subcompcounts[0]*analysedparameters+subindII+jd*(5+3*analysedchannels)+4]=datatable[subcompcounts[0]*analysedparameters+subindII+jd*(5+3*analysedchannels)+4]+1;
}
}
}
} else {
if(ymj>ymi+distcutoff){
//print("Two-Spot "+id+" stopped after "+jd+" steps; Distance > "+((ymi-ymj)*(ymi-ymj))/(distcutoff*distcutoff));
jd=jdstop;
} else {
if(ymj<ymi-distcutoff){
jdstart=jd;
}
}
}
}
}
print("Spot "+id+"; Neighbors: "+neighbors);
}
}
//waitForUser("id cycle");
}
}
//updateStats();
}

if(activegate[2*activegatecomp]!="None"){
print("ActiveGateComp: "+activegatecomp);
openregionlist="Begin";
isu=0;
i=0;
g="\n";
start=-1;
newImage("Mask", "8-bit black", 1038, 1038,1);
openregionlist=openregionlist+"\n"+getImageID();
hist=newArray(1024);
lista=split(regionlist, "\n");
while(indexOf(activegate[2*activegatecomp], "r", start+1)>=0){
start=indexOf(activegate[2*activegatecomp], "r", start+1);
region=substring(activegate[2*activegatecomp], start-3, start+3);
//print("Region: "+region);
regionID=substring(region,0,6);
if(startsWith(substring(activegate[2*activegatecomp], maxOf(0,start-4), start+3), "!")){
invertregion=true;
} else {
invertregion=false;
}
newImage(region, "8-bit black", subcompcounts[activegatecomp], 1,1);
openregionlist=openregionlist+"\n"+getImageID();
selectWindow("Mask");
run("Select All");
setColor(0);
fill();
for(jroi=0; jroi<roiManager("count"); jroi++){
if(regionID==call("ij.plugin.frame.RoiManager.getName", jroi)){
roiManager("select", jroi);
setColor(255);
fill();
}
}
if(invertregion){
run("Select All");
run("Invert");
}
nreg=0;
nfill=0;

regionIDcheck=true;
jroi=0;
while(regionIDcheck){
parameters=split(lista[jroi], "\t");
if(parameters[0]==regionID){regionIDcheck=false;}
jroi=jroi+1;
}
jactcomproi=parseInt(substring(parameters[0],0,2));
jxroi=parseInt(parameters[1]);
jyroi=parseInt(parameters[4]);
voltagexroi=parseFloat(parameters[2]);
voltageyroi=parseFloat(parameters[5]);
offsetxroi=0;
offsetyroi=0;
minimumxroi=parseFloat(parameters[3]);
minimumyroi=parseFloat(parameters[6]);
scalexroi=(parseFloat(parameters[7])-minimumxroi)/(voltagexroi*1);
scaleyroi=(parseFloat(parameters[8])-minimumyroi)/(voltageyroi*1);
//scalex=(maximum[jx]-minimum[jx])/(voltagex*1);
//scaley=(maximum[jy]-minimum[jy])/(voltagey*1);
subindroi=0;
subnumbroi=0;
for(ijsub=1; ijsub<jactcomproi; ijsub++){
subindroi=subindroi+(5+3*analysedchannels)*subcompcounts[ijsub];
subnumbroi=subnumbroi+subcompcounts[ijsub];
}
for(i=0; i<subcompcounts[jactcomproi]; i++){
if(jactcomproi==0){
indicexroi=jxroi+analysedparameters*i;
indiceyroi=jyroi+analysedparameters*i;
indicecellroi=i;
} else {
indicexroi=subcompcounts[0]*analysedparameters+subindroi+i*(5+3*analysedchannels)+(jxroi-subcompindexstart[jactcomproi]);
indiceyroi=subcompcounts[0]*analysedparameters+subindroi+i*(5+3*analysedchannels)+(jyroi-subcompindexstart[jactcomproi]);
indicecellroi=cellIndex[subnumbroi+i];
}
selectWindow("Mask");
if(jyroi==0){
weight=getPixel(8+floor(minOf(offsetxroi+maxOf((datatable[indicexroi]-minimumxroi),0)/scalexroi, 1)*1023), 8+(0.5*1023))/255;
} else {
weight=getPixel(8+floor(minOf(offsetxroi+maxOf((datatable[indicexroi]-minimumxroi),0)/scalexroi, 1)*1023), 8+floor((1-minOf(offsetyroi+maxOf((datatable[indiceyroi]-minimumyroi),0)/scaleyroi, 1))*1023))/255;
}
nreg=nreg+weight;
selectWindow(region);
setColor(255*weight);
fillRect(i,0,1,1);
//print("weight["+i+"]: "+weight);
}
}

invertgate="0"+"\t";
expression=activegate[2*activegatecomp];
while(lastIndexOf(expression, "(")>=0){
start=lastIndexOf(expression, "(");
if(startsWith(substring(expression, maxOf(0,start-1), indexOf(expression, ")", start)), "!")){
expression=substring(expression,0,start-1)+substring(expression,start,lengthOf(expression));
invertgate=invertgate+"1"+"\t";
} else {
invertgate=invertgate+"0"+"\t";
}
g=g+substring(expression, lastIndexOf(expression, "(")+1, indexOf(expression, ")", lastIndexOf(expression, "(")))+"\n";
end=indexOf(expression, ")", lastIndexOf(expression, "("));
j=substring(expression,indexOf(expression, ")", lastIndexOf(expression, "("))+1,lengthOf(expression));
expression=substring(expression, 0,lastIndexOf(expression, "("))+"g"+isu+j;
isu=isu+1;
}
invertgate=invertgate+"0"+"\t";
g=g+expression;
result=expression;
expr=split(g, "\n");
invgateindex=split(invertgate, "\t");

for(j=1; j<expr.length; j++){
plus=split(expr[j], "OR");
for(k=0; k<plus.length; k++){
//print(plus[k]);
per=split(plus[k], "AND");
if(per.length>1){
result=per[0]+"AND";
selectWindow(per[0]);
run("Duplicate...", result);
rename(result);
//selectWindow(result);
openregionlist=openregionlist+"\n"+getImageID();
for(s=1; s<per.length; s++){
imageCalculator("AND", result,per[s]);
result=result+per[s]+"AND";
rename(result);
}
rename(plus[k]);
}

}
result=expr[j];
if(plus.length>1){
result=plus[0]+"OR";
selectWindow(plus[0]);
run("Duplicate...", result);
rename(result);
openregionlist=openregionlist+"\n"+getImageID();
for(s=1; s<plus.length; s++){
imageCalculator("OR", result,plus[s]);
result=result+plus[s]+"OR";
rename(result);
}


}
selectWindow(result);
rename("g"+(j-1));
if(invgateindex[j]=="1"){
run("Invert");
}
if(j==expr.length-1){
selectWindow("Mask");
setColor(255);
fillRect(8,8,1024,1024);
run("Select None");
if(jy==0){
listpictsize=1024;
} else {
listpictsize=1024*1024;
}
listpict=newArray(listpictsize);
for (lpi=0; lpi<listpictsize; lpi++){
listpict[lpi]="*";
}

selectImage("g"+(j-1));
if((activegatecomp!=0)&&(jactcomp!=activegatecomp)){
print("recalculating activegateweights for cells; jactcomp: "+jactcomp+"; agind: "+agind+"; subcompindexstart[agind]: "+subcompindexstart[agind]);
subindactgatecomp=0;
subnumbactgatecomp=0;
for(ijsub=1; ijsub<activegatecomp; ijsub++){
subindactgatecomp=subindactgatecomp+(5+3*analysedchannels)*subcompcounts[ijsub];
subnumbactgatecomp=subnumbactgatecomp+subcompcounts[ijsub];
}
end=0;
for(i=0; i<subcompcounts[0];i++){
numerospot=0;
compgate=0;
if(!(end<subcompcounts[activegatecomp])){
condition=false;
} else {
condition=(cellIndex[subnumbactgatecomp+end]==i);
}
while(condition){
if(activegate[2*activegatecomp+1]!=0){
compgate=maxOf(compgate,getPixel(end,0)/255);
/////////////////////maxOf returns a OR logic choice: if at least one spot is counted cell is maintained (use minOf to simulate AND logic)////////////////////////////////////////////////////////////////////////////////////////////////
}
activegateweights[subcompcounts[0]+subnumbactgatecomp+end]=getPixel(end,0)/255;
//print(i+" case=-1 activegateweights["+subcompcounts[0]+subnumbactgatecomp+end+"]="+activegateweights[subcompcounts[0]+subnumbactgatecomp+end]);
numerospot=numerospot+getPixel(end,0)/255;
end=end+1;
if(!(end<subcompcounts[activegatecomp])){
condition=false;
} else {
condition=(cellIndex[subnumbactgatecomp+end]==i);
}
}
if(activegate[2*activegatecomp+1]!=0){
activegateweights[i]=activegateweights[i]*compgate;
}




}
}                                                   

for(i=0; i<subcompcounts[jactcomp]; i++){
if(jactcomp==0){
indicecell=i;
} else {
indicecell=cellIndex[subnumb+i];
}
selectImage("g"+(j-1));
if(jactcomp==activegatecomp){
activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+i+subnumb]=activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+i+subnumb]*getPixel(i,0)/255;
//print(i+" case=0 activegateweights["+subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+i+subnumb+"]="+activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+i+subnumb]);
} else {
if((activegatecomp==0)){
activegateweights[subcompcounts[0]+subnumb+i]=activegateweights[subcompcounts[0]+subnumb+i]*getPixel(indicecell,0)/255;
//print(i+" case=1 activegateweights["+subcompcounts[0]+subnumb+i+"]="+activegateweights[subcompcounts[0]+subnumb+i]);
} else {
activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i]=activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i]*activegateweights[indicecell];
//print(i+" case=2 activegateweights["+subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i+"]="+activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+subnumb+i]);
}
}
}

}
}
if(isOpen("g"+(j-1))){
selectImage("g"+(j-1));
close();
}
regionlistindex=split(openregionlist, "\n");
for(js=1; js<regionlistindex.length; js++){
selectImage(parseInt(regionlistindex[js]));
close();
}
}
}
}
updateStats();
scalingx=(maximum[jx]-minimum[jx])/(voltagex*1);
scalingy=(maximum[jy]-minimum[jy])/(voltagey*1);
jycheck=false;
for(ij=0; ij<subcomp+1; ij++){
if(jy==subcompindexstart[ij]){
jycheck=true;
if(isOpen("Results")){
selectWindow("Results");
run("Close");
}
}
}
if(isOpen("PlottingPSF")){
selectImage("PlottingPSF");
close();
}
if(!isOpen("PSF")){
run("Gaussian PSF 3D", "width="+(2*meanfilterDP+1)+" height="+(2*meanfilterDP+1)+" number=1 dc-level=1 horizontal=1 vertical=1 depth=1");
}
//setBatchMode("show");
//waitForUser("Check");
newImage("Plotting", "8-bit White", 1024, 1024, 1);
plottingID=getImageID();
run("Duplicate...", "title=OverlayDP");
newImage("PlottingPSF", "32-bit Black", 1024, 1024, 1);
selectImage(plottingID);
//setColor(0,0,0);
if(jycheck){
listpictsize=1024;
} else {
listpictsize=1024*1024;
}
listpict=newArray(listpictsize);
for (lpi=0; lpi<listpictsize; lpi++){
listpict[lpi]="*";
}
if(jycheck){
h=newArray(1024);
Array.fill(h,0);
} else {
h=newArray(1024*1024);
Array.fill(h,0);
}
iperc=0;
for(i=0; i<subcompcounts[jactcomp]; i++){
if(i>=0.1*iperc*subcompcounts[jactcomp]){
print(10*iperc+"% elapsed - "+i+" out of "+subcompcounts[jactcomp]+" events loaded");
iperc=iperc+1;
if(jx==7){
//print("File Index Column: "+datatable[jx+analysedparameters*i]);
}
}
end=0;
if(jactcomp==0){
indicex=jx+analysedparameters*i;
indicey=jy+analysedparameters*i;
indicecell=i;
} else {
indicex=subcompcounts[0]*analysedparameters+subind+i*(5+3*analysedchannels)+(jx-subcompindexstart[jactcomp]);
indicey=subcompcounts[0]*analysedparameters+subind+i*(5+3*analysedchannels)+(jy-subcompindexstart[jactcomp]);
//indicecell=cellIndex[subnumb+i];
indicecell=subnumb+i;
}

datax=datatable[indicex];
datay=datatable[indicey];
//print("datax: "+datax+"; datay: "+datay);
if(activerenorm){
if(jx==jrenorm){
//datax=renormvalue*renormweights[i]*datax;
}
} 
if(jycheck){
h[floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023)]= h[floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023)]+activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+i+subnumb]*distancegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+i+subnumb];
index=floor((minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1))*1023);
//fillRect(floor(minOf(offsetx+datax/scalingx, 1)*511), floor((1-minOf(10*h[index]/scalingy, 1))*511), 1, 1+floor(minOf(10*h[index]/scalingy, 1)*511));
if(activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+i+subnumb]*distancegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+i+subnumb]){
listpict[floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023)]=listpict[floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023)]+":"+d2s(indicecell,0);
rowRes=nResults;
setResult("Cell Index",rowRes, indicecell);
if(jactcomp==0){setResult("File Index",rowRes, fileIndex[indicecell]);} else {setResult("File Index",rowRes, fileIndex[cellIndex[indicecell]]); }
setResult("DATA", rowRes, floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023));
setResult("Raw Data", rowRes, datax);
}
} else {
h[floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023)+1024*floor((1-minOf(offsety+maxOf(0,(datay-minimum[jy]))/scalingy, 1))*1023)]=h[floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023)+1024*floor((1-minOf(offsety+maxOf(0,(datay-minimum[jy]))/scalingy, 1))*1023)]+activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+i+subnumb]*distancegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+i+subnumb];
selectImage(plottingID);
if(activegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+i+subnumb]*distancegateweights[subcompcounts[0]*(1-isNaN(jactcomp/jactcomp))+i+subnumb]){
setPixel(floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023),floor((1-minOf(offsety+maxOf(0,(datay-minimum[jy]))/scalingy, 1))*1023),minOf(254,h[floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023)+1024*floor((1-minOf(offsety+maxOf(0,(datay-minimum[jy]))/scalingy, 1))*1023)]));
selectImage("PSF");
run("Copy");
selectImage("PlottingPSF");
makeRectangle(floor(minOf(offset[jx]+maxOf((datatable[indicex]-minimum[jx]),0)/scalingx, 1)*1023)-meanfilterDP, floor((1-minOf(offset[jy]+maxOf((datatable[indicey]-minimum[jy]),0)/scalingy, 1))*1023)-meanfilterDP,2*meanfilterDP+1,2*meanfilterDP+1);
setPasteMode("Add");
run("Paste");
//run("Select None");
//setColor(255);
//fillRect(floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023)-meanfilterDP,floor((1-minOf(offsety+maxOf(0,(datay-minimum[jy]))/scalingy, 1))*1023)-meanfilterDP, 2*meanfilterDP, 2*meanfilterDP);
//setPasteMode("Add");
//run("Paste");
//print("X: "+floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023)-meanfilterDP+"; Y: "+floor((1-minOf(offsety+maxOf(0,(datay-minimum[jy]))/scalingy, 1))*1023)-meanfilterDP);
selectImage(plottingID);
//////////Creation of Data-Crosses for images retrieval///////
selectImage("OverlayDP");
for(jr=-2; jr<3; jr++){
if(jr!=0){
setPixel(floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023)+jr,floor((1-minOf(offsety+maxOf(0,(datay-minimum[jy]))/scalingy, 1))*1023),1);
}
}
for(jc=-2; jc<3; jc++){
if(jc!=0){
setPixel(floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023),floor((1-minOf(offsety+maxOf(0,(datay-minimum[jy]))/scalingy, 1))*1023)+jc,1);
}
}
///////////////////end of Crosses Overlay//////////////
listpict[floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023)+1024*floor((1-minOf(offsety+maxOf(0,(datay-minimum[jy]))/scalingy, 1))*1023)]=listpict[floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023)+1024*floor((1-minOf(offsety+maxOf(0,(datay-minimum[jy]))/scalingy, 1))*1023)]+":"+d2s(indicecell,0);
}
}
}
if(jycheck){
smooth=newArray(1024);
for(index=0; index<1024; index++){
for(s=maxOf(0,index-smoothfactor); s<minOf(index+smoothfactor+1,1024); s++){
smooth[index]=smooth[index]+h[s];
}
smooth[index]=smooth[index]/(2*smoothfactor+1);
//smooth[index]=h[index];
}
Array.getStatistics(smooth, hmin, hmax, hmean, hstDev);
print("histogram stats.\n Min: "+hmin+"; Max: "+hmax+"; Mean: "+hmean+"; StDev: "+hstDev);
automaximum[jy]=hmax;
if((checkautomax[jy]==0)||(manualmaximum[jy]==0)){
maximum[jy]=hmax;
}
scalingy=(maximum[jy]-minimum[jy])/(voltagey*1);
for(i=0; i<subcompcounts[jactcomp]; i++){
end=0;
if(jactcomp==0){
indicex=jx+analysedparameters*i;
indicey=jy+analysedparameters*i;
indicecell=i;
} else {
indicex=subcompcounts[0]*analysedparameters+subind+i*(5+3*analysedchannels)+(jx-subcompindexstart[jactcomp]);
indicey=subcompcounts[0]*analysedparameters+subind+i*(5+3*analysedchannels)+(jy-subcompindexstart[jactcomp]);
//indicecell=cellIndex[subnumb+i];
indicecell=subnumb+i;
}

datax=datatable[indicex];
setColor(0);
index=floor((minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1))*1023);
//setPixel(floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023), floor((1-minOf(1*smooth[index]/scalingy, 1))*1023),0);
fillRect(floor(minOf(offsetx+maxOf(0,(datax-minimum[jx]))/scalingx, 1)*1023), floor((1-minOf(1*smooth[index]/scalingy, 1))*1023), 1, floor(minOf(10*smooth[index]/scalingy, 1)*1023));
}
}
if(isOpen("PSF")){
selectImage("PSF");
run("Close");
}

selectImage(plottingID);
Array.getStatistics(h, minDP, maxDP);
print("maxDP: "+maxDP);
if(!jycheck){
selectImage("OverlayDP");
setMinAndMax(1, minOf(255,maxDP+1));
run("RGB Color");
changeValues(0,0,0xff0000);
if(meanfilterDP>0){
selectImage(plottingID);
run("brgbcmyw_mod");
run("Mean...", "radius="+meanfilterDP);
run("Invert");
changeValues(0,0,255);
//setBatchMode("show");
//waitForUser("Check");
run("RGB Color");
selectImage("PlottingPSF");
run("Select All");
//run("Blue");
//run("Invert");
setBatchMode("show");
//waitForUser("Check");
//changeValues(0,0,255);
selectImage(plottingID);
} else {
run("brgbcmyw_mod");
setMinAndMax(minDP+1, minOf(255,maxDP+1));
}    
//run("RGB Color");
}
selectImage(plottingID);
run("Copy");
close();
//Array.show(activegateweights);
selectWindow("Dot Plot"+resultsfilepath);
print("Current Slice: "+getSliceNumber());
setPasteMode("Copy");
setSlice(sliceNow);
makeRectangle(8,8,1024,1024);
run("Paste");
run("Add Image...", "image=[OverlayDP] x=8 y=8 opacity=100 zero");
run("Hide Overlay");
setColor(0,0,0);
drawRect(7,7,1026,1026);
run("Select None");
setColor(255, 255, 255);
fillRect(1028, 1076, 120, 14);
setColor(0,0,0);
//drawString("None", 1051, 1090);
setColor(255,255,255);
fillRect(1048, 814, 72, 20);
setColor(128*checkautomin[jx],128*checkautomin[jx],128*checkautomin[jx]);
drawString(d2s(autominimum[jx],0), 1048,834);
setColor(255,255,255);
fillRect(1048, 874, 798,20);
setColor(128*(1-checkautomin[jx]),128*(1-checkautomin[jx]),128*(1-checkautomin[jx]));
drawString(d2s(manualminimum[jx],0), 1048, 894);
setColor(255,255,255);
fillRect(1048,954, 148,20);
setColor(128*checkautomin[jy],128*checkautomin[jy],128*checkautomin[jy]);
drawString(d2s(autominimum[jy],0), 1048,974);
setColor(255,255,255);
fillRect(1048,1014, 148,20);
setColor(128*(1-checkautomin[jy]),128*(1-checkautomin[jy]),128*(1-checkautomin[jy]));
drawString(d2s(manualminimum[jy],0), 1048, 1034);
setColor(255,255,255);
fillRect(1125, 814, 72, 20);
setColor(128*checkautomax[jx],128*checkautomax[jx],128*checkautomax[jx]);
drawString(d2s(automaximum[jx],0), 1125,834);
setColor(255,255,255);
fillRect(1125, 874, 798,20);
setColor(128*(1-checkautomax[jx]),128*(1-checkautomax[jx]),128*(1-checkautomax[jx]));
drawString(d2s(manualmaximum[jx],0), 1125, 894);
setColor(255,255,255);
fillRect(1125,954, 148,20);
setColor(128*checkautomax[jy],128*checkautomax[jy],128*checkautomax[jy]);
drawString(d2s(automaximum[jy],0), 1125,974);
setColor(255,255,255);
fillRect(1125,1014, 148,20);
setColor(128*(1-checkautomax[jy]),128*(1-checkautomax[jy]),128*(1-checkautomax[jy]));
drawString(d2s(manualmaximum[jy],0), 1125, 1034);
setBatchMode(false);
updateDisplay();
if(jycheck){
if(isOpen("DNA Hist")){
selectWindow("DNA Hist");
run("Close");
}
Plot.create("DNA Hist", "Channel", "Counts",smooth);
Plot.show();
updateResults();
}

selectWindow("Dot Plot"+resultsfilepath);
setColor(255, 255, 255);
fillRect(400, 1076, 800, 200);
setColor(0,0,0);
for(jtext=0; jtext<subcomp+1; jtext++){
setColor(0,0,0);
drawString(activegate[2*jtext], minOf(1048,1190-getStringWidth(activegate[2*jactcomp])), 1090+20*jtext);
}


}

////////////////////////////////////////////////////////////////////////////////////end of function gateddotplot////////////////////////////////////////////////////////////////////
function dataloading(resultsfilepath, firsttime) {
mycheck=true;
//mycheck=false;
//////////////mycheck: logic condition to bypass Dialogs creation. Default parameters are employed instead/////////////
setBatchMode(true);
checkMaxspot=false;
compcheck=true;
while(compcheck){
//resultsfilepath=File.openDialog("Select a File");
//dir=File.getParent(resultsfilepath);
resultsfilename=substring(resultsfilepath,lastIndexOf(resultsfilepath, File.separator)+1, lengthOf(resultsfilepath));
compcheck=false;
resultsarray=split(File.openAsString(resultsfilepath),"\n");
for(i=0; i<resultsarray.length; i++){
if(startsWith(resultsarray[i], "*")){
counts=i;
}
}
resultsarray[0]=replace(resultsarray[0],"\\[\\t","\\[");
resultsarray[0]=replace(resultsarray[0], "segm\\t","segm");
resultsarray[0]=replace(resultsarray[0],"\\(\\t","\\(");
checkfileparam=split(resultsarray[0],"\t");
//Array.show(checkfileparam);
//waitForUser("check if spaces have been removed");
print(resultsarray[counts]);
analysedparameterssum=split(resultsarray[counts], "\t");
if(!firsttime){

selectImage(dotplotID);
rename("Dot Plot"+resultsfilepath);
igc=0;
for(igc=0; igc<5; igc++){
call("java.lang.System.gc");
wait(10);
}
}
}
//////////resultsarray is the results database: each element is a row referred to the single cell//////////


projmethods=newArray("Max Intensity", "Sum Slices", "Average Intensity", "Standard Deviation", "Min Intensity", "Median");
if(indexOf(resultsarray[0],"Whole")<0){
checkwholecell=0;
} else {
checkwholecell=1;
}
analysedparameterslisttemp=split(resultsarray[0],"\t");
subcomp=parseInt(substring(analysedparameterslisttemp[lengthOf(analysedparameterslisttemp)-1],0,indexOf(analysedparameterslisttemp[lengthOf(analysedparameterslisttemp)-1],":")));
analysedchannels=(lengthOf(analysedparameterslisttemp)-3-5-2*2*checkwholecell-9*subcomp)/(3*(1+2*checkwholecell+2*subcomp));
if(mycheck){
Dialog.create("New Array");
Dialog.addNumber("# of  Channels: ", analysedchannels);
Dialog.addNumber("# of SubCompartments: ", subcomp);
Dialog.addNumber("Dot Plot Mean-Filter Radius", meanfilterDP);
//Dialog.addCheckbox("MeanSpot/MeanCell Calculation (if not StdDevSpot was reported)", checkMaxspot);
//Dialog.addCheckbox("Whole Cell analysis", checkwholecell);
//Dialog.addCheckbox("Multichannel data", multichannelcheck);
//Dialog.addNumber("# of Z slices (Leica MSA structure applied): ", stackslices);
//Dialog.addChoice("Projection Method (for stacks only): ", projmethods, projmeth);
Dialog.show();
MSAchannels=Dialog.getNumber();
//analysedchannels=MSAchannels;
subcomp=Dialog.getNumber();
meanfilterDP=Dialog.getNumber();
//checkMaxspot=Dialog.getCheckbox();
//checkwholecell=Dialog.getCheckbox();
//multichannelcheck=Dialog.getCheckbox();
//stackslices=Dialog.getNumber();
//projmeth=Dialog.getChoice();
}
imagespath=substring(resultsarray[counts+1],0,lastIndexOf(resultsarray[counts+1],File.separator));
imagesdir=imagespath+File.separator;



//if(checkMaxspot){
//analysedparameterslisttemp=split(replace(resultsarray[0], "MaxSpot", "CellMeanRatioSpot"),"\t");
//analysedparameterslisttemp=split(replace(resultsarray[0], "StdDevSpot", "CellMeanRatioSpot"),"\t");
//} 
analysedparameterslisttemp=split(resultsarray[0],"\t");
if(confdata){

} else {
total=0; 
while(total==0){
imageslist=getFileList(imagesdir);
total = imageslist.length;
if(total==0){
imagesdir=getDirectory("Set the images directory (the one named experiment-- if MSA data are used)");
}
}
Array.sort(imageslist);
nd2check=indexOf(imageslist[0],".nd2");
print("Images Length: "+ total+"\n Images Dir: "+imagesdir+"\n nd2 File: "+nd2check);
}
//////////////////////inserting channels labeling////////////
id=imagesdir+imageslist[0];
chprefix=newArray(analysedchannels);
lengthf=File.length(id);
print("Dimension: "+d2s(lengthf/pow(1024, 2), 2)+" MB");
/////////new////// read parameters from xml/////////////////
run("Bio-Formats Macro Extensions");
print("Checking Image Acquisition Parameters...please be patient");
tstart=getTime();
run("Bio-Formats", "open=["+id+"] autoscale color_mode=Default display_metadata rois_import=[ROI manager] view=[Metadata only] stack_order=Default");
//run("Bio-Formats", "open=["+id+"] autoscale color_mode=Default rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order=XYCZT");
tstop=getTime();
print(d2s((tstop-tstart)/1000,0)+" seconds elapsed");
selectWindow("Original Metadata - "+imageslist[0]);
xmlstring=getInfo("window.contents");
bitdepth=parseInt(substring(xmlstring,indexOf(xmlstring,"BitsPerPixel")+lengthOf("BitsPerPixel"),indexOf(xmlstring, "\n", indexOf(xmlstring,"BitsPerPixel"))));
channels=parseInt(substring(xmlstring,indexOf(xmlstring,"SizeC")+lengthOf("SizeC"),indexOf(xmlstring, "\n", indexOf(xmlstring,"SizeC"))));
imagewidth=parseInt(substring(xmlstring,indexOf(xmlstring,"SizeX")+lengthOf("SizeX"),indexOf(xmlstring, "\n", indexOf(xmlstring,"SizeX"))));
//imagewidth=getWidth();
imageheight=parseInt(substring(xmlstring,indexOf(xmlstring,"SizeY")+lengthOf("SizeY"),indexOf(xmlstring, "\n", indexOf(xmlstring,"SizeY"))));
//imageheight=getHeight();
sizeZ=parseInt(substring(xmlstring,indexOf(xmlstring,"SizeZ")+lengthOf("SizeZ"),indexOf(xmlstring, "\n", indexOf(xmlstring,"SizeZ"))));
//selectImage("ForInfo");
//stackOrder="XYZCT";
stackOrder="Default";
specify="c_";
///////////multiplane files are considered multichannels; equivalent to modify stack order by swapping c and z dimension////////
if((sizeZ>1)&&(channels==1)){
channels=sizeZ;
sizeZ=1;
stackOrder="XYCZT";
specify="z_";
}
if(channels>1){
multichannelcheck=1;
} else {
multichannelcheck=0;
}
if(multichannelcheck>0){
canali=newArray(channels);
canalixml=newArray(channels);
if(indexOf(xmlstring, "Name #1")>-1){
for(i=0; i<channels; i++){
canali[i]=substring(xmlstring,indexOf(xmlstring,"\nName #"+d2s(i+2,0))+lengthOf("\nName #"+d2s(i+2,0)),indexOf(xmlstring, "\n", indexOf(xmlstring,"\nName #"+d2s(i+2,0))+1));
}
} else {
for(i=0; i<channels; i++){
canali[i]=substring(analysedparameterslisttemp[3+5+3*i], indexOf(analysedparameterslisttemp[3+5+3*i],"[")+1,indexOf(analysedparameterslisttemp[3+5+3*i],"]"));
//canali[i]="Channel"+d2s(i,0);
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
////Array.show(canali);
}
}
} 
if(multichannelcheck==0) {
if(nd2check<0){
firstch=substring(imageslist[0], lastIndexOf(imageslist[0], "-"), indexOf(imageslist[0], ".tif"));
} else {
firstch=substring(imageslist[0], lastIndexOf(imageslist[0], "_"), indexOf(imageslist[0], ".nd2"));
}
for (ch=1; ch<total; ch++){
if(indexOf(imageslist[ch],firstch)<0){
channels=channels+1;
} else {
ch=total;
}
}
canali=newArray(channels);
for (ch=0; ch<channels; ch++){
if(nd2check<0){
canali[ch]=substring(imageslist[ch], lastIndexOf(imageslist[ch], "-")+1, indexOf(imageslist[ch], ".tif"));
} else {
canali[ch]=substring(imageslist[ch], lastIndexOf(imageslist[ch], "_")+1, indexOf(imageslist[ch], ".nd2"));
}
}
}
if(isOpen("Original Metadata - "+imageslist[0])){
selectWindow("Original Metadata - "+imageslist[0]);
run("Close");
}
if(multichannelcheck<1){
positions=total/channels;
} else {
positions=total;
}
////Array.show(canali);
///////////end of new procedure for channel labelling//////////////////


for(chl=0; chl<analysedchannels; chl++){
if(multichannelcheck<1){
if(nd2check<0){
chprefix[chl]=substring(imageslist[chl], lastIndexOf(imageslist[chl], "-")+1, indexOf(imageslist[chl], ".tif"));
} else {
chprefix[chl]=substring(imageslist[chl], lastIndexOf(imageslist[chl], "_")+1, indexOf(imageslist[chl], ".nd2"));
}
} else {
chprefix[chl]=canali[chl];
}
if(chl==0){
label="1="+chprefix[0];
} else {
label=label+" "+d2s(chl+1,0)+"\="+chprefix[chl];
}
}



////////////////////////////end of channel labeling////////////////
if(firsttime){
fullanalysedparameters=analysedparameterslisttemp.length-3;
analysedparameters=5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+subcomp*(4+3*analysedchannels);
print("Analysed parameters: "+analysedparameters);
analysedparameterslist=newArray(analysedparameterslisttemp.length-3);
subcompindexstart=newArray(subcomp+1);
subcompindexend=newArray(subcomp+1);
subcomparray=newArray(subcomp+1);
subcompfluo=newArray(subcomp+1);
subcompcounts=newArray(subcomp+1);
Array.fill(subcompindexstart,0);
Array.fill(subcompindexend,analysedparameterslisttemp.length-3);
subcomparray[0]="0: Cell";
jsub=0;
for(il=0; il<analysedparameterslisttemp.length-3; il++){
analysedparameterslist[il]=analysedparameterslisttemp[il+3];
if(subcomp>0){
if(startsWith(analysedparameterslist[il], " "+d2s(jsub+1,0))||startsWith(analysedparameterslist[il], d2s(jsub+1,0))){
//waitForUser(analysedparameterslist[il]);
subcompindexstart[jsub+1]=il;
subcompindexend[jsub]=il;
if(startsWith(analysedparameterslist[il], " "+d2s(jsub+1,0))){
subcomparray[jsub+1]=substring(analysedparameterslist[il], 1, indexOf(analysedparameterslist[il],"_"));
}
if(startsWith(analysedparameterslist[il], d2s(jsub+1,0))){
subcomparray[jsub+1]=substring(analysedparameterslist[il], 0, indexOf(analysedparameterslist[il],"_"));
}
for(ch=0; ch<analysedchannels; ch++){
if(substring(subcomparray[jsub+1], indexOf(subcomparray[jsub+1],"(")+1,indexOf(subcomparray[jsub+1], ")"))==substring(analysedparameterslist[5+3*ch],indexOf(analysedparameterslist[5+3*ch],"[")+1,indexOf(analysedparameterslist[5+3*ch],"]"))){
subcompfluo[jsub+1]=ch;
}
}
//print("- "+il+" "+subcompindexstart[jsub]+" "+subcomparray[jsub+1]+" "+subcompcounts[jsub]);
jsub=jsub+1;
}
}
}
Array.show(subcompindexstart, subcompindexend);
dsubI="None";
dsubII="None";
dsubIII="None";
activegate=newArray(2*(subcomp+1));
activegateindexdp="|00:0";
for(i=0; i<subcomp+1; i++){
activegate[2*i]="None";
activegate[2*i+1]=false;
activegateindexdp=activegateindexdp+";None,0";
}
activegateindexdp=activegateindexdp+"|";
print(activegateindexdp);
addchratio=0;
addchnorm=0;
}
//////////////////////Initialization//////////////////////////
subspotn=newArray(subcomp);
jactcomp=0;
distcutoff=0;
jdistI=0;
jdistII=0;
subcompcounts[0]=counts-1;
totspots=0;
totalspotnumber=0;
for(jsub=1; jsub<subcomp+1; jsub++){
subcompcounts[jsub]=parseFloat(analysedparameterssum[subcompindexstart[jsub]+3]);
print("SubComp "+jsub+" Counts: "+subcompcounts[jsub]);
totspots=totspots+(5+3*analysedchannels)*subcompcounts[jsub];
totalspotnumber=totalspotnumber+subcompcounts[jsub];
}

print("Totspots: "+totspots);
for(ir=0; ir<subcomp+1; ir++){
label=label+" "+d2s(chl+1,0)+"\="+substring(subcomparray[ir],indexOf(subcomparray[ir],"\:")+2);
chl=chl+1;
if((ir==0)&&(checkwholecell)){
label=label+" "+d2s(chl+1,0)+"\=WholeCell";
chl=chl+1;
}
}
print("Label: "+label);
datatable=newArray(subcompcounts[0]*analysedparameters+totspots);
rawdatatable=newArray(subcompcounts[0]*analysedparameters);
automaximum=newArray(analysedparameterslisttemp.length-3);
autominimum=newArray(analysedparameterslisttemp.length-3);
if(firsttime){
maximum=newArray(analysedparameterslisttemp.length-3);
minimum=newArray(analysedparameterslisttemp.length-3);
//Array.fill(autominimum, 1.0E99);
Array.fill(autominimum, 0);
manualmaximum=newArray(analysedparameterslisttemp.length-3);
manualminimum=newArray(analysedparameterslisttemp.length-3);
checkautomax=newArray(analysedparameterslisttemp.length-3);
checkautomin=newArray(analysedparameterslisttemp.length-3);
mean=newArray(analysedparameters);
checkparam=newArray(analysedparameterslist.length);
for(i=0; i<5; i++){
checkparam[i]=1;
}
for(i=0; i<3*analysedchannels; i+=3){
checkparam[5+i]=1;
checkparam[5+i+1]=1;
}
if(checkwholecell){
for(j=0; j<2; j++){
checkparam[5+3*analysedchannels+j*(2+3*analysedchannels)]=1;
checkparam[5+3*analysedchannels+j*(2+3*analysedchannels)+1]=1;
for(i=0; i<3*analysedchannels; i+=3){
checkparam[5+3*analysedchannels+j*(2+3*analysedchannels)+2+i]=1;
checkparam[5+3*analysedchannels+j*(2+3*analysedchannels)+2+i+1]=1;
}
}
}
if(subcomp>0){
for(i=0; i<subcomp; i++){
for(j=0; j<5; j++){
if(j<4){
checkparam[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+(4+3*analysedchannels)*i+j]=1;
}
checkparam[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+(4+3*analysedchannels)*subcomp+(5+3*analysedchannels)*i+j]=1;
}
for(j=0; j<3; j++){
checkparam[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+(4+3*analysedchannels)*i+4+3*subcompfluo[i+1]+j]=1;
checkparam[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+(4+3*analysedchannels)*subcomp+(5+3*analysedchannels)*i+5+3*subcompfluo[i+1]+j]=1;
}
}

}
}


activegateweights=newArray(subcompcounts[0]+totalspotnumber);
distancegateweights=newArray(subcompcounts[0]+totalspotnumber);
renormweights=newArray(subcompcounts[0]);
activerenorm=false;
Array.fill(activegateweights,1);
Array.fill(distancegateweights,1);
Array.fill(renormweights,-1);
fileIndex=newArray(subcompcounts[0]);
Xcoord=newArray(subcompcounts[0]);
Ycoord=newArray(subcompcounts[0]);
if(checkwholecell){
WholeXcoord=newArray(subcompcounts[0]);
WholeYcoord=newArray(subcompcounts[0]);
}
cellIndex=newArray(totalspotnumber);
spotnumber=newArray(subcompcounts[0]*subcomp);


//////////////////////Create Dialog Windows for Parameters Selection: Cells, Subcomp and additional fields (e.g. File Index, Computed Channels)////////////////////////
if(firsttime){
availablech=0;
for(i=0; i<5+3*analysedchannels; i++){
if(checkparam[i]==0){
availablech=availablech+1;
}
}
addZfileindex=true;
if(indexOf(resultsarray[0], "XStage")>0){

}
if(mycheck){
Dialog.create("Computed Parameters Selection - Cell Section (I)");
Dialog.addMessage("Cell Physical Parameters");
physcellparam=Array.slice(analysedparameterslist, 0, 5);
physcelldef=Array.slice(checkparam, 0, 5);
fluocellparam=Array.slice(analysedparameterslist, 5, 5+3*analysedchannels);
fluocelldef=Array.slice(checkparam,5, 5+3*analysedchannels);
Dialog.addCheckboxGroup(2, 3, physcellparam, physcelldef);
Dialog.addMessage("Cell Fluorescence Parameters");
Dialog.addCheckboxGroup(analysedchannels, 3, fluocellparam, fluocelldef);
Dialog.show();
for(i=0; i<5+3*analysedchannels; i++){
if(analysedparameterssum[i+3]!="NC"){
checkparam[i]=Dialog.getCheckbox();
print(d2s(i,0)+" "+analysedparameterslist[i]+" "+checkparam[i]);
}
}
}
if(checkwholecell){
if(mycheck){
Dialog.create("Computed Parameters Selection - Cell Section (I)- Whole Cell");
Dialog.addMessage("Whole Cell Parameters");
wholecellphysparam=Array.slice(analysedparameterslist,5+3*analysedchannels, 5+3*analysedchannels+2);
wholecellphysdef=Array.slice(checkparam, 5+3*analysedchannels, 5+3*analysedchannels+2);
wholecellfluoparam=Array.slice(analysedparameterslist, 5+3*analysedchannels+2, 5+3*analysedchannels+2+3*analysedchannels);
wholecellfluodef=Array.slice(checkparam, 5+3*analysedchannels+2, 5+3*analysedchannels+2+3*analysedchannels);
Dialog.addMessage("Whole Cell  Physical Parameters");
Dialog.addCheckboxGroup(1, 2, wholecellphysparam, wholecellphysdef);
Dialog.addMessage("Whole Cell Fluorescence Parameters");
Dialog.addCheckboxGroup(analysedchannels, 3, wholecellfluoparam, wholecellfluodef);
Dialog.show();
for(i=5+3*analysedchannels; i<5+3*analysedchannels+2+3*analysedchannels; i++){
if(analysedparameterssum[i+3]!="NC"){
checkparam[i]=Dialog.getCheckbox();
print(d2s(i,0)+" "+analysedparameterslist[i]+" "+checkparam[i]);
}
if(checkparam[i]==0){
availablech=availablech+1;
}
}
Dialog.create("Computed Parameters Selection - Cell Section (I)- Cytoplasm");
Dialog.addMessage("Cytoplasm Parameters");
wholecellphysparam=Array.slice(analysedparameterslist,5+3*analysedchannels+2+3*analysedchannels, 5+3*analysedchannels+2+3*analysedchannels+2);
wholecellphysdef=Array.slice(checkparam, 5+3*analysedchannels+2+3*analysedchannels, 5+3*analysedchannels+2+3*analysedchannels+2);
wholecellfluoparam=Array.slice(analysedparameterslist, 5+3*analysedchannels+2+3*analysedchannels+2, 5+3*analysedchannels+2+3*analysedchannels+2+3*analysedchannels);
wholecellfluodef=Array.slice(checkparam, 5+3*analysedchannels+2+3*analysedchannels+2, 5+3*analysedchannels+2+3*analysedchannels+2+3*analysedchannels);
Dialog.addMessage("Whole Cell  Physical Parameters");
Dialog.addCheckboxGroup(1, 2, wholecellphysparam, wholecellphysdef);
Dialog.addMessage("Whole Cell Fluorescence Parameters");
Dialog.addCheckboxGroup(analysedchannels, 3, wholecellfluoparam, wholecellfluodef);
Dialog.show();
for(i=5+3*analysedchannels+2+3*analysedchannels; i<analysedparameters-subcomp*(4+3*analysedchannels); i++){
if(analysedparameterssum[i+3]!="NC"){
checkparam[i]=Dialog.getCheckbox();
print(d2s(i,0)+" "+analysedparameterslist[i]+" "+checkparam[i]);
}
if(checkparam[i]==0){
availablech=availablech+1;
}
}
}
for(i=5+3*analysedchannels+2+3*analysedchannels; i<analysedparameters-subcomp*(4+3*analysedchannels); i++){
if(checkparam[i]==0){
availablech=availablech+1;
}
}
} 

if(subcomp>0){
istart=analysedparameters-subcomp*(4+3*analysedchannels);
iend=analysedparameters-(subcomp-1)*(4+3*analysedchannels);
for(jsub=1; jsub<subcomp+1; jsub++){
subfluocellparamstring="|";
subfluocelldefstring="|";
subphyscellparam=Array.slice(analysedparameterslist,5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+(jsub-1)*(4+3*analysedchannels), 5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+(jsub-1)*(4+3*analysedchannels)+4);
subphyscelldef=Array.slice(checkparam,5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+(jsub-1)*(4+3*analysedchannels), 5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+(jsub-1)*(4+3*analysedchannels)+4);
for(k=0; k<analysedchannels; k++){
if(analysedparameterssum[3+5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+(jsub-1)*(4+3*analysedchannels)+4+3*k]!="NC"){
subfluocellparamstring=subfluocellparamstring+"|"+analysedparameterslist[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+(jsub-1)*(4+3*analysedchannels)+4+3*k]+"|"+analysedparameterslist[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+(jsub-1)*(4+3*analysedchannels)+4+3*k+1]+"|"+analysedparameterslist[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+(jsub-1)*(4+3*analysedchannels)+4+3*k+2];
subfluocelldefstring=subfluocelldefstring+"|"+checkparam[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+(jsub-1)*(4+3*analysedchannels)+4+3*k]+"|"+checkparam[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+(jsub-1)*(4+3*analysedchannels)+4+3*k+1]+"|"+checkparam[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+(jsub-1)*(4+3*analysedchannels)+4+3*k+2];
}
}
subfluocellparam=split(subfluocellparamstring,"|");
subfluocelldef=split(subfluocelldefstring,"|");
if(mycheck){
Dialog.create("Computed Parameters Selection - Cell Section (II)");
Dialog.addMessage("Subcomp "+d2s(jsub,0)+" derived Cell Parameters");
Dialog.addMessage("SubComp "+d2s(jsub,0)+" Physical Parameters");
Dialog.addCheckboxGroup(2, 3, subphyscellparam, subphyscelldef);
Dialog.addMessage("SubComp "+d2s(jsub,0)+" Fluorescence Parameters");
Dialog.addCheckboxGroup(lengthOf(subfluocellparam)/3, 3,subfluocellparam ,subfluocelldef);
Dialog.show();
for(i=istart; i<iend; i++){
if(analysedparameterssum[i+3]!="NC"){
checkparam[i]=Dialog.getCheckbox();
print(d2s(i,0)+" "+analysedparameterslist[i]+" "+checkparam[i]);
}
}
}
for(i=istart; i<iend; i++){
if(checkparam[i]==0){
availablech=availablech+1;
}
}
istart=istart+(4+3*analysedchannels);
iend=iend+(4+3*analysedchannels);
}
}


if(subcomp>0){
istart=analysedparameters;
iend=analysedparameters+(5+3*analysedchannels);
print("istart: "+istart+"; iend= "+iend);
for(jsub=1; jsub<subcomp+1; jsub++){
subfluocellparamstring="|";
subfluocelldefstring="|";
subphyscellparam=Array.slice(analysedparameterslist,subcompindexstart[jsub], subcompindexstart[jsub]+5);
subphyscelldef=Array.slice(checkparam,subcompindexstart[jsub], subcompindexstart[jsub]+5);
for(k=0; k<analysedchannels; k++){
if(analysedparameterssum[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+(jsub-1)*(4+3*analysedchannels)+4+3*k+3]!="NC"){
subfluocellparamstring=subfluocellparamstring+"|"+analysedparameterslist[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+subcomp*(4+3*analysedchannels)+(jsub-1)*(5+3*analysedchannels)+5+3*k]+"|"+analysedparameterslist[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+subcomp*(4+3*analysedchannels)+(jsub-1)*(5+3*analysedchannels)+5+3*k+1]+"|"+analysedparameterslist[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+subcomp*(4+3*analysedchannels)+(jsub-1)*(5+3*analysedchannels)+5+3*k+2];
subfluocelldefstring=subfluocelldefstring+"|"+checkparam[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+subcomp*(4+3*analysedchannels)+(jsub-1)*(5+3*analysedchannels)+5+3*k]+"|"+checkparam[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+subcomp*(4+3*analysedchannels)+(jsub-1)*(5+3*analysedchannels)+5+3*k+1]+"|"+checkparam[5+3*analysedchannels+checkwholecell*2*(2+3*analysedchannels)+subcomp*(4+3*analysedchannels)+(jsub-1)*(5+3*analysedchannels)+5+3*k+2];
}
}
subfluocellparam=split(subfluocellparamstring,"|");
subfluocelldef=split(subfluocelldefstring,"|");
if(mycheck){
Dialog.create("Computed Parameters Selection - SubComp Section");
Dialog.addMessage("Subcomp "+d2s(jsub,0)+" Parameters");
Dialog.addMessage("SubComp "+d2s(jsub,0)+" Physical Parameters");
Dialog.addCheckboxGroup(2, 3, subphyscellparam, subphyscelldef);
Dialog.addMessage("SubComp "+d2s(jsub,0)+" Fluorescence Parameters");
Dialog.addCheckboxGroup(lengthOf(subfluocellparam)/3, 3,subfluocellparam ,subfluocelldef);
Dialog.show();
for(i=istart; i<iend; i++){
if(i<istart+5){
checkparam[i]=Dialog.getCheckbox();
} else {
if(analysedparameterssum[i+3]!="NC"){
checkparam[i]=Dialog.getCheckbox();
print(d2s(i,0)+" "+analysedparameterslist[i]+" "+checkparam[i]);
}
} 
}
}
istart=istart+(5+3*analysedchannels);
iend=iend+(5+3*analysedchannels);
}
}
availablechind=newArray(availablech);
avch=0;
for(ch=0; ch<analysedparameters; ch++){
if(checkparam[ch]==0){
availablechind[avch]=ch;
avch=avch+1;
}
}
if(addZfileindex){
//checkparam[availablechind[0]]=1;
analysedparameterslist[availablechind[0]]=" 0: Cell_Z_File_Index";
}

//////////////Additional Channels Creation///////////////

Dialog.create("Derived channels: available channels "+availablech);
Dialog.addCheckbox("Calculate Stage Coordinates: ", 0);
Dialog.addMessage("Cell Ratiometric Channels: ");
Dialog.addNumber("# of additional ratiometric channels: ", addchratio);
Dialog.show();
stagecoordcheck=Dialog.getCheckbox();
addchratio=Dialog.getNumber();
num=newArray(addchratio);
ratioxnum=newArray(addchratio);
axnum=newArray(addchratio);
Array.fill(axnum, 1);
bxnum=newArray(addchratio);
den=newArray(addchratio);
ratioxden=newArray(addchratio);
axden=newArray(addchratio);
Array.fill(axden, 1);
bxden=newArray(addchratio);
if(stagecoordcheck){
analysedparameterslist[availablechind[addZfileindex]]=" 0: Cell_Xstage";
analysedparameterslist[availablechind[addZfileindex+1]]=" 0: Cell_Ystage";
//checkparam[availablechind[addZfileindex]]=1;
//checkparam[availablechind[addZfileindex+1]]=1;
}
if(addchratio>0){
choiceparameterslist="|";
jactcomp=0;
for(ich=0; ich<(subcompindexend[jactcomp]-subcompindexstart[jactcomp]);ich++){
if(checkparam[subcompindexstart[jactcomp]+ich]){
choiceparameterslist=choiceparameterslist+"|"+analysedparameterslist[subcompindexstart[jactcomp]+ich];
}
}
//if(addZfileindex){
//choiceparameterslist=choiceparameterslist+"|"+analysedparameterslist[availablechind[0]];
//}
for(iadd=0; iadd<addchratio; iadd++){
choiceparameters=split(choiceparameterslist, "|");
Dialog.create("Ratio parameters:");
Dialog.addMessage("Ratiometric Channel: "+iadd);
Dialog.addChoice("Numerator: ", choiceparameters, num[iadd]);
Dialog.addNumber("Numerator Slope: ", axnum[iadd]);
Dialog.addNumber("Numerator Intercept: ", bxnum[iadd]);
Dialog.addChoice("Denominator: ", choiceparameters, den[iadd]);
Dialog.addNumber("Denominator Slope: ", axden[iadd]);
Dialog.addNumber("Denominator Intercept: ", bxden[iadd]);
Dialog.show();
num[iadd]=Dialog.getChoice();
axnum[iadd]=Dialog.getNumber();
bxnum[iadd]=Dialog.getNumber();
den[iadd]=Dialog.getChoice();
axden[iadd]=Dialog.getNumber();
bxden[iadd]=Dialog.getNumber();
for(ch=0; ch<analysedparameters; ch++){
if(num[iadd]==analysedparameterslist[ch]){
ratioxnum[iadd]=ch;
}
if(den[iadd]==analysedparameterslist[ch]){
ratioxden[iadd]=ch;
}
}
analysedparameterslist[availablechind[iadd+addZfileindex+2*stagecoordcheck]]="0: Cell_Ratio_("+axnum[iadd]+"*"+analysedparameterslist[ratioxnum[iadd]]+"\+"+bxnum[iadd]+") \/ ("+axden[iadd]+"*"+analysedparameterslist[ratioxden[iadd]]+"\+"+bxden[iadd]+")";
choiceparameterslist=choiceparameterslist+"|"+analysedparameterslist[availablechind[iadd+1]];
}
}
} else {
if(addZfileindex){
checkparam[availablechind[0]]=0;
}
if(stagecoordcheck){
checkparam[availablechind[addZfileindex]]=0;
checkparam[availablechind[addZfileindex+1]]=0;
}
for(chr=addZfileindex+2*stagecoordcheck; chr<addZfileindex+2*stagecoordcheck+addchratio; chr++){
checkparam[availablechind[chr]]=0;
}
}
/////////////////////////end of initialization GUIs for the first data loading//////
///////All the next loaded files (called from the Load File Button) will skip the parameter-choice part with the condition that they must present the same parameters///

///////////////////////////Start Data Loading (from the chosen text-tab file)/////////////////////
starttime=getTime();
iperc=0;
for(i=1; i<subcompcounts[0]+1; i++){
event=split(resultsarray[i],"\t");
fileIndex[i-1]=parseInt(event[0]);
Xcoord[i-1]=event[1];
Ycoord[i-1]=event[2];

for(j=0; j<analysedparameters; j++){
if(checkparam[j]){

if(isNaN(parseFloat(event[j+3]))){
datatable[j+analysedparameters*(i-1)]=0;
rawdatatable[j+analysedparameters*(i-1)]=0;
} else {
datatable[j+analysedparameters*(i-1)]=parseFloat(event[j+3]);
rawdatatable[j+analysedparameters*(i-1)]=parseFloat(event[j+3]);
}

mean[j]=mean[j]+datatable[j+analysedparameters*(i-1)];
activegateweights[i-1]=1;
if((i-1)==0){
automaximum[j]=datatable[j];
maximum[j]=automaximum[j];
//autominimum[j]=datatable[j];
minimum[j]=autominimum[j];
} else {
if(datatable[j+analysedparameters*(i-1)]>automaximum[j]){
automaximum[j]=datatable[j+analysedparameters*(i-1)];
maximum[j]=automaximum[j];
}
if(datatable[j+analysedparameters*(i-1)]<autominimum[j]){
autominimum[j]=datatable[j+analysedparameters*(i-1)];
minimum[j]=autominimum[j];
}
}


}
}
//////////////////// loop for loading the spotsdata//////////////////////////////
for(jsub=1; jsub<subcomp+1; jsub++){
subind=0;
subnumb=0;
for(ijsub=1; ijsub<jsub; ijsub++){
subind=subind+(5+3*analysedchannels)*subcompcounts[ijsub];
subnumb=subnumb+subcompcounts[ijsub];
}
for(ispot=0; ispot<parseInt(event[3+subcompindexstart[jsub]]); ispot++){
cellIndex[subnumb+(subspotn[jsub-1]+ispot)]=datatable[0+analysedparameters*(i-1)]-1;
spotnumber[(jsub-1)*subcompcounts[0]+(i-1)]=subspotn[jsub-1]+parseInt(event[3+subcompindexstart[jsub]]);
//print("cellIndex["+(subnumb+(subspotn[jsub-1]+ispot))+"]="+cellIndex[subnumb+(subspotn[jsub-1]+ispot)]+"; analysedparameters*(i-1)="+(analysedparameters*(i-1)));
datatable[subcompcounts[0]*analysedparameters+subind+(subspotn[jsub-1]+ispot)*(5+3*analysedchannels)+1]=ispot+subspotn[jsub-1];
}

for(jspot=0; jspot<4+3*analysedchannels; jspot++){
if(checkparam[subcompindexstart[jsub]+1+jspot]){
spotscolumn=split(event[3+subcompindexstart[jsub]+1+jspot], "|");
//Array.show(spotscolumn);
//print("i="+i+"; jspot="+jspot);
for(ispot=0; ispot<parseInt(event[3+subcompindexstart[jsub]]); ispot++){
if(isNaN(parseFloat(spotscolumn[ispot]))){
datatable[subcompcounts[0]*analysedparameters+subind+(subspotn[jsub-1]+ispot)*(5+3*analysedchannels)+1+jspot]=0;
} else {
if((checkMaxspot)&&(jspot>3)&&((jspot-4)%3==2)){
datatable[subcompcounts[0]*analysedparameters+subind+(subspotn[jsub-1]+ispot)*(5+3*analysedchannels)+1+jspot]=datatable[subcompcounts[0]*analysedparameters+subind+(subspotn[jsub-1]+ispot)*(5+3*analysedchannels)+1+jspot-2]/datatable[cellIndex[subnumb+(subspotn[jsub-1]+ispot)]*analysedparameters+5+floor((jspot-4)/3)*3];
//print("analysed parameter: "+analysedparameterslist[5+floor((jspot-4)/3)*3]+": "+datatable[subcompcounts[0]*analysedparameters+subind+(subspotn[jsub-1]+ispot)*(5+3*analysedchannels)+1+jspot]);
} else {
datatable[subcompcounts[0]*analysedparameters+subind+(subspotn[jsub-1]+ispot)*(5+3*analysedchannels)+1+jspot]=parseFloat(spotscolumn[ispot]);
}
}
if((subspotn[jsub-1]==0)&&(ispot==0)){
automaximum[subcompindexstart[jsub]+1+jspot]=datatable[subcompcounts[0]*analysedparameters+subind+(subspotn[jsub-1]+ispot)*(5+3*analysedchannels)+1+jspot];
maximum[subcompindexstart[jsub]+1+jspot]=automaximum[subcompindexstart[jsub]+1+jspot];
autominimum[analysedparameters]=datatable[analysedparameters];
minimum[j]=autominimum[j];
} else {
if(datatable[subcompcounts[0]*analysedparameters+subind+(subspotn[jsub-1]+ispot)*(5+3*analysedchannels)+1+jspot]>automaximum[subcompindexstart[jsub]+1+jspot]){
automaximum[subcompindexstart[jsub]+1+jspot]=datatable[subcompcounts[0]*analysedparameters+subind+(subspotn[jsub-1]+ispot)*(5+3*analysedchannels)+1+jspot];
maximum[subcompindexstart[jsub]+1+jspot]=automaximum[subcompindexstart[jsub]+1+jspot];
}
}
}
}
}
subspotn[jsub-1]=subspotn[jsub-1]+ispot;
}

////////////////////end of the loop for loading the spotsdata//////////////////////////////
////////////////loading File Index Coordinates////////////////
if(addZfileindex){
if(i==1){
waitForUser("File Index Loading at column "+availablechind[0]);
}
datatable[availablechind[0]+analysedparameters*(i-1)]=fileIndex[i-1];
if(i==1){
automaximum[0]=datatable[availablechind[0]];
maximum[availablechind[0]]=automaximum[availablechind[0]];
autominimum[availablechind[0]]=datatable[availablechind[0]];
minimum[availablechind[0]]=autominimum[availablechind[0]];
} 
if(datatable[availablechind[0]+analysedparameters*(i-1)]>automaximum[availablechind[0]]){
automaximum[availablechind[0]]=datatable[availablechind[0]+analysedparameters*(i-1)];
maximum[availablechind[0]]=automaximum[availablechind[0]];
}
if(datatable[availablechind[0]+analysedparameters*(i-1)]<autominimum[availablechind[0]]){
autominimum[availablechind[0]]=datatable[availablechind[0]+analysedparameters*(i-1)];
minimum[availablechind[0]]=autominimum[availablechind[0]];
}
}
////////////////end of loading File Index Coordinates////////////////
////////////////creation of stage coordinates////////////////////////
if(stagecoordcheck){
if(i==1){
waitForUser("File Index Loading at column "+availablechind[addZfileindex]);
fileID=-1;
indicecell=i-1;
automaximum[availablechind[addZfileindex]]=-10000000000000000000;
autominimum[availablechind[addZfileindex]]=10000000000000000000;
automaximum[availablechind[addZfileindex+1]]=-10000000000000000000;
autominimum[availablechind[addZfileindex+1]]=10000000000000000000;
}

//run("Bio-Formats (Windowless)", "open=H:/Multiplex/RIMI300_CS_1/Registered/Region00/Round01_20x_Point0000.nd2.tif autoscale color_mode=Default display_metadata rois_import=[ROI manager] view=[Metadata only] stack_order=Default");
if(nd2check<0){
waitForUser("Stage Coordinates retrieval working on nd2 files only");
} else {
if(parseInt(fileIndex[i-1])!=fileID){
if(fileID>=0){
if(isOpen("Original Metadata - "+imageslist[fileID])){
selectWindow("Original Metadata - "+imageslist[fileID]);
run("Close");
}
}
xcenter=imagewidth/2;
ycenter=imageheight/2;
indicecell=i-1;
fileID=parseInt(fileIndex[i-1]);
target=imagesdir+imageslist[fileID];
run("Bio-Formats", "open=["+target+"] color_mode=Default display_metadata rois_import=[ROI manager] view=[Metadata only] stack_order=Default");
selectWindow("Original Metadata - "+imageslist[fileID]);
infostring=getInfo("window.contents");
infoarray=split(infostring, "\n");
pixelsizeX=-1;
stagepositionX=-1;
stagepositionY=-1;
for(ii=0; ii<lengthOf(infoarray); ii++){
if(indexOf(infoarray[ii],"dCalibration")>=0&&pixelsizeX<0){
C=split(infoarray[ii], "\t");
pixelsizeX=pixelsizeY=parseFloat(C[1]);
}
if(indexOf(infoarray[ii],"dXPos")>=0&&stagepositionX<0){
C=split(infoarray[ii], "\t");
stagepositionX=parseFloat(C[1]);
}
if(indexOf(infoarray[ii],"dYPos")>=0&&stagepositionY<0){
C=split(infoarray[ii], "\t");
stagepositionY=parseFloat(C[1]);
}
}
}
datatable[availablechind[addZfileindex]+analysedparameters*(i-1)]=stagepositionX-pixelsizeX*(datatable[1+analysedparameters*(i-1)]-xcenter);
datatable[availablechind[addZfileindex+1]+analysedparameters*(i-1)]=stagepositionY+pixelsizeY*(datatable[2+analysedparameters*(i-1)]-ycenter);
if(i==1){
automaximum[availablechind[addZfileindex]]=datatable[availablechind[addZfileindex]];
maximum[availablechind[addZfileindex]]=automaximum[availablechind[addZfileindex]];
autominimum[availablechind[addZfileindex]]=datatable[availablechind[addZfileindex]];
minimum[availablechind[addZfileindex]]=autominimum[availablechind[addZfileindex]];
automaximum[availablechind[addZfileindex+1]]=datatable[availablechind[addZfileindex+1]];
maximum[availablechind[addZfileindex+1]]=automaximum[availablechind[addZfileindex+1]];
autominimum[availablechind[addZfileindex+1]]=datatable[availablechind[addZfileindex+1]];
minimum[availablechind[addZfileindex+1]]=autominimum[availablechind[addZfileindex+1]];
} 

if(datatable[availablechind[addZfileindex]+analysedparameters*(i-1)]>automaximum[availablechind[addZfileindex]]){
automaximum[availablechind[addZfileindex]]=datatable[availablechind[addZfileindex]+analysedparameters*(i-1)];
maximum[availablechind[addZfileindex]]=automaximum[availablechind[addZfileindex]];
}
if(datatable[availablechind[addZfileindex]+analysedparameters*(i-1)]<autominimum[availablechind[addZfileindex]]){
autominimum[availablechind[addZfileindex]]=datatable[availablechind[addZfileindex]+analysedparameters*(i-1)];
minimum[availablechind[addZfileindex]]=autominimum[availablechind[addZfileindex]];
}
if(datatable[availablechind[addZfileindex+1]+analysedparameters*(i-1)]>automaximum[availablechind[addZfileindex+1]]){
automaximum[availablechind[addZfileindex+1]]=datatable[availablechind[addZfileindex+1]+analysedparameters*(i-1)];
maximum[availablechind[addZfileindex+1]]=automaximum[availablechind[addZfileindex+1]];
}
if(datatable[availablechind[addZfileindex+1]+analysedparameters*(i-1)]<autominimum[availablechind[addZfileindex+1]]){
autominimum[availablechind[addZfileindex+1]]=datatable[availablechind[addZfileindex+1]+analysedparameters*(i-1)];
minimum[availablechind[addZfileindex+1]]=autominimum[availablechind[addZfileindex+1]];
}
}
}

////////////////end of creation of stage coordinates////////////////
////////additional channel creation//////////
for(ch=0; ch<addchratio; ch++){
if(i==1){
Array.show(axnum, bxnum, axden, bxden);
waitForUser("Ratio Channel "+d2s(ch+addZfileindex+2*stagecoordcheck,0)+" Loading at column "+availablechind[ch+addZfileindex+2*stagecoordcheck]);
}
datatable[availablechind[ch+addZfileindex+2*stagecoordcheck]+analysedparameters*(i-1)]=(axnum[ch]*datatable[ratioxnum[ch]+analysedparameters*(i-1)]+bxnum[ch])/(axden[ch]*datatable[ratioxden[ch]+analysedparameters*(i-1)]+bxden[ch]);
if(isNaN(datatable[availablechind[ch+addZfileindex+2*stagecoordcheck]+analysedparameters*(i-1)])){
datatable[availablechind[ch+addZfileindex+2*stagecoordcheck]+analysedparameters*(i-1)]=0;
}
rawdatatable[availablechind[ch+addZfileindex+2*stagecoordcheck]+analysedparameters*(i-1)]=datatable[availablechind[ch+addZfileindex+2*stagecoordcheck]+analysedparameters*(i-1)];
if(i==1){
automaximum[availablechind[ch+addZfileindex+2*stagecoordcheck]]=datatable[availablechind[ch+addZfileindex+2*stagecoordcheck]];
maximum[availablechind[ch+addZfileindex]+2*stagecoordcheck]=automaximum[availablechind[ch+addZfileindex+2*stagecoordcheck]];
autominimum[availablechind[ch+addZfileindex+2*stagecoordcheck]]=datatable[availablechind[ch+addZfileindex+2*stagecoordcheck]];
minimum[availablechind[ch+addZfileindex+2*stagecoordcheck]]=autominimum[availablechind[ch+addZfileindex+2*stagecoordcheck]];
} 
if(datatable[availablechind[ch+addZfileindex+2*stagecoordcheck]+analysedparameters*(i-1)]>automaximum[availablechind[ch+addZfileindex+2*stagecoordcheck]]){
automaximum[availablechind[ch+addZfileindex+2*stagecoordcheck]]=datatable[availablechind[ch+addZfileindex+2*stagecoordcheck]+analysedparameters*(i-1)];
maximum[availablechind[ch+addZfileindex+2*stagecoordcheck]]=automaximum[availablechind[ch+addZfileindex+2*stagecoordcheck]];
}
if(datatable[availablechind[ch+addZfileindex+2*stagecoordcheck]+analysedparameters*(i-1)]<autominimum[availablechind[ch+addZfileindex+2*stagecoordcheck]]){
autominimum[availablechind[ch+addZfileindex+2*stagecoordcheck]]=datatable[availablechind[ch+addZfileindex+2*stagecoordcheck]+analysedparameters*(i-1)];
minimum[availablechind[ch+addZfileindex+2*stagecoordcheck]]=autominimum[availablechind[ch+addZfileindex+2*stagecoordcheck]];
}
}


/////////end of additional channel creation///////
if(i>=0.1*iperc*subcompcounts[0]){
print(10*iperc+"% elapsed - "+i+" out of "+subcompcounts[0]+" cells loaded");
print("File Index at position "+(availablechind[0]+analysedparameters*(i-1))+": "+datatable[availablechind[0]+analysedparameters*(i-1)]);
iperc=iperc+1;
}
}
/////////////////////////end of i - loop for Cell data Loading/////////////////

if(addZfileindex){
checkparam[availablechind[0]]=1;
}
if(stagecoordcheck){
checkparam[availablechind[addZfileindex]]=1;
checkparam[availablechind[addZfileindex+1]]=1;
if(isOpen("Original Metadata - "+imageslist[fileID])){
selectWindow("Original Metadata - "+imageslist[fileID]);
run("Close");
}
}
for(chr=addZfileindex+2*stagecoordcheck; chr<addZfileindex+2*stagecoordcheck+addchratio; chr++){
checkparam[availablechind[chr]]=1;
//analysedparameterslist[availablechind[chr]]=" 0: Cell_Ratio_"+analysedparameterslist[ratioxnum[chr-1]]+"\/"+analysedparameterslist[ratioxden[chr-1]];
analysedparameterslist[availablechind[chr]]="0: Cell_Ratio_("+axnum[chr-(addZfileindex+2*stagecoordcheck)]+"*\["+analysedparameterslist[ratioxnum[chr-(addZfileindex+2*stagecoordcheck)]]+"\]\+"+bxnum[chr-(addZfileindex+2*stagecoordcheck)]+") \/ ("+axden[chr-(addZfileindex+2*stagecoordcheck)]+"*\["+analysedparameterslist[ratioxden[chr-(addZfileindex+2*stagecoordcheck)]]+"\]\+"+bxden[chr-(addZfileindex+2*stagecoordcheck)]+")";
}
endtime=getTime();
event="";
//Array.getStatistics(spotstable, minimal, maximal, meanspotting, stdev);
print("Elapsed Time: "+(endtime-starttime)/1000+" seconds");
print("Z File Index Last Value: "+datatable[availablechind[0]+analysedparameters*(subcompcounts[0]-1)]);

if(!firsttime){

for(j=0; j<fullanalysedparameters; j++){
if(checkautomax[j]==1){
maximum[j]=manualmaximum[j];
}
if(checkautomin[j]==1){
minimum[j]=manualminimum[j];
}

}
DPactcomp=split(jactcompdp,"\|");
DPx=split(jxdp,"\|");
DPy=split(jydp,"\|");
DPgate=split(activegateindexdp,"\|");
selectImage(dotplotID);
for(j=0; j<nSlices; j++){
jactcomp=parseInt(substring(DPactcomp[j],3,4));
selectImage(dotplotID);
setSlice(parseInt(substring(DPx[j],0,2))+1);
activegateindex=parseInt(substring(DPgate[j],3,4));
arraygateDP=split(DPgate[j],"\;");
for(ic=0; ic<subcomp+1; ic++){
activegate[2*ic]=substring(arraygateDP[ic+1],0, indexOf(arraygateDP[ic+1],","));
activegate[2*ic+1]=parseInt(substring(arraygateDP[ic+1], indexOf(arraygateDP[ic+1],",")+1,indexOf(arraygateDP[ic+1],",")+2));
}
//print("Active Comp: "+jactcompdp+"; Jx: "+substring(DPx[j],3,5)+"; Jy: "+substring(DPy[j],3,5));
print("Minimum: "+minimum[jx]);
print("Maximum: "+maximum[jx]);
gateddotplot(parseInt(substring(DPactcomp[j],3,5)), parseInt(substring(DPx[j],3,6)), parseInt(substring(DPy[j],3,6)), voltage[parseInt(substring(DPx[j],3,5))], offset[parseInt(substring(DPx[j],3,5))], voltage[parseInt(substring(DPy[j],3,5))], offset[parseInt(substring(DPy[j],3,5))]);
print("Minimum: "+minimum[jx]);
print("Maximum: "+maximum[jx]);
}
//setSlice(sliceDP);
}
setBatchMode(false);
updateDisplay();

}

////////////////////////////////////////////end of function  ///////////////////////////////////////////////////////////////////////////////////////////////////////////

function updateregionlist() {
selectWindow("Dot Plot"+resultsfilepath);
sliceNow=getSliceNumber();
lista=split(regionlist, "\n");
regionlist="Begin";
print(regionlist);
regnames=newArray(lista.length);
roimanagerlist="Start";
for(i=0; i<roiManager("count"); i++){
roimanagerlist=roimanagerlist+"\t"+call("ij.plugin.frame.RoiManager.getName", i);
}
for(j=1; j<lista.length;j++){
regnamesarray=split(lista[j], "\t");
regnames[j]=regnamesarray[0];
if(indexOf(roimanagerlist, regnames[j])<0){
arraygates=split(gatelist, "\n");
gatelist="None";
for(i=1; i<arraygates.length; i++){
if(indexOf(arraygates[i], regnames[j])>=0){
if(activegate==arraygates[i]){
activegate="None";
Array.fill(activegateweights, 1);
activegateindex=0;
gateddotplot(jactcomp,jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);
}
} else {
gatelist=gatelist+"\n"+arraygates[i];
}
}

} else {
regionlist=regionlist+"\n"+regnamesarray[0];
for(k=1; k<lengthOf(regnamesarray)-2; k++){
regionlist=regionlist+"\t"+regnamesarray[k];
}
selectWindow("Dot Plot"+resultsfilepath);
for(i=0; i<roiManager("count"); i++){
if(call("ij.plugin.frame.RoiManager.getName", i)==regnames[j]){
roiManager("select", i);
getSelectionCoordinates(xcroi, ycroi);
xregc="";
yregc="";
for(iroi=0; iroi<lengthOf(xcroi); iroi++){
xregc=xregc+":"+xcroi[iroi];
yregc=yregc+":"+ycroi[iroi];
}
}
}
regionlist=regionlist+"\t"+xregc+"\t"+yregc;
}

}
run("Select None");
setSlice(sliceNow);
lista=split(regionlist, "\n");
if(lista.length>1){
title1 = "Region List";
  title2 = "["+title1+"]";
  f = title2;
  if (isOpen(title1))
     print(f, "\\Clear");
  else
    {run("Table...", "name="+title2+" width=250 height=600");}
  print(f, "\\Headings:Region\tX\tVoltageX\tMinimumX\tMaximumX\tY\tVoltageY\tMinimumY\tMaximumY\tXcoord.\tYcoord.");
for(j=1; j<lista.length; j++){
parameters=split(lista[j], "\t");
heading=parameters[0];
jxroi=parseInt(parameters[1]);
jyroi=parseInt(parameters[4]);
voltagexroi=parseFloat(parameters[2]);
voltageyroi=parseFloat(parameters[5]);
//offsetxroi=parseFloat(parameters[3]);
minimumxroi=parseFloat(parameters[3]);
//offsetyroi=parseFloat(parameters[6]);
minimumyroi=parseFloat(parameters[6]);
scalexroi=(parseFloat(parameters[7])-minimumxroi)/(voltagexroi*1);
scaleyroi=(parseFloat(parameters[8])-minimumyroi)/(voltageyroi*1);
 print(f, heading+"\t"+analysedparameterslist[jxroi]+"\t" +voltagexroi+"\t"+minimumxroi+"\t"+parameters[7]+"\t"+analysedparameterslist[jyroi]+"\t" +voltageyroi+"\t"+minimumyroi+"\t"+parameters[8]+"\t"+parameters[9]+"\t"+parameters[10]);
}
}
}
////////////////////////////////////////end of function updateregionlist()//////////////////
function updateDP(){
selectImage(dotplotID);
setBatchMode(true);
DPgate=split(activegateindexdp,"\|");
selectImage(dotplotID);
for(j=1; j<nSlices+1; j++){
selectImage(dotplotID);
setSlice(j);
jactcomp=parseInt(substring(jactcompdp, (j-1)*6+4,j*6));
jx=parseInt(substring(jxdp, (j-1)*7+4,j*7));
jy=parseInt(substring(jydp, (j-1)*7+4,j*7));
dotplotscheme();
setColor(255,255,255);
fillRect(70, 1058, 300, 12);
fillRect(175, 1078, 30, 12);
fillRect(360, 1078, 30, 12);
setColor(0,0,0);
drawString(analysedparameterslist[jx]+";", 70, 1070);
drawString(d2s(voltage[jx],2), 175, 1090);
drawString(offset[jx], 360, 1090);
setColor(255,255,255);
fillRect(71, 1077, 98, 12);
setColor(0,0,255);
fillRect(71, 1077, voltage[jx]/0.1, 12);
setColor(255,255,255);
fillRect(251, 1077, 98, 12);
setColor(0,0,255);
fillRect(251, 1077, 50+offset[jx]/10, 12);
setColor(0,0,0);
setColor(255,255,255);
fillRect(70, 1098, 300, 12);
fillRect(175, 1118, 30, 12);
fillRect(360, 1118, 30, 12);
setColor(0,0,0);
drawString(analysedparameterslist[jy]+";", 70, 1110);
drawString(d2s(voltage[jy],2), 175, 1130);
drawString(offset[jy], 360, 1130);
setColor(255,255,255);
fillRect(71, 1117, 98, 12);
setColor(0,0,255);
fillRect(71, 1117, voltage[jy]/0.1, 12);
setColor(255,255,255);
fillRect(251, 1117, 98, 12);
setColor(0,0,255);
fillRect(251, 1117, 50+offset[jy]/10, 12);
setColor(0,0,0);
activegateindex=parseInt(substring(DPgate[j-1],3,4));
arraygateDP=split(DPgate[j-1],"\;");
for(ic=0; ic<subcomp+1; ic++){
activegate[2*ic]=substring(arraygateDP[ic+1],0, indexOf(arraygateDP[ic+1],","));
activegate[2*ic+1]=parseInt(substring(arraygateDP[ic+1], indexOf(arraygateDP[ic+1],",")+1,indexOf(arraygateDP[ic+1],",")+2));
}
gateddotplot(jactcomp, jx, jy, voltage[jx], offset[jx], voltage[jy], offset[jy]);
print("Dot Plot "+d2s(j,0)+" Created");
}
setBatchMode(false);
updateDisplay();
}
////////////////////////////////////end of function updateDP()/////////////////////////////
function dotplotscheme() {
run("Select All");
setColor(255,255,255);
fill();
run("Select None");
setColor(0,0,255);
drawRect(7,7,1026,1026);
ncomp=128;
for(ig=0; ig<ncomp+1; ig++){
if((ig-2*floor(ig/2))==0){
drawRect(8+1024/ncomp*ig-1, 3, 2, 5);
drawRect(8+1024/ncomp*ig-1, 1032, 2, 5);
drawRect(3, 8+1024/ncomp*ig-1, 5,2);
} else {
drawRect(8+1024/ncomp*ig-1, 5, 2, 3);
drawRect(8+1024/ncomp*ig-1, 1032, 2, 3);
drawRect(5, 8+1024/ncomp*ig-1, 3,2);
}
}
///////////////////////////////////////////draw square containing dot plot data///////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1044, 8, 70, 17);
setColor(0,0,125);
drawRect(1045,9, 68, 15);
setColor(0,0,255);
fillRect(1046, 10, 66,13);
setColor(255,255,255);
drawString("Set Region", 1048, 24);
////////////////////////////////////////// Set Region Button//////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1044, 28, 70, 17);
setColor(0,0,125);
drawRect(1045,29, 68, 15);
setColor(0,0,255);
fillRect(1046, 30, 66,13);
setColor(255,255,255);
drawString("Set Gate", 1048, 44);
////////////////////////////////////////// Set Gate Button//////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1044, 48, 70, 17);
setColor(0,0,125);
drawRect(1045,49, 68, 15);
setColor(0,0,255);
fillRect(1046, 50, 66,13);
setColor(255,255,255);
drawString("Show Stats", 1048, 64);
////////////////////////////////////////// Show Stats Button//////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1044, 68, 70, 17);
setColor(0,0,125);
drawRect(1045,69, 68, 15);
setColor(0,0,255);
fillRect(1046, 70, 66,13);
setColor(255,255,255);
drawString("New Plot", 1048, 84);
////////////////////////////////////////// Set New Plot Button//////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1044, 88, 70, 17);
setColor(0,0,125);
drawRect(1045,89, 68, 15);
setColor(0,0,255);
fillRect(1046, 90, 66,13);
setColor(255,255,255);
drawString("Renormalize", 1048, 104);
////////////////////////////////////////// Set Renormalize Button//////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1044, 108, 70, 17);
setColor(0,0,125);
drawRect(1045,109, 68, 15);
setColor(0,0,255);
fillRect(1046, 110, 66,13);
setColor(255,255,255);
drawString("Export Data", 1048, 124);
////////////////////////////////////////// Set Export Gated  Button//////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1044, 128, 70, 17);
setColor(0,0,125);
drawRect(1045,129, 68, 15);
setColor(0,0,255);
fillRect(1046, 130, 66,13);
setColor(255,255,255);
drawString("Pause", 1048, 144);
////////////////////////////////////////// Set Pause Button/////////////////////////////
setColor(0,0,0);
drawString("Scale", 1048, 754);
drawString("X Axis:", 1048, 774);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1044, 778, 70, 17);
setColor(0,0,125);
drawRect(1045,779, 68, 15);
setColor(0,0,255);
fillRect(1046, 780, 66,13);
setColor(255,255,255);
drawString("Auto", 1048, 794);
setColor(0,0,255);
drawString("Min: ", 1048, 814);
// drawString with max value at 538, 184
////////////////////////////////////////// Auto X Min button//////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1044, 838, 70, 17);
setColor(0,0,125);
drawRect(1045,839, 68, 15);
setColor(0,0,255);
fillRect(1046, 840, 66,13);
setColor(255,255,255);
drawString("Manual", 1048, 854);
setColor(0,0,255);
drawString("Min: ", 1048, 874);
// drawString with max value at 538, 244
////////////////////////////////////////// Manual X Min Button//////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,0);
drawString("Y axis:", 1048, 914);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1044, 918, 70, 17);
setColor(0,0,125);
drawRect(1045,919, 68, 15);
setColor(0,0,255);
fillRect(1046, 920, 66,13);
setColor(255,255,255);
drawString("Auto", 1048, 934);
setColor(0,0,255);
drawString("Min: ", 1048, 954);
// draw String with max value at 538, 324
////////////////////////////////////////// Auto Y Min Button//////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1044, 978, 70, 17);
setColor(0,0,125);
drawRect(1045,979, 68, 15);
setColor(0,0,255);
fillRect(1046, 980, 66,13);
setColor(255,255,255);
drawString("Manual", 1048, 994);              
setColor(0,0,255);
drawString("Min: ", 1048, 1014);
// draw String with max value at 538, 512
////////////////////////////////////////// Manual Y Min Button//////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1121, 778, 70, 17);
setColor(0,0,125);
drawRect(1122,779, 68, 15);
setColor(0,0,255);
fillRect(1123, 780, 66,13);
setColor(255,255,255);
drawString("Auto", 1125, 794);
setColor(0,0,255);
drawString("Min: ", 1125, 814);
// drawString with max value at 538, 184
////////////////////////////////////////// Auto X Max button//////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1121, 838, 70, 17);
setColor(0,0,125);
drawRect(1122,839, 68, 15);
setColor(0,0,255);
fillRect(1123, 840, 66,13);
setColor(255,255,255);
drawString("Manual", 1125, 854);
setColor(0,0,255);
drawString("Max: ", 1125, 874);
// drawString with max value at 538, 244
////////////////////////////////////////// Manual X Max Button//////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1121, 918, 70, 17);
setColor(0,0,125);
drawRect(1122,919, 68, 15);
setColor(0,0,255);
fillRect(1123, 920, 66,13);
setColor(255,255,255);
drawString("Auto", 1125, 934);
setColor(0,0,255);
drawString("Max: ", 1125, 954);
// draw String with max value at 538, 324
////////////////////////////////////////// Auto Y Max Button//////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1121, 978, 70, 17);
setColor(0,0,125);
drawRect(1122,979, 68, 15);
setColor(0,0,255);
fillRect(1123, 980, 66,13);
setColor(255,255,255);
drawString("Manual", 1125, 994);              
setColor(0,0,255);
drawString("Max: ", 1125, 1014);
// draw String with max value at 538, 512
////////////////////////////////////////// Manual Y Max Button//////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1121, 8, 70, 17);
setColor(0,0,125);
drawRect(1122,9, 68, 15);
setColor(0,0,255);
fillRect(1123, 10, 66,13);
setColor(255,255,255);
drawString("Pictures", 1125, 24);
////////////////////////////////////////// Picture Retrieval Mode Button////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1121, 28, 70, 17);
setColor(0,0,125);
drawRect(1122,29, 68, 15);
setColor(0,0,255);
fillRect(1123, 30, 66,13);
setColor(255,255,255);
drawString("Load data", 1125, 44);
////////////////////////////////////////// Load data Mode Button////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1121, 48, 70, 17);
setColor(0,0,125);
drawRect(1122,49, 68, 15);
setColor(0,0,255);
fillRect(1123, 50, 66,13);
setColor(255,255,255);
drawString("Duplicate", 1125, 64);
////////////////////////////////////////// Duplicate Dot Plot Button////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1121, 68, 70, 17);
setColor(0,0,125);
drawRect(1122,69, 68, 15);
setColor(0,0,255);
fillRect(1123, 70, 66,13);
setColor(255,255,255);
drawString("Load RL", 1125, 84);
//////////////////////////////////////////Load RegionList Button////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1121, 88, 70, 17);
setColor(0,0,125);
drawRect(1122,89, 68, 15);
setColor(0,0,255);
fillRect(1123, 90, 66,13);
setColor(255,255,255);
drawString("DP Slice", 1125, 104);
//////////////////////////////////////////Load DoatPlot////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1121, 108, 70, 17);
setColor(0,0,125);
drawRect(1122,109, 68, 15);
setColor(0,0,255);
fillRect(1123, 110, 66,13);
setColor(255,255,255);
drawString("Update DP", 1125, 124);
//////////////////////////////////////////Update DoatPlot////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1121, 128, 70, 17);
setColor(0,0,125);
drawRect(1122,129, 68, 15);
setColor(0,0,255);
fillRect(1123, 130, 66,13);
setColor(255,255,255);
drawString("Stage", 1125, 144);
//////////////////////////////////////////Retrieve Stage Positions////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1121, 148, 70, 17);
setColor(0,0,125);
drawRect(1122,149, 68, 15);
setColor(0,0,255);
fillRect(1123, 150, 66,13);
setColor(255,255,255);
drawString("Distances", 1125, 164);
//////////////////////////////////////////Distance Gating////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1121, 168, 70, 17);
setColor(0,0,125);
drawRect(1122,169, 68, 15);
setColor(0,0,255);
fillRect(1123, 170, 66,13);
setColor(255,255,255);
drawString("DP List", 1125, 184);
//////////////////////////////////////////DP stack////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1121, 188, 70, 17);
setColor(0,0,125);
drawRect(1122,189, 68, 15);
setColor(0,0,255);
fillRect(1123, 190, 66,13);
setColor(255,255,255);
drawString("Auto Stats", 1125, 204);
//////////////////////////////////////////Auto Stats//////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(1044,1054, 46, 17);
setColor(0,0,125);
drawRect(1045,1055, 44, 15);
setColor(0,0,255);
fillRect(1046, 1056, 42,13);
setColor(255,255,255);
drawString("Gates:", 1048, 1070);
////////////////////////////////////////// Set Gate Button//////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,0);
drawRect(1044,1054, 46, 17);
//setColor(0,0,125);
//drawRect(15,417, 44, 15);
//setColor(0,0,255);
//fillRect(16, 418, 42,13);
//setColor(255,255,255);
//drawString("None", 1041, 1090);
////////////////////////////////////////// Active Gate Box//////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(14,1144, 96, 17);
setColor(0,0,125);
drawRect(15,1145, 94, 15);
setColor(0,0,255);
fillRect(16, 1146, 92,13);
setColor(255,255,255);
drawString("Compartment:", 20, 1160);
setColor(255,255,255);
fillRect(0,1140,20,20);
setColor(0,0,0);
drawString(subcomparray[jactcomp], 14, 1180);
/////////////////////////////////////subcompartment Button/////////////////////////
setColor(0,0,62);
drawRect(14,1054, 46, 17);
setColor(0,0,125);
drawRect(15,1055, 44, 15);
setColor(0,0,255);
fillRect(16, 1056, 42,13);
setColor(255,255,255);
drawString("X axis:", 20, 1070);
//setColor(255,255,255);
//fillRect(70, 420, 300, 12);
setColor(0,0,0);
drawString("Voltage: ", 20, 1090);
drawString("Offset: ", 210, 1090);
//////////////////////////////////////////  X Box //////////////////////////////////////////////////////////////////////////////////////////////////////
drawRect(70, 1076, 100, 14);
//setColor(0,0,255);
//fillRect(71, 1077, voltage[5]/0.1, 12);
//////////////////////////////////////////  X Voltage Button //////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,0);
drawRect(250, 1076, 101,14);
//setColor(0,0,255);
//fillRect(251, 1077, offset[5]/10, 12);
//////////////////////////////////////////  X Offset Button //////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,62);
drawRect(14,1094, 46, 17);
setColor(0,0,125);
drawRect(15,1095, 44, 15);
setColor(0,0,255);
fillRect(16, 1096, 42,13);
setColor(255,255,255);
drawString("Y axis:", 20, 1110);
//setColor(255,255,255);
//fillRect(70, 460, 300, 12);
setColor(0,0,0);
drawString("Voltage: ", 20, 1130);
drawString("Offset: ", 210, 1130);
//////////////////////////////////////////  Y Box //////////////////////////////////////////////////////////////////////////////////////////////////////
drawRect(70, 1116, 100, 14);
//setColor(0,0,255);
//fillRect(71, 1117, voltage[3]/0.1, 12);
//////////////////////////////////////////  Y Voltage Button //////////////////////////////////////////////////////////////////////////////////////////////////////
setColor(0,0,0);
drawRect(250, 1116, 100,14);
//////////////////////////////////////////  Y Offset Button //////////////////////////////////////////////////////////////////////////////////////////////////////

}
////////////////////////////////////////////////////////////////end of Dot Plot Scheme creation///////////////////////////////////////////////////////////////////////////////////////

function updateStats() {
arrayend=newArray(subcomp+1);
Array.fill(arrayend,0);

for (i=0; i<subcompcounts[0]; i++){
statscomp=0;

for(jstats=5+3*analysedchannels+2*checkwholecell*(2+3*analysedchannels); jstats<subcompindexend[0]-subcompindexstart[0]; jstats++){
if(checkparam[jstats]){
datatable[jstats+i*analysedparameters]=rawdatatable[jstats+i*analysedparameters];
statscomp=floor((jstats-(5+3*analysedchannels+2*checkwholecell*(2+3*analysedchannels)))/(4+3*analysedchannels));
//////start of recalculation for subcomp-derived cell parameters///////////////////////////////////
if((jstats==5+3*analysedchannels+2*checkwholecell*(2+3*analysedchannels)+statscomp*(4+3*analysedchannels))&&((activegate[2*statscomp+2]!="None")||(distcutoff>0))){

statsubind=0;
statsubnumb=0;
for(ijsub=1; ijsub<statscomp+1; ijsub++){
statsubind=statsubind+(5+3*analysedchannels)*subcompcounts[ijsub];
statsubnumb=statsubnumb+subcompcounts[ijsub];
}
numerospot=0;
statrecalc=newArray(analysedchannels+1);
if(!(arrayend[statscomp+1]<subcompcounts[statscomp+1])){
condition=false;
} else {
condition=(cellIndex[statsubnumb+arrayend[statscomp+1]]==i);
}
while(condition){
numerospot=numerospot+distancegateweights[subcompcounts[0]+statsubnumb+arrayend[statscomp+1]]*activegateweights[subcompcounts[0]+statsubnumb+arrayend[statscomp+1]];
for(subcompchind=0; subcompchind<1+analysedchannels; subcompchind++){
statrecalc[subcompchind]=statrecalc[subcompchind]+distancegateweights[subcompcounts[0]+statsubnumb+arrayend[statscomp+1]]*activegateweights[subcompcounts[0]+statsubnumb+arrayend[statscomp+1]]*datatable[subcompcounts[0]*analysedparameters+statsubind+arrayend[statscomp+1]*(5+3*analysedchannels)+3+3*subcompchind];
}
arrayend[statscomp+1]=arrayend[statscomp+1]+1;
if(!(arrayend[statscomp+1]<subcompcounts[statscomp+1])){
condition=false;
} else {
condition=(cellIndex[statsubnumb+arrayend[statscomp+1]]==i);
}
}
datatable[jstats+i*analysedparameters]=numerospot;

for(subcompchind=0; subcompchind<1+analysedchannels; subcompchind++){
if(numerospot!=0){
datatable[jstats+1+3*subcompchind+i*analysedparameters]=statrecalc[subcompchind]/numerospot;
datatable[jstats+2+3*subcompchind+i*analysedparameters]=statrecalc[subcompchind];
datatable[jstats+3+3*subcompchind+i*analysedparameters]=100*statrecalc[subcompchind]/datatable[3+3*subcompchind+i*analysedparameters];
} else {
datatable[jstats+1+3*subcompchind+i*analysedparameters]=0;
datatable[jstats+2+3*subcompchind+i*analysedparameters]=0;
datatable[jstats+3+3*subcompchind+i*analysedparameters]=0;
}
}
jstats=jstats+3*(analysedchannels+1);
}
}
}
for(ch=0; ch<addchratio; ch++){
datatable[availablechind[ch+addZfileindex]+analysedparameters*i]=(axnum[ch]*datatable[ratioxnum[ch]+analysedparameters*i]+bxnum[ch])/(axden[ch]*datatable[ratioxden[ch]+analysedparameters*i]+bxden[ch]);
//print("ratio function at "+availablechind[addZfileindex+ch]+": "+datatable[availablechind[addZfileindex+ch]+analysedparameters*i]);
if(isNaN(datatable[availablechind[ch]+analysedparameters*i])){
datatable[availablechind[ch]+analysedparameters*i]=0;
}
//rawdatatable[availablechind[ch]+analysedparameters*(i-1)]=datatable[availablechind[ch]+analysedparameters*(i-1)];
if(i==1){
automaximum[availablechind[ch]]=datatable[availablechind[ch]];
maximum[availablechind[ch]]=automaximum[availablechind[ch]];
} 
if(datatable[availablechind[ch]+analysedparameters*i]>automaximum[availablechind[ch]]){
automaximum[availablechind[ch]]=datatable[availablechind[ch]+analysedparameters*i];
maximum[availablechind[ch]]=automaximum[availablechind[ch]];
}

}
}
}
//////////////////////end of recalculation of the subcomp-derived cell parameters//////////////////////////////////////


