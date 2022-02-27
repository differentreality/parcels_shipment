#!/usr/bin/ruby
require 'csv'
require 'ostruct'

csv = CSV.parse(File.read('samples/input_sample.csv'), headers: true, converters: :numeric)

# CSV row sample:
# {"parcel_ref"=>"VIA-1ADFB816", "client_name"=>"Bayer Hoeger and McClure", "weight"=>12}
# [#<OpenStruct parcel_ref="VIA-1ADFB816", client_name="Bayer Hoeger and McClure", weight=12>]
csv_input = csv.map(&:to_h).map{ |r| OpenStruct.new r }

# { 'client name' => [struct_parcel1, struct_parcel2] }
# { "Gleichner Inc" => [
#           #<OpenStruct parcel_ref="VIA-B898250D", client_name="Gleichner Inc", weight=12>,
#           #<OpenStruct parcel_ref="VIA-79AC5CB5", client_name="Gleichner Inc", weight=10>] }
csv_groupped = csv_input.group_by(&:client_name)

# Number of parcels per client
# csv_groupped.map{ |k, v| [k, v.count] }.sort_by{ |k, v| k }.to_h

# Confirm if any client parcels are higher than shipment limit
# csv_groupped.map{ |k, v| [k, v.sum(&:weight)] }.to_h.any?{ |k, v| v > 2311 }

# How much weight per client (in descending order)
weight_per_client = csv_groupped.map{ |k, v| [k, v.sum(&:weight)] }.sort_by{ |k, v| -v }.to_h

# [
#   { shipment_weight: 2310, shipment_contents: { 'client 10' => 2000, 'client 3': 310 } },  # This is one shipment
#   { shipment_weight: 450, shipment_contents: { 'client 4' => 100, 'client 20' => 350 } } # This is another shipment
# ]
shipments = [{ shipment_weight: 0, shipment_contents: {} }]

max_shipment_weight = 2311

# Parcels of a client, all go into one shipment
weight_per_client.each do |client_name, client_weight|
  # If client weight fits into shipment, add client's parcels into shipment
  available_shipment = shipments.find{ |shipment| (shipment[:shipment_weight] + client_weight) <= max_shipment_weight }

  if available_shipment
    available_shipment[:shipment_contents][client_name] = client_weight
    available_shipment[:shipment_weight] += client_weight
  else
    # if client's parcels don't fit in any shipment, create new shipment
    shipments << { shipment_weight: client_weight, shipment_contents: { client_name => client_weight } }
  end
end

# Smallest number of possible shipments (not necessarily feasible)
# weight_per_shipment = shipments.collect{ |shipment| shipment[:shipment_weight] } # => [2311, 2188, 2262, 2291, 1855]
# weight_per_shipment.sum/2311.0

CSV.open('output-script.csv', 'w') do |csv_output|
  output_headers = csv.headers << 'shipment_ref'

  csv_output << output_headers
  csv.each do |row|
    shipment_ref = '(not found)'
    # Find index of shipments array, for item (shipment) that includes client's parcels
    # shipment reference number is the array index of shipments
    # Client name is case sensitive!
    # row[1] is the client name
    client_shipment_index = shipments.index{ |shipment| shipment[:shipment_contents].key?(row[1]) }
    shipment_ref = client_shipment_index + 1 if client_shipment_index

    csv_output << (row.fields + ["shipment #{shipment_ref}"])
  end
end
