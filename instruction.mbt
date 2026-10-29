///|
/// little-endian load/store instructions for `Memory`
trait Instruction {
  fn load(view : View[Self], index : Int32) -> Self
  fn store(view : View[Self], index : Int32, value : Self) -> Unit
  /// share computer memory without copy 
  fn from_memory(memory : Memory) -> View[Self]
  /// share computer memory without copy
  fn to_memory(view : View[Self]) -> Memory
  fn length(view : View[Self]) -> Int32
}
