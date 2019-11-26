#!/bin/bash

## mHi-C
## Author: Ye Zheng
## Contact: yezheng@stat.wisc.edu
## Update: May 2018

###################################################
# step 4 remove duplicates among Valid Interactions
###################################################
validP=$1
outFile=$2
summaryFile=$3

if [ ! -d $outDir/sorttmp ]; then
    mkdir -p $outDir/sorttmp
fi

sort -k2,2V -k3,3n -k4 -k7,7V -k8,8n -k9 -k1 -T $outDir/sorttmp $validP | awk -v OFS="\t" 'BEGIN{c1=0;c2=0;p1=0;p2=0;s1=0;s2=0;}(c1!=$2 || c2!=$7 || p1!=$3 || p2!=$8 || s1!=$4 || s2!=$9 ){print;c1=$2;c2=$7;p1=$3;p2=$8;s1=$4;s2=$9}' >$outFile
    

rm -rf $outDir/sorttmp

validP_num=$(cat $validP | wc -l)
validP_nodup_num=$(cat $outFile | wc -l)


echo -e "  Valid interactions count:\t"$validP_num >>$summaryFile
echo -e "  Valid interactions without duplicates count:\t"$validP_nodup_num >>$summaryFile
