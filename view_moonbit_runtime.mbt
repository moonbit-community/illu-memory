///|
/// 
/// Although `View[T]` declare underlying representation type is `FixedArray[T]`,
/// actually it is underlying representation type is `Memory`.
/// 
/// because `to_memory` and `from_memory` does not change the MoonBit Object's meta data.
/// 
/// use `FixedArray[T]` is in order to use `%fixedarray.unsafe_get` and `%fixedarray.unsafe_set`
/// instructions to implement `load` and `store` functions.
/// 
struct View[T](FixedArray[T])

///|
pub fn[T : Instruction] View::length(view : View[T]) -> Int32 {
  Instruction::length(view)
}

///|
fn[T] View::bytes_length(view : View[T]) -> Int32 = "%fixedarray.length"

///|
fn[T] unsafe_memory_to_view(memory : Memory) -> View[T] = "%identity"

///|
fn[T] unsafe_view_to_memory(view : View[T]) -> Memory = "%identity"

///|
pub impl Instruction for Int32 with fn from_memory(memory) {
  unsafe_memory_to_view(memory)
}

///|
pub impl Instruction for Int32 with fn to_memory(view) {
  unsafe_view_to_memory(view)
}

///|
pub impl Instruction for Int32 with fn load(view, index) = "%fixedarray.unsafe_get"

///|
pub impl Instruction for Int32 with fn store(view, index, value) = "%fixedarray.unsafe_set"

///|
pub impl Instruction for Int32 with fn length(view) {
  View::bytes_length(view) >> Int_elem_size_shift
}

///|
pub impl Instruction for UInt32 with fn from_memory(memory) {
  unsafe_memory_to_view(memory)
}

///|
pub impl Instruction for UInt32 with fn to_memory(view) {
  unsafe_view_to_memory(view)
}

///|
pub impl Instruction for UInt32 with fn load(view, index) = "%fixedarray.unsafe_get"

///|
pub impl Instruction for UInt32 with fn store(view, index, value) = "%fixedarray.unsafe_set"

///|
pub impl Instruction for UInt32 with fn length(view) {
  View::bytes_length(view) >> UInt_elem_size_shift
}

///|
pub impl Instruction for UInt16 with fn from_memory(memory) {
  unsafe_memory_to_view(memory)
}

///|
pub impl Instruction for UInt16 with fn to_memory(view) {
  unsafe_view_to_memory(view)
}

///|
pub impl Instruction for UInt16 with fn load(view, index) = "%fixedarray.unsafe_get"

///|
pub impl Instruction for UInt16 with fn store(view, index, value) = "%fixedarray.unsafe_set"

///|
pub impl Instruction for UInt16 with fn length(view) {
  View::bytes_length(view) >> UInt16_elem_size_shift
}

///|
pub impl Instruction for Int16 with fn from_memory(memory) {
  unsafe_memory_to_view(memory)
}

///|
pub impl Instruction for Int16 with fn to_memory(view) {
  unsafe_view_to_memory(view)
}

///|
pub impl Instruction for Int16 with fn load(view, index) = "%fixedarray.unsafe_get"

///|
pub impl Instruction for Int16 with fn store(view, index, value) = "%fixedarray.unsafe_set"

///|
pub impl Instruction for Int16 with fn length(view) {
  View::bytes_length(view) >> Int16_elem_size_shift
}

///|
pub impl Instruction for Int64 with fn from_memory(memory) {
  unsafe_memory_to_view(memory)
}

///|
pub impl Instruction for Int64 with fn to_memory(view) {
  unsafe_view_to_memory(view)
}

///|
pub impl Instruction for Int64 with fn load(view, index) = "%fixedarray.unsafe_get"

///|
pub impl Instruction for Int64 with fn store(view, index, value) = "%fixedarray.unsafe_set"

///|
pub impl Instruction for Int64 with fn length(view) {
  View::bytes_length(view) >> Int64_elem_size_shift
}

///|
pub impl Instruction for UInt64 with fn from_memory(memory) {
  unsafe_memory_to_view(memory)
}

///|
pub impl Instruction for UInt64 with fn to_memory(view) {
  unsafe_view_to_memory(view)
}

///|
pub impl Instruction for UInt64 with fn load(view, index) = "%fixedarray.unsafe_get"

///|
pub impl Instruction for UInt64 with fn store(view, index, value) = "%fixedarray.unsafe_set"

///|
pub impl Instruction for UInt64 with fn length(view) {
  View::bytes_length(view) >> UInt64_elem_size_shift
}
