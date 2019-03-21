RSpec.describe NxtErrorRegistry::Registry do
  subject { described_class.instance }

  describe '#flat' do
    before do
      subject['LevelOne'] = { 'LevelOneError': { code: '100.100' } }
      subject['LevelTwo'] = { 'LevelTwoError': { code: '100.101' } }
    end

    it 'returns merges all registries of all namespaces' do
      expect(subject.flat).to eq(:LevelOneError=>{:code=>"100.100"}, :LevelTwoError=>{:code=>"100.101"})
    end
  end

  describe '#entries_by_codes' do
    before do
      subject['LevelOne'] = { 'LevelOneError': { code: '100.100' } }
      subject['LevelTwo'] = { 'LevelTwoError': { code: '100.101' } }
    end

    it 'returns a flat with codes as keys' do
      expect(subject.entries_by_codes).to eq("100.100"=>[{:code=>"100.100"}], "100.101"=>[{:code=>"100.101"}])
    end
  end

  describe '#duplicate_codes' do
    before do
      subject['LevelOne'] = { 'LevelOneError': { code: '100.100' } }
      subject['LevelTwo'] = { 'LevelTwoError': { code: '100.101' } }
      subject['LevelThree'] = { 'LevelThreError': { code: '100.101' } }
    end

    it 'returns the entries that have the same code' do
      expect(subject.duplicate_codes).to eq("100.101"=>[{:code=>"100.101"}, {:code=>"100.101"}])
    end
  end
end