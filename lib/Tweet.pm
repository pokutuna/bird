package Tweet;

use strict;
use warnings;
use base qw(Class::Accessor);

__PACKAGE__->mk_accessors(qw/bird body/);

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    $self->_init(@_);
    return $self;
}

sub _init {
    my ($self, $bird, $body) = @_;
    $self->bird($bird);
    $self->body($body);
    $self->send_tweet;
}

sub message {
    my $self = shift;
    my ($name, $msg) = ($self->bird->name, $self->body);
    return "$name: $msg";
}

sub send_tweet {
    my $self = shift;
    #$self->bird->receive_tweet($self); don't need send tweet to self timeline'
    foreach my $follower (@{$self->bird->followers}) {
        $follower->receive_tweet($self);
    }
}

1;
