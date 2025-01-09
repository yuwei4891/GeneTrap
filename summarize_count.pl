#3	72096	intron (NM_032137, intron 5 of 16)	-	L1MA3|LINE|L1	C3orf20	-	chromosome 3 open reading frame 20	protein-coding

if(@ARGV<1){  
      print " This script is to summarize the number of reads within exon, Intron, 5'UTR,3'UTR
                Usage:  perl *pl        $sample.extendedFrags.sam.map_hg38.bed.anno.count
                Output:
                                        $sample.extendedFrags.sam.map_hg38.bed.anno.count.summary\n";
                  }

my $out=$ARGV[0].".summary";
open(OUT,">$out")||die("Can not open out file\n");
open(IN,"$ARGV[0]")||die("Can not open in file\n");
while($line=<IN>){
	chomp $line;
	if($line=~/Total_reads/){
	}
	else{
		@split=split /\t/,$line;
		$number=$split[0];
		@type=split /\s/,$split[2];
		$type=$type[0];
		$hash{$type}+=$number;
	}
}

while(($key,$value)=each % hash){
	
	
	print OUT "$key\t$value\n";
}
