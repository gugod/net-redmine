package Net::Redmine::Ticket;
use Any::Moose;

has connection => (
    is => "rw",
    isa => "Net::Redmine::Connection",
    required => 1
);

has id          => (is => "rw", isa => "Num");
has subject     => (is => "rw", isa => "Str");
has description => (is => "rw", isa => "Str");
has status      => (is => "rw", isa => "Str");
has priority    => (is => "rw", isa => "Str");

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
        return undef;
    }

    if ($mech->uri =~ m[/issues/show/(\d+)$]) {
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

    unless ($mech->response->is_success) {
        die "Failed to create a new ticket\n";
    }

    my $html = $mech->content;

    # my $html = io("/tmp/issue.html")->utf8->all;

    my $p = pQuery($html);

    my $wc = new HTML::WikiConverter( dialect => 'Markdown' );

    my $description = $wc->html2wiki( Encode::encode_utf8($p->find(".issue .wiki")->html) );

    my $subject = $p->find(".issue h3")->text;

    $self->id($id);
    $self->subject($subject);
    $self->description($description);

    return $self;
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

