import Foundation

struct User: Decodable {
    var userId: String
    var loginName: String
    var homeMarket: String
    var userType: String
    var nextOfKin: String
    var secureQuestion1: String
    var secureQuestion2: String
    var secureQuestion3: String
    var marketingPrefsUpdatedAt: Date
    var marketingOffersAccepted: Bool
    var vhsMessagesAccepted: Bool
    var contact: Contact
    var homeAddress: Address
}

extension User: Identifiable {
    var id: String { return userId }
}

struct Contact: Decodable {
    var userPreferences: UserPreference
    var firstName: String
    var middleName: String
    var lastName: String
    var title: String
    var gender: String
    var birthday: String
    var emailAddress: String
    var homePhone: String
    var businessPhone: String
    var mobilePhone: String
}

struct Address: Decodable {
    var street: String
    var city: String
    var zipCode: String
    var stateProvince: String
    var country: String
    var addressLine1: String
    var addressLine2: String
}

struct UserPreference: Decodable {
    var timeZone: String
    var unitsOfMeasurement: String
    var dateFormat: String
    var language: String
}
