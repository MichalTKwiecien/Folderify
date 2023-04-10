import Networking
import Foundation

// The file contains declarations of the objects shared among World's components.
// Use them directly in the services, repositories etc.
// They must stay internal!

let httpApiClient: HTTPClient = DefaultHTTPClient(
    baseURL: URL(safe: "http://163.172.147.216:8080"),
    networkTrafficLogger: consoleLog // Use `consoleLog` to see responses in the console
)
