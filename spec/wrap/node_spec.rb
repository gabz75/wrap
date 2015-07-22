require 'spec_helper'

module Wrap
  describe Node do
    let(:key) { :social }
    let(:host) { 'http://127.0.0.1' }
    let(:versions) { %w(v1 v2) }
    subject { Node.new(key, host, versions) }

    it { expect(subject.key).to eq key }
    it { expect(subject.host).to eq host }
    it { expect(subject.versions).to eq versions }
    it { expect(subject.path).to eq "#{ host }/#{ versions.first }" }
    it { expect(Node.new(:auth, 'http://127.0.0.1/', ['v1']).path).to eq "#{ host }/#{ versions.first }" }
  end
end
