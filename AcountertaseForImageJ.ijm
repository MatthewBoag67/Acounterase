
if (isOpen("a.nd2") == true) {

selectWindow("a.nd2");
alpha = getInfo("image.directory");
	setBatchMode(false);
		rename("BeachBois");
			run("Split Channels");
				selectWindow("C1-BeachBois");
					rename("Nuclei");
						selectWindow("C2-BeachBois");
							rename("488");
								selectWindow("C3-BeachBois");
									rename("647");
	run("Set Measurements...", "area add redirect=None decimal=3");
	run("3D OC Options", "volume surface nb_of_obj._voxels nb_of_surf._voxels dots_size=5 font_size=10 store_results_within_a_table_named_after_the_image_(macro_friendly) redirect_to=none");

	run("Coloc 2", "channel_1=647 channel_2=488 roi_or_mask=<None> threshold_regression=Bisection psf=3 costes_randomisations=1");
		selectWindow("Log");
			saveAs("Txt", alpha + "Colocal");
				run("Close");

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
		
//647 Identification
	 rename("FSubtract");
			run("Duplicate...", "title=FStandard stack duplicate");
				run("Subtract Background...", "rolling=21 sliding disable stack");
					run("Subtract Background...", "rolling=21 stack");
						run("Duplicate...", "title=647Merge stack duplicate");
						
			selectWindow("FSubtract");
				run("Subtract Background...", "rolling=5 stack");
				run("Subtract Background...", "rolling=5 stack");
					
					
			imageCalculator("Add create stack", "FSubtract", "FStandard");
				

					setSlice(brightestSlice);
						setAutoThreshold("Default dark");
							//run("Threshold...");
								resetThreshold(); 
								rename("647");
															run("Duplicate...", "title=647ForSave stack duplicate");
															selectWindow("647");

			setAutoThreshold("IsoData dark");
				//run("Threshold...");
					setAutoThreshold("IsoData dark");
						setOption("BlackBackground", true);
							run("Convert to Mask", "method=IsoData background=Dark black");

//647 Counting (0-1)
	run("Analyze Particles...", "size=0.1-1 show=[Masks] stack");
		rename("Ferritin0-1");
		getStatistics(area, mean, min, max, std, histogram);
			if (max < 128) threshold = max;
				else threshold = 128;
					run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
						setSlice(brightestSlice);
						
	 setAutoThreshold("Default dark");
		//run("Threshold...");
			setAutoThreshold("Default dark stack");
				setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Ferritin:0-1 stack duplicate");	
				run("16-bit");	
				selectWindow("Objects map of Ferritin0-1");
															run("Duplicate...", "title=Ferritin0-1BinaryForSave stack duplicate");
															selectWindow("Objects map of Ferritin0-1");

						run("Outline", "stack Yes");
							rename("FerritinOutlines0");
								run("16-bit");
															run("Duplicate...", "title=FerritinOutlines0ForSave stack duplicate");

		
//647 Counting (1-Infinity)		
	selectWindow("647");
		run("Analyze Particles...", "size=1.001-Infinity show=[Masks] stack");
			rename("Ferritin1+");
		
		getStatistics(area, mean, min, max, std, histogram);
			if (max < 128) threshold = max;
				else threshold = 128;
					run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
						setSlice(brightestSlice);
	
	selectWindow("Objects map of Ferritin1+");		
		 setAutoThreshold("Default dark");
			//run("Threshold...");
				setAutoThreshold("Default dark stack");
					setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");	
			run("Duplicate...", "title=Ferritin:1+ stack duplicate");				
				selectWindow("Objects map of Ferritin1+");
															run("Duplicate...", "title=Ferritin1+BinaryForSave stack duplicate");
															selectWindow("Objects map of Ferritin1+");
					
					run("Outline", "stack Yes");
						rename("FerritinOutlines1+");
							run("16-bit");
															run("Duplicate...", "title=FerritinOutlines1+ForSave stack duplicate");


//Asyn Preparation
	selectWindow("488");
		setSlice(brightestSlice);
			rename("ASubtract");
			
	run("Duplicate...", "title=AStandard stack duplicate");
		run("Subtract Background...", "rolling=21 stack sliding disable");
			run("Subtract Background...", "rolling=21 stack");
				run("Duplicate...", "title=488Merge stack duplicate");
				
	selectWindow("ASubtract");
		run("Subtract Background...", "rolling=2 stack");
			run("Subtract Background...", "rolling=2 stack");
														


				
	imageCalculator("Add create stack", "ASubtract", "AStandard");
		setSlice(brightestSlice);
			setAutoThreshold("Default dark");
				//run("Threshold...");
					resetThreshold();
						setSlice(brightestSlice);
						rename("488x");
													run("Duplicate...", "title=AsynSubtractedForSave stack duplicate");
													selectWindow("488x");

	setAutoThreshold("Default dark");
		//run("Threshold...");
			run("Convert to Mask", "method=Triangle background=Dark black");
				rename("488");

//488 Counting 0.5-1
	selectWindow("488");
		run("Analyze Particles...", "size=0.5-1 show=[Masks] stack");
			rename("A0.5-1");
		
	getStatistics(area, mean, min, max, std, histogram);
	  if (max < 128) threshold = max;
	 	 else threshold = 128;
	 		 run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");

	selectWindow("Objects map of A0.5-1");
		setSlice(brightestSlice);		
		 setAutoThreshold("Default dark");
			//run("Threshold...");
				setAutoThreshold("Default dark stack");
					setThreshold(1, 65535);
					
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
										run("Duplicate...", "title=Asyn0.5-1 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A0.5-1");
															run("Duplicate...", "title=A0.5-1ForSave stack duplicate");
															selectWindow("Objects map of A0.5-1");
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:0.5-1");
															run("Duplicate...", "title=AsynOutlines0.5-1ForSave stack duplicate");
															
						
//488 Counting 1-2
	selectWindow("488");
		run("Analyze Particles...", "size=1.001-2 show=[Masks] stack");
			rename("A1-2");
			
	getStatistics(area, mean, min, max, std, histogram);
	  if (max < 128) threshold = max;
		else threshold = 128;
	 		run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
				setSlice(brightestSlice);
		
	selectWindow("Objects map of A1-2");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn1-2 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A1-2");
															run("Duplicate...", "title=A1-2ForSave stack duplicate");
															selectWindow("Objects map of A1-2");
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:1-2");
															run("Duplicate...", "title=AsynOutlines1-2ForSave stack duplicate");
															

//488 Counting 2-4
selectWindow("488");
	run("Analyze Particles...", "size=2.001-4 show=[Masks] stack");
		rename("A2-4");
		
	getStatistics(area, mean, min, max, std, histogram);
		if (max < 128) threshold = max;
			else threshold = 128;
				run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
					setSlice(brightestSlice);

	selectWindow("Objects map of A2-4");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn2-4 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A2-4");
															run("Duplicate...", "title=A2-4ForSave stack duplicate");
															selectWindow("Objects map of A2-4");
																				
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:2-4");
															run("Duplicate...", "title=AsynOutlines2-4ForSave stack duplicate");
																						

//488 Counting 4+
selectWindow("488");
	run("Analyze Particles...", "size=4.001-Infinity show=[Masks] stack");
		rename("A4+");
		
	getStatistics(area, mean, min, max, std, histogram);
		if (max < 128) threshold = max;
			else threshold = 128;
				run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
					setSlice(brightestSlice);

	selectWindow("Objects map of A4+");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn4+ stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A4+");
															run("Duplicate...", "title=A4+ForSave stack duplicate");
															selectWindow("Objects map of A4+");
															
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:4+");
															run("Duplicate...", "title=AsynOutlines4+ForSave stack duplicate");
															
	imageCalculator("Add create stack", "Asyn2-4", "Asyn4+");
			rename("bing");	
	imageCalculator("Add create stack", "Asyn0.5-1", "Asyn1-2");	
			rename("ting");
	imageCalculator("Add create stack", "bing", "ting");
			rename("bingting");															


//Merging & Saving Images
	run("Merge Channels...", "c4=[FerritinOutlines0] c1=[647Merge] c7=[FerritinOutlines1+] create keep");
		rename("aFerritinOutlinesA");
															
															saveAs("Tiff", alpha + "aFerritinOutlinesA");
															close();
														
	selectWindow("Ferritin:0-1");
		run("16-bit");
			selectWindow("Ferritin:1+");
				run("16-bit");
	run("Merge Channels...", "c4=[Ferritin:0-1] c1=[Ferritin:1+] c3=Nuclei create keep");
		rename("aFerritinBinaryB");
															
															saveAs("Tiff", alpha + "aFerritinBinaryB");
															close();
													
	
	selectWindow("bing");
		run("16-bit");	
			run("Merge Channels...", "c4=[Ferritin:0-1] c2=bing c1=[Ferritin:1+] create keep");
				rename("aFerritin+AsynTotalC");
															
															saveAs("Tiff", alpha + "aFerritin+AsynTotalC");
															close();
														
															

	selectWindow("bingting");
		run("16-bit");	
			run("Merge Channels...", "c1=647Merge c2=488Merge c3=Nuclei c4=bingting create keep");
				rename("aWholeMergD");
															
															saveAs("Tiff", alpha + "aWholeMergD");
															close();
													
		
	run("Merge Channels...", "c1=647Merge c2=488Merge c3=Nuclei c4=[Asyn:0.5-1] c5=[Asyn:1-2] c6=[Asyn:2-4] c7=[Asyn:4+] create keep");
		rename("aSegmentedMergE");
															
															saveAs("Tiff", alpha + "aSegmentedMergE");
															close();
													

//Saving & Closingn Relavent Windows
if (isOpen("Ferritin0-1BinaryForSave") == true) {
															selectWindow("Ferritin0-1BinaryForSave");	
																	saveAs("Tiff", alpha + "FerritinBinary0");
															}
if (isOpen("FerritinOutlines0ForSave") == true) {	
															selectWindow("FerritinOutlines0ForSave");	
																	saveAs("Tiff", alpha + "Ferritin0-1");
}
if (isOpen("Ferritin1+BinaryForSave") == true) {	
															selectWindow("Ferritin1+BinaryForSave");	
																	saveAs("Tiff", alpha + "FerritinOutlines0");
}
if (isOpen("FerritinOutlines1+ForSave") == true) {
															selectWindow("FerritinOutlines1+ForSave");	
																	saveAs("Tiff", alpha + "Ferritin1+");
}
if (isOpen("647ForSave") == true) {
															selectWindow("647ForSave");	
																	saveAs("Tiff", alpha + "FerritinOutlines1");
}
if (isOpen("AsynSubtractedForSave") == true) {
															selectWindow("AsynSubtractedForSave");	
																	saveAs("Tiff", alpha + "AsynTouchedUp");
}
if (isOpen("A0.5-1ForSave") == true) {
															selectWindow("A0.5-1ForSave");	
																	saveAs("Tiff", alpha + "A0.5-1");
}
if (isOpen("AsynOutlines0.5-1ForSave") == true) {
															selectWindow("AsynOutlines0.5-1ForSave");	
																	saveAs("Tiff", alpha + "AsynOutlines0.5-1");
}
if (isOpen("A1-2ForSave") == true) {
															selectWindow("A1-2ForSave");	
																	saveAs("Tiff", alpha + "A1-2");
}
if (isOpen("AsynOutlines1-2ForSave") == true) {
															selectWindow("AsynOutlines1-2ForSave");	
																	saveAs("Tiff", alpha + "AsynOutlines1-2");
}
if (isOpen("A2-4ForSave") == true) {	
															selectWindow("A2-4ForSave");	
																	saveAs("Tiff", alpha + "A2-4");
}
if (isOpen("AsynOutlines2-4ForSave") == true) {		
														selectWindow("AsynOutlines2-4ForSave");	
																	saveAs("Tiff", alpha + "AsynOutlines2-4");
}
if (isOpen("A4+ForSave") == true) {	
															selectWindow("A4+ForSave");	
																	saveAs("Tiff", alpha + "A4+");
}
if (isOpen("AsynOutlines4+ForSave") == true) {
															selectWindow("AsynOutlines4+ForSave");	
																	saveAs("Tiff", alpha + "AsynOutlines4+");
}
															
														
	
//saving log and statistics
	selectWindow("Log");	
		{
			saveAs("Text", alpha + "Counts");
				
		} 
		run("Close");
	
	selectWindow("Statistics for A4+");	
		{
			saveAs("Results", alpha + "Statistics for A4+");
				
		}
		run("Close");
	
	selectWindow("Statistics for A2-4");	
		{
			saveAs("Results", alpha + "Statistics for A2-4");
				
		}
		run("Close");
	
	selectWindow("Statistics for A1-2");	
		{
			saveAs("Results", alpha + "Statistics for A1-2");
				
		}
		run("Close");
		
	selectWindow("Statistics for A0.5-1");	
		{
			saveAs("Results", alpha + "Statistics for A0.5-1");
				
		}
		run("Close");
	
	selectWindow("Statistics for Ferritin1+");	
		{
			saveAs("Results", alpha + "Statistics for Ferritin1+");
				
		}
		run("Close");
	
	selectWindow("Statistics for Ferritin0-1");	
		{
			saveAs("Results", alpha + "Statistics for Ferritin0-1");
				
		}
		run("Close");

selectWindow("Nuclei");
run("Z Project...", "projection=[Max Intensity]");
rename("NucleiA");
saveAs("tif", alpha + "Nuclei for Counting");

if (isOpen("Nuclei") == true) {
	selectWindow("Nuclei");
		run("Close");
}
	if (isOpen("Nuclei for Counting.tif") == true) {
	selectWindow("Nuclei for Counting.tif");
		run("Close");
}
	if (isOpen("FSubtract") == true) {
		selectWindow("FSubtract");	
			run("Close");
	}
	if (isOpen("FStandard") == true) {
		selectWindow("FStandard");	
			run("Close");
	}
		if (isOpen("647") == true) {
		selectWindow("647");	
			run("Close");
	}
		if (isOpen("Ferritin0-1") == true) {
		selectWindow("Ferritin0-1");	
			run("Close");
	}
		if (isOpen("FerritinOutlines0") == true) {
		selectWindow("FerritinOutlines0");	
			run("Close");
	}
		if (isOpen("Ferritin1+") == true) {
		selectWindow("Ferritin1+");	
			run("Close");
	}
		if (isOpen("FerritinOutlines1+") == true) {
		selectWindow("FerritinOutlines1+");	
			run("Close");
	}
		if (isOpen("488") == true) {
		selectWindow("488");	
			run("Close");
	}
		if (isOpen("ASubtract") == true) {
		selectWindow("ASubtract");	
			run("Close");
	}
		if (isOpen("AStandard") == true) {
		selectWindow("AStandard");	
			run("Close");
	}
		if (isOpen("488x") == true) {
		selectWindow("488x");	
			run("Close");
	}
		if (isOpen("A0.5-1") == true) {
		selectWindow("A0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn0.5-1") == true) {
		selectWindow("Asyn0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn:0.5-1") == true) {
		selectWindow("Asyn:0.5-1");	
			run("Close");
	}
		if (isOpen("A1-2") == true) {
		selectWindow("A1-2");	
			run("Close");
	}	
	if (isOpen("Asyn1-2") == true) {
		selectWindow("Asyn1-2");	
			run("Close");
	}
		if (isOpen("Asyn:1-2") == true) {
		selectWindow("Asyn:1-2");	
			run("Close");
	}
		if (isOpen("A2-4") == true) {
		selectWindow("A2-4");	
			run("Close");
	}	
			if (isOpen("A2-4.tif") == true) {
		selectWindow("A2-4.tif");	
			run("Close");
	}	
	if (isOpen("Asyn:2-4") == true) {
		selectWindow("Asyn:2-4");	
			run("Close");
	}
	if (isOpen("Asyn2-4") == true) {
		selectWindow("Asyn2-4");	
			run("Close");
	}	
	if (isOpen("A4+") == true) {
		selectWindow("A4+");	
			run("Close");
	}	
	if (isOpen("Asyn4+") == true) {
		selectWindow("Asyn4+");	
			run("Close");
	}
		if (isOpen("Asyn:4+") == true) {
		selectWindow("Asyn:4+");	
			run("Close");
	}
		if (isOpen("AsynOutlines4+.tif") == true) {
		selectWindow("AsynOutlines4+.tif");	
			run("Close");
	}
		if (isOpen("AsynOutlines2-4.tif") == true) {
		selectWindow("AsynOutlines2-4.tif");	
			run("Close");
	}
		if (isOpen("A4+.tif") == true) {
		selectWindow("A4+.tif");	
			run("Close");
	}
		if (isOpen("647Merge") == true) {
		selectWindow("647Merge");	
			run("Close");
	}
			if (isOpen("AsynOutlines1-2.tif") == true) {
		selectWindow("AsynOutlines1-2.tif");	
			run("Close");
	}
			if (isOpen("A1-2.tif") == true) {
		selectWindow("A1-2.tif");	
			run("Close");
	}
			if (isOpen("AsynOutlines0.5-1.tif") == true) {
		selectWindow("AsynOutlines0.5-1.tif");	
			run("Close");
	}
			if (isOpen("A0.5-1.tif") == true) {
		selectWindow("A0.5-1.tif");	
			run("Close");
	}
			if (isOpen("AsynTouchedUp.tif") == true) {
		selectWindow("AsynTouchedUp.tif");	
			run("Close");
	}
			if (isOpen("FerritinOutlines1.tif") == true) {
		selectWindow("FerritinOutlines1.tif");	
			run("Close");
	}
				if (isOpen("Ferritin1+.tif") == true) {
		selectWindow("Ferritin1+.tif");	
			run("Close");
	}
				if (isOpen("FerritinOutlines0.tif") == true) {
		selectWindow("FerritinOutlines0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin0-1.tif") == true) {
		selectWindow("Ferritin0-1.tif");	
			run("Close");
	}
				if (isOpen("FerritinBinary0.tif") == true) {
		selectWindow("FerritinBinary0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin:1+") == true) {
		selectWindow("Ferritin:1+");	
			run("Close");
	}
				if (isOpen("Ferritin:0-1") == true) {
		selectWindow("Ferritin:0-1");	
			run("Close");
	}
				if (isOpen("488Merge") == true) {
		selectWindow("488Merge");	
			run("Close");
	}
		if (isOpen("bing") == true) {
		selectWindow("bing");	
			run("Close");
	}
		if (isOpen("ting") == true) {
		selectWindow("ting");	
			run("Close");
	}	if (isOpen("bingting") == true) {
		selectWindow("bingting");	
			run("Close");
	}
	if (isOpen("FSubtract") == true) {
		selectWindow("FSubtract");	
			run("Close");
	}
	if (isOpen("FStandard") == true) {
		selectWindow("FStandard");	
			run("Close");
	}
		if (isOpen("647") == true) {
		selectWindow("647");	
			run("Close");
	}
		if (isOpen("Ferritin0-1") == true) {
		selectWindow("Ferritin0-1");	
			run("Close");
	}
		if (isOpen("FerritinOutlines0") == true) {
		selectWindow("FerritinOutlines0");	
			run("Close");
	}
		if (isOpen("Ferritin1+") == true) {
		selectWindow("Ferritin1+");	
			run("Close");
	}
		if (isOpen("FerritinOutlines1+") == true) {
		selectWindow("FerritinOutlines1+");	
			run("Close");
	}
		if (isOpen("488") == true) {
		selectWindow("488");	
			run("Close");
	}
		if (isOpen("ASubtract") == true) {
		selectWindow("ASubtract");	
			run("Close");
	}
		if (isOpen("AStandard") == true) {
		selectWindow("AStandard");	
			run("Close");
	}
		if (isOpen("488x") == true) {
		selectWindow("488x");	
			run("Close");
	}
		if (isOpen("A0.5-1") == true) {
		selectWindow("A0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn0.5-1") == true) {
		selectWindow("Asyn0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn:0.5-1") == true) {
		selectWindow("Asyn:0.5-1");	
			run("Close");
	}
		if (isOpen("A1-2") == true) {
		selectWindow("A1-2");	
			run("Close");
	}	
	if (isOpen("Asyn1-2") == true) {
		selectWindow("Asyn1-2");	
			run("Close");
	}
		if (isOpen("Asyn:1-2") == true) {
		selectWindow("Asyn:1-2");	
			run("Close");
	}
		if (isOpen("A2-4") == true) {
		selectWindow("A2-4");	
			run("Close");
	}	
			if (isOpen("A2-4.tif") == true) {
		selectWindow("A2-4.tif");	
			run("Close");
	}	
	if (isOpen("Asyn:2-4") == true) {
		selectWindow("Asyn:2-4");	
			run("Close");
	}
	if (isOpen("Asyn2-4") == true) {
		selectWindow("Asyn2-4");	
			run("Close");
	}	
	if (isOpen("A4+") == true) {
		selectWindow("A4+");	
			run("Close");
	}	
	if (isOpen("Asyn4+") == true) {
		selectWindow("Asyn4+");	
			run("Close");
	}
		if (isOpen("Asyn:4+") == true) {
		selectWindow("Asyn:4+");	
			run("Close");
	}
		if (isOpen("AsynOutlines4+.tif") == true) {
		selectWindow("AsynOutlines4+.tif");	
			run("Close");
	}
		if (isOpen("AsynOutlines2-4.tif") == true) {
		selectWindow("AsynOutlines2-4.tif");	
			run("Close");
	}
		if (isOpen("A4+.tif") == true) {
		selectWindow("A4+.tif");	
			run("Close");
	}
		if (isOpen("647Merge") == true) {
		selectWindow("647Merge");	
			run("Close");
	}
			if (isOpen("AsynOutlines1-2.tif") == true) {
		selectWindow("AsynOutlines1-2.tif");	
			run("Close");
	}
			if (isOpen("A1-2.tif") == true) {
		selectWindow("A1-2.tif");	
			run("Close");
	}
			if (isOpen("AsynOutlines0.5-1.tif") == true) {
		selectWindow("AsynOutlines0.5-1.tif");	
			run("Close");
	}
			if (isOpen("A0.5-1.tif") == true) {
		selectWindow("A0.5-1.tif");	
			run("Close");
	}
			if (isOpen("AsynTouchedUp.tif") == true) {
		selectWindow("AsynTouchedUp.tif");	
			run("Close");
	}
			if (isOpen("FerritinOutlines1.tif") == true) {
		selectWindow("FerritinOutlines1.tif");	
			run("Close");
	}
				if (isOpen("Ferritin1+.tif") == true) {
		selectWindow("Ferritin1+.tif");	
			run("Close");
	}
				if (isOpen("FerritinOutlines0.tif") == true) {
		selectWindow("FerritinOutlines0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin0-1.tif") == true) {
		selectWindow("Ferritin0-1.tif");	
			run("Close");
	}
				if (isOpen("FerritinBinary0.tif") == true) {
		selectWindow("FerritinBinary0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin:1+") == true) {
		selectWindow("Ferritin:1+");	
			run("Close");
	}
				if (isOpen("Ferritin:0-1") == true) {
		selectWindow("Ferritin:0-1");	
			run("Close");
	}
				if (isOpen("488Merge") == true) {
		selectWindow("488Merge");	
			run("Close");
	}
		if (isOpen("bing") == true) {
		selectWindow("bing");	
			run("Close");
	}
		if (isOpen("ting") == true) {
		selectWindow("ting");	
			run("Close");
	}	if (isOpen("bingting") == true) {
		selectWindow("bingting");	
			run("Close");
	}
}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if (isOpen("b.nd2") == true) {

selectWindow("b.nd2");
beta = getInfo("image.directory");
	setBatchMode(false);
		rename("BeachBois");
			run("Split Channels");
				selectWindow("C1-BeachBois");
					rename("Nuclei");
						selectWindow("C2-BeachBois");
							rename("488");
								selectWindow("C3-BeachBois");
									rename("647");
	run("Set Measurements...", "area add redirect=None decimal=3");
	run("3D OC Options", "volume surface nb_of_obj._voxels nb_of_surf._voxels dots_size=5 font_size=10 store_results_within_a_table_named_after_the_image_(macro_friendly) redirect_to=none");

	run("Coloc 2", "channel_1=647 channel_2=488 roi_or_mask=<None> threshold_regression=Bisection psf=3 costes_randomisations=1");
		selectWindow("Log");
			saveAs("Txt", beta + "Colocal");
				run("Close");

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
		
//647 Identification
	 rename("FSubtract");
			run("Duplicate...", "title=FStandard stack duplicate");
				run("Subtract Background...", "rolling=21 sliding disable stack");
					run("Subtract Background...", "rolling=21 stack");
						run("Duplicate...", "title=647Merge stack duplicate");
						
			selectWindow("FSubtract");
				run("Subtract Background...", "rolling=5 stack");
				run("Subtract Background...", "rolling=5 stack");
					
					
			imageCalculator("Add create stack", "FSubtract", "FStandard");
				

					setSlice(brightestSlice);
						setAutoThreshold("Default dark");
							//run("Threshold...");
								resetThreshold(); 
								rename("647");
															run("Duplicate...", "title=647ForSave stack duplicate");
															selectWindow("647");

			setAutoThreshold("IsoData dark");
				//run("Threshold...");
					setAutoThreshold("IsoData dark");
						setOption("BlackBackground", true);
							run("Convert to Mask", "method=IsoData background=Dark black");

//647 Counting (0-1)
	run("Analyze Particles...", "size=0.1-1 show=[Masks] stack");
		rename("Ferritin0-1");
		getStatistics(area, mean, min, max, std, histogram);
			if (max < 128) threshold = max;
				else threshold = 128;
					run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
						setSlice(brightestSlice);
						
	 setAutoThreshold("Default dark");
		//run("Threshold...");
			setAutoThreshold("Default dark stack");
				setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Ferritin:0-1 stack duplicate");	
			run("16-bit");		
				selectWindow("Objects map of Ferritin0-1");
															run("Duplicate...", "title=Ferritin0-1BinaryForSave stack duplicate");
															selectWindow("Objects map of Ferritin0-1");

						run("Outline", "stack Yes");
							rename("FerritinOutlines0");
								run("16-bit");
															run("Duplicate...", "title=FerritinOutlines0ForSave stack duplicate");

		
//647 Counting (1-Infinity)		
	selectWindow("647");
		run("Analyze Particles...", "size=1.001-Infinity show=[Masks] stack");
			rename("Ferritin1+");
		
		getStatistics(area, mean, min, max, std, histogram);
			if (max < 128) threshold = max;
				else threshold = 128;
					run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
						setSlice(brightestSlice);
	
	selectWindow("Objects map of Ferritin1+");		
		 setAutoThreshold("Default dark");
			//run("Threshold...");
				setAutoThreshold("Default dark stack");
					setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");	
			run("Duplicate...", "title=Ferritin:1+ stack duplicate");				
				selectWindow("Objects map of Ferritin1+");
															run("Duplicate...", "title=Ferritin1+BinaryForSave stack duplicate");
															selectWindow("Objects map of Ferritin1+");
					
					run("Outline", "stack Yes");
						rename("FerritinOutlines1+");
							run("16-bit");
															run("Duplicate...", "title=FerritinOutlines1+ForSave stack duplicate");


//Asyn Preparation
	selectWindow("488");
		setSlice(brightestSlice);
			rename("ASubtract");
			
	run("Duplicate...", "title=AStandard stack duplicate");
		run("Subtract Background...", "rolling=21 stack sliding disable");
			run("Subtract Background...", "rolling=21 stack");
				run("Duplicate...", "title=488Merge stack duplicate");
				
	selectWindow("ASubtract");
		run("Subtract Background...", "rolling=2 stack");
			run("Subtract Background...", "rolling=2 stack");
														


				
	imageCalculator("Add create stack", "ASubtract", "AStandard");
		setSlice(brightestSlice);
			setAutoThreshold("Default dark");
				//run("Threshold...");
					resetThreshold();
						setSlice(brightestSlice);
						rename("488x");
													run("Duplicate...", "title=AsynSubtractedForSave stack duplicate");
													selectWindow("488x");

	setAutoThreshold("Default dark");
		//run("Threshold...");
			run("Convert to Mask", "method=Triangle background=Dark black");
				rename("488");

//488 Counting 0.5-1
	selectWindow("488");
		run("Analyze Particles...", "size=0.5-1 show=[Masks] stack");
			rename("A0.5-1");
		
	getStatistics(area, mean, min, max, std, histogram);
	  if (max < 128) threshold = max;
	 	 else threshold = 128;
	 		 run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");

	selectWindow("Objects map of A0.5-1");
		setSlice(brightestSlice);		
		 setAutoThreshold("Default dark");
			//run("Threshold...");
				setAutoThreshold("Default dark stack");
					setThreshold(1, 65535);
					
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
										run("Duplicate...", "title=Asyn0.5-1 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A0.5-1");
															run("Duplicate...", "title=A0.5-1ForSave stack duplicate");
															selectWindow("Objects map of A0.5-1");
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:0.5-1");
															run("Duplicate...", "title=AsynOutlines0.5-1ForSave stack duplicate");
															
						
//488 Counting 1-2
	selectWindow("488");
		run("Analyze Particles...", "size=1.001-2 show=[Masks] stack");
			rename("A1-2");
			
	getStatistics(area, mean, min, max, std, histogram);
	  if (max < 128) threshold = max;
		else threshold = 128;
	 		run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
				setSlice(brightestSlice);
		
	selectWindow("Objects map of A1-2");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn1-2 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A1-2");
															run("Duplicate...", "title=A1-2ForSave stack duplicate");
															selectWindow("Objects map of A1-2");
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:1-2");
															run("Duplicate...", "title=AsynOutlines1-2ForSave stack duplicate");
															

//488 Counting 2-4
selectWindow("488");
	run("Analyze Particles...", "size=2.001-4 show=[Masks] stack");
		rename("A2-4");
		
	getStatistics(area, mean, min, max, std, histogram);
		if (max < 128) threshold = max;
			else threshold = 128;
				run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
					setSlice(brightestSlice);

	selectWindow("Objects map of A2-4");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn2-4 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A2-4");
															run("Duplicate...", "title=A2-4ForSave stack duplicate");
															selectWindow("Objects map of A2-4");
																				
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:2-4");
															run("Duplicate...", "title=AsynOutlines2-4ForSave stack duplicate");
																						

//488 Counting 4+
selectWindow("488");
	run("Analyze Particles...", "size=4.001-Infinity show=[Masks] stack");
		rename("A4+");
		
	getStatistics(area, mean, min, max, std, histogram);
		if (max < 128) threshold = max;
			else threshold = 128;
				run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
					setSlice(brightestSlice);

	selectWindow("Objects map of A4+");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn4+ stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A4+");
															run("Duplicate...", "title=A4+ForSave stack duplicate");
															selectWindow("Objects map of A4+");
															
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:4+");
															run("Duplicate...", "title=AsynOutlines4+ForSave stack duplicate");
															
	imageCalculator("Add create stack", "Asyn2-4", "Asyn4+");
			rename("bing");	
	imageCalculator("Add create stack", "Asyn0.5-1", "Asyn1-2");	
			rename("ting");
	imageCalculator("Add create stack", "bing", "ting");
			rename("bingting");															


//Merging & Saving Images
	run("Merge Channels...", "c4=[FerritinOutlines0] c1=[647Merge] c7=[FerritinOutlines1+] create keep");
		rename("aFerritinOutlinesA");
															
															saveAs("Tiff", beta + "aFerritinOutlinesA");
															close();
														
	selectWindow("Ferritin:0-1");
		run("16-bit");
			selectWindow("Ferritin:1+");
				run("16-bit");
	run("Merge Channels...", "c4=[Ferritin:0-1] c1=[Ferritin:1+] c3=Nuclei create keep");
		rename("aFerritinBinaryB");
															
															saveAs("Tiff", beta + "aFerritinBinaryB");
															close();
													
	
	selectWindow("bing");
		run("16-bit");	
			run("Merge Channels...", "c4=[Ferritin:0-1] c2=bing c1=[Ferritin:1+] create keep");
				rename("aFerritin+AsynTotalC");
															
															saveAs("Tiff", beta + "aFerritin+AsynTotalC");
															close();
														
															

	selectWindow("bingting");
		run("16-bit");	
			run("Merge Channels...", "c1=647Merge c2=488Merge c3=Nuclei c4=bingting create keep");
				rename("aWholeMergD");
															
															saveAs("Tiff", beta + "aWholeMergD");
															close();
													
		
	run("Merge Channels...", "c1=647Merge c2=488Merge c3=Nuclei c4=[Asyn:0.5-1] c5=[Asyn:1-2] c6=[Asyn:2-4] c7=[Asyn:4+] create keep");
		rename("aSegmentedMergE");
															
															saveAs("Tiff", beta + "aSegmentedMergE");
															close();
													

//Saving & Closingn Relavent Windows
if (isOpen("Ferritin0-1BinaryForSave") == true) {
															selectWindow("Ferritin0-1BinaryForSave");	
																	saveAs("Tiff", beta + "FerritinBinary0");
															}
if (isOpen("FerritinOutlines0ForSave") == true) {	
															selectWindow("FerritinOutlines0ForSave");	
																	saveAs("Tiff", beta + "Ferritin0-1");
}
if (isOpen("Ferritin1+BinaryForSave") == true) {	
															selectWindow("Ferritin1+BinaryForSave");	
																	saveAs("Tiff", beta + "FerritinOutlines0");
}
if (isOpen("FerritinOutlines1+ForSave") == true) {
															selectWindow("FerritinOutlines1+ForSave");	
																	saveAs("Tiff", beta + "Ferritin1+");
}
if (isOpen("647ForSave") == true) {
															selectWindow("647ForSave");	
																	saveAs("Tiff", beta + "FerritinOutlines1");
}
if (isOpen("AsynSubtractedForSave") == true) {
															selectWindow("AsynSubtractedForSave");	
																	saveAs("Tiff", beta + "AsynTouchedUp");
}
if (isOpen("A0.5-1ForSave") == true) {
															selectWindow("A0.5-1ForSave");	
																	saveAs("Tiff", beta + "A0.5-1");
}
if (isOpen("AsynOutlines0.5-1ForSave") == true) {
															selectWindow("AsynOutlines0.5-1ForSave");	
																	saveAs("Tiff", beta + "AsynOutlines0.5-1");
}
if (isOpen("A1-2ForSave") == true) {
															selectWindow("A1-2ForSave");	
																	saveAs("Tiff", beta + "A1-2");
}
if (isOpen("AsynOutlines1-2ForSave") == true) {
															selectWindow("AsynOutlines1-2ForSave");	
																	saveAs("Tiff", beta + "AsynOutlines1-2");
}
if (isOpen("A2-4ForSave") == true) {	
															selectWindow("A2-4ForSave");	
																	saveAs("Tiff", beta + "A2-4");
}
if (isOpen("AsynOutlines2-4ForSave") == true) {		
														selectWindow("AsynOutlines2-4ForSave");	
																	saveAs("Tiff", beta + "AsynOutlines2-4");
}
if (isOpen("A4+ForSave") == true) {	
															selectWindow("A4+ForSave");	
																	saveAs("Tiff", beta + "A4+");
}
if (isOpen("AsynOutlines4+ForSave") == true) {
															selectWindow("AsynOutlines4+ForSave");	
																	saveAs("Tiff", beta + "AsynOutlines4+");
}
															
														
	
//saving log and statistics
	selectWindow("Log");	
		{
			saveAs("Text", beta + "Counts");
				
		} 
		run("Close");
	
	selectWindow("Statistics for A4+");	
		{
			saveAs("Results", beta + "Statistics for A4+");
				
		}
		run("Close");
	
	selectWindow("Statistics for A2-4");	
		{
			saveAs("Results", beta + "Statistics for A2-4");
				
		}
		run("Close");
	
	selectWindow("Statistics for A1-2");	
		{
			saveAs("Results", beta + "Statistics for A1-2");
				
		}
		run("Close");
		
	selectWindow("Statistics for A0.5-1");	
		{
			saveAs("Results", beta + "Statistics for A0.5-1");
				
		}
		run("Close");
	
	selectWindow("Statistics for Ferritin1+");	
		{
			saveAs("Results", beta + "Statistics for Ferritin1+");
				
		}
		run("Close");
	
	selectWindow("Statistics for Ferritin0-1");	
		{
			saveAs("Results", beta + "Statistics for Ferritin0-1");
				
		}
		run("Close");

selectWindow("Nuclei");
run("Z Project...", "projection=[Max Intensity]");
rename("NucleiA");
saveAs("tif", beta + "Nuclei for Counting");

if (isOpen("Nuclei") == true) {
	selectWindow("Nuclei");
		run("Close");
}
	if (isOpen("Nuclei for Counting.tif") == true) {
	selectWindow("Nuclei for Counting.tif");
		run("Close");
}
	if (isOpen("FSubtract") == true) {
		selectWindow("FSubtract");	
			run("Close");
	}
	if (isOpen("FStandard") == true) {
		selectWindow("FStandard");	
			run("Close");
	}
		if (isOpen("647") == true) {
		selectWindow("647");	
			run("Close");
	}
		if (isOpen("Ferritin0-1") == true) {
		selectWindow("Ferritin0-1");	
			run("Close");
	}
		if (isOpen("FerritinOutlines0") == true) {
		selectWindow("FerritinOutlines0");	
			run("Close");
	}
		if (isOpen("Ferritin1+") == true) {
		selectWindow("Ferritin1+");	
			run("Close");
	}
		if (isOpen("FerritinOutlines1+") == true) {
		selectWindow("FerritinOutlines1+");	
			run("Close");
	}
		if (isOpen("488") == true) {
		selectWindow("488");	
			run("Close");
	}
		if (isOpen("ASubtract") == true) {
		selectWindow("ASubtract");	
			run("Close");
	}
		if (isOpen("AStandard") == true) {
		selectWindow("AStandard");	
			run("Close");
	}
		if (isOpen("488x") == true) {
		selectWindow("488x");	
			run("Close");
	}
		if (isOpen("A0.5-1") == true) {
		selectWindow("A0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn0.5-1") == true) {
		selectWindow("Asyn0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn:0.5-1") == true) {
		selectWindow("Asyn:0.5-1");	
			run("Close");
	}
		if (isOpen("A1-2") == true) {
		selectWindow("A1-2");	
			run("Close");
	}	
	if (isOpen("Asyn1-2") == true) {
		selectWindow("Asyn1-2");	
			run("Close");
	}
		if (isOpen("Asyn:1-2") == true) {
		selectWindow("Asyn:1-2");	
			run("Close");
	}
		if (isOpen("A2-4") == true) {
		selectWindow("A2-4");	
			run("Close");
	}	
			if (isOpen("A2-4.tif") == true) {
		selectWindow("A2-4.tif");	
			run("Close");
	}	
	if (isOpen("Asyn:2-4") == true) {
		selectWindow("Asyn:2-4");	
			run("Close");
	}
	if (isOpen("Asyn2-4") == true) {
		selectWindow("Asyn2-4");	
			run("Close");
	}	
	if (isOpen("A4+") == true) {
		selectWindow("A4+");	
			run("Close");
	}	
	if (isOpen("Asyn4+") == true) {
		selectWindow("Asyn4+");	
			run("Close");
	}
		if (isOpen("Asyn:4+") == true) {
		selectWindow("Asyn:4+");	
			run("Close");
	}
		if (isOpen("AsynOutlines4+.tif") == true) {
		selectWindow("AsynOutlines4+.tif");	
			run("Close");
	}
		if (isOpen("AsynOutlines2-4.tif") == true) {
		selectWindow("AsynOutlines2-4.tif");	
			run("Close");
	}
		if (isOpen("A4+.tif") == true) {
		selectWindow("A4+.tif");	
			run("Close");
	}
		if (isOpen("647Merge") == true) {
		selectWindow("647Merge");	
			run("Close");
	}
			if (isOpen("AsynOutlines1-2.tif") == true) {
		selectWindow("AsynOutlines1-2.tif");	
			run("Close");
	}
			if (isOpen("A1-2.tif") == true) {
		selectWindow("A1-2.tif");	
			run("Close");
	}
			if (isOpen("AsynOutlines0.5-1.tif") == true) {
		selectWindow("AsynOutlines0.5-1.tif");	
			run("Close");
	}
			if (isOpen("A0.5-1.tif") == true) {
		selectWindow("A0.5-1.tif");	
			run("Close");
	}
			if (isOpen("AsynTouchedUp.tif") == true) {
		selectWindow("AsynTouchedUp.tif");	
			run("Close");
	}
			if (isOpen("FerritinOutlines1.tif") == true) {
		selectWindow("FerritinOutlines1.tif");	
			run("Close");
	}
				if (isOpen("Ferritin1+.tif") == true) {
		selectWindow("Ferritin1+.tif");	
			run("Close");
	}
				if (isOpen("FerritinOutlines0.tif") == true) {
		selectWindow("FerritinOutlines0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin0-1.tif") == true) {
		selectWindow("Ferritin0-1.tif");	
			run("Close");
	}
				if (isOpen("FerritinBinary0.tif") == true) {
		selectWindow("FerritinBinary0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin:1+") == true) {
		selectWindow("Ferritin:1+");	
			run("Close");
	}
				if (isOpen("Ferritin:0-1") == true) {
		selectWindow("Ferritin:0-1");	
			run("Close");
	}
				if (isOpen("488Merge") == true) {
		selectWindow("488Merge");	
			run("Close");
	}
		if (isOpen("bing") == true) {
		selectWindow("bing");	
			run("Close");
	}
		if (isOpen("ting") == true) {
		selectWindow("ting");	
			run("Close");
	}	if (isOpen("bingting") == true) {
		selectWindow("bingting");	
			run("Close");
	}
	if (isOpen("FSubtract") == true) {
		selectWindow("FSubtract");	
			run("Close");
	}
	if (isOpen("FStandard") == true) {
		selectWindow("FStandard");	
			run("Close");
	}
		if (isOpen("647") == true) {
		selectWindow("647");	
			run("Close");
	}
		if (isOpen("Ferritin0-1") == true) {
		selectWindow("Ferritin0-1");	
			run("Close");
	}
		if (isOpen("FerritinOutlines0") == true) {
		selectWindow("FerritinOutlines0");	
			run("Close");
	}
		if (isOpen("Ferritin1+") == true) {
		selectWindow("Ferritin1+");	
			run("Close");
	}
		if (isOpen("FerritinOutlines1+") == true) {
		selectWindow("FerritinOutlines1+");	
			run("Close");
	}
		if (isOpen("488") == true) {
		selectWindow("488");	
			run("Close");
	}
		if (isOpen("ASubtract") == true) {
		selectWindow("ASubtract");	
			run("Close");
	}
		if (isOpen("AStandard") == true) {
		selectWindow("AStandard");	
			run("Close");
	}
		if (isOpen("488x") == true) {
		selectWindow("488x");	
			run("Close");
	}
		if (isOpen("A0.5-1") == true) {
		selectWindow("A0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn0.5-1") == true) {
		selectWindow("Asyn0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn:0.5-1") == true) {
		selectWindow("Asyn:0.5-1");	
			run("Close");
	}
		if (isOpen("A1-2") == true) {
		selectWindow("A1-2");	
			run("Close");
	}	
	if (isOpen("Asyn1-2") == true) {
		selectWindow("Asyn1-2");	
			run("Close");
	}
		if (isOpen("Asyn:1-2") == true) {
		selectWindow("Asyn:1-2");	
			run("Close");
	}
		if (isOpen("A2-4") == true) {
		selectWindow("A2-4");	
			run("Close");
	}	
			if (isOpen("A2-4.tif") == true) {
		selectWindow("A2-4.tif");	
			run("Close");
	}	
	if (isOpen("Asyn:2-4") == true) {
		selectWindow("Asyn:2-4");	
			run("Close");
	}
	if (isOpen("Asyn2-4") == true) {
		selectWindow("Asyn2-4");	
			run("Close");
	}	
	if (isOpen("A4+") == true) {
		selectWindow("A4+");	
			run("Close");
	}	
	if (isOpen("Asyn4+") == true) {
		selectWindow("Asyn4+");	
			run("Close");
	}
		if (isOpen("Asyn:4+") == true) {
		selectWindow("Asyn:4+");	
			run("Close");
	}
		if (isOpen("AsynOutlines4+.tif") == true) {
		selectWindow("AsynOutlines4+.tif");	
			run("Close");
	}
		if (isOpen("AsynOutlines2-4.tif") == true) {
		selectWindow("AsynOutlines2-4.tif");	
			run("Close");
	}
		if (isOpen("A4+.tif") == true) {
		selectWindow("A4+.tif");	
			run("Close");
	}
		if (isOpen("647Merge") == true) {
		selectWindow("647Merge");	
			run("Close");
	}
			if (isOpen("AsynOutlines1-2.tif") == true) {
		selectWindow("AsynOutlines1-2.tif");	
			run("Close");
	}
			if (isOpen("A1-2.tif") == true) {
		selectWindow("A1-2.tif");	
			run("Close");
	}
			if (isOpen("AsynOutlines0.5-1.tif") == true) {
		selectWindow("AsynOutlines0.5-1.tif");	
			run("Close");
	}
			if (isOpen("A0.5-1.tif") == true) {
		selectWindow("A0.5-1.tif");	
			run("Close");
	}
			if (isOpen("AsynTouchedUp.tif") == true) {
		selectWindow("AsynTouchedUp.tif");	
			run("Close");
	}
			if (isOpen("FerritinOutlines1.tif") == true) {
		selectWindow("FerritinOutlines1.tif");	
			run("Close");
	}
				if (isOpen("Ferritin1+.tif") == true) {
		selectWindow("Ferritin1+.tif");	
			run("Close");
	}
				if (isOpen("FerritinOutlines0.tif") == true) {
		selectWindow("FerritinOutlines0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin0-1.tif") == true) {
		selectWindow("Ferritin0-1.tif");	
			run("Close");
	}
				if (isOpen("FerritinBinary0.tif") == true) {
		selectWindow("FerritinBinary0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin:1+") == true) {
		selectWindow("Ferritin:1+");	
			run("Close");
	}
				if (isOpen("Ferritin:0-1") == true) {
		selectWindow("Ferritin:0-1");	
			run("Close");
	}
				if (isOpen("488Merge") == true) {
		selectWindow("488Merge");	
			run("Close");
	}
		if (isOpen("bing") == true) {
		selectWindow("bing");	
			run("Close");
	}
		if (isOpen("ting") == true) {
		selectWindow("ting");	
			run("Close");
	}	if (isOpen("bingting") == true) {
		selectWindow("bingting");	
			run("Close");
	}
}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if (isOpen("c.nd2") == true) {

selectWindow("c.nd2");
charlie = getInfo("image.directory");
	setBatchMode(false);
		rename("BeachBois");
			run("Split Channels");
				selectWindow("C1-BeachBois");
					rename("Nuclei");
						selectWindow("C2-BeachBois");
							rename("488");
								selectWindow("C3-BeachBois");
									rename("647");
	run("Set Measurements...", "area add redirect=None decimal=3");
	run("3D OC Options", "volume surface nb_of_obj._voxels nb_of_surf._voxels dots_size=5 font_size=10 store_results_within_a_table_named_after_the_image_(macro_friendly) redirect_to=none");

	run("Coloc 2", "channel_1=647 channel_2=488 roi_or_mask=<None> threshold_regression=Bisection psf=3 costes_randomisations=1");
		selectWindow("Log");
			saveAs("Txt", charlie + "Colocal");
				run("Close");

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
		
//647 Identification
	 rename("FSubtract");
			run("Duplicate...", "title=FStandard stack duplicate");
				run("Subtract Background...", "rolling=21 sliding disable stack");
					run("Subtract Background...", "rolling=21 stack");
						run("Duplicate...", "title=647Merge stack duplicate");
						
			selectWindow("FSubtract");
				run("Subtract Background...", "rolling=5 stack");
				run("Subtract Background...", "rolling=5 stack");
					
					
			imageCalculator("Add create stack", "FSubtract", "FStandard");
				

					setSlice(brightestSlice);
						setAutoThreshold("Default dark");
							//run("Threshold...");
								resetThreshold(); 
								rename("647");
															run("Duplicate...", "title=647ForSave stack duplicate");
															selectWindow("647");

			setAutoThreshold("IsoData dark");
				//run("Threshold...");
					setAutoThreshold("IsoData dark");
						setOption("BlackBackground", true);
							run("Convert to Mask", "method=IsoData background=Dark black");

//647 Counting (0-1)
	run("Analyze Particles...", "size=0.1-1 show=[Masks] stack");
		rename("Ferritin0-1");
		getStatistics(area, mean, min, max, std, histogram);
			if (max < 128) threshold = max;
				else threshold = 128;
					run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
						setSlice(brightestSlice);
						
	 setAutoThreshold("Default dark");
		//run("Threshold...");
			setAutoThreshold("Default dark stack");
				setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Ferritin:0-1 stack duplicate");	
			run("16-bit");		
				selectWindow("Objects map of Ferritin0-1");
															run("Duplicate...", "title=Ferritin0-1BinaryForSave stack duplicate");
															selectWindow("Objects map of Ferritin0-1");

						run("Outline", "stack Yes");
							rename("FerritinOutlines0");
								run("16-bit");
															run("Duplicate...", "title=FerritinOutlines0ForSave stack duplicate");

		
//647 Counting (1-Infinity)		
	selectWindow("647");
		run("Analyze Particles...", "size=1.001-Infinity show=[Masks] stack");
			rename("Ferritin1+");
		
		getStatistics(area, mean, min, max, std, histogram);
			if (max < 128) threshold = max;
				else threshold = 128;
					run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
						setSlice(brightestSlice);
	
	selectWindow("Objects map of Ferritin1+");		
		 setAutoThreshold("Default dark");
			//run("Threshold...");
				setAutoThreshold("Default dark stack");
					setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");	
			run("Duplicate...", "title=Ferritin:1+ stack duplicate");				
				selectWindow("Objects map of Ferritin1+");
															run("Duplicate...", "title=Ferritin1+BinaryForSave stack duplicate");
															selectWindow("Objects map of Ferritin1+");
					
					run("Outline", "stack Yes");
						rename("FerritinOutlines1+");
							run("16-bit");
															run("Duplicate...", "title=FerritinOutlines1+ForSave stack duplicate");


//Asyn Preparation
	selectWindow("488");
		setSlice(brightestSlice);
			rename("ASubtract");
			
	run("Duplicate...", "title=AStandard stack duplicate");
		run("Subtract Background...", "rolling=21 stack sliding disable");
			run("Subtract Background...", "rolling=21 stack");
				run("Duplicate...", "title=488Merge stack duplicate");
				
	selectWindow("ASubtract");
		run("Subtract Background...", "rolling=2 stack");
			run("Subtract Background...", "rolling=2 stack");
														


				
	imageCalculator("Add create stack", "ASubtract", "AStandard");
		setSlice(brightestSlice);
			setAutoThreshold("Default dark");
				//run("Threshold...");
					resetThreshold();
						setSlice(brightestSlice);
						rename("488x");
													run("Duplicate...", "title=AsynSubtractedForSave stack duplicate");
													selectWindow("488x");

	setAutoThreshold("Default dark");
		//run("Threshold...");
			run("Convert to Mask", "method=Triangle background=Dark black");
				rename("488");

//488 Counting 0.5-1
	selectWindow("488");
		run("Analyze Particles...", "size=0.5-1 show=[Masks] stack");
			rename("A0.5-1");
		
	getStatistics(area, mean, min, max, std, histogram);
	  if (max < 128) threshold = max;
	 	 else threshold = 128;
	 		 run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");

	selectWindow("Objects map of A0.5-1");
		setSlice(brightestSlice);		
		 setAutoThreshold("Default dark");
			//run("Threshold...");
				setAutoThreshold("Default dark stack");
					setThreshold(1, 65535);
					
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
										run("Duplicate...", "title=Asyn0.5-1 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A0.5-1");
															run("Duplicate...", "title=A0.5-1ForSave stack duplicate");
															selectWindow("Objects map of A0.5-1");
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:0.5-1");
															run("Duplicate...", "title=AsynOutlines0.5-1ForSave stack duplicate");
															
						
//488 Counting 1-2
	selectWindow("488");
		run("Analyze Particles...", "size=1.001-2 show=[Masks] stack");
			rename("A1-2");
			
	getStatistics(area, mean, min, max, std, histogram);
	  if (max < 128) threshold = max;
		else threshold = 128;
	 		run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
				setSlice(brightestSlice);
		
	selectWindow("Objects map of A1-2");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn1-2 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A1-2");
															run("Duplicate...", "title=A1-2ForSave stack duplicate");
															selectWindow("Objects map of A1-2");
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:1-2");
															run("Duplicate...", "title=AsynOutlines1-2ForSave stack duplicate");
															

//488 Counting 2-4
selectWindow("488");
	run("Analyze Particles...", "size=2.001-4 show=[Masks] stack");
		rename("A2-4");
		
	getStatistics(area, mean, min, max, std, histogram);
		if (max < 128) threshold = max;
			else threshold = 128;
				run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
					setSlice(brightestSlice);

	selectWindow("Objects map of A2-4");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn2-4 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A2-4");
															run("Duplicate...", "title=A2-4ForSave stack duplicate");
															selectWindow("Objects map of A2-4");
																				
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:2-4");
															run("Duplicate...", "title=AsynOutlines2-4ForSave stack duplicate");
																						

//488 Counting 4+
selectWindow("488");
	run("Analyze Particles...", "size=4.001-Infinity show=[Masks] stack");
		rename("A4+");
		
	getStatistics(area, mean, min, max, std, histogram);
		if (max < 128) threshold = max;
			else threshold = 128;
				run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
					setSlice(brightestSlice);

	selectWindow("Objects map of A4+");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn4+ stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A4+");
															run("Duplicate...", "title=A4+ForSave stack duplicate");
															selectWindow("Objects map of A4+");
															
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:4+");
															run("Duplicate...", "title=AsynOutlines4+ForSave stack duplicate");
															
	imageCalculator("Add create stack", "Asyn2-4", "Asyn4+");
			rename("bing");	
	imageCalculator("Add create stack", "Asyn0.5-1", "Asyn1-2");	
			rename("ting");
	imageCalculator("Add create stack", "bing", "ting");
			rename("bingting");															


//Merging & Saving Images
	run("Merge Channels...", "c4=[FerritinOutlines0] c1=[647Merge] c7=[FerritinOutlines1+] create keep");
		rename("aFerritinOutlinesA");
															
															saveAs("Tiff", charlie + "aFerritinOutlinesA");
															close();
														
	selectWindow("Ferritin:0-1");
		run("16-bit");
			selectWindow("Ferritin:1+");
				run("16-bit");
	run("Merge Channels...", "c4=[Ferritin:0-1] c1=[Ferritin:1+] c3=Nuclei create keep");
		rename("aFerritinBinaryB");
															
															saveAs("Tiff", charlie + "aFerritinBinaryB");
															close();
													
	
	selectWindow("bing");
		run("16-bit");	
			run("Merge Channels...", "c4=[Ferritin:0-1] c2=bing c1=[Ferritin:1+] create keep");
				rename("aFerritin+AsynTotalC");
															
															saveAs("Tiff", charlie + "aFerritin+AsynTotalC");
															close();
														
															

	selectWindow("bingting");
		run("16-bit");	
			run("Merge Channels...", "c1=647Merge c2=488Merge c3=Nuclei c4=bingting create keep");
				rename("aWholeMergD");
															
															saveAs("Tiff", charlie + "aWholeMergD");
															close();
													
		
	run("Merge Channels...", "c1=647Merge c2=488Merge c3=Nuclei c4=[Asyn:0.5-1] c5=[Asyn:1-2] c6=[Asyn:2-4] c7=[Asyn:4+] create keep");
		rename("aSegmentedMergE");
															
															saveAs("Tiff", charlie + "aSegmentedMergE");
															close();
													

//Saving & Closingn Relavent Windows
if (isOpen("Ferritin0-1BinaryForSave") == true) {
															selectWindow("Ferritin0-1BinaryForSave");	
																	saveAs("Tiff", charlie + "FerritinBinary0");
															}
if (isOpen("FerritinOutlines0ForSave") == true) {	
															selectWindow("FerritinOutlines0ForSave");	
																	saveAs("Tiff", charlie + "Ferritin0-1");
}
if (isOpen("Ferritin1+BinaryForSave") == true) {	
															selectWindow("Ferritin1+BinaryForSave");	
																	saveAs("Tiff", charlie + "FerritinOutlines0");
}
if (isOpen("FerritinOutlines1+ForSave") == true) {
															selectWindow("FerritinOutlines1+ForSave");	
																	saveAs("Tiff", charlie + "Ferritin1+");
}
if (isOpen("647ForSave") == true) {
															selectWindow("647ForSave");	
																	saveAs("Tiff", charlie + "FerritinOutlines1");
}
if (isOpen("AsynSubtractedForSave") == true) {
															selectWindow("AsynSubtractedForSave");	
																	saveAs("Tiff", charlie + "AsynTouchedUp");
}
if (isOpen("A0.5-1ForSave") == true) {
															selectWindow("A0.5-1ForSave");	
																	saveAs("Tiff", charlie + "A0.5-1");
}
if (isOpen("AsynOutlines0.5-1ForSave") == true) {
															selectWindow("AsynOutlines0.5-1ForSave");	
																	saveAs("Tiff", charlie + "AsynOutlines0.5-1");
}
if (isOpen("A1-2ForSave") == true) {
															selectWindow("A1-2ForSave");	
																	saveAs("Tiff", charlie + "A1-2");
}
if (isOpen("AsynOutlines1-2ForSave") == true) {
															selectWindow("AsynOutlines1-2ForSave");	
																	saveAs("Tiff", charlie + "AsynOutlines1-2");
}
if (isOpen("A2-4ForSave") == true) {	
															selectWindow("A2-4ForSave");	
																	saveAs("Tiff", charlie + "A2-4");
}
if (isOpen("AsynOutlines2-4ForSave") == true) {		
														selectWindow("AsynOutlines2-4ForSave");	
																	saveAs("Tiff", charlie + "AsynOutlines2-4");
}
if (isOpen("A4+ForSave") == true) {	
															selectWindow("A4+ForSave");	
																	saveAs("Tiff", charlie + "A4+");
}
if (isOpen("AsynOutlines4+ForSave") == true) {
															selectWindow("AsynOutlines4+ForSave");	
																	saveAs("Tiff", charlie + "AsynOutlines4+");
}
															
														
	
//saving log and statistics
	selectWindow("Log");	
		{
			saveAs("Text", charlie + "Counts");
				
		} 
		run("Close");
	
	selectWindow("Statistics for A4+");	
		{
			saveAs("Results", charlie + "Statistics for A4+");
				
		}
		run("Close");
	
	selectWindow("Statistics for A2-4");	
		{
			saveAs("Results", charlie + "Statistics for A2-4");
				
		}
		run("Close");
	
	selectWindow("Statistics for A1-2");	
		{
			saveAs("Results", charlie + "Statistics for A1-2");
				
		}
		run("Close");
		
	selectWindow("Statistics for A0.5-1");	
		{
			saveAs("Results", charlie + "Statistics for A0.5-1");
				
		}
		run("Close");
	
	selectWindow("Statistics for Ferritin1+");	
		{
			saveAs("Results", charlie + "Statistics for Ferritin1+");
				
		}
		run("Close");
	
	selectWindow("Statistics for Ferritin0-1");	
		{
			saveAs("Results", charlie + "Statistics for Ferritin0-1");
				
		}
		run("Close");

selectWindow("Nuclei");
run("Z Project...", "projection=[Max Intensity]");
rename("NucleiA");
saveAs("tif", charlie + "Nuclei for Counting");

if (isOpen("Nuclei") == true) {
	selectWindow("Nuclei");
		run("Close");
}
	if (isOpen("Nuclei for Counting.tif") == true) {
	selectWindow("Nuclei for Counting.tif");
		run("Close");
}
	if (isOpen("FSubtract") == true) {
		selectWindow("FSubtract");	
			run("Close");
	}
	if (isOpen("FStandard") == true) {
		selectWindow("FStandard");	
			run("Close");
	}
		if (isOpen("647") == true) {
		selectWindow("647");	
			run("Close");
	}
		if (isOpen("Ferritin0-1") == true) {
		selectWindow("Ferritin0-1");	
			run("Close");
	}
		if (isOpen("FerritinOutlines0") == true) {
		selectWindow("FerritinOutlines0");	
			run("Close");
	}
		if (isOpen("Ferritin1+") == true) {
		selectWindow("Ferritin1+");	
			run("Close");
	}
		if (isOpen("FerritinOutlines1+") == true) {
		selectWindow("FerritinOutlines1+");	
			run("Close");
	}
		if (isOpen("488") == true) {
		selectWindow("488");	
			run("Close");
	}
		if (isOpen("ASubtract") == true) {
		selectWindow("ASubtract");	
			run("Close");
	}
		if (isOpen("AStandard") == true) {
		selectWindow("AStandard");	
			run("Close");
	}
		if (isOpen("488x") == true) {
		selectWindow("488x");	
			run("Close");
	}
		if (isOpen("A0.5-1") == true) {
		selectWindow("A0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn0.5-1") == true) {
		selectWindow("Asyn0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn:0.5-1") == true) {
		selectWindow("Asyn:0.5-1");	
			run("Close");
	}
		if (isOpen("A1-2") == true) {
		selectWindow("A1-2");	
			run("Close");
	}	
	if (isOpen("Asyn1-2") == true) {
		selectWindow("Asyn1-2");	
			run("Close");
	}
		if (isOpen("Asyn:1-2") == true) {
		selectWindow("Asyn:1-2");	
			run("Close");
	}
		if (isOpen("A2-4") == true) {
		selectWindow("A2-4");	
			run("Close");
	}	
			if (isOpen("A2-4.tif") == true) {
		selectWindow("A2-4.tif");	
			run("Close");
	}	
	if (isOpen("Asyn:2-4") == true) {
		selectWindow("Asyn:2-4");	
			run("Close");
	}
	if (isOpen("Asyn2-4") == true) {
		selectWindow("Asyn2-4");	
			run("Close");
	}	
	if (isOpen("A4+") == true) {
		selectWindow("A4+");	
			run("Close");
	}	
	if (isOpen("Asyn4+") == true) {
		selectWindow("Asyn4+");	
			run("Close");
	}
		if (isOpen("Asyn:4+") == true) {
		selectWindow("Asyn:4+");	
			run("Close");
	}
		if (isOpen("AsynOutlines4+.tif") == true) {
		selectWindow("AsynOutlines4+.tif");	
			run("Close");
	}
		if (isOpen("AsynOutlines2-4.tif") == true) {
		selectWindow("AsynOutlines2-4.tif");	
			run("Close");
	}
		if (isOpen("A4+.tif") == true) {
		selectWindow("A4+.tif");	
			run("Close");
	}
		if (isOpen("647Merge") == true) {
		selectWindow("647Merge");	
			run("Close");
	}
			if (isOpen("AsynOutlines1-2.tif") == true) {
		selectWindow("AsynOutlines1-2.tif");	
			run("Close");
	}
			if (isOpen("A1-2.tif") == true) {
		selectWindow("A1-2.tif");	
			run("Close");
	}
			if (isOpen("AsynOutlines0.5-1.tif") == true) {
		selectWindow("AsynOutlines0.5-1.tif");	
			run("Close");
	}
			if (isOpen("A0.5-1.tif") == true) {
		selectWindow("A0.5-1.tif");	
			run("Close");
	}
			if (isOpen("AsynTouchedUp.tif") == true) {
		selectWindow("AsynTouchedUp.tif");	
			run("Close");
	}
			if (isOpen("FerritinOutlines1.tif") == true) {
		selectWindow("FerritinOutlines1.tif");	
			run("Close");
	}
				if (isOpen("Ferritin1+.tif") == true) {
		selectWindow("Ferritin1+.tif");	
			run("Close");
	}
				if (isOpen("FerritinOutlines0.tif") == true) {
		selectWindow("FerritinOutlines0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin0-1.tif") == true) {
		selectWindow("Ferritin0-1.tif");	
			run("Close");
	}
				if (isOpen("FerritinBinary0.tif") == true) {
		selectWindow("FerritinBinary0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin:1+") == true) {
		selectWindow("Ferritin:1+");	
			run("Close");
	}
				if (isOpen("Ferritin:0-1") == true) {
		selectWindow("Ferritin:0-1");	
			run("Close");
	}
				if (isOpen("488Merge") == true) {
		selectWindow("488Merge");	
			run("Close");
	}
		if (isOpen("bing") == true) {
		selectWindow("bing");	
			run("Close");
	}
		if (isOpen("ting") == true) {
		selectWindow("ting");	
			run("Close");
	}	if (isOpen("bingting") == true) {
		selectWindow("bingting");	
			run("Close");
	}
	if (isOpen("FSubtract") == true) {
		selectWindow("FSubtract");	
			run("Close");
	}
	if (isOpen("FStandard") == true) {
		selectWindow("FStandard");	
			run("Close");
	}
		if (isOpen("647") == true) {
		selectWindow("647");	
			run("Close");
	}
		if (isOpen("Ferritin0-1") == true) {
		selectWindow("Ferritin0-1");	
			run("Close");
	}
		if (isOpen("FerritinOutlines0") == true) {
		selectWindow("FerritinOutlines0");	
			run("Close");
	}
		if (isOpen("Ferritin1+") == true) {
		selectWindow("Ferritin1+");	
			run("Close");
	}
		if (isOpen("FerritinOutlines1+") == true) {
		selectWindow("FerritinOutlines1+");	
			run("Close");
	}
		if (isOpen("488") == true) {
		selectWindow("488");	
			run("Close");
	}
		if (isOpen("ASubtract") == true) {
		selectWindow("ASubtract");	
			run("Close");
	}
		if (isOpen("AStandard") == true) {
		selectWindow("AStandard");	
			run("Close");
	}
		if (isOpen("488x") == true) {
		selectWindow("488x");	
			run("Close");
	}
		if (isOpen("A0.5-1") == true) {
		selectWindow("A0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn0.5-1") == true) {
		selectWindow("Asyn0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn:0.5-1") == true) {
		selectWindow("Asyn:0.5-1");	
			run("Close");
	}
		if (isOpen("A1-2") == true) {
		selectWindow("A1-2");	
			run("Close");
	}	
	if (isOpen("Asyn1-2") == true) {
		selectWindow("Asyn1-2");	
			run("Close");
	}
		if (isOpen("Asyn:1-2") == true) {
		selectWindow("Asyn:1-2");	
			run("Close");
	}
		if (isOpen("A2-4") == true) {
		selectWindow("A2-4");	
			run("Close");
	}	
			if (isOpen("A2-4.tif") == true) {
		selectWindow("A2-4.tif");	
			run("Close");
	}	
	if (isOpen("Asyn:2-4") == true) {
		selectWindow("Asyn:2-4");	
			run("Close");
	}
	if (isOpen("Asyn2-4") == true) {
		selectWindow("Asyn2-4");	
			run("Close");
	}	
	if (isOpen("A4+") == true) {
		selectWindow("A4+");	
			run("Close");
	}	
	if (isOpen("Asyn4+") == true) {
		selectWindow("Asyn4+");	
			run("Close");
	}
		if (isOpen("Asyn:4+") == true) {
		selectWindow("Asyn:4+");	
			run("Close");
	}
		if (isOpen("AsynOutlines4+.tif") == true) {
		selectWindow("AsynOutlines4+.tif");	
			run("Close");
	}
		if (isOpen("AsynOutlines2-4.tif") == true) {
		selectWindow("AsynOutlines2-4.tif");	
			run("Close");
	}
		if (isOpen("A4+.tif") == true) {
		selectWindow("A4+.tif");	
			run("Close");
	}
		if (isOpen("647Merge") == true) {
		selectWindow("647Merge");	
			run("Close");
	}
			if (isOpen("AsynOutlines1-2.tif") == true) {
		selectWindow("AsynOutlines1-2.tif");	
			run("Close");
	}
			if (isOpen("A1-2.tif") == true) {
		selectWindow("A1-2.tif");	
			run("Close");
	}
			if (isOpen("AsynOutlines0.5-1.tif") == true) {
		selectWindow("AsynOutlines0.5-1.tif");	
			run("Close");
	}
			if (isOpen("A0.5-1.tif") == true) {
		selectWindow("A0.5-1.tif");	
			run("Close");
	}
			if (isOpen("AsynTouchedUp.tif") == true) {
		selectWindow("AsynTouchedUp.tif");	
			run("Close");
	}
			if (isOpen("FerritinOutlines1.tif") == true) {
		selectWindow("FerritinOutlines1.tif");	
			run("Close");
	}
				if (isOpen("Ferritin1+.tif") == true) {
		selectWindow("Ferritin1+.tif");	
			run("Close");
	}
				if (isOpen("FerritinOutlines0.tif") == true) {
		selectWindow("FerritinOutlines0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin0-1.tif") == true) {
		selectWindow("Ferritin0-1.tif");	
			run("Close");
	}
				if (isOpen("FerritinBinary0.tif") == true) {
		selectWindow("FerritinBinary0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin:1+") == true) {
		selectWindow("Ferritin:1+");	
			run("Close");
	}
				if (isOpen("Ferritin:0-1") == true) {
		selectWindow("Ferritin:0-1");	
			run("Close");
	}
				if (isOpen("488Merge") == true) {
		selectWindow("488Merge");	
			run("Close");
	}
		if (isOpen("bing") == true) {
		selectWindow("bing");	
			run("Close");
	}
		if (isOpen("ting") == true) {
		selectWindow("ting");	
			run("Close");
	}	if (isOpen("bingting") == true) {
		selectWindow("bingting");	
			run("Close");
	}
}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if (isOpen("d.nd2") == true) {

selectWindow("d.nd2");
delta = getInfo("image.directory");
	setBatchMode(false);
		rename("BeachBois");
			run("Split Channels");
				selectWindow("C1-BeachBois");
					rename("Nuclei");
						selectWindow("C2-BeachBois");
							rename("488");
								selectWindow("C3-BeachBois");
									rename("647");
	run("Set Measurements...", "area add redirect=None decimal=3");
	run("3D OC Options", "volume surface nb_of_obj._voxels nb_of_surf._voxels dots_size=5 font_size=10 store_results_within_a_table_named_after_the_image_(macro_friendly) redirect_to=none");

	run("Coloc 2", "channel_1=647 channel_2=488 roi_or_mask=<None> threshold_regression=Bisection psf=3 costes_randomisations=1");
		selectWindow("Log");
			saveAs("Txt", delta + "Colocal");
				run("Close");

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
		
//647 Identification
	 rename("FSubtract");
			run("Duplicate...", "title=FStandard stack duplicate");
				run("Subtract Background...", "rolling=21 sliding disable stack");
					run("Subtract Background...", "rolling=21 stack");
						run("Duplicate...", "title=647Merge stack duplicate");
						
			selectWindow("FSubtract");
				run("Subtract Background...", "rolling=5 stack");
				run("Subtract Background...", "rolling=5 stack");
					
					
			imageCalculator("Add create stack", "FSubtract", "FStandard");
				

					setSlice(brightestSlice);
						setAutoThreshold("Default dark");
							//run("Threshold...");
								resetThreshold(); 
								rename("647");
															run("Duplicate...", "title=647ForSave stack duplicate");
															selectWindow("647");

			setAutoThreshold("IsoData dark");
				//run("Threshold...");
					setAutoThreshold("IsoData dark");
						setOption("BlackBackground", true);
							run("Convert to Mask", "method=IsoData background=Dark black");

//647 Counting (0-1)
	run("Analyze Particles...", "size=0.1-1 show=[Masks] stack");
		rename("Ferritin0-1");
		getStatistics(area, mean, min, max, std, histogram);
			if (max < 128) threshold = max;
				else threshold = 128;
					run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
						setSlice(brightestSlice);
						
	 setAutoThreshold("Default dark");
		//run("Threshold...");
			setAutoThreshold("Default dark stack");
				setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Ferritin:0-1 stack duplicate");		
			run("16-bit");	
				selectWindow("Objects map of Ferritin0-1");
															run("Duplicate...", "title=Ferritin0-1BinaryForSave stack duplicate");
															selectWindow("Objects map of Ferritin0-1");

						run("Outline", "stack Yes");
							rename("FerritinOutlines0");
								run("16-bit");
															run("Duplicate...", "title=FerritinOutlines0ForSave stack duplicate");

		
//647 Counting (1-Infinity)		
	selectWindow("647");
		run("Analyze Particles...", "size=1.001-Infinity show=[Masks] stack");
			rename("Ferritin1+");
		
		getStatistics(area, mean, min, max, std, histogram);
			if (max < 128) threshold = max;
				else threshold = 128;
					run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
						setSlice(brightestSlice);
	
	selectWindow("Objects map of Ferritin1+");		
		 setAutoThreshold("Default dark");
			//run("Threshold...");
				setAutoThreshold("Default dark stack");
					setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");	
			run("Duplicate...", "title=Ferritin:1+ stack duplicate");				
				selectWindow("Objects map of Ferritin1+");
															run("Duplicate...", "title=Ferritin1+BinaryForSave stack duplicate");
															selectWindow("Objects map of Ferritin1+");
					
					run("Outline", "stack Yes");
						rename("FerritinOutlines1+");
							run("16-bit");
															run("Duplicate...", "title=FerritinOutlines1+ForSave stack duplicate");


//Asyn Preparation
	selectWindow("488");
		setSlice(brightestSlice);
			rename("ASubtract");
			
	run("Duplicate...", "title=AStandard stack duplicate");
		run("Subtract Background...", "rolling=21 stack sliding disable");
			run("Subtract Background...", "rolling=21 stack");
				run("Duplicate...", "title=488Merge stack duplicate");
				
	selectWindow("ASubtract");
		run("Subtract Background...", "rolling=2 stack");
			run("Subtract Background...", "rolling=2 stack");
														


				
	imageCalculator("Add create stack", "ASubtract", "AStandard");
		setSlice(brightestSlice);
			setAutoThreshold("Default dark");
				//run("Threshold...");
					resetThreshold();
						setSlice(brightestSlice);
						rename("488x");
													run("Duplicate...", "title=AsynSubtractedForSave stack duplicate");
													selectWindow("488x");

	setAutoThreshold("Default dark");
		//run("Threshold...");
			run("Convert to Mask", "method=Triangle background=Dark black");
				rename("488");

//488 Counting 0.5-1
	selectWindow("488");
		run("Analyze Particles...", "size=0.5-1 show=[Masks] stack");
			rename("A0.5-1");
		
	getStatistics(area, mean, min, max, std, histogram);
	  if (max < 128) threshold = max;
	 	 else threshold = 128;
	 		 run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");

	selectWindow("Objects map of A0.5-1");
		setSlice(brightestSlice);		
		 setAutoThreshold("Default dark");
			//run("Threshold...");
				setAutoThreshold("Default dark stack");
					setThreshold(1, 65535);
					
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
										run("Duplicate...", "title=Asyn0.5-1 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A0.5-1");
															run("Duplicate...", "title=A0.5-1ForSave stack duplicate");
															selectWindow("Objects map of A0.5-1");
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:0.5-1");
															run("Duplicate...", "title=AsynOutlines0.5-1ForSave stack duplicate");
															
						
//488 Counting 1-2
	selectWindow("488");
		run("Analyze Particles...", "size=1.001-2 show=[Masks] stack");
			rename("A1-2");
			
	getStatistics(area, mean, min, max, std, histogram);
	  if (max < 128) threshold = max;
		else threshold = 128;
	 		run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
				setSlice(brightestSlice);
		
	selectWindow("Objects map of A1-2");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn1-2 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A1-2");
															run("Duplicate...", "title=A1-2ForSave stack duplicate");
															selectWindow("Objects map of A1-2");
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:1-2");
															run("Duplicate...", "title=AsynOutlines1-2ForSave stack duplicate");
															

//488 Counting 2-4
selectWindow("488");
	run("Analyze Particles...", "size=2.001-4 show=[Masks] stack");
		rename("A2-4");
		
	getStatistics(area, mean, min, max, std, histogram);
		if (max < 128) threshold = max;
			else threshold = 128;
				run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
					setSlice(brightestSlice);

	selectWindow("Objects map of A2-4");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn2-4 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A2-4");
															run("Duplicate...", "title=A2-4ForSave stack duplicate");
															selectWindow("Objects map of A2-4");
																				
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:2-4");
															run("Duplicate...", "title=AsynOutlines2-4ForSave stack duplicate");
																						

//488 Counting 4+
selectWindow("488");
	run("Analyze Particles...", "size=4.001-Infinity show=[Masks] stack");
		rename("A4+");
		
	getStatistics(area, mean, min, max, std, histogram);
		if (max < 128) threshold = max;
			else threshold = 128;
				run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
					setSlice(brightestSlice);

	selectWindow("Objects map of A4+");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn4+ stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A4+");
															run("Duplicate...", "title=A4+ForSave stack duplicate");
															selectWindow("Objects map of A4+");
															
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:4+");
															run("Duplicate...", "title=AsynOutlines4+ForSave stack duplicate");
															
	imageCalculator("Add create stack", "Asyn2-4", "Asyn4+");
			rename("bing");	
	imageCalculator("Add create stack", "Asyn0.5-1", "Asyn1-2");	
			rename("ting");
	imageCalculator("Add create stack", "bing", "ting");
			rename("bingting");															


//Merging & Saving Images
	run("Merge Channels...", "c4=[FerritinOutlines0] c1=[647Merge] c7=[FerritinOutlines1+] create keep");
		rename("aFerritinOutlinesA");
															
															saveAs("Tiff", delta + "aFerritinOutlinesA");
															close();
														
	selectWindow("Ferritin:0-1");
		run("16-bit");
			selectWindow("Ferritin:1+");
				run("16-bit");
	run("Merge Channels...", "c4=[Ferritin:0-1] c1=[Ferritin:1+] c3=Nuclei create keep");
		rename("aFerritinBinaryB");
															
															saveAs("Tiff", delta + "aFerritinBinaryB");
															close();
													
	
	selectWindow("bing");
		run("16-bit");	
			run("Merge Channels...", "c4=[Ferritin:0-1] c2=bing c1=[Ferritin:1+] create keep");
				rename("aFerritin+AsynTotalC");
															
															saveAs("Tiff", delta + "aFerritin+AsynTotalC");
															close();
														
															

	selectWindow("bingting");
		run("16-bit");	
			run("Merge Channels...", "c1=647Merge c2=488Merge c3=Nuclei c4=bingting create keep");
				rename("aWholeMergD");
															
															saveAs("Tiff", delta + "aWholeMergD");
															close();
													
		
	run("Merge Channels...", "c1=647Merge c2=488Merge c3=Nuclei c4=[Asyn:0.5-1] c5=[Asyn:1-2] c6=[Asyn:2-4] c7=[Asyn:4+] create keep");
		rename("aSegmentedMergE");
															
															saveAs("Tiff", delta + "aSegmentedMergE");
															close();
													

//Saving & Closingn Relavent Windows
if (isOpen("Ferritin0-1BinaryForSave") == true) {
															selectWindow("Ferritin0-1BinaryForSave");	
																	saveAs("Tiff", delta + "FerritinBinary0");
															}
if (isOpen("FerritinOutlines0ForSave") == true) {	
															selectWindow("FerritinOutlines0ForSave");	
																	saveAs("Tiff", delta + "Ferritin0-1");
}
if (isOpen("Ferritin1+BinaryForSave") == true) {	
															selectWindow("Ferritin1+BinaryForSave");	
																	saveAs("Tiff", delta + "FerritinOutlines0");
}
if (isOpen("FerritinOutlines1+ForSave") == true) {
															selectWindow("FerritinOutlines1+ForSave");	
																	saveAs("Tiff", delta + "Ferritin1+");
}
if (isOpen("647ForSave") == true) {
															selectWindow("647ForSave");	
																	saveAs("Tiff", delta + "FerritinOutlines1");
}
if (isOpen("AsynSubtractedForSave") == true) {
															selectWindow("AsynSubtractedForSave");	
																	saveAs("Tiff", delta + "AsynTouchedUp");
}
if (isOpen("A0.5-1ForSave") == true) {
															selectWindow("A0.5-1ForSave");	
																	saveAs("Tiff", delta + "A0.5-1");
}
if (isOpen("AsynOutlines0.5-1ForSave") == true) {
															selectWindow("AsynOutlines0.5-1ForSave");	
																	saveAs("Tiff", delta + "AsynOutlines0.5-1");
}
if (isOpen("A1-2ForSave") == true) {
															selectWindow("A1-2ForSave");	
																	saveAs("Tiff", delta + "A1-2");
}
if (isOpen("AsynOutlines1-2ForSave") == true) {
															selectWindow("AsynOutlines1-2ForSave");	
																	saveAs("Tiff", delta + "AsynOutlines1-2");
}
if (isOpen("A2-4ForSave") == true) {	
															selectWindow("A2-4ForSave");	
																	saveAs("Tiff", delta + "A2-4");
}
if (isOpen("AsynOutlines2-4ForSave") == true) {		
														selectWindow("AsynOutlines2-4ForSave");	
																	saveAs("Tiff", delta + "AsynOutlines2-4");
}
if (isOpen("A4+ForSave") == true) {	
															selectWindow("A4+ForSave");	
																	saveAs("Tiff", delta + "A4+");
}
if (isOpen("AsynOutlines4+ForSave") == true) {
															selectWindow("AsynOutlines4+ForSave");	
																	saveAs("Tiff", delta + "AsynOutlines4+");
}
															
														
	
//saving log and statistics
	selectWindow("Log");	
		{
			saveAs("Text", delta + "Counts");
				
		} 
		run("Close");
	
	selectWindow("Statistics for A4+");	
		{
			saveAs("Results", delta + "Statistics for A4+");
				
		}
		run("Close");
	
	selectWindow("Statistics for A2-4");	
		{
			saveAs("Results", delta + "Statistics for A2-4");
				
		}
		run("Close");
	
	selectWindow("Statistics for A1-2");	
		{
			saveAs("Results", delta + "Statistics for A1-2");
				
		}
		run("Close");
		
	selectWindow("Statistics for A0.5-1");	
		{
			saveAs("Results", delta + "Statistics for A0.5-1");
				
		}
		run("Close");
	
	selectWindow("Statistics for Ferritin1+");	
		{
			saveAs("Results", delta + "Statistics for Ferritin1+");
				
		}
		run("Close");
	
	selectWindow("Statistics for Ferritin0-1");	
		{
			saveAs("Results", delta + "Statistics for Ferritin0-1");
				
		}
		run("Close");

selectWindow("Nuclei");
run("Z Project...", "projection=[Max Intensity]");
rename("NucleiA");
saveAs("tif", delta + "Nuclei for Counting");

if (isOpen("Nuclei") == true) {
	selectWindow("Nuclei");
		run("Close");
}
	if (isOpen("Nuclei for Counting.tif") == true) {
	selectWindow("Nuclei for Counting.tif");
		run("Close");
}
	if (isOpen("FSubtract") == true) {
		selectWindow("FSubtract");	
			run("Close");
	}
	if (isOpen("FStandard") == true) {
		selectWindow("FStandard");	
			run("Close");
	}
		if (isOpen("647") == true) {
		selectWindow("647");	
			run("Close");
	}
		if (isOpen("Ferritin0-1") == true) {
		selectWindow("Ferritin0-1");	
			run("Close");
	}
		if (isOpen("FerritinOutlines0") == true) {
		selectWindow("FerritinOutlines0");	
			run("Close");
	}
		if (isOpen("Ferritin1+") == true) {
		selectWindow("Ferritin1+");	
			run("Close");
	}
		if (isOpen("FerritinOutlines1+") == true) {
		selectWindow("FerritinOutlines1+");	
			run("Close");
	}
		if (isOpen("488") == true) {
		selectWindow("488");	
			run("Close");
	}
		if (isOpen("ASubtract") == true) {
		selectWindow("ASubtract");	
			run("Close");
	}
		if (isOpen("AStandard") == true) {
		selectWindow("AStandard");	
			run("Close");
	}
		if (isOpen("488x") == true) {
		selectWindow("488x");	
			run("Close");
	}
		if (isOpen("A0.5-1") == true) {
		selectWindow("A0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn0.5-1") == true) {
		selectWindow("Asyn0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn:0.5-1") == true) {
		selectWindow("Asyn:0.5-1");	
			run("Close");
	}
		if (isOpen("A1-2") == true) {
		selectWindow("A1-2");	
			run("Close");
	}	
	if (isOpen("Asyn1-2") == true) {
		selectWindow("Asyn1-2");	
			run("Close");
	}
		if (isOpen("Asyn:1-2") == true) {
		selectWindow("Asyn:1-2");	
			run("Close");
	}
		if (isOpen("A2-4") == true) {
		selectWindow("A2-4");	
			run("Close");
	}	
			if (isOpen("A2-4.tif") == true) {
		selectWindow("A2-4.tif");	
			run("Close");
	}	
	if (isOpen("Asyn:2-4") == true) {
		selectWindow("Asyn:2-4");	
			run("Close");
	}
	if (isOpen("Asyn2-4") == true) {
		selectWindow("Asyn2-4");	
			run("Close");
	}	
	if (isOpen("A4+") == true) {
		selectWindow("A4+");	
			run("Close");
	}	
	if (isOpen("Asyn4+") == true) {
		selectWindow("Asyn4+");	
			run("Close");
	}
		if (isOpen("Asyn:4+") == true) {
		selectWindow("Asyn:4+");	
			run("Close");
	}
		if (isOpen("AsynOutlines4+.tif") == true) {
		selectWindow("AsynOutlines4+.tif");	
			run("Close");
	}
		if (isOpen("AsynOutlines2-4.tif") == true) {
		selectWindow("AsynOutlines2-4.tif");	
			run("Close");
	}
		if (isOpen("A4+.tif") == true) {
		selectWindow("A4+.tif");	
			run("Close");
	}
		if (isOpen("647Merge") == true) {
		selectWindow("647Merge");	
			run("Close");
	}
			if (isOpen("AsynOutlines1-2.tif") == true) {
		selectWindow("AsynOutlines1-2.tif");	
			run("Close");
	}
			if (isOpen("A1-2.tif") == true) {
		selectWindow("A1-2.tif");	
			run("Close");
	}
			if (isOpen("AsynOutlines0.5-1.tif") == true) {
		selectWindow("AsynOutlines0.5-1.tif");	
			run("Close");
	}
			if (isOpen("A0.5-1.tif") == true) {
		selectWindow("A0.5-1.tif");	
			run("Close");
	}
			if (isOpen("AsynTouchedUp.tif") == true) {
		selectWindow("AsynTouchedUp.tif");	
			run("Close");
	}
			if (isOpen("FerritinOutlines1.tif") == true) {
		selectWindow("FerritinOutlines1.tif");	
			run("Close");
	}
				if (isOpen("Ferritin1+.tif") == true) {
		selectWindow("Ferritin1+.tif");	
			run("Close");
	}
				if (isOpen("FerritinOutlines0.tif") == true) {
		selectWindow("FerritinOutlines0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin0-1.tif") == true) {
		selectWindow("Ferritin0-1.tif");	
			run("Close");
	}
				if (isOpen("FerritinBinary0.tif") == true) {
		selectWindow("FerritinBinary0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin:1+") == true) {
		selectWindow("Ferritin:1+");	
			run("Close");
	}
				if (isOpen("Ferritin:0-1") == true) {
		selectWindow("Ferritin:0-1");	
			run("Close");
	}
				if (isOpen("488Merge") == true) {
		selectWindow("488Merge");	
			run("Close");
	}
		if (isOpen("bing") == true) {
		selectWindow("bing");	
			run("Close");
	}
		if (isOpen("ting") == true) {
		selectWindow("ting");	
			run("Close");
	}	if (isOpen("bingting") == true) {
		selectWindow("bingting");	
			run("Close");
	}
	if (isOpen("FSubtract") == true) {
		selectWindow("FSubtract");	
			run("Close");
	}
	if (isOpen("FStandard") == true) {
		selectWindow("FStandard");	
			run("Close");
	}
		if (isOpen("647") == true) {
		selectWindow("647");	
			run("Close");
	}
		if (isOpen("Ferritin0-1") == true) {
		selectWindow("Ferritin0-1");	
			run("Close");
	}
		if (isOpen("FerritinOutlines0") == true) {
		selectWindow("FerritinOutlines0");	
			run("Close");
	}
		if (isOpen("Ferritin1+") == true) {
		selectWindow("Ferritin1+");	
			run("Close");
	}
		if (isOpen("FerritinOutlines1+") == true) {
		selectWindow("FerritinOutlines1+");	
			run("Close");
	}
		if (isOpen("488") == true) {
		selectWindow("488");	
			run("Close");
	}
		if (isOpen("ASubtract") == true) {
		selectWindow("ASubtract");	
			run("Close");
	}
		if (isOpen("AStandard") == true) {
		selectWindow("AStandard");	
			run("Close");
	}
		if (isOpen("488x") == true) {
		selectWindow("488x");	
			run("Close");
	}
		if (isOpen("A0.5-1") == true) {
		selectWindow("A0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn0.5-1") == true) {
		selectWindow("Asyn0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn:0.5-1") == true) {
		selectWindow("Asyn:0.5-1");	
			run("Close");
	}
		if (isOpen("A1-2") == true) {
		selectWindow("A1-2");	
			run("Close");
	}	
	if (isOpen("Asyn1-2") == true) {
		selectWindow("Asyn1-2");	
			run("Close");
	}
		if (isOpen("Asyn:1-2") == true) {
		selectWindow("Asyn:1-2");	
			run("Close");
	}
		if (isOpen("A2-4") == true) {
		selectWindow("A2-4");	
			run("Close");
	}	
			if (isOpen("A2-4.tif") == true) {
		selectWindow("A2-4.tif");	
			run("Close");
	}	
	if (isOpen("Asyn:2-4") == true) {
		selectWindow("Asyn:2-4");	
			run("Close");
	}
	if (isOpen("Asyn2-4") == true) {
		selectWindow("Asyn2-4");	
			run("Close");
	}	
	if (isOpen("A4+") == true) {
		selectWindow("A4+");	
			run("Close");
	}	
	if (isOpen("Asyn4+") == true) {
		selectWindow("Asyn4+");	
			run("Close");
	}
		if (isOpen("Asyn:4+") == true) {
		selectWindow("Asyn:4+");	
			run("Close");
	}
		if (isOpen("AsynOutlines4+.tif") == true) {
		selectWindow("AsynOutlines4+.tif");	
			run("Close");
	}
		if (isOpen("AsynOutlines2-4.tif") == true) {
		selectWindow("AsynOutlines2-4.tif");	
			run("Close");
	}
		if (isOpen("A4+.tif") == true) {
		selectWindow("A4+.tif");	
			run("Close");
	}
		if (isOpen("647Merge") == true) {
		selectWindow("647Merge");	
			run("Close");
	}
			if (isOpen("AsynOutlines1-2.tif") == true) {
		selectWindow("AsynOutlines1-2.tif");	
			run("Close");
	}
			if (isOpen("A1-2.tif") == true) {
		selectWindow("A1-2.tif");	
			run("Close");
	}
			if (isOpen("AsynOutlines0.5-1.tif") == true) {
		selectWindow("AsynOutlines0.5-1.tif");	
			run("Close");
	}
			if (isOpen("A0.5-1.tif") == true) {
		selectWindow("A0.5-1.tif");	
			run("Close");
	}
			if (isOpen("AsynTouchedUp.tif") == true) {
		selectWindow("AsynTouchedUp.tif");	
			run("Close");
	}
			if (isOpen("FerritinOutlines1.tif") == true) {
		selectWindow("FerritinOutlines1.tif");	
			run("Close");
	}
				if (isOpen("Ferritin1+.tif") == true) {
		selectWindow("Ferritin1+.tif");	
			run("Close");
	}
				if (isOpen("FerritinOutlines0.tif") == true) {
		selectWindow("FerritinOutlines0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin0-1.tif") == true) {
		selectWindow("Ferritin0-1.tif");	
			run("Close");
	}
				if (isOpen("FerritinBinary0.tif") == true) {
		selectWindow("FerritinBinary0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin:1+") == true) {
		selectWindow("Ferritin:1+");	
			run("Close");
	}
				if (isOpen("Ferritin:0-1") == true) {
		selectWindow("Ferritin:0-1");	
			run("Close");
	}
				if (isOpen("488Merge") == true) {
		selectWindow("488Merge");	
			run("Close");
	}
		if (isOpen("bing") == true) {
		selectWindow("bing");	
			run("Close");
	}
		if (isOpen("ting") == true) {
		selectWindow("ting");	
			run("Close");
	}	if (isOpen("bingting") == true) {
		selectWindow("bingting");	
			run("Close");
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if (isOpen("e.nd2") == true) {

selectWindow("e.nd2");
epsilon = getInfo("image.directory");
	setBatchMode(false);
		rename("BeachBois");
			run("Split Channels");
				selectWindow("C1-BeachBois");
					rename("Nuclei");
						selectWindow("C2-BeachBois");
							rename("488");
								selectWindow("C3-BeachBois");
									rename("647");
	run("Set Measurements...", "area add redirect=None decimal=3");
	run("3D OC Options", "volume surface nb_of_obj._voxels nb_of_surf._voxels dots_size=5 font_size=10 store_results_within_a_table_named_after_the_image_(macro_friendly) redirect_to=none");

	run("Coloc 2", "channel_1=647 channel_2=488 roi_or_mask=<None> threshold_regression=Bisection psf=3 costes_randomisations=1");
		selectWindow("Log");
			saveAs("Txt", epsilon + "Colocal");
				

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
		
//647 Identification
	 rename("FSubtract");
			run("Duplicate...", "title=FStandard stack duplicate");
				run("Subtract Background...", "rolling=21 sliding disable stack");
					run("Subtract Background...", "rolling=21 stack");
						run("Duplicate...", "title=647Merge stack duplicate");
						
			selectWindow("FSubtract");
				run("Subtract Background...", "rolling=5 stack");
				run("Subtract Background...", "rolling=5 stack");
					
					
			imageCalculator("Add create stack", "FSubtract", "FStandard");
				

					setSlice(brightestSlice);
						setAutoThreshold("Default dark");
							//run("Threshold...");
								resetThreshold(); 
								rename("647");
															run("Duplicate...", "title=647ForSave stack duplicate");
															selectWindow("647");

			setAutoThreshold("IsoData dark");
				//run("Threshold...");
					setAutoThreshold("IsoData dark");
						setOption("BlackBackground", true);
							run("Convert to Mask", "method=IsoData background=Dark black");

//647 Counting (0-1)
	run("Analyze Particles...", "size=0.1-1 show=[Masks] stack");
		rename("Ferritin0-1");
		getStatistics(area, mean, min, max, std, histogram);
			if (max < 128) threshold = max;
				else threshold = 128;
					run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
						setSlice(brightestSlice);
						
	 setAutoThreshold("Default dark");
		//run("Threshold...");
			setAutoThreshold("Default dark stack");
				setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Ferritin:0-1 stack duplicate");	
			run("16-bit");		
				selectWindow("Objects map of Ferritin0-1");
															run("Duplicate...", "title=Ferritin0-1BinaryForSave stack duplicate");
															selectWindow("Objects map of Ferritin0-1");

						run("Outline", "stack Yes");
							rename("FerritinOutlines0");
								run("16-bit");
															run("Duplicate...", "title=FerritinOutlines0ForSave stack duplicate");

		
//647 Counting (1-Infinity)		
	selectWindow("647");
		run("Analyze Particles...", "size=1.001-Infinity show=[Masks] stack");
			rename("Ferritin1+");
		
		getStatistics(area, mean, min, max, std, histogram);
			if (max < 128) threshold = max;
				else threshold = 128;
					run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
						setSlice(brightestSlice);
	
	selectWindow("Objects map of Ferritin1+");		
		 setAutoThreshold("Default dark");
			//run("Threshold...");
				setAutoThreshold("Default dark stack");
					setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");	
			run("Duplicate...", "title=Ferritin:1+ stack duplicate");				
				selectWindow("Objects map of Ferritin1+");
															run("Duplicate...", "title=Ferritin1+BinaryForSave stack duplicate");
															selectWindow("Objects map of Ferritin1+");
					
					run("Outline", "stack Yes");
						rename("FerritinOutlines1+");
							run("16-bit");
															run("Duplicate...", "title=FerritinOutlines1+ForSave stack duplicate");


//Asyn Preparation
	selectWindow("488");
		setSlice(brightestSlice);
			rename("ASubtract");
			
	run("Duplicate...", "title=AStandard stack duplicate");
		run("Subtract Background...", "rolling=21 stack sliding disable");
			run("Subtract Background...", "rolling=21 stack");
				run("Duplicate...", "title=488Merge stack duplicate");
				
	selectWindow("ASubtract");
		run("Subtract Background...", "rolling=2 stack");
			run("Subtract Background...", "rolling=2 stack");
														


				
	imageCalculator("Add create stack", "ASubtract", "AStandard");
		setSlice(brightestSlice);
			setAutoThreshold("Default dark");
				//run("Threshold...");
					resetThreshold();
						setSlice(brightestSlice);
						rename("488x");
													run("Duplicate...", "title=AsynSubtractedForSave stack duplicate");
													selectWindow("488x");

	setAutoThreshold("Default dark");
		//run("Threshold...");
			run("Convert to Mask", "method=Triangle background=Dark black");
				rename("488");

//488 Counting 0.5-1
	selectWindow("488");
		run("Analyze Particles...", "size=0.5-1 show=[Masks] stack");
			rename("A0.5-1");
		
	getStatistics(area, mean, min, max, std, histogram);
	  if (max < 128) threshold = max;
	 	 else threshold = 128;
	 		 run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");

	selectWindow("Objects map of A0.5-1");
		setSlice(brightestSlice);		
		 setAutoThreshold("Default dark");
			//run("Threshold...");
				setAutoThreshold("Default dark stack");
					setThreshold(1, 65535);
					
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
										run("Duplicate...", "title=Asyn0.5-1 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A0.5-1");
															run("Duplicate...", "title=A0.5-1ForSave stack duplicate");
															selectWindow("Objects map of A0.5-1");
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:0.5-1");
															run("Duplicate...", "title=AsynOutlines0.5-1ForSave stack duplicate");
															
						
//488 Counting 1-2
	selectWindow("488");
		run("Analyze Particles...", "size=1.001-2 show=[Masks] stack");
			rename("A1-2");
			
	getStatistics(area, mean, min, max, std, histogram);
	  if (max < 128) threshold = max;
		else threshold = 128;
	 		run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
				setSlice(brightestSlice);
		
	selectWindow("Objects map of A1-2");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn1-2 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A1-2");
															run("Duplicate...", "title=A1-2ForSave stack duplicate");
															selectWindow("Objects map of A1-2");
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:1-2");
															run("Duplicate...", "title=AsynOutlines1-2ForSave stack duplicate");
															

//488 Counting 2-4
selectWindow("488");
	run("Analyze Particles...", "size=2.001-4 show=[Masks] stack");
		rename("A2-4");
		
	getStatistics(area, mean, min, max, std, histogram);
		if (max < 128) threshold = max;
			else threshold = 128;
				run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
					setSlice(brightestSlice);

	selectWindow("Objects map of A2-4");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn2-4 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A2-4");
															run("Duplicate...", "title=A2-4ForSave stack duplicate");
															selectWindow("Objects map of A2-4");
																				
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:2-4");
															run("Duplicate...", "title=AsynOutlines2-4ForSave stack duplicate");
																						

//488 Counting 4+
selectWindow("488");
	run("Analyze Particles...", "size=4.001-Infinity show=[Masks] stack");
		rename("A4+");
		
	getStatistics(area, mean, min, max, std, histogram);
		if (max < 128) threshold = max;
			else threshold = 128;
				run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
					setSlice(brightestSlice);

	selectWindow("Objects map of A4+");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn4+ stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A4+");
															run("Duplicate...", "title=A4+ForSave stack duplicate");
															selectWindow("Objects map of A4+");
															
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:4+");
															run("Duplicate...", "title=AsynOutlines4+ForSave stack duplicate");
															
	imageCalculator("Add create stack", "Asyn2-4", "Asyn4+");
			rename("bing");	
	imageCalculator("Add create stack", "Asyn0.5-1", "Asyn1-2");	
			rename("ting");
	imageCalculator("Add create stack", "bing", "ting");
			rename("bingting");															


//Merging & Saving Images
	run("Merge Channels...", "c4=[FerritinOutlines0] c1=[647Merge] c7=[FerritinOutlines1+] create keep");
		rename("aFerritinOutlinesA");
															
															saveAs("Tiff", epsilon + "aFerritinOutlinesA");
															close();
														
	selectWindow("Ferritin:0-1");
		run("16-bit");
			selectWindow("Ferritin:1+");
				run("16-bit");
	run("Merge Channels...", "c4=[Ferritin:0-1] c1=[Ferritin:1+] c3=Nuclei create keep");
		rename("aFerritinBinaryB");
															
															saveAs("Tiff", epsilon + "aFerritinBinaryB");
															close();
													
	
	selectWindow("bing");
		run("16-bit");	
			run("Merge Channels...", "c4=[Ferritin:0-1] c2=bing c1=[Ferritin:1+] create keep");
				rename("aFerritin+AsynTotalC");
															
															saveAs("Tiff", epsilon + "aFerritin+AsynTotalC");
															close();
														
															

	selectWindow("bingting");
		run("16-bit");	
			run("Merge Channels...", "c1=647Merge c2=488Merge c3=Nuclei c4=bingting create keep");
				rename("aWholeMergD");
															
															saveAs("Tiff", epsilon + "aWholeMergD");
															close();
													
		
	run("Merge Channels...", "c1=647Merge c2=488Merge c3=Nuclei c4=[Asyn:0.5-1] c5=[Asyn:1-2] c6=[Asyn:2-4] c7=[Asyn:4+] create keep");
		rename("aSegmentedMergE");
															
															saveAs("Tiff", epsilon + "aSegmentedMergE");
															close();
													

//Saving & Closingn Relavent Windows
if (isOpen("Ferritin0-1BinaryForSave") == true) {
															selectWindow("Ferritin0-1BinaryForSave");	
																	saveAs("Tiff", epsilon + "FerritinBinary0");
															}
if (isOpen("FerritinOutlines0ForSave") == true) {	
															selectWindow("FerritinOutlines0ForSave");	
																	saveAs("Tiff", epsilon + "Ferritin0-1");
}
if (isOpen("Ferritin1+BinaryForSave") == true) {	
															selectWindow("Ferritin1+BinaryForSave");	
																	saveAs("Tiff", epsilon + "FerritinOutlines0");
}
if (isOpen("FerritinOutlines1+ForSave") == true) {
															selectWindow("FerritinOutlines1+ForSave");	
																	saveAs("Tiff", epsilon + "Ferritin1+");
}
if (isOpen("647ForSave") == true) {
															selectWindow("647ForSave");	
																	saveAs("Tiff", epsilon + "FerritinOutlines1");
}
if (isOpen("AsynSubtractedForSave") == true) {
															selectWindow("AsynSubtractedForSave");	
																	saveAs("Tiff", epsilon + "AsynTouchedUp");
}
if (isOpen("A0.5-1ForSave") == true) {
															selectWindow("A0.5-1ForSave");	
																	saveAs("Tiff", epsilon + "A0.5-1");
}
if (isOpen("AsynOutlines0.5-1ForSave") == true) {
															selectWindow("AsynOutlines0.5-1ForSave");	
																	saveAs("Tiff", epsilon + "AsynOutlines0.5-1");
}
if (isOpen("A1-2ForSave") == true) {
															selectWindow("A1-2ForSave");	
																	saveAs("Tiff", epsilon + "A1-2");
}
if (isOpen("AsynOutlines1-2ForSave") == true) {
															selectWindow("AsynOutlines1-2ForSave");	
																	saveAs("Tiff", epsilon + "AsynOutlines1-2");
}
if (isOpen("A2-4ForSave") == true) {	
															selectWindow("A2-4ForSave");	
																	saveAs("Tiff", epsilon + "A2-4");
}
if (isOpen("AsynOutlines2-4ForSave") == true) {		
														selectWindow("AsynOutlines2-4ForSave");	
																	saveAs("Tiff", epsilon + "AsynOutlines2-4");
}
if (isOpen("A4+ForSave") == true) {	
															selectWindow("A4+ForSave");	
																	saveAs("Tiff", epsilon + "A4+");
}
if (isOpen("AsynOutlines4+ForSave") == true) {
															selectWindow("AsynOutlines4+ForSave");	
																	saveAs("Tiff", epsilon + "AsynOutlines4+");
}
															
														
	
//saving log and statistics
	selectWindow("Log");	
		{
			saveAs("Text", epsilon + "Counts");
				
		} 
		run("Close");
	
	selectWindow("Statistics for A4+");	
		{
			saveAs("Results", epsilon + "Statistics for A4+");
				
		}
		run("Close");
	
	selectWindow("Statistics for A2-4");	
		{
			saveAs("Results", epsilon + "Statistics for A2-4");
				
		}
		run("Close");
	
	selectWindow("Statistics for A1-2");	
		{
			saveAs("Results", epsilon + "Statistics for A1-2");
				
		}
		run("Close");
		
	selectWindow("Statistics for A0.5-1");	
		{
			saveAs("Results", epsilon + "Statistics for A0.5-1");
				
		}
		run("Close");
	
	selectWindow("Statistics for Ferritin1+");	
		{
			saveAs("Results", epsilon + "Statistics for Ferritin1+");
				
		}
		run("Close");
	
	selectWindow("Statistics for Ferritin0-1");	
		{
			saveAs("Results", epsilon + "Statistics for Ferritin0-1");
				
		}
		run("Close");

selectWindow("Nuclei");
run("Z Project...", "projection=[Max Intensity]");
rename("NucleiA");
saveAs("tif", epsilon + "Nuclei for Counting");

if (isOpen("Nuclei") == true) {
	selectWindow("Nuclei");
		run("Close");
}
	if (isOpen("Nuclei for Counting.tif") == true) {
	selectWindow("Nuclei for Counting.tif");
		run("Close");
}
	if (isOpen("FSubtract") == true) {
		selectWindow("FSubtract");	
			run("Close");
	}
	if (isOpen("FStandard") == true) {
		selectWindow("FStandard");	
			run("Close");
	}
		if (isOpen("647") == true) {
		selectWindow("647");	
			run("Close");
	}
		if (isOpen("Ferritin0-1") == true) {
		selectWindow("Ferritin0-1");	
			run("Close");
	}
		if (isOpen("FerritinOutlines0") == true) {
		selectWindow("FerritinOutlines0");	
			run("Close");
	}
		if (isOpen("Ferritin1+") == true) {
		selectWindow("Ferritin1+");	
			run("Close");
	}
		if (isOpen("FerritinOutlines1+") == true) {
		selectWindow("FerritinOutlines1+");	
			run("Close");
	}
		if (isOpen("488") == true) {
		selectWindow("488");	
			run("Close");
	}
		if (isOpen("ASubtract") == true) {
		selectWindow("ASubtract");	
			run("Close");
	}
		if (isOpen("AStandard") == true) {
		selectWindow("AStandard");	
			run("Close");
	}
		if (isOpen("488x") == true) {
		selectWindow("488x");	
			run("Close");
	}
		if (isOpen("A0.5-1") == true) {
		selectWindow("A0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn0.5-1") == true) {
		selectWindow("Asyn0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn:0.5-1") == true) {
		selectWindow("Asyn:0.5-1");	
			run("Close");
	}
		if (isOpen("A1-2") == true) {
		selectWindow("A1-2");	
			run("Close");
	}	
	if (isOpen("Asyn1-2") == true) {
		selectWindow("Asyn1-2");	
			run("Close");
	}
		if (isOpen("Asyn:1-2") == true) {
		selectWindow("Asyn:1-2");	
			run("Close");
	}
		if (isOpen("A2-4") == true) {
		selectWindow("A2-4");	
			run("Close");
	}	
			if (isOpen("A2-4.tif") == true) {
		selectWindow("A2-4.tif");	
			run("Close");
	}	
	if (isOpen("Asyn:2-4") == true) {
		selectWindow("Asyn:2-4");	
			run("Close");
	}
	if (isOpen("Asyn2-4") == true) {
		selectWindow("Asyn2-4");	
			run("Close");
	}	
	if (isOpen("A4+") == true) {
		selectWindow("A4+");	
			run("Close");
	}	
	if (isOpen("Asyn4+") == true) {
		selectWindow("Asyn4+");	
			run("Close");
	}
		if (isOpen("Asyn:4+") == true) {
		selectWindow("Asyn:4+");	
			run("Close");
	}
		if (isOpen("AsynOutlines4+.tif") == true) {
		selectWindow("AsynOutlines4+.tif");	
			run("Close");
	}
		if (isOpen("AsynOutlines2-4.tif") == true) {
		selectWindow("AsynOutlines2-4.tif");	
			run("Close");
	}
		if (isOpen("A4+.tif") == true) {
		selectWindow("A4+.tif");	
			run("Close");
	}
		if (isOpen("647Merge") == true) {
		selectWindow("647Merge");	
			run("Close");
	}
			if (isOpen("AsynOutlines1-2.tif") == true) {
		selectWindow("AsynOutlines1-2.tif");	
			run("Close");
	}
			if (isOpen("A1-2.tif") == true) {
		selectWindow("A1-2.tif");	
			run("Close");
	}
			if (isOpen("AsynOutlines0.5-1.tif") == true) {
		selectWindow("AsynOutlines0.5-1.tif");	
			run("Close");
	}
			if (isOpen("A0.5-1.tif") == true) {
		selectWindow("A0.5-1.tif");	
			run("Close");
	}
			if (isOpen("AsynTouchedUp.tif") == true) {
		selectWindow("AsynTouchedUp.tif");	
			run("Close");
	}
			if (isOpen("FerritinOutlines1.tif") == true) {
		selectWindow("FerritinOutlines1.tif");	
			run("Close");
	}
				if (isOpen("Ferritin1+.tif") == true) {
		selectWindow("Ferritin1+.tif");	
			run("Close");
	}
				if (isOpen("FerritinOutlines0.tif") == true) {
		selectWindow("FerritinOutlines0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin0-1.tif") == true) {
		selectWindow("Ferritin0-1.tif");	
			run("Close");
	}
				if (isOpen("FerritinBinary0.tif") == true) {
		selectWindow("FerritinBinary0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin:1+") == true) {
		selectWindow("Ferritin:1+");	
			run("Close");
	}
				if (isOpen("Ferritin:0-1") == true) {
		selectWindow("Ferritin:0-1");	
			run("Close");
	}
				if (isOpen("488Merge") == true) {
		selectWindow("488Merge");	
			run("Close");
	}
		if (isOpen("bing") == true) {
		selectWindow("bing");	
			run("Close");
	}
		if (isOpen("ting") == true) {
		selectWindow("ting");	
			run("Close");
	}	if (isOpen("bingting") == true) {
		selectWindow("bingting");	
			run("Close");
	}
	if (isOpen("FSubtract") == true) {
		selectWindow("FSubtract");	
			run("Close");
	}
	if (isOpen("FStandard") == true) {
		selectWindow("FStandard");	
			run("Close");
	}
		if (isOpen("647") == true) {
		selectWindow("647");	
			run("Close");
	}
		if (isOpen("Ferritin0-1") == true) {
		selectWindow("Ferritin0-1");	
			run("Close");
	}
		if (isOpen("FerritinOutlines0") == true) {
		selectWindow("FerritinOutlines0");	
			run("Close");
	}
		if (isOpen("Ferritin1+") == true) {
		selectWindow("Ferritin1+");	
			run("Close");
	}
		if (isOpen("FerritinOutlines1+") == true) {
		selectWindow("FerritinOutlines1+");	
			run("Close");
	}
		if (isOpen("488") == true) {
		selectWindow("488");	
			run("Close");
	}
		if (isOpen("ASubtract") == true) {
		selectWindow("ASubtract");	
			run("Close");
	}
		if (isOpen("AStandard") == true) {
		selectWindow("AStandard");	
			run("Close");
	}
		if (isOpen("488x") == true) {
		selectWindow("488x");	
			run("Close");
	}
		if (isOpen("A0.5-1") == true) {
		selectWindow("A0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn0.5-1") == true) {
		selectWindow("Asyn0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn:0.5-1") == true) {
		selectWindow("Asyn:0.5-1");	
			run("Close");
	}
		if (isOpen("A1-2") == true) {
		selectWindow("A1-2");	
			run("Close");
	}	
	if (isOpen("Asyn1-2") == true) {
		selectWindow("Asyn1-2");	
			run("Close");
	}
		if (isOpen("Asyn:1-2") == true) {
		selectWindow("Asyn:1-2");	
			run("Close");
	}
		if (isOpen("A2-4") == true) {
		selectWindow("A2-4");	
			run("Close");
	}	
			if (isOpen("A2-4.tif") == true) {
		selectWindow("A2-4.tif");	
			run("Close");
	}	
	if (isOpen("Asyn:2-4") == true) {
		selectWindow("Asyn:2-4");	
			run("Close");
	}
	if (isOpen("Asyn2-4") == true) {
		selectWindow("Asyn2-4");	
			run("Close");
	}	
	if (isOpen("A4+") == true) {
		selectWindow("A4+");	
			run("Close");
	}	
	if (isOpen("Asyn4+") == true) {
		selectWindow("Asyn4+");	
			run("Close");
	}
		if (isOpen("Asyn:4+") == true) {
		selectWindow("Asyn:4+");	
			run("Close");
	}
		if (isOpen("AsynOutlines4+.tif") == true) {
		selectWindow("AsynOutlines4+.tif");	
			run("Close");
	}
		if (isOpen("AsynOutlines2-4.tif") == true) {
		selectWindow("AsynOutlines2-4.tif");	
			run("Close");
	}
		if (isOpen("A4+.tif") == true) {
		selectWindow("A4+.tif");	
			run("Close");
	}
		if (isOpen("647Merge") == true) {
		selectWindow("647Merge");	
			run("Close");
	}
			if (isOpen("AsynOutlines1-2.tif") == true) {
		selectWindow("AsynOutlines1-2.tif");	
			run("Close");
	}
			if (isOpen("A1-2.tif") == true) {
		selectWindow("A1-2.tif");	
			run("Close");
	}
			if (isOpen("AsynOutlines0.5-1.tif") == true) {
		selectWindow("AsynOutlines0.5-1.tif");	
			run("Close");
	}
			if (isOpen("A0.5-1.tif") == true) {
		selectWindow("A0.5-1.tif");	
			run("Close");
	}
			if (isOpen("AsynTouchedUp.tif") == true) {
		selectWindow("AsynTouchedUp.tif");	
			run("Close");
	}
			if (isOpen("FerritinOutlines1.tif") == true) {
		selectWindow("FerritinOutlines1.tif");	
			run("Close");
	}
				if (isOpen("Ferritin1+.tif") == true) {
		selectWindow("Ferritin1+.tif");	
			run("Close");
	}
				if (isOpen("FerritinOutlines0.tif") == true) {
		selectWindow("FerritinOutlines0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin0-1.tif") == true) {
		selectWindow("Ferritin0-1.tif");	
			run("Close");
	}
				if (isOpen("FerritinBinary0.tif") == true) {
		selectWindow("FerritinBinary0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin:1+") == true) {
		selectWindow("Ferritin:1+");	
			run("Close");
	}
				if (isOpen("Ferritin:0-1") == true) {
		selectWindow("Ferritin:0-1");	
			run("Close");
	}
				if (isOpen("488Merge") == true) {
		selectWindow("488Merge");	
			run("Close");
	}
		if (isOpen("bing") == true) {
		selectWindow("bing");	
			run("Close");
	}
		if (isOpen("ting") == true) {
		selectWindow("ting");	
			run("Close");
	}	if (isOpen("bingting") == true) {
		selectWindow("bingting");	
			run("Close");
	}
}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if (isOpen("g.nd2") == true) {

selectWindow("g.nd2");
gamma = getInfo("image.directory");
	setBatchMode(false);
		rename("BeachBois");
			run("Split Channels");
				selectWindow("C1-BeachBois");
					rename("Nuclei");
						selectWindow("C2-BeachBois");
							rename("488");
								selectWindow("C3-BeachBois");
									rename("647");
	run("Set Measurements...", "area add redirect=None decimal=3");
	run("3D OC Options", "volume surface nb_of_obj._voxels nb_of_surf._voxels dots_size=5 font_size=10 store_results_within_a_table_named_after_the_image_(macro_friendly) redirect_to=none");

	run("Coloc 2", "channel_1=647 channel_2=488 roi_or_mask=<None> threshold_regression=Bisection psf=3 costes_randomisations=1");
		selectWindow("Log");
			saveAs("Txt", gamma + "Colocal");
				run("Close");

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
		
//647 Identification
	 rename("FSubtract");
			run("Duplicate...", "title=FStandard stack duplicate");
				run("Subtract Background...", "rolling=21 sliding disable stack");
					run("Subtract Background...", "rolling=21 stack");
						run("Duplicate...", "title=647Merge stack duplicate");
						
			selectWindow("FSubtract");
				run("Subtract Background...", "rolling=5 stack");
				run("Subtract Background...", "rolling=5 stack");
					
					
			imageCalculator("Add create stack", "FSubtract", "FStandard");
				

					setSlice(brightestSlice);
						setAutoThreshold("Default dark");
							//run("Threshold...");
								resetThreshold(); 
								rename("647");
															run("Duplicate...", "title=647ForSave stack duplicate");
															selectWindow("647");

			setAutoThreshold("IsoData dark");
				//run("Threshold...");
					setAutoThreshold("IsoData dark");
						setOption("BlackBackground", true);
							run("Convert to Mask", "method=IsoData background=Dark black");

//647 Counting (0-1)
	run("Analyze Particles...", "size=0.1-1 show=[Masks] stack");
		rename("Ferritin0-1");
		getStatistics(area, mean, min, max, std, histogram);
			if (max < 128) threshold = max;
				else threshold = 128;
					run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
						setSlice(brightestSlice);
						
	 setAutoThreshold("Default dark");
		//run("Threshold...");
			setAutoThreshold("Default dark stack");
				setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Ferritin:0-1 stack duplicate");	
			run("16-bit");		
				selectWindow("Objects map of Ferritin0-1");
															run("Duplicate...", "title=Ferritin0-1BinaryForSave stack duplicate");
															selectWindow("Objects map of Ferritin0-1");

						run("Outline", "stack Yes");
							rename("FerritinOutlines0");
								run("16-bit");
															run("Duplicate...", "title=FerritinOutlines0ForSave stack duplicate");

		
//647 Counting (1-Infinity)		
	selectWindow("647");
		run("Analyze Particles...", "size=1.001-Infinity show=[Masks] stack");
			rename("Ferritin1+");
		
		getStatistics(area, mean, min, max, std, histogram);
			if (max < 128) threshold = max;
				else threshold = 128;
					run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
						setSlice(brightestSlice);
	
	selectWindow("Objects map of Ferritin1+");		
		 setAutoThreshold("Default dark");
			//run("Threshold...");
				setAutoThreshold("Default dark stack");
					setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");	
			run("Duplicate...", "title=Ferritin:1+ stack duplicate");				
				selectWindow("Objects map of Ferritin1+");
															run("Duplicate...", "title=Ferritin1+BinaryForSave stack duplicate");
															selectWindow("Objects map of Ferritin1+");
					
					run("Outline", "stack Yes");
						rename("FerritinOutlines1+");
							run("16-bit");
															run("Duplicate...", "title=FerritinOutlines1+ForSave stack duplicate");


//Asyn Preparation
	selectWindow("488");
		setSlice(brightestSlice);
			rename("ASubtract");
			
	run("Duplicate...", "title=AStandard stack duplicate");
		run("Subtract Background...", "rolling=21 stack sliding disable");
			run("Subtract Background...", "rolling=21 stack");
				run("Duplicate...", "title=488Merge stack duplicate");
				
	selectWindow("ASubtract");
		run("Subtract Background...", "rolling=2 stack");
			run("Subtract Background...", "rolling=2 stack");
														


				
	imageCalculator("Add create stack", "ASubtract", "AStandard");
		setSlice(brightestSlice);
			setAutoThreshold("Default dark");
				//run("Threshold...");
					resetThreshold();
						setSlice(brightestSlice);
						rename("488x");
													run("Duplicate...", "title=AsynSubtractedForSave stack duplicate");
													selectWindow("488x");

	setAutoThreshold("Default dark");
		//run("Threshold...");
			run("Convert to Mask", "method=Triangle background=Dark black");
				rename("488");

//488 Counting 0.5-1
	selectWindow("488");
		run("Analyze Particles...", "size=0.5-1 show=[Masks] stack");
			rename("A0.5-1");
		
	getStatistics(area, mean, min, max, std, histogram);
	  if (max < 128) threshold = max;
	 	 else threshold = 128;
	 		 run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");

	selectWindow("Objects map of A0.5-1");
		setSlice(brightestSlice);		
		 setAutoThreshold("Default dark");
			//run("Threshold...");
				setAutoThreshold("Default dark stack");
					setThreshold(1, 65535);
					
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
										run("Duplicate...", "title=Asyn0.5-1 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A0.5-1");
															run("Duplicate...", "title=A0.5-1ForSave stack duplicate");
															selectWindow("Objects map of A0.5-1");
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:0.5-1");
															run("Duplicate...", "title=AsynOutlines0.5-1ForSave stack duplicate");
															
						
//488 Counting 1-2
	selectWindow("488");
		run("Analyze Particles...", "size=1.001-2 show=[Masks] stack");
			rename("A1-2");
			
	getStatistics(area, mean, min, max, std, histogram);
	  if (max < 128) threshold = max;
		else threshold = 128;
	 		run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
				setSlice(brightestSlice);
		
	selectWindow("Objects map of A1-2");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn1-2 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A1-2");
															run("Duplicate...", "title=A1-2ForSave stack duplicate");
															selectWindow("Objects map of A1-2");
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:1-2");
															run("Duplicate...", "title=AsynOutlines1-2ForSave stack duplicate");
															

//488 Counting 2-4
selectWindow("488");
	run("Analyze Particles...", "size=2.001-4 show=[Masks] stack");
		rename("A2-4");
		
	getStatistics(area, mean, min, max, std, histogram);
		if (max < 128) threshold = max;
			else threshold = 128;
				run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
					setSlice(brightestSlice);

	selectWindow("Objects map of A2-4");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn2-4 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A2-4");
															run("Duplicate...", "title=A2-4ForSave stack duplicate");
															selectWindow("Objects map of A2-4");
																				
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:2-4");
															run("Duplicate...", "title=AsynOutlines2-4ForSave stack duplicate");
																						

//488 Counting 4+
selectWindow("488");
	run("Analyze Particles...", "size=4.001-Infinity show=[Masks] stack");
		rename("A4+");
		
	getStatistics(area, mean, min, max, std, histogram);
		if (max < 128) threshold = max;
			else threshold = 128;
				run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
					setSlice(brightestSlice);

	selectWindow("Objects map of A4+");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn4+ stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A4+");
															run("Duplicate...", "title=A4+ForSave stack duplicate");
															selectWindow("Objects map of A4+");
															
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:4+");
															run("Duplicate...", "title=AsynOutlines4+ForSave stack duplicate");
															
	imageCalculator("Add create stack", "Asyn2-4", "Asyn4+");
			rename("bing");	
	imageCalculator("Add create stack", "Asyn0.5-1", "Asyn1-2");	
			rename("ting");
	imageCalculator("Add create stack", "bing", "ting");
			rename("bingting");															


//Merging & Saving Images
	run("Merge Channels...", "c4=[FerritinOutlines0] c1=[647Merge] c7=[FerritinOutlines1+] create keep");
		rename("aFerritinOutlinesA");
															
															saveAs("Tiff", gamma + "aFerritinOutlinesA");
															close();
														
	selectWindow("Ferritin:0-1");
		run("16-bit");
			selectWindow("Ferritin:1+");
				run("16-bit");
	run("Merge Channels...", "c4=[Ferritin:0-1] c1=[Ferritin:1+] c3=Nuclei create keep");
		rename("aFerritinBinaryB");
															
															saveAs("Tiff", gamma + "aFerritinBinaryB");
															close();
													
	
	selectWindow("bing");
		run("16-bit");	
			run("Merge Channels...", "c4=[Ferritin:0-1] c2=bing c1=[Ferritin:1+] create keep");
				rename("aFerritin+AsynTotalC");
															
															saveAs("Tiff", gamma + "aFerritin+AsynTotalC");
															close();
														
															

	selectWindow("bingting");
		run("16-bit");	
			run("Merge Channels...", "c1=647Merge c2=488Merge c3=Nuclei c4=bingting create keep");
				rename("aWholeMergD");
															
															saveAs("Tiff", gamma + "aWholeMergD");
															close();
													
		
	run("Merge Channels...", "c1=647Merge c2=488Merge c3=Nuclei c4=[Asyn:0.5-1] c5=[Asyn:1-2] c6=[Asyn:2-4] c7=[Asyn:4+] create keep");
		rename("aSegmentedMergE");
															
															saveAs("Tiff", gamma + "aSegmentedMergE");
															close();
													

//Saving & Closingn Relavent Windows
if (isOpen("Ferritin0-1BinaryForSave") == true) {
															selectWindow("Ferritin0-1BinaryForSave");	
																	saveAs("Tiff", gamma + "FerritinBinary0");
															}
if (isOpen("FerritinOutlines0ForSave") == true) {	
															selectWindow("FerritinOutlines0ForSave");	
																	saveAs("Tiff", gamma + "Ferritin0-1");
}
if (isOpen("Ferritin1+BinaryForSave") == true) {	
															selectWindow("Ferritin1+BinaryForSave");	
																	saveAs("Tiff", gamma + "FerritinOutlines0");
}
if (isOpen("FerritinOutlines1+ForSave") == true) {
															selectWindow("FerritinOutlines1+ForSave");	
																	saveAs("Tiff", gamma + "Ferritin1+");
}
if (isOpen("647ForSave") == true) {
															selectWindow("647ForSave");	
																	saveAs("Tiff", gamma + "FerritinOutlines1");
}
if (isOpen("AsynSubtractedForSave") == true) {
															selectWindow("AsynSubtractedForSave");	
																	saveAs("Tiff", gamma + "AsynTouchedUp");
}
if (isOpen("A0.5-1ForSave") == true) {
															selectWindow("A0.5-1ForSave");	
																	saveAs("Tiff", gamma + "A0.5-1");
}
if (isOpen("AsynOutlines0.5-1ForSave") == true) {
															selectWindow("AsynOutlines0.5-1ForSave");	
																	saveAs("Tiff", gamma + "AsynOutlines0.5-1");
}
if (isOpen("A1-2ForSave") == true) {
															selectWindow("A1-2ForSave");	
																	saveAs("Tiff", gamma + "A1-2");
}
if (isOpen("AsynOutlines1-2ForSave") == true) {
															selectWindow("AsynOutlines1-2ForSave");	
																	saveAs("Tiff", gamma + "AsynOutlines1-2");
}
if (isOpen("A2-4ForSave") == true) {	
															selectWindow("A2-4ForSave");	
																	saveAs("Tiff", gamma + "A2-4");
}
if (isOpen("AsynOutlines2-4ForSave") == true) {		
														selectWindow("AsynOutlines2-4ForSave");	
																	saveAs("Tiff", gamma + "AsynOutlines2-4");
}
if (isOpen("A4+ForSave") == true) {	
															selectWindow("A4+ForSave");	
																	saveAs("Tiff", gamma + "A4+");
}
if (isOpen("AsynOutlines4+ForSave") == true) {
															selectWindow("AsynOutlines4+ForSave");	
																	saveAs("Tiff", gamma + "AsynOutlines4+");
}
															
														
	
//saving log and statistics
	selectWindow("Log");	
		{
			saveAs("Text", gamma + "Counts");
				
		} 
		run("Close");
	
	selectWindow("Statistics for A4+");	
		{
			saveAs("Results", gamma + "Statistics for A4+");
				
		}
		run("Close");
	
	selectWindow("Statistics for A2-4");	
		{
			saveAs("Results", gamma + "Statistics for A2-4");
				
		}
		run("Close");
	
	selectWindow("Statistics for A1-2");	
		{
			saveAs("Results", gamma + "Statistics for A1-2");
				
		}
		run("Close");
		
	selectWindow("Statistics for A0.5-1");	
		{
			saveAs("Results", gamma + "Statistics for A0.5-1");
				
		}
		run("Close");
	
	selectWindow("Statistics for Ferritin1+");	
		{
			saveAs("Results", gamma + "Statistics for Ferritin1+");
				
		}
		run("Close");
	
	selectWindow("Statistics for Ferritin0-1");	
		{
			saveAs("Results", gamma + "Statistics for Ferritin0-1");
				
		}
		run("Close");

selectWindow("Nuclei");
run("Z Project...", "projection=[Max Intensity]");
rename("NucleiA");
saveAs("tif", gamma + "Nuclei for Counting");

if (isOpen("Nuclei") == true) {
	selectWindow("Nuclei");
		run("Close");
}
	if (isOpen("Nuclei for Counting.tif") == true) {
	selectWindow("Nuclei for Counting.tif");
		run("Close");
}
	if (isOpen("FSubtract") == true) {
		selectWindow("FSubtract");	
			run("Close");
	}
	if (isOpen("FStandard") == true) {
		selectWindow("FStandard");	
			run("Close");
	}
		if (isOpen("647") == true) {
		selectWindow("647");	
			run("Close");
	}
		if (isOpen("Ferritin0-1") == true) {
		selectWindow("Ferritin0-1");	
			run("Close");
	}
		if (isOpen("FerritinOutlines0") == true) {
		selectWindow("FerritinOutlines0");	
			run("Close");
	}
		if (isOpen("Ferritin1+") == true) {
		selectWindow("Ferritin1+");	
			run("Close");
	}
		if (isOpen("FerritinOutlines1+") == true) {
		selectWindow("FerritinOutlines1+");	
			run("Close");
	}
		if (isOpen("488") == true) {
		selectWindow("488");	
			run("Close");
	}
		if (isOpen("ASubtract") == true) {
		selectWindow("ASubtract");	
			run("Close");
	}
		if (isOpen("AStandard") == true) {
		selectWindow("AStandard");	
			run("Close");
	}
		if (isOpen("488x") == true) {
		selectWindow("488x");	
			run("Close");
	}
		if (isOpen("A0.5-1") == true) {
		selectWindow("A0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn0.5-1") == true) {
		selectWindow("Asyn0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn:0.5-1") == true) {
		selectWindow("Asyn:0.5-1");	
			run("Close");
	}
		if (isOpen("A1-2") == true) {
		selectWindow("A1-2");	
			run("Close");
	}	
	if (isOpen("Asyn1-2") == true) {
		selectWindow("Asyn1-2");	
			run("Close");
	}
		if (isOpen("Asyn:1-2") == true) {
		selectWindow("Asyn:1-2");	
			run("Close");
	}
		if (isOpen("A2-4") == true) {
		selectWindow("A2-4");	
			run("Close");
	}	
			if (isOpen("A2-4.tif") == true) {
		selectWindow("A2-4.tif");	
			run("Close");
	}	
	if (isOpen("Asyn:2-4") == true) {
		selectWindow("Asyn:2-4");	
			run("Close");
	}
	if (isOpen("Asyn2-4") == true) {
		selectWindow("Asyn2-4");	
			run("Close");
	}	
	if (isOpen("A4+") == true) {
		selectWindow("A4+");	
			run("Close");
	}	
	if (isOpen("Asyn4+") == true) {
		selectWindow("Asyn4+");	
			run("Close");
	}
		if (isOpen("Asyn:4+") == true) {
		selectWindow("Asyn:4+");	
			run("Close");
	}
		if (isOpen("AsynOutlines4+.tif") == true) {
		selectWindow("AsynOutlines4+.tif");	
			run("Close");
	}
		if (isOpen("AsynOutlines2-4.tif") == true) {
		selectWindow("AsynOutlines2-4.tif");	
			run("Close");
	}
		if (isOpen("A4+.tif") == true) {
		selectWindow("A4+.tif");	
			run("Close");
	}
		if (isOpen("647Merge") == true) {
		selectWindow("647Merge");	
			run("Close");
	}
			if (isOpen("AsynOutlines1-2.tif") == true) {
		selectWindow("AsynOutlines1-2.tif");	
			run("Close");
	}
			if (isOpen("A1-2.tif") == true) {
		selectWindow("A1-2.tif");	
			run("Close");
	}
			if (isOpen("AsynOutlines0.5-1.tif") == true) {
		selectWindow("AsynOutlines0.5-1.tif");	
			run("Close");
	}
			if (isOpen("A0.5-1.tif") == true) {
		selectWindow("A0.5-1.tif");	
			run("Close");
	}
			if (isOpen("AsynTouchedUp.tif") == true) {
		selectWindow("AsynTouchedUp.tif");	
			run("Close");
	}
			if (isOpen("FerritinOutlines1.tif") == true) {
		selectWindow("FerritinOutlines1.tif");	
			run("Close");
	}
				if (isOpen("Ferritin1+.tif") == true) {
		selectWindow("Ferritin1+.tif");	
			run("Close");
	}
				if (isOpen("FerritinOutlines0.tif") == true) {
		selectWindow("FerritinOutlines0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin0-1.tif") == true) {
		selectWindow("Ferritin0-1.tif");	
			run("Close");
	}
				if (isOpen("FerritinBinary0.tif") == true) {
		selectWindow("FerritinBinary0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin:1+") == true) {
		selectWindow("Ferritin:1+");	
			run("Close");
	}
				if (isOpen("Ferritin:0-1") == true) {
		selectWindow("Ferritin:0-1");	
			run("Close");
	}
				if (isOpen("488Merge") == true) {
		selectWindow("488Merge");	
			run("Close");
	}
		if (isOpen("bing") == true) {
		selectWindow("bing");	
			run("Close");
	}
		if (isOpen("ting") == true) {
		selectWindow("ting");	
			run("Close");
	}	if (isOpen("bingting") == true) {
		selectWindow("bingting");	
			run("Close");
	}
	if (isOpen("FSubtract") == true) {
		selectWindow("FSubtract");	
			run("Close");
	}
	if (isOpen("FStandard") == true) {
		selectWindow("FStandard");	
			run("Close");
	}
		if (isOpen("647") == true) {
		selectWindow("647");	
			run("Close");
	}
		if (isOpen("Ferritin0-1") == true) {
		selectWindow("Ferritin0-1");	
			run("Close");
	}
		if (isOpen("FerritinOutlines0") == true) {
		selectWindow("FerritinOutlines0");	
			run("Close");
	}
		if (isOpen("Ferritin1+") == true) {
		selectWindow("Ferritin1+");	
			run("Close");
	}
		if (isOpen("FerritinOutlines1+") == true) {
		selectWindow("FerritinOutlines1+");	
			run("Close");
	}
		if (isOpen("488") == true) {
		selectWindow("488");	
			run("Close");
	}
		if (isOpen("ASubtract") == true) {
		selectWindow("ASubtract");	
			run("Close");
	}
		if (isOpen("AStandard") == true) {
		selectWindow("AStandard");	
			run("Close");
	}
		if (isOpen("488x") == true) {
		selectWindow("488x");	
			run("Close");
	}
		if (isOpen("A0.5-1") == true) {
		selectWindow("A0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn0.5-1") == true) {
		selectWindow("Asyn0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn:0.5-1") == true) {
		selectWindow("Asyn:0.5-1");	
			run("Close");
	}
		if (isOpen("A1-2") == true) {
		selectWindow("A1-2");	
			run("Close");
	}	
	if (isOpen("Asyn1-2") == true) {
		selectWindow("Asyn1-2");	
			run("Close");
	}
		if (isOpen("Asyn:1-2") == true) {
		selectWindow("Asyn:1-2");	
			run("Close");
	}
		if (isOpen("A2-4") == true) {
		selectWindow("A2-4");	
			run("Close");
	}	
			if (isOpen("A2-4.tif") == true) {
		selectWindow("A2-4.tif");	
			run("Close");
	}	
	if (isOpen("Asyn:2-4") == true) {
		selectWindow("Asyn:2-4");	
			run("Close");
	}
	if (isOpen("Asyn2-4") == true) {
		selectWindow("Asyn2-4");	
			run("Close");
	}	
	if (isOpen("A4+") == true) {
		selectWindow("A4+");	
			run("Close");
	}	
	if (isOpen("Asyn4+") == true) {
		selectWindow("Asyn4+");	
			run("Close");
	}
		if (isOpen("Asyn:4+") == true) {
		selectWindow("Asyn:4+");	
			run("Close");
	}
		if (isOpen("AsynOutlines4+.tif") == true) {
		selectWindow("AsynOutlines4+.tif");	
			run("Close");
	}
		if (isOpen("AsynOutlines2-4.tif") == true) {
		selectWindow("AsynOutlines2-4.tif");	
			run("Close");
	}
		if (isOpen("A4+.tif") == true) {
		selectWindow("A4+.tif");	
			run("Close");
	}
		if (isOpen("647Merge") == true) {
		selectWindow("647Merge");	
			run("Close");
	}
			if (isOpen("AsynOutlines1-2.tif") == true) {
		selectWindow("AsynOutlines1-2.tif");	
			run("Close");
	}
			if (isOpen("A1-2.tif") == true) {
		selectWindow("A1-2.tif");	
			run("Close");
	}
			if (isOpen("AsynOutlines0.5-1.tif") == true) {
		selectWindow("AsynOutlines0.5-1.tif");	
			run("Close");
	}
			if (isOpen("A0.5-1.tif") == true) {
		selectWindow("A0.5-1.tif");	
			run("Close");
	}
			if (isOpen("AsynTouchedUp.tif") == true) {
		selectWindow("AsynTouchedUp.tif");	
			run("Close");
	}
			if (isOpen("FerritinOutlines1.tif") == true) {
		selectWindow("FerritinOutlines1.tif");	
			run("Close");
	}
				if (isOpen("Ferritin1+.tif") == true) {
		selectWindow("Ferritin1+.tif");	
			run("Close");
	}
				if (isOpen("FerritinOutlines0.tif") == true) {
		selectWindow("FerritinOutlines0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin0-1.tif") == true) {
		selectWindow("Ferritin0-1.tif");	
			run("Close");
	}
				if (isOpen("FerritinBinary0.tif") == true) {
		selectWindow("FerritinBinary0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin:1+") == true) {
		selectWindow("Ferritin:1+");	
			run("Close");
	}
				if (isOpen("Ferritin:0-1") == true) {
		selectWindow("Ferritin:0-1");	
			run("Close");
	}
				if (isOpen("488Merge") == true) {
		selectWindow("488Merge");	
			run("Close");
	}
		if (isOpen("bing") == true) {
		selectWindow("bing");	
			run("Close");
	}
		if (isOpen("ting") == true) {
		selectWindow("ting");	
			run("Close");
	}	if (isOpen("bingting") == true) {
		selectWindow("bingting");	
			run("Close");
	}
}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if (isOpen("f.nd2") == true) {

selectWindow("f.nd2");
fumarate = getInfo("image.directory");
	setBatchMode(false);
		rename("BeachBois");
			run("Split Channels");
				selectWindow("C1-BeachBois");
					rename("Nuclei");
						selectWindow("C2-BeachBois");
							rename("488");
								selectWindow("C3-BeachBois");
									rename("647");
	run("Set Measurements...", "area add redirect=None decimal=3");
	run("3D OC Options", "volume surface nb_of_obj._voxels nb_of_surf._voxels dots_size=5 font_size=10 store_results_within_a_table_named_after_the_image_(macro_friendly) redirect_to=none");

	run("Coloc 2", "channel_1=647 channel_2=488 roi_or_mask=<None> threshold_regression=Bisection psf=3 costes_randomisations=1");
		selectWindow("Log");
			saveAs("Txt", fumarate + "Colocal");
				run("Close");

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
		
//647 Identification
	 rename("FSubtract");
			run("Duplicate...", "title=FStandard stack duplicate");
				run("Subtract Background...", "rolling=21 sliding disable stack");
					run("Subtract Background...", "rolling=21 stack");
						run("Duplicate...", "title=647Merge stack duplicate");
						
			selectWindow("FSubtract");
				run("Subtract Background...", "rolling=5 stack");
				run("Subtract Background...", "rolling=5 stack");
					
					
			imageCalculator("Add create stack", "FSubtract", "FStandard");
				

					setSlice(brightestSlice);
						setAutoThreshold("Default dark");
							//run("Threshold...");
								resetThreshold(); 
								rename("647");
															run("Duplicate...", "title=647ForSave stack duplicate");
															selectWindow("647");

			setAutoThreshold("IsoData dark");
				//run("Threshold...");
					setAutoThreshold("IsoData dark");
						setOption("BlackBackground", true);
							run("Convert to Mask", "method=IsoData background=Dark black");

//647 Counting (0-1)
	run("Analyze Particles...", "size=0.1-1 show=[Masks] stack");
		rename("Ferritin0-1");
		getStatistics(area, mean, min, max, std, histogram);
			if (max < 128) threshold = max;
				else threshold = 128;
					run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
						setSlice(brightestSlice);
						
	 setAutoThreshold("Default dark");
		//run("Threshold...");
			setAutoThreshold("Default dark stack");
				setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Ferritin:0-1 stack duplicate");	
			run("16-bit");		
				selectWindow("Objects map of Ferritin0-1");
															run("Duplicate...", "title=Ferritin0-1BinaryForSave stack duplicate");
															selectWindow("Objects map of Ferritin0-1");

						run("Outline", "stack Yes");
							rename("FerritinOutlines0");
								run("16-bit");
															run("Duplicate...", "title=FerritinOutlines0ForSave stack duplicate");

		
//647 Counting (1-Infinity)		
	selectWindow("647");
		run("Analyze Particles...", "size=1.001-Infinity show=[Masks] stack");
			rename("Ferritin1+");
		
		getStatistics(area, mean, min, max, std, histogram);
			if (max < 128) threshold = max;
				else threshold = 128;
					run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
						setSlice(brightestSlice);
	
	selectWindow("Objects map of Ferritin1+");		
		 setAutoThreshold("Default dark");
			//run("Threshold...");
				setAutoThreshold("Default dark stack");
					setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");	
			run("Duplicate...", "title=Ferritin:1+ stack duplicate");				
				selectWindow("Objects map of Ferritin1+");
															run("Duplicate...", "title=Ferritin1+BinaryForSave stack duplicate");
															selectWindow("Objects map of Ferritin1+");
					
					run("Outline", "stack Yes");
						rename("FerritinOutlines1+");
							run("16-bit");
															run("Duplicate...", "title=FerritinOutlines1+ForSave stack duplicate");


//Asyn Preparation
	selectWindow("488");
		setSlice(brightestSlice);
			rename("ASubtract");
			
	run("Duplicate...", "title=AStandard stack duplicate");
		run("Subtract Background...", "rolling=21 stack sliding disable");
			run("Subtract Background...", "rolling=21 stack");
				run("Duplicate...", "title=488Merge stack duplicate");
				
	selectWindow("ASubtract");
		run("Subtract Background...", "rolling=2 stack");
			run("Subtract Background...", "rolling=2 stack");
														


				
	imageCalculator("Add create stack", "ASubtract", "AStandard");
		setSlice(brightestSlice);
			setAutoThreshold("Default dark");
				//run("Threshold...");
					resetThreshold();
						setSlice(brightestSlice);
						rename("488x");
													run("Duplicate...", "title=AsynSubtractedForSave stack duplicate");
													selectWindow("488x");

	setAutoThreshold("Default dark");
		//run("Threshold...");
			run("Convert to Mask", "method=Triangle background=Dark black");
				rename("488");

//488 Counting 0.5-1
	selectWindow("488");
		run("Analyze Particles...", "size=0.5-1 show=[Masks] stack");
			rename("A0.5-1");
		
	getStatistics(area, mean, min, max, std, histogram);
	  if (max < 128) threshold = max;
	 	 else threshold = 128;
	 		 run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");

	selectWindow("Objects map of A0.5-1");
		setSlice(brightestSlice);		
		 setAutoThreshold("Default dark");
			//run("Threshold...");
				setAutoThreshold("Default dark stack");
					setThreshold(1, 65535);
					
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
										run("Duplicate...", "title=Asyn0.5-1 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A0.5-1");
															run("Duplicate...", "title=A0.5-1ForSave stack duplicate");
															selectWindow("Objects map of A0.5-1");
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:0.5-1");
															run("Duplicate...", "title=AsynOutlines0.5-1ForSave stack duplicate");
															
						
//488 Counting 1-2
	selectWindow("488");
		run("Analyze Particles...", "size=1.001-2 show=[Masks] stack");
			rename("A1-2");
			
	getStatistics(area, mean, min, max, std, histogram);
	  if (max < 128) threshold = max;
		else threshold = 128;
	 		run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
				setSlice(brightestSlice);
		
	selectWindow("Objects map of A1-2");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn1-2 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A1-2");
															run("Duplicate...", "title=A1-2ForSave stack duplicate");
															selectWindow("Objects map of A1-2");
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:1-2");
															run("Duplicate...", "title=AsynOutlines1-2ForSave stack duplicate");
															

//488 Counting 2-4
selectWindow("488");
	run("Analyze Particles...", "size=2.001-4 show=[Masks] stack");
		rename("A2-4");
		
	getStatistics(area, mean, min, max, std, histogram);
		if (max < 128) threshold = max;
			else threshold = 128;
				run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
					setSlice(brightestSlice);

	selectWindow("Objects map of A2-4");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn2-4 stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A2-4");
															run("Duplicate...", "title=A2-4ForSave stack duplicate");
															selectWindow("Objects map of A2-4");
																				
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:2-4");
															run("Duplicate...", "title=AsynOutlines2-4ForSave stack duplicate");
																						

//488 Counting 4+
selectWindow("488");
	run("Analyze Particles...", "size=4.001-Infinity show=[Masks] stack");
		rename("A4+");
		
	getStatistics(area, mean, min, max, std, histogram);
		if (max < 128) threshold = max;
			else threshold = 128;
				run("3D Objects Counter", "threshold=" + threshold + " slice=8 min.=10 max.=2124276 " + "objects statistics summary");
					setSlice(brightestSlice);

	selectWindow("Objects map of A4+");
		setSlice(brightestSlice);		
			setAutoThreshold("Default dark");
				//run("Threshold...");
					setAutoThreshold("Default dark stack");
						setThreshold(1, 65535);
				
	run("Make Binary", "stack Yes");
		run("Convert to Mask", "method=Default background=Light black");
			run("Duplicate...", "title=Asyn4+ stack duplicate");
				run("16-bit");		
					selectWindow("Objects map of A4+");
															run("Duplicate...", "title=A4+ForSave stack duplicate");
															selectWindow("Objects map of A4+");
															
															
						run("Outline", "stack Yes");
							run("16-bit");
								rename("Asyn:4+");
															run("Duplicate...", "title=AsynOutlines4+ForSave stack duplicate");
															
	imageCalculator("Add create stack", "Asyn2-4", "Asyn4+");
			rename("bing");	
	imageCalculator("Add create stack", "Asyn0.5-1", "Asyn1-2");	
			rename("ting");
	imageCalculator("Add create stack", "bing", "ting");
			rename("bingting");															


//Merging & Saving Images
	run("Merge Channels...", "c4=[FerritinOutlines0] c1=[647Merge] c7=[FerritinOutlines1+] create keep");
		rename("aFerritinOutlinesA");
															
															saveAs("Tiff", fumarate + "aFerritinOutlinesA");
															close();
														
	selectWindow("Ferritin:0-1");
		run("16-bit");
			selectWindow("Ferritin:1+");
				run("16-bit");
	run("Merge Channels...", "c4=[Ferritin:0-1] c1=[Ferritin:1+] c3=Nuclei create keep");
		rename("aFerritinBinaryB");
															
															saveAs("Tiff", fumarate + "aFerritinBinaryB");
															close();
													
	
	selectWindow("bing");
		run("16-bit");	
			run("Merge Channels...", "c4=[Ferritin:0-1] c2=bing c1=[Ferritin:1+] create keep");
				rename("aFerritin+AsynTotalC");
															
															saveAs("Tiff", fumarate + "aFerritin+AsynTotalC");
															close();
														
															

	selectWindow("bingting");
		run("16-bit");	
			run("Merge Channels...", "c1=647Merge c2=488Merge c3=Nuclei c4=bingting create keep");
				rename("aWholeMergD");
															
															saveAs("Tiff", fumarate + "aWholeMergD");
															close();
													
		
	run("Merge Channels...", "c1=647Merge c2=488Merge c3=Nuclei c4=[Asyn:0.5-1] c5=[Asyn:1-2] c6=[Asyn:2-4] c7=[Asyn:4+] create keep");
		rename("aSegmentedMergE");
															
															saveAs("Tiff", fumarate + "aSegmentedMergE");
															close();
													

//Saving & Closingn Relavent Windows
if (isOpen("Ferritin0-1BinaryForSave") == true) {
															selectWindow("Ferritin0-1BinaryForSave");	
																	saveAs("Tiff", fumarate + "FerritinBinary0");
															}
if (isOpen("FerritinOutlines0ForSave") == true) {	
															selectWindow("FerritinOutlines0ForSave");	
																	saveAs("Tiff", fumarate + "Ferritin0-1");
}
if (isOpen("Ferritin1+BinaryForSave") == true) {	
															selectWindow("Ferritin1+BinaryForSave");	
																	saveAs("Tiff", fumarate + "FerritinOutlines0");
}
if (isOpen("FerritinOutlines1+ForSave") == true) {
															selectWindow("FerritinOutlines1+ForSave");	
																	saveAs("Tiff", fumarate + "Ferritin1+");
}
if (isOpen("647ForSave") == true) {
															selectWindow("647ForSave");	
																	saveAs("Tiff", fumarate + "FerritinOutlines1");
}
if (isOpen("AsynSubtractedForSave") == true) {
															selectWindow("AsynSubtractedForSave");	
																	saveAs("Tiff", fumarate + "AsynTouchedUp");
}
if (isOpen("A0.5-1ForSave") == true) {
															selectWindow("A0.5-1ForSave");	
																	saveAs("Tiff", fumarate + "A0.5-1");
}
if (isOpen("AsynOutlines0.5-1ForSave") == true) {
															selectWindow("AsynOutlines0.5-1ForSave");	
																	saveAs("Tiff", fumarate + "AsynOutlines0.5-1");
}
if (isOpen("A1-2ForSave") == true) {
															selectWindow("A1-2ForSave");	
																	saveAs("Tiff", fumarate + "A1-2");
}
if (isOpen("AsynOutlines1-2ForSave") == true) {
															selectWindow("AsynOutlines1-2ForSave");	
																	saveAs("Tiff", fumarate + "AsynOutlines1-2");
}
if (isOpen("A2-4ForSave") == true) {	
															selectWindow("A2-4ForSave");	
																	saveAs("Tiff", fumarate + "A2-4");
}
if (isOpen("AsynOutlines2-4ForSave") == true) {		
														selectWindow("AsynOutlines2-4ForSave");	
																	saveAs("Tiff", fumarate + "AsynOutlines2-4");
}
if (isOpen("A4+ForSave") == true) {	
															selectWindow("A4+ForSave");	
																	saveAs("Tiff", fumarate + "A4+");
}
if (isOpen("AsynOutlines4+ForSave") == true) {
															selectWindow("AsynOutlines4+ForSave");	
																	saveAs("Tiff", fumarate + "AsynOutlines4+");
}
															
														
	
//saving log and statistics
	selectWindow("Log");	
		{
			saveAs("Text", fumarate + "Counts");
				
		} 
		run("Close");
	
	selectWindow("Statistics for A4+");	
		{
			saveAs("Results", fumarate + "Statistics for A4+");
				
		}
		run("Close");
	
	selectWindow("Statistics for A2-4");	
		{
			saveAs("Results", fumarate + "Statistics for A2-4");
				
		}
		run("Close");
	
	selectWindow("Statistics for A1-2");	
		{
			saveAs("Results", fumarate + "Statistics for A1-2");
				
		}
		run("Close");
		
	selectWindow("Statistics for A0.5-1");	
		{
			saveAs("Results", fumarate + "Statistics for A0.5-1");
				
		}
		run("Close");
	
	selectWindow("Statistics for Ferritin1+");	
		{
			saveAs("Results", fumarate + "Statistics for Ferritin1+");
				
		}
		run("Close");
	
	selectWindow("Statistics for Ferritin0-1");	
		{
			saveAs("Results", fumarate + "Statistics for Ferritin0-1");
				
		}
		run("Close");

selectWindow("Nuclei");
run("Z Project...", "projection=[Max Intensity]");
rename("NucleiA");
saveAs("tif", fumarate + "Nuclei for Counting");

if (isOpen("Nuclei") == true) {
	selectWindow("Nuclei");
		run("Close");
}
	if (isOpen("Nuclei for Counting.tif") == true) {
	selectWindow("Nuclei for Counting.tif");
		run("Close");
}

	if (isOpen("FSubtract") == true) {
		selectWindow("FSubtract");	
			run("Close");
	}
	if (isOpen("FStandard") == true) {
		selectWindow("FStandard");	
			run("Close");
	}
		if (isOpen("647") == true) {
		selectWindow("647");	
			run("Close");
	}
		if (isOpen("Ferritin0-1") == true) {
		selectWindow("Ferritin0-1");	
			run("Close");
	}
		if (isOpen("FerritinOutlines0") == true) {
		selectWindow("FerritinOutlines0");	
			run("Close");
	}
		if (isOpen("Ferritin1+") == true) {
		selectWindow("Ferritin1+");	
			run("Close");
	}
		if (isOpen("FerritinOutlines1+") == true) {
		selectWindow("FerritinOutlines1+");	
			run("Close");
	}
		if (isOpen("488") == true) {
		selectWindow("488");	
			run("Close");
	}
		if (isOpen("ASubtract") == true) {
		selectWindow("ASubtract");	
			run("Close");
	}
		if (isOpen("AStandard") == true) {
		selectWindow("AStandard");	
			run("Close");
	}
		if (isOpen("488x") == true) {
		selectWindow("488x");	
			run("Close");
	}
		if (isOpen("A0.5-1") == true) {
		selectWindow("A0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn0.5-1") == true) {
		selectWindow("Asyn0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn:0.5-1") == true) {
		selectWindow("Asyn:0.5-1");	
			run("Close");
	}
		if (isOpen("A1-2") == true) {
		selectWindow("A1-2");	
			run("Close");
	}	
	if (isOpen("Asyn1-2") == true) {
		selectWindow("Asyn1-2");	
			run("Close");
	}
		if (isOpen("Asyn:1-2") == true) {
		selectWindow("Asyn:1-2");	
			run("Close");
	}
		if (isOpen("A2-4") == true) {
		selectWindow("A2-4");	
			run("Close");
	}	
			if (isOpen("A2-4.tif") == true) {
		selectWindow("A2-4.tif");	
			run("Close");
	}	
	if (isOpen("Asyn:2-4") == true) {
		selectWindow("Asyn:2-4");	
			run("Close");
	}
	if (isOpen("Asyn2-4") == true) {
		selectWindow("Asyn2-4");	
			run("Close");
	}	
	if (isOpen("A4+") == true) {
		selectWindow("A4+");	
			run("Close");
	}	
	if (isOpen("Asyn4+") == true) {
		selectWindow("Asyn4+");	
			run("Close");
	}
		if (isOpen("Asyn:4+") == true) {
		selectWindow("Asyn:4+");	
			run("Close");
	}
		if (isOpen("AsynOutlines4+.tif") == true) {
		selectWindow("AsynOutlines4+.tif");	
			run("Close");
	}
		if (isOpen("AsynOutlines2-4.tif") == true) {
		selectWindow("AsynOutlines2-4.tif");	
			run("Close");
	}
		if (isOpen("A4+.tif") == true) {
		selectWindow("A4+.tif");	
			run("Close");
	}
		if (isOpen("647Merge") == true) {
		selectWindow("647Merge");	
			run("Close");
	}
			if (isOpen("AsynOutlines1-2.tif") == true) {
		selectWindow("AsynOutlines1-2.tif");	
			run("Close");
	}
			if (isOpen("A1-2.tif") == true) {
		selectWindow("A1-2.tif");	
			run("Close");
	}
			if (isOpen("AsynOutlines0.5-1.tif") == true) {
		selectWindow("AsynOutlines0.5-1.tif");	
			run("Close");
	}
			if (isOpen("A0.5-1.tif") == true) {
		selectWindow("A0.5-1.tif");	
			run("Close");
	}
			if (isOpen("AsynTouchedUp.tif") == true) {
		selectWindow("AsynTouchedUp.tif");	
			run("Close");
	}
			if (isOpen("FerritinOutlines1.tif") == true) {
		selectWindow("FerritinOutlines1.tif");	
			run("Close");
	}
				if (isOpen("Ferritin1+.tif") == true) {
		selectWindow("Ferritin1+.tif");	
			run("Close");
	}
				if (isOpen("FerritinOutlines0.tif") == true) {
		selectWindow("FerritinOutlines0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin0-1.tif") == true) {
		selectWindow("Ferritin0-1.tif");	
			run("Close");
	}
				if (isOpen("FerritinBinary0.tif") == true) {
		selectWindow("FerritinBinary0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin:1+") == true) {
		selectWindow("Ferritin:1+");	
			run("Close");
	}
				if (isOpen("Ferritin:0-1") == true) {
		selectWindow("Ferritin:0-1");	
			run("Close");
	}
				if (isOpen("488Merge") == true) {
		selectWindow("488Merge");	
			run("Close");
	}

	
		if (isOpen("bing") == true) {
		selectWindow("bing");	
			run("Close");
	}
		if (isOpen("ting") == true) {
		selectWindow("ting");	
			run("Close");
	}	if (isOpen("bingting") == true) {
		selectWindow("bingting");	
			run("Close");
	}
	if (isOpen("FSubtract") == true) {
		selectWindow("FSubtract");	
			run("Close");
	}
	if (isOpen("FStandard") == true) {
		selectWindow("FStandard");	
			run("Close");
	}
		if (isOpen("647") == true) {
		selectWindow("647");	
			run("Close");
	}
		if (isOpen("Ferritin0-1") == true) {
		selectWindow("Ferritin0-1");	
			run("Close");
	}
		if (isOpen("FerritinOutlines0") == true) {
		selectWindow("FerritinOutlines0");	
			run("Close");
	}
		if (isOpen("Ferritin1+") == true) {
		selectWindow("Ferritin1+");	
			run("Close");
	}
		if (isOpen("FerritinOutlines1+") == true) {
		selectWindow("FerritinOutlines1+");	
			run("Close");
	}
		if (isOpen("488") == true) {
		selectWindow("488");	
			run("Close");
	}
		if (isOpen("ASubtract") == true) {
		selectWindow("ASubtract");	
			run("Close");
	}
		if (isOpen("AStandard") == true) {
		selectWindow("AStandard");	
			run("Close");
	}
		if (isOpen("488x") == true) {
		selectWindow("488x");	
			run("Close");
	}
		if (isOpen("A0.5-1") == true) {
		selectWindow("A0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn0.5-1") == true) {
		selectWindow("Asyn0.5-1");	
			run("Close");
	}
		if (isOpen("Asyn:0.5-1") == true) {
		selectWindow("Asyn:0.5-1");	
			run("Close");
	}
		if (isOpen("A1-2") == true) {
		selectWindow("A1-2");	
			run("Close");
	}	
	if (isOpen("Asyn1-2") == true) {
		selectWindow("Asyn1-2");	
			run("Close");
	}
		if (isOpen("Asyn:1-2") == true) {
		selectWindow("Asyn:1-2");	
			run("Close");
	}
		if (isOpen("A2-4") == true) {
		selectWindow("A2-4");	
			run("Close");
	}	
			if (isOpen("A2-4.tif") == true) {
		selectWindow("A2-4.tif");	
			run("Close");
	}	
	if (isOpen("Asyn:2-4") == true) {
		selectWindow("Asyn:2-4");	
			run("Close");
	}
	if (isOpen("Asyn2-4") == true) {
		selectWindow("Asyn2-4");	
			run("Close");
	}	
	if (isOpen("A4+") == true) {
		selectWindow("A4+");	
			run("Close");
	}	
	if (isOpen("Asyn4+") == true) {
		selectWindow("Asyn4+");	
			run("Close");
	}
		if (isOpen("Asyn:4+") == true) {
		selectWindow("Asyn:4+");	
			run("Close");
	}
		if (isOpen("AsynOutlines4+.tif") == true) {
		selectWindow("AsynOutlines4+.tif");	
			run("Close");
	}
		if (isOpen("AsynOutlines2-4.tif") == true) {
		selectWindow("AsynOutlines2-4.tif");	
			run("Close");
	}
		if (isOpen("A4+.tif") == true) {
		selectWindow("A4+.tif");	
			run("Close");
	}
		if (isOpen("647Merge") == true) {
		selectWindow("647Merge");	
			run("Close");
	}
			if (isOpen("AsynOutlines1-2.tif") == true) {
		selectWindow("AsynOutlines1-2.tif");	
			run("Close");
	}
			if (isOpen("A1-2.tif") == true) {
		selectWindow("A1-2.tif");	
			run("Close");
	}
			if (isOpen("AsynOutlines0.5-1.tif") == true) {
		selectWindow("AsynOutlines0.5-1.tif");	
			run("Close");
	}
			if (isOpen("A0.5-1.tif") == true) {
		selectWindow("A0.5-1.tif");	
			run("Close");
	}
			if (isOpen("AsynTouchedUp.tif") == true) {
		selectWindow("AsynTouchedUp.tif");	
			run("Close");
	}
			if (isOpen("FerritinOutlines1.tif") == true) {
		selectWindow("FerritinOutlines1.tif");	
			run("Close");
	}
				if (isOpen("Ferritin1+.tif") == true) {
		selectWindow("Ferritin1+.tif");	
			run("Close");
	}
				if (isOpen("FerritinOutlines0.tif") == true) {
		selectWindow("FerritinOutlines0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin0-1.tif") == true) {
		selectWindow("Ferritin0-1.tif");	
			run("Close");
	}
				if (isOpen("FerritinBinary0.tif") == true) {
		selectWindow("FerritinBinary0.tif");	
			run("Close");
	}
				if (isOpen("Ferritin:1+") == true) {
		selectWindow("Ferritin:1+");	
			run("Close");
	}
				if (isOpen("Ferritin:0-1") == true) {
		selectWindow("Ferritin:0-1");	
			run("Close");
	}
				if (isOpen("488Merge") == true) {
		selectWindow("488Merge");	
			run("Close");
	}
		if (isOpen("bing") == true) {
		selectWindow("bing");	
			run("Close");
	}
		if (isOpen("ting") == true) {
		selectWindow("ting");	
			run("Close");
	}	if (isOpen("bingting") == true) {
		selectWindow("bingting");	
			run("Close");
	}
}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
close("*");
