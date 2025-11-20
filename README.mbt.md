# illusory0x0/memory

Low-level memory operation library providing typed views over raw byte buffers with support for various integer types in little-endian format only. This package offers a `Memory` type for raw byte storage and a generic `View[T]` type for typed access to memory regions.

**Note: This library only supports little-endian byte order and does not provide big-endian operations or endianness control.**

## Core Components

### Memory

The `Memory` type represents a contiguous block of bytes, providing basic operations for raw memory access.

```moonbit
///|
test "basic memory operations" {
  // Create a 16-byte memory block initialized with zeros
  let memory = @memory.Memory::make(16, 0)

  // Access memory length
  inspect(memory.length(), content="16")

  // Set and get individual bytes
  memory[0] = 0xFFU.to_byte()
  memory[1] = 0x12U.to_byte()
  inspect(memory[0], content="b'\\xFF'")
  inspect(memory[1], content="b'\\x12'")
}
```

### View[T]

The `View[T]` type provides typed access to memory regions, allowing you to work with different data types while maintaining memory efficiency. It supports various integer types through the `Instruction` trait.

```moonbit
///|
test "basic view operations" {
  let memory = @memory.Memory::make(16, 0)
  let int_view : @memory.View[Int] = @memory.View::from_memory(memory)

  // Store integers in little-endian format
  int_view[0] = 0x12345678
  int_view[1] = 0xABCDEF00
  inspect(int_view[0], content="305419896")
  inspect(int_view[1], content="-1412567296")
  inspect(int_view.length(), content="4") // 16 bytes / 4 bytes per Int
}
```

## Supported Types

The package supports multiple integer types via the `Instruction` trait:

### 32-bit Types

```moonbit
///|
test "32-bit integer operations" {
  let memory = @memory.Memory::make(16, 0)

  // Signed integers
  let int_view : @memory.View[Int] = @memory.View::from_memory(memory)
  int_view[0] = -2147483648 // Int32 min
  int_view[1] = 2147483647 // Int32 max
  inspect(int_view[0], content="-2147483648")
  inspect(int_view[1], content="2147483647")

  // Unsigned integers
  let memory2 = @memory.Memory::make(16, 0)
  let uint_view : @memory.View[UInt] = @memory.View::from_memory(memory2)
  uint_view[0] = 0xFFFFFFFFU
  uint_view[1] = 0x12345678U
  inspect(uint_view[0], content="4294967295")
  inspect(uint_view[1], content="305419896")
}
```

### 16-bit Types

```moonbit
///|
test "16-bit integer operations" {
  let memory = @memory.Memory::make(16, 0)

  // Manually set bytes for Int16 values (little-endian)
  memory[0] = 1U.to_byte() // Low byte of 1
  memory[1] = 0U.to_byte() // High byte of 1
  memory[2] = 255U.to_byte() // Low byte of 32767
  memory[3] = 127U.to_byte() // High byte of 32767
  let int16_view : @memory.View[Int16] = @memory.View::from_memory(memory)
  inspect(int16_view[0], content="1")
  inspect(int16_view[1], content="32767")
  inspect(int16_view.length(), content="8") // 16 bytes / 2 bytes per Int16

  // UInt16 operations
  let memory2 = @memory.Memory::make(16, 0)
  memory2[0] = 210U.to_byte() // 0xD2 - low byte of 1234
  memory2[1] = 4U.to_byte() // 0x04 - high byte of 1234
  let uint16_view : @memory.View[UInt16] = @memory.View::from_memory(memory2)
  inspect(uint16_view[0], content="1234")
}
```

### 64-bit Types

```moonbit
///|
test "64-bit integer operations" {
  let memory = @memory.Memory::make(32, 0)

  // Signed 64-bit integers
  let int64_view : @memory.View[Int64] = @memory.View::from_memory(memory)
  int64_view[0] = 9223372036854775807L // Int64 max
  int64_view[1] = -9223372036854775808L // Int64 min
  int64_view[2] = 1234567890123456789L
  inspect(int64_view[0], content="9223372036854775807")
  inspect(int64_view[1], content="-9223372036854775808")
  inspect(int64_view[2], content="1234567890123456789")
  inspect(int64_view.length(), content="4") // 32 bytes / 8 bytes per Int64

  // Unsigned 64-bit integers
  let memory2 = @memory.Memory::make(32, 0)
  let uint64_view : @memory.View[UInt64] = @memory.View::from_memory(memory2)
  uint64_view[0] = 18446744073709551615UL // UInt64 max
  uint64_view[1] = 0xFEDCBA9876543210UL
  inspect(uint64_view[0], content="18446744073709551615")
  inspect(uint64_view[1], content="18364758544493064720")
}
```

