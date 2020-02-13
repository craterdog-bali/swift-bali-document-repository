import XCTest
import BDN

@testable import Repository

let account = formatter.generateTag()
let publicKey = formatter.generateKey()

final class RepositoryTests: XCTestCase {
    var certificateCitation: Citation?

    func testCertificate() {
        let signature = formatter.generateSignature()
        let certificate = Document(account: account, content: Certificate(publicKey: publicKey), signature: signature)
        let tag = certificate.content.tag
        let version = certificate.content.version
        let digest = formatter.generateDigest()
        certificateCitation = Citation(tag: tag, version: version, digest: digest)
        let credentials = Document(account: account, content: Credentials(), certificate: certificateCitation, signature: signature)
        repository.writeDocument(credentials: credentials, digest: digest, document: certificate)
        let name = "/bali/test/certificate"
        repository.writeCitation(credentials: credentials, name: name, version: version, citation: certificateCitation!)
    }

    func testTransaction() {
        let signature = formatter.generateSignature()
        let transaction = Document(account: account, content: Transaction(merchant: "Starbucks", amount: "$4.95"), certificate: certificateCitation, signature: signature)
        let tag = transaction.content.tag
        let version = transaction.content.version
        let digest = formatter.generateDigest()
        let transactionCitation = Citation(tag: tag, version: version, digest: digest)
        let credentials = Document(account: account, content: Credentials(), certificate: certificateCitation, signature: signature)
        repository.writeDocument(credentials: credentials, digest: digest, document: transaction)
        let name = "/bali/test/transaction"
        repository.writeCitation(credentials: credentials, name: name, version: version, citation: transactionCitation)
    }

    static var allTests = [
        ("Test storing of a certificate", testCertificate),
        ("Test storing of a transaction", testTransaction)
    ]
}
