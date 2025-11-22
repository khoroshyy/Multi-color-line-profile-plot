macro "Line Profile Action Tool - CeefD8aCb8dD69CfffD00D01D02D03D04D05D06D07D10D11D12D13D14D15D16D17D20D21D22D23D24D25D26D27D28D30D31D3dD4fD5fD60D61D62D63D64D65D6fD70D71D72D73D74D75D76D77D78D7bD80D81D82D83D84D85D86D87D88D8bD8cD90D91D92D93D94D95D96D97D98D9bD9cDa0Da1Da2Da3Da4Da5Da6Da7DabDacDb0Db1Db2Db3Db4Db5Db9DbaDbbDbcDc0Dc1Dc2Dc3Dc4Dc8Dc9DcaDcbDccDd0Dd1Dd2Dd3Dd4Dd8Dd9DdaDdbDe0De1De2De3De4De5Df0Df1Df2Df3Df4Df5DffC9e8D2bCfffD7aDaaDb6CdfdD08DcfCfaaD38D54D57DfaCeefDd7De8CdadD6aCcb8D3bCdefD4cCfa9D0dCcadD5aC8dbD5dCfeeD48D50D67DfcCfbbD37D44D52D53D58DadCddfD0fD1fD2fD9aCcfcD1aCefeDafDfdCf77D41CaafD4eD79D89Da9Cbe9D0cCfeeD33D47D68DdcDeaCfddD40D46Df6CfbcD59CfffD32D49D66De9CfaaD2cD39D55D56D8dD9dDbdDf9CbbfDa8CafaD9eCfddD2dD34D7cDedCfccD1cD1dD35D3cCfffD1bD5eD7fD8fCc7aDf7C99fDe7C9f9D0bD18DfeCefeD9fDbfDdfDefCccfD1eD2eDc5Dc7Dd5CbfbD09D4bD6eCddfD3fDe6CaafD3eD4dDb7CafaD0aD8eCf99D43DcdDddDecCbe9DaeCfccD36D45D51DebDfbCccfD0eCafaD4aDdeDeeC78bD5bC99fDc6Dd6C8f8D19CdfdD29CbeaD6dCaf9D2aCf88D42CbbfD99Db8CbfaDbeCfa9D7dCe8aDf8C8bcD5cC9f9D7eCbfaDceCf99D6cCfaaD6b"{
// macro to make line plots
// will select different colours to plot
// handles 8, 16 and 32 bit images as well as maximal 7 channels

// version 4.1; Solved problem with x-coordinates in scaled images. 
// version 4.2; Thanks to Michael Epping (mailinglist 15-05-2013) the X-scale on  
// the scaled plot is also drawn corectly.
// version 4.3; The plot is now scaled depending on the channels selected by the user.
// The colour for each channel is first detected followed by selection of the
// colours by the user instead of the user has to select channel numbers. 

// Kees Straatman, University of Leicester, 19 January 2014

	setTool("line");
	if (isOpen("ROI Manager")) {
     		selectWindow("ROI Manager");
    		 run("Close");
  	}
	inv = false; 		 // To check if LUT is inverted
	p = 0; 			 //Counter for presence of plot
	intensityBottom=0;
	color = "black";
	getVoxelSize(vw, vh, vd, unit);
	
	// Check that there is a line selection
	do{
		type = selectionType();
		if (type!=5){
			title="Warning";
			msg="The macro needs a line selection.\nMake a line selection and click \"OK\"";
			waitForUser(title, msg);
		}
	wait(100);
	}while(type!=5);
	getLine(x1, y1, x2, y2, lineWidth);

	// Parameters for the plot
	dx = (x2-x1)*vw; 
	dy = (y2-y1)*vh;
	maxT=0;
	minT=100000000;
	Stack.getDimensions(width, height, channels, slices, frames);

	if (bitDepth==24){
		if (nSlices>1){
			roiManager("Add");
			run("Make Composite");
			wait(100);  // Line is sometimes not transfered to the new image
			setVoxelSize(vw, vh, vd, unit);
			roiManager("select", 0);
			//wait(100);
			selectWindow("ROI Manager");
			run("Close");
		}else{
			run("Make Composite");
		}
	}

	Stack.getDimensions(width, height, channels, slices, frames); // need to repeat because of creation of new composite
	channel = newArray(channels);
	color=newArray(channels+1);

	// to allow single channel profile in color
	for (i=0; i<channels;i++)
		channel[i]=true;

	for (i=1; i<=channels; i++){
		// Solve problem with inverted images (blobs)
		if (is("Inverting LUT")){
			run("Invert LUT");
			inv=true;
		}
		if (channels>1) Stack.setChannel(i); 
		getLut(reds, greens, blues);
		if ((reds[i]==i)&&(greens[i]==0)&&(blues[i]==0)) color[i] = "red";
		if ((reds[i]==0)&&(greens[i]==i)&&(blues[i]==0)) color[i] = "green";
		if ((reds[i]==0)&&(greens[i]==0)&&(blues[i]==i)) color[i] = "blue";
		if ((reds[i]==0)&&(greens[i]==i)&&(blues[i]==i)) color[i] = "cyan";
		if ((reds[i]==i)&&(greens[i]==0)&&(blues[i]==i)) color[i] = "magenta";
		if ((reds[i]==i)&&(greens[i]==1)&&(blues[i]==0)) color[i] = "yellow";
		if ((reds[i]==i)&&(greens[i]==i)&&(blues[i]==i)) color[i] = "black";
	}
	if (inv) run("Invert LUT"); // reset inverted image

	// Select channels to plot
	if (channels > 1){
		Dialog.create("channels");
			Dialog.addMessage("Which channels do you want to plot?");
			for (i=0; i<channels;i++){
				Dialog.addCheckbox(color[i+1], true);
			}
		Dialog.show();
		setBatchMode(true);
		for (i=0; i<channels;i++){
			channel[i] = Dialog.getCheckbox();
			
		}
	}

	// Collect data for minimal and maximal values of the selected channels for the plot
	if ((Stack.isHyperstack)||(is("composite"))){
		Stack.getDimensions(width, height, channels, slices, frames); // need to repeat because of creation of new composite
		for (i=1; i<=channels;i++){
			if(channel[i-1]==true){
				Stack.setChannel(i);
				profile = getProfile();
 				for (j=0; j<profile.length; j++){
    					if (maxT<profile[j]) maxT=profile[j];
					if(profile[j]<minT) minT=profile[j];
				}
			}
		}
	}else{
		channels = 1;
		profile = getProfile();
 		for (j=0; j<profile.length; j++){
    			if (maxT<profile[j]) maxT=profile[j];
			if(profile[j]<minT) minT=profile[j];
		}
	}
	intensityTop=maxT;
	intensityBottom=minT;

	// Check if channel is selected. 
	for (i=1; i<=channels; i++){
		if (channels>1) Stack.setChannel(i); 
		if(channel[i-1]==true){
				
			// Plot different colours
			if (p==0){
				profile=getProfile();
				Plot.create("multi Channel Plot", "Distance("+unit+")", "Intensity"); 
				Plot.setLimits(0,sqrt(dx*dx+dy*dy),intensityBottom,intensityTop);
				p=1;
			}

			// Scale the profiles for correct x-coordinates
			run("Plot Profile");
  			Plot.getValues(x, y);
  			close();
			Plot.setColor(color[i]); 
			Plot.add("line",x,y); 
		}
	}
		
}

