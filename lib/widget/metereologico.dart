import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _cityController = TextEditingController();
  String _temperature = '';
  String _description = '';
  String _iconUrl = '';
  String _windSpeed = '';

  final String _apiKey = '38d36a5609d8363d8634d9f7b78ac59f';

  Future<void> _fetchWeather() async {
    final city = _cityController.text;
    final url =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _temperature = '${data['main']['temp']} °C';
        _description = data['weather'][0]['description'];
        _iconUrl =
            'http://openweathermap.org/img/wn/${data['weather'][0]['icon']}.png';
        _windSpeed = '${data['wind']['speed']} m/s';
      });
    } else {
      setState(() {
        _temperature = 'Error';
        _description = '';
        _iconUrl = '';
        _windSpeed = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos Meteorológicos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ciudad:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingresa la ciudad',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _fetchWeather,
              child: const Text('Actualizar'),
            ),
            const SizedBox(height: 16.0),
            if (_iconUrl.isNotEmpty)
              Row(
                children: [
                  Image.network(_iconUrl, width: 50, height: 50),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Temperatura actual: $_temperature',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'condiciones climáticas: $_description',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Velocidad del viento: $_windSpeed',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
