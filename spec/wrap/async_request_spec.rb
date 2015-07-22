require 'spec_helper'

module Wrap
  describe AsyncRequest do
    it { expect { AsyncRequest.new }.to raise_error ArgumentError }

    context 'without a payload' do
      subject { AsyncRequest.new :get, 'http://localhost:80', content_type: 'application/json' }

      it { expect(subject).to be_an_instance_of AsyncRequest }
      it { expect(subject.execute).to be_an_instance_of Thread }
    end

    context 'with a payload' do
      subject { AsyncRequest.new :get, 'http://localhost:80', { content_type: 'application/json' }, foo: 'bar' }

      it { expect(subject).to be_an_instance_of AsyncRequest }
      it { expect(subject.execute).to be_an_instance_of Thread }
    end
  end
end
