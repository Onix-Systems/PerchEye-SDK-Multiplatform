import Flutter
import UIKit
import PerchEyeFramework

public class PerchEyePlugin: NSObject, FlutterPlugin {
    private var perchEye: PerchEyeSwift?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "perch_eye_method_channel", binaryMessenger: registrar.messenger())
        let instance = PerchEyePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public override init() {
        super.init()
    }

    deinit {
        perchEye?.destroy()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            handleInit(result: result)

        case "destroy":
            handleDestroy(result: result)

        case "openTransaction":
            handleOpenTransaction(result: result)

        case "addImage":
            handleAddImage(call: call, result: result)

        case "addImageRaw":
            handleAddImageRaw(call: call, result: result)

        case "enroll":
            handleEnroll(result: result)

        case "verify":
            handleVerify(call: call, result: result)

        case "evaluate":
            handleEvaluate(call: call, result: result)

        case "compareList":
            handleCompareList(call: call, result: result)

        case "compareFaces":
            handleCompareFaces(call: call, result: result)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleInit(result: @escaping FlutterResult) {
        perchEye = PerchEyeSwift()
        result(nil)
    }

    private func handleDestroy(result: @escaping FlutterResult) {
        perchEye?.destroy()
        perchEye = nil
        result(nil)
    }

    private func handleOpenTransaction(result: @escaping FlutterResult) {
        perchEye?.openTransaction()
        result(nil)
    }

    private func handleAddImage(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let perchEye = perchEye else {
            result("SDK_NOT_INITIALIZED")
            return
        }

        guard let args = call.arguments as? [String: Any],
              let base64String = args["img"] as? String else {
            result("INVALID_ARGUMENT")
            return
        }

        guard let image = decodeBase64ToUIImage(base64String) else {
            result("DECODE_ERROR")
            return
        }

        let imageResult = perchEye.load(image: image)
        result(imageResult.stringValue)
    }

    private func handleAddImageRaw(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let perchEye = perchEye else {
            result("SDK_NOT_INITIALIZED")
            return
        }

        guard let args = call.arguments as? [String: Any],
              let pixelsData = args["pixels"] as? FlutterStandardTypedData,
              let width = args["width"] as? Int,
              let height = args["height"] as? Int else {
            result("INVALID_ARGUMENT")
            return
        }

        let pixels = pixelsData.data
        guard let image = createUIImageFromRGBA(pixels: pixels, width: width, height: height) else {
            result("DECODE_ERROR")
            return
        }

        let imageResult = perchEye.load(image: image)
        result(imageResult.stringValue)
    }

    private func handleEnroll(result: @escaping FlutterResult) {
        guard let perchEye = perchEye else {
            result("")
            return
        }

        let hash = perchEye.enroll()
        result(hash)
    }

    private func handleVerify(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let perchEye = perchEye else {
            result(0.0)
            return
        }

        guard let args = call.arguments as? [String: Any],
              let hash = args["hash"] as? String else {
            result(0.0)
            return
        }

        let similarity = perchEye.verify(hash: hash)
        result(Double(similarity))
    }

    private func handleEvaluate(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let perchEye = perchEye else {
            result("")
            return
        }

        guard let args = call.arguments as? [String: Any],
              let base64Images = args["images"] as? [String] else {
            result("")
            return
        }

        let images = base64Images.compactMap { decodeBase64ToUIImage($0) }

        if images.count != base64Images.count {
            result("")
            return
        }

        let hash = perchEye.evaluate(images)
        result(hash)
    }

    private func handleCompareList(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let perchEye = perchEye else {
            result(0.0)
            return
        }

        guard let args = call.arguments as? [String: Any],
              let base64Images = args["images"] as? [String],
              let hash = args["hash"] as? String else {
            result(0.0)
            return
        }

        let images = base64Images.compactMap { decodeBase64ToUIImage($0) }
        let similarity = perchEye.compare(images: images, withHash: hash)
        result(Double(similarity))
    }

    private func handleCompareFaces(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let base64Image1 = args["img1"] as? String,
              let base64Image2 = args["img2"] as? String else {
            result(0.0)
            return
        }

        let similarity = compareTwoFaces(base64Image1: base64Image1, base64Image2: base64Image2)
        result(similarity)
    }

    // MARK: - Helper Methods

    private func compareTwoFaces(base64Image1: String, base64Image2: String) -> Double {
        guard let perchEye = perchEye,
              let image1 = decodeBase64ToUIImage(base64Image1),
              let image2 = decodeBase64ToUIImage(base64Image2) else {
            return 0.0
        }

        // Enroll first image
        perchEye.openTransaction()
        let add1Result = perchEye.load(image: image1)
        if add1Result != .success { return 0.0 }
        let hash = perchEye.enroll()

        // Verify with second image
        perchEye.openTransaction()
        let add2Result = perchEye.load(image: image2)
        if add2Result != .success { return 0.0 }

        let similarity = perchEye.verify(hash: hash)
        return Double(similarity)
    }

    private func decodeBase64ToUIImage(_ base64String: String) -> UIImage? {
        guard let data = Data(base64Encoded: base64String) else {
            return nil
        }
        return UIImage(data: data)
    }

    private func createUIImageFromRGBA(pixels: Data, width: Int, height: Int) -> UIImage? {
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel

        guard pixels.count == width * height * bytesPerPixel else {
            return nil
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        guard let context = CGContext(data: UnsafeMutableRawPointer(mutating: pixels.withUnsafeBytes { $0.baseAddress }),
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }

        guard let cgImage = context.makeImage() else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}

// MARK: - ImageResult Extension

extension ImageResult {
    var stringValue: String {
        switch self {
        case .success: return "SUCCESS"
        case .faceNotFound: return "FACE_NOT_FOUND"
        case .transactionNotOpened: return "TRANSACTION_NOT_OPENED"
        case .sdkNotInitialized: return "SDK_NOT_INITIALIZED"
        case .internalError: return "INTERNAL_ERROR"
        @unknown default: return "INTERNAL_ERROR"
        }
    }
}