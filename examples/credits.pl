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

say "==== MAINTAINERS ====";
print $_->dump_json for $obj->gather_all_maintainers;

say "==== CONTRIBUTORS ====";
print $_->dump_json for $obj->gather_all_contributors;

say "==== THANKS ====";
print $_->dump_json for $obj->gather_all_thanks;
