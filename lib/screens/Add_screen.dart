import 'package:map_app/model/places.dart';
import 'package:map_app/provider/places.dart';
import 'package:map_app/widgets/inputimage.dart';
import 'package:map_app/widgets/locationinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class Addscreen extends ConsumerStatefulWidget{ 
  const Addscreen({super.key});

  ConsumerState<Addscreen> createState(){
    return _AddscreenState();
  }
}
class _AddscreenState extends ConsumerState<Addscreen>{
   File? selectedImage;
   PlaceLocation? pickedlocation;
   @override
   final titlecontroller = TextEditingController();
   void dispose(){
   titlecontroller.dispose();
   super.dispose();
   }
   
   final formkey = GlobalKey<FormState>();
   
   void saveitem(){
    final enteredtext = titlecontroller.text;

    if(enteredtext == null || enteredtext.isEmpty ||  selectedImage == null){
    formkey.currentState!.validate();
    }else
     ref.read(usersPlaceProvider.notifier).addPlace(enteredtext , selectedImage!,pickedlocation!);
    
   }
   Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Add places'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
       body: SingleChildScrollView(        //the addscreen adds more data use singelscrollview to make everything viisibel
         child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: titlecontroller,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Name'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 1 and 50 characters.';
                    }
                    return null;
                  },
         
                ),
                SizedBox(height:10),
                inputimage(
                  onpickimage: (image) {
                    selectedImage = image;
                  }
                  
                ,),
         
                SizedBox(height: 10),
         
                Locationinput(
                    onpicklocation: (location) {
                      pickedlocation = location;
                    },  
                ),
         
                SizedBox(height: 16,),
                ElevatedButton(
                onPressed: () {
                     saveitem();
                   },
              style: ElevatedButton.styleFrom(
             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
               ),
             child: const Row(
             mainAxisSize: MainAxisSize.min, // Makes the button wrap content
            children: [
            Icon(Icons.add),
            SizedBox(width: 5),
            Text('Add'),
           ],
           ),
         )
         
                  
              ],
            ),
          ),
         ),
       )

    );
   }
}