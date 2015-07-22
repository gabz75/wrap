require 'spec_helper'

describe Wrap do
  let(:host) { 'http://127.0.0.1:8000/' }
  before(:each) do
    Wrap.config do |c|
      c.add :node_a, host, %w(v1 v2)
    end
  end

  it { expect { subject.node(:whatever) }.to raise_error RuntimeError }
  it { expect { subject.node(:node_a) }.to_not raise_error }
  it { expect(subject.node(:node_a)).to be_an_instance_of Wrap::Api }
  it { expect(subject.node(:node_a).resource(:object)).to be_an_instance_of Wrap::Api }

  context 'after selecting a node' do
    before(:each) { subject.node(:node_a) }
    let(:default_response) { MockResponse.new }

    it 'return a an array when fetching all resources' do
      expect(RestClient).to receive(:get).and_return(default_response)
      expect(subject.resource(:object).index).to eq('foo' => 'bar')
    end

    it 'return a a block when fecthing a resource' do
      expect(RestClient).to receive(:get).and_return(default_response)
      expect(subject.resource(:object, 'some-id').show).to eq('foo' => 'bar')
    end

    it 'return a block when creating a resource' do
      expect(RestClient).to receive(:post).and_return(default_response)
      expect(subject.resource(:object).create(object_id: 'b')).to eq('foo' => 'bar')
    end

    it 'return a block when updating a resource' do
      expect(RestClient).to receive(:put).and_return(default_response)
      expect(subject.resource(:object, 'some-id').update(object_id: 'b')).to eq('foo' => 'bar')
    end

    it 'return nothing when deleting a resource' do
      expect(RestClient).to receive(:delete).and_return(MockResponse.new(''))
      expect(subject.resource(:object, 'some-id').delete).to eq({})
    end
  end
end
