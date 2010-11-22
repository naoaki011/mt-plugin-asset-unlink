package AssetUnlink::CMS;

use strict;
use warnings;
use MT 5.0;

# use Data::Dumper;

sub unlink_asset {
    my ($app) = @_;
    my @ids = $app->param('id');
    require MT::Asset;
    foreach my $id (@ids) {
        my $asset = MT::Asset->load($id);
        $asset->file_path( $asset->file_path . '.dummy.file' );
        $asset->save;
        $asset->remove;
    }
    $app->call_return( saved => 1 );
}

sub find_duplicated_assets {
    my ($app) = @_;

}

sub is_blog_context {
    my $app = MT->instance;
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        return 1;
    }
}

sub doLog {
    my ($msg) = @_; 
    return unless defined($msg);
    require MT::Log;
    my $log = MT::Log->new;
    $log->message($msg) ;
    $log->save or die $log->errstr;
}

1;