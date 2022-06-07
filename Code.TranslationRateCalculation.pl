#!/usr/bin/perl -w  
use strict;
my $path="./";
#**********************************************************************************************
##***************************************************
#*****************************
open IN1,"$path/Input_Expression1.txt";
open OUT1,"> $path/Output_TranslationRate1.txt";
my %value=();
my %indexToSample=();
my %SampleCount_zeroValue=();
foreach (<IN1>) {
  chomp;
  my @a=split/\t/;
  my $out="$a[4]\t$a[5]\t$a[6]";
  my $transcript=$a[4];
  if (/TranscriptId/) {
    foreach (7..$#a) { $indexToSample{$_}=$a[$_]; $a[$_]=~s/RFP\.//; $out="$out\t$a[$_]" if $_ <=30;}
    print OUT1 "$out\n";
    next;
  }
  ##
  my $sampleCount=0;
  foreach (7..$#a) { $value{$out}{$indexToSample{$_}}=$a[$_]; $sampleCount++ if $a[$_]==0;}
  $SampleCount_zeroValue{$out}=$sampleCount;
}close IN1;


my $transCount_all=0;
my $transCount_used=0;
foreach my $tempId (sort keys %value) {
  my $out=$tempId;
  my $sampleCount=0;
  $transCount_all++;
  foreach (sort {$a<=>$b} keys %indexToSample) {
    my $sample_RFP=$indexToSample{$_};
    last if $sample_RFP=~/^RNA/;
    my $sample_RNA=$sample_RFP;
    $sample_RNA=~s/RFP/RNA/;

    if (!exists($value{$tempId}{$sample_RFP})) {print "error#1 the value of $tempId from sample $sample_RFP is not exists\n";$value{$tempId}{$sample_RFP}=0;}
    elsif (!exists($value{$tempId}{$sample_RNA})) {print "error#2 the value of $tempId from sample $sample_RNA is not exists\n";$value{$tempId}{$sample_RNA}=0;}
    else {}

    my $value_RFP=$value{$tempId}{$sample_RFP};
    my $value_RNA=$value{$tempId}{$sample_RNA};
    my $ratio=($value_RFP+0.1)/($value_RNA+0.1);
    if ($ratio>1) { $sampleCount++;}
    $out=$out."\t$ratio";
  }
  print OUT1 "$out\n";
}
