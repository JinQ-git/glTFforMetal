import Foundation
import simd

extension glTF.Accessor
{
    // MARK: - Computed Properties
    
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
    
    // MARK: - max to Scalar, Vector, or Matrix
    
    public func max<T>(as _type: T.Type) -> T? {
        guard let m = max else { return nil }
        switch _type
        {
        // MARK: scalar type
        case is Int8.Type: // simd_char1
            if type == .scalar && componentType == .byte { return Int8(m[0]) as? T }
        case is UInt8.Type: // simd_uchar1
            if type == .scalar && componentType == .ubyte { return UInt8(m[0]) as? T }
        case is Int16.Type: // simd_short1
            if type == .scalar && componentType == .short { return Int16(m[0]) as? T }
        case is UInt16.Type: // simd_ushort1
            if type == .scalar && componentType == .ushort { return UInt16(m[0]) as? T }
        case is UInt32.Type: // simd_uint1
            if type == .scalar && componentType == .uint { return UInt32(m[0]) as? T }
        case is UInt.Type: // simd_uint1
            if type == .scalar && componentType == .uint { return UInt(m[0]) as? T }
        case is Float.Type: // simd_float1
            if type == .scalar && componentType == .float { return Float(m[0]) as? T }
            
        // MARK: vec2 type
        case is simd_char2.Type:
            if type == .vec2 && componentType == .byte { return simd_char2( simd_double2( m ) ) as? T }
        case is simd_uchar2.Type:
            if type == .vec2 && componentType == .ubyte { return simd_uchar2( simd_double2( m ) ) as? T }
        case is simd_short2.Type:
            if type == .vec2 && componentType == .short { return simd_short2( simd_double2( m ) ) as? T }
        case is simd_ushort2.Type:
            if type == .vec2 && componentType == .ushort { return simd_ushort2( simd_double2( m ) ) as? T }
        case is simd_uint2.Type:
            if type == .vec2 && componentType == .uint { return simd_uint2( simd_double2( m ) ) as? T }
        case is simd_float2.Type:
            if type == .vec2 && componentType == .float { return simd_float2( simd_double2( m ) ) as? T }
         
        // MARK: vec3 type
        case is simd_char3.Type:
            if type == .vec3 && componentType == .byte { return simd_char3( simd_double3( m ) ) as? T }
        case is simd_uchar3.Type:
            if type == .vec3 && componentType == .ubyte { return simd_uchar3( simd_double3( m ) ) as? T }
        case is simd_short3.Type:
            if type == .vec3 && componentType == .short { return simd_short3( simd_double3( m ) ) as? T }
        case is simd_ushort3.Type:
            if type == .vec3 && componentType == .ushort { return simd_ushort3( simd_double3( m ) ) as? T }
        case is simd_uint3.Type:
            if type == .vec3 && componentType == .uint { return simd_uint3( simd_double3( m ) ) as? T }
        case is simd_float3.Type:
            if type == .vec3 && componentType == .float { return simd_float3( simd_double3( m ) ) as? T }
            
        // MARK: vec4 type
        case is simd_char4.Type:
            if type == .vec4 && componentType == .byte { return simd_char4( simd_double4( m ) ) as? T }
        case is simd_uchar4.Type:
            if type == .vec4 && componentType == .ubyte { return simd_uchar4( simd_double4( m ) ) as? T }
        case is simd_short4.Type:
            if type == .vec4 && componentType == .short { return simd_short4( simd_double4( m ) ) as? T }
        case is simd_ushort4.Type:
            if type == .vec4 && componentType == .ushort { return simd_ushort4( simd_double4( m ) ) as? T }
        case is simd_uint4.Type:
            if type == .vec4 && componentType == .uint { return simd_uint4( simd_double4( m ) ) as? T }
        case is simd_float4.Type:
            if type == .vec4 && componentType == .float { return simd_float4( simd_double4( m ) ) as? T }
            
        // MARK: mat2 type
        case is simd_float2x2.Type: // matrix_float2x2
            if type == .mat2 && componentType == .float {
                return simd_float2x2.init(columns:(
                    simd_float2( Float(m[0]), Float(m[1]) ),
                    simd_float2( Float(m[2]), Float(m[3]) )
                )) as? T
            }
            
        // MARK: mat3 type
        case is simd_float3x3.Type: // matrix_float3x3
            if type == .mat3 && componentType == .float {
                return simd_float3x3.init(columns:(
                    simd_float3( Float(m[0]), Float(m[1]), Float(m[2]) ),
                    simd_float3( Float(m[4]), Float(m[5]), Float(m[6]) ),
                    simd_float3( Float(m[7]), Float(m[8]), Float(m[9]) )
                )) as? T
            }
            
        case is simd_float4x4.Type: // matrix_float4x4
            if type == .mat4 && componentType == .float {
                return simd_float4x4.init(columns:(
                    simd_float4( Float(m[0]), Float(m[1]), Float(m[2]), Float(m[3]) ),
                    simd_float4( Float(m[4]), Float(m[5]), Float(m[6]), Float(m[7]) ),
                    simd_float4( Float(m[8]), Float(m[9]), Float(m[10]), Float(m[11]) ),
                    simd_float4( Float(m[12]), Float(m[13]), Float(m[14]), Float(m[15]) )
                )) as? T
            }
            
        default:
            break
        }
        return nil
    }
    
    // MARK: - min to Scalar, Vector, or Matrix
    
    public func min<T>(as _type: T.Type) -> T? {
        guard let m = min else { return nil }
        switch _type
        {
        // MARK: scalar type
        case is Int8.Type: // simd_char1
            if type == .scalar && componentType == .byte { return Int8(m[0]) as? T }
        case is UInt8.Type: // simd_uchar1
            if type == .scalar && componentType == .ubyte { return UInt8(m[0]) as? T }
        case is Int16.Type: // simd_short1
            if type == .scalar && componentType == .short { return Int16(m[0]) as? T }
        case is UInt16.Type: // simd_ushort1
            if type == .scalar && componentType == .ushort { return UInt16(m[0]) as? T }
        case is UInt32.Type: // simd_uint1
            if type == .scalar && componentType == .uint { return UInt32(m[0]) as? T }
        case is UInt.Type: // simd_uint1
            if type == .scalar && componentType == .uint { return UInt(m[0]) as? T }
        case is Float.Type: // simd_float1
            if type == .scalar && componentType == .float { return Float(m[0]) as? T }
            
        // MARK: vec2 type
        case is simd_char2.Type:
            if type == .vec2 && componentType == .byte { return simd_char2( simd_double2( m ) ) as? T }
        case is simd_uchar2.Type:
            if type == .vec2 && componentType == .ubyte { return simd_uchar2( simd_double2( m ) ) as? T }
        case is simd_short2.Type:
            if type == .vec2 && componentType == .short { return simd_short2( simd_double2( m ) ) as? T }
        case is simd_ushort2.Type:
            if type == .vec2 && componentType == .ushort { return simd_ushort2( simd_double2( m ) ) as? T }
        case is simd_uint2.Type:
            if type == .vec2 && componentType == .uint { return simd_uint2( simd_double2( m ) ) as? T }
        case is simd_float2.Type:
            if type == .vec2 && componentType == .float { return simd_float2( simd_double2( m ) ) as? T }
         
        // MARK: vec3 type
        case is simd_char3.Type:
            if type == .vec3 && componentType == .byte { return simd_char3( simd_double3( m ) ) as? T }
        case is simd_uchar3.Type:
            if type == .vec3 && componentType == .ubyte { return simd_uchar3( simd_double3( m ) ) as? T }
        case is simd_short3.Type:
            if type == .vec3 && componentType == .short { return simd_short3( simd_double3( m ) ) as? T }
        case is simd_ushort3.Type:
            if type == .vec3 && componentType == .ushort { return simd_ushort3( simd_double3( m ) ) as? T }
        case is simd_uint3.Type:
            if type == .vec3 && componentType == .uint { return simd_uint3( simd_double3( m ) ) as? T }
        case is simd_float3.Type:
            if type == .vec3 && componentType == .float { return simd_float3( simd_double3( m ) ) as? T }
            
        // MARK: vec4 type
        case is simd_char4.Type:
            if type == .vec4 && componentType == .byte { return simd_char4( simd_double4( m ) ) as? T }
        case is simd_uchar4.Type:
            if type == .vec4 && componentType == .ubyte { return simd_uchar4( simd_double4( m ) ) as? T }
        case is simd_short4.Type:
            if type == .vec4 && componentType == .short { return simd_short4( simd_double4( m ) ) as? T }
        case is simd_ushort4.Type:
            if type == .vec4 && componentType == .ushort { return simd_ushort4( simd_double4( m ) ) as? T }
        case is simd_uint4.Type:
            if type == .vec4 && componentType == .uint { return simd_uint4( simd_double4( m ) ) as? T }
        case is simd_float4.Type:
            if type == .vec4 && componentType == .float { return simd_float4( simd_double4( m ) ) as? T }
            
        // MARK: mat2 type
        case is simd_float2x2.Type: // matrix_float2x2
            if type == .mat2 && componentType == .float {
                return simd_float2x2.init(columns:(
                    simd_float2( Float(m[0]), Float(m[1]) ),
                    simd_float2( Float(m[2]), Float(m[3]) )
                )) as? T
            }
            
        // MARK: mat3 type
        case is simd_float3x3.Type: // matrix_float3x3
            if type == .mat3 && componentType == .float {
                return simd_float3x3.init(columns:(
                    simd_float3( Float(m[0]), Float(m[1]), Float(m[2]) ),
                    simd_float3( Float(m[4]), Float(m[5]), Float(m[6]) ),
                    simd_float3( Float(m[7]), Float(m[8]), Float(m[9]) )
                )) as? T
            }
            
        case is simd_float4x4.Type: // matrix_float4x4
            if type == .mat4 && componentType == .float {
                return simd_float4x4.init(columns:(
                    simd_float4( Float(m[0]), Float(m[1]), Float(m[2]), Float(m[3]) ),
                    simd_float4( Float(m[4]), Float(m[5]), Float(m[6]), Float(m[7]) ),
                    simd_float4( Float(m[8]), Float(m[9]), Float(m[10]), Float(m[11]) ),
                    simd_float4( Float(m[12]), Float(m[13]), Float(m[14]), Float(m[15]) )
                )) as? T
            }
            
        default:
            break
        }
        return nil
    }
}

extension glTF.Material {
    public var emissiveFactor_asFloat3: simd_float3 {
        get { return simd_float3(emissiveFactor) }
    }
}

extension glTF.Material.PBRMetallicRoughness {
    public var baseColorFactor_asFloat4: simd_float4 {
        return simd_float4( baseColorFactor )
    }
}

extension glTF.Node {
    // When `matrix` is defined, it MUST be decomposable to TRS properties. (Transformation matrices cannot skew or shear.)
    // When a node is targted for animation (referenced by an `animation.channel.target`), only TRS properties MAY be present; `matrix` MUST NOT be present
    
    public var matrix_asFloat4x4: simd_float4x4? {
        get {
            if let m = matrix {
                return simd_float4x4(columns: (
                    simd_float4(m[ 0], m[ 1], m[ 2], m[ 3]),
                    simd_float4(m[ 4], m[ 5], m[ 6], m[ 7]),
                    simd_float4(m[ 8], m[ 9], m[10], m[11]),
                    simd_float4(m[12], m[13], m[14], m[15])
                ))
            }
            return nil
        }
    }
    
    public var scale_asFloat3: simd_float3? {
        get {
            if matrix != nil { return nil } // matrix should not be present
            return simd_float3( scale ?? [1, 1, 1] )
        }
    }
    
    public var rotation_asQuatF: simd_quatf? {
        get {
            if matrix != nil { return nil } // matrix should not be present
            return simd_quatf( vector:simd_float4( rotation ?? [0, 0, 0, 1] ) )
        }
    }
    
    public var translation_asFloat3: simd_float3? {
        get {
            if matrix != nil { return nil } // matrix should not be present
            return simd_float3( translation ?? [0, 0, 0] )
        }
    }
    
    public func matrixFromTRS() -> simd_float4x4? {
        if matrix != nil { return nil } // matrix should not be present
        
        if rotation != nil || scale != nil || translation != nil { // one of TRS should be present.
            let rotM = simd_float4x4( simd_quatf( vector: simd_float4( rotation ?? [0, 0, 0, 1] ) ) )
            let S = simd_float3( scale ?? [1, 1, 1] )
            let T = simd_float3( translation ?? [ 0, 0, 0 ] )
            
            return simd_float4x4(columns: (
                S.x * rotM.columns.0,
                S.y * rotM.columns.1,
                S.z * rotM.columns.2,
                simd_float4( T, 1 )
            ))
        }
        
        return simd_float4x4(1.0) // return Identity
    }
    
    public func decomposeMatrixToTRS() -> (translation: simd_float3, rotation: simd_quatf, scale: simd_float3)? {
        guard let m = matrix else { return nil } // matrix should be present
        
        let scaledXAxis = simd_float3( m[0], m[1], m[2] )
        let scaledYAxis = simd_float3( m[4], m[5], m[6] )
        let scaledZAxis = simd_float3( m[8], m[9], m[10] )
        
        let scale = simd_float3(
            simd_length( scaledXAxis ),
            simd_length( scaledYAxis ),
            simd_length( scaledZAxis )
        )
        
        let rotMat = simd_float3x3(columns: (
            scaledXAxis / scale.x,
            scaledYAxis / scale.y,
            scaledZAxis / scale.z
        ))
        
        
        return (
            simd_float3( m[12], m[13], m[14] ),
            simd_quatf(rotMat),
            scale
        )
    }
}
