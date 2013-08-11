package RDF::DOAP::Project;

use Moose;
with qw(RDF::DOAP::Role::Resource);

use RDF::DOAP::Person;
use RDF::DOAP::Version;
use RDF::DOAP::Types -types;

use RDF::Trine::Namespace qw(rdf rdfs owl xsd);
my $doap = 'RDF::Trine::Namespace'->new('http://usefulinc.com/ns/doap#');

has $_ => (
	traits     => [ 'RDF::DOAP::Trait::WithURI' ],
	is         => 'ro',
	isa        => String,
	coerce     => 1,
	uri        => $doap->$_,
) for qw(name shortdesc);

has release => (
	traits     => [ 'RDF::DOAP::Trait::WithURI' ],
	is         => 'ro',
	isa        => ArrayRef[Version],
	coerce     => 1,
	uri        => $doap->release,
	multi      => 1,
);

has $_ => (
	traits     => [ 'RDF::DOAP::Trait::WithURI' ],
	is         => 'ro',
	isa        => ArrayRef[Person],
	coerce     => 1,
	multi      => 1,
	uri        => $doap->$_,
	gather_as  => ['maintainer'],
) for qw( maintainer );

has $_ => (
	traits     => [ 'RDF::DOAP::Trait::WithURI' ],
	is         => 'ro',
	isa        => ArrayRef[Person],
	coerce     => 1,
	multi      => 1,
	uri        => $doap->$_,
	gather_as  => ['contributor'],
) for qw( developer documenter );

has $_ => (
	traits     => [ 'RDF::DOAP::Trait::WithURI' ],
	is         => 'ro',
	isa        => ArrayRef[Person],
	coerce     => 1,
	multi      => 1,
	uri        => $doap->$_,
	gather_as  => ['thanks'],
) for qw( translator tester helper );

sub gather_all_maintainers
{
	require RDF::DOAP::Utils;
	my $self = shift;
	RDF::DOAP::Utils::gather_objects($self, 'maintainer');
}

sub gather_all_contributors
{
	require RDF::DOAP::Utils;
	my $self = shift;
	RDF::DOAP::Utils::gather_objects($self, 'contributor');
}

sub gather_all_thanks
{
	require RDF::DOAP::Utils;
	my $self = shift;
	RDF::DOAP::Utils::gather_objects($self, 'thanks');
}

sub sorted_releases
{
	my $self = shift;
	my @rels = sort {
		   ($a->revision  and $b->revision  and version->parse($a->revision) cmp version->parse($b->revision))
		or ($a->issued    and $b->issued    and $a->issued cmp $b->issued)
		or ($a->rdf_about and $b->rdf_about and $a->rdf_about->as_ntriples cmp $b->rdf_about->as_ntriples)
	} @{$self->release};	
	return \@rels;
}

sub changelog
{
	my $self = shift;
	
	return join "\n",
		$self->_changelog_header,
		map($_->changelog_section, reverse @{ $self->sorted_releases });
}

sub _changelog_header
{
	my $self = shift;
	return $self->name . "\n";
}

1;
