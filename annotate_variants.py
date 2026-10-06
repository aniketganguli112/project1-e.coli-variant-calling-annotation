
import sys
from Bio.Blast import NCBIWWW
from Bio import SeqIO
import pandas as pd
from Bio.Blast import NCBIXML
from Bio.SeqRecord import SeqRecord
genome=sys.argv[1]    
vcfpath=sys.argv[2]
col=["CHROM","POS","ID","REF","ALT","QUAL","FILTER","INFO","FORMAT","bam_output.bam"]
vcf=pd.read_csv(vcfpath,sep="\t",comment="#",names=col)
fasta=SeqIO.read(genome,"fasta")
for index,rows in vcf.iterrows():
    if index>30:
        break
    pos=int(rows["POS"])
    print("blasting variant at posn:",pos)
    gene=str(fasta.seq[max(0,pos-100):pos+100])
    blasts=NCBIWWW.qblast(program="blastn",database="nt",sequence=gene)
    b=NCBIXML.read(blasts)
for a in b.alignments:
    print(a.title)    
    print("no of hits",len(b.alignments))
