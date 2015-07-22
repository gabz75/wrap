# Wrapper

Opiniated HTTP Wrapper to talk to Several homogeneous Rails APIs (called node)

## Installation

In your Gemfile:

    gem 'wrap', git: git@github.com:gabz75/wrap.git


## Configuration

    Wrap.config do |c|
      c.add :node_a, 'http://localhost:3000', ['v1']
      c.add :node_b, 'http://localhost:4000', ['v1']
      c.add :node_c, 'http://localhost:5000', ['v1']
    end

## Usage

Select a service first

    Wrap.node(:node_a)

Then select the resources that you would like to work with

    Wrap.node(:node_a).resource(:object)

Then select the action

    # Return all Objects
    Wrap.node(:node_a).resource(:object).index
    Wrap.node(:node_a).resource(:object).index(foo: 'bar') # support for query parameters

    # Return an Object given his ID
    Wrap.node(:node_a).resource(:object, 'some-id').show
    Wrap.node(:node_a).resource(:object, 'some-id').show(foo: 'bar') # support for query parameters

    # Create an Object
    Wrap.node(:node_a).resource(:object).create({ foo: 'bar ', baz: 'bar' }))

    # Update an Object
    Wrap.node(:node_a).resource(:object, 'some-id').update(foo: 'bar')

    # Delete an Object
    Wrap.node(:node_a).resource(:object, 'some-id').delete('some-id')

## Headers

Set a a bunch of headers globally and overide the `default_header` parameters

    Wrap.headers(
      content_type: 'application/json',
      foo: 'bar',
      bar: 'fooz'
    )

In a specific header only for a single request

    Wrap.header(:foo, 'bar').node(:node_a).resources(:object).index

## Authentication

In order to authenticate any request use the following:

    Wrap.auth('user_id')

In order to authenticate only a single request use the following:

    Wrap.node(:node_a).auth('user_id', :tmp).resources(:object).index

+ If the auth('user_id') method is called ***before*** specifying the node, then ***all the requests*** will be ***authenticated***.
+ If the auth('user_id', :tmp) method is called ***after*** specifying the node, then ***only one request*** will be ***authenticated***.

In order to turn off the authentiation for all requets, use the following:

    Wrap.auth(:anonymous)

Authentication can also be turned off for a single request by using

    Wrap.unauth.node(:node_a).resources(:object).index

Example:

    Wrap.node(:node_a).resource(:object).index # unauthenticated
    Wrap.auth('user_id')
    Wrap.node(:node_a).resource(:object).index # authenticated
    Wrap.node(:node_a).resource(:object).index # authenticated
    Wrap.auth(:anonymous)
    Wrap.node(:node_a).resource(:object).index # unauthenticated
    Wrap.node(:node_a).auth('user_id', :tmp).resource(:object).index # authenticated
    Wrap.auth('user_id')
    Wrap.unauth.node(:node_a).resource(:object).index #unauthenticated
    Wrap.node(:node_a).resource(:object).index # authenticated

## Asynchronous request

when asking for a resource you can specify an extra parameters asking to execute the request asynchronously

    Wrap.node(:node_a).resource(:object).async.create({ foo: 'bar ', baz: 'bar' }))

## Nested resources

    Wrap.node(:node_a).resource(:object, 'some-id').resource(:event).create({ name: 'bar ', data: 'bar' }))

## Namespace

    Wrap.node(:node_a).namespace(:private).resource(:name).show(id)
    Wrap.node(:node_a).namespace(:private, :something).resource(:name).show(id)

## Coming up

- Support for non restfuls resources/actions
- Support for fields selector

