import 'package:map_app/screens/MapsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:map_app/model/places.dart';

class placeDetails_screen extends StatelessWidget{
  const placeDetails_screen({required this.place});
   @override 

   final Places place;
    String get locationImage {
   if (place.location == null) {
    return ''; // Empty string if no location picked
  }

  final lat = place.location.latitude;
  final lng = place.location.longitude;
  return 'https://maps.googleapis.com/maps/api/staticmap'
      '?center=$lat,$lng'
      '&zoom=16'
      '&size=600x300'
      '&markers=color:red%7C$lat,$lng'
      '&key=AIzaSyBkLS7PcafgeVDZVTFGexXDl5LlNkCP9tc';
}

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body:Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
         Positioned(
             left: 0,
             right: 0,
             bottom: 0,
            child:Column(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => Mapsscreen(location: place.location)));
                  },
                    child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(locationImage),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.transparent,
                      Colors.black54,
                    ],
                    begin: Alignment.topCenter,
                    end : Alignment.bottomCenter
                    ),
                  ),
                  child: Text(place.location.address,style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground
              ), 
              textAlign: TextAlign.center,
              ),
                )
              ],
            )
          )
        ],
      )
    );
  }

}