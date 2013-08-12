package RDF::DOAP;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = 0.001;

use Moose;

use RDF::DOAP::Types -types;
use RDF::DOAP::Resource ();
use RDF::DOAP::Project ();
use RDF::DOAP::Repository ();
use RDF::DOAP::Person ();
use RDF::DOAP::Version ();
use RDF::DOAP::ChangeSet ();
use RDF::DOAP::Change ();
use RDF::DOAP::Issue ();

use RDF::Trine::Namespace qw(rdf rdfs owl xsd);
my $doap = 'RDF::Trine::Namespace'->new('http://usefulinc.com/ns/doap#');

has projects => (
	is         => 'ro',
	isa        => ArrayRef[Project],
	default    => sub { [] },
	coerce     => 1,
);

sub from_url
{
	require RDF::Trine;
	
	my $class = shift;
	my ($url) = @_;
	
	my $model = 'RDF::Trine::Model'->new;
	'RDF::Trine::Parser'->parse_url_into_model("$url", $model);
	
	return $class->from_model($model);
}

sub from_file
{
	require RDF::Trine;
	
	my $class = shift;
	my ($fh, $base) = @_;
	$base //= 'http://localhost/';
	
	my $model = 'RDF::Trine::Model'->new;
	'RDF::Trine::Parser'->parse_file_into_model($base, $fh, $model);
	
	return $class->from_model($model);
}

sub from_model
{
	my $class = shift;
	my ($model) = @_;
	
	# required for coercion to work!
	local $RDF::DOAP::Resource::MODEL = $model;
	
	$class->new(
		projects => [ $model->subjects($rdf->type, $doap->Project) ],
	);
}

sub project
{
	my $self = shift;
	
	my @projects = @{$self->projects};
	return $projects[0] if @projects <= 1;
	
	my @sorted = 
		map $_->[0],
		sort { $b->[1] <=> $a->[1] }
		map [
			$_,
			$_->has_rdf_model && $_->has_rdf_about
				? $_->rdf_model->count_statements($_->rdf_about, undef, undef)
				: 0
		], @projects;
	
	return $sorted[0];
}

1;

