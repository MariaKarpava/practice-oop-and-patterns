// Polymorthism

class A {
    func f1() {
        print("Called f1 implementation from A")
    }
}


class B: A {
    override func f1() {
        print("Called f1 implementation from B")
//        super.f1()
    }
    
    func f2() {
      print("Called f2")
    }
}


let a: A = A()
let b: B = B()
let x: A = B()

//a.f1()
//b.f1()
//x.f1()

//"Called f1 implementation from A"
//"Called f1 implementation from B"
//"Called f1 implementation from B"


// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --



class Container {
    let id: String
    let costDollarCents: Int
    let description: String
    
    init(id: String, costDollarCents: Int, description: String) {
        self.id = id
        self.costDollarCents = costDollarCents
        self.description = description
  }
}


class SparePartsContainer: Container {
}

class CarContainer: Container {
}

class LiquidsContainer: Container {
}


class Storage {
    let location: String
    let contentType: String
    let maxCapacity: Int
    var containers: [Container] {
        fatalError("Implement this method in a child")
    }
    
    init(location: String, contentType: String, maxCapacity: Int) {
        self.location = location
        self.contentType = contentType
        self.maxCapacity = maxCapacity
    }
    
    func addContainer(_ container: Container) {
        fatalError("Implement this method in a child")
    }

    
}



class SparePartsStorage: Storage {
    private var sparePartsContainers: [SparePartsContainer]
    
    override init(location: String, contentType: String, maxCapacity: Int) {
        
        self.sparePartsContainers = []
        
        super.init(location: location, contentType: contentType, maxCapacity: maxCapacity)
    }
    
    override var containers: [Container] {
        return sparePartsContainers
    }
    
    override func addContainer(_ container: Container) {
        if let sparePartsContainer = container as? SparePartsContainer {
            sparePartsContainers.append(sparePartsContainer)
        }
    }
}
    
    
    


class CarStorage: Storage {
    private var carContainers: [CarContainer]
    
    override init(location: String, contentType: String, maxCapacity: Int) {
        
        self.carContainers = []
        
        super.init(location: location, contentType: contentType, maxCapacity: maxCapacity)
    }
    
    override var containers: [Container] {
        return carContainers
    }
    
    override func addContainer(_ container: Container) {
        if let carContainer = container as? CarContainer {
            carContainers.append(carContainer)
        }
    }
}





class LiquidsStorage: Storage {
    private var liquidsContainers: [LiquidsContainer]
    
    override init(location: String, contentType: String, maxCapacity: Int) {
        
        self.liquidsContainers = []
        
        super.init(location: location, contentType: contentType, maxCapacity: maxCapacity)
    }
    
    override var containers: [Container] {
        return liquidsContainers
    }
    
    override func addContainer(_ container: Container) {
        if let liquidsContainer = container as? LiquidsContainer { // attempt cast
            liquidsContainers.append(liquidsContainer)
        }
        
        // Alternative:
        // liquidsContainers.append(container as! LiquidsContainer) // force-casting
    }
}






class AccountingDepartment {
    func containersCount(in trains: [Train]) -> Int {
        var totalCount = 0
        for train in trains {
            totalCount += train.containers.count
        }
        return totalCount
    }
    
    func containersCount(in storages: [Storage]) -> Int {
        var totalCount = 0
        for storage in storages {
            totalCount += storage.containers.count
        }
        return totalCount
    }
    
    func totalCost(of storages: [Storage]) -> Int {
        var totalCost = 0
        
        for storage in storages {
            
            let allContainersInOneStorage = storage.containers
            
            for container in allContainersInOneStorage {
                totalCost += container.costDollarCents
            }
        }
        return totalCost
    }
}





class Worker {
    let name: String
    var isBeasy: Bool {
        didSet {
            print("Worker \(name) is \(isBeasy ? "busy" : "free")")
        }
    }
    
    init(name: String, isBeasy: Bool) {
        self.name = name
        self.isBeasy = isBeasy
    }
    
    func move(what container: Container, where destination: Storage) {
        isBeasy = true
        
        destination.addContainer(container)
        
        print("Worker \(name) moved container with container id: \(container.id) to \(destination.location).")
        
        isBeasy = false
    }
}





class Train {
    let id: String
    var containers: [Container]
    
    init(id: String, containers: [Container]) {
        self.id = id
        self.containers = containers
    }
    
    func comeToPlatform() {
        print("Train \(id) moved to the platform.")
    }
    
    func leavePlatform() {
        print("Train \(id) left the platform.")
    }

}




