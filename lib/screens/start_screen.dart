import 'package:map_app/screens/Add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:map_app/widgets/placeslist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:map_app/provider/places.dart';

class Startscreen extends ConsumerStatefulWidget{
  const Startscreen({super.key});

  ConsumerState<Startscreen> createState(){
    return _StartscreenState();
  }
}
  class _StartscreenState extends ConsumerState<Startscreen>{
    late Future<void> placesfuture;
   @override 
   void initState(){
    super.initState();
    placesfuture = ref.watch(usersPlaceProvider.notifier).loadPlaces();
   }
   
   Widget build(BuildContext context){
    final userplaces = ref.watch(usersPlaceProvider);  //userplaces to know what is passed tell the notifier what type 
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places',
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Addscreen()));
            }, 
            child: Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:FutureBuilder(future: placesfuture,
         builder: (context , snapshot) => 
        snapshot.connectionState == ConnectionState.waiting ?  Center(child: CircularProgressIndicator()) : 
         places(placess: userplaces),
      )
      )
    );
   }
  }
