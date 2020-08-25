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
        level_one.register_error :LevelOneError, type: TestErrors::BadError, code: '04ac98bd-a89e-4e4a-8448-7197dbd76623'
        expect(level_one::LevelOneError.code).to eq('04ac98bd-a89e-4e4a-8448-7197dbd76623')
      end

      it 'defines the instance method too' do
        level_one.register_error :LevelOneError, type: TestErrors::BadError, code: '04ac98bd-a89e-4e4a-8448-7197dbd76623'
        instance = level_one::LevelOneError.new('Error!')
        expect(instance.code).to eq('04ac98bd-a89e-4e4a-8448-7197dbd76623')
      end
    end

    context 'options' do
      let(:level_one) { test_class }

      let(:registry) { NxtErrorRegistry::Registry.send(:new) }

      before do
        allow(NxtErrorRegistry::Registry).to receive(:instance).and_return(registry)
        level_one.register_error :LevelOneError, type: TestErrors::BadError, code: '04ac98bd-a89e-4e4a-8448-7197dbd76623', capture: false
      end

      it 'sets the options on the class' do
        expect(level_one::LevelOneError.options).to eq(capture: false)
      end

      it 'can be extended by the subclass' do
        level_one.register_error :LevelTwoError, type: level_one::LevelOneError, code: '14fc94dd-a159-4e58-bfc2-b35b59e8bb15', capture: true, reraise: true
        expect(level_one::LevelTwoError.options).to eq(capture: true, reraise: true)
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
          level_one.register_error :LevelOneError, type: TestErrors::BadError, code: '14fc94dd-a159-4e58-bfc2-b35b59e8bb15'
        }.to change {
          level_one.const_defined?('LevelOneError')
        }.from(false).to(true)

        expect(level_one::LevelOneError.ancestors).to include(TestErrors::BadError)
      end

      it 'registers the error class in the registry' do
        level_two.register_error :LevelTwoError, type: TestErrors::BadError, code: 'bddf958e-0e74-4729-b63f-1367a2103e53'

        expect(
          NxtErrorRegistry::Registry.instance[level_two.to_s]['LevelTwoError']
        ).to eq(
          :code => "bddf958e-0e74-4729-b63f-1367a2103e53",
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
        level_one.register_error :LevelOneError, type: TestErrors::BadError, code: 'bddf958e-0e74-4729-b63f-1367a2103e53'
      end

      it 'raises an error' do
        expect {
          level_two.register_error :LevelTwoError, type: TestErrors::BadError, code: 'bddf958e-0e74-4729-b63f-1367a2103e53'
        }.to raise_error(NxtErrorRegistry::DefaultCodeValidator::CodeAlreadyTakenError, 'The following codes are duplicated: bddf958e-0e74-4729-b63f-1367a2103e53')
      end
    end

    context 'when the same error was already registered before' do
      context 'in the same namespace' do
        let(:level_one) { test_class }

        let(:registry) { NxtErrorRegistry::Registry.send(:new) }

        before do
          allow(NxtErrorRegistry::Registry).to receive(:instance).and_return(registry)
          level_one.register_error :LevelOneError, type: TestErrors::BadError, code: 'bddf958e-0e74-4729-b63f-1367a2103e53'
        end

        it 'raises an error' do
          expect {
            level_one.register_error :LevelOneError, type: TestErrors::BadError, code: '15e37258-b0f9-4dc1-b154-8c6bd9004ead'
          }.to raise_error(NxtErrorRegistry::RegistrationError, "LevelOneError was already registered in #{level_one}")
        end
      end

      context 'in another namespace' do
        let(:level_one) { test_class }
        let(:level_two) { test_class }

        let(:registry) { NxtErrorRegistry::Registry.send(:new) }

        before do
          allow(NxtErrorRegistry::Registry).to receive(:instance).and_return(registry)
          level_one.register_error :LevelOneError, type: TestErrors::BadError, code: '15e37258-b0f9-4dc1-b154-8c6bd9004ead'
        end

        it 'does not raise en error' do
          expect {
            level_two.register_error :LevelOneError, type: TestErrors::BadError, code: '3317bfff-3fed-45aa-8626-371eef1b33ab'
          }.to_not raise_error
        end
      end
    end
  end
end
