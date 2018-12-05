import UIKit

enum EventType {
    case beginsShift
    case fallsAsleep
    case wakesUp
}

func getTimestamp(_ record: String) -> String {
    let start = record.index(record.startIndex, offsetBy: 1)
    let end = record.index(record.startIndex, offsetBy: 17)
    return String(record[start..<end])
}

func getEventType(_ record: String) -> EventType {
    if record.range(of: "falls asleep") != nil {
        return .fallsAsleep
    } else if record.range(of: "wakes up") != nil {
        return .wakesUp
    }

    return .beginsShift
}

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!)
var records = input.components(separatedBy: "\n")
records.removeLast()

let sortedRecords = records.sorted(by: {
    return getTimestamp($0) < getTimestamp($1)
})


// [GuardId : [ Minute : TimesAsleep ]
var sleepTracker: [Int : [Int : Int]] = [:]

var guardOnDuty: Int = 0
var sleepTime: Int = 0
var wakeTime: Int = 0
var i = 0

while i < sortedRecords.count {
    let record = sortedRecords[i]

    switch(getEventType(sortedRecords[i])) {
    case .beginsShift:
        guardOnDuty = Int(record.components(separatedBy: CharacterSet.decimalDigits.inverted)[14])!
    case .fallsAsleep:
        sleepTime = Int(record.components(separatedBy: CharacterSet.decimalDigits.inverted)[5])!
    case .wakesUp:
        wakeTime = Int(record.components(separatedBy: CharacterSet.decimalDigits.inverted)[5])!
        for min in sleepTime..<wakeTime {
            sleepTracker[guardOnDuty, default: [:]][min, default: 0] += 1
        }
    }

    i += 1
}

// Part 1
var maxGuardId = -1
var mostMinutes = -1

// Part 2
var mostFrequentGuard = -1
var mostFrequentMax = -1
var mostFrequentMinute = -1

for (id, minutes) in sleepTracker {
    var totalMinutes = 0
    for (minute, count) in minutes {
        totalMinutes += count

        if count > mostFrequentMax {
            mostFrequentMax = count
            mostFrequentMinute = minute
            mostFrequentGuard = id
        }
    }
    if totalMinutes > mostMinutes {
        mostMinutes = totalMinutes
        maxGuardId = id
    }
}

let mostLikelyMinute = sleepTracker[maxGuardId]?.max(by: {
    $0.value < $1.value
})

print("Guard: \(maxGuardId), in minute: \(mostLikelyMinute?.key)")
print("Answer: \(maxGuardId * mostLikelyMinute!.key)")
print("Part 2: Guard \(mostFrequentGuard) in minute \(mostFrequentMinute), result: \(mostFrequentGuard * mostFrequentMinute)")
