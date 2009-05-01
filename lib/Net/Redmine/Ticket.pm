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

use WWW::Mechanize;

sub create {
    my ($self, %attr) = @_;

    if (%attr) {
        while (my ($k, $v) = each(%attr)) {
            $self->$k($v);
        }
    }

    my $mech = WWW::Mechanize->new;
    $mech->get($self->connection->url);

    if ($mech->uri =~ /\/login/) {
        $mech->submit_form(
            form_number => 2,
            fields => {
                username => $self->connection->user,
                password => $self->connection->password
            }
        );

        if ($mech->uri ne $self->connection->url) {
            $mech->get($self->connection->url);
        }
    }
    
    $mech->follow_link( url_regex => qr[/issues/new$] );
    
    $mech->form_id("issue-form");
    $mech->field("issue[subject]", $self->subject);
    $mech->field("issue[description]", $self->description);
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


__PACKAGE__->meta->make_immutable;
no Any::Moose;
1;

__END__

=head1 NAME

Net::Redmine::Ticket - Represents a ticket.

=head1 SYNOPSIS



=head1 DESCRIPTION



=cut

