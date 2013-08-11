package RDF::DOAP::Utils;

use strict;
use warnings;

use RDF::DOAP::Types -types;
use match::simple 'match';
use List::MoreUtils 'uniq';

our %seen;

sub _gather_objects
{
	my ($self, $relation) = @_;
	return if $seen{$self}++;
	
	if (ArrayRef->check($self))
	{
		return uniq(
			map _gather_objects($_, $relation), @$self
		);
	}
	
	if (Object->check($self))
	{
		return unless $self->isa('Moose::Object');
		
		my @local =
			grep defined,
			map ArrayRef->check($_) ? @$_ : $_,
			map $_->get_value($self),
			grep $_->can('gather_as') && match($relation, $_->gather_as),
			$self->meta->get_all_attributes;
		
		my @recursive =
			grep defined,
			map _gather_objects($_, $relation),
			grep defined,
			map $_->get_value($self),
			grep !($_->can('gather_as') && match($relation, $_->gather_as)),
			$self->meta->get_all_attributes;
		
		return uniq(@local, @recursive);
	}
}

sub gather_objects
{
	local %seen;
	grep defined, _gather_objects(@_);
}

1;
