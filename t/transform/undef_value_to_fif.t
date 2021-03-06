use strict;
use warnings;
use Test::More;

{
    package MyApp::Form::Test;
    use Moo;
    use Data::MuForm::Meta;
    extends 'Data::MuForm';

    has_field 'foo' => ( 'transform_value_to_fif' => *deflate_foo );
    has_field 'bar';

    sub deflate_foo {
        my ( $self, $value ) = @_;
        if ( ! defined $value ) {
            $value = 'deflated';
        }
        return $value;
    }

}

my $form = MyApp::Form::Test->new;
ok( $form );

my $init_obj = {
   foo => undef,
   bar => 'somebar',
};

$form->process( init_object => $init_obj, params => {} );
my $fif = $form->fif;
is_deeply( $fif, { foo => 'deflated', bar => 'somebar' }, 'undef value was deflated' );

done_testing;
