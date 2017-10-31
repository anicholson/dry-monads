RSpec.describe(Dry::Monads) do
  let(:m) { described_class }
  maybe = Dry::Monads::Maybe
  list = Dry::Monads::List
  result = Dry::Monads::Result

  describe 'maybe monad' do
    describe '.Maybe' do
      describe 'lifting to Some' do
        subject { m.Some(5) }

        it { is_expected.to eq maybe::Some.new(5) }
      end

      describe 'lifting to None' do
        subject { m.Maybe(nil) }

        it { is_expected.to eq maybe::None.new }
      end
    end

    describe '.Some' do
      subject { m.Some(10) }

      it { is_expected.to eq maybe::Some.new(10) }

      example 'lifting nil produces an error' do
        expect { m.Some(nil) }.to raise_error(ArgumentError)
      end
    end

    describe '.None' do
      subject { m.None() }

      it { is_expected.to eq maybe::None.new }
    end
  end

  describe 'list monad' do
    subject(:instance) do
      module Test
        class Foo
          include Dry::Monads

          def get_list
            List[1, 2, 3]
          end
        end
      end

      Test::Foo.new
    end

    it 'builds a list with List[]' do
      expect(instance.get_list).to eql(list[1, 2, 3])
    end
  end

   describe 'result monad' do
    describe '.Success' do
      subject { m.Success('everything went right') }

      it { is_expected.to eq result::Success.new('everything went right') }
    end

    describe '.Failure' do
      subject { m.Failure('something has gone wrong') }

      it { is_expected.to eq result::Failure.new('something has gone wrong') }
    end
  end

end
