#!/usr/bin/perl
#
# This program takes two files in argument, computes the mean of the data in the first file, and
# print the result in the second file.

# Returns the mean of all the values passed in argument
sub mean {
	if (!@_) {
		return '';
	}
	$sum = 0;
	$n = 0;
	foreach $value (@_) {
		$sum += $value;
		$n++;
	}
	return $sum / $n;
}

# return true if the argument is a "simple" number (no scientific notation)
sub isNumber {
	return $_[0] =~ /^(-?\d+\.?\d*|\.\d+)$/;
}

$file = $ARGV[0];
open(FILE, $file) or die "Unable to open $file : $!";

# STORE THE SUM
$first = 1;
$cmpt = 0;
while ($line = <FILE>) {
	if (($line =~ /^\s*\n$/) || ($line =~ /^\s*#/)) { # remove comment and blank lines
		next;
	}
	my @lineAsWords = split(/\s+/, $line);

	if ($first) { 
		# set @result to zeros
		for (my $j = 0; $j <= $#lineAsWords; $j++) {
			push(@result, 0);
		}
		$first = 0;
	}

	for ($j = 0; $j <= $#result; $j++) {
		if (isNumber($lineAsWords[$j]) && isNumber($result[$j])) {
			$result[$j] += $lineAsWords[$j];
		}
		else {
			$result[$j] = "NaN";
		}
	}
	$cmpt++;
}
close(FILE);

# PRINT THE RESULT
$fileOutput = $ARGV[1];
open(OUTPUT, '>', $fileOutput);

for $item (@result) {
	if (isNumber($item)) {
		print OUTPUT ($item / $cmpt);
	}
	else {
		print OUTPUT "NaN";
	}
	print OUTPUT " \t ";
}
print OUTPUT "\n";

close(OUTPUT);

