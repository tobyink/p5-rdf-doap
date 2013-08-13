package RDF::DOAP::Version;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = 0.004;

use Moose;
extends qw(RDF::DOAP::Resource);

use RDF::DOAP::ChangeSet;
use RDF::DOAP::Change;
use RDF::DOAP::Person;
use RDF::DOAP::Types -types;
use RDF::DOAP::Utils -traits;

use RDF::Trine::Namespace qw(rdf rdfs owl xsd);
my $doap = 'RDF::Trine::Namespace'->new('http://usefulinc.com/ns/doap#');
my $dc   = 'RDF::Trine::Namespace'->new('http://purl.org/dc/terms/');
my $dcs  = 'RDF::Trine::Namespace'->new('http://ontologi.es/doap-changeset#');

has $_ => (
	traits     => [ WithURI ],
	is         => 'ro',
	isa        => String,
	coerce     => 1,
	uri        => $doap->$_,
) for qw( revision name branch );

has issued => (
	traits     => [ WithURI ],
	is         => 'ro',
	isa        => String,
	coerce     => 1,
	uri        => $dc->issued,
);

has changesets => (
	traits     => [ WithURI ],
	is         => 'ro',
	isa        => ArrayRef[ChangeSet],
	coerce     => 1,
	uri        => $dcs->changeset,
	multi      => 1,
);

has changes => (
	is         => 'ro',
	isa        => ArrayRef[Change],
	coerce     => 1,
	lazy       => 1,
	builder    => '_build_changes',
);

has released_by => (
	traits     => [ WithURI, Gathering ],
	is         => 'ro',
	isa        => Person,
	coerce     => 1,
	uri        => $dcs->uri('released-by'),
	gather_as  => ['maintainer'],
);

sub _build_changes
{
	my $self = shift;
	[ map { @{$_->items} } @{$self->changesets || []} ];
}

sub changelog_section
{
	my $self = shift;
	
	return join(
		"\n",
		$self->_changelog_section_header,
		sort map $_->changelog_entry, @{$self->changes},
	)."\n";
}

sub _changelog_section_header
{
	my $self = shift;
	return join(
		"\t",
		grep(
			defined,
			$self->revision,
			($self->issued // 'Unknown'),
			($self->name // $self->label),
		),
	) . "\n";
}

1;
