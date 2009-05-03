package Net::Redmine::TicketHistory;
use Any::Moose;

has connection => (
    is => "rw",
    isa => "Net::Redmine::Connection",
    required => 1
);

has id               => (is => "rw", isa => "Int", required => 1);
has ticket_id        => (is => "rw", isa => "Int", required => 1);
has note             => (is => "rw", isa => "Str", lazy_build => 1);
has property_changes => (is => "rw", isa => "HashRef", lazy_build => 1);

has _ticket_page_html => (is => "rw", isa => "Str", lazy_build => 1);

use pQuery;

sub _build__ticket_page_html {
    my ($self) = @_;
    my $mech = $self->connection->get_issues_page($self->ticket_id)->mechanize;
    return $mech->content;
}

sub _build_property_changes {
    my ($self) = @_;
    my $p = pQuery($self->_ticket_page_html);

    my $property_changes = {};

    $p->find(".journal")->eq($self->id - 1)->find("ul:eq(0) li")->each(
        sub {
            my $li = pQuery($_);

            my $name = lc( $li->find("strong")->text );
            my $from = $li->find("i")->eq(0)->text;
            my $to   = $li->find("i")->eq(1)->text;

            $property_changes->{$name} = {from => $from, to => $to};
        }
    );

    return $property_changes;
}

use HTML::WikiConverter;
use Encode;

sub _build_note {
    my ($self) = @_;

    my $p = pQuery($self->_ticket_page_html);

    my $note_html = $p->find(".journal")->eq($self->id - 1)->find(".wiki")->html;

    my $wc = HTML::WikiConverter->new(dialect => "Markdown");
    my $note_text = $wc->html2wiki( Encode::encode_utf8($note_html) );

    return $note_text;
}

__PACKAGE__->meta->make_immutable;
no Any::Moose;
1;
