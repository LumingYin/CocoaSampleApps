import Foundation

//for arg in CommandLine.arguments {
//    print(arg)
//}

let weather = Weather()
var location = ""

if CommandLine.arguments.count <= 1 {
    print("Usage: weather [city name]")
    weather.finished = true
} else {
    for index in 0..<CommandLine.arguments.count {
        if index != 0 {
            location += CommandLine.arguments[index] + " "
        }
    }
}

//print("The location is \(location)")

while !weather.finished {
    if !weather.apiLaunched {
        weather.getTemp(location: location)
        weather.apiLaunched = true
    }
}
