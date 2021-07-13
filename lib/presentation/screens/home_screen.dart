import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_concepts/constants/enums.dart';
import 'package:flutter_bloc_concepts/logic/cubit/internet_cubit.dart';
import '../../logic/cubit/counter_cubit.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.title, required this.color})
      : super(key: key);

  final String title;
  final Color color;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<InternetCubit, InternetState>(
              builder: (context, state) {
                if (state is InternetConnected &&
                    state.connectionType == ConnectionType.Wifi) {
                  return Text('Wifi');
                } else if (state is InternetConnected &&
                    state.connectionType == ConnectionType.Mobile) {
                  return Text('Mobile');
                } else if (state is InternetDisconnected) {
                  return Text('Disconnected');
                }

                return CircularProgressIndicator();
              },
            ),
            BlocConsumer<CounterCubit, CounterState>(
              listener: (context, state) {
                if (state.wasIncremented) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Incremented'),
                    duration: Duration(milliseconds: 100),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Decremented'),
                    duration: Duration(milliseconds: 100),
                  ));
                }
              },
              builder: (context, state) {
                if (state.counterValue < 0) {
                  print('+');
                  return Text(
                    'NEGATIVE  ' + state.counterValue.toString(),
                    style: Theme.of(context).textTheme.headline4,
                  );
                } else {
                  print('-');
                  return Text(
                    'POSITIVE  ' + state.counterValue.toString(),
                    style: Theme.of(context).textTheme.headline4,
                  );
                }
              },
            ),
            /* Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: '1',
                  onPressed: () {
                    BlocProvider.of<CounterCubit>(context).decrement();
                    //context.bloc<CounterCubit>().decrement();
                  },
                  tooltip: 'Decrement',
                  child: Icon(Icons.remove),
                ),
                FloatingActionButton(
                  heroTag: '2',
                  onPressed: () {
                    BlocProvider.of<CounterCubit>(context).increment();
                  },
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                ),
              ],
            ), */
            SizedBox(
              height: 24,
            ),
            MaterialButton(
              color: Colors.redAccent,
              onPressed: () {
                Navigator.of(context).pushNamed('/second');
              },
              child: Text('Go to Second Screen'),
            ),
            MaterialButton(
              color: Colors.greenAccent,
              onPressed: () {
                Navigator.of(context).pushNamed('/third');
              },
              child: Text('Go to Third Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
