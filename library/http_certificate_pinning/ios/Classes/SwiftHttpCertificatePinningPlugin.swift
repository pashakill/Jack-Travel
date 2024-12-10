import Flutter
import UIKit
import CryptoSwift
import Alamofire

public class SwiftHttpCertificatePinningPlugin: NSObject, FlutterPlugin {

    var fingerprints: [String]?
    var flutterResult: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "http_certificate_pinning", binaryMessenger: registrar.messenger())
        let instance = SwiftHttpCertificatePinningPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "check":
            if let args = call.arguments as? [String: AnyObject] {
                self.check(call: call, args: args, flutterResult: result)
            } else {
                result(
                    FlutterError(
                        code: "Invalid Arguments",
                        message: "Please specify arguments",
                        details: nil
                    )
                )
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func check(
        call: FlutterMethodCall,
        args: [String: AnyObject],
        flutterResult: @escaping FlutterResult
    ) {
        guard let urlString = args["url"] as? String,
              let headers = args["headers"] as? [String: String],
              let fingerprints = args["fingerprints"] as? [String],
              let type = args["type"] as? String else {
            flutterResult(
                FlutterError(
                    code: "Params incorrect",
                    message: "The parameters are incorrect",
                    details: nil
                )
            )
            return
        }

        self.fingerprints = fingerprints

        var timeout = 60
        if let timeoutArg = args["timeout"] as? Int {
            timeout = timeoutArg
        }

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(timeout)

        let sessionDelegate = CertificatePinningDelegate(fingerprints: fingerprints, type: type, flutterResult: flutterResult)
        let session = URLSession(configuration: configuration, delegate: sessionDelegate, delegateQueue: nil)

        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                flutterResult(
                    FlutterError(
                        code: "URL Format",
                        message: error.localizedDescription,
                        details: nil
                    )
                )
            } else if let _ = data {
                // Handle the success case here if needed
            }
        }.resume()
    }
}

class CertificatePinningDelegate: NSObject, URLSessionDelegate {

    var fingerprints: [String]
    var type: String
    var flutterResult: FlutterResult

    init(fingerprints: [String], type: String, flutterResult: @escaping FlutterResult) {
        self.fingerprints = fingerprints
        self.type = type
        self.flutterResult = flutterResult
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust,
              let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            flutterResult(
                FlutterError(
                    code: "ERROR CERT",
                    message: "Invalid Certificate",
                    details: nil
                )
            )
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        let policies = [SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString)]
        SecTrustSetPolicies(serverTrust, policies as CFTypeRef)

        var result: SecTrustResultType = .invalid
        SecTrustEvaluate(serverTrust, &result)
        let isServerTrusted = (result == .unspecified || result == .proceed)

        let serverCertData = SecCertificateCopyData(certificate) as Data
        var serverCertSha = serverCertData.sha256().toHexString()

        if type.uppercased() == "SHA1" {
            serverCertSha = serverCertData.sha1().toHexString()
        }

        let isSecure = fingerprints.contains { $0.replacingOccurrences(of: " ", with: "").caseInsensitiveCompare(serverCertSha) == .orderedSame }

        if isServerTrusted && isSecure {
            flutterResult("CONNECTION_SECURE")
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            flutterResult(
                FlutterError(
                    code: "CONNECTION_NOT_SECURE",
                    message: nil,
                    details: nil
                )
            )
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
