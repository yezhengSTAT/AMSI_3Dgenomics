---
title: "Hi-C Data Visualization"
author: "Ye Zheng"
date: "December 3, 2019"
output: html_document
---

### Juicebox Visualization

#### Input data format
https://github.com/aidenlab/juicer/wiki/Pre

Short format
A whitespace separated file that contains, on each line
```
<str1> <chr1> <pos1> <frag1> <str2> <chr2> <pos2> <frag2>
```
- str = strand (0 for forward, anything else for reverse)

- chr = chromosome (must be a chromosome in the genome)

- pos = position

- frag = restriction site fragment

If not using the restriction site file option, frag will be ignored, but please see above note on dummy values. readname and strand are also not currently stored within .hic files.

#### Data preparation

Download juicer tools. 
```
wget https://s3.amazonaws.com/hicfiles.tc4ga.com/public/juicer/juicer_tools_1.14.08.jar
```

Convert interactions into .hic format.
```
java -Xmx2g -jar juicer_tools_1.14.08.jar pre Ring_chr7.bed.gz Ring_chr7.hic Pf3D7
```

scp back to local laptop for online uploading.

### HiGlass Visualization [optional ?]

https://docs.higlass.io/tutorial.html

#### Input data format

#### Data preparation