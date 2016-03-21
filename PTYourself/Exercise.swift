import Foundation

class Exercise {
    private var name:String
    private var did:Bool
    
    init() {
        self.name = ""
        self.did = false
    }
    
    init(name:String, did:Bool) {
        self.name = name
        self.did = did
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getDid() -> Bool {
        return self.did
    }
}