use strict;
use warnings;
use feature 'say';

use RDF::Trine;
use RDF::TrineX::Functions 'parse';
use RDF::DOAP;

my $doap = 'RDF::DOAP'->from_url('http://api.metacpan.org/source/TOBYINK/MooX-ClassAttribute-0.008/META.ttl');
my $proj = $doap->project;

say "==== MAINTAINERS ====";
say $_->to_string for $proj->gather_all_maintainers;

say "==== CONTRIBUTORS ====";
say $_->to_string for $proj->gather_all_contributors;

say "==== THANKS ====";
say $_->to_string for $proj->gather_all_thanks;
