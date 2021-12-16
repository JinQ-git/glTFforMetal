import Foundation
import simd

public struct glTF: Decodable
{
    // MARK: - Type Define
    
    public struct Accessor: Decodable
    {
        public enum ComponentType: Int, Decodable
        {
            case byte   = 5120
            case ubyte  = 5121
            case short  = 5122
            case ushort = 5123
            case uint   = 5125
            case float  = 5126
        }
        
        public enum DataType: String, Decodable
        {
            case scalar = "SCALAR"
            case vec2   = "VEC2"
            case vec3   = "VEC3"
            case vec4   = "VEC4"
            case mat2   = "MAT2"
            case mat3   = "MAT3"
            case mat4   = "MAT4"
        }
        
        public struct Sparse: Decodable
        {
            public struct Indices: Decodable
            {
                public enum ComponentType: Int, Decodable
                {
                    case ubyte  = 5121
                    case ushort = 5123
                    case uint   = 5125
                }
                
                public let bufferView: Int              // The index of the buffer view with sparse indicies.
                                                        // The referenced buffer view "MUST NOT" have its `target` or `byteStride` properties defined.
                                                        // The buffer view and the optional `byteOffset` "MUST" be aligned to the `componentType` byte length.
                public let _byteOffset: Int?            // The offset relative to the start of the buffer view in bytes. (default: 0)
                public let componentType: ComponentType // The indices data type. ( ubyte, ushort, uint )
                // MARK: Not Support `Extensions` & `Extras` Properties
                // let extensions: extension? = nil     // JSON object with extension-specific objects.
                // let extras: extras? = nil            // Application-specific data.
                
                enum CodingKeys: String, CodingKey {
                    case bufferView
                    case _byteOffset = "byteOffset"
                    case componentType
                }
                
                public var byteOffset: Int { get { return _byteOffset ?? 0 } }
            }
            
            public struct Values: Decodable
            {
                public let bufferView: Int  // The index of the bufferView with sparse indicies.
                                            // The referenced buffer view "MUST NOT" have its `target` or `byteStride` properties defined.
                public let _byteOffset: Int? // The offset relative to the start of the bufferView in bytes. (default: 0)
                // MARK: Not Support `Extensions` & `Extras` Properties
                // let extensions: extension? = nil // JSON object with extension-specific objects.
                // let extras: extras? = nil        // Application-specific data.
                
                enum CodingKeys: String, CodingKey {
                    case bufferView
                    case _byteOffset = "byteOffset"
                }
                
                public var byteOffset: Int { get { return _byteOffset ?? 0 } }
            }
            
            public let count: Int       // Number of devicating accessor values stored int the sparse array.
            public let indices: Indices // An object pointing to a buffer view containing the indices of deviating accessor values.
                                        // The number of indices is equal to `count`.
                                        // Indices "MUST" strictly increase.
            public let values: Values   // An object pointing to a buffer view containing the deviating accessor values.
            
            // MARK: Not Support `Extensions` & `Extras` Properties
            // let extensions: extension? = nil // JSON object with extension-specific objects.
            // let extras: extras? = nil        // Application-specific data.
        }
        
        public let bufferView: Int?             // The index of the bufferView.
        public let _byteOffset: Int?            // The offset relative to the start of the buffer view in bytes. (default:0)
        public let componentType: ComponentType // The datatype of the accessor's components. (byte, ubyte, short, ushort, uint, float)
        public let _normalized: Bool?           // Specifies whethere integer data values are normalized before usage. (default:false)
        public let count: Int                   // The number of elements referenced by this accessor.
        public let type: DataType               // Specifies if the accessor's elements are scalars, vectors, or matrices.
        public let max: [Float]?                // Maximum value of each component in this accessor.
        public let min: [Float]?                // Minimum value of each component in this accessor.
        public let sparse: Sparse?              // Sparse storage of elements that deviate from their initialization value.
        public let name: String?                // The user-defined name of this object.
        // MARK: Not Support `Extensions` & `Extras` Properties
        // let extensions: extension? = nil     // JSON object with extension-specific objects.
        // let extras: extras? = nil            // Application-specific data.
        