class ControlRoom {
    var workers: [Worker]
    var trainsQueue: [Train]
    var sparePartsStorages: [SparePartsStorage]
    var carStorages : [CarStorage]
    var liquidsStorages: [LiquidsStorage]
    
    init(workers: [Worker], trainsQueue: [Train], sparePartsStorages: [SparePartsStorage], carStorages : [CarStorage], liquidsStorages: [LiquidsStorage]) {
        self.workers = workers
        self.trainsQueue = trainsQueue
        self.sparePartsStorages = sparePartsStorages
        self.carStorages = carStorages
        self.liquidsStorages = liquidsStorages
    }
    
    
    func start() {
        print("Start work.")
        
        for _ in 0...trainsQueue.count {
            processOneTrain()
        }
    }
    
    
    func stop() {
        print("Stop work.")
    }
    
    
    func getFreeWorker(_ workers: [Worker]) -> Worker? {
        var freeWorker: Worker?
        
        for worker in workers{
            if worker.isBeasy == false {
                freeWorker = worker
                break
            }
        }
        return freeWorker
    }
    
    
    func getFreeSparePartsStorage(_ sparePartsStorages: [SparePartsStorage]) -> SparePartsStorage? {
        var freeSparePartsStorage: SparePartsStorage?
        
        for sparePartsStorage in sparePartsStorages {
            if sparePartsStorage.containers.count < sparePartsStorage.maxCapacity {
                freeSparePartsStorage = sparePartsStorage
                break
            }
        }
        return freeSparePartsStorage
    }
    
    
    func getCarStorage(_ carStorages: [CarStorage]) -> CarStorage? {
        var freeCarStorage: CarStorage?
        
        for carStorage in carStorages {
            if carStorage.containers.count < carStorage.maxCapacity {
                freeCarStorage = carStorage
                break
            }
        }
        return freeCarStorage
    }
    
    
    func getLiquidsStorage(_ liquidsStorages: [LiquidsStorage]) -> LiquidsStorage? {
        var freeLiquidsStorage: LiquidsStorage?
        
        for liquidsStorage in liquidsStorages {
            if liquidsStorage.containers.count < liquidsStorage.maxCapacity {
                freeLiquidsStorage = liquidsStorage
                break
            }
        }
        return freeLiquidsStorage
    }
    
    
    
    
    func findNextTrainAndRemoveFromTheQueue() -> Train? {
        var nextTrain: Train?
        
        for train in trainsQueue {
            nextTrain = train
            trainsQueue.remove(at: 0)
            break
        }
        return nextTrain
    }
    
    
    
    func processOneTrain() {
        
        guard let nextTrain = findNextTrainAndRemoveFromTheQueue() else {
            return
        }
        
        nextTrain.comeToPlatform()
        
        var contaiersToBeRemoved = [Container]()
        
        for container in nextTrain.containers {
            if container is SparePartsContainer {
                
                var worker: Worker? = getFreeWorker(workers)
                var storage: SparePartsStorage? = getFreeSparePartsStorage(sparePartsStorages)
                
                if let worker, let storage {
                    worker.move(what: container, where: storage)
                    contaiersToBeRemoved.append(container)
                }
                
            } else if container is CarContainer {
                
                var worker: Worker? = getFreeWorker(workers)
                var storage: CarStorage? = getCarStorage(carStorages)
                
                if let worker, let storage {
                    worker.move(what: container, where: storage)
                    contaiersToBeRemoved.append(container)
                }
                
                
            } else if container is LiquidsContainer {
                var worker: Worker? = getFreeWorker(workers)
                var storage: LiquidsStorage? = getLiquidsStorage(liquidsStorages)
                
                if let worker, let storage {
                    worker.move(what: container, where: storage)
                    contaiersToBeRemoved.append(container)
                }
            }
        }
        
        nextTrain.containers = nextTrain.containers.filter { candidate in
            !contaiersToBeRemoved.contains(where: { $0 === candidate }) // !(contaiersToBeRemoved contains candidate, compairing by reference)
        }
        
        nextTrain.leavePlatform()
    }
}



// Experiments:


