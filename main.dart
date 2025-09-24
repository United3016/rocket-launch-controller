import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rocket Launch Controller',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;
  bool _hasLaunched = false; // prevents repeated popups

  Color getCounterColor() {
    if (_counter == 0) return Colors.red;
    if (_counter > 50) return Colors.green;
    return Colors.orange; // 1..50
  }

  void _maybeShowLiftoffDialog() {
    if (_counter == 100 && !_hasLaunched) {
      _hasLaunched = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => AlertDialog(
            title: const Text('🎉 Launch Success!'),
            content: const Text('The rocket has successfully launched! 🚀'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  void _setCounter(int value) {
    setState(() {
      _counter = value.clamp(0, 100);
      if (_counter < 100) _hasLaunched = false; // reset flag if below 100
    });
  }

  @override
  Widget build(BuildContext context) {
    _maybeShowLiftoffDialog();

    return Scaffold(
      appBar: AppBar(title: const Text('Rocket Launch Controller')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text('Fuel', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    '$_counter',
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: getCounterColor(),
                    ),
                  ),
                  if (_counter == 100)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        '🚀 LIFTOFF!',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Slider(
              min: 0,
              max: 100,
              divisions: 100,
              value: _counter.toDouble(),
              onChanged: (double value) => _setCounter(value.toInt()),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _counter < 100 ? () => _setCounter(_counter + 1) : null,
              child: const Text('Ignite'),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _counter > 0 ? () => _setCounter(_counter - 1) : null,
                  child: const Text('Abort'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => _setCounter(0),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
