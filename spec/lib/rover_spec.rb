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

    context "when moving the rover forward" do
      let(:command_sequence) { "F" }
      context "when the rover is heading north" do
        before do
          allow(instance.position).
            to receive(:heading).
            and_return(:north)
        end

        it "increments y by 1" do
          expect { run }.to change { instance.position.y }.by(1)
        end
      end

      context "when the rover is heading south" do
        before do
          allow(instance.position).
            to receive(:heading).
            and_return(:south)
        end

        it "increments y by 1" do
          expect { run }.to change { instance.position.y }.by(-1)
        end
      end

      context "when the rover is heading west" do
        before do
          allow(instance.position).
            to receive(:heading).
            and_return(:west)
        end

        it "increments y by 1" do
          expect { run }.to change { instance.position.x }.by(-1)
        end
      end

      context "when the rover is heading east" do
        before do
          allow(instance.position).
            to receive(:heading).
            and_return(:east)
        end

        it "increments y by 1" do
          expect { run }.to change { instance.position.x }.by(1)
        end
      end
    end

    context "when moving the rover backward" do
      let(:command_sequence) { "B" }
      context "when the rover is heading north" do
        before do
          allow(instance.position).
            to receive(:heading).
            and_return(:north)
        end

        it "decrements y by 1" do
          expect { run }.to change { instance.position.y }.by(-1)
        end
      end

      context "when the rover is heading south" do
        before do
          allow(instance.position).
            to receive(:heading).
            and_return(:south)
        end

        it "increments y by 1" do
          expect { run }.to change { instance.position.y }.by(1)
        end
      end

      context "when the rover is heading west" do
        before do
          allow(instance.position).
            to receive(:heading).
            and_return(:west)
        end

        it "increments y by 1" do
          expect { run }.to change { instance.position.x }.by(1)
        end
      end

      context "when the rover is heading east" do
        before do
          allow(instance.position).
            to receive(:heading).
            and_return(:east)
        end

        it "increments y by 1" do
          expect { run }.to change { instance.position.x }.by(-1)
        end
      end
    end

    context "when the rover is turning left" do
      let(:command_sequence) { "L" }

      context "when the rover is heading north" do
        before do
          instance.position.heading = :north
        end

        it "faces the rover west" do
          run
          expect(instance.position.heading).to eq(:west)
        end
      end
    end

    context "when the rover is turning right" do
      let(:command_sequence) { "R" }

      context "when the rover is heading north" do
        before do
          instance.position.heading = :north
        end

        it "faces the rover east" do
          run
          expect(instance.position.heading).to eq(:east)
        end
      end
    end
  end
end
