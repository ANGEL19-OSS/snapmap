import 'dart:convert';

import 'package:map_app/model/places.dart';
import 'package:map_app/screens/MapsScreen.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class Locationinput extends StatefulWidget{ 
  const Locationinput({ super.key ,required this.onpicklocation});

  final void Function(PlaceLocation location) onpicklocation;

    State<Locationinput> createState()
    {
    return _LocationinputState();
   }
}

class _LocationinputState extends State<Locationinput>{
  PlaceLocation? locationpicked;
  var isgettinglocation = false;

   String get locationImage {
  if (locationpicked == null) {
    return ''; // Empty string if no location picked
  }

  final lat = locationpicked!.latitude;
  final lng = locationpicked!.longitude;
  return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=13&size=600x300&markers=color:red%7C$lat,$lng&key=AIzaSyBkLS7PcafgeVDZVTFGexXDl5LlNkCP9tc';

   }

Future<void> savePlace (double latitude, double longitude) async{
      final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyBkLS7PcafgeVDZVTFGexXDl5LlNkCP9tc');
     final response = await http.get(url);     //result in json 
     final resdata = json.decode(response.body);

     if (resdata['results'] == null) {
     print('No address found for the given location.');
     setState(() {
      isgettinglocation = false;
       });
      return;
     }

     final address = resdata['results'][0]['formatted_address'];
       setState(() {
        locationpicked = PlaceLocation(longitude: longitude, latitude: latitude, address: address);
        isgettinglocation = false;   
      });
     widget.onpicklocation(locationpicked!);  //can be potentially null so !
}

  void _getlocation()async{ 
  Location location = Location();            //picked from the flutterpackage

bool serviceEnabled;
PermissionStatus permissionGranted;
LocationData locationData;

serviceEnabled = await location.serviceEnabled();
if (!serviceEnabled) {
  serviceEnabled = await location.requestService();
  if (!serviceEnabled) {
    return;
  }
}

permissionGranted = await location.hasPermission();
if (permissionGranted == PermissionStatus.denied) {
  permissionGranted = await location.requestPermission();
  if (permissionGranted != PermissionStatus.granted) {
    return;
  }
   }
     setState(() {
        isgettinglocation = true;          //until the location is got it rotates
      });

    locationData = await location.getLocation();   //awaiting for the location
    var lat = locationData.latitude;
    var lng = locationData.longitude;

     if(lat == null || lng == null){
      return ;                                 //a null check for  lat and lng 
     }
    savePlace(lat, lng);
  }

    void saveMap() async{
       final pickedlocation = await
        Navigator.of(context).push<LatLng>
       (MaterialPageRoute
       (builder: (ctx) => Mapsscreen()));

       if(pickedlocation == null){
        return;
       }
       savePlace(pickedlocation.latitude, pickedlocation.longitude);
    }

    Widget build(BuildContext context){

      Widget preview =  Text('No place choosen', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge!.copyWith(
      color: Theme.of(context).colorScheme.onBackground,
      ));   

      if(locationpicked != null){
        preview = Image.network(locationImage , 
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        );
      }

      if(isgettinglocation){
        preview = CircularProgressIndicator();
      }

      return Column(
        children: [
          Container(
            height: 170,
            width: double.infinity,
          decoration: BoxDecoration(
           border: Border.all(width :1 ,
           color: Theme.of(context).colorScheme.primary.withOpacity(0.2)
        )
       ),
      child:  Center(child: preview)
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.location_on),
                 label: Text('Get your current location'),
                onPressed: (){
                  _getlocation();
                }, 
                ),
                SizedBox(width: 9,),
                TextButton.icon(
                icon: const Icon(Icons.map),
                 label: Text('Select on Map'),
                onPressed: (){
                  saveMap();
                }, 
                )
            ],
          )
        ],
      );
    }
}