import Foundation

class Root {
    
    private var bodyInformation:Body
    private var exerciseList:[Exercise]
    private var records:[Record]
    private var bodyHistoryPhotos:Album
    
    static let sharedInstance = Root()

    init() {
        self.exerciseList = []
        self.records = []
        self.bodyInformation = Body()
        self.bodyHistoryPhotos = Album()
    }
    
    init(exerciseList:[Exercise], records:[Record], bodyHistoryPhotos:Album, bodyInformation:Body) {
        self.exerciseList = exerciseList
        self.records = records
        self.bodyHistoryPhotos = bodyHistoryPhotos
        self.bodyInformation = bodyInformation
    }
    
    func addExercise(exercise:Exercise) {
        exerciseList.append(exercise)
    }
    
    func getExerciseList() -> [Exercise] {
        return self.exerciseList
    }
    
    func addRecord(record:Record) {
        records.append(record)
    }
    
    func getRecords() -> [Record] {
        return self.records
    }
    
    func setBodyHistoryPhotos(bodyHistoryPhotos:Album) {
        self.bodyHistoryPhotos = bodyHistoryPhotos
    }
    
    func getBodyHistoryPhotos() -> Album {
        return self.bodyHistoryPhotos
    }
    
    func setBodyInformation(bodyInformation:Body) {
        self.bodyInformation = bodyInformation
    }
    
    func getBodyInformation() -> Body {
        return self.bodyInformation
    }
}