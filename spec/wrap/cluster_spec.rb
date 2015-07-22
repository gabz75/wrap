require 'spec_helper'

module Wrap
  describe Cluster do
    let(:node_a) { Node.new(:auth, 'http://127.0.0.1/service-a', ['v1']) }
    let(:node_b) { Node.new(:social, 'http://127.0.0.1/service-b', ['v1']) }

    subject do
      cluster = Cluster.new
      cluster.add_node node_a
      cluster.add_node node_b
      cluster
    end

    it { expect(subject.nodes).to be_a_kind_of Hash }
    it { expect(subject.nodes.size).to eq 2 }
    it { expect(subject.nodes[:auth]).to eq node_a }
    it { expect(subject.nodes[:social]).to eq node_b }
  end
end
