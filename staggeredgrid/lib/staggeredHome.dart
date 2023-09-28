import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<List<Album>> fetchAlbums() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<Album> albums =
        data.map((albumJson) => Album.fromJson(albumJson)).toList();
    return albums;
  } else {
    throw Exception('Failed to load albums');
  }
}

class Album {

  final int userId;
  final int id;
  final String title;

  const Album({
   
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
   
      
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class ApiHome extends StatefulWidget {
  const ApiHome({Key? key});

  @override
  State<ApiHome> createState() => _ApiHomeState();
}

class _ApiHomeState extends State<ApiHome> {
  late Future<List<Album>> futureAlbums;

  @override
  void initState() {
    super.initState();
    futureAlbums = fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Data Example'),
        backgroundColor: Color.fromARGB(255, 10, 132, 208),
      ),
      backgroundColor: Color.fromARGB(233, 0, 4, 9),
      body: Center(
        
      
        child: FutureBuilder<List<Album>>(
          
          future: futureAlbums,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Album> albums = snapshot.data!;

              return StaggeredGridView.countBuilder(
                
                crossAxisCount: 3,
                itemCount: albums.length,
                itemBuilder: ( context,  index) {
                  Album album = albums[index];
                  return Card(
                    color: Color.fromARGB(255, 59, 255, 183),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Image.network(
                          "https://tse3.mm.bing.net/th?id=OIP.FNXliSRGYF3D2gA2HN2wZgHaEK&pid=Api&P=0&h=180" ,// Use the imageUrl field from Album
                          fit: BoxFit.cover, // You can adjust the image fit as needed
                          height: 150, // Set the desired height for the image
                        ),
                          Text("Title: ${album.title}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 11, 7, 255)),
                          ),
                          Text("User ID: ${album.userId}"),
                          Text("Album ID: ${album.id}"),
                        ],
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
