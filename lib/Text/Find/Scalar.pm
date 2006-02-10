package Text::Find::Scalar;

use 5.006001;
use strict;
use warnings;
use Data::Dumper;

our $VERSION = '0.01';

sub new{
  my ($class) = @_;
  
  my $self = {};
  bless $self,$class;
  
  $self->_Counter(0);
  
  return $self;
}# new

sub find{
  my ($self,$text) = @_;
  my @array = ();
  $self->_Counter(0);
  if(defined $text){
    $text =~ s,<<'(.*?)'.*?\n\1,,sg;
    $text =~ s,'.*?',,sg;
    $text =~ s,q~.*?~,,sg;
    @array = $text =~ m/(?:(\$\w+(?:->)?(?:\[\$?\w+\]|{\$?\w+}))|(\${\w+})|(\$\w+))/sg;
    @array = grep{defined}@array;
  }
  $self->_Elements(@array);
  return $self->_Elements();
}# find

sub unique{
  my ($self) = @_;
  my %seen;
  my @unique = grep{!$seen{$_++}}@{$self->_Elements()};
  return \@unique;
}# unique

sub count{
  my ($self,$name) = @_;
  my %counter;
  $counter{$_}++ for(@{$self->_Elements()});
  return $counter{$name};
}# count

sub hasNext{
  my ($self) = @_;
  my $count = $self->_Counter();
  if($count > scalar(@{$self->_Elements()}) - 1){
    return 0;
  }  
  return 1;
}# hasNext

sub nextElement{
  my ($self)  = @_;
  my $count   = $self->_Counter();
  my $all     = $self->_Elements();
  my $element = undef;
  if($count < scalar(@$all)){
    $element = ${$all}[$count];
  }
  $self->_Counter(++$count);
  return $element;
}# nextElement

sub _Counter{
  my ($self,$count) = @_;
  $self->{Counter} = $count if(defined $count);
  return $self->{Counter};
}# _Counter

sub _Elements{
  my ($self,@elements) = @_;
  $self->{Elements} = [@elements] if(scalar(@elements) > 0);
  return $self->{Elements};
}# _Elements

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Text::Find::Variable - Find scalar names in a text.

=head1 SYNOPSIS

  use Text::Find::Variable;
  
  my $finder = Text::Find::Variable->new();
  my $arrayref = $finder->find($string);
  
  # or
  
  $finder->find($string);
  while($finder->hasNext()){
    print $finder->nextElement();
  }

=head1 DESCRIPTION

This Class helps to find all Scalar variables in a text. It is recommended to
use L<PPI> to parse Perl programs. This module should help to find SCALAR names
e.g. in Error messages.

=head1 METHODS

=head2 new

  my $finder = Text::Find::Scalar->new();

=head2 find

  my $string = q~Test $test $foo '$bar'~;
  my $arrayref = $finder->find($string);

=head2 hasNext

  while($finder->hasNext()){
    print $finder->nextElement();
  }

=head2 nextElement

  print $finder->nextElement();
  print $finder->nextElement();

=head2 unique

  my $uniquenames = $finder->unique();

=head2 count

  my $counter = $finder->count('$foo');

=head1 AUTHOR

Renee Baecker, E<lt>module@renee-baecker.deE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Renee Baecker

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.


=cut
