use strict;
use warnings;
use feature 'say';

use RDF::Trine;
use RDF::TrineX::Functions 'parse';
use RDF::DOAP;

my $model = parse(
	'http://api.metacpan.org/source/TOBYINK/MooX-ClassAttribute-0.008/META.ttl',
	as   => 'Turtle',
	base => 'http://api.metacpan.org/source/TOBYINK/MooX-ClassAttribute-0.008/META.ttl',
);

my $obj = 'RDF::DOAP'->from_model($model)->project;

say "==== MAINTAINERS ====";
say $_->to_string for $obj->gather_all_maintainers;

say "==== CONTRIBUTORS ====";
say $_->to_string for $obj->gather_all_contributors;

say "==== THANKS ====";
say $_->to_string for $obj->gather_all_thanks;
