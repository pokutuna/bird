use strict;
use warnings;

BEGIN {
    unshift @INC, "lib"; #なんかhackっぽい、こうじゃない普通な方法ってなんでしょうか
}

use Bird;

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
print $b1_timelines->[0]->message, "\n"; # 'onishi: 烏丸御池なう！'
print $b1_timelines->[1]->message, "\n"; # 'reikon: しなもんのお散歩中です'

my $b3_timelines = $b3->friends_timeline;
print $b3_timelines->[0]->message, "\n"; # 'jkondo: きょうはあついですね！'
