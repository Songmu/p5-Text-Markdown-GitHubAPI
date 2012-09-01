package Text::Markdown::GitHubAPI;
use strict;
use warnings;
use utf8;

use Digest::MD5 qw(md5_hex);
use parent 'Exporter';
our $VERSION = '0.01';
$VERSION = eval $VERSION; ## no critic

use Encode qw/decode_utf8/;
use Furl;
use JSON;

use Class::Accessor::Lite (
    new => 1,
    ro  => [qw/fallback_md_class error_msg/],
);

our @EXPORT_OK = qw/markdown/;

our $API_URL = 'https://api.github.com/markdown';

sub _error_msg {
    shift->error_msg || '<p class="error">Request failed.</p>';
}

sub furl { shift->{_furl} ||= Furl->new( timeout => 10 ) }
sub json { shift->{_json} ||= JSON->new->utf8 }
sub fallback_md {
    my $self = shift;
    $self->{_fallbck_md} ||= do {
        my $cls = $self->fallback_md_class || 'Text::Markdown';
        my $file = $cls;
        $file =~ s!::!/!g; $file .= '.pm';
        require $file;
        $cls->new;
    };
}

sub markdown {
    my ( $self, $text, $options ) = @_;

    # copied from Text::Markdown
    # Detect functional mode, and create an instance for this run
    unless (ref $self) {
        if ( $self ne __PACKAGE__ ) {
            my $ob = __PACKAGE__->new();
                                # $self is text, $text is options
            return $ob->markdown($self, $text);
        }
        else {
            croak('Calling ' . $self . '->markdown (as a class method) is not supported.');
        }
    }

    # TODO: cache
    my $data = $self->json->encode({
        text => $text,
    });

    my $res = $self->furl->post($API_URL, [
        'Content-Type'   => 'application/json',
        'Content-Length' => length($data),
    ], $data);

    if ($res->is_success) {
        decode_utf8 $res->content;
    }
    else {
        # fallback
        $self->_error_msg . $self->fallback_md->markdown($text);
    }

}


1;
__END__

=head1 NAME

Text::Markdown::GitHubAPI -

=head1 SYNOPSIS

  use Text::Markdown::GitHubAPI;

=head1 DESCRIPTION

Text::Markdown::GitHubAPI is

=head1 AUTHOR

Masayuki Matsuki E<lt>y.songmu@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