        enum CodingKeys: String, CodingKey {
            case bufferView
            case _byteOffset = "byteOffset"
            case componentType
            case _normalized = "normalized"
            case count
            case type
            case max
            case min
            case sparse
            case name
        }
        
        public var byteOffset: Int { get { return _byteOffset ?? 0 } }
        public var normalized: Bool { get { return _normalized ?? false } }
    }
    
    public struct Animation: Decodable
    {
        public struct Channel: Decodable
        {
            public struct Target: Decodable
            {
                public enum PathName: String, Decodable
                {
                    case translation = "translation"
                    case rotation    = "rotation"
                    case scale       = "scale"
                    case weights     = "weights"
                }
                
                public let node: Int?     // The index of the node to animate.
                                          // When undefined, the animated object "MAY" be defined by an extension.
                public let path: PathName // The name of the node's TRS property to animate, or the `"weights"` of the Morph Targets it instantiates.
                                          // For the `"translation"` property, the values that are provided by the sampler are the translation along X, Y, and Z axes.
                                          // For the `"rotation"` property, the values are a quaternion in the order (x, y, z, w), where w is the scalar.
                                          // For the `"scale"` property, the values are the scaling factors along the X, y, and Z axes.
                // MARK: Not Support `Extensions` & `Extras` Properties
                // let extensions: extension? = nil // JSON object with extension-specific objects.
                // let extras: extras? = nil        // Application-specific data.
            }
            
            public let sampler: Int   // The index of a sampler in this animation used to compute the value for the target.
            public let target: Target // The descriptor of the animated property.
            // MARK: Not Support `Extensions` & `Extras` Properties
            // let extensions: extension? = nil // JSON object with extension-specific objects.
            // let extras: extras? = nil        // Application-specific data.
        }
        
        public struct Sampler: Decodable
        {
            public enum InterpolationAlgorithm: String, Decodable
            {
                case linear      = "LINEAR"
                case step        = "STEP"
                case cubicSpline = "CUBICSPLINE"
            }
            
            public let input: Int                              // The index of an accessor containing keyframe timestamps.
            public let _interpolation: InterpolationAlgorithm? // Interpolation algorithm. (default: "LINEAR")
            public let output: Int                             // The index of an accessor containing keyframe output values.
            // MARK: Not Support `Extensions` & `Extras` Properties
            // let extensions: extension? = nil // JSON object with extension-specific objects.
            // let extras: extras? = nil        // Application-specific data.
            
            enum CodingKeys: String, CodingKey
            {
                case input
                case _interpolation = "interpolation"
                case output
            }
            
            public var interpolation: InterpolationAlgorithm { get { return _interpolation ?? .linear } }
        }
        
        public let channels: [Channel] // An array of animation channels.
                                       // An animation channel combines an animation sampler with a target property being animated.
                                       // Different channels of the same animation "MUST NOT" have the same targets.
        public let samplers: [Sampler] // An array of animation samplers.
                                       // An animation sampler combines timestamps with a sequence of output values and defines an interpolation algorithm.
        public let name: String?       // The user-defined name of this object.
        // MARK: Not Support `Extensions` & `Extras` Properties
        // let extensions: extension? = nil // JSON object with extension-specific objects.
        // let extras: extras? = nil        // Application-specific data.
    }
    
    public struct Asset: Decodable
    {
        public let version: String     // A copyright message suitable for display to credit the content creator.
        public let generator: String?  // Tool that generated this glTF model. Useful for debugging.
        public let copyright: String?  // The glTF version in the form of `<major>.<minor>` that this asset targets.
    }
    
    public struct Buffer: Decodable
    {
        public let uri: String?    // The URI (or IRI) of the buffer.
        public let byteLength: Int // The length of the buffer in bytes.
        public let name: String?   // The user-defined name of this object.
        // MARK: Not Support `Extensions` & `Extras` Properties
        // let extensions: extension? = nil // JSON object with extension-specific objects.
        // let extras: extras? = nil        // Application-specific data.
    }
    
    public struct BufferView: Decodable
    {
        public enum BufferType: Int, Decodable
        {
            case arrayBuffer        = 34962
            case elementArrayBuffer = 34963
        }
        
