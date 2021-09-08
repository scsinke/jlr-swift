import Foundation
import MapKit

protocol JLRLocationService {
    func fetchAddressInformatation(accessToken: String, deviceID: String, loc: CLLocationCoordinate2D) async throws -> Location
}

public struct LocationService: JLRLocationService {
    func fetchAddressInformatation(accessToken: String, deviceID: String, loc: CLLocationCoordinate2D) async throws -> Location {
        
        guard let url = URL(string: "\(URLHost.IF9)/jlr/geocode/reverse/\(loc.latitude)/\(loc.longitude)/en") else {
            throw APIError.invalidEndpoint
        }
        
        var req = URLRequest(url: url)
        
        req.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization":"Bearer \(accessToken)",
            "X-Device-Id": deviceID,
        ]
        
        let (data, _) = try await URLSession.shared.data(for: req)
        
        return try JSONDecoder().decode(Location.self, from: data)
    }
}
