import Foundation

enum DataSetType: String, CaseIterable, Identifiable {
    case small = "Small Set (20)"
    case large = "Large Set (100)"
    case sorted = "Sorted (100)"
    case reversed = "Reversed (100)"
    case random = "Random (100)"
    
    var id: String { rawValue }
    
    func generateData() -> [Int] {
        switch self {
        case .small:
            return [27,8,12,54,32,42,32,34,27,14,36,9,28,35,5,41,78,11,14]
        case .large:
            return [27,8,2,54,32,42,32,54,97,14,96,9,28,35,5,41,78,11,14,96,1,18,73,91,79,65,28,80,98,99,11,19,65,78,61,31,64,41,98,10,69,99,4,62,60,11,85,26,64,25,2,77,97,52,90,76,50,72,73,46,100,16,29,52,63,5,61,71,47,89,15,36,28,83,67,46,71,10,94,77,88,71,44,71,77,13,32,54,67,73,92,42,21,35,39,22,29,58,42,15]
        case .sorted:
            return Array(1...100)
        case .reversed:
            return Array((1...100).reversed())
        case .random:
            return (1...100).map { _ in Int.random(in: 1...100) }
        }
    }
}
