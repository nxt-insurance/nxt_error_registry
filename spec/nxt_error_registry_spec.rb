RSpec.describe NxtErrorRegistry do
  it "has a version number" do
    expect(NxtErrorRegistry::VERSION).not_to be nil
  end

  describe '.register_error' do
    module TestErrors
      class BadError < StandardError
      end
    end

    def test_class
      Class.new do
        extend NxtErrorRegistry
      end
    end

    context 'code' do
      let(:level_one) { test_class }

      let(:registry) { NxtErrorRegistry::Registry.send(:new) }

      before do
        allow(NxtErrorRegistry::Registry).to receive(:instance).and_return(registry)
      end

      it 'registers a new error class with the :code method' do
        level_one.register_error :LevelOneError, type: TestErrors::BadError, code: '100.100'
        expect(level_one::LevelOneError.code).to eq('100.100')
      end
    end

    context 'when there are no other errors registered' do
      let(:level_one) { test_class }
      let(:level_two) { test_class }

      let(:registry) { NxtErrorRegistry::Registry.send(:new) }

      before do
        allow(NxtErrorRegistry::Registry).to receive(:instance).and_return(registry)
      end

      it 'creates a new error class' do
        expect {
          level_one.register_error :LevelOneError, type: TestErrors::BadError, code: '100.100'
        }.to change {
          level_one.const_defined?('LevelOneError')
        }.from(false).to(true)

        expect(level_one::LevelOneError.ancestors).to include(TestErrors::BadError)
      end

      it 'registers the error class in the registry' do
        level_two.register_error :LevelTwoError, type: TestErrors::BadError, code: '100.101'

        expect(
          NxtErrorRegistry::Registry.instance[level_two.to_s]['LevelTwoError']
        ).to eq(
          :code => "100.101",
          :error_class => level_two::LevelTwoError,
          :name => :LevelTwoError,
          :namespace => level_two.to_s,
          :opts => {},
          :type => TestErrors::BadError,
        )
      end
    end

    context 'when there are duplicated codes' do
      let(:level_one) { test_class }
      let(:level_two) { test_class }

      let(:registry) { NxtErrorRegistry::Registry.send(:new) }

      before do
        allow(NxtErrorRegistry::Registry).to receive(:instance).and_return(registry)
        level_one.register_error :LevelOneError, type: TestErrors::BadError, code: '100.100'
      end

      it 'raises an error' do
        expect {
          level_two.register_error :LevelTwoError, type: TestErrors::BadError, code: '100.100'
        }.to raise_error(NxtErrorRegistry::DefaultCodeValidator::CodeAlreadyTakenError, "The following codes are duplicated: 100.100")
      end
    end

    context 'when the same error was already registered before' do
      context 'in the same namespace' do
        let(:level_one) { test_class }

        let(:registry) { NxtErrorRegistry::Registry.send(:new) }

        before do
          allow(NxtErrorRegistry::Registry).to receive(:instance).and_return(registry)
          level_one.register_error :LevelOneError, type: TestErrors::BadError, code: '100.101'
        end

        it 'raises an error' do
          expect {
            level_one.register_error :LevelOneError, type: TestErrors::BadError, code: '100.102'
          }.to raise_error(NxtErrorRegistry::RegistrationError, "LevelOneError was already registered in #{level_one}")
        end
      end

      context 'in another namespace' do
        let(:level_one) { test_class }
        let(:level_two) { test_class }

        let(:registry) { NxtErrorRegistry::Registry.send(:new) }

        before do
          allow(NxtErrorRegistry::Registry).to receive(:instance).and_return(registry)
          level_one.register_error :LevelOneError, type: TestErrors::BadError, code: '100.103'
        end

        it 'does not raise en error' do
          expect {
            level_two.register_error :LevelOneError, type: TestErrors::BadError, code: '100.104'
          }.to_not raise_error
        end
      end
    end
  end
end