let allStorages = [
    LiquidsStorage(location: "101 Liquids Street, UK", contentType: "liquids", maxCapacity: 1),
    LiquidsStorage(location: "102 Liquids Street, UK", contentType: "liquids", maxCapacity: 3),
    LiquidsStorage(location: "103 Liquids Street, UK", contentType: "liquids", maxCapacity: 5),
    CarStorage(location: "201 Cars Street, UK", contentType: "cars", maxCapacity: 1),
    CarStorage(location: "202 Cars Street, UK", contentType: "cars", maxCapacity: 3),
    CarStorage(location: "203 Cars Street, UK", contentType: "cars", maxCapacity: 5),
    SparePartsStorage(location: "301 Spare Parts Street, UK", contentType: "spare parts", maxCapacity: 1),
    SparePartsStorage(location: "302 Spare Parts Street, UK", contentType: "spare parts", maxCapacity: 3),
    SparePartsStorage(location: "303 Spare Parts Street, UK", contentType: "spare parts", maxCapacity: 5),
].shuffled()

var trains = [
    Train(id: "1", containers: [
        CarContainer(id: "1", costDollarCents: 1, description: "BMW cars"),
        CarContainer(id: "2", costDollarCents: 1, description: "Audi cars"),
        CarContainer(id: "3", costDollarCents: 1, description: "Mercedes cars"),
        LiquidsContainer(id: "4", costDollarCents: 10, description: "Oil"),
        LiquidsContainer(id: "5", costDollarCents: 10, description: "Diesel"),
        LiquidsContainer(id: "6", costDollarCents: 10, description: "Petrol"),
        SparePartsContainer(id: "7", costDollarCents: 100, description: "Spare parts for BMW"),
        SparePartsContainer(id: "8", costDollarCents: 100, description: "Spare parts for Audi"),
        SparePartsContainer(id: "9", costDollarCents: 100, description: "Spare parts for Meredes"),
    ].shuffled()),
    Train(id: "2", containers: [
        CarContainer(id: "10", costDollarCents: 1, description: "BMW cars"),
        CarContainer(id: "11", costDollarCents: 1, description: "Audi cars"),
        CarContainer(id: "12", costDollarCents: 1, description: "Mercedes cars"),
        LiquidsContainer(id: "13", costDollarCents: 10, description: "Oil"),
        LiquidsContainer(id: "14", costDollarCents: 10, description: "Diesel"),
        LiquidsContainer(id: "15", costDollarCents: 10, description: "Petrol"),
        SparePartsContainer(id: "16", costDollarCents: 100, description: "Spare parts for BMW"),
        SparePartsContainer(id: "17", costDollarCents: 100, description: "Spare parts for Audi"),
        SparePartsContainer(id: "18", costDollarCents: 100, description: "Spare parts for Meredes"),
    ].shuffled()),
    Train(id: "3", containers: [
        CarContainer(id: "19", costDollarCents: 1, description: "BMW cars"),
        CarContainer(id: "20", costDollarCents: 1, description: "Audi cars"),
        CarContainer(id: "21", costDollarCents: 1, description: "Mercedes cars"),
        LiquidsContainer(id: "22", costDollarCents: 10, description: "Oil"),
        LiquidsContainer(id: "23", costDollarCents: 10, description: "Diesel"),
        LiquidsContainer(id: "24", costDollarCents: 10, description: "Petrol"),
        SparePartsContainer(id: "25", costDollarCents: 100, description: "Spare parts for BMW"),
        SparePartsContainer(id: "26", costDollarCents: 100, description: "Spare parts for Audi"),
        SparePartsContainer(id: "27", costDollarCents: 100, description: "Spare parts for Meredes"),
    ].shuffled()),
    
]


let controlRoom = ControlRoom(
    workers: [
        Worker(name: "Alice", isBeasy: false),
        Worker(name: "Bob", isBeasy: false),
        Worker(name: "Carol", isBeasy: false)
    ],
    trainsQueue: trains,
    sparePartsStorages: allStorages.filter { $0 is SparePartsStorage } as! [SparePartsStorage],
    carStorages: allStorages.filter { $0 is CarStorage } as! [CarStorage],
    liquidsStorages: allStorages.filter { $0 is LiquidsStorage } as! [LiquidsStorage]
)
let accountingDepartment = AccountingDepartment()

print("Initial State:")
print("    Cotainers waiting in trains: \(accountingDepartment.containersCount(in: trains))")
print("          Cotainers in storages: \(accountingDepartment.containersCount(in: allStorages))")
print("         Total cost in storages: \(accountingDepartment.totalCost(of: allStorages))")
print()

controlRoom.start()

print("Eventual State:")
print("    Cotainers waiting in trains: \(accountingDepartment.containersCount(in: trains))")
print("          Cotainers in storages: \(accountingDepartment.containersCount(in: allStorages))")
print("         Total cost in storages: \(accountingDepartment.totalCost(of: allStorages))")
print()


