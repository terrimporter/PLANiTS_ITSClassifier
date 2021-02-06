#!/usr/bin/perl
# Teresita M. Porter, Feb. 2/21
# Script to convert UNITE qiime formatted files to re-train stand-alone RDP classifier v2.13
# USAGE perl qiime_unite_to_rdp.plx file.fasta file.taxonomy

use strict;
use warnings;
use Data::Dumper;

# declare vars
my $i=0;
my $line;
my $acc;
my $lineage;
my $j;
my $seq;
my $index=0;
my $taxonname;
my $previousindex='-1';
my $rankindex;
my $rankname;
my $taxon;
my $rankletter;
my $tmp;
my $previoustaxon;
my $newlineage;
my $k=0;
my $mytrainseq;

# declare arrays
my @fasta;
my @tax;
my @line;
my @lineage;
my @taxon;
my @mytrainseq;

# declare hashes
my %tax; #id = sh, val = qiime formatted lineage
my %taxon; #id = k__taxon; val = taxonindex
my %rankname; #id = letter; val = rankname
my %problems; # id = taxon g__genus; val = 1

# create rankname hash
%rankname = (
		'0',"Root",
		'1', "kingdom",
		'2', "phylum",
		'3', "class",
		'4', "order",
		'5', "family",
		'6', "genus",
		'7', "species");

# create problems hash
# contains non-unique taxa (ex. same genus name found in two different families)
%problems = (
#		'Asterales','1'
		);

open (FASTA, "<", $ARGV[0]) || die "Error can't open fasta file: $!\n";
@fasta = <FASTA>;
close FASTA;

open (TAX, "<", $ARGV[1]) || die "Error can't open taxonomy file: $!\n";
@tax = <TAX>;
close TAX;

# first parse id -> lineage taxonomy file
while ($tax[$i]) {
	$line = $tax[$i];
	chomp $line;

	@line = split(/\t/,$line);
	$acc = $line[0];
	$lineage = $line[1];

	# handle spaces
	if ($lineage =~ / /) {
		$lineage =~ s/ /_/g;
	}

	$tax{$acc} = $lineage;

	$i++;
}
$i=0;

# create reformatted outfile
open (OUT, ">>", "mytrainseq.fasta") || die "Error can't open outfile: $!\n";

# first reformat fasta file for training rdp classifier
while ($fasta[$i]) {
	$line = $fasta[$i];
	chomp $line;

	if ($line =~ /^>/) { #header
		$acc = $line;
		$acc =~ s/^>//g;

		if (exists $tax{$acc}) {
			$lineage = $tax{$acc};

			# parse through lineage to handle unidentified
			@lineage = split(/;/, $lineage);
			
			while ($lineage[$k]) {
				$taxon = $lineage[$k];

				# handle NA's
				if ($taxon =~ /^NA$/) {
					$taxon = $previoustaxon."_".$taxon; # append previous taxon as prefix
					$lineage[$k] = $taxon;
					$previoustaxon = $taxon; # only needed if next taxon is unidentified
				}

				# handle non-unique taxa (taxa of the same name found in more than one higher-level group, 
				# ex. same genus name in two different families)
				if (exists $problems{$taxon}) {
					$taxon = $previoustaxon."_".$taxon; #append previous taxon as prefix
					$lineage[$k] = $taxon;
					$previoustaxon = $taxon; # only needed if next taxon is unidentified
				}
				
				else {
					$previoustaxon = $taxon; #only needed if next taxon is unidentified
				}

				$k++;
			}
			$k=0;

			$newlineage = join ';', @lineage;
		
			print OUT ">$acc\tRoot;Viridiplantae;$newlineage\n";

			$mytrainseq = "$acc\tRoot;Viridiplantae;$newlineage";
			push @mytrainseq, $mytrainseq;

			$newlineage = "";
			$j = $i+1;
			$seq = $fasta[$j];
			chomp $seq;
			print OUT $seq."\n";
		}
		else {
			print "Couldn't find accession $acc in hash\n";
		}
	}
	$i++;
}
$i=0;
close OUT;
$j=0;

# create newly formatted taxonomy file
open (OUT2, ">>", "mytaxon.txt") || die "Can't open taxonomy outfile: $!\n";

# instead of parsing taxonomy file, parse the mytrainseq.fasta
open (TRAINSEQ, "<", "mytrainseq.fasta") || die "Can't open mytrainseq.fasta: $!\n";

# print out taxonomy file for classifier
while ($mytrainseq[$i]) {
	$line = $mytrainseq[$i];
	chomp $line;

	# add lineage (kingdom to species)
	@line = split(/\t/, $line);
	$acc = $line[0];
	$lineage = $line[1];
	@lineage = split(/;/,$lineage);

	while ($lineage[$j]) {
		$taxon = $lineage[$j];
		chomp $taxon;

		if (exists $rankname{$j} ) {

			$rankname = $rankname{$j};
			$rankindex = $j;

			# handle NAs
			if ($taxon =~ /^NA$/) {
				$taxon = $previoustaxon."_".$taxon; #append previous taxon as prefix
				$previoustaxon = $taxon; # only needed if next taxon is unidentified
			}

			# handle non-unique taxa (ex. same genus name in two different families)
			if (exists $problems{$taxon}) {
				$taxon = $previoustaxon."_".$taxon; #append previous taxon as prefix
				$previoustaxon = $taxon; # only needed if next taxon is unidentified
			}

			if (exists $taxon{$taxon} ) {
				$tmp = $taxon{$taxon}; 
				$previousindex = $tmp;
				$previoustaxon = $taxon; #only needed if next taxon is unidentified

			}
			else {
				print OUT2 $index."*".$taxon."*".$previousindex."*".$rankindex."*".$rankname."\n";
				$taxon{$taxon} = $index;
				$previousindex = $index;
				$index++;
				$previoustaxon = $taxon; #only needed if next taxon is unidentified

			}

		}
		else {
			print "Can't find index $j in rankname hash\n";
		}

		$j++;
	}
	$j=0;
	$index++;
	$i++;

}
$i=0;

close OUT2;
close TRAINSEQ;
