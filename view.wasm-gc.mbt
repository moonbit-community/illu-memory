///|
/// Due to this issue: [#1569](https://github.com/WebAssembly/design/issues/1569),
/// WebAssembly GC drafts implementation would be slower than other MoonBit backends.

///|
struct View[T](Memory)

///|
fn load_uint(memory : Memory, index : Int) -> UInt {
  let byte_index = index << UInt_elem_size_shift
  let b0 = memory.op_get(byte_index + 0).to_uint() << 0
  let b1 = memory.op_get(byte_index + 1).to_uint() << 8
  let b2 = memory.op_get(byte_index + 2).to_uint() << 16
  let b3 = memory.op_get(byte_index + 3).to_uint() << 24
  b0 | b1 | b2 | b3
}

///|
fn store_uint(memory : Memory, index : Int, value : UInt) -> Unit {
  let byte_index = index << UInt_elem_size_shift
  memory[byte_index + 0] = (value >> 0).to_byte()
  memory[byte_index + 1] = (value >> 8).to_byte()
  memory[byte_index + 2] = (value >> 16).to_byte()
  memory[byte_index + 3] = (value >> 24).to_byte()
}

///|
fn load_uint16(memory : Memory, index : Int) -> UInt16 {
  let byte_index = index << UInt16_elem_size_shift
  let b0 = memory.op_get(byte_index + 0).to_uint16() << 0
  let b1 = memory.op_get(byte_index + 1).to_uint16() << 8
  b0 | b1
}

///|
fn store_uint16(memory : Memory, index : Int, value : UInt16) -> Unit {
  let byte_index = index << UInt16_elem_size_shift
  memory[byte_index + 0] = (value >> 0).to_byte()
  memory[byte_index + 1] = (value >> 8).to_byte()
}

///|
fn load_uint64(memory : Memory, index : Int) -> UInt64 {
  let byte_index = index << UInt64_elem_size_shift
  let b0 = memory.op_get(byte_index + 0).to_uint64() << 0
  let b1 = memory.op_get(byte_index + 1).to_uint64() << 8
  let b2 = memory.op_get(byte_index + 2).to_uint64() << 16
  let b3 = memory.op_get(byte_index + 3).to_uint64() << 24
  let b4 = memory.op_get(byte_index + 4).to_uint64() << 32
  let b5 = memory.op_get(byte_index + 5).to_uint64() << 40
  let b6 = memory.op_get(byte_index + 6).to_uint64() << 48
  let b7 = memory.op_get(byte_index + 7).to_uint64() << 56
  b0 | b1 | b2 | b3 | b4 | b5 | b6 | b7
}

///|
fn store_uint64(memory : Memory, index : Int, value : UInt64) -> Unit {
  let byte_index = index << UInt64_elem_size_shift
  memory[byte_index + 0] = (value >> 0).to_byte()
  memory[byte_index + 1] = (value >> 8).to_byte()
  memory[byte_index + 2] = (value >> 16).to_byte()
  memory[byte_index + 3] = (value >> 24).to_byte()
  memory[byte_index + 4] = (value >> 32).to_byte()
  memory[byte_index + 5] = (value >> 40).to_byte()
  memory[byte_index + 6] = (value >> 48).to_byte()
  memory[byte_index + 7] = (value >> 56).to_byte()
}

///|
pub fn[T : Instruction] View::length(view : View[T]) -> Int {
  Instruction::length(view)
}

///|
pub impl Instruction for UInt with load(view, index) {
  load_uint(view.0, index)
}

///|
pub impl Instruction for UInt with store(view, index, value) {
  store_uint(view.0, index, value)
}

///|
pub impl Instruction for UInt with from_memory(memory) = "%identity"

///|
pub impl Instruction for UInt with to_memory(view) = "%identity"

///|
pub impl Instruction for UInt with length(view) {
  view.0.length() >> UInt_elem_size_shift
}

///|
pub impl Instruction for Int with load(view, index) {
  load_uint(view.0, index).reinterpret_as_int()
}

///|
pub impl Instruction for Int with store(view, index, value) {
  store_uint(view.0, index, value.reinterpret_as_uint())
}

///|
pub impl Instruction for Int with from_memory(memory) = "%identity"

///|
pub impl Instruction for Int with to_memory(view) = "%identity"

///|
pub impl Instruction for Int with length(view) {
  view.0.length() >> Int_elem_size_shift
}

///|
pub impl Instruction for UInt16 with load(view, index) {
  load_uint16(view.0, index)
}

///|
pub impl Instruction for UInt16 with store(view, index, value) {
  store_uint16(view.0, index, value)
}

///|
pub impl Instruction for UInt16 with from_memory(memory) = "%identity"

///|
pub impl Instruction for UInt16 with to_memory(view) = "%identity"

///|
pub impl Instruction for UInt16 with length(view) {
  view.0.length() >> UInt16_elem_size_shift
}

///|
pub impl Instruction for Int16 with load(view, index) {
  load_uint16(view.0, index).to_int().to_int16()
}

///|
pub impl Instruction for Int16 with store(view, index, value) {
  store_uint16(view.0, index, value.reinterpret_as_uint16())
}

///|
pub impl Instruction for Int16 with from_memory(memory) = "%identity"

///|
pub impl Instruction for Int16 with to_memory(view) = "%identity"

///|
pub impl Instruction for Int16 with length(view) {
  view.0.length() >> Int16_elem_size_shift
}

///|
pub impl Instruction for UInt64 with load(view, index) {
  load_uint64(view.0, index)
}

///|
pub impl Instruction for UInt64 with store(view, index, value) {
  store_uint64(view.0, index, value)
}

///|
pub impl Instruction for UInt64 with from_memory(memory) = "%identity"

///|
pub impl Instruction for UInt64 with to_memory(view) = "%identity"

///|
pub impl Instruction for UInt64 with length(view) {
  view.0.length() >> UInt64_elem_size_shift
}

///|
pub impl Instruction for Int64 with load(view, index) {
  load_uint64(view.0, index).reinterpret_as_int64()
}

///|
pub impl Instruction for Int64 with store(view, index, value) {
  store_uint64(view.0, index, value.reinterpret_as_uint64())
}

///|
pub impl Instruction for Int64 with from_memory(memory) = "%identity"

///|
pub impl Instruction for Int64 with to_memory(view) = "%identity"

///|
pub impl Instruction for Int64 with length(view) {
  view.0.length() >> Int64_elem_size_shift
}
