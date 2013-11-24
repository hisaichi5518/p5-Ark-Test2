package Ark::Test2::Role::Context;
use Mouse::Role;

before process => sub {
    Ark::Test2::_context($_[0]);
};

no Mouse::Role;

1;
