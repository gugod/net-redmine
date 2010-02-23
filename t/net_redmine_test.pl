use Test::More;
use Cwd 'getcwd';

unless ($_ = $ENV{NET_REDMINE_RAILS_ROOT}) {
    plan skip_all => "Need SD_REDMINE_RAILS_ROOT env var";
    exit;
}

my $REDMINE_RAILS_ROOT = $ENV{NET_REDMINE_RAILS_ROOT};
my $REDMINE_SERVER_PID = undef;

END {
    system "kill -9 $REDMINE_SERVER_PID" if $REDMINE_SERVER_PID
}

sub net_redmine_test {
    return ("http://localhost:3000", "admin", "admin");
}

sub new_net_redmine {
    system "kill -9 $REDMINE_SERVER_PID" if $REDMINE_SERVER_PID;
    $REDMINE_SERVER_PID = undef;

    {
        my $cwd = getcwd;

        chdir $REDMINE_RAILS_ROOT;
        system q[echo en | rake log:clear db:drop db:create db:migrate redmine:load_default_data];
        system q[script/runner 'p = Project.create(:name => "test", :identifier => "test", :is_public => false); p.enabled_module_names = ["issue_tracking"]; p.set_parent!(nil); p.save'];
        system q[script/server -d];
        sleep 3;

        $REDMINE_SERVER_PID = `cat tmp/pids/server.pid`;
        print STDERR "Redmine Server started. PID ${REDMINE_SERVER_PID}\n";
        chdir $cwd;
    }

    my ($server, $user, $password) = net_redmine_test();
    return Net::Redmine->new(url => $server,user => $user, password => $password);
}

use Text::Greeking;

sub new_tickets {
    my ($r, $n) = @_;
    $n ||= 1;

    my $g = Text::Greeking->new;
    $g->paragraphs(1,1);
    $g->sentences(1,1);
    $g->words(8,24);

    my (undef, $filename, $line) = caller;

    return map {
        $r->create(
            ticket => {
                subject => "$filename, line $line " . $g->generate,
                description => $g->generate
            }
        );
    } (1..$n);
}

1;
