bulkRNAseq snakemake workflow
================

waiting to edit

# File download

download file in the ref-data/ directory;

Hisat2 UCSC hg38 genome index can be downloaded
[here](https://genome-idx.s3.amazonaws.com/hisat/hg38_genome.tar.gz);then
unzip the file;

``` bash
tar -zxvf *tar.gz 
rm *tar.gz
```

UCSC hg38 gtf file can be downloaded
[here](https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.refGene.gtf.gz);

参考：  
[RNA-seq入门实战](https://cloud.tencent.com/developer/article/2032040?areaSource=&traceId=)  
[snakemake中复杂shell命令](https://carpentries.org/community-lessons/)  
[snakemake基础以及进阶](https://felicia-yjzhang.gitbooks.io/bioinfo-training/content/snakemakeshi-yong.html)
