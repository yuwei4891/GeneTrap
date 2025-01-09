if(@ARGV<1){
	print " This script is to find the reads which have gene trap sequence & part of human sequence
			Only output the human part 
			Usage:
				perl 	*pl  	$sample.extendedFrags.sam
			Output:
						$sample.extendedFrags.sam.map_hg38.sam\n\n";
}

open(IN,"$ARGV[0]")||die("Can not open sam file\n");
my $out=$ARGV[0].".map_hg38.sam";
open(OUT,">$out")||die("Can not open out file\n");

$genetrap_length_cutoff=30;		# the cutoff of genetrap is 30 bps

while($line=<IN>){
	chomp $line;
	@split=split /\t/,$line;
	$chr=$split[2];
	$ID=$split[0];
	$cigar=$split[5];
	if($chr=~/chr/){
		$hash_human{$ID}++;
	}
	if($chr=~/genetrap/){
		$loc_S=index($cigar,'S');
		$loc_M=index($cigar,'M');
		if($loc_S>$loc_M){		# 64M194S
		#	print "$line\n";
			$cigar=~s/M/S/;
			@split_S=split /S/,$cigar;
			$M=$split_S[0];
			$S=$split_S[1];
			if($M>=$genetrap_length_cutoff){
				$hash_gentrap{$ID}++;
			}
		}
		else{
#		M05218:89:000000000-G29F2:1:1101:5810:8591	0	genetrap	2	60	361S65M62S	
			$cigar=~s/M/S/;
			@split_S=split /S/,$cigar;
			$count_S=@split_S;
			$M=$split_S[1];
			if($M>=$genetrap_length_cutoff){
				$hash_gentrap{$ID}++;
			}
		}
	}
}

open(IN,"$ARGV[0]")||die("Can not open sam file\n");
while($line=<IN>){
	chomp $line;
	@split=split /\t/,$line;
	if($line=~/^\@SQ/){
		print OUT "$line\n";
	}
	$chr=$split[2];
	$ID=$split[0];
	$cigar=$split[5];
	if(($hash_human{$ID}>0)&&($hash_gentrap{$ID}>0)){
		if($chr=~/chr/){
			if($hash_human{$ID}>1){	# multiple copy and paste
			#	print "$line\n";
			}
			elsif($hash_human{$ID}==1){			##### this is genetrap insertion site
				print OUT "$line\n";
			}
			else{#print "$line\n";
			}
		}
	}
}