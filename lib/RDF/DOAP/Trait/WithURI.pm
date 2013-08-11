package RDF::DOAP::Trait::WithURI;

use Moose::Role;
use Types::Standard -types;
use RDF::DOAP::Types -types;

has uri => (
	is         => 'ro',
	isa        => Identifier,
	coerce     => 1,
);

has multi => (
	is         => 'ro',
	isa        => Bool,
	default    => 0,
);

has gather_as => (
	is         => 'ro',
	isa        => ArrayRef[Str],
	default    => sub { [] },
);

1;
