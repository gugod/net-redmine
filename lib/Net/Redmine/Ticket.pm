package Net::Redmine::Ticket;
use Any::Moose;

has connection => (
    is => "rw",
    isa => "Net::Redmine::Connection",
    required => 1
);

has id          => (is => "rw", isa => "Int");
has subject     => (is => "rw", isa => "Str");
has description => (is => "rw", isa => "Str");
has status      => (is => "rw", isa => "Str");
has priority    => (is => "rw", isa => "Str");

has note        => (is => "rw", isa => "Str");
has histories   => (is => "rw", isa => "ArrayRef", lazy_build => 1);

sub create {
    my ($self, %attr) = @_;

    if (%attr) {
        while (my ($k, $v) = each(%attr)) {
            $self->$k($v);
        }
    }

    my $mech = $self->connection->get_project_overview->mechanize;

    $mech->follow_link( url_regex => qr[/issues/new$] );

    $mech->form_id("issue-form");
    $mech->field("issue[subject]" => $self->subject);
    $mech->field("issue[description]" => $self->description);
    $mech->submit;

    unless ($mech->response->is_success) {
        die "Failed to create a new ticket\n";
    }

    if ($mech->uri =~ m[/issues(?:/show)?/(\d+)$]) {
        my $id = $1;
        $self->id($id);
        return $id;
    }
}

# use IO::All;
use pQuery;
use HTML::WikiConverter;
use Encode;

sub load {
    my ($self, $id) = @_;

    my $mech = $self->connection->get_project_overview->mechanize;
    $mech->submit_form(
        form_number => 1,
        fields => {
            q => "#" . $id
        }
    );

    die "Failed to load the ticket with id $id\n" unless $mech->response->is_success;
    unless ($mech->uri =~ m[/issues/\d+$]) {
        return undef;
    }

    my $html = $mech->content;

    # my $html = io("/tmp/issue.html")->utf8->all;

    my $p = pQuery($html);

    my $wc = new HTML::WikiConverter( dialect => 'Markdown' );

    my $description = $wc->html2wiki( Encode::encode_utf8($p->find(".issue .wiki")->html) );

    my $subject = $p->find(".issue h3")->text;

    my $status = $p->find(".issue .status")->eq(1)->text;

    $self->id($id);
    $self->subject($subject);
    $self->description($description);
    $self->status($status);

    return $self;
}

sub save {
    my ($self) = @_;
    die "Cannot save a ticket without id.\n" unless $self->id;

    my $mech = $self->connection->get_issues($self->id)->mechanize;
    $mech->follow_link( url_regex => qr[/issues/\d+/edit$] );

    $mech->form_id("issue-form");
    $mech->set_fields(
        'issue[status_id]' => $self->status,
        'issue[description]' => $self->description,
        'issue[subject]' => $self->subject
    );

    if ($self->note) {
        $mech->set_fields(notes => $self->note);
    }

    $mech->submit;
    die "Ticket save failed (ticket id = @{[ $self->id ]})\n"
        unless $mech->response->is_success;

    return $self;
}

sub delete {
    my ($self) = @_;
    die "Cannot delete the ticket without id.\n" unless $self->id;

    my $id = $self->id;
    my $mech = $self->connection->get_issues($id)->mechanize;
    my $link = $mech->find_link(url_regex => qr[/issues/${id}/destroy$]);

    $mech->post($link->url_abs());

    die "Cannot delete the ticket\n" unless $mech->response->is_success;

    $self->id(-1);
    return $self;
}

sub _build_histories {
    my ($self) = @_;
    die "Cannot lookup ticket histories without id.\n" unless $self->id;
    my $mech = $self->connection->get_issues($self->id)->mechanize;

    my $p = pQuery($mech->content);

    my $n = $p->find(".journal")->size;

    return [
        map {
            Net::Redmine::TicketHistory->new(
                connection => $self->connection,
                id => $_,
                ticket_id => $self->id
            )
        } (1..$n)
    ];
}

__PACKAGE__->meta->make_immutable;
no Any::Moose;
1;

__END__

=head1 NAME

Net::Redmine::Ticket - Represents a ticket.

=head1 SYNOPSIS



=head1 DESCRIPTION



=cut
