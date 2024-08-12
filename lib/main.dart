import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Noticias(),
    );
  }
}

class Noticias extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {
  List<dynamic> noticias = [];

  @override
  void initState() {
    super.initState();
    fetchNoticias();
  }

  Future<void> fetchNoticias() async {
    final response = await http.get(
      Uri.parse(
          'https://newsapi.org/v2/everything?q=tesla&from=2024-04-19&sortBy=publishedAt&apiKey=4f8552913cdf433981c4c77ab136e558'),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> fetchedNoticias = json['articles'];
      fetchedNoticias.sort((a, b) => a['title'].compareTo(b['title']));

      setState(() {
        noticias = fetchedNoticias;
      });
    } else {
      print('No se pudo cargar los datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: noticias.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: noticias.map((noticia) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(noticia['title'] ?? 'Inexistente'),
                      subtitle: Text(
                        'Descripción: ${noticia['description'] ?? 'No disponible'}\nFuente: ${noticia['source']['name'] ?? 'Desconocida'}',
                      ),
                      leading: noticia['urlToImage'] != null
                          ? Image.network(
                              noticia['urlToImage'],
                              width: 50,
                              height: 50,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }
}