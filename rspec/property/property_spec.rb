require_relative '../../classes/Property.rb'

describe 'Property' do
    let(:new_property) { Property.new('house', '$430', {first_name: "Leo", last_name: "Michael"}, {first_name: "Haylin", last_name: "Lee"}, {street_number: "5", street_name: "Hall Sreet", suburb: "Toowong"}, "occupied")}

    it 'it should return property details' do
        expect(new_property.type).to eq('house')
        expect(new_property.rent).to eq('$430')
        expect(new_property.status).to eq('occupied')
        expect(new_property.address).to eq({street_number: "5", street_name: "Hall Sreet", suburb: "Toowong"})
        expect(new_property.landlord).to eq({first_name: "Leo", last_name: "Michael"})
        expect(new_property.tenant).to be({first_name: "Haylin", last_name: "Lee"})

    end

    # it 'it should return updated rent' do
    #     new_property.update_rent('$500')
    #     expect(new_property.rent).to eq('$500')
    # end

    # it 'it should return updated property status' do
    #     new_property.update_status('occupied')
    #     expect(new_property.status).to eq('occupied')
    # end

    # it 'it should return updated address' do
    #     new_property.update_address('30', 'Hall street', 'Spring Hill')
    #     expect(new_property.address).to eq({street_number: '30', street_name: 'Hall street', suburb: 'Spring Hill'})
    # end

    # it 'it should return updated tenant' do

    #     new_property.update_tenant('Leo', 'Lee')
    #     expect(new_property.tenant.first_name).to eq('Leo')
    #     expect(new_property.tenant.last_name).to eq('Lee')
    # end

    # it 'it should return updated landlord' do
    #     new_property.create_landlord('Joyce', 'Michael')
    #     expect(new_property.landlord.first_name).to eq('Joyce')
    #     expect(new_property.landlord.last_name).to eq('Michael')
    # end

end