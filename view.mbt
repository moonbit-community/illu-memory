///|
#alias("_[_]=_")
pub fn[T : Instruction] View::set(
  view : View[T],
  index : Int32,
  value : T,
) -> Unit {
  Instruction::store(view, index, value)
}

///|
#alias("_[_]")
pub fn[T : Instruction] View::get(view : View[T], index : Int32) -> T {
  Instruction::load(view, index)
}

///|
pub fn[T : Instruction] View::from_memory(memory : Memory) -> View[T] {
  Instruction::from_memory(memory)
}

///|
pub fn[T : Instruction] View::to_memory(view : View[T]) -> Memory {
  Instruction::to_memory(view)
}
