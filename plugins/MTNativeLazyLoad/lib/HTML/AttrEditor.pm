# Copyright (c) 2020 ARK-Web Co.,Ltd.
package HTML::AttrEditor;
use strict;
use utf8;

sub new {
	my ($class, $opts) = @_;

	my $self = {};
	$self->{"errors"} = [];
	$self->{"logs"} = [];
	$self->{"targets"} = $opts->{"targets"} || [];

	my @modules = (
		'HTML::TokeParser', 
	);
	foreach my $module (@modules) {
		eval "require $module";
		if ($@) {
			push @{$self->{"errors"}}, "Perl module $module is required to HTML::AttrEditor\n$@";
			$self->{$module} = 0;
		} else {
			$self->{$module} = 1;
		}
	}

	return bless $self, $class;
}

sub convert {
	my ($self, $html) = @_;

	return $html unless $self->{'HTML::TokeParser'};

	my $content = "";
	my $p = HTML::TokeParser->new(\$html);
	while (my $token = $p->get_token) {
		my $type = $token->[0];
		if ($type eq "S") {		# Start tag
			my $tagname   = $token->[1];
			my %attrs     = %{$token->[2]};
			my @attr_keys = @{$token->[3]};
			my $text      = $token->[4];

			# convert
			my $changed = $self->convert_attrs(\$tagname, \%attrs, \$text);
			if ($changed) {
				# fix end slash
				my $end = $attrs{'/'} ? ' /' : '';
				delete $attrs{'/'} if $attrs{'/'};
				my $attr_string = "";
				foreach my $key (keys %attrs) {
					$attr_string .= sprintf(' %s="%s"', $key, $attrs{$key});
				}
				$content .= sprintf('<%s%s%s>', $tagname, $attr_string, $end);
			}
			else {
				$content .= $text;
			}
		}
		elsif ($type eq "E") {	# End tag
			my $tagname = $token->[1];
			my $text    = $token->[2];

			$content .= $text;
		}
		elsif ($type eq "T" || $type eq "C" || $type eq "D") {	# Other tags
			my $text = $token->[1];

			$content .= $text;
		}
		elsif ($type eq "PI") {	# <?php
			my $text = $token->[2];

			$content .= $text;
		}
	}
	return $content;
}

sub convert_attrs {
	my ($self, $tagname, $attrs, $text) = @_;

	my $changed = 0;
	foreach my $target (@{$self->{"targets"}}) {
		if ($$tagname eq $target->{"tag"}) {
			my $attr = $target->{"attr"};
			if (!$target->{"overwrite"} && $attrs->{$attr}) {
				next;
			}
			if ($target->{"required_attrs"} && ref $target->{"required_attrs"} eq "ARRAY") {
				my $check_ng  = 0;
				foreach my $required_attr (@{$target->{"required_attrs"}}) {
					if (!defined $attrs->{$required_attr}) {
						$check_ng = 1;
						last;
					}
				}
				if ($check_ng) {
					next;
				}
			}
			$attrs->{$attr} = $target->{"val"};
			$changed = 1;
		}
	}
	return $changed;
}

1;
