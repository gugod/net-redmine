package Net::Redmine::Search;
use Any::Moose;
use pQuery;

has connection => (
    is => "rw",
    isa => "Net::Redmine::Connection",
    required => 0
);

has query => (is => "rw", isa => "Str", required => 1);
has type => (is => "rw", isa => "ArrayRef", required => 1);

sub results {
    my $self = shift;
    my $mech = $self->connection->get_project_overview->mechanize;
    $mech->form_number(1);
    $mech->field(q => $self->query);
    $mech->submit;

    die "Failed on search page" unless $mech->response->is_success;

    my @r = ();
    pQuery($mech->content)->find("#search-results .issue a")->each(
        sub {
            my $issue_url = $_->getAttribute("href") or return;
            if (my ($issue_id) = $issue_url =~ m[/issues/(\d+)$]) {
                push @r, Net::Redmine::Ticket->new(connection => $self->connection, id => $issue_id);
            }
        }
    );
    return wantarray ? @r : \@r;
}

__PACKAGE__->meta->make_immutable;
no Any::Moose;
1;
