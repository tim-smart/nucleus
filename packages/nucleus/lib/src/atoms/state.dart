import 'package:nucleus/nucleus.dart';

/// See [stateAtom].
class StateAtom<Value> extends WritableAtom<Value, Value> {
  StateAtom(this.initialValue);

  /// The [Value] that this atom contains when first read.
  final Value initialValue;

  @override
  Value read(_) => _(this);

  @override
  void write(Store store, AtomSetter set, Value value) => set(this, value);
}

/// Create a simple atom with mutable state.
///
/// ```dart
/// final counter = stateAtom(0);
/// ```
///
/// If you want to ensure the state is not automatically disposed when not in
/// use, then call the [Atom.keepAlive] method.
///
/// ```dart
/// final counter = stateAtom(0)..keepAlive();
/// ```
WritableAtom<Value, Value> stateAtom<Value>(Value initialValue) =>
    StateAtom(initialValue);
