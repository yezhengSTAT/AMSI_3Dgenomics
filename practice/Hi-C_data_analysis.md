---
title: "Hi-C Data Analysis"
author: "Ye Zheng"
date: "December 3, 2019"
output: html_document
---

### I. Quality Control

#### 1. Input Data Format

First load the HiCRep R package into R console.

```
library(hicrep)
```

The main function that we will use is `get.scc` which calculates the stratum-adjusted correlation coefficient for each pair of contact matrices on one chromosome. Try `?get.scc` to check the input data format.

#### 2. Data Preparation

HiCRep has embedded smoothing function hence it recommends using raw contact count. Therefore, we will utilize bin pair files, such as `AMSI_3Dgenomics/results/Ring/step5_bin/Ring_chr7.binPairs`, for input matrix generation in R.

```
library(data.table)
library(dplyr)
hicData1 <- fread("~/AMSI_3Dgenomics/results/Ring/step5_bin/Ring_chr7.binPairs") %>% select(V2, V4, V5)
hicData2 <- fread("~/AMSI_3Dgenomics/results/Trophozoite/step5_bin/Trophozoite_chr7.binPairs") %>% select(V2, V4, V5)

hicDataMerge <- full_join(hicData1, hicData2, by = c("V2", "V4"))
hicDataMerge[is.na(hicDataMerge)] <- 0
head(hicDataMerge)
```

#### 3. Stratum-adjusted Correlation Coefficient

```
get.scc(hicDataMerge, 10000, 1000000)$scc
```

- Get the SCC score for Ring vs Trophozoite

- Get the SCC score for Ring vs Schizont

- Get the SCC score for Trophozoite vs Schizont


### II. Differential Chromatin Interaction Detection

#### 1. Install Selfish in Bash
[Selfish](https://github.com/ay-lab/selfish), i.e., Self-fishing, is a tool for finding differential chromatin interactions between two Hi-C contact maps.

First, we will need to install Selfish in Terminal:

```
git clone https://github.com/ay-lab/selfish
```

#### 2. Data Preparation

Our bin pair files, such as `AMSI_3Dgenomics/results/Ring/step5_bin/Ring_chr7.binPairs`, perfectly match the input data foramt for Selfish:

| Chromosome | Midpoint 1 | Chromosome | Midpoint 2 | Contact Count |
|---|---|---|---|---|
| chr1 | 5000 | chr1 | 65000 | 438 |
| chr1 | 5000 | chr1 | 85000 | 12 |
| ... | ... | ... | ... | ... |

#### 3. Differential Detection

```
mkdir -p AMSI_3Dgenomics/analysis/Selfish
selfish/selfish/selfish.py -f1 AMSI_3Dgenomics/results/Ring/step5_bin/Ring_chr7.binPairs -f2 AMSI_3Dgenomics/results/Trophozoite/step5_bin/Trophozoite_chr7.binPairs -ch 7 -r 10kb -o AMSI_3Dgenomics/analysis/Selfish/Ring_Trophozoite_chr7.npy
```

Output of Selfish is a matrix of p-values indicating the probability of differential conformation (Smaller values mean more significant.).Convert `numpy` object into readable text file. 

```
python3 AMSI_3Dgenomics/scripts/selfish_npyToCSV.py AMSI_3Dgenomics/analysis/Selfish/Ring_Trophozoite_chr7.npy AMSI_3Dgenomics/analysis/Selfish/Ring_Trophozoite_chr7.selfish
```

To control False Discovery Rate, Benjamini-Horchberg multiple testing correction is usually applied before determining the significant differential chromatin interactions.
 
- Get the differential interactions for Ring vs Trophozoite.

- Get the differential interactions for Ring vs Schizont.

- Get the differential interactions for Trophozoite vs Schizont.