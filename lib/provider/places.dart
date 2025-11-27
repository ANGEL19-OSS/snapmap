import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:map_app/model/places.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'dart:io';

Future<Database>  _getDatabase() async{
  final dbPath = await sql.getDatabasesPath();
   final db = await sql.openDatabase(              //opens a database or if not creates a database 
      path.join(
        dbPath , 'places.db',
      ),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
      },
      version: 1,
    );
    return db;
  
}

class UsersPlaceNotifier extends StateNotifier<List<Places>> {
  UsersPlaceNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
   final places =  data.map(
      (item) => Places(title: item['title'] as String,
       image: File(item['image'] as String),
        location: PlaceLocation(
        longitude:  item['lat'] as double, 
        latitude: item['lng'] as double, 
        address: item['address'] as String )
        )

    ).toList();
    state = places;            //the state notifier 
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();           //to get the directory of the app
    final fileName = path.basename(image.path);         //to get the name of the image file
   final copiedimage = await  image.copy ('${appDir.path}/$fileName');      //copying the image to the app directory
    final newPlace = Places(title: title, image: copiedimage, location: location);

    final db = await _getDatabase();
    db.insert('user_places', {
      'id' : newPlace.id,
      'title' : newPlace.title,
      'image' : newPlace.image.path,
      'lat' :newPlace.location.latitude,
      'lng' : newPlace.location.longitude,
      'address' : newPlace.location.address,
    });
    state = [newPlace, ...state];
  }
}

final usersPlaceProvider = StateNotifierProvider<UsersPlaceNotifier, List<Places>>(
  (ref) => UsersPlaceNotifier(),
);