        public let buffer: Int         // The index of the buffer.
        public let _byteOffset: Int?   // The offset into the buffer in bytes. (default: 0)
        public let byteLength: Int     // The length of the bufferView in bytes.
        public let byteStride: Int?    // The stride, in bytes.
        public let target: BufferType? // The hint representing the intended GPU buffer type to use with this buffer view.
        public let name: String?       // The user-defined name of this object.
        // MARK: Not Support `Extensions` & `Extras` Properties
        // let extensions: extension? = nil // JSON object with extension-specific objects.
        // let extras: extras? = nil        // Application-specific data.
        
        enum CodingKeys: String, CodingKey {
            case buffer
            case _byteOffset = "byteOffset"
            case byteLength
            case byteStride
            case target
            case name
        }
        
        public var byteOffset: Int { get { return _byteOffset ?? 0 } }
    }
    
    public struct Camera: Decodable
    {
        public enum ProjectionType: String, Decodable
        {
            case perspective  = "perspective"
            case orthographic = "orthographic"
        }
        
        public struct Orthographic: Decodable
        {
            public let xmag: Float  // The floating-point horizontal magnification of the view.
                                    // This value "MUST NOT" be equal to zero.
                                    // This value "SHOULD NOT" be negative.
            public let ymag: Float  // The floating-point vertical magnification of the view.
                                    // This value "MUST NOT" be equal to zero.
                                    // This value "SHOULD NOT" be negative.
            public let zfar: Float  // The floating-point distance to the far clipping plane.
                                    // This value "MUST NOT" be equal to zero.
                                    // `zfar` "MUST" be greater than `znear`.
            public let znear: Float // The floating-point distance to the near clipping plane.
            // MARK: Not Support `Extensions` & `Extras` Properties
            // let extensions: extension? = nil // JSON object with extension-specific objects.
            // let extras: extras? = nil        // Application-specific data.
        }
        
        public struct Perspective: Decodable
        {
            public let aspectRatio: Float? // The floating-point aspect ratio of the field of view.
                                           // When undefined, the aspect ratio of the rendering viewport "MUST" be used.
            public let yfov: Float         // The floating-point vertical field of view in radians.
                                           // This value "SHOULD" be less than pi(π).
            public let zfar: Float?        // The floating-point distance to the far clipping plane.
                                           // When defined, `zfar` "MUST" be greater than `znear`.
                                           // If `zfar` is undefined, client implementations "SHOULD" use infinite projection matrix.
            public let znear: Float        // The floating-point distance to the near clipping plane.
            // MARK: Not Support `Extensions` & `Extras` Properties
            // let extensions: extension? = nil // JSON object with extension-specific objects.
            // let extras: extras? = nil        // Application-specific data.
        }
        
        public let orthographic: Orthographic? // An orthographic camera containing properties to create an orthographic projection matrix.
                                               // This property "MUST NOT" be defined when `perspective` is defined.
        public let perspective: Perspective?   // A perspective camera containing properties to create a perspective projection matrix.
                                               // This property "MUST NOT" be defined when `orthographic` is defined.
        public let type: ProjectionType        // Specifies if the camera uses a perspective or orthographic projection.
        public let name: String?               // The user-defined name of this object.
        // MARK: Not Support `Extensions` & `Extras` Properties
        // let extensions: extension? = nil // JSON object with extension-specific objects.
        // let extras: extras? = nil        // Application-specific data.
    }
    
    public struct Image: Decodable
    {
        public enum ImageMediaType: String, Decodable
        {
            case jpeg = "image/jpeg"
            case png  = "image/png"
        }
        
        public let uri: String?              // The URI (or IRI) of the image.
        public let mimeType: ImageMediaType? // The image's media type.
                                             // This field "MUST" be defined when `bufferView` is defined.
        public let bufferView: Int?          // The index of the bufferView that contains the image.
                                             // This field "MUST NOT" be defined when `uri` is defined.
        public let name: String?             // The user-defined name of this object.
        // MARK: Not Support `Extensions` & `Extras` Properties
        // let extensions: extension? = nil // JSON object with extension-specific objects.
        // let extras: extras? = nil        // Application-specific data.
    }
    
