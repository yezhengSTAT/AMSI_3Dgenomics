# 3D Genomics and Long-range Gene Regulations

Workshop for AMSI BioInfoSummer 2019

- Session: Stream C, Tuesday, December 3, 2019, 1:30pm - 5:00pm
- Instructor: Ye Zheng, Fred Hutchinson Cancer Research Center, yzheng23@fredhutch.org
- Teaching Assistant: Yue Cao, University of Sydney

Chromatin is dynamically organized within the three-dimensional nuclear space in a way that allows efficient genome packaging while ensuring proper expression and replication of the genetic materials. Therefore, understanding of genome architecture and revealing its relationship to the genomic function is vital and has progressed through the advancement of new technologies. Recently developed chromatin conformation capture-based assays (3C) enabled the study of three-dimensional chromosomal architecture in a high throughput fashion. Hi-C, particularly, elucidated genome-wide long-range interactions among loci. In this workshop, we will go through the state-of-the-art 3D genomics technologies and focus on the role of statistical methods and computational tools in analyzing 3D genomics data. Successful running of the complete pipeline and all software is not strictly required; instead, we will concentrate on the inference and interpretation of the results.

### Timeline of Workshop

- Session 1: 1:30 - 2:00 Introduction to 3D genomics. 

- Session 2: 2:00 - 2:30 Hi-C data processing.

- Session 3: 2:30 - 3:00 Hi-C data visualization.

- Session 4: 3:30 - 4:00 Introduction to Hi-C data analysis.

- Session 5: 4:00 - 5:00 Hi-C data quality control and differential interaction detection analysis.

### Lecture Slides

We will start with introduction to the 3D genomics background, fundamental processing steps, visualization of the processed Hi-C data, and some vital analysis. Slides can be downloaded [here](http://pages.stat.wisc.edu/~yezheng/Hi-C/3DgenomicsWorshopSlides.pdf). 

### Practical Instructions

 - [Hi-C Data Processing](http://pages.stat.wisc.edu/~yezheng/AMSI2019/Hi-C_data_processing.html)
 
 - [Hi-C Visualization](http://pages.stat.wisc.edu/~yezheng/AMSI2019/Hi-C_visualization.html)
 
 - [Hi-C Data Analysis](http://pages.stat.wisc.edu/~yezheng/AMSI2019/Hi-C_data_analysis.html)

### Google Cloud Access

1. Type ```35.232.81.4``` in your web browser. Ignore all the danger warning ;)

2. Enter the username and password provided to you.

3. Type ```git clone https://github.com/yezhengSTAT/AMSI_3Dgenomics``` in the Terminal (On the left panel next to Console).

### Practical Linux Commands

- Get current directory path: pwd 
- Go to other directory: cd pathToOtherDirectory 
  - Current directory ./
  - Home directory ~/ 
- Move up one level of current directory: cd .. 
- List all the files in the current directory: ls 
- Check the content of a file: 
  - less fileName (to open the file in terminal)
  - Scroll down to see more of the file
  - Type “q” to exit the file 
- Copy a file from one place to another directory: cp path1/fileName path2/ 
- Move a file from one place to another directory: mv path1/fileName path2/
- Create a new directory in current folder: mkdir directoryName
- Create a new file in current folder: touch fileName
- Delete a file: rm pathToFile/fileName 
- Delete a directory: rmdir pathToDirectory/dirName/ 
- Compress a file: gzip –c fileName > fileName.gz or tar -zcvf fileName.tar.gz fileName
- Uncompress a file: gunzip fileName.gz  or tar -zxvf fileName.tar.gz
- Count the number of lines in a file: wc –l pathToFile/fileName
