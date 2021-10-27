import CoreML

var stateOutput = try! MLMultiArray(shape:[400 as NSNumber], dataType: .double)

print(stateOutput)
