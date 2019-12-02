---
title: "Hi-C Data Visualization"
author: "Ye Zheng"
date: "December 3, 2019"
output: html_document
---

### Juicebox Visualization

- Juicebox Online: [https://aidenlab.org/juicebox/](https://aidenlab.org/juicebox/)

- Juicebox Desktop: [https://github.com/aidenlab/Juicebox/wiki/Download](https://github.com/aidenlab/Juicebox/wiki/Download)


#### Input Data Format

The Juicer Tools and Juicebox software is centered around the .hic file, a highly compressed binary file that provides rapid random access to the matrices at nested resolution levels. Juicer tool [`Pre`](https://github.com/aidenlab/juicer/wiki/Pre) can help us generate such .hic file from various input data format. We will use the simplest format for illustration.


Short format (cited from [https://github.com/aidenlab/juicer/wiki/Pre](https://github.com/aidenlab/juicer/wiki/Pre))
A whitespace separated file that contains, on each line
```
<str1> <chr1> <pos1> <frag1> <str2> <chr2> <pos2> <frag2>
```
- str = strand (0 for forward, anything else for reverse; we can ignore this option as currently strand information is not stored within .hic files.)

- chr = chromosome (must be a chromosome in the genome)

- pos = position

- frag = restriction site fragment (We can ignore this option by putting a dummy value. `Pre` throws away reads that map to the same restriction fragment. If using dummy numbers for the frag field, be sure they are different for the different read ends; that is, <frag1> should be 0 and <frag2> should be 1.)


#### Data Preparation
To generate the short format interaction file, we can make use of `AMSI_3Dgenomics/results/Ring/step4_duplicatesRemoval/Ring_chr7.validPairs.noDup` which records the nonduplicated valid read pairs. 

```
mkdir -p AMSI_3Dgenomics/results/Ring/Juicebox

awk -v OFS="\t" '{print 0, $2, $3, 1, 16, $7, $8, 0}' AMSI_3Dgenomics/results/Ring/step4_duplicatesRemoval/Ring_chr7.validPairs.noDup >AMSI_3Dgenomics/results/Ring/Juicebox/Ring_chr7.pre
```

#### .hic File Generation

Convert interactions (short format) into .hic format.

```
java -Xmx2g -jar AMSI_3Dgenomics/bin/juicer_tools_1.14.08.jar pre AMSI_3Dgenomics/results/Ring/Juicebox/Ring_chr7.pre AMSI_3Dgenomics/results/Ring/Juicebox/Ring_chr7.hic AMSI_3Dgenomics/Plasmodium/supportData/plasmodium.chrom.sizes -d true
```

Transfer `AMSI_3Dgenomics/results/Ring/Juicebox/Ring_chr7.hic` back to your own laptop for online visualization.

#### Visualization

1. Open the Online Juicebox at `https://aidenlab.org/juicebox/`.

2. Load Map - Local Map File - Find the downloaded .hic file.

3. Check the following:

    - genome coordinate

    - resolution

    - color scale

    - Normalization (Optional task: compare KR normalization with the `Balanced` normalization function on Juicebox.)

    - Comparison between three stages

    - Public data and other genome tracks

    - Desktop version
