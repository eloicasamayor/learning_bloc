# flutter_bloc_concepts

This is a project developed following the course ["The Best Flutter Bloc Complete Course - Visualise, Understand, Learn & Practice Bloc Concepts."](https://www.youtube.com/watch?v=THCkkQ-V1-8&t=6089s), by Flutterly.
> by the way, I can confirm that it is the best Bloc course. 100% recommended for sure!

## Core concepts resume

### Navigation between screens
You can NAVIGATE inside Flutter by using
- Anonymous Routing (recommended for SMALL projects)
- Named Routing (recommended for MEDIUM projects)
- Generated Routing (recommended for LARGE projects)

The key is to PROVIDE a UNIQUE INSTANCE of a bloc/cubit.
You SHOULDN'T create MULTIPLE INSTANCES of the same bloc/cubit.
### BlocProvider() vs BlocProvider.value()
- BlocProvider() CREATES & PROVIDES a NEW INSTANCE of a bloc/cubit.
- BlocProvider.value() takes an ALREADY CREATED INSTANCE and PROVIDES it further.

### Ways to provide bloc instances
You can PROVIDE your cubit/bloc INSTANCES
- LOCALLY - when you want to provide the instance to A SINGLE SCREEN
- SPECIFICALLY - when you want to SPECIFICALLY PROVIDE it across 1 or more SCREENS
- GLOBALLY - when you want to provide it ACROSS ALL OF YOUR SCREENS

Always DOUBLE CHECK in which CONTEXT you're searching for AN INSTANCE.


Code example for specifically providing a bloc instance to the screens using Generated Routing:
```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: _appRouter.onGenerateRoute,
      ),
    );
  }

  @override
  void dispose() {
    _appRouter.dispose();
    super.dispose();
  }
}
```

Code example for Generated Routing function:
```dart
class AppRouter {
  final CounterCubit _counterCubit = CounterCubit();

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _counterCubit,
            child: HomeScreen(
              title: 'HomeScreen',
              color: Colors.blueAccent,
            ),
          ),
        );

      case '/second':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _counterCubit,
            child: SecondScreen(
              title: 'Second Screen',
              color: Colors.redAccent,
            ),
          ),
        );

      case '/third':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _counterCubit,
            child: ThirdScreen(
              title: 'Third Screen',
              color: Colors.greenAccent,
            ),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _counterCubit,
            child: HomeScreen(
              title: 'HomeScreen',
              color: Colors.blueAccent,
            ),
          ),
        );
    }
  }

  void dispose() {
    _counterCubit.close();
  }
}
```

## bloc-to-bloc communication

Cubits and blocs emit a stream of states. Other blocs can listen an receive those states and then act appropetly. 
There are two ways of achieving it:
### 1. Stream Subscription
- StreamSubscription is the foundation object from which you can listen to a stream.
- We initialize the StreamSubscription inside the bloc or cubit constructor.
- Since we create the StreamSubscription manually, we should also CLOSE it manually. Normally we can do it inside the close() bloc method, by calling streamSubscriptionObject.cancell().

Example of Stream Subscription implementation: inside the counterCubit we subscribe to the internetCubit and call increment or decrement.
```dart
class CounterCubit extends Cubit<CounterState> {
  final InternetCubit internetCubit;
  late StreamSubscription internetStreamSubscription;

  CounterCubit({required this.internetCubit})
      : super(CounterState(counterValue: 0, wasIncremented: true)) {
    monitorInternetCubit();
  }

  StreamSubscription<InternetState> monitorInternetCubit() {
    return internetCubit.listen((InternetState) {
      if (InternetState is InternetConnected &&
          InternetState.connectionType == ConnectionType.Wifi) {
        increment();
      } else if (InternetState is InternetConnected &&
          InternetState.connectionType == ConnectionType.Mobile) {
        decrement();
      }
    });
  }

  void increment() => emit(
      CounterState(counterValue: state.counterValue + 1, wasIncremented: true));

  void decrement() => emit(CounterState(
      counterValue: state.counterValue - 1, wasIncremented: false));

  @override
  Future<void> close() {
    internetStreamSubscription.cancel();
    return super.close();
  }
}
```