    public struct TextureInfo: Decodable
    {
        public let index: Int     // The index of the texture.
        public let _texCoord: Int? // The set index of texture's TEXCOORD attribute used for texture coordinate mapping. (default: 0)
        // MARK: Not Support `Extensions` & `Extras` Properties
        // let extensions: extension? = nil // JSON object with extension-specific objects.
        // let extras: extras? = nil        // Application-specific data.
        
        enum CodingKeys: String, CodingKey {
            case index
            case _texCoord = "texCoord"
        }
        
        public var texCoord: Int { get { return _texCoord ?? 0 } }
    }
    
    public struct Material: Decodable
    {
        public enum AlphaMode: String, Decodable
        {
            case opaque = "OPAQUE"
            case mask   = "MASK"
            case blend  = "BLEND"
        }
        
        public struct PBRMetallicRoughness: Decodable
        {
            public let _baseColorFactor: [Float]? // number[4] // The factors for the base color of the material. (default: [1, 1, 1, 1])
            public let baseColorTexture: TextureInfo?          // The base color texture.
            public let _metallicFactor: Float?                 // The factor for the metalness of the material. (default: 1)
            public let _roughnessFactor: Float?                // The factor for the roughness of the material. (default: 1)
            public let metallicRoughnessTexture: TextureInfo?  // The metallic-roughness texture.
            // MARK: Not Support `Extensions` & `Extras` Properties
            // let extensions: extension? = nil // JSON object with extension-specific objects.
            // let extras: extras? = nil        // Application-specific data.
            
            enum CodingKeys: String, CodingKey {
                case _baseColorFactor = "baseColorFactor"
                case baseColorTexture
                case _metallicFactor = "metallicFactor"
                case _roughnessFactor = "roughnessFactor"
                case metallicRoughnessTexture
            }
            
            public var baseColorFactor: simd_float4 {
                get {
                    if let bcf = _baseColorFactor {
                        return simd_float4.init(Float(bcf[0]), Float(bcf[1]), Float(bcf[2]), Float(bcf[3]))
                    }
                    else {
                        return simd_float4.init(repeating: 1.0)
                    }
                }
            }
            
            public var metallicFactor: Float { get { return _metallicFactor ?? 1.0 } }
            public var roughnessFactor: Float { get { return _roughnessFactor ?? 1.0 } }
        }
        
        public struct NormalTextureInfo: Decodable
        {
            public let index: Int      // The index of the texture.
            public let _texCoord: Int? // The set index of texture's TEXCOORD attribute used for texture coordinate mapping. (default: 0)
            public let _scale: Float?  // The scalar parameter applied to each normal vector of the normal texture. (default: 1)
            // MARK: Not Support `Extensions` & `Extras` Properties
            // let extensions: extension? = nil // JSON object with extension-specific objects.
            // let extras: extras? = nil        // Application-specific data.
            
            enum CodingKeys: String, CodingKey {
                case index
                case _texCoord = "texCoord"
                case _scale = "scale"
            }
            
            public var texCoord: Int { get { return _texCoord ?? 0 } }
            public var scale: Float { get { return _scale ?? 1.0 } }
        }
        
        public struct OcclusionTextureInfo: Decodable
        {
            public let index: Int        // The index of the texture.
            public let _texCoord: Int?   // The set index of texture's TEXCOORD attribute used for texture coordinate mapping. (default: 0)
            public let _strength: Float? // A scalar multiplier controlling the amount of occlusion applied. (default: 1)
            // MARK: Not Support `Extensions` & `Extras` Properties
            // let extensions: extension? = nil // JSON object with extension-specific objects.
            // let extras: extras? = nil        // Application-specific data.
            
            enum CodingKeys: String, CodingKey {
                case index
                case _texCoord = "texCoord"
                case _strength = "strength"
            }
            
            public var texCoord: Int { get { return _texCoord ?? 0 } }
            public var strength: Float { get { return _strength ?? 1.0 } }
        }
        
        public let name: String? // The user-defined name of this object.
        // MARK: Not Support `Extensions` & `Extras` Properties
        // let extensions: extension? = nil // JSON object with extension-specific objects.
        // let extras: extras? = nil        // Application-specific data.
        
        public let pbrMetallicRoughness: PBRMetallicRoughness? // A set of parameter values that are used to define the metallic-roughness material model from Physically Based Rendering (PBR) methodology.
                                                               // When undefined, all the default values of `pbrMetallicRoughness` "MUST" apply.
        public let normalTexture: NormalTextureInfo?           // The tangent space normal texture.
        public let occlusionTexture: OcclusionTextureInfo?     // The occlusion texture.
        public let emissiveTexture: TextureInfo?               // The emissive texture.
        public let _emissiveFactor: [Float]? // number[3]      // The factors for the emissive color of the material. (default: [0, 0, 0])
        public let _alphaMode: AlphaMode?                      // The alpha rendering mode of the material. (default: "OPAQUE")
        public let _alphaCutoff: Float?                        // The alpha cutoff value of the material. (default: 0.5)
        public let _doubleSided: Bool?                         // Specifies whether the material is double sided. (default: false)
        
        enum CodingKeys: String, CodingKey {
            case name
            case pbrMetallicRoughness
            case normalTexture
            case occlusionTexture
            case emissiveTexture
            case _emissiveFactor = "emissiveFactor"
            case _alphaMode = "alphaMode"
            case _alphaCutoff = "alphaCutoff"
            case _doubleSided = "doubleSided"
        }
        
        public var emissiveFactor: simd_float3 {
            get {
                if let ef = _emissiveFactor {
                    return simd_float3.init(ef[0], ef[1], ef[2])
                }
                else {
                    return simd_float3.init()
                }
            }
        }
        public var alphaMode: AlphaMode { get { return _alphaMode ?? .opaque } }
        public var alphaCutoff: Float { get { return _alphaCutoff ?? 0.5 } }
        public var doubleSided: Bool { get { return _doubleSided ?? false } }
        
        public static func getDefaultPBRMetallicRoughness() -> PBRMetallicRoughness {
            return PBRMetallicRoughness.init(_baseColorFactor: nil, baseColorTexture: nil, _metallicFactor: nil, _roughnessFactor: nil, metallicRoughnessTexture: nil)
        }
    }
    
    public struct Mesh: Decodable
    {
        public struct Primitive: Decodable
        {
//            public enum AttributeSemantic: String, Decodable
//            {
//                case position  = "POSITION"
//                case normal    = "NORMAL"
//                case tangent   = "TANGENT"
//                case texCoord0 = "TEXCOORD_0"
//                case texCoord1 = "TEXCOORD_1"
//                case texCoord2 = "TEXCOORD_2"
//                case texCoord3 = "TEXCOORD_3"
//                case color0    = "COLOR_0"
//                case joints0   = "JOINTS_0"
//                case weights0  = "WEIGHTS_0"
//            }
            public typealias AttributeSemantic = String
            
            public enum TopologyType: Int, Decodable
            {
                case points        = 0
                case lines         = 1
                case lineLoop      = 2
                case lineStrip     = 3
                case triangles     = 4
                case triangleStrip = 5
                case triangleFan   = 6
            }
            
            public let attributes: [AttributeSemantic:Int] // A plain JSON object, where each key corresponds to a mesh attribute semantic and each value is the index of the accessor containing attribute's data.
            public let indices: Int?                       // The index of the accessor that contains the vertex indices.
            public let material: Int?                      // The index of the material to apply to this primitive when rendering.
            public let _mode: TopologyType?                // The topology type of primitives to render. (default: 4)
            public let targets: [[AttributeSemantic:Int]]? // An array of morph targets.
                                                           // Each target in the `targets` array is a plain JSON object mapping a primitive attribute to an accessor containing morph target displacement data (deltas).
            // MARK: Not Support `Extensions` & `Extras` Properties
            // let extensions: extension? = nil // JSON object with extension-specific objects.
            // let extras: extras? = nil        // Application-specific data.
            
            enum CodingKeys: String, CodingKey {
                case attributes
                case indices
                case material
                case _mode = "mode"
                case targets
            }
            
            public var mode: TopologyType { get { return _mode ?? .triangles } }
            //public var hasIndices: Bool { get { return indices != nil } }
        }
        
        public let primitives: [Primitive] // An array of primitives, each defining geometry to be rendered.
        public let weights: [Float]?       // Array of weights to be applied to the morph targets.
                                           // The number of array elements "MUST" match the number of morph targets.
        public let name: String?           // The user-defined name of this object.
        // MARK: Not Support `Extensions` & `Extras` Properties
        // let extensions: extension? = nil // JSON object with extension-specific objects.
        // let extras: extras? = nil        // Application-specific data.
        
    }
    
    public struct Node: Decodable
    {
        public let camera: Int?                        // The index of the camera referenced by this node.
        public let children: [Int]?                    // The indices of this node's children.
        public let skin: Int?                          // The index of the skin referenced by this node.
        public let matrix: [Float]?      // number[16] // A floating-point 4x4 transformation matrix stored in column-major order. (default: [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1])
        public let mesh: Int?                          // The index of the mesh in this node.
        public let rotation: [Float]?    // number[4]  // The node's unit guaternion rotation in the order (x, y, z, w), where w is the scalar. (default: [0, 0, 0, 1])
        public let scale: [Float]?       // number[3]  // The node's non-uniform scale, given as the scaling factors along the x, y, and z axes. (default: [1, 1, 1])
        public let translation: [Float]? // number[3]  // The node's translation along the x, y, and z axes. (default: [0, 0, 0])
        public let weights: [Float]?                   // The weights of the instantiated morph target.
                                                       // The number of array elements "MUST" match the number of morph targets of the referenced mesh.
                                                       // When defined, `mesh` "MUST" also be defined.
        public let name: String?                       // The user-defined name of this object.
        // MARK: Not Support `Extensions` & `Extras` Properties
        // let extensions: extension? = nil // JSON object with extension-specific objects.
        // let extras: extras? = nil        // Application-specific data.
    }
    
    public struct Sampler: Decodable
    {
        public enum MagnificationFilter: Int, Decodable
        {
            case nearest = 9728
            case linear  = 9729
        }
        
        public enum MinificationFilter: Int, Decodable
        {
            case nearest = 9728
            case linear  = 9729
            case nearestMipmapNearest = 9984
            case linearMipmapNearest  = 9985
            case nearestMipmapLinear  = 9986
            case linearMipmapLinear   = 9987
        }
        
        public enum WrappingMode: Int, Decodable
        {
            case clampToEdge    = 33071
            case mirroredRepeat = 33648
            case `repeat`       = 10497
        }
        
        public let magFilter: MagnificationFilter? // Magnification filter.
        public let minFilter: MinificationFilter?  // Minification filter.
        public let _wrapS: WrappingMode?           // S(U) wrapping mode. (default: 10497)
        public let _wrapT: WrappingMode?           // T(V) wrapping mode. (default: 10497)
        public let name: String?                   // The user-defined name of this object.
        // MARK: Not Support `Extensions` & `Extras` Properties
        // let extensions: extension? = nil // JSON object with extension-specific objects.
        // let extras: extras? = nil        // Application-specific data.
        
        enum CodingKeys: String, CodingKey {
            case magFilter
            case minFilter
            case _wrapS = "wrapS"
            case _wrapT = "wrapT"
            case name
        }
        
        public var wrapS: WrappingMode { get { return _wrapS ?? .repeat } }
        public var wrapT: WrappingMode { get { return _wrapS ?? .repeat } }
    }
    
    public struct Scene: Decodable
    {
        public let nodes: [Int]? // The indices of each root node.
        public let name: String? // The user-defined name of this object.
        // MARK: Not Support `Extensions` & `Extras` Properties
        // let extensions: extension? = nil // JSON object with extension-specific objects.
        // let extras: extras? = nil        // Application-specific data.
    }
    
    public struct Skin: Decodable
    {
        public let inverseBindMatrices: Int? // The index of the accessor containing the floating-point 4x4 inverse-bind matrices.
        public let skeleton: Int?            // The index of the node used as a skeleton root.
        public let joints: [Int]             // Indices of skeleton nodes, used as joints in this skin.
        public let name: String?             // The user-defined name of this object.
        // MARK: Not Support `Extensions` & `Extras` Properties
        // let extensions: extension? = nil // JSON object with extension-specific objects.
        // let extras: extras? = nil        // Application-specific data.
    }
    
    public struct Texture: Decodable
    {
        public let sampler: Int?  // The index of the sampler used by this texture.
                                  // When undefined, a sampler with repeat wrapping and auto filtering "SHOULD" be used.
        public let source: Int?   // The index of the image used by this texture.
                                  // When undefined, an extension or other mechanism "SHOULD" supply an alternate texture source, otherwise behavior is undefined.
        public let name: String?  // The user-defined name of this object.
        // MARK: Not Support `Extensions` & `Extras` Properties
        // let extensions: extension? = nil // JSON object with extension-specific objects.
        // let extras: extras? = nil        // Application-specific data.
    }
    
    // MARK: Not Support `Extensions` & `Extras` Properties
    
    // MARK: - Properties of glTF itself
    
    public let extensionsUsed: [String]?
    public let extensionsRequired: [String]?
    public let accessors: [Accessor]?
    public let animations: [Animation]?
    public let asset: Asset // Required!!
    public let buffers: [Buffer]?
    public let bufferViews: [BufferView]?
    public let cameras: [Camera]?
    public let images: [Image]?
    public let materials: [Material]?
    public let meshes: [Mesh]?
    public let nodes: [Node]?
    public let samplers: [Sampler]?
    public let scene: Int?
    public let scenes: [Scene]?
    public let skins: [Skin]?
    public let textures: [Texture]?
    // MARK: Not Support `Extensions` & `Extras` Properties
    // let extensions: extension? = nil // JSON object with extension-specific objects
    // let extras: extras? = nil        // Application-specific data
}

extension glTF.Accessor
{
    public var SIZE_OF_COMPONENT: Int {
        get {
            switch componentType {
            case .byte, .ubyte:
                return 1
            case .short, .ushort:
                return 2
            case .uint, .float:
                return 4
            }
        }
    }
    
    public var NUMBER_OF_COMPONENTS: Int {
        get {
            switch type {
            case .scalar:
                return 1
            case .vec2:
                return 2
            case .vec3:
                return 3
            case .vec4:
                return 4
            case .mat2:
                return 4
            case .mat3:
                return 9
            case .mat4:
                return 16
            }
        }
    }
    
    public var SIZE_OF_ELEMENT: Int {
        get {
            let numComponent = SIZE_OF_COMPONENT // 1, 2, or 4
            switch type {
            case .scalar:
                return numComponent
            case .vec2:
                return 2 * numComponent
            case .vec3:
                return 3 * numComponent
            case .vec4:
                return 4 * numComponent
                
            // NOTE! matrix type -> start of each column must be aligned to 4-byte boundaries.
            // Only the 3 case require padding. (mat2 with 1-byte compoents, mat3 with 1-byte compoents, mat3 with 2-byte components
                
            case .mat2:
                return numComponent == 1 ? 8 : 4 * numComponent
            case .mat3:
                return numComponent == 4 ? 9 * numComponent : 3 * 4 * numComponent
            case .mat4:
                return 16 * numComponent
            }
        }
    }
}

public class glTFReader
{
    public class func from(URL url: URL) throws -> glTF {
        let data = try Data.init(contentsOf: url)
        let decoder = JSONDecoder()
        
        return try decoder.decode(glTF.self, from: data)
    }
    
    public class func from(filePath path: String, jsonDecoder:JSONDecoder? = nil) throws -> glTF {
        let data = try Data.init(contentsOf: URL(fileURLWithPath: path))
        let decoder = jsonDecoder ?? JSONDecoder()
        
        return try decoder.decode(glTF.self, from: data)
    }
    
    public class func from(jsonData data: Data, jsonDecoder:JSONDecoder? = nil) throws -> glTF {
        let decoder = jsonDecoder ?? JSONDecoder()
        return try decoder.decode(glTF.self, from: data)
    }
    
    public class func from(jsonString str: String, jsonDecoder:JSONDecoder? = nil) throws -> glTF {
        let decoder = jsonDecoder ?? JSONDecoder()
        return try decoder.decode(glTF.self, from: str.data(using: .utf8)!)
    }
}

