//
// Copyright (c) 2017 Shakuro (https://shakuro.com/)
// Sergey Laschuk
//

import Accelerate
import AVFoundation
import CoreGraphics
import Foundation
import UIKit

public enum ImageProcessorError: Error {
    case cantCreateCVPixelBuffer(statusCode: CVReturn)        // probably out of memory situation
}

public class ImageProcessor {

    /**
     - returns: pixel buffer with `kCVPixelFormatType_32BGRA` pixel format
     - throws: `ImageProcessorError` if output object can not be created (probable out of memory)
     */
    public static func createBGRAPixelBuffer(image: CGImage) throws -> CVPixelBuffer {
        let result: CVPixelBuffer

        let imageWidth: Int = image.width
        let imageHeight: Int = image.height

        let bufferAttributes = [
            kCVPixelBufferCGImageCompatibilityKey: NSNumber(value: false),
            kCVPixelBufferCGBitmapContextCompatibilityKey: NSNumber(value: false)
            ] as CFDictionary
        let pixelBufferOut = UnsafeMutablePointer<CVPixelBuffer?>.allocate(capacity: 1)
        let createBufferStatus = CVPixelBufferCreate(kCFAllocatorDefault,
                                                     imageWidth,
                                                     imageHeight,
                                                     kCVPixelFormatType_32BGRA,
                                                     bufferAttributes,
                                                     pixelBufferOut)
        let pixelBuffer = pixelBufferOut.pointee
        pixelBufferOut.deallocate()
        if createBufferStatus == kCVReturnSuccess, let actualPixelBuffer = pixelBuffer {
            CVPixelBufferLockBaseAddress(actualPixelBuffer, [])
            let pixelData = CVPixelBufferGetBaseAddress(actualPixelBuffer)
            let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
                .union(.byteOrder32Little) // BGRA
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapContext = CGContext(
                data: pixelData,
                width: imageWidth,
                height: imageHeight,
                bitsPerComponent: 8,
                bytesPerRow: CVPixelBufferGetBytesPerRow(actualPixelBuffer),
                space: rgbColorSpace,
                bitmapInfo: bitmapInfo.rawValue)
            bitmapContext?.draw(image, in: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
            CVPixelBufferUnlockBaseAddress(actualPixelBuffer, [])
            result = actualPixelBuffer
        } else {
            throw ImageProcessorError.cantCreateCVPixelBuffer(statusCode: createBufferStatus)
        }

        return result
    }

    public static func uiImageOrientation(from: AVCaptureVideoOrientation) -> UIImage.Orientation {
        switch from {
        case .portrait:
            return UIImage.Orientation.up
        case .portraitUpsideDown:
            return UIImage.Orientation.down
        case .landscapeLeft:
            return UIImage.Orientation.left
        case .landscapeRight:
            return UIImage.Orientation.right
        @unknown default:
            return UIImage.Orientation.up // like from portrait
        }
    }

    public static func orientationAfterCWRotation(_ previousOrientation: UIImage.Orientation) -> UIImage.Orientation {
        let nextOrientation: UIImage.Orientation
        switch previousOrientation {
        case .up:
            nextOrientation = .right
        case .down:
            nextOrientation = .left
        case .left:
            nextOrientation = .up
        case .right:
            nextOrientation = .down
        case .upMirrored:
            nextOrientation = .rightMirrored
        case .downMirrored:
            nextOrientation = .leftMirrored
        case .leftMirrored:
            nextOrientation = .upMirrored
        case .rightMirrored:
            nextOrientation = .downMirrored
        default:
            nextOrientation = previousOrientation
        }
        return nextOrientation
    }

    public static func orientationAfterCCWRotation(_ previousOrientation: UIImage.Orientation) -> UIImage.Orientation {
        var result = previousOrientation
        for _ in 0...3 {
            result = orientationAfterCWRotation(result)
        }
        return result
    }

}
