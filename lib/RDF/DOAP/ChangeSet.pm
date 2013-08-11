package RDF::DOAP::ChangeSet;

use Moose;
with qw(RDF::DOAP::Role::Resource);

use RDF::DOAP::ChangeSet;
use RDF::DOAP::Change;
use RDF::DOAP::Types -types;

use RDF::Trine::Namespace qw(rdf rdfs owl xsd);
my $doap = 'RDF::Trine::Namespace'->new('http://usefulinc.com/ns/doap#');
my $dc   = 'RDF::Trine::Namespace'->new('http://purl.org/dc/terms/');
my $dcs  = 'RDF::Trine::Namespace'->new('http://ontologi.es/doap-changeset#');

has items => (
	traits     => [ 'RDF::DOAP::Trait::WithURI' ],
	is         => 'ro',
	isa        => ArrayRef[Change],
	coerce     => 1,
	uri        => $dcs->item,
	multi      => 1,
);

1;
