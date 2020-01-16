import Foundation
import BDN

public class DocumentRepository {

    let EOL = "\n"  // the POSIX end of line character

    public func writeCitation(credentials: Credentials, name: String, citation: Citation) {
        let credentialsString = "\"\(EOL)" + credentials.format(level: 0) + "\(EOL)\""
        let body = citation.format(level: 0)
        sendRequest(credentials: credentialsString, method: "POST", type: "citations", identifier: name, version: nil, body: body)
    }

    public func writeDocument(credentials: Credentials, document: Document) {
        let credentialsString = "\"\(EOL)" + credentials.format(level: 0) + "\(EOL)\""
        let tag = document.content.tag
        let version = document.content.version
        let body = document.format(level: 0)
        sendRequest(credentials: credentialsString, method: "POST", type: "documents", identifier: tag, version: version, body: body)
    }

    func sendRequest(credentials: String, method: String, type: String, identifier: String, version: String?, body: String?) {

        // setup the request URI
        let resource = "https://bali-nebula.net/\(type)/\(identifier)" + (version == nil ? "" : "/\(version!)")
        guard let url = URL(string: resource) else {
            print("An invalid URL was used: \(resource)")
            return
        }

        // encode the credentials
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: ";,/?:@&=+$-_.!~*'()#")
        let encodedCredentials = credentials.addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)!

        // setup the request content
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("ArmorD App/v2 (Swift/v5) Bali Nebula/v2", forHTTPHeaderField: "User-Agent")
        request.addValue(encodedCredentials, forHTTPHeaderField: "Nebula-Credentials")
        request.addValue("application/bali", forHTTPHeaderField: "Accept")
        if body != nil {
            let data = body!.data(using: .utf8)!
            let length = String(data.count)
            request.httpBody = data
            request.addValue("application/bali", forHTTPHeaderField: "Content-Type")
            request.addValue(length, forHTTPHeaderField: "Content-Length")
        }

        // send the request
        let task = URLSession.shared.dataTask(with: request)
        task.resume()

    }

}
