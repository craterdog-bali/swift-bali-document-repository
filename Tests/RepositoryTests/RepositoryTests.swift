import XCTest
import BDN

@testable import Repository

let account = formatter.generateTag()
let publicKey = formatter.generateKey()
let signature = formatter.generateSignature()
let digest = formatter.generateDigest()
let credentials = Credentials()
var certificateCitation: Citation?

final class RepositoryTests: XCTestCase {
    func testCertificate() {
        let content = Certificate(publicKey: publicKey)
        let name = "/bali/demo/certificate"
        let tag = content.tag
        let version = content.version
        let certificate = Document(account: account, content: content, certificate: nil, signature: signature)
        certificateCitation = Citation(tag: tag, version: version, digest: digest)
        repository.writeDocument(credentials: credentials, document: certificate)
        repository.writeCitation(credentials: credentials, name: name, version: version, citation: certificateCitation!)
    }

    func testTransaction() {
        let content = Transaction(merchant: "Starbucks", amount: "$4.95")
        let name = "/bali/demo/transaction"
        let tag = content.tag
        let version = content.version
        let transaction = Document(account: account, content: content, certificate: certificateCitation, signature: signature)
        let citation = Citation(tag: tag, version: version, digest: digest)
        repository.writeDocument(credentials: credentials, document: transaction)
        repository.writeCitation(credentials: credentials, name: name, version: version, citation: citation)
    }

    static var allTests = [
        ("Test storing of a certificate", testCertificate),
        ("Test storing of a transaction", testTransaction)
    ]
}
