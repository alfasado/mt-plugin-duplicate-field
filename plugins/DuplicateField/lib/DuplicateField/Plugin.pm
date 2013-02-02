package DuplicateField::Plugin;
use strict;

sub _edit_field {
    my ( $cb, $app, $tmpl ) = @_;
    my $pointer = '<\/button>';
    my $mtml = <<'MTML';
<__trans_section component="DuplicateField">
<mt:if name="id">
    <button
        type="button"
        accesskey="d"
        title="<__trans phrase="Duplicate this field (d)">"
        class="save action button"
        onclick="location.href='<mt:var name="script_url">?__mode=view&amp;_type=field&amp;blog_id=<mt:var name="blog_id" escape="url">&amp;id=<mt:var name="id" escape="url">&amp;duplicate=1';">
        <__trans phrase="Duplicate">
    </button>
</mt:if>
</__trans_section>
MTML
    $$tmpl =~ s/($pointer)/$1$mtml/;
    if ( $app->param( 'duplicate' ) ) {
        my $search = quotemeta( '<__trans phrase="Create Custom Field">' );
        my $replace = '<__trans_section component="DuplicateField"><__trans phrase="Duplicate Custom Field"></__trans_section>';
        $$tmpl =~ s/$search/$replace/;
        $search= quotemeta( 'changeName();' );
        $$tmpl =~ s/$search//;
    }
}

sub _edit_field_param {
    my ( $cb, $app, $param, $tmpl ) = @_;
    if (! $app->param( 'duplicate' ) ) {
        return ;
    }
    $param->{ id } = '';
    $param->{ basename } = '';
    $param->{ tag } = '';
    my $name = $param->{ name };
    $param->{ name } = $app->translate( 'Copy of [_1]', $name );
}

1;