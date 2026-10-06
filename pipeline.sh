!/bin/bash
read -p "enter type of seq,PE OR SE:" type
mkdir fastq_report fastq_files
if [[ "${type,,}" == "SE" ]]
then
  read -p "give the accession number of fastq file:" acc
  fasterq-dump -p $acc
  mv *".fastq" fastq_files
else
  read -p "give the accession number of fastq file:" acc
  fasterq-dump -p --split-3 $acc
  mv *".fastq" fastq_files
fi
mkdir fastq_report
fastqc fastq_files/*.fastq -o fastq_report
echo "here is your fastqc report :"
ls fastq_report
read -p "enter type of fastq file,PE OR SE:" type
if [[ "${type,,}" == "SE" ]]
then
  mkdir fastq_quality_control
  read -p "enter the fastq file:" fastq_input
  fastp\
  -i $fastq_input\
  -o $fastq_quality_control1\
  --thread 4\
  -h html.report\
  -l 100\
  -j report.json\
  -q 30\
  -u 30\
  -r\
  --cut_right_mean_quality 20
  echo "here is your output file $fastq_quality_control1 "
  head -n 5 $fastq_quality_control1
else
  read -p "enter the fastq file 1:" fastq_input1
  read -p "enter the fastq file2:" fastq_input2
  read -p "enter the name for output of file 1" fastq_quality_control1
  read -p "enter the name for output of file 2" fastq_quality_control2
  fastp\
  -I fastq_files/$fastq_input2\
  -i fastq_files/$fastq_input1\
  -O $fastq_quality_control2\
  -o $fastq_quality_control1\
  --thread 4\
  -h html.report\
  -l 100\
  -j report.json\
  -q 30\
  -u 30\
  -r\
  --cut_right_mean_quality 20
  echo "here are your output files $fastq_quality_control1 $fastq_quality_control1"
  head -n 5 $fastq_quality_control1 $fastq_quality_control2
fi
read -p "give the path of ref genome:" ref_genome
if
  read -p "type of fastq file:" type
   [[ "${type,,}" == "pe" ]]
then
 bwa index $ref_genome
 bwa mem "$ref_genome" "$fastq_quality_control1" "$fastq_quality_control2"|samtools sort -o bam_output.bam
 samtools index bam_output.bam
 bcftools mpileup  -E --threads 4 -Ou -f $ref_genome bam_output.bam|bcftools call -mv -Ob -o vcf_output.bcf
 bcftools view vcf_output.bcf > vcf_file.vcf
 echo "here is your vcf file"
 cat vcf_file.vcf
else
   bwa index "$ref_genome"
 bwa mem "$ref_genome" "$fastq_quality_control1"|samtools sort -o bam_output.bam
 samtools index bam_output.bam
 bcftools mpileup  -E --threads 4 -Ou -f $ref_genome bam_output.bam|bcftools call -mv -Ob -o vcf_output.bcf
 bcftools view vcf_output.bcf > vcf_file.vcf
fi
python3 annotate_variants.py "$ref_genome" vcf_file.vcf
