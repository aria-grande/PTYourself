import Foundation

class Photo {
    private var date:NSDate
    private var description:String
    private var src:String
    
    init() {
        self.date = NSDate()
        self.description = ""
        self.src = ""
    }
    
    init(date:NSDate, description:String, src:String) {
        self.date = date
        self.description = description
        self.src = src
    }
    
    func getDate() -> NSDate {
        return self.date
    }
    
    func getDescription() -> String {
        return self.description
    }
    
    func getSrc() -> String {
        return self.src
    }
}
