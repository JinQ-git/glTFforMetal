import Foundation
// glTF2Struct.swift require

public enum glTFError: Error {
    case invalidFormat(desc: String)
}

public class glTF2Data
{
    // MARK: - Stored Properties
    
    let root: glTF
    let url: URL
    
    var buffers: [Data]? = nil
    var bufferViews: [Data]? = nil
    
    // MARK: - Computed Properties
    
    var glTFRoot: glTF { get { return root } }
    var glTFUrl: URL { get { return url } }
    
    var isBufferLoaded: Bool { get { return bufferViews != nil } }
    
    
    // MARK: - Constructor
    
    public init(URL jsonUrl: URL, jsonDecoder: JSONDecoder? = nil) throws {
        let decoder = jsonDecoder ?? JSONDecoder()
        let jsonData = try Data.init(contentsOf: jsonUrl)
        
        root = try decoder.decode(glTF.self, from: jsonData)
        url  = jsonUrl
    }
    
    public init(filePath path: String, jsonDecoder: JSONDecoder? = nil) throws {
        let jsonUrl = URL(fileURLWithPath: path)
        let decoder = jsonDecoder ?? JSONDecoder()
        let jsonData = try Data.init(contentsOf: jsonUrl)
        
        root = try decoder.decode(glTF.self, from: jsonData)
        url  = jsonUrl
    }
    
    // MARK: - Load file resources to memory buffer
    
    public func loadBuffers() throws {
        // MARK: Load Buffers
        var bufferDatas = [Data]()
        
        if let bufferInfos = root.buffers {
            for bufferInfo in bufferInfos {
                guard let uri = bufferInfo.uri else { throw glTFError.invalidFormat(desc: "buffer.uri does not exist") }
                let isDataUri: Bool = uri.hasPrefix("data:")
                
                if isDataUri { // Embeded buffer data with base64 encoding
                    // `mediatype` field MUST be set to `application/octet-stream` or `application/gltf-buffer`
                    guard let commaIndex = uri.firstIndex(of: ",") else { throw glTFError.invalidFormat(desc: "Invalid Data Uri format") }
                    
                    // validate mediatype and encoding method
                    let prefix = uri[uri.index(uri.startIndex, offsetBy: 5)..<commaIndex] // <media-type>;base64
                    if !(prefix.hasPrefix("application/octet-stream;base64") || prefix.hasPrefix("application/gltf-buffer;base64")) {
                        throw glTFError.invalidFormat(desc: "buffer data uri's mediatype must be `application/octet-stream` or `application/gltf-buffer` with base64 encoding (uri: \(prefix))")
                    }
                }
                //else // relative path to binary file (generally, .bin)
                
                let dataUrl: URL = isDataUri ? URL(string: uri)! : URL(fileURLWithPath: uri, relativeTo: self.url)
                let bufferData = try Data.init(contentsOf: dataUrl)
                // assert( bufferData.count == bufferInfo.byteLength )
                bufferDatas.append(bufferData)
            }
        }
        // assert( bufferDatas.count == root.buffers!.count )
        
        // MARK: Buffer Views
        var bufferDataViews = [Data]()
        
        if let bufferViewInfos = root.bufferViews {
            for bufferViewInfo in bufferViewInfos {
                let buffer = bufferDatas[ bufferViewInfo.buffer ]
                let sIdx = buffer.index(buffer.startIndex, offsetBy: bufferViewInfo.byteOffset)
                let eIdx = buffer.index(sIdx, offsetBy: bufferViewInfo.byteLength)
                
                let bufferDataView = buffer[sIdx..<eIdx] // reference? // to Copy: buffer.subdata(in: sIdx..<eIdx)
                bufferDataViews.append(bufferDataView)
            }
        }
        // assert( bufferDataViews.count == root.bufferViews!.count )
        
        self.buffers = bufferDatas
        self.bufferViews = bufferDataViews
    }
}

