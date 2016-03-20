import Foundation

class Root {
    
    private var bodyInformation:Body
    
    /* for first tab [Exercise Record] */
    private var exerciseList:[Exercise]
    private var records:[Record]
    
    /* for second tab [Body History] */
    private var bodyHistoryPhotos:Album
    
    init(exerciseList:[Exercise], records:[Record], bodyHistoryPhotos:Album, bodyInformation:Body) {
        self.exerciseList = exerciseList
        self.records = records
        self.bodyHistoryPhotos = bodyHistoryPhotos
        self.bodyInformation = bodyInformation
    }
    
    func getExerciseList() -> [Exercise] {
        return self.exerciseList
    }
    
    func getRecords() -> [Record] {
        return self.records
    }
    
    func getBodyHistoryPhotos() -> Album {
        return self.bodyHistoryPhotos
    }
    
    func getBodyInformation() -> Body {
        return self.bodyInformation
    }
    
}