require "spec_helper"

RSpec.describe Kata::Rover do
  let(:instance) { described_class.new }

  describe "#run" do
    subject(:run) { instance.run(command_sequence) }
    context "with a valid command sequence" do
      let(:command_sequence) { "FBLR" }
      
      it "doesn't raise and exception" do
        expect { run }.not_to raise_error
      end
    end

    context "with an invalid command command sequence" do
      let(:command_sequence) { "FBLV" }

      it "raises and exception" do
        expect { run }.to raise_error(/V is not a valid command/)
      end
    end
  end
end
