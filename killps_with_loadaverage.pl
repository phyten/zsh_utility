#!/usr/bin/perl

package KillpsWithLoadaverage;

use strict qw/vars subs/;
$|++;

use utf8;
use Moose;
use CGI::Carp qw(fatalsToBrowser);
use URI;
use Encode;
use Encode::Guess;
use URI::Escape;
# use DBI;
# use DBD::mysql;

has 'keywords' => (
		   is => 'rw',
		   isa => 'ArrayRef',
		   default => sub {['tashiro.pl', 'perl']}
);

our $VERSION = '0.0.1';

__PACKAGE__->meta->make_immutable;

no Moose;

sub killps {
  my $self = shift;
  my @keywords = @{$self->{keywords}};
  `kill -9 \`ps auxw | grep $keywords[0] | grep $keywords[1] | awk '{print \$2}' | perl -pe 's/\n/ /g'\``
}

sub loadaverage {
  my $self = shift;
  my $minute = shift || 15;
  my $result = "";
  if($minute eq "1"){
    $result = `cat /proc/loadavg | awk '{print \$1}'`;
  }elsif($minute eq "5"){
    $result = `cat /proc/loadavg | awk '{print \$2}'`;
  }elsif($minute eq "15"){
    $result = `cat /proc/loadavg | awk '{print \$3}'`;
  }else{
    print "you should choose number, 1, 5 or 15\n";
    $result = `cat /proc/loadavg | awk '{print \$3}'`;
  }
  return $result;
}

sub kwl {
  my $self = shift;
  my $minute = shift || 15;
  $self->killps_with_loadaverage(15);
}

sub killps_with_loadaverage {
  my $self = shift;
  my $minute = shift || 15;
  my $loadaverage = $self->loadaverage(15);
  printf ("loadaverage is %f\n", $loadaverage);
  if ($loadaverage > 80.0) {
    print "killing... wait a minute.";
    $self->killps;
  }
}


my $obj = KillpsWithLoadaverage->new;
print $obj->killps_with_loadaverage(15);
