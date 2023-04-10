import Combine
import Foundation

public extension Networking {
    typealias Logger = (String) -> Void
}

extension URLRequest {
    func curl(formatted: Bool = false) -> String {
        var data = ""
        let complement = formatted ? "\\\n" : ""
        let method = "-X \(httpMethod ?? "GET") \(complement)"
        let url = "\"" + (url?.absoluteString ?? "") + "\""

        var header = ""

        if let httpHeaders = allHTTPHeaderFields?.sorted(by: { element1, element2 -> Bool in
            element1.key > element2.key
        }) {
            for (key, value) in httpHeaders {
                header += "-H \"\(key): \(value)\" \(complement)"
            }
        }

        if let bodyData = httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            data = "-d \'\(bodyString)\' \(complement)"
        }

        let command = "curl -i " + complement + method + header + data + url
        return command
    }

    func contents() -> String {
        formattedContents()
    }

    private func formattedContents() -> String {
        """
        -------- Request created --------
        \(curl(formatted: true))
        ---------------------------------
        """
    }
}

extension URLResponse {
    /// Returns contents of the response as string.
    func contents(of data: Data?) -> String {
        formattedContents(with: data, statusCode: httpStatusCode)
    }

    /// Returns contents as formatted string.
    private func formattedContents(with data: Data?, statusCode: HTTPStatusCode?) -> String {
        """
        -------- Response received --------
        Status code: \(statusCode?.localizedDescription ?? "-1")
        Path: \(url?.absoluteString ?? "")
        Body: \(data?.prettyPrintedJSONString ?? "")
        -----------------------------------
        \n\n
        """
    }
}

extension Data {
    /// Produces pretty printed from data from json string
    var prettyPrintedJSONString: CustomStringConvertible {
        let dictionary = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any] ?? [:]
        return dictionary ?? [:]
    }

    /// Produces non formatted json string.
    var jsonString: CustomStringConvertible {
        String(data: self, encoding: .utf8) ?? "N/A"
    }
}
