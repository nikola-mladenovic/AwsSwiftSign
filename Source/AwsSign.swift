import Foundation
import CryptoSwift

public extension URLRequest {
    private static let kHMACShaTypeString = "AWS4-HMAC-SHA256"
    private static let kAWS4Request = "aws4_request"
    private static let kAllowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "\\-_.~"))

    private static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyyMMdd'T'HHmmssXXXXX"
        return formatter
    }()
    private var currentIso8601Date: (full: String, short: String) {
        let date = URLRequest.iso8601Formatter.string(from: Date())
        let index = date.index(date.startIndex, offsetBy: 8)
        let shortDate = date.substring(to: index)
        return (full: date, short: shortDate)
    }

    public mutating func sign(accessKeyId: String, secretAccessKey: String) throws {
        guard let url = url, let host = url.host, let method = httpMethod else { throw SignError.generalError(reason: "URLRequest doesn't have a proper URL") }
        let hostComponents = host.components(separatedBy: ".")
        guard hostComponents.count > 3 else { throw SignError.generalError(reason: "Incorrect host format. The host should contain service name and region, e.g sns.us-east-1.amazonaws.com") }

        let serviceName = hostComponents[0]
        let awsRegion = hostComponents[1]

        var body = ""
        if let bodyData = httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            body = bodyString
        }

        let date = currentIso8601Date

        addValue(host, forHTTPHeaderField: "Host")
        addValue(date.full, forHTTPHeaderField: "X-Amz-Date")

        let headers = allHTTPHeaderFields ?? [:]

        let signedHeaders = headers.map{ $0.key.lowercased() }.sorted().joined(separator: ";")

        var urlComponents = URLComponents(string: url.absoluteString)
        urlComponents?.queryItems = URLComponents(string: url.absoluteString)?.queryItems?.sorted { $0.name < $1.name }.map {
            let percentEncodedName = $0.name.addingPercentEncoding(withAllowedCharacters: URLRequest.kAllowedCharacters) ?? $0.name
            let percentEncodedValue = $0.value?.addingPercentEncoding(withAllowedCharacters: URLRequest.kAllowedCharacters) ?? $0.value
            return URLQueryItem(name: percentEncodedName, value: percentEncodedValue)
        }
        let queryString = urlComponents?.query ?? ""

        let canonicalRequestHash = [method, url.path == "" ? "/" : url.path, queryString,
                                    headers.map{ $0.key.lowercased() + ":" + $0.value }.sorted().joined(separator: "\n"),
                                    "", signedHeaders, body.sha256()].joined(separator: "\n").sha256()
        let credentials = [date.short, awsRegion, serviceName, URLRequest.kAWS4Request].joined(separator: "/")
        let stringToSign = [URLRequest.kHMACShaTypeString, date.full, credentials, canonicalRequestHash].joined(separator: "\n")

        let signature = try [date.short, awsRegion, serviceName, URLRequest.kAWS4Request, stringToSign].reduce([UInt8]("AWS4\(secretAccessKey)".utf8), {
            try HMAC(key: $0, variant: .sha256).authenticate([UInt8]($1.utf8))
        }).toHexString()

        let authorization = URLRequest.kHMACShaTypeString + " Credential=" + accessKeyId + "/" + credentials + ", SignedHeaders=" + signedHeaders + ", Signature=" + signature
        addValue(authorization, forHTTPHeaderField: "Authorization")
    }
}

public enum SignError: Error {
    case generalError(reason: String?)
}

extension SignError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .generalError(let reason):
            return "Signing failed! " + (reason ?? "No failure reason available")
        }
    }
    public var localizedDescription: String {
        return errorDescription!
    }
}