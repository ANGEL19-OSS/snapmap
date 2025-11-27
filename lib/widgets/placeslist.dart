import 'package:map_app/screens/placeDetails_screen.dart';
import 'package:flutter/material.dart';

import 'package:map_app/model/places.dart';

class places extends StatelessWidget{
  const places({super.key, required this.placess});

  final List<Places> placess;
  @override 
  Widget build(BuildContext context){
    if(placess.isEmpty){
      return  Center(
        child: Text('No places added yet',style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.onBackground
        ),
        ),
      );
    }

    return ListView.builder(
      itemCount: placess.length,
      itemBuilder: (ctx,index) =>
       ListTile(
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: FileImage(placess[index].image),
        ),
        title: Text(placess[index].title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.onBackground
        ),
       ),
       subtitle: Text(placess[index].location.address,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.onBackground),
       ),
       onTap : ()
       {
         Navigator.push(context, MaterialPageRoute(builder: (context) => placeDetails_screen(place: placess[index])));
       },
       )
       );
  }
}