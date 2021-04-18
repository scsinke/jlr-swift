import Foundation
import Combine

extension URLSession {
    func publisher<T: Decodable>(
        for request: URLRequest,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<T, Error> {
        return dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
