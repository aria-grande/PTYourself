import Foundation

class Album {
    private var inbody:[Photo]
    private var body:[Photo]
    
    init(inbody:[Photo], body:[Photo]) {
        self.inbody = inbody
        self.body = body
    }
    
    func getInbodyPhotos() -> [Photo] {
        return self.inbody
    }
    
    func getBodyPhotos() -> [Photo] {
        return self.body
    }
}