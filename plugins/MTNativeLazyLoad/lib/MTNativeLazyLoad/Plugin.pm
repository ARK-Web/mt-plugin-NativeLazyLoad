package MTNativeLazyLoad::Plugin;
use strict;
use utf8;
use HTML::AttrEditor;

sub LOADING_DEFAULT { "lazy" }
sub OVERWRITE_DEFAULT { 0 }

sub hdlr_modifier_native_lazyload {
	my ($content, $val, $ctx) = @_;

	my $loading = ($val ne "1") ? $val : LOADING_DEFAULT;
	my $overwrite = OVERWRITE_DEFAULT;

	return _convert_lazyload($ctx, $content, {
		loading => $loading,
		overwrite => $overwrite,
	});
}

sub hdlr_block_native_lazyload {
	my ($ctx, $args, $cond) = @_;

	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	defined (my $content = $builder->build($ctx, $tokens))
		or return $ctx->error($builder->errstr);

	my $loading = $args->{"loading"} ? $args->{"loading"} : LOADING_DEFAULT;
	my $overwrite = $args->{"overwrite"} ? 1 : OVERWRITE_DEFAULT;

	return _convert_lazyload($ctx, $content, {
		loading => $loading,
		overwrite => $overwrite,
	});
}

sub _convert_lazyload {
	my ($ctx, $content, $opts) = @_;

	my $app = MT->instance;
	my $native_lazyload = HTML::AttrEditor->new({
		targets => [
			{
				tag  => 'img',
				attr => 'loading',
				val  => $opts->{"loading"},
				overwrite => $opts->{"overwrite"},
			},
		],
	});
	$content = $native_lazyload->convert($content);
	if (@{$native_lazyload->{"errors"}}) {
		return $ctx->error(join("\n", @{$native_lazyload->{"errors"}}));
	}
	if (@{$native_lazyload->{"logs"}}) {
		$app->log({message => 'MTNativeLazyLoad: ' . $ctx->stash('current_mapping_url'), metadata => join("\n", @{$native_lazyload->{"logs"}})});
		@{$native_lazyload->{"logs"}} = [];
	}

	return $content;
}

1;
