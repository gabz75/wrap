require 'spec_helper'

describe 'authentication' do
  subject { Wrap::Api.instance }

  it 'provides a DSL to auth and unauth each requests' do
    Wrap.config do |c|
      c.add :node_a, 'http://localhost:3000', ['v1']
    end

    expect(RestClient).to receive(:get).exactly(6).and_return(MockResponse.new)

    expect(subject).to_not be_auth
    subject.node(:node_a).resource(:object).index # unauthenticated
    expect(subject).to_not be_auth

    subject.auth('user_id')
    expect(subject).to be_auth
    subject.node(:node_a).resource(:object).index # authenticated
    subject.node(:node_a).resource(:object).index # authenticated
    expect(subject).to be_auth
    subject.auth(:anonymous)
    expect(subject).to_not be_auth
    subject.node(:node_a).resource(:object).index # unauthenticated

    expect(subject).to_not be_auth
    subject.auth('user_id', :tmp)
    expect(subject).to be_auth
    subject.node(:node_a).resource(:object).index # authenticated
    expect(subject).to_not be_auth

    subject.auth('user_id')
    subject.node(:node_a).resource(:object).index # authenticated
    expect(subject).to be_auth

    subject.reset
  end
end
