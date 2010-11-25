package AssetUnlink::CMS;

use strict;
use warnings;
use MT 4.0;
use base qw( MT::Object );

# use Data::Dumper;

sub unlink_asset {
    my ($app) = @_;
    my @ids = $app->param('id');
    require MT::Asset;
    foreach my $id (@ids) {
        my $asset = MT::Asset->load($id);
#        $asset->remove_cached_files;
        # remove children.
#        my $class = ref $asset;
#        my $iter = __PACKAGE__->load_iter({ parent => $asset->id, class => '*' });
#        while(my $a = $iter->()) {
#            $a->SUPER::remove;
#        }
        # Remove MT::ObjectAsset records
        my $class = MT->model('objectasset');
        my $iter = $class->load_iter({ asset_id => $asset->id });
        while (my $o = $iter->()) {
            $o->remove;
        }
        $asset->SUPER::remove;
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