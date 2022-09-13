import 'package:nucleus/nucleus.dart';

class ReadOnlyAtom<Value> extends Atom<Value> {
  ReadOnlyAtom(
    this._reader, {
    super.keepAlive,
  });

  final AtomReader<Value> _reader;

  @override
  Value read(AtomGetter getter) => _reader(getter);
}

// Function API

Atom<Value> readOnlyAtom<Value>(
  AtomReader<Value> create, {
  bool? keepAlive,
}) =>
    ReadOnlyAtom(
      create,
      keepAlive: keepAlive,
    );