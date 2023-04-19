configfile: "config.yaml"


rule all:
    input:
        "result/counts/counts.txt",
        expand("result/clean/qc/{rep}_R1_001_val_1_fastqc.html",rep=config["SAMPLES"]),
        expand("result/clean/qc/{rep}_R2_001_val_2_fastqc.html",rep=config["SAMPLES"])

rule cutadapt:
    input:
        "/path/to/{sample}_R1_001.fastq.gz",
        "/path/to/{sample}_R2_001.fastq.gz"
    output:
        "result/clean/fq/{sample}_R1_001_val_1.fq.gz",
        "result/clean/fq/{sample}_R2_001_val_2.fq.gz"
    shell:
        "trim_galore {input}  -o result/clean/fq/ \
        -j 6 -q 25 --phred33 --length 18 --stringency 1 --paired --gzip\
        --three_prime_clip_R1 70 --three_prime_clip_R1 70"

rule qc:
    input:
        "result/clean/fq/{sample}_R1_001_val_1.fq.gz",
        "result/clean/fq/{sample}_R2_001_val_2.fq.gz"
    output:
        "result/clean/qc/{sample}_R1_001_val_1_fastqc.html",
        "result/clean/qc/{sample}_R2_001_val_2_fastqc.html"
    shell:
        "fastqc {input} -t 12 -o result/clean/qc/"

rule align:
    input:
        "result/clean/fq/{sample}_R1_001_val_1.fq.gz",
        "result/clean/fq/{sample}_R2_001_val_2.fq.gz"
    output:
        temp("result/align/sam/{sample}.sam")
    params:
        genome=config["genome"]
    threads:12
    log:
        "logs/hisat2/{sample}.log"
    shell:
        "hisat2 -x {params.genome} -S  {output} \
        -1 {input[0]}  -2 {input[1]} \
        -t -p {threads}"

rule sorted_bam:
    input:
        "result/align/sam/{sample}.sam"
    output:
        protected("result/align/bam/{sample}_sorted.bam")
    shell:
        "samtools sort {input} -o {output} \
        -@ 6"

rule count:
    input:
        bam=expand("result/align/bam/{rep}_sorted.bam", rep=config["SAMPLES"]),
    output:
        "result/counts/counts.txt"
    params:
        gtf=config["gtf"]
    shell:
        "featureCounts {input.bam}  -a {params.gtf} \
        -o result/counts/counts.txt \
        -T 6  -p"
