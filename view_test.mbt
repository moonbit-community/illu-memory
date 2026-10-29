///|
fn bytes_of_memory(memory : @memory.Memory) -> Bytes = "%identity"

///|
test "basic Int view operations" {
  let memory = @memory.Memory::make(16, 0)
  let view : @memory.View[Int32] = @memory.View::from_memory(memory)
  view[0] = 1
  view[1] = 2
  view[2] = 3
  view[3] = 4
  inspect(view.length(), content="4")
  let bytes : Bytes = bytes_of_memory(view.to_memory())
  inspect(
    bytes,
    content=(
      #|b"\x01\x00\x00\x00\x02\x00\x00\x00\x03\x00\x00\x00\x04\x00\x00\x00"
    ),
  )
}

///|
test "UInt view operations" {
  let memory = @memory.Memory::make(16, 0)
  let view : @memory.View[UInt32] = @memory.View::from_memory(memory)
  view[0] = 0xFFFFFFFFU
  view[1] = 0x12345678U
  view[2] = 0U
  view[3] = 0xABCDEF00U
  inspect(view.length(), content="4")

  // Test reading back the values
  inspect(view[0], content="4294967295")
  inspect(view[1], content="305419896")
  inspect(view[2], content="0")
  inspect(view[3], content="2882400000")
}

///|
test "Int16 view operations" {
  let memory = @memory.Memory::make(16, 0)
  let view : @memory.View[Int16] = @memory.View::from_memory(memory)
  inspect(view.length(), content="8")

  // First test zero initialization
  inspect(view[0], content="0")
  inspect(view[1], content="0")

  // Test storing positive values via array manipulation
  // Since we can't directly create Int16 literals, test with what the view can actually store
  let memory2 = @memory.Memory::make(16, 0)
  memory2[0] = 1U.to_byte()
  memory2[1] = 0U.to_byte() // 1 in little-endian
  memory2[2] = 255U.to_byte()
  memory2[3] = 127U.to_byte() // 32767 in little-endian
  memory2[4] = 0U.to_byte()
  memory2[5] = 128U.to_byte() // -32768 in little-endian
  let view2 : @memory.View[Int16] = @memory.View::from_memory(memory2)
  inspect(view2[0], content="1")
  inspect(view2[1], content="32767")
  inspect(view2[2], content="-32768")
}

///|
test "UInt16 view operations" {
  let memory = @memory.Memory::make(16, 0)
  let view : @memory.View[UInt16] = @memory.View::from_memory(memory)
  inspect(view.length(), content="8")

  // Test zero initialization
  inspect(view[0], content="0")

  // Test by manually setting bytes for known UInt16 values
  let memory2 = @memory.Memory::make(16, 0)
  memory2[0] = 210U.to_byte() // 0xD2
  memory2[1] = 4U.to_byte() // 0x04 - 1234 in little-endian
  memory2[2] = 255U.to_byte() // 0xFF
  memory2[3] = 255U.to_byte() // 0xFF - 65535 in little-endian
  memory2[4] = 205U.to_byte() // 0xCD
  memory2[5] = 171U.to_byte() // 0xAB - 0xABCD in little-endian
  let view2 : @memory.View[UInt16] = @memory.View::from_memory(memory2)
  inspect(view2[0], content="1234")
  inspect(view2[1], content="65535")
  inspect(view2[2], content="43981") // 0xABCD
}

///|
test "Int64 view operations" {
  let memory = @memory.Memory::make(32, 0)
  let view : @memory.View[Int64] = @memory.View::from_memory(memory)
  view[0] = 9223372036854775807L
  view[1] = -9223372036854775808L
  view[2] = 0L
  view[3] = 1234567890123456789L
  inspect(view.length(), content="4")

  // Test reading back the values
  inspect(view[0], content="9223372036854775807")
  inspect(view[1], content="-9223372036854775808")
  inspect(view[2], content="0")
  inspect(view[3], content="1234567890123456789")
}

///|
test "UInt64 view operations" {
  let memory = @memory.Memory::make(32, 0)
  let view : @memory.View[UInt64] = @memory.View::from_memory(memory)
  view[0] = 18446744073709551615UL
  view[1] = 0UL
  view[2] = 1234567890123456789UL
  view[3] = 0xFEDCBA9876543210UL
  inspect(view.length(), content="4")

  // Test reading back the values
  inspect(view[0], content="18446744073709551615")
  inspect(view[1], content="0")
  inspect(view[2], content="1234567890123456789")
  inspect(view[3], content="18364758544493064720")
}

