# MSIFluxer

## Introduction

This repo contains the code needed to run the R package MSIFluxer. MSIFluxer is used to comprehensively detect the labeled metabolites from the mass spectrometry imaging (MSI) data after 13C-nutrients administration. The package was originally designed and tested with the lab-built ambient airflow-assisted desorption electrospray ionization (AFADESI)-MSI system but can accommodate all types of MSI data as long as the input of tabular form.
MSIFluxer stands out for enabling effective analysis of isotope-labeled imaging data and can directly export information such as labeled metabolite names, molecular formulas, adduct forms, and labeled fractions. 

Currently, MSIFluxer requires R version 4.2.0 or greater. 

## Installation

The current released version of the package may be installed by running the following code.


```r
remotes::install_github("xinzhul/MSIFluxer")
```

## Data input
MSIFluxer requires the average mass spectra from the regions of interest (ROI) in labeled and unlabeled samples. In our experiment, this process was performed by the custom-developed software MassImager (in corporation with Chemmind Technologies Co., Ltd). The m/z value and corresponding signal intensity of ROI information is a .csv format table, with any missing values filled with zeros.

## Quickstart
We provide a template here. Users only need to change the thresholds for each step as needed.

```r
library (MSIFluxer)
# Input file (example file included)
MSIdata <- read.csv(system.file("extdata", "Example-U13C-Glucose-MSIdata.csv", package = "MSIFluxer"))
Target <- read.csv(system.file("extdata", "U13C-Glucose-Negative.csv", package = "MSIFluxer"))

# Extracting the intensity of targeted isotopologues
for(i in seq(1, ncol(MSIdata), 2)){
  print(i)
  col <- colnames(MSIdata)[i]
  select_Intensitys <- apply(Target[, 1, drop=F], 1, Extractint, unlist(MSIdata[, i]), unlist(MSIdata[, i+1]))
  Target[, col] <- select_Intensitys
  Target[is.na(Target[, col]), col] <- 0
}

# Selecting ions with sufficient imaging signals
Target1 <- Scanint(Target,Intensity=100, num=2)
Target2 <- Filterint(Target1, Intensity=10)
Compound_new <- Target2 %>% select(Compound,ID) %>% mutate(Compound_new = pmap_chr(., str_c, sep = "_")) %>% select(Compound_new)
Target3 <- cbind(Compound_new, Target2 %>% select(Formula,IsotopeLabel,Unlabel_01:Glc_Label_03)) %>% rename(Compound = Compound_new)

# Detecting the labeled signals
Result_Int = list("Extract_Int" = Target,"Scan_Int" = Target1,"Filter_Int"=Target2,"Input_Int"=Target3)
write.xlsx(Result_Int,file = "Result_Int_example.xlsx")

# Quantifying labeling patterns and fractions
Corrected <- natural_abundance_correction(path = "Result_Int_example.xlsx",sheet = "Input_Int",resolution = 140000,purity = 0.99)

```
## Bug report

This package is still under active development and updates. If you have any questions or suggestions, please don’t hesitate to email me: Xinzhu Li (stxinzhu@outlook.com).
