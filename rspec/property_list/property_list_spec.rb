require_relative '../../classes/PropertyList.rb'
require_relative '../../classes/Property.rb'
require_relative '../../classes/Landlord.rb'
require_relative '../../classes/Tenant.rb'

describe 'PropertyList' do
    let(:property_list) {PropertyList.new('../../data/properties.json')}
    let(:last_added_property) {property_list.array[-1]}
    it "it should return property list details" do
        property_list.create_property('house', '$700', "Occupied", {street_number: "30", street_name: "New Street", suburb: "Taringa"}, {first_name: 'Sandy', last_name: 'Liang'}, {first_name: "Carol", last_name: "Xin"} )
        expect(last_added_property.type).to eq('house')
        expect(last_added_property.rent).to eq('$700')
        expect(last_added_property.landlord.first_name).to eq('Sandy')
    end

    it "it should update weekly rent" do
        property_list.update_rent(last_added_property.property_id, "$500")
        expect(last_added_property.rent).to eq('$500')
    end

    it 'it should update tenant name' do
        property_list.update_tenant(last_added_property.property_id, "Yan", "Liu")
        expect(last_added_property.tenant.first_name).to eq("Yan")
        expect(last_added_property.tenant.last_name).to eq("Liu")
    end
    it 'it should update landlord name' do
        property_list.update_landlord(last_added_property.property_id, "Bin", "Wang")
        expect(last_added_property.landlord.first_name).to eq("Bin")
        expect(last_added_property.landlord.last_name).to eq("Wang")
    end
end