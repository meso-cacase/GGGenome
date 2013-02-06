package Align2seq ;

# 2つの塩基配列のアライメントを行い差分をハイライトするためのモジュール
#
# 2012-12-28 Yuki Naito (@meso_cacase)

use warnings ;
use strict ;

# ====================
sub diffseq {

# 2つの塩基配列のアライメントを行い差分をハイライトする
# usage: $html = diffseq('GCAAGAAGAGATTGC','GCAAGAAAAGATTGC') ;

# query: GCAAGAAGAGATTGC
#        |||||||x|||||||
# sbjct: GCAAGAAAAGATTGC
#
# -> GCAAGAA<strong>A</strong>AGATTGC
#
# query: GCA AGAAGAGATTGC
#        ||| ||||||||||||
# sbjct: GCAGAGAAGAGATTGC
#
# -> GCA<ins>G</ins>AGAAGAGATTGC
#
# query: GCAAGAAGAGATTGC
#        ||||||| |||||||
# sbjct: GCAAGAA AGATTGC
#
# -> GCAAGAA<del>-</del>AGATTGC

# needlemanwunsch()：塩基配列の末端部分にミスマッチやギャップが
# ある場合でもそれを含めてアライメントを出力する
my ($align1, $align2) = needlemanwunsch(@_) ;

# smithwaterman()：塩基配列の末端部分にミスマッチやギャップがある
# 場合にその手前でアライメントを止めてしまうため、ここでは適さない
# my ($align1, $align2) = smithwaterman(@_) ;

my $html = '' ;

foreach (0..length($align2)-1){
	$html .=
		(substr($align1,$_,1) eq substr($align2,$_,1)) ?
			substr($align2,$_,1) :
		(substr($align1,$_,1) eq '-') ?
			'<ins>' . substr($align2,$_,1) . '</ins>' :
		(substr($align2,$_,1) eq '-') ?
			'<del>-</del>' :
		# else ミスマッチ塩基の場合
			'<strong>' . substr($align2,$_,1) . '</strong>' ;
}

return $html ;
} ;
# ====================
sub needlemanwunsch {

# Needleman-Wunsch Algorithm
#
# Code from: Korf I, Yandell M, Bedell J. BLAST. O'Reilly (2003)
# p.44 Example 3-1. Trace-back with Needleman-Wunsch algorithm
# Download Example Code: http://examples.oreilly.com/9780596002992/
#
# Modified by Yuki Naito (@meso_cacase)

# get sequences
my $seq1 = $_[0] // '' ;
my $seq2 = $_[1] // '' ;

# scoring scheme
my $MATCH    =  1; # +1 for letters that match
my $MISMATCH = -1; # -1 for letters that mismatch
my $GAP      = -1; # -1 for any gap

# initialization
my @matrix;
$matrix[0][0]{score}   = 0;
$matrix[0][0]{pointer} = "none";
for(my $j = 1; $j <= length($seq1); $j++) {
	$matrix[0][$j]{score}   = $GAP * $j;
	$matrix[0][$j]{pointer} = "left";
}
for (my $i = 1; $i <= length($seq2); $i++) {
	$matrix[$i][0]{score}   = $GAP * $i;
	$matrix[$i][0]{pointer} = "up";
}

# fill
for(my $i = 1; $i <= length($seq2); $i++) {
	for(my $j = 1; $j <= length($seq1); $j++) {
		my ($diagonal_score, $left_score, $up_score);
		
		# calculate match score
		my $letter1 = substr($seq1, $j-1, 1);
		my $letter2 = substr($seq2, $i-1, 1);		
		if ($letter1 eq $letter2) {
			$diagonal_score = $matrix[$i-1][$j-1]{score} + $MATCH;
		}
		else {
			$diagonal_score = $matrix[$i-1][$j-1]{score} + $MISMATCH;
		}
		
		# calculate gap scores
		$up_score   = $matrix[$i-1][$j]{score} + $GAP;
		$left_score = $matrix[$i][$j-1]{score} + $GAP;
		
		# choose best score
		if ($diagonal_score >= $up_score) {
			if ($diagonal_score >= $left_score) {
				$matrix[$i][$j]{score}   = $diagonal_score;
				$matrix[$i][$j]{pointer} = "diagonal";
			}
			else {
				$matrix[$i][$j]{score}   = $left_score;
				$matrix[$i][$j]{pointer} = "left";
			}
		} else {
			if ($up_score >= $left_score) {
				$matrix[$i][$j]{score}   = $up_score;
				$matrix[$i][$j]{pointer} = "up";
			}
			else {
				$matrix[$i][$j]{score}   = $left_score;
				$matrix[$i][$j]{pointer} = "left";
			}
		}
	}
}

my $align1 = "";
my $align2 = "";

my $j = length($seq1);
my $i = length($seq2);

while (1) {
	last if $matrix[$i][$j]{pointer} eq "none";
	
	if ($matrix[$i][$j]{pointer} eq "diagonal") {
		$align1 .= substr($seq1, $j-1, 1);
		$align2 .= substr($seq2, $i-1, 1);
		$i--; $j--;
	}
	elsif ($matrix[$i][$j]{pointer} eq "left") {
		$align1 .= substr($seq1, $j-1, 1);
		$align2 .= "-";
		$j--;
	}
	elsif ($matrix[$i][$j]{pointer} eq "up") {
		$align1 .= "-";
		$align2 .= substr($seq2, $i-1, 1);
		$i--;
	}	
}

$align1 = reverse $align1;
$align2 = reverse $align2;

return ($align1, $align2);
} ;
# ====================
sub smithwaterman {

# Smith-Waterman Algorithm
#
# Code from: Korf I, Yandell M, Bedell J. BLAST. O'Reilly (2003)
# p.47 Example 3-2. Local alignment with the Smith-Waterman algorithm
# Download Example Code: http://examples.oreilly.com/9780596002992/
#
# Modified by Yuki Naito (@meso_cacase)

# get sequences
my $seq1 = $_[0] // '' ;
my $seq2 = $_[1] // '' ;

# scoring scheme
my $MATCH    =  1; # +1 for letters that match
my $MISMATCH = -1; # -1 for letters that mismatch
my $GAP      = -1; # -1 for any gap

# initialization
my @matrix;
$matrix[0][0]{score}   = 0;
$matrix[0][0]{pointer} = "none";
for(my $j = 1; $j <= length($seq1); $j++) {
	$matrix[0][$j]{score}   = 0;
	$matrix[0][$j]{pointer} = "none";
}
for (my $i = 1; $i <= length($seq2); $i++) {
	$matrix[$i][0]{score}   = 0;
	$matrix[$i][0]{pointer} = "none";
}

# fill
my $max_i     = 0;
my $max_j     = 0;
my $max_score = 0;

for(my $i = 1; $i <= length($seq2); $i++) {
	for(my $j = 1; $j <= length($seq1); $j++) {
		my ($diagonal_score, $left_score, $up_score);
		
		# calculate match score
		my $letter1 = substr($seq1, $j-1, 1);
		my $letter2 = substr($seq2, $i-1, 1);		
		if ($letter1 eq $letter2) {
			$diagonal_score = $matrix[$i-1][$j-1]{score} + $MATCH;
		}
		else {
			$diagonal_score = $matrix[$i-1][$j-1]{score} + $MISMATCH;
		}
		
		# calculate gap scores
		$up_score   = $matrix[$i-1][$j]{score} + $GAP;
		$left_score = $matrix[$i][$j-1]{score} + $GAP;
		
		if ($diagonal_score <= 0 and $up_score <= 0 and $left_score <= 0) {
			$matrix[$i][$j]{score}   = 0;
			$matrix[$i][$j]{pointer} = "none";
			next; # terminate this iteration of the loop
		}
		
		# choose best score
		if ($diagonal_score >= $up_score) {
			if ($diagonal_score >= $left_score) {
				$matrix[$i][$j]{score}   = $diagonal_score;
				$matrix[$i][$j]{pointer} = "diagonal";
			}
			else {
				$matrix[$i][$j]{score}   = $left_score;
				$matrix[$i][$j]{pointer} = "left";
			}
		} else {
			if ($up_score >= $left_score) {
				$matrix[$i][$j]{score}   = $up_score;
				$matrix[$i][$j]{pointer} = "up";
			}
			else {
				$matrix[$i][$j]{score}   = $left_score;
				$matrix[$i][$j]{pointer} = "left";
			}
		}
		
		# set maximum score
		if ($matrix[$i][$j]{score} > $max_score) {
			$max_i     = $i;
			$max_j     = $j;
			$max_score = $matrix[$i][$j]{score};
		}
	}
}

my $align1 = "";
my $align2 = "";

my $j = $max_j;
my $i = $max_i;

while (1) {
	last if $matrix[$i][$j]{pointer} eq "none";
	
	if ($matrix[$i][$j]{pointer} eq "diagonal") {
		$align1 .= substr($seq1, $j-1, 1);
		$align2 .= substr($seq2, $i-1, 1);
		$i--; $j--;
	}
	elsif ($matrix[$i][$j]{pointer} eq "left") {
		$align1 .= substr($seq1, $j-1, 1);
		$align2 .= "-";
		$j--;
	}
	elsif ($matrix[$i][$j]{pointer} eq "up") {
		$align1 .= "-";
		$align2 .= substr($seq2, $i-1, 1);
		$i--;
	}	
}

$align1 = reverse $align1;
$align2 = reverse $align2;

return ($align1, $align2);
} ;
# ====================

return 1 ;
