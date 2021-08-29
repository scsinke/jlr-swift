import Foundation

struct Vehicle: Decodable {
    var vin: String
}

extension Vehicle: Identifiable {
    var id: String { return vin }
}
