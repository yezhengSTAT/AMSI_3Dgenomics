FROM ubuntu 
FROM python:3.6
FROM openjdk:8
FROM rocker/verse:3.6.1
RUN apt-get update && apt-get install -y samtools bwa bedtools wget git python-pip build-essential zlib1g-dev libbz2-dev liblzma-dev
RUN pip install numpy scipy pysam bx-python Cython csv
RUN git clone --recursive git://github.com/yezhengSTAT/AMSI_3Dgenomics
RUN wget https://s3.amazonaws.com/hicfiles.tc4ga.com/public/juicer/juicer_tools_1.14.08.jar
MAINTAINER Ye Zheng<yzheng23@fredhutch.org>
