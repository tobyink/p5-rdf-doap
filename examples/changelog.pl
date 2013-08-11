use strict;
use warnings;
use feature 'say';

use RDF::Trine;
use RDF::TrineX::Functions 'parse';
use RDF::DOAP::Project;

my $model = parse(
	'http://api.metacpan.org/source/TOBYINK/MooX-ClassAttribute-0.008/META.ttl',
	as   => 'Turtle',
	base => 'http://api.metacpan.org/source/TOBYINK/MooX-ClassAttribute-0.008/META.ttl',
);

my $obj = 'RDF::DOAP::Project'->rdf_load(
	'http://purl.org/NET/cpan-uri/dist/MooX-ClassAttribute/project',
	$model,
);

print $obj->changelog;
