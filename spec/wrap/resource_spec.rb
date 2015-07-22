require 'spec_helper'

module Wrap
  describe Resource do
    it { expect { Resource.new }.to raise_error ArgumentError }

    context 'without an id' do
      subject { Resource.new :object }

      it { expect(subject).to be_an_instance_of Resource }
      it { expect(subject.sub_path).to eq '/objects' }
    end

    context 'with an id' do
      subject { Resource.new :object, 'some-uid' }

      it { expect(subject).to be_an_instance_of Resource }
      it { expect(subject.sub_path).to eq '/objects/some-uid' }
    end
  end
end
