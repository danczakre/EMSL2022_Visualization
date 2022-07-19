### Script to generate Pathview results

# Change everything between the quotes to the full path location
# where the repository is located
home.dir = "~/Documents/Conferences and Workshops/EMSL Summer School 2022"

########### Do not change below this line ###########

### Function creation
# Function to check if package is installed, 
# installing if it isn't, and then loading it
is.installed = function(package.name){
  # if/else loop for pacakge
  if(!(package.name %in% row.names(installed.packages()))){
    install.packages(package.name)
  } else {
    print(paste(package.name, "is installed already."))
  }
}

# Specialized function for bioconductor packages
is.installed.bio = function(package.name){
  # if/else loop for pacakge
  if(!(package.name %in% row.names(installed.packages()))){
    if (!require("BiocManager", quietly = TRUE))
      install.packages("BiocManager")
    
    BiocManager::install(package.name)
  } else {
    print(paste(package.name, "is installed already."))
  }
}

### Load in libraries
# Checking to see if packages are installed (installing, if not)
is.installed("stringr")
is.installed("plyr")
is.installed("tidyverse")
is.installed("ggpubr")
is.installed.bio("pathview")
is.installed("vegan")

# Loading in packages
library("stringr")
library("plyr")
library("tidyverse")
library("ggpubr")
library("pathview")
library("vegan")

# Setting seed for reproducibility
set.seed(2414)

### Set up
# Load in folders and sample mapping file
setwd(home.dir)
ko.table = read.csv("EMSL_SummerSchool22_KO_Annotations.csv", row.names = 1, check.names = F)

# Removing unneeded samples
ko.table = ko.table[,grep("WEW", colnames(ko.table))]

# Removing missing KO values
ko.table = ko.table[!(rowSums(ko.table)==0),]

# Creating factor table
factors = data.frame(Sample = colnames(ko.table), Plot = NA, Depth = NA)

# Filling in factor table
factors$Plot = gsub("_", "", str_extract(factors$Sample, "_.*_"))
factors$Depth = gsub("_", "", str_extract(factors$Sample, "_10$|_40$|_100$|_150$"))

# Creating sample name list to make selecting samples easier
sample.list = c("June2016WEW_4_10", "June2016WEW_4_40", 
                "June2016WEW_4_100", "June2016WEW_4_150")

# Select first 4 samples (June 2015)
short.ko = ko.table[,sample.list]
row.names(short.ko) = gsub("KO:", "", row.names(short.ko)) # modifying identifier to be compatible with Pathview

# Rarefying to make comparisons more viable
short.ko = as.data.frame(t(rrarefy(t(short.ko), min(colSums(short.ko)))))

# Identify differences across 1 and 4th samples
ko.diff = data.frame(KO = row.names(short.ko), 
                     Difference = log(short.ko[,"June2016WEW_4_150"]/short.ko[,"June2016WEW_4_10"], base = 2)) # back of the envelope log2FC
ko.diff = ko.diff[!is.infinite(ko.diff$Difference),] # dropping wrong values

### Pathview 
# Run Pathview
path.in = ko.diff$Difference # need to create input in the right format
names(path.in) = ko.diff$KO
carb.out = pathview(gene.data = path.in, pathway.id = "00010", species = "ko",
                    out.suffix = "Glycolysis_Pathview_Output", kegg.native = T, pdf.size = c(12,12), same.layer = T) # generate map for carbon metabolism
nitr.out = pathview(gene.data = path.in, pathway.id = "00910", species = "ko",
                    out.suffix = "Nitrogen_Pathview_Output", kegg.native = T) # generate map for nitrogen metabolism

### Targeted analyses
# Identify KOs to target
nit.genes = c(narG = "K00370", narH = "K00371", narI = "K00374", nirK = "K00368", 
              norB = "K04561", norC = "K02305")

# Selecting genes
nit.table = short.ko[which(row.names(short.ko) %in% nit.genes),]

# Adding gene names to table
nit.table$Gene_Name = NA

for(i in 1:nrow(nit.table)){
  w = which(nit.genes %in% row.names(nit.table)[i])
  nit.table$Gene_Name[i] = names(nit.genes)[w]
}

