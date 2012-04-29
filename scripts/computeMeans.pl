#!/usr/bin/perl
#
# This program takes any number of files in argument, and computes the mean of the data in the
# files.

use FileHandle;

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

sub computeLine {
#   print "computeLine : @_ \n";
   my @allLinesAsWords = ();
   foreach $line (@_) {
      my @lineAsWords = split(/\s+/, $line);
      push(@allLinesAsWords, \@lineAsWords);
   }

   my $continue = 1;
   my $isNumber = 1;
   $j = 0;
   while ($continue) {
      $continue = 0;
      $isNumber = 1;
      # loop through words in the line
      my @words = ();
#      print "Words : ";
      for my $i (0 .. $#_) {
         # loop through files
         if ($allLinesAsWords[$i][$j]) { 
            $continue = 1;
            if ($allLinesAsWords[$i][$j] =~ /^(-?\d+\.?\d*|\.\d+)$/) {
               push (@words, $allLinesAsWords[$i][$j]);
#               print "$allLinesAsWords[$i][$j] ";
            }
            else {
               $isNumber = 0;
            }
         }
      }
#      print "\n";
      if ($isNumber) {
         $result = mean(@words);
      }
      else {
         $result = 'NaN';
      }
      print "$result\t";
      $j++;
   }

   print "\n";
#   print "EndComputeLine\n";
}


# We store FileHandlers for each file in the @fh array.
@allFh = ();
foreach $file (@ARGV) {
   my $fh = FileHandle->new();
   push(@allFh, $fh);
   open($fh, $file) or die "Unable to open $file : $!";
#   print "File '$file' opened. \n";
}

# We compute the means.
$continue = 1;
$cmpt = 0;
while ($continue) {
   $cmpt++;
   $continue = 0;
   my @allLines = ();

   # read one file at a time
   foreach $currentFh (@allFh) {
      my $line = <$currentFh>;
      if ($line) {
         $continue = 1;
         if (!($line =~ /^\s*\n$/) && !($line =~ /^\s*#/)) { # remove comment and blank lines
            push (@allLines, $line);
         }
      }
   }

#   print "Ligne $cmpt : ";
   computeLine(@allLines);
}


