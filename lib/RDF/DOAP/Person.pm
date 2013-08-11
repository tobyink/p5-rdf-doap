package RDF::DOAP::Person;

use Moose;
with qw(RDF::DOAP::Role::Resource);

use RDF::DOAP::Types -types;

use RDF::Trine::Namespace qw(rdf rdfs owl xsd);
my $foaf = 'RDF::Trine::Namespace'->new('http://xmlns.com/foaf/0.1/');

has $_ => (
	traits     => [ 'RDF::DOAP::Trait::WithURI' ],
	is         => 'ro',
	isa        => String,
	coerce     => 1,
	uri        => $foaf->$_,
) for qw( name nick );

has mbox => (
	traits     => [ 'RDF::DOAP::Trait::WithURI' ],
	is         => 'ro',
	isa        => ArrayRef[Identifier],
	coerce     => 1,
	uri        => $foaf->mbox,
	multi      => 1,
);

has cpanid => (
	is         => 'ro',
	isa        => Str,
	lazy       => 1,
	builder    => '_build_cpanid',
);

sub _build_cpanid
{
	my $self = shift;
	return unless $self->has_rdf_about;
	$self->rdf_about =~ m{^http://purl\.org/NET/cpan-uri/person/(\w+)$}
		and return $1;
	return;
}

sub to_string
{
	my $self = shift;
	
	return $self->name
		|| $self->nick
		|| $self->cpanid
		|| ($self->mbox && $self->mbox->[0]->uri)
		|| ($self->rdf_about && $self->rdf_about->uri)
		|| 'Anonymous'
		if $_[0] eq 'compact';
	return "$self";
}

1;
