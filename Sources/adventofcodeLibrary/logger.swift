
class Logger {
    enum Level : Int, Comparable {
        case Verbose = 0
        case Debug
        case Info
        case severe

        // Implement Comparable
        public static func < (left: Level, right: Level) -> Bool {
            return left.rawValue < right.rawValue
        }
    }

    static var level : Level = Level.Info

    static func Verbose(_ message: String) {
        if level <= Level.Verbose {
            print(message)
        }
    }

    static func Debug(_ message: String) {
        if level <= Level.Debug {
            print(message)
        }
    }

    static func Info(_ message: String) {
        if level <= Level.Info {
            print(message)
        }
    }



}
