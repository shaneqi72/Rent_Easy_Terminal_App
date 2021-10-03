require_relative '../../classes/Property.rb'

describe 'Property' do
    
    let(:new_property) { Property.new('house', '$430', {first_name: 'Leo', last_name: 'Michael'}, {first_name: "Haylin", last_name: "Lee"}, {street_number: "5", street_name: "Hall Street", suburb: "Toowong"}, "occupied")}

    it 'it should return property details' do
        expect(new_property.type).to eq('house')
        expect(new_property.rent).to eq('$430')
        expect(new_property.status).to eq('occupied')
        expect(new_property.address[:street_number]).to eq('5')
        expect(new_property.address[:street_name]).to eq('Hall Street')
        expect(new_property.address[:suburb]).to eq('Toowong')
    end

    it 'it should return landlord name' do
        expect(new_property.landlord.first_name).to eq('Leo')
        expect(new_property.landlord.last_name).to eq('Michael')
    end

    it 'it should return tenant name' do
        expect(new_property.tenant.first_name).to eq('Haylin')
        expect(new_property.tenant.last_name).to eq('Lee')
    end

    it 'it should return property details summary' do
        expect(new_property.print_list).to eq('5 Hall Street, Toowong. $430/pw occupied. Tenant: Haylin Lee. Landlord: Leo Michael')
    end
end