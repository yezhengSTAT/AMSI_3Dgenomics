---
title: "Hi-C Data Processing"
author: "Ye Zheng"
date: "December 3, 2019"
output:
  html_document:
    df_print: paged
  pdf_document: default
---

### Data and Scripts

For practical processing of Hi-C data, we are going to leverage three different stages of malaria parasite P. falciparum red blood cell cycles (Ay et al. 2014). Complete raw sequences for P. falciparum can be obtained from GEO under the accession code GSE50199. The demo data we will use for today's workshop are simulated Hi-C data using FreeHi-C (Zheng and Keles. 2019) on chromomosome 7 of three stages of P.falciparum, Ring stage, Trophozoite stage, and Schizont stage, respectively. They are simulated to the same sequencing depth. We will reproduce some of the analysis published in [Zheng and Keles. 2019](https://www.nature.com/articles/s41592-019-0624-3)

All the data and scripts are available on AMSI BioInfoSummer 3D Genomics Workshop GitHub <https://github.com/yezhengSTAT/AMSI_3Dgenomics>. 

```
cd pathToWorkingDirectory
git clone https://github.com/yezhengSTAT/AMSI_3Dgenomics
```

### Step 1: Alignment

We will use [BWA](http://bio-bwa.sourceforge.net/) for read end alignment respectively. An aggregated script, step1_alignment, for alignment and chimeric reads rescuing is provided. However, let's first try the core section for the alignment step.

Let's first create a folder to save all the alignment outputs.
```
mkdir -p AMSI_3Dgenomics/results/Ring/step1_alignment
```

To use BWA for alignment, we will need to generate index files for the target reference genome. The index files will be saved under the same directory of the reference genome fasta file.
```
bwa index AMSI_3Dgenomics/Plasmodium/supportData/PlasmoDB-9.0_Pfalciparum3D7_Genome.fasta
```
Now we can continue to align the read end, for example Ring stage chromosome 7 end 1.
```
bwa aln -n 3 -o 1 -t 1 AMSI_3Dgenomics/Plasmodium/supportData/PlasmoDB-9.0_Pfalciparum3D7_Genome.fasta \
AMSI_3Dgenomics/Plasmodium/rawData/Ring_chr7_1.fastq \
>AMSI_3Dgenomics/results/Ring/step1_alignment/Ring_chr7_1.sai

bwa samse AMSI_3Dgenomics/Plasmodium/supportData/PlasmoDB-9.0_Pfalciparum3D7_Genome.fasta \
AMSI_3Dgenomics/results/Ring/step1_alignment/Ring_chr7_1.sai \
AMSI_3Dgenomics/Plasmodium/rawData/Ring_chr7_1.fastq \ 
>AMSI_3Dgenomics/results/Ring/step1_alignment/Ring_chr7_1.sam
```
`AMSI_3Dgenomics/results/Ring/step1_alignment/Ring_chr7_1.sam` is our alignment results for Ring stage chromosome 7 end1. 

Try the aggregated alignment script for all three stages.

```
stage="Ring"              ## Change to Trophozoite or Schizont for the other life stages of Plasmodium.
bin="AMSI_3Dgenomics/bin" ## Path to the bin folder.
fastqFile="AMSI_3Dgenomics/Plasmodium/rawData/${stage}_chr7" 
                          ## path to fastq files. Please note _1.fastq or _2.fastq should be omitted here.
ref="AMSI_3Dgenomics/Plasmodium/supportData/PlasmoDB-9.0_Pfalciparum3D7_Genome.fasta" 
                          ## Path to the reference genome
step1Path="AMSI_3Dgenomics/results/${stage}/step1_alignment" 
                          ## Path to the directory for all the outputs
summaryFile="AMSI_3Dgenomics/results/${stage}/summary.txt" 
                          ## Path to the summary file that will summarize alignment statistics.
bwa=bwa                   ## Path to bwa executive file.
samtools=samtools         ## Path to samtools executive file.
coreN=1                   ## Number of core need for alignment. Use >1 number for parallel running.
mismatchN=3               ## Maximum mismatches allowed
gapN=1                    ## Maximum gap allowed
ligateSite="GATCGATC"     ## Sequence at the ligation site. 0 for not re-align to rescue chimeric reads

bash step1_alignment.sh "$bin" "$fastqFile" "${step1Path}" "$bwa" "$samtools"  "$ref" "$coreN" "$mismatchN" "$gapN" "$summaryFile" "$ligateSite"
```

There will be three files generated at `AMSI_3Dgenomics/results/Ring/step1_alignment`:

- `Ring_chr7_1.sam`: alignment results for Ring stage chromosome 7 end 1.

- `Ring_chr7_2.sam`: alignment results for Ring stage chromosome 7 end 2.

- `summary.txt`: step 1 alignment results summary.


### Step 2: Read Ends Pairing

We will use `pysam` module of python3 to match the read end alignment results by read ID and save into one SAM file with two ends alignment results in two consecutive lines. Meanwhile, we will also remove singleton read pairs and unmapped read pairs.

```
step2Path="AMSI_3Dgenomics/results/${stage}/step2_readEndsPairing"
python3 step2_readEndsPairing.py -r1 ${step1Path}/${stage}_chr7_1.sam -r2 ${step1Path}/${stage}_chr7_2.sam -o ${step2Path}/${stage}_chr7.sam -sf $summaryFile
```

There will be one files generated at AMSI_3Dgenomics/results/Ring/step2_readEndsPairing:

- `Ring_chr7.sam`: alignment results after pairing two ends for Ring stage chromosome 7.

Check your summary file. You will see the read ends pairing summary statistics added!

### Step 3: Validation Filtering

For validation filtering, we will utilize `pysam` and `bx-python` modules of python3 to diagnose if the read pairs are valid read pairs or self-circles, dangling ends, religations, invalid alignment, short-range contact. 

```
step3Path="AMSI_3Dgenomics/results/${stage}/step3_validation"
refrag="AMSI_3Dgenomics/Plasmodium/supportData/MboI_resfrag_plasmodium.bed"
                                ## Restriction enzyme fragment file. 
refragL=50                      ## Lower bound of the read pair distances summation from read end alignment position to its assigned RE fragment cutting site.
refragU=500                     ## Upper bound of the read pair distances summation from read end alignment position to its assigned RE fragment cutting site.
resolution=10000                ## The window size of binning.
lowerBound=$((resolution * 2))  ## The lower bound for valid long-range interactions. We recommend using 2 times the resolution to remove short-range interactions.

python3 step3_validation.py -f ${refrag} -r ${step2Path}/${stage}_chr7.sam -o ${step3Path} -l $refragL -u $refragU -d $lowerBound -m "window" -b $resolution -sf $summaryFile
```

There will be one BED file generated at AMSI_3Dgenomics/results/Ring/step3_validation:

- `Ring_chr7.validPairs`: read ID (column 1), aligned position for end 1 (column2-6: chromosome, position, strand, corresponding restriction fragment, mid-point of correponding bin ), aligned position for end 2 (column7-11: chromosome, position, strand, corresponding restriction fragment, end 2 mid-point of correponding bin,   

### Step 4: Duplicates Removal

Linux commands can be fast in dealing with duplicates. Will check column 2, 3, 4, 5, 6, and 9 for PCR duplicates. We will first create a local temporary file for sorting as sometimes the sorting temporary files can grow too huge for the /tmp/ folder.

```
step4Path="AMSI_3Dgenomics/results/${stage}/step4_duplicatesRemoval"
mkdir -p $step4Path/sorttmp
sort -k2,2V -k3,3n -k4 -k7,7V -k8,8n -k9 -k1 -T $step4Path/sorttmp $step3Path/${stage}_chr7.validPairs | awk -v OFS="\t" 'BEGIN{c1=0;c2=0;p1=0;p2=0;s1=0;s2=0;}(c1!=$2 || c2!=$7 || p1!=$3 || p2!=$8 || s1!=$4 || s2!=$9 ){print;c1=$2;c2=$7;p1=$3;p2=$8;s1=$4;s2=$9}' >$step4Path/${stage}_chr7.validPairs.noDup
rmdir ${step4Path}/sorttmp
```

Or using the aggregated script.

```
bash step4_duplicatesRemoval.sh "${step3Path}/${stage}_chr7.validPairs" "${step4Path}/${stage}_chr7.validPairs.noDup" "$summaryFile"
```

### Step 5: Genome Binning

Bin the genome and count the number of interactions for each bin pairs.

```
step5Path="AMSI_3Dgenomics/results/${stage}/step5_bin"
mkdir -p $step5Path/sorttmp
awk '{print $2, $6, $7, $11}' $step4Path/${stage}_chr7.validPairs.noDup | sort -T ${step5Path}/sorttmp | uniq -c | awk -v OFS="\t" '{print $2, $3, $4, $5, $1}' | sort -k1,1V -k2,2n -k3,3V -k4,4n -T ${step5Path}/sorttmp >${step5Path}/${stage}_chr7.binPairs
        
rm -rf ${step5Path}/sorttmp
```

### Step 6: Normalization

KR normalization.
```
chromSizeFile="AMSI_3Dgenomics/Plasmodium/supportData/plasmodium.chrom.sizes"
sparsePerc=10
step6Path="AMSI_3Dgenomics/results/${stage}/step6_normalization"

python3 step6_normalization_KR.py -r $resolution -l $chromSizeFile -c chr7 -tr $sparsePerc -f ${step5Path}/${stage}_chr7.binPairs -o $step6Path
```

