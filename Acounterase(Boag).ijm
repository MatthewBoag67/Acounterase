
do {
//------------------------------------------------------------------------
//split
alpha = getInfo("image.directory");
beta = getInfo("image.filename");
	setBatchMode(false);
	
		rename("BeachBois");
			run("Split Channels");
				selectWindow("C1-BeachBois");
					rename("Nuclei");
						selectWindow("C2-BeachBois");
							rename("488");
								selectWindow("C3-BeachBois");
									rename("647");
									selectWindow("C4-BeachBois");
										close();
	run("Set Measurements...", "area add redirect=None decimal=3");
	run("3D OC Options", "volume surface nb_of_obj._voxels nb_of_surf._voxels dots_size=5 font_size=10 store_results_within_a_table_named_after_the_image_(macro_friendly) redirect_to=none");

//------------------------------------------------------------------------
//bright
		selectWindow("647");	
			//Sourced: Biovoxxel (Jan Brocher) biovoxxel Community Forum Team member (https://forum.image.sc/t/maximum-intensity-z-project-alters-values-randomly/2193)
				brightestMean = 0;
					brightestSlice = 1;
						for(i=1; i<nSlices; i++) {
							setSlice(i);
								getStatistics(area, mean);
						if(brightestMean<mean) {
								brightestMean = mean;
									brightestSlice = i;
										}
									}
						setSlice(brightestSlice);


//------------------------------------------------------------------------
//Nuclei
selectWindow("Nuclei");
run("Duplicate...", "title=NucleiMask stack duplicate");
run("Z Project...", "projection=[Max Intensity]");
run("Convert to Mask", "Otsu stack dark");
selectWindow("Nuclei");
run("Duplicate...", "title=Nuclei+ stack duplicate");
run("Enhance Contrast...", "saturated=1 process_all use");
run("Z Project...", "projection=[Max Intensity]");
run("Subtract Background...", "rolling=100");
rename("Nuclei4Counting");
saveAs("PNG", alpha + beta + "Nuclei4Counting.png");
close();
selectWindow("Nuclei");


//------------------------------------------------------------------------
//647 ID

selectWindow("647");

run("Duplicate...", "title=647Co stack duplicate");
setSlice(brightestSlice);
selectWindow("647");
	 rename("FSubtract");
		run("Duplicate...", "title=FStandard stack duplicate");
			//	run("Subtract Background...", "rolling=21 sliding disable stack");
					run("Subtract Background...", "rolling=28 stack");
					run("Subtract Background...", "rolling=21 stack");
					run("Duplicate...", "title=647Merge stack duplicate");
					
						
			selectWindow("FSubtract");
				run("Subtract Background...", "rolling=4 stack");
				//run("Subtract Background...", "rolling=4 stack");
				
					
					
			imageCalculator("Add create stack", "FSubtract", "FStandard");
//------------------------------------------------------------------------
//647 qunat
					setSlice(brightestSlice);
						setAutoThreshold("Default dark");
							//run("Threshold...");
								resetThreshold(); 
								rename("647");
						run("Duplicate...", "title=647ForSave stack duplicate");
				selectWindow("647");

		factorFr = 2;

	setAutoThreshold("IJ_IsoData dark");
getThreshold(lower, upper);
setThreshold(lower*factorFr, upper);
run("Convert to Mask", "method=IJ_IsoData background=Dark black");

rename("FrSmall");
getStatistics(area, mean, min, max, std, histogram);
		if (max < 128) threshold = max;
			else threshold = 128;
run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=250 " + "statistics summary");
		selectWindow("Statistics for FrSmall");
		saveAs("Results", alpha + beta + "FrSmall.csv");
	
selectWindow("FrSmall");
rename("FrLarge");
run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=251 max.=2124276 " + "statistics summary");
		selectWindow("Statistics for FrLarge");
		saveAs("Results", alpha + beta + "FrLarge.csv");




//------------------------------------------------------------------------
		
//488 ID


selectWindow("488");
setSlice(brightestSlice);
run("Duplicate...", "title=488Co stack duplicate");
selectWindow("488");
	 rename("LSubtract");
		run("Duplicate...", "title=LStandard stack duplicate");
			//	run("Subtract Background...", "rolling=21 sliding disable stack");
					run("Subtract Background...", "rolling=21 stack");
					run("Subtract Background...", "rolling=21 stack");
					
					
						
			selectWindow("LSubtract");
				run("Subtract Background...", "rolling=2 stack");
				run("Subtract Background...", "rolling=2 stack");
				
					
					
			imageCalculator("Add create stack", "LSubtract", "LStandard");


					setSlice(brightestSlice);
						setAutoThreshold("Default dark");
							//run("Threshold...");
								resetThreshold(); 
								rename("488");
						run("Duplicate...", "title=488ForSave stack duplicate");
				selectWindow("488");


				factorLC = 2.5;

	setAutoThreshold("IJ_IsoData dark");
getThreshold(lower, upper);
setThreshold(lower*factorLC, upper);
run("Convert to Mask", "method=IJ_IsoData background=Dark black");

rename("LC3");
getStatistics(area, mean, min, max, std, histogram);
		if (max < 128) threshold = max;
			else threshold = 128;
run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=5 max.=999999 " + "statistics summary");
		selectWindow("Statistics for LC3");
		saveAs("Results", alpha + beta + "Asyn.csv");

selectWindow("Log");
	saveAs("text", alpha + "Log");
	run("Close");
//------------------------------------------------------------------------
//colocal
selectWindow("647Co");
makeOval(136, 158, 306, 282);
roiManager("Add");
makeOval(590, 178, 306, 282);
roiManager("Add");
makeOval(338, 316, 306, 282);
roiManager("Add");
makeOval(138, 522, 306, 282);
roiManager("Add");
makeOval(578, 520, 306, 282);
roiManager("Add");



run("Coloc 2", "channel_1=647Co channel_2=488Co roi_or_mask=[ROI Manager] threshold_regression=Bisection psf=3 costes_randomisations=1");

roiManager("delete");
selectWindow("Log");

	saveAs("text", alpha + "Colocal");
	selectWindow("Log");
	run("Close");


run("Coloc 2", "channel_1=647Co channel_2=NucleiMask roi_or_mask=[MAX_NucleiMask] threshold_regression=Bisection psf=3 costes_randomisations=1");


selectWindow("Log");

	saveAs("text", alpha + beta + "NucleiColocal");
	selectWindow("Log");
	run("Close");

run("Merge Channels...", "c1=647ForSave c2=488ForSave c3=Nuclei create");
	saveAs("tif", alpha + beta + "Merged Image");
	close();

if (isOpen("LC3.csv") == true) 
	{ selectWindow("LC3.csv");
	run("Close");}
if (isOpen("LC3") == true) 
	{ selectWindow("LC3");
	run("Close");}
if (isOpen("FrLarge") == true) 
	{ selectWindow("FrLarge");
	run("Close");}
if (isOpen("FrLarge.csv") == true) 
	{ selectWindow("FrLarge.csv");
	run("Close");}
if (isOpen("FrSmall.csv") == true) 
	{ selectWindow("FrSmall.csv");
	run("Close");}
if (isOpen("FrSmall") == true) 
	{ selectWindow("FrSmall");
	run("Close");}
if (isOpen("LC3.csv") == true) 
	{ selectWindow("LC3.csv");
	run("Close");}

if (isOpen("LC3.csv") == true) 
	{ selectWindow("LC3.csv");
	run("Close");}
	
if (isOpen("488Co") == true) 
	{ selectWindow("488Co");
	run("Close");}
if (isOpen("NucleiMask") == true) 
	{ selectWindow("NucleiMask");
	run("Close");}
if (isOpen("MAX_NucleiMask") == true) 
	{ selectWindow("MAX_NucleiMask");
	run("Close");}
if (isOpen("Nuclei+") == true) 
	{ selectWindow("Nuclei+");
	run("Close");}
if (isOpen("647ForSave") == true) 
	{ selectWindow("647ForSave");
	run("Close");}
if (isOpen("488ForSave") == true) 
	{ selectWindow("488ForSave");
	run("Close");}
if (isOpen("Nuclei") == true) 
	{ selectWindow("Nuclei");
	run("Close");}
if (isOpen("FrLarge") == true) 
	{ selectWindow("FrLarge");
	run("Close");}
if (isOpen("488") == true) 
	{ selectWindow("488");
	run("Close");}	
if (isOpen("647") == true) 
	{ selectWindow("647");
	run("Close");}
if (isOpen("FSubtract") == true) 
	{ selectWindow("FSubtract");
	run("Close");}
if (isOpen("LSubtract") == true) 
	{ selectWindow("LSubtract");
	run("Close");}
if (isOpen("FStandard") == true) 
	{ selectWindow("FStandard");
	run("Close");}
if (isOpen("LStandard") == true) 
	{ selectWindow("LStandard");
	run("Close");}
if (isOpen("647Merge") == true) 
	{ selectWindow("647Merge");
	run("Close");}
if (isOpen("488Merge") == true) 
	{ selectWindow("488Merge");
	run("Close");}
if (isOpen("647Co") == true) 
	{ selectWindow("647Co");
	run("Close");}
if (isOpen("488Co") == true) 
	{ selectWindow("488Co");
	run("Close");}
rename("BeachBois");
}
while (isOpen("BeachBois") == true);





