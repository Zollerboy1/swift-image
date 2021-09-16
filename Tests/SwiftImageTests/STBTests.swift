import XCTest
import SwiftImage

class STBTests: XCTestCase {
    func testInitWithPath() {
        let path = (#file as NSString).deletingLastPathComponent.appending("/Test2x2.png")

        do {
            if let image = try? Image<RGB<UInt8>>(withPath: path) {
                XCTAssertEqual(image.width, 2)
                XCTAssertEqual(image.height, 2)

                XCTAssertEqual(image[0, 0].red,   255)
                XCTAssertEqual(image[0, 0].green,   0)
                XCTAssertEqual(image[0, 0].blue,    0)

                XCTAssertEqual(image[1, 0].red,     0)
                XCTAssertEqual(image[1, 0].green, 255)
                XCTAssertEqual(image[1, 0].blue,    0)

                XCTAssertEqual(image[0, 1].red,     0)
                XCTAssertEqual(image[0, 1].green,   0)
                XCTAssertEqual(image[0, 1].blue,  255)

                XCTAssertEqual(image[1, 1].red,   255)
                XCTAssertEqual(image[1, 1].green, 255)
                XCTAssertEqual(image[1, 1].blue,    0)
            } else {
                XCTFail()
            }
        }

        do {
            if let image = try? Image<RGBA<UInt8>>(withPath: path) {
                XCTAssertEqual(image.width, 2)
                XCTAssertEqual(image.height, 2)

                XCTAssertEqual(image[0, 0].red,   255)
                XCTAssertEqual(image[0, 0].green,   0)
                XCTAssertEqual(image[0, 0].blue,    0)
                XCTAssertEqual(image[0, 0].alpha,  64)

                XCTAssertEqual(image[1, 0].red,     0)
                XCTAssertEqual(image[1, 0].green, 255)
                XCTAssertEqual(image[1, 0].blue,    0)
                XCTAssertEqual(image[1, 0].alpha, 127)

                XCTAssertEqual(image[0, 1].red,     0)
                XCTAssertEqual(image[0, 1].green,   0)
                XCTAssertEqual(image[0, 1].blue,  255)
                XCTAssertEqual(image[0, 1].alpha, 191)

                XCTAssertEqual(image[1, 1].red,   255)
                XCTAssertEqual(image[1, 1].green, 255)
                XCTAssertEqual(image[1, 1].blue,    0)
                XCTAssertEqual(image[1, 1].alpha, 255)
            } else {
                XCTFail()
            }
        }
    }

    func testWriteToPath() {
        let path = (#file as NSString).deletingLastPathComponent.appending("/Temporary.png")


        do {
            let image = Image<RGB<UInt8>>(width: 2, height: 2, pixels: [
                RGB<UInt8>(red: 0, green: 1, blue: 2),
                RGB<UInt8>(red: 3, green: 4, blue: 5),
                RGB<UInt8>(red: 126, green: 127, blue: 128),
                RGB<UInt8>(red: 253, green: 254, blue: 255)
            ])

            try image.write(toPath: path, withFormat: .png)

            let loadedImage = try Image<RGB<UInt8>>(withPath: path)

            XCTAssertEqual(image, loadedImage)

            try FileManager.default.removeItem(atPath: path)
        } catch {
            XCTFail()
        }


        do {
            let image = Image<RGBA<UInt8>>(width: 2, height: 2, pixels: [
                RGBA<UInt8>(red: 0, green: 1, blue: 2, alpha: 255),
                RGBA<UInt8>(red: 3, green: 4, blue: 5, alpha: 150),
                RGBA<UInt8>(red: 126, green: 127, blue: 128, alpha: 1),
                RGBA<UInt8>(red: 253, green: 254, blue: 255, alpha: 20)
            ])

            try image.write(toPath: path, withFormat: .png)

            let loadedImage = try Image<RGBA<UInt8>>(withPath: path)

            XCTAssertEqual(image, loadedImage)

            try FileManager.default.removeItem(atPath: path)
        } catch {
            XCTFail()
        }
    }
}
