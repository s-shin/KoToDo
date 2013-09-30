package todoApp::Controller::Todos;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

todoApp::Controller::Todos - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched todoApp::Controller::Todos in Todos.');
}


sub get :Local {
	my ($self, $c)=@_;
	$c->stash(todos => [$c->model('DB::Todo')->all]);
	$c->stash(template => 'todos/list.tt');
}





#REST api

sub post :create {
	my ($self, $c)=@_;
	my $name = $c->request->parameters->{name};
	my $comment = $c->request->parameters->{comment};
	my $deadline = $c->request->parameters->{deadline};
	$c->stash(todos => [$c->model('DB::Todo')->all]);

}


sub get :todos {
	my ($self, $c)=@_;
	$c->stash(todos => [$c->model('DB::Todo')->all]);
}

sub post :todos {
	my ($self, $c)=@_;
	$c->stash(todos => [$c->model('DB::Todo')->all]);

}

sub post :delete {
	my ($self, $c)=@_;
	$c->stash(todos => [$c->model('DB::Todo')->all]);
}


sub get :delete {
	my ($self, $c)=@_;
	$c->stash(todos => [$c->model('DB::Todo')->all]);
		
}

=encoding utf8

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
