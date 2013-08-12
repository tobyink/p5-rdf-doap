package RDF::DOAP::Person;

use Moose;
extends qw(RDF::DOAP::Resource);

use RDF::DOAP::Types -types;
use RDF::DOAP::Utils -traits;

use RDF::Trine::Namespace qw(rdf rdfs owl xsd);
my $foaf = 'RDF::Trine::Namespace'->new('http://xmlns.com/foaf/0.1/');

has $_ => (
	traits     => [ WithURI ],
	is         => 'ro',
	isa        => String,
	coerce     => 1,
	uri        => $foaf->$_,
) for qw( name nick );

has mbox => (
	traits     => [ WithURI ],
	is         => 'ro',
	isa        => ArrayRef[Identifier],
	coerce     => 1,
	uri        => $foaf->mbox,
	multi      => 1,
);

has cpanid => (
	is         => 'ro',
	isa        => Maybe[Str],
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
		if @_ && $_[0] eq 'compact';
	
	my @parts;
	if ($self->name)
	{
		push @parts, $self->name;
		if ($self->cpanid)
		{
			push @parts, sprintf('(cpan:%s)', uc $self->cpanid);
		}
	}
	else
	{
		my $nick = uc($self->nick) || uc($self->cpanid);
		push @parts, $nick if $nick;
	}
	
	for my $mbox (@{$self->mbox || []})
	{
		if ($mbox and $mbox->uri =~ /^mailto:(.+)$/)
		{
			push @parts, "<$1>";
			last;
		}
	}
	
	for my $mbox (@{$self->mbox || []})
	{
		push @parts, $mbox if !@parts;
	}
	
	push @parts, $self->rdf_about if !@parts && $self->has_rdf_about;
	
	join(" ", grep !!$_, @parts) or 'Anonymous';
}

1;
