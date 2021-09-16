import stb

#if canImport(Foundation)
import Foundation
#endif


public struct ImageLoadingError: Error, CustomStringConvertible {
    let path: String
    let failureReason: String?

    internal init(path: String, failureReason: String? = nil) {
        self.path = path
        self.failureReason = failureReason
    }

    public var description: String {
        if let failureReason = self.failureReason {
            return "Error while loading image from '\(path)': " + failureReason
        } else {
            return "Unknown error while loading image from '\(path)'"
        }
    }
}

public struct ImageWritingError: Error, CustomStringConvertible {
    let path: String

    public var description: String {
        "Error while writing image to '\(path)'"
    }
}


private func writeImage(withData data: UnsafeRawPointer?, toPath path: String, width: Int, height: Int, channels: Int, format: ImageFormat) throws {
    let errorCode: Int32
    switch format {
    case .png:
        errorCode = writePNG(path, Int32(width), Int32(height), Int32(channels), data, Int32(width * channels))
    case let .jpeg(quality):
        errorCode = writeJPG(path, Int32(width), Int32(height), Int32(channels), data, Int32(quality))
    }

    if errorCode == 0 {
        throw ImageWritingError(path: path)
    }
}


extension ImageProtocol where Pixel == RGB<UInt8> {
    public init(withPath path: String) throws {
        var _width = Int32()
        var _height = Int32()
        var channels = Int32()

        let desiredChannels = MemoryLayout<Pixel>.size / MemoryLayout<UInt8>.size

        precondition(MemoryLayout<Pixel>.alignment <= MemoryLayout<UInt8>.size * desiredChannels)

        guard let data = loadImage(path, &_width, &_height, &channels, Int32(desiredChannels)) else {
            if let failureReason = getFailureReason() {
                throw ImageLoadingError(path: path, failureReason: .init(cString: failureReason))
            } else {
                throw ImageLoadingError(path: path)
            }
        }

        defer {
            freeImage(data)
        }

        let width = Int(_width)
        let height = Int(_height)

        let pixels = [Pixel](unsafeUninitializedCapacity: width * height) { buffer, initializedCount in
            UnsafeMutableRawPointer(buffer.baseAddress!).moveInitializeMemory(as: UInt8.self, from: data, count: width * height * desiredChannels)

            initializedCount = width * height
        }

        self.init(width: width, height: height, pixels: pixels)
    }

    #if canImport(Foundation)
    public init(withURL url: URL) throws {
        try self.init(withPath: url.path)
    }

    public init?(withURL url: URL?) throws {
        guard let path = url?.path else { return nil }

        try self.init(withPath: path)
    }
    #endif


    public func write(toPath path: String, withFormat format: ImageFormat) throws {
        let pixels = self.map({ [$0.red, $0.green, $0.blue ] }).flatMap { $0 }

        try pixels.withUnsafeBytes { data in
            try writeImage(withData: data.baseAddress, toPath: path, width: self.width, height: self.height, channels: 3, format: format)
        }
    }
}

extension Image where Pixel == RGB<UInt8> {
    public func write(toPath path: String, withFormat format: ImageFormat) throws {
        let storedChannels = MemoryLayout<Pixel>.size / MemoryLayout<UInt8>.size

        precondition(MemoryLayout<Pixel>.alignment <= MemoryLayout<UInt8>.size * storedChannels)

        if storedChannels == 3 {
            try self.withUnsafeBytes { data in
                try writeImage(withData: data.baseAddress, toPath: path, width: self.width, height: self.height, channels: 3, format: format)
            }
        } else {
            let pixels = self.map({ [$0.red, $0.green, $0.blue ] }).flatMap { $0 }

            try pixels.withUnsafeBytes { data in
                try writeImage(withData: data.baseAddress, toPath: path, width: self.width, height: self.height, channels: 3, format: format)
            }
        }
    }
}

extension ImageProtocol where Pixel == RGBA<UInt8> {
    public init(withPath path: String) throws {
        var _width = Int32()
        var _height = Int32()
        var channels = Int32()

        let desiredChannels = MemoryLayout<Pixel>.size / MemoryLayout<UInt8>.size

        precondition(MemoryLayout<Pixel>.alignment <= MemoryLayout<UInt8>.size * desiredChannels)

        guard let data = loadImage(path, &_width, &_height, &channels, Int32(desiredChannels)) else {
            if let failureReason = getFailureReason() {
                throw ImageLoadingError(path: path, failureReason: .init(cString: failureReason))
            } else {
                throw ImageLoadingError(path: path)
            }
        }

        defer {
            data.deallocate()
        }

        let width = Int(_width)
        let height = Int(_height)

        let pixels = [Pixel](unsafeUninitializedCapacity: width * height) { buffer, initializedCount in
            UnsafeMutableRawPointer(buffer.baseAddress!).moveInitializeMemory(as: UInt8.self, from: data, count: width * height * desiredChannels)

            initializedCount = width * height
        }

        self.init(width: width, height: height, pixels: pixels)
    }

    #if canImport(Foundation)
    public init(withURL url: URL) throws {
        try self.init(withPath: url.path)
    }

    public init?(withURL url: URL?) throws {
        guard let path = url?.path else { return nil }

        try self.init(withPath: path)
    }
    #endif


    public func write(toPath path: String, withFormat format: ImageFormat) throws {
        let pixels = self.map({ [$0.red, $0.green, $0.blue, $0.alpha ] }).flatMap { $0 }

        try pixels.withUnsafeBytes { data in
            try writeImage(withData: data.baseAddress, toPath: path, width: self.width, height: self.height, channels: 4, format: format)
        }
    }
}

extension Image where Pixel == RGBA<UInt8> {
    public func write(toPath path: String, withFormat format: ImageFormat) throws {
        let storedChannels = MemoryLayout<Pixel>.size / MemoryLayout<UInt8>.size

        precondition(storedChannels == 4 && MemoryLayout<Pixel>.alignment <= MemoryLayout<UInt8>.size * storedChannels)

        try self.withUnsafeBytes { data in
            try writeImage(withData: data.baseAddress, toPath: path, width: self.width, height: self.height, channels: 4, format: format)
        }
    }
}
