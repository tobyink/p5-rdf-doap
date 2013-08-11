use strict;
use warnings;

use RDF::Trine;
use RDF::TrineX::Functions 'parse';
use RDF::DOAP::Project;

my $model = parse(
	'http://api.metacpan.org/source/DOY/Moose-2.0604/doap.rdf',
	as   => 'RDFXML',
	base => 'http://api.metacpan.org/source/DOY/Moose-2.0604/doap.rdf',
);

my ($obj) = 'RDF::DOAP::Project'->rdf_load_all($model);

print $obj->dump_json;