# Plotting data
out.plot = nit.table %>% gather(Sample, value, -Gene_Name) %>%
  mutate(Sample = factor(Sample, levels = c("June2016WEW_4_10", "June2016WEW_4_40", 
                                            "June2016WEW_4_100", "June2016WEW_4_150"))) %>%
  mutate(Function = case_when(grepl("nar", Gene_Name)~"NO3->NO2",
                              grepl("nir", Gene_Name)~"NO2->NO",
                              grepl("nor", Gene_Name)~"NO->N2O")) %>%
  mutate(Function = factor(Function, levels = c("NO3->NO2", "NO2->NO", "NO->N2O"))) %>%
  ggplot(aes(x = Gene_Name, y = value))+
  geom_bar(stat = "identity", position = "dodge", aes(fill = Sample))+
  facet_grid(.~Function, scales = "free_x", space = "free")+
  scale_fill_manual(values = c("dodgerblue", "firebrick", "goldenrod", "purple"))+
  xlab("Gene Name") + ylab("Gene Count")+
  theme_bw()

ggsave(filename = "Sample_Resolved_Nitrogen_Targeted_Genes.pdf", plot = out.plot)

### Whole data file analysis
# Let's take a look at the nitrogen genes across all WEW samples; first some prep
row.names(ko.table) = gsub("KO:", "", row.names(ko.table)) # modifying identifier to be compatible with Pathview
ko.table = as.data.frame(t(rrarefy(t(ko.table), min(colSums(ko.table))))) # rarefying

# Selecting genes
nit.table = ko.table[which(row.names(ko.table) %in% nit.genes),]

# Adding gene names to table
nit.table$Gene_Name = NA

for(i in 1:nrow(nit.table)){
  w = which(nit.genes %in% row.names(nit.table)[i])
  nit.table$Gene_Name[i] = names(nit.genes)[w]
}

# Plotting data by depth
plot1 = nit.table %>% gather(Sample, value, -Gene_Name) %>%
  left_join(factors, by = "Sample") %>%
  mutate(Depth = factor(Depth, levels = c("10", "40", "100", "150"))) %>%
  mutate(Function = case_when(grepl("nar", Gene_Name)~"NO3->NO2",
                              grepl("nir", Gene_Name)~"NO2->NO",
                              grepl("nor", Gene_Name)~"NO->N2O")) %>%
  mutate(Function = factor(Function, levels = c("NO3->NO2", "NO2->NO", "NO->N2O"))) %>%
  ggplot(aes(x = Depth, y = value))+
  geom_boxplot(aes(fill = Function))+
  stat_compare_means(method = "kruskal.test", 
                     label.x.npc = 0.37, label.y.npc = 0.92)+
  facet_grid(Gene_Name~., scales = "free")+
  scale_fill_manual(values = c("#EDAE49", "#D1495B", "#00798C"))+
  xlab("Depth") + ylab("Gene Count")+
  theme_bw()

# Plotting data by plot
plot2 = nit.table %>% gather(Sample, value, -Gene_Name) %>%
  left_join(factors, by = "Sample") %>%
  mutate(Plot = factor(Plot, levels = c("4", "6", "7", "8", "10", "11", "13",
                                        "16", "17", "19", "20", "21"))) %>%
  mutate(Function = case_when(grepl("nar", Gene_Name)~"NO3->NO2",
                              grepl("nir", Gene_Name)~"NO2->NO",
                              grepl("nor", Gene_Name)~"NO->N2O")) %>%
  mutate(Function = factor(Function, levels = c("NO3->NO2", "NO2->NO", "NO->N2O"))) %>%
  ggplot(aes(x = Plot, y = value))+
  geom_boxplot(aes(fill = Function))+
  stat_compare_means(method = "kruskal.test", 
                     label.x.npc = 0.37, label.y.npc = 0.92)+
  facet_grid(Gene_Name~., scales = "free")+
  scale_fill_manual(values = c("#EDAE49", "#D1495B", "#00798C"))+
  xlab("Plot") + ylab("Gene Count")+
  theme_bw()

# Merging plots
out.plot = ggarrange(plot1, plot2, common.legend = T, labels = c("A", "B"))

ggsave(filename = "Bulk_Nitrogen_Targeted_Genes.pdf", plot = out.plot,
       width = 9, height = 8.5)
