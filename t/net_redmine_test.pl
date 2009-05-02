sub net_redmine_test {
    unless ($_ = $ENV{NET_REDMINE_TEST}) {
        plan skip_all => "Need NET_REDMINE_TEST env var";
        exit;
    }

    my ($server, $user, $password) = split / /;

    unless ($server && $user && $password) {
        plan skip_all => "No server and/or login credentials.";
        exit;
    }

    return ($server, $user, $password);
}

1;
