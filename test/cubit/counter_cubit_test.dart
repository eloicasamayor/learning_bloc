import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/logic/cubit/counter_cubit.dart';

void main() {
  group('CounterCubit', () {
    CounterCubit counterCubit = CounterCubit();

    setUp(() {
      counterCubit = CounterCubit();
    });

    tearDown(() {
      counterCubit.close();
    });

    test(
        'the initial state for the CounterCubit is CounterState(counterValue:0)',
        () {
      expect(
        counterCubit.state,
        CounterState(counterValue: 0, wasIncremented: true),
      );
    });

    blocTest(
      'the cubit should emit a CounterState(counterValue:1, wasIncremented:true when cubit.increment() function is called',
      build: () => counterCubit,
      act: (CounterCubit cubit) => cubit.increment(),
      expect: () => [CounterState(counterValue: 1, wasIncremented: true)],
    );

    blocTest(
      'the cubit should emit a CounterState(counterValue:-1, wasIncremented:false when cubit.increment() function is called',
      build: () => counterCubit,
      act: (CounterCubit cubit) => cubit.decrement(),
      expect: () => [CounterState(counterValue: -1, wasIncremented: false)],
    );
  });
}
