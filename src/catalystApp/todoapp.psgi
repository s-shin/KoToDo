use strict;
use warnings;

use todoApp;

my $app = todoApp->apply_default_middlewares(todoApp->psgi_app);
$app;

