if(@ARGV<1){
	print "	This script is to count the number of reads within exon, Intron, 5'UTR,3'UTR
		Usage:	perl *pl	Gtrun1.extendedFrags.sam.map_hg38.bed.anno
		Output:
					Gtrun1.extendedFrags.sam.map_hg38.bed.anno.count\n";
				}

open(IN,"$ARGV[0]")||die("Can not open in file\n");
my $out=$ARGV[0].".count";
open(OUT,">$out")||die("Can not open out file\n");

while($line=<IN>){
	chomp $line;
	$total++;
	@split=split /\t/,$line;
	$ID=$split[7]."\t".$split[4]."\t".$split[8]."\t".$split[15]."\t".$split[16]."\t".$split[17]."\t".$split[18];
	if(($line=~/exon/)||($line=~/intron/)){
		$hash_count{$ID}++;
	#	print OUT "$line\n";
	}
}#print "$total\n";

print OUT "\#reads\t\#Total_reads\tAnnotation\tStrand\tDetailed Annotation\tGene Name\tGene Alias\tGene Description\tGene Type\n";

while(($key,$value)=each % hash_count){
	$normalize_count=int($hash_count{$ID})/$total;
	
	print OUT "$value\t$total\t$key\n";
}
