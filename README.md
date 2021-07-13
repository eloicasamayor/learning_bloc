# flutter_bloc_concepts

This is a project developed following the course ["The Best Flutter Bloc Complete Course - Visualise, Understand, Learn & Practice Bloc Concepts."](https://www.youtube.com/watch?v=THCkkQ-V1-8&t=6089s), by Flutterly.

## Core concepts resume

You can NAVIGATE inside Flutter by using
- Anonymous Routing (recommended for SMALL projects)
- Named Routing (recommended for MEDIUM projects)
- Generated Routing (recommended for LARGE projects)

The key is to PROVIDE a UNIQUE INSTANCE of a bloc/cubit.
You SHOULDN'T create MULTIPLE INSTANCES of the same bloc/cubit.
- BlocProvider() CREATES & PROVIDES a NEW INSTANCE of a bloc/cubit.
- BlocProvider.value() takes an ALREADY CREATED INSTANCE and PROVIDES it further.

You can PROVIDE your cubit/bloc INSTANCES
- LOCALLY - when you want to provide the instance to A SINGLE SCREEN
- SPECIFICALLY - when you want to SPECIFICALLY PROVIDE it across 1 or more SCREENS
- GLOBALLY - when you want to provide it ACROSS ALL OF YOUR SCREENS

Always DOUBLE CHECK in which CONTEXT you're searching for AN INSTANCE.


Code example for specifically providing a bloc instance to the screens:
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
}```