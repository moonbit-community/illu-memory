///|
#external
type View[T]

///|
pub fn[T : Instruction] View::length(view : View[T]) -> Int32 {
  Instruction::length(view)
}

///|
extern "js" fn View::from_memory_int32(memory : Memory) -> View[Int32] = "(memory) => new Int32Array(memory.buffer,0,memory.buffer.byteLength >>> 2)"

///|
extern "js" fn View::to_memory_int32(view : View[Int32]) -> Memory = "(view) => new Uint8Array(view.buffer)"

///|
extern "js" fn View::store_int32(
  view : View[Int32],
  index : Int32,
  value : Int32,
) = "(view,index,value) => view[index] = value"

///|
extern "js" fn View::load_int32(view : View[Int32], index : Int32) -> Int32 = "(view,index)  => view[index]"

///|
extern "js" fn View::length_int32(view : View[Int32]) -> Int32 = "(view) => view.length"

///|
extern "js" fn View::from_memory_uint32(memory : Memory) -> View[UInt32] = "(memory) => new Uint32Array(memory.buffer,0,memory.buffer.byteLength >>> 2)"

///|
extern "js" fn View::to_memory_uint32(view : View[UInt32]) -> Memory = "(view) => new Uint8Array(view.buffer)"

///|
extern "js" fn View::store_uint32(
  view : View[UInt32],
  index : Int32,
  value : UInt32,
) = "(view,index,value) => view[index] = value"

///|
extern "js" fn View::load_uint32(view : View[UInt32], index : Int32) -> UInt32 = "(view,index) => view[index]"

///|
extern "js" fn View::length_uint32(view : View[UInt32]) -> Int32 = "(view) => view.length"

///|
extern "js" fn View::from_memory_int16(memory : Memory) -> View[Int16] = "(memory) => new Int16Array(memory.buffer,0,memory.buffer.byteLength >>> 1)"

///|
extern "js" fn View::to_memory_int16(view : View[Int16]) -> Memory = "(view) => new Uint8Array(view.buffer)"

///|
extern "js" fn View::store_int16(
  view : View[Int16],
  index : Int32,
  value : Int16,
) = "(view,index,value) => view[index] = value"

///|
extern "js" fn View::load_int16(view : View[Int16], index : Int32) -> Int16 = "(view,index) => view[index]"

///|
extern "js" fn View::length_int16(view : View[Int16]) -> Int32 = "(view) => view.length"

///|
extern "js" fn View::from_memory_uint16(memory : Memory) -> View[UInt16] = "(memory) => new Uint16Array(memory.buffer,0,memory.buffer.byteLength >>> 1)"

///|
extern "js" fn View::to_memory_uint16(view : View[UInt16]) -> Memory = "(view) => new Uint8Array(view.buffer)"

///|
extern "js" fn View::store_uint16(
  view : View[UInt16],
  index : Int32,
  value : UInt16,
) = "(view,index,value) => view[index] = value"

///|
extern "js" fn View::load_uint16(view : View[UInt16], index : Int32) -> UInt16 = "(view,index) => view[index]"

///|
extern "js" fn View::length_uint16(view : View[UInt16]) -> Int32 = "(view) => view.length"

///|
pub impl Instruction for Int32 with fn load(view, index) {
  View::load_int32(view, index)
}

///|
pub impl Instruction for Int32 with fn store(view, index, value) {
  View::store_int32(view, index, value)
}

///|
pub impl Instruction for Int32 with fn from_memory(memory) {
  View::from_memory_int32(memory)
}

///|
pub impl Instruction for Int32 with fn to_memory(view) {
  View::to_memory_int32(view)
}

///|
pub impl Instruction for Int32 with fn length(view) {
  View::length_int32(view)
}

///|
pub impl Instruction for UInt32 with fn load(view, index) {
  View::load_uint32(view, index)
}

///|
pub impl Instruction for UInt32 with fn store(view, index, value) {
  View::store_uint32(view, index, value)
}

///|
pub impl Instruction for UInt32 with fn from_memory(memory) {
  View::from_memory_uint32(memory)
}

