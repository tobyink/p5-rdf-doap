use strict;
use warnings;

use RDF::Trine;
use RDF::TrineX::Functions 'parse';
use RDF::DOAP::Project;

my $model = parse(
	'http://ftp.heanet.ie/mirrors/gnome/sources/banshee/banshee.doap',
	as   => 'RDFXML',
	base => 'http://ftp.heanet.ie/mirrors/gnome/sources/banshee/banshee.doap',
);

my ($obj) = 'RDF::DOAP::Project'->rdf_load_all($model);

print $obj->dump_json;

