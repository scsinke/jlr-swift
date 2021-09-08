import Foundation

struct Location: Decodable {
    var formattedAddress: String
    var street: String
    var streetNumber: String
    var postalcode: String
    var city: String
    var citycode: String
    var region: String
    var regionCode: String
    var country: String
    var countryCodeISO2: String
    var province: String
    var district: String
    var telephoneAreaCode: String
    var additionalInfo: String
    var provinceAdcode: String
    var cityAdcode: String
    var districtAdcode: String
    var adcode: String
    var any: String
}
