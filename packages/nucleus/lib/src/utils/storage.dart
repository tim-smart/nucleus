import 'dart:collection';

import 'package:nucleus/nucleus.dart';

abstract class NucleusStorage {
  Object? get(String key);
  void set(String key, Object? value);
}

class MemoryNucleusStorage implements NucleusStorage {
  final _map = HashMap<String, Object?>();

  @override
  Object? get(String key) => _map[key];

  @override
  void set(String key, Object? value) {
    _map[key] = value;
  }
}

const _noValue = {};

/// Create a [stateAtom], except it's value is persisted to a [NucleusStorage]
/// instance.
WritableAtom<A, A> stateAtomWithStorage<A>(
  A initialValue, {
  required String key,
  required Atom<NucleusStorage> storage,
  required A Function(dynamic json) fromJson,
  required dynamic Function(A a) toJson,
}) {
  final valueAtom = stateAtom<Object?>(_noValue);

  return proxyAtom((get) {
    final value = get(valueAtom);
    if (value != _noValue) {
      return value as A;
    }

    final storedValue = get(storage).get(key);
    return storedValue != null ? fromJson(storedValue) : initialValue;
  }, (get, set, value) {
    get(storage).set(key, toJson(value));
    set(valueAtom, value);
  });
}

typedef AtomWithStorageCreate<R, A> = R Function(
  AtomContext<R> get,
  A? Function() read,
  void Function(A value) write,
);

/// Create an atom that can read and write to a [NucleusStorage] instance.
///
/// Can be used to wrap other state management tools with persistence.
Atom<R> atomWithStorage<R, A>(
  AtomWithStorageCreate<R, A> create, {
  required String key,
  required Atom<NucleusStorage> storage,
  required A Function(dynamic json) fromJson,
  required dynamic Function(A a) toJson,
}) =>
    atom((get) {
      final s = get(storage);

      void write(A value) => s.set(key, toJson(value));

      A? read() {
        final value = s.get(key);
        return value != null ? fromJson(value) : null;
      }

      return create(get, read, write);
    });
