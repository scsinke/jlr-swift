import Foundation


struct URLHost: RawRepresentable {
    var rawValue: String
}

extension URLHost {
    static var IFAS: Self {
        URLHost(rawValue: "https://ifas.prod-row.jlrmotor.com/ifas/jlr")
    }
    
    static var IF9: Self {
        URLHost(rawValue: "https://if9.prod-row.jlrmotor.com/if9/jlr")
    }
    
    static var IFOP: Self {
        URLHost(rawValue: "https://ifop.prod-row.jlrmotor.com/ifop/jlr")
    }
}
