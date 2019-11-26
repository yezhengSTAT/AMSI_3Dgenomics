---
title: "Hi-C Data Analysis"
author: "Ye Zheng"
date: "December 3, 2019"
output: html_document
---

### Quality Control

Install `HiCRep`  R package
```
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("hicrep")
```

```
HiCR1[1:10,1:10]
##       V1      V2       V3 V4 V5 V6 V7 V8 V9 V10
## 1  chr22       0  1000000  0  0  0  0  0  0   0
## 2  chr22 1000000  2000000  0  0  0  0  0  0   0
## 3  chr22 2000000  3000000  0  0  0  0  0  0   0
## 4  chr22 3000000  4000000  0  0  0  0  0  0   0
## 5  chr22 4000000  5000000  0  0  0  0  0  0   0
## 6  chr22 5000000  6000000  0  0  0  0  0  0   0
## 7  chr22 6000000  7000000  0  0  0  0  0  0   0
## 8  chr22 7000000  8000000  0  0  0  0  0  0   0
## 9  chr22 8000000  9000000  0  0  0  0  0  0   0
## 10 chr22 9000000 10000000  0  0  0  0  0  0   0
```

```
Pre_HiC <- prep(HiCR1, HiCR2, 1000000, 1, 5000000)
head(Pre_HiC)
##           V1       V2        V3        V4
## 796 15500000 15500000 314.66667 515.11111
## 797 15500000 16500000 539.88889 871.11111
## 798 15500000 17500000 579.66667 927.11111
## 799 15500000 18500000 283.00000 439.44444
## 800 15500000 19500000  65.33333  95.55556
## 801 15500000 20500000  32.88889  53.88889
```

```
SCC.out = get.scc(Pre_HiC, 1000000, 5000000)
```

### Differential Chromatin Interaction

#### Input data format
| Chromosome | Midpoint 1 | Chromosome | Midpoint 2 | Contact Count |
|---|---|---|---|---|
| chr1 | 5000 | chr1 | 65000 | 438 |
| chr1 | 5000 | chr1 | 85000 | 12 |
| ... | ... | ... | ... | ... |

#### Differential detection
```
git clone https://github.com/ay-lab/selfish
./selfish/selfish/selfish.py -f1 /path/to/contact/Ring_chr7.bed \
                             -f2 /path/to/contact/Schizont_chr7.bed \
	                           -ch 7 \
                             -r 10kb -o ./output.npy
```