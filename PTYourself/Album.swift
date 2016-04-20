import Foundation
import RealmSwift

class Album:Object {
    let inbody = List<Photo>()
    let body = List<Photo>()
    
    convenience init(inbody:Photo, body:Photo) {
        self.init()
        addInbodyPhoto(inbody)
        addBodyPhoto(body)
    }
    
    func addInbodyPhoto(inbodyPhoto:Photo) {
        inbody.append(inbodyPhoto)
    }
    
    func removeBodyPhoto(bodyPhoto:Photo) {
        if let index = body.indexOf(bodyPhoto) {
            body.removeAtIndex(index)
        }
    }
    
    func removeInbodyPhoto(inbodyPhoto:Photo) {
        if let index = inbody.indexOf(inbodyPhoto) {
            inbody.removeAtIndex(index)
        }
    }
    
    func addBodyPhoto(bodyPhoto:Photo) {
        body.append(bodyPhoto)
    }
}