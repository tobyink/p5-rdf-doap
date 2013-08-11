package RDF::DOAP::Issue;

use Moose;
with qw(RDF::DOAP::Role::Resource);

use RDF::DOAP::Types -types;

use RDF::Trine::Namespace qw(rdf rdfs owl xsd);
my $dbug  = 'RDF::Trine::Namespace'->new('http://ontologi.es/doap-bugs#');

has reporter => (
	traits     => [ 'RDF::DOAP::Trait::WithURI' ],
	is         => 'ro',
	isa        => ArrayRef[ Person ],
	coerce     => 1,
	uri        => $dbug->reporter,
	multi      => 1,
	gather_as  => ['thanks'],
);

has assignee => (
	traits     => [ 'RDF::DOAP::Trait::WithURI' ],
	is         => 'ro',
	isa        => ArrayRef[ Person ],
	coerce     => 1,
	uri        => $dbug->assignee,
	multi      => 1,
	gather_as  => ['contributor'],
);

has id => (
	traits     => [ 'RDF::DOAP::Trait::WithURI' ],
	is         => 'ro',
	isa        => String,
	coerce     => 1,
	uri        => $dbug->id,
);

has $_ => (
	traits     => [ 'RDF::DOAP::Trait::WithURI' ],
	is         => 'ro',
	isa        => Identifier,
	coerce     => 1,
	uri        => $dbug->$_,
) for qw( severity status );

has page => (
	traits     => [ 'RDF::DOAP::Trait::WithURI' ],
	is         => 'ro',
	isa        => Identifier,
	coerce     => 1,
	uri        => $dbug->page,
);

1;