///|
test "view length calculation for different types" {
  // Test that different view types have correct length calculation
  let memory32 = @memory.Memory::make(32, 0)
  let int_view : @memory.View[Int32] = @memory.View::from_memory(memory32)
  inspect(int_view.length(), content="8") // 32 bytes / 4 bytes per Int
  let int16_view : @memory.View[Int16] = @memory.View::from_memory(memory32)
  inspect(int16_view.length(), content="16") // 32 bytes / 2 bytes per Int16
  let int64_view : @memory.View[Int64] = @memory.View::from_memory(memory32)
  inspect(int64_view.length(), content="4") // 32 bytes / 8 bytes per Int64
}

///|
test "view bounds and edge cases" {
  let memory = @memory.Memory::make(8, 0)
  let view : @memory.View[Int32] = @memory.View::from_memory(memory)

  // Test boundary values
  view[0] = -2147483648 // Int32 min
  view[1] = 2147483647 // Int32 max
  inspect(view[0], content="-2147483648")
  inspect(view[1], content="2147483647")
  inspect(view.length(), content="2")
}

///|
test "view type conversion consistency" {
  let memory = @memory.Memory::make(16, 0)

  // Write as Int, read as UInt to test memory layout
  let int_view : @memory.View[Int32] = @memory.View::from_memory(memory)
  int_view[0] = -1
  int_view[1] = 0x12345678
  let uint_view : @memory.View[UInt32] = @memory.View::from_memory(
    int_view.to_memory(),
  )
  inspect(uint_view[0], content="4294967295") // -1 as UInt
  inspect(uint_view[1], content="305419896") // 0x12345678
}

///|
test "mixed size view operations" {
  let memory = @memory.Memory::make(16, 0)

  // Write with Int16 view by setting up memory manually
  // 0x1234 in little-endian: 34 12
  memory[0] = 52U.to_byte() // 0x34
  memory[1] = 18U.to_byte() // 0x12
  // 0x5678 in little-endian: 78 56 
  memory[2] = 120U.to_byte() // 0x78
  memory[3] = 86U.to_byte() // 0x56
  // 0xABCD in little-endian: CD AB
  memory[4] = 205U.to_byte() // 0xCD
  memory[5] = 171U.to_byte() // 0xAB
  // 0xEF00 in little-endian: 00 EF
  memory[6] = 0U.to_byte() // 0x00
  memory[7] = 239U.to_byte() // 0xEF
  let int16_view : @memory.View[Int16] = @memory.View::from_memory(memory)

  // Read with Int view (should combine pairs of Int16 values)
  let int_view : @memory.View[Int32] = @memory.View::from_memory(
    int16_view.to_memory(),
  )
  inspect(int_view[0], content="1450709556") // 0x56781234 in little-endian
  inspect(int_view[1], content="-285168691") // 0xEF00ABCD in little-endian
}

///|
test "zero initialization" {
  let memory = @memory.Memory::make(16, 0)
  let view : @memory.View[Int32] = @memory.View::from_memory(memory)

  // Memory should be zero-initialized
  inspect(view[0], content="0")
  inspect(view[1], content="0")
  inspect(view[2], content="0")
  inspect(view[3], content="0")
}

///|
test "64-bit views preserve little-endian bytes and shared memory" {
  let memory = @memory.Memory::make(16, 0)
  let unsigned : @memory.View[UInt64] = @memory.View::from_memory(memory)
  let signed : @memory.View[Int64] = @memory.View::from_memory(memory)
  unsigned[0] = 0x1122334455667788UL
  let expected : Array[Byte] = [0x88, 0x77, 0x66, 0x55, 0x44, 0x33, 0x22, 0x11]
  for i = 0; i < 8; i = i + 1 {
    assert_eq(memory[i], expected[i])
  }
  assert_eq(signed[0], 0x1122334455667788L)
  signed[1] = -1L
  assert_eq(unsigned[1], 0xFFFFFFFFFFFFFFFFUL)
  for i = 8; i < 16; i = i + 1 {
    assert_eq(memory[i], 0xFF)
  }
  memory[0] = 0xFF
  assert_eq(unsigned[0], 0x11223344556677FFUL)
}
