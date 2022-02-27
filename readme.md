For a given CSV file with client parcels, fit parcels into shipments. Implemenation of first-fit-decreasing bin packing algorithm to avoid computational complexity.

**Assumptions**
1. All parcels of client is included in one shipment
2. Shipment max weight is 2311 kg
3. No parcel weight is more than shipment max weight

# How to run
Run `./script.rb` from inside the project folder, and it will output a new file named `output-script.csv`

The results from running this with the sample input csv file can be found in `samples/output-script.csv`

# Results
## Client distribution in shipments
`shipments.map.with_index{ |s, index| { shipment_ref: index+1, shipment_clients: s[:shipment_contents].count, shipment_weight: s[:shipment_weight], shipment_contents: s[:shipment_contents] } }`

```
{:shipment_ref=>1,
 :shipment_clients=>2,
 :shipment_weight=>2311,
 :shipment_contents=>{"Hoppe Waelchi and Doyle"=>1262,
                      "Kertzmann Group"=>1049} }
{:shipment_ref=>2,
 :shipment_clients=>2,
 :shipment_weight=>2188,
 :shipment_contents=>{"Ruecker Collins and Langworth"=>1227,
                      "Schumm Beatty and Goldner"=>961}}
{:shipment_ref=>3,
 :shipment_clients=>3,
 :shipment_weight=>2262,
 :shipment_contents=>{"Krajcik-Beer"=>945,
                      "Powlowski-Grant"=>667,
                      "Pagac Bednar and Schmeler"=>650}}
{:shipment_ref=>4,
 :shipment_clients=>4,
 :shipment_weight=>2291,
 :shipment_contents=>{"Hegmann Larkin and Hodkiewicz"=>621,
                      "OKon-Turcotte"=>567,
                      "Donnelly Buckridge and Homenick"=>567,
                      "Bayer Hoeger and McClure"=>536}}
{:shipment_ref=>5,
 :shipment_clients=>4,
 :shipment_weight=>1855,
 :shipment_contents=>{"Fadel Inc"=>564,
                      "Dickinson Group"=>560,
                      "Goldner and Sons"=>419,
                      "Gleichner Inc"=>312}}
```

## Number of parcels per client
```
{ "Bayer Hoeger and McClure"=>48,
  "Dickinson Group"=>53,
  "Donnelly Buckridge and Homenick"=>58,
  "Fadel Inc"=>55,
  "Gleichner Inc"=>35,
  "Goldner and Sons"=>44,
  "Hegmann Larkin and Hodkiewicz"=>56,
  "Hoppe Waelchi and Doyle"=>100,
  "Kertzmann Group"=>101,
  "Krajcik-Beer"=>90,
  "OKon-Turcotte"=>50,
  "Pagac Bednar and Schmeler"=>59,
  "Powlowski-Grant"=>58,
  "Ruecker Collins and Langworth"=>108,
  "Schumm Beatty and Goldner"=>85 }
```

## How much weight per client (in descending order)
```
{ "Hoppe Waelchi and Doyle"=>1262,
  "Ruecker Collins and Langworth"=>1227,
  "Kertzmann Group"=>1049,
  "Schumm Beatty and Goldner"=>961,
  "Krajcik-Beer"=>945,
  "Powlowski-Grant"=>667,
  "Pagac Bednar and Schmeler"=>650,
  "Hegmann Larkin and Hodkiewicz"=>621,
  "OKon-Turcotte"=>567,
  "Donnelly Buckridge and Homenick"=>567,
  "Fadel Inc"=>564,
  "Dickinson Group"=>560,
  "Bayer Hoeger and McClure"=>536,
  "Goldner and Sons"=>419,
  "Gleichner Inc"=>312 }
```
