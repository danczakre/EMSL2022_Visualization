# EMSL Summer School - 2022 Visualization Walkthrough
This repository contains both the data and the scripts that are necessary to participate in the EMSL Summer School 2022. Below, you will find a description of each file:

In the root respoitory:
- <b>EMSL_SummerSchool22_KO_Annotations.csv:</b> This file contains all of the KEGG Orthology Numbers (KO Numbers) and the number of times they were detected within a given sample. This is very similar to an OTU table with functoinal categories instead of organisms. Rows are KO numbers and columns are samples.
- <b>Data_Visualization_Example.R:</b> This is the R script which will provide example data analysis options and will be used during the walkthrough. It will generate 3 different image files (contained in the "Plots" folder here in this respository)
- <b>EMSL_2022-Presentation.pptx:</b> This is the presentation given during the EMSL Summer School 2022 and can be used as a reference in the future.

In the Plots folder:
- <b>ko00010.Glycolysis_Pathview_Output.png:</b> This is the glycolysis/gluconeogenesis output pathway generated as part of the Pathview example analysis.
- <b>ko00910.Nitrogen_Pathview_Output.png:</b> This is the nitrogen output pathway generated as part of the Pathview example analysis.
- <b>Sample_Resolved_Nitrogen_Targeted_Genes.pdf:</b> This graph represents the targeted nitrogen gene counts plotted by sample.
- <b>Bulk_Nitrogen_Targeted_Genes.pdf:</b> This graph represents the targeted nitrogen gene counts plotted by either depth or sampling location.