## Memory Layout and Little-Endian Format

**Important: This library exclusively uses little-endian byte order.** All multi-byte values are stored and accessed in little-endian format. Big-endian operations and endianness control are not supported.

This design choice ensures consistent behavior across platforms and simplifies the API, making it ideal for applications that work primarily with little-endian data (which includes most modern processors and network protocols).

```moonbit
///|
test "little-endian memory layout demonstration" {
  let memory = @memory.Memory::make(8, 0)
  let int_view : @memory.View[Int] = @memory.View::from_memory(memory)

  // Store a known value - will always be stored in little-endian
  int_view[0] = 0x12345678

  // Convert back to memory to examine individual bytes
  let memory_result = int_view.to_memory()

  // In little-endian format: 0x12345678 becomes [0x78, 0x56, 0x34, 0x12]
  // (least significant byte first)
  inspect(memory_result[0], content="b'\\x78'") // 0x78 (LSB)
  inspect(memory_result[1], content="b'\\x56'") // 0x56
  inspect(memory_result[2], content="b'\\x34'") // 0x34
  inspect(memory_result[3], content="b'\\x12'") // 0x12 (MSB)
}
```

## Type Conversions and Reinterpretation

You can reinterpret the same memory region with different types, useful for low-level data manipulation.

```moonbit
///|
test "type reinterpretation" {
  let memory = @memory.Memory::make(16, 0)

  // Write as signed integers
  let int_view : @memory.View[Int] = @memory.View::from_memory(memory)
  int_view[0] = -1
  int_view[1] = 0x12345678

  // Reinterpret as unsigned integers
  let uint_view : @memory.View[UInt] = @memory.View::from_memory(
    int_view.to_memory(),
  )
  inspect(uint_view[0], content="4294967295") // -1 as UInt32
  inspect(uint_view[1], content="305419896") // Same bit pattern
}
```

## Advanced Usage

### Mixed-Size Operations

You can work with the same memory using different view sizes for complex data structures.

```moonbit
///|
test "mixed size operations" {
  let memory = @memory.Memory::make(16, 0)

  // Set up memory with specific byte pattern
  memory[0] = 52U.to_byte() // 0x34
  memory[1] = 18U.to_byte() // 0x12
  memory[2] = 120U.to_byte() // 0x78
  memory[3] = 86U.to_byte() // 0x56

  // Read as 16-bit values
  let int16_view : @memory.View[Int16] = @memory.View::from_memory(memory)
  inspect(int16_view[0], content="4660") // 0x1234
  inspect(int16_view[1], content="22136") // 0x5678

  // Read the same memory as 32-bit values
  let int_view : @memory.View[Int] = @memory.View::from_memory(
    int16_view.to_memory(),
  )
  inspect(int_view[0], content="1450709556") // 0x56781234
}
```

### Zero Initialization

Memory blocks are properly zero-initialized when created.

```moonbit
///|
test "zero initialization verification" {
  let memory = @memory.Memory::make(16, 0)
  let view : @memory.View[Int] = @memory.View::from_memory(memory)

  // All values should be zero
  inspect(view[0], content="0")
  inspect(view[1], content="0")
  inspect(view[2], content="0")
  inspect(view[3], content="0")
}
```

## Use Cases

This package is ideal for:

- **Binary data processing**: Reading and writing little-endian binary file formats
- **Network protocol implementation**: Handling network packets with mixed data types (most network protocols use little-endian or have endianness specified separately)
- **Embedded systems programming**: Efficient memory usage in resource-constrained environments with little-endian processors
- **Cryptographic operations**: Byte-level manipulation of cryptographic data in little-endian format
- **Performance-critical applications**: Zero-copy data access patterns with consistent little-endian byte order

## Limitations

- **Endianness**: Only little-endian byte order is supported. Big-endian operations are not available.
- **Portability**: Applications requiring big-endian data or endianness conversion should use alternative libraries.
- **Cross-platform compatibility**: When interfacing with big-endian systems, manual byte order conversion will be required.

The combination of raw memory access and typed views provides both flexibility and type safety, making it suitable for system-level programming while maintaining MoonBit's safety guarantees and consistent little-endian behavior.