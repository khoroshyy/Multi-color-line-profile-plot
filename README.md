# Multi colour line profile plot

ImageJ macro to plot line profiles in up to 7 channels/colours. You can select the channels you want to use to create your plot graph. You can use the macro as an action tool (will create an icon in the toolbar when the macro is installed) or run it as a standard macro in ImageJ/Fiji. 

![Line profile](https://github.com/KeesStraatman/Multi-colour-line-profile-plot/blob/main/Line%20profile.png)



## Download code

Select the file "Plot_Multicolor4.3" and select "Raw" from the right side menu. Select all the code and copy and paste this into the text editor from ImageJ/Fiji (File > New > Text Window). Alternatively, you can download all files via the green "Code" button as a ZIP file and extract the macro file. Save this file in your macros sub-folder within the ImageJ or Fiji folder with the name Plot_Multicolor.txt.

## Run macro

To run the macro a single time open an image and via Plugins > Macros > Run... select the macro. Alternatively install it via Plugins > Macros > Install ... and the macro will be added to the Plugins > Macros menu, till you restart ImageJ/Fiji.

## Install action tool

Download and save the "Line Profile Action Tool" as described above using the name Line Profile Action Tool.txt. When you install this tool via  Plugins > Macros > Install .. an icon will be added to the ImageJ/Fiji tool bar. Clicking this icon will execute the macro code.

## Auto installation of the tool during Fiji startup.
Clone repository or download code.
Copy the AutoInstall folder to the Fiji/macro directory.
Modify the StartupMacros.fiji.ijm script in the macro directory in the following way:

Originally the sctipt contain this autostart past:
```
macro "AutoRun" {
	// run all the .ijm scripts provided in macros/AutoRun/
	autoRunDirectory = getDirectory("imagej") + "/macros/AutoRun/";
	if (File.isDirectory(autoRunDirectory)) {
		list = getFileList(autoRunDirectory);
		// make sure startup order is consistent
		Array.sort(list);
		for (i = 0; i < list.length; i++) {
			if (endsWith(list[i], ".ijm")) {
				runMacro(autoRunDirectory + list[i]);
			}
		}
	}
}
```
You can comment or delere it and replace it with this:

```
macro "AutoRun" {
    // ----- 1) Run all .ijm scripts from macros/AutoRun/ -----
    autoRunDirectory = getDirectory("imagej")
        + "macros" + File.separator
        + "AutoRun" + File.separator;

    if (File.isDirectory(autoRunDirectory)) {
        list = getFileList(autoRunDirectory);
        Array.sort(list); // consistent order

        for (i = 0; i < list.length; i++) {
            if (endsWith(list[i], ".ijm")) {
                runMacro(autoRunDirectory + list[i]);
            }
        }
    }

    // ----- 2) Install all .ijm macros from macros/AutoInstall/ -----
    autoInstallDirectory = getDirectory("imagej")
        + "macros" + File.separator
        + "AutoInstall" + File.separator;

    if (File.isDirectory(autoInstallDirectory)) {
        installList = getFileList(autoInstallDirectory);
        Array.sort(installList);

        for (i = 0; i < installList.length; i++) {
            if (endsWith(installList[i], ".ijm")) {
                // Only install, do NOT run
                fullPath = autoInstallDirectory + installList[i];
                run("Install...", "install=[" + fullPath + "]");
            }
        }
    }
}
```
Then the tool shall load on the startup of Fiji.


## Disclaimer

All the macros published on this repository can be used at your own risk. Although I did my best to ensure that they run as intended, there may be bugs, not expected use or changes to the ImageJ code that results in unexpected behaviour. If you notice a problem with any of the macros please let me know and I can try to solve the problem.

## Publications acknowledging this macro:

Lützkendorf J, Matkovic-Rachid T, Götz T, Liu S, Ghelani T, Maglione M, Grieger M, Putignano S, Gao L, Gimber N, Schmoranzer J, Stawrakakis A, Walter AM, Heine M, Wahl MC, Mielke T, Liu F, Sigrist SJ (2024) Identification and characterization of a synaptic active zone assembly protein. 
bioRxiv 2024.04.08.588536; doi: https://doi.org/10.1101/2024.04.08.588536

Oevel K, Hohensee S, Kumar A, Rosas-Brugada I, Bartolini F, Soykan T, Haucke V (2024) Rho GTPase signaling and mDia facilitate endocytosis via presynaptic actin eLife 12:RP92755

Pooryasin A, Maglione M, Schubert M, Matkovic-Rachid T, Hasheminasab SM, Pech U, Fiala A, Mielke T, Sigrist SJ (2021) Unc13A and Unc13B contribute to the decoding of distinct sensory information in *Drosophila*. Nat Commun. 12:1932. doi: 10.1038/s41467-021-22180-6.

Jäpel M, Gerth F, Sakaba T, Bacetic J, Yao L, Koo SJ, Maritzen T, Freund C, Haucke V (2020) Intersectin-Mediated Clearance of SNARE Complexes Is Required for Fast Neurotransmission. Cell Rep. 30:409-420.

Vallardi G, Allan LA, Crozier L, Saurin AT (2019) Division of labour between PP2A-B56 isoforms at the centromere and kinetochore. Elife. 8. pii: e42619. doi: 10.7554/eLife.42619.

Gerth F, Jäpel M, Sticht J, Kuropka B, Schmitt XJ, Driller JH, Loll B, Wahl MC, Pagel K, Haucke V, Freund C (2019) Exon Inclusion Modulates Conformational Plasticity and Autoinhibition of the Intersectin 1 SH3A Domain. Structure. 27:977-987.

Brockmann MM, Maglione M, Willmes CG, Stumpf A, Bouazza BA, Velasquez LM, Grauel MK, Beed P, Lehmann M, Gimber N, Schmoranzer J, Sigrist SJ, Rosenmund C, Schmitz D (2019) RIM-BP2 primes synaptic vesicles via recruitment of Munc13-1 at hippocampal mossy fiber synapses. eLife. 8: e43243.

Sabatinos SA, Green MD (2018) A Chromatin Fiber Analysis Pipeline to Model DNA Synthesis and Structures in Fission Yeast. Methods Mol Biol. 1672:509-526.
