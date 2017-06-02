import Foundation
import RealmSwift

class Album:Object {
    var inbody = List<Photo>()
    var body = List<Photo>()
    
    convenience init(inbody:Photo, body:Photo) {
        self.init()
        addInbodyPhoto(inbody)
        addBodyPhoto(body)
    }
    
    func addInbodyPhoto(_ inbodyPhoto:Photo) {
        inbody.append(inbodyPhoto)
    }
    
    func removeBodyPhoto(_ bodyPhoto:Photo) {
        if let index = body.index(of: bodyPhoto) {
            body.remove(at: index)
        }
    }
    
    func removeInbodyPhoto(_ inbodyPhoto:Photo) {
        if let index = inbody.index(of: inbodyPhoto) {
            inbody.remove(at: index)
        }
    }
    
    func addBodyPhoto(_ bodyPhoto:Photo) {
        body.append(bodyPhoto)
    }
}
