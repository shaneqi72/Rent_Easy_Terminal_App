require_relative '../../classes/Property.rb'

describe 'Property' do
    let(:new_property) { Property.new('house', '$430')}

    it 'it should return property details' do
        expect(new_property.type).to eq('house')
        expect(new_property.rent).to eq('$430')
        expect(new_property.status).to eq('vacant')
        expect(new_property.address).to eq({})
    end

    it 'it should return updated rent' do
        new_property.update_rent('$500')
        expect(new_property.rent).to eq('$500')
    end

    it 'it should return updated property status' do
        new_property.update_status('occupied')
        expect(new_property.status).to eq('occupied')
    end

    it 'it should return updated address' do
        new_property.update_address('30', 'Hall street', 'Spring Hill')
        expect(new_property.address).to eq({street_number: '30', street_name: 'Hall street', suburb: 'Spring Hill'})
    end

end