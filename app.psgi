use FindBin;
use lib "$FindBin::Bin/extlib/lib/perl5";
use lib "$FindBin::Bin/lib";
use File::Basename;
use Plack::MIME;
use Plack::Builder;
use KoToDo::Web;

# 静的ファイルのMIMEの追加
Plack::MIME->add_type('.ttf' => 'application/x-font-ttf');
Plack::MIME->add_type('.woff' => 'application/font-woff');

my $root_dir = File::Basename::dirname(__FILE__);

my $app = KoToDo::Web->psgi($root_dir);
builder {
    enable 'ReverseProxy';
    enable 'Static',
        path => qr!^/(?:(?:css|js|img)/|favicon\.ico$)!,
        root => $root_dir . '/public';
    $app;
};

