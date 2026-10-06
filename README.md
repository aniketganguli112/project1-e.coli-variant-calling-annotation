E. coli Variant Calling and Annotation Pipeline

An automated NGS pipeline that finds genetic variants in E. coli
sequencing reads and annotates them using NCBI BLAST.

Supports both single-end (SE) and paired-end (PE) reads

Pipeline Steps

1. Download reads from NCBI SRA (fasterq-dump)
2. Quality check (FastQC) and trimming(fastp)
3. Align reads to the reference genome (BWA-MEM)
4. Sort and index alignments (samtools)
5. Call variants (bcftools mpileup + call) -> vcf_file.vcf
6. Annotate variants with BLAST (annotate_variants.py)

tools used

Bash, Python, Biopython, pandas, Sra Toolkit, FastQC,fastp,
Bwa, Samtools, bcftools,Blast

Files

- "pipeline.sh": runs the whole workflow
- "annotate_variants.py": extracts a 200 bp window around each variant
  and runs BLAST

How to Run

conda install -c bioconda -c conda-forge sra-tools fastqc bwa samtools bcftools
pip install biopython pandas
bash pipeline.sh

Notes and Limitations

- BLAST is run on only the first few variants, because NCBI web BLAST is slow.
- Reference: E. coli genome (accession HG738867.1).
- Reads used: SRA accession SRR40993358

What I Learned
Building a reproducible bioinformatics workflow, working with
VCF files, and using Git/GitHub,handling genomic data in python


