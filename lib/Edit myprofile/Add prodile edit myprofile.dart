import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../activity/Home Screens/myprofile.dart';

class PickImage extends StatefulWidget {
  final String memberId;
  final String id;

  const PickImage({super.key, required this.memberId, required this.id});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Profile"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100,),
            Stack(
              children: [
                const CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                ),
                Positioned(
                    bottom: -0,
                    left: 140,
                    child: IconButton(
                        onPressed: () {
                          selectImages();
                        },
                        icon: const Icon(Icons.add_a_photo))),

              ],
            ),
            SizedBox(
              height: imageFileList!.isNotEmpty?80:0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageFileList!.length,
                itemBuilder: (context, index) {
                  final employee = imageFileList![index];
                  return Column(
                    children: [
                      GestureDetector(
                          onTap:(){

                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16,top: 10),
                            child: Image.file(File(imageFileList![index].path), fit: BoxFit.cover,width: 70,height: 70,),
                          )
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectImages() async {
    imageFileList!.clear();
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      if(selectedImages.length>2)
      {
        showCustomBar("You can select only 2 images", Colors.red);
      }
      else
      {
        imageFileList!.addAll(selectedImages);
        savechangeprofile();
      }
    }
    print("Image List Length:${imageFileList!.length}");
    setState((){});
  }


  Future<void> savechangeprofile() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString("id")!;

    var request = http.MultipartRequest('POST', Uri.parse('http://kaverykannadadevangakulamatrimony.com/appadmin/api/profile_image_update'));
    request.fields.addAll({
      'id': memberId
    });

 //   print(selectedIMage!.path.toString());
  //  request.files.add(await http.MultipartFile.fromPath('profile_image',selectedIMage!.path.toString()));

    if(imageFileList!.isNotEmpty)
    {
      if(imageFileList!.length==1)
      {
        request.files.add(await http.MultipartFile.fromPath('profile_image[]',imageFileList![0].path.toString()));
      }
      if(imageFileList!.length==2)
      {
        request.files.add(await http.MultipartFile.fromPath('profile_image[]',imageFileList![0].path.toString()));
        request.files.add(await http.MultipartFile.fromPath('profile_image[]',imageFileList![1].path.toString()));
      }
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      showCustomBar("Profile Image Changes Successfully",Colors.green);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MyProfile(
                memberId: "1",
                id: "1",
              )));
    }
    else {
      print(response.reasonPhrase);
    }
  }


  void showCustomBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
