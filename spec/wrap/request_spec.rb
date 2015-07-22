require 'spec_helper'

module Wrap
  describe Request do
    it { expect { Request.new }.to raise_error ArgumentError }

    context 'without a payload' do
      subject { Request.new :get, 'http://localhost:80', content_type: 'application/json' }

      it { expect(subject).to be_an_instance_of Request }
      it 'returns some JSON' do
        expect(RestClient).to receive(:get).and_return MockResponse.new
        expect(subject.execute).to eq 'foo' => 'bar'
      end
    end

    context 'with a payload' do
      subject { Request.new :get, 'http://localhost:80', { content_type: 'application/json' }, foo: 'bar' }

      it { expect(subject).to be_an_instance_of Request }
      it 'returns some JSON' do
        expect(RestClient).to receive(:get).and_return MockResponse.new
        expect(subject.execute).to eq 'foo' => 'bar'
      end
    end
  end
end
