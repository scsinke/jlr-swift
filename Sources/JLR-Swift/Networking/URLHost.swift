import Foundation


struct URLHost: RawRepresentable {
    var rawValue: String
}

extension URLHost {
    static var IFAS: Self {
        URLHost(rawValue: "https://ifas.prod-row.jlrmotor.com/ifas/jlr")
    }
}
