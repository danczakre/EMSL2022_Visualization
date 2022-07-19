# EMSL Summer School - 2022 Visualization Walkthrough
This repository contains both the data and the scripts that are necessary to participate in the EMSL Summer School 2022 metagenomics visualization walkthrough. Below, you will find a description of each file:

Instructions for the walkthrough (assuming R and RStudio are installed):
1. Download this repository by going to the upper right side of this page, clicking the green "Code" button, and "Download ZIP"
2. Unzip this repository wherever convenient
3. Open the R script
4. Change the home.dir parameter in the R script to the full location of the downloaded repository (e.g., go to the address bar in explorer to copy). Remember, if on Windows and you are copying from the address bar, you will need to replace the backslashes (\\) with forward slashes (/) in R.
5. Click the "Source" button in the upper right side of the R script window in RStudio


In the root respoitory:
- <b>EMSL_SummerSchool22_KO_Annotations.csv:</b> This file contains all of the KEGG Orthology Numbers (KO Numbers) and the number of times they were detected within a given sample. This is very similar to an OTU table with functoinal categories instead of organisms. Rows are KO numbers and columns are samples. This data were downloaded from [NMDC](https://data.microbiomedata.org/?q=ChgIABABGAMiECJnb2xkOkdzMDExMDEzOCIKFAgAEAIYAiIMIk1ldGFnZW5vbWUi) and was combined using a custom R script which counts the number of times a given KO number is observed in an annotation output file. While not generated following the exact pipeline described in Day 2, these data should be very similar.
- <b>Data_Visualization_Example.R:</b> This is the R script which will provide example data analysis options and will be used during the walkthrough. It will generate 3 different image files (contained in the "Plots" folder here in this respository)
- <b>EMSL_2022-Presentation.pptx:</b> This is the presentation given during the EMSL Summer School 2022 and can be used as a reference in the future.

In the Plots folder:
- <b>ko00010.Glycolysis_Pathview_Output.png:</b> This is the glycolysis/gluconeogenesis output pathway generated as part of the Pathview example analysis.
- <b>ko00910.Nitrogen_Pathview_Output.png:</b> This is the nitrogen output pathway generated as part of the Pathview example analysis.
- <b>Sample_Resolved_Nitrogen_Targeted_Genes.pdf:</b> This graph represents the targeted nitrogen gene counts plotted by sample.
- <b>Bulk_Nitrogen_Targeted_Genes.pdf:</b> This graph represents the targeted nitrogen gene counts plotted by either depth or sampling location.
