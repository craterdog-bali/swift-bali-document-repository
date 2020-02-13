import Foundation
import BDN

public class DocumentRepository {

    let EOL = "\n"  // the POSIX end of line character

    public func writeCitation(credentials: Document, name: String, version: String, citation: Citation) {
        let credentialsString = "\(EOL)" + credentials.format() + "\(EOL)"
        let body = citation.format()
        sendRequest(credentials: credentialsString, method: "PUT", type: "names", identifier: name, version: version, digest: citation.digest, body: body)
    }

    public func writeDocument(credentials: Document, digest: [UInt8], document: Document) {
        let credentialsString = "\(EOL)" + credentials.format() + "\(EOL)"
        let tag = document.content.tag
        let version = document.content.version
        let body = document.format()
        sendRequest(credentials: credentialsString, method: "PUT", type: "documents", identifier: tag, version: version, digest: digest, body: body)
    }

    func sendRequest(credentials: String, method: String, type: String, identifier: String, version: String, digest: [UInt8], body: String?) {

        // setup the request URI
        var identifierString = identifier
        identifierString.remove(at: identifier.startIndex)
        let resource = "https://bali-nebula.net/repository/\(type)/\(identifierString)/\(version)"
        guard let url = URL(string: resource) else {
            print("An invalid URL was used: \(resource)")
            return
        }
        print("\(method): \(resource)")

        // encode the credentials
        let encodedCredentials = formatter.base32Encode(bytes: [UInt8](credentials.utf8))
        let encodedDigest = formatter.base32Encode(bytes: digest)

        // setup the request content
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("ArmorD App/v2 (Swift/v5) Bali Nebula/v2", forHTTPHeaderField: "user-agent")
        request.addValue(encodedCredentials, forHTTPHeaderField: "nebula-credentials")
        request.addValue(encodedDigest, forHTTPHeaderField: "nebula-digest")
        request.addValue("application/bali", forHTTPHeaderField: "accept")
        if body != nil {
            let data = body!.data(using: .utf8)!
            let length = String(data.count)
            request.httpBody = data
            request.addValue("application/bali", forHTTPHeaderField: "content-type")
            request.addValue(length, forHTTPHeaderField: "content-length")
        }

        // send the request
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let statusCode = (response as! HTTPURLResponse).statusCode
            guard statusCode < 300 else {
                print("Error \(statusCode)")
                semaphore.signal()
                return
            }
            print("Success \(statusCode)")
            if let data = data {
                print("\(String(describing: String(data: data, encoding: .utf8)))")
            }
            semaphore.signal()
        }.resume()
        let _ = semaphore.wait(wallTimeout: .distantFuture)
    }

}
public let repository = DocumentRepository()
