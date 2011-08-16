package test::Bird;

use strict;
use warnings;
use utf8;
use base qw(Test::Class);
use Test::More;

use Bird;
use Tweet;

sub init : Test(1) {
    new_ok 'Bird'
}

sub tweet : Tests {
    my $bird = Bird->new(name => 'pokutuna');
    my $tweet = $bird->tweet('some message');

    is_deeply $tweet->bird, $bird;
    is $tweet->body, 'some message';
    is $tweet->message, 'pokutuna: some message';
}

sub bird_single : Tests {
    my $bird = Bird->new(name => 'pokutuna');
    is $bird->name, 'pokutuna';
    is_deeply $bird->followers, [];
    is_deeply $bird->following, [];
    is_deeply $bird->friends_timeline, [];
    is_deeply $bird->tweets, [];

    my $tweet = $bird->tweet("hoge");
    is_deeply $bird->tweets->[0], $tweet;
}

sub follow : Tests {
    my $pokutuna = Bird->new(name => 'pokutuna');
    my $sister = Bird->new(name => 'oneetyan');
    $pokutuna->follow($sister);

    is_deeply $pokutuna->following->[0], $sister;
    is_deeply $sister->followers->[0], $pokutuna;
    is_deeply $pokutuna->followers, [];
}

sub timeline : Tests {
    my $pokutuna = Bird->new(name => 'pokutuna');
    my $sister = Bird->new(name => 'oneetyan');
    $pokutuna->follow($sister);

    my $t = $pokutuna->tweet('ひとりごとです');
    is_deeply $sister->friends_timeline, [];
    is_deeply $pokutuna->tweets->[0], $t;

    $t = $sister->tweet('お姉ちゃんです');
    is_deeply $sister->friends_timeline, [];
    is_deeply $pokutuna->friends_timeline->[0], $t;

    my $t2 = $sister->tweet('お姉ちゃんです2');
    is_deeply $pokutuna->friends_timeline->[0], $t2;
    is_deeply $pokutuna->friends_timeline->[1], $t;
    is_deeply $sister->tweets->[0], $t2;
    is_deeply $sister->tweets->[1], $t;
}

sub sample : Tests {
    my $b1 = Bird->new( name => 'jkondo');
    my $b2 = Bird->new( name => 'reikon');
    my $b3 = Bird->new( name => 'onishi');

    $b1->follow($b2);
    $b1->follow($b3);
    $b3->follow($b1);
    $b1->tweet('きょうはあついですね！');
    $b2->tweet('しなもんのお散歩中です');
    $b3->tweet('烏丸御池なう！');

    my $b1_timelines = $b1->friends_timeline;
    is $b1_timelines->[0]->message, 'onishi: 烏丸御池なう！';
    is $b1_timelines->[1]->message, 'reikon: しなもんのお散歩中です';

    my $b3_timelines = $b3->friends_timeline;
    is $b3_timelines->[0]->message, 'jkondo: きょうはあついですね！';
    #PDFのサンプルコード、今日ときょう、!と！が混じってたりする
}

__PACKAGE__->runtests;

1;
