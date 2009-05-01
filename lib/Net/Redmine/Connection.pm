package Net::Redmine::Connection;
use Any::Moose;

has url      => ( is => "rw", isa => "Str", required => 1 );
has user     => ( is => "rw", isa => "Str", required => 1 );
has password => ( is => "rw", isa => "Str", required => 1 );

1;

__END__

=head1 NAME

Net::Redmine::Connection

=head1 SYNOPSIS

    # Initialize a redmien connection object
    my $redmine = Net::Redmine::Connection->new(
        url => 'http://redmine.example.com/projects/show/fooproject'
        user => 'hiro',
        password => 'yatta'
    );

    # Passed it to other classes
    my $ticket = Net::Redmine::Ticket->new(connection => $redmine);

=head1 DESCRIPTION



=cut

