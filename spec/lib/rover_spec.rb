require "spec_helper"

RSpec.describe Kata::Rover do
  let(:instance) { described_class.new }

  describe "#run" do
    subject(:run) { instance.run(command_sequence) }
    context "with a valid command sequence" do
      let(:command_sequence) { "FBLR" }
      let(:result) { Kata::Rover::Result.new(:success) }

      it "returns a success result" do
        real_result = run
        expect(real_result).to eq(result)
      end
    end

    context "with an invalid command command sequence" do
      let(:command_sequence) { "FBLV" }
      let(:result) { Kata::Rover::Result.new(:invalid_command, "V") }

      it "returns an invalid command result" do
        real_result = run
        expect(real_result).to eq(result)
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

      context "when the rover is at the left edge" do
        before do
          instance.position.x = 0
          instance.position.y = 10
          instance.position.heading = :west
        end

        it "wraps the rover around to the right" do
          run
          expect(instance.position.x).to eq(100)
        end
      end

      context "when the rover is at the bottom edge" do
        before do
          instance.position.x = 10
          instance.position.y = 0
          instance.position.heading = :south
        end

        it "wraps the rover around to the top" do
          run
          expect(instance.position.y).to eq(100)
        end
      end

      context "when the rover is at the right edge" do
        before do
          instance.position.x = 100
          instance.position.y = 0
          instance.position.heading = :east
        end

        it "wraps the rover around to the left" do
          run
          expect(instance.position.x).to eq(0)
        end
      end

      context "when the rover is at the top edge" do
        before do
          instance.position.x = 10
          instance.position.y = 100
          instance.position.heading = :north
        end

        it "wraps the rover around to the bottom" do
          run
          expect(instance.position.y).to eq(0)
        end
      end

      context "when the rover is going to collide" do
        let(:result) { Kata::Rover::Result.new(:collision, result_data) }
        let(:result_data) { Kata::Rover::Obstacle.new(25, 25) }
        before do
          instance.position.x = 25
          instance.position.y = 24
          instance.position.heading = :north
        end

        it "reports the obstacle ahead" do
          real_result = run
          expect(real_result).to eq(result)
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

      context "when the rover is at the left edge" do
        before do
          instance.position.x = 0
          instance.position.y = 10
          instance.position.heading = :east
        end

        it "wraps the rover around to the right" do
          run
          expect(instance.position.x).to eq(100)
        end
      end

      context "when the rover is at the bottom edge" do
        before do
          instance.position.x = 10
          instance.position.y = 0
          instance.position.heading = :north
        end

        it "wraps the rover around to the top" do
          run
          expect(instance.position.y).to eq(100)
        end
      end

      context "when the rover is at the right edge" do
        before do
          instance.position.x = 100
          instance.position.y = 0
          instance.position.heading = :west
        end

        it "wraps the rover around to the left" do
          run
          expect(instance.position.x).to eq(0)
        end
      end

      context "when the rover is at the top edge" do
        before do
          instance.position.x = 10
          instance.position.y = 100
          instance.position.heading = :south
        end

        it "wraps the rover around to the bottom" do
          run
          expect(instance.position.y).to eq(0)
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

      context "when the rover is heading south" do
        before do
          instance.position.heading = :south
        end

        it "faces the rover east" do
          run
          expect(instance.position.heading).to eq(:east)
        end
      end

      context "when the rover is heading west" do
        before do
          instance.position.heading = :west
        end

        it "faces the rover south" do
          run
          expect(instance.position.heading).to eq(:south)
        end
      end

      context "when the rover is heading east" do
        before do
          instance.position.heading = :east
        end

        it "faces the rover north" do
          run
          expect(instance.position.heading).to eq(:north)
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

      context "when the rover is heading south" do
        before do
          instance.position.heading = :south
        end

        it "faces the rover west" do
          run
          expect(instance.position.heading).to eq(:west)
        end
      end

      context "when the rover is heading west" do
        before do
          instance.position.heading = :west
        end

        it "faces the rover north" do
          run
          expect(instance.position.heading).to eq(:north)
        end
      end

      context "when the rover is heading east" do
        before do
          instance.position.heading = :east
        end

        it "faces the rover south" do
          run
          expect(instance.position.heading).to eq(:south)
        end
      end
    end

    context "with a long command sequence" do
      let (:command_sequence) { "FFFRFFLFFBRFF" }

      before do
        instance.position.heading = :north
        instance.position.x = 0
        instance.position.y = 0
      end

      it "moves the rover to the right place" do
        run
        expect(instance.position.heading).to eq(:east)
        expect(instance.position.x).to eq(4)
        expect(instance.position.y).to eq(4)
      end
    end
  end
end
