require 'spec_helper'

module Wrap
  describe Api do
    subject { Api.instance }

    before(:all) do
      Api.instance.reset
      Api.instance.unauth
      Api.instance.current_node = nil
    end

    it { expect(subject.resources).to be_empty }
    it { expect(subject.current_node).to be_nil }
    it { expect(subject.cluster).to be_an_instance_of Cluster }
    it { expect(subject.default_headers).to eq content_type: 'application/json' }
    it { expect(subject).to_not be_auth }

    context 'with a node' do
      before(:each) do
        subject.cluster.add :social, 'http://127.0.0.1/', %w(v1)
      end

      it { expect(subject.default_node).to be_an_instance_of Node }

      context 'with a resource' do
        it { expect { subject.resource(:object) }.to change { subject.resources.size }.by(1) }
        it { expect { subject.resource(:object, 'some-uid') }.to change { subject.resources.size }.by(1) }
      end

      context 'after executing the request' do
        before(:each) do
          expect(RestClient).to receive(:get).and_return(MockResponse.new)
          subject.resource(:object).index
        end

        it { expect(subject.resources.size).to eq 0 }
      end

      context 'when executing a request' do
        before(:each) { subject.reset }

        it 'returns a JSON object' do
          expect(RestClient).to receive(:get).and_return(MockResponse.new)
          expect(subject.resource(:object, 'some-id').resource(:event).index).to eq 'foo' => 'bar'
        end
      end

      context 'when executing an async request' do
        before(:each) { subject.reset }

        it { expect(subject.async.resource(:object, 'some-id').resource(:event).index).to be_an_instance_of Thread }
      end

      it 'set a headder for the next request only' do
        expect(RestClient).to receive(:get).and_return(MockResponse.new)
        subject.header(:foo, 'bar')
        expect(subject.get_headers).to eq subject.default_headers.merge(foo: 'bar')
        subject.resource(:object).index
        expect(subject.get_headers).to eq subject.default_headers
      end

      it 'auth one request only' do
        expect(RestClient).to receive(:get).and_return(MockResponse.new)
        expect(subject).to_not be_auth
        subject.auth('user_id', :tmp).resource(:object).index
        expect(subject).to_not be_auth
      end

      it 'auth several requests' do
        expect(RestClient).to receive(:get).and_return(MockResponse.new)
        expect(subject).to_not be_auth
        subject.auth('user_id').resource(:object).index
        expect(subject).to be_auth
      end
    end

    it 'override the default headers' do
      new_header = { content_type: 'application/text', foo: 'bar' }
      subject.headers(new_header)
      expect(subject.default_headers).to eq new_header
    end

    it 'auth the next requests' do
      subject.auth('user_id')
      expect(subject).to be_auth
      subject.auth(:anonymous)
      expect(subject).to_not be_auth
    end

    it 'allows query parameters on a :show' do
      expect(RestClient).to receive(:get) { |url| MockResponse.new("{ \"url\" : \"#{ url }\" }") }
      expect(subject.resource(:object, 'object-id').show(access: 'read')['url']).to end_with '?access=read'
    end

    it 'allows query parameters on a :index' do
      expect(RestClient).to receive(:get) { |url| MockResponse.new("{ \"url\" : \"#{ url }\" }") }
      expect(subject.resource(:object, 'object-id').index(access: 'read')['url']).to end_with '?access=read'
    end

    it 'allows namespace in the url' do
      expect(RestClient).to receive(:get).twice { |url| MockResponse.new("{ \"url\" : \"#{ url }\" }") }
      expect(subject.namespace(:private).resource(:object, ':object_id').index['url']).to eq 'http://localhost:3000/v1/private/objects/:object_id'
      expect(subject.resource(:object, ':object_id').index['url']).to eq 'http://localhost:3000/v1/objects/:object_id'
    end

    it 'allows namespace as array in the url' do
      expect(RestClient).to receive(:get).twice { |url| MockResponse.new("{ \"url\" : \"#{ url }\" }") }
      expect(subject.namespace(:private, :acl).resource(:object, ':object_id').index['url']).to eq 'http://localhost:3000/v1/private/acl/objects/:object_id'
      expect(subject.resource(:object, ':object_id').index['url']).to eq 'http://localhost:3000/v1/objects/:object_id'
    end
  end
end
