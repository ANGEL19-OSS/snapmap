import 'package:map_app/model/places.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as latlng;

class Mapsscreen  extends StatefulWidget{
  const Mapsscreen({super.key, this.location = const PlaceLocation(longitude: 37.422, latitude: -122.084, address: '')});
final PlaceLocation location;
final bool isselecting = true;

State<Mapsscreen> createState(){
  return _MapscreenState();
}
}

class _MapscreenState extends State<Mapsscreen>{
  LatLng ? _pickedlocation;

  void _selectLocation(LatLng position){
    setState(() {
      _pickedlocation = position;
    });
  }
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isselecting ? "Pick your location" : "Your Location"),
        actions: [
          if(widget.isselecting)
            IconButton(
              onPressed: (){
                Navigator.of(context).pop(_pickedlocation);             //taking the _pickedlocation from this screen
              }, icon: Icon(Icons.save)),
        ],
      ),
      body:  GoogleMap(
        initialCameraPosition: 
        CameraPosition(
          target: LatLng(
            widget.location.latitude,
            widget.location.longitude),
            zoom: 16
            ),
            onTap: widget.isselecting ? _selectLocation : null,
            markers: {
              Marker(
                markerId: const MarkerId('m1'),
                position: LatLng(
                  widget.location.latitude,
                  widget.location.longitude,
                ) ,
              )
            },
            )

    );

  }
}