import Foundation

public class JsonElement: Decodable
{
    public enum JsonType { case null, object, array, boolean, number, string }
    
    private let _type: JsonType
    private let _value: Any
    
    // MARK: - Initializer
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let arr = try? container.decode([JsonElement].self) {
            _type = .array
            _value = arr
        }
        else if let obj = try? container.decode([String:JsonElement].self) {
            _type = .object
            _value = obj
        }
        else if let bool = try? container.decode(Bool.self) {
            _type = .boolean
            _value = bool
        }
        else if let num = try? container.decode(Double.self) {
            _type = .number
            _value = num
        }
        else if let str = try? container.decode(String.self) {
            _type = .string
            _value = str
        }
        else if container.decodeNil() {
            _type = .null
            _value = 0
        }
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unexpected Json Type value")
        }
    }
    
    // MARK: - Computed Properties (getter)
    
    public var type: JsonType { get { return _type } }
    
    // MARK: - Convenience Computed Properties
    
    public var isArray:Bool { get { return _type == .array } }
    public var isObject:Bool { get { return _type == .object } }
    public var isNull:Bool { get { return _type == .null } }
    public var isBoolean:Bool { get { return _type == .boolean } }
    public var isNumber:Bool { get { return _type == .number } }
    public var isString:Bool { get { return _type == .string } }
    
    public var array: [JsonElement]? { get { return isArray ? (_value as! [JsonElement]) : nil } }
    public var object: [String:JsonElement]? { get { return isObject ? (_value as! [String:JsonElement]) : nil } }
    public var boolean: Bool? { get { return isBoolean ? (_value as! Bool) : nil } }
    public var number: Double? { get { return isNumber ? (_value as! Double) : nil } }
    public var string: String? { get { return isString ? (_value as! String) : nil } }
}
