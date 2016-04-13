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
    
    func addBodyPhoto(bodyPhoto:Photo) {
        body.append(bodyPhoto)
    }
}