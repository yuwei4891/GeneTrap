# GeneTrap
DerianoLab-geneTrap pipeline

These codes are the pipeline for sequencing analysis in high throughput gene trap  screen .

Common tools utilized include Perl, BWA, samtools, ea-utils, bedtools, HOMER. 

The procedures for processing sequencing reads in fastq format:


Step 1. Merge read1 and read2 with at least 10 bp  overlap

	FLASH-1.2.11/flash -M 250 $sample_read1.cutadapt.fastq $sample_read2.cutadapt.fastq
	Output:
	#  out.extendedFrags.fastq
	
	Rename with output file with the name of your sample :
	mv out.extendedFrags.fastq $sample.extendedFrags.fastq
	
Step 2. Mapping merged read to human genome hg38 and genetrap sequence

	bwa mem -t 8 /BWA_index/hg38_genetrap.fa $sample.extendedFrags.fastq >$sample.extendedFrags.sam
	#  Please merge reference genome and genetrap sequence and perform BWA index in advance, here we used hg38 reference

Step 3.	Parase reads containing both the gene trap sequence and the reference sequence
	
	perl find_read_with_genetrap_and_human_map_part.pl $sample.extendedFrags.sam
	
	Output the reads with mapped reference sequence part:
	#	$sample.extendedFrags.sam.map_hg38.sam
					
Step 4. Annotate the mapped reads by HOMER

	samtools view -bS $sample.extendedFrags.sam.map_hg38.sam >$sample.extendedFrags.sam.map_hg38.bam
	bedtools bamtobed -i $sample.extendedFrags.sam.map_hg38.bam >$sample.extendedFrags.sam.map_hg38.bed
	perl /HOMER/bin/annotatePeaks.pl $sample.extendedFrags.sam.map_hg38.bed hg38 >$sample.extendedFrags.sam.map_hg38.bed.anno
	
	Output:
  	#	$sample.extendedFrags.sam.map_hg38.bed.anno
			
Step 5. Calculate the number of reads mapping to Exon, Intron, UTR of reference genome

	perl count_Exon_Intron_UTR.pl $sample.extendedFrags.sam.map_hg38.bed.anno

	Output:
	#	$sample.extendedFrags.sam.map_hg38.bed.anno.count