///|
pub impl Instruction for UInt32 with fn to_memory(view) {
  View::to_memory_uint32(view)
}

///|
pub impl Instruction for UInt32 with fn length(view) {
  View::length_uint32(view)
}

///|
pub impl Instruction for Int16 with fn load(view, index) {
  View::load_int16(view, index)
}

///|
pub impl Instruction for Int16 with fn store(view, index, value) {
  View::store_int16(view, index, value)
}

///|
pub impl Instruction for Int16 with fn from_memory(memory) {
  View::from_memory_int16(memory)
}

///|
pub impl Instruction for Int16 with fn to_memory(view) {
  View::to_memory_int16(view)
}

///|
pub impl Instruction for Int16 with fn length(view) {
  View::length_int16(view)
}

///|
pub impl Instruction for UInt16 with fn load(view, index) {
  View::load_uint16(view, index)
}

///|
pub impl Instruction for UInt16 with fn store(view, index, value) {
  View::store_uint16(view, index, value)
}

///|
pub impl Instruction for UInt16 with fn from_memory(memory) {
  View::from_memory_uint16(memory)
}

///|
pub impl Instruction for UInt16 with fn to_memory(view) {
  View::to_memory_uint16(view)
}

///|
pub impl Instruction for UInt16 with fn length(view) {
  View::length_uint16(view)
}

///|
pub impl Instruction for Int64 with fn load(view, index) {
  let view32 = unsafe_view_int64_to_view_int(view)
  let int32_index = index * 2
  let lo = View::load_int32(view32, int32_index)
  let hi = View::load_int32(view32, int32_index + 1)
  (hi.to_int64() << 32) | (lo.to_int64() & 0xFFFFFFFFL)
}

///|
pub impl Instruction for Int64 with fn store(view, index, value) {
  let view32 = unsafe_view_int64_to_view_int(view)
  let int32_index = index * 2
  View::store_int32(view32, int32_index, value.to_int())
  View::store_int32(view32, int32_index + 1, (value >> 32).to_int())
}

///|
fn unsafe_view_int_to_view_int64(view : View[Int32]) -> View[Int64] = "%identity"

///|
fn unsafe_view_int64_to_view_int(view : View[Int64]) -> View[Int32] = "%identity"

///|
pub impl Instruction for Int64 with fn from_memory(memory) {
  unsafe_view_int_to_view_int64(View::from_memory_int32(memory))
}

///|
pub impl Instruction for Int64 with fn to_memory(view) {
  View::to_memory_int32(unsafe_view_int64_to_view_int(view))
}

///|
pub impl Instruction for Int64 with fn length(view) {
  let view32 = unsafe_view_int64_to_view_int(view)
  View::length_int32(view32) >> 1
}

///|
fn unsafe_view_uint64_to_view_int64(view : View[UInt64]) -> View[Int64] = "%identity"

///|
fn unsafe_view_int64_to_view_uint64(view : View[Int64]) -> View[UInt64] = "%identity"

///|
pub impl Instruction for UInt64 with fn load(view, index) {
  let int64_view = unsafe_view_uint64_to_view_int64(view)
  let int64_value = Instruction::load(int64_view, index)
  Int64::reinterpret_as_uint64(int64_value)
}

///|
pub impl Instruction for UInt64 with fn store(view, index, value) {
  let int64_view = unsafe_view_uint64_to_view_int64(view)
  let int64_value = UInt64::reinterpret_as_int64(value)
  Instruction::store(int64_view, index, int64_value)
}

///|
pub impl Instruction for UInt64 with fn from_memory(memory) {
  let int64_view : View[Int64] = Instruction::from_memory(memory)
  unsafe_view_int64_to_view_uint64(int64_view)
}

///|
pub impl Instruction for UInt64 with fn to_memory(view) {
  let int64_view = unsafe_view_uint64_to_view_int64(view)
  Instruction::to_memory(int64_view)
}

///|
pub impl Instruction for UInt64 with fn length(view) {
  let int64_view = unsafe_view_uint64_to_view_int64(view)
  Instruction::length(int64_view)
}
