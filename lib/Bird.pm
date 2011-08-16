package Bird;

use strict;
use warnings;
use base qw(Class::Accessor);

use Tweet;

__PACKAGE__->mk_accessors(qw/name following followers tweets friends_timeline/);

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    $self->_init(@_);
    return $self;
}

sub _init {
    my ($self, %hash) = @_;
    $self->name($hash{name});
    $self->tweets([]);
    $self->following([]);
    $self->followers([]);
    $self->friends_timeline([]);
}

sub follow {
    my ($self, $user) = @_;
    unshift(@{$self->following}, $user);
    unshift(@{$user->followers}, $self)
}

sub tweet {
    my ($self, $msg) = @_;
    my $t = Tweet->new($self, $msg);
    unshift(@{$self->tweets}, $t);
    return $t;
}

sub receive_tweet {
    my ($self, $tweet) = @_;
    unshift(@{$self->friends_timeline}, $tweet);
}

1;
