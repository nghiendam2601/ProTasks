
import Foundation

extension Date {
    var startOfDay: Date {
//        let timeZoneOffset = TimeZone.current.secondsFromGMT(for: self)
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        let components = DateComponents(hour: 23, minute: 59, second: 59)
        return Calendar.current.date(byAdding: components, to: self) ?? self
    }
    var timeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // 24-hour format        
        return dateFormatter.string(from: self)
    }
    
    var stringToDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        return formatter.string(from: self)
    }
    var stringToYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }
    var stringToWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }

}
