import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:catsnap/full_image_screen.dart';
import 'package:shimmer/shimmer.dart';


class Wallpapers extends StatefulWidget {
  const Wallpapers({super.key});

  @override
  State<Wallpapers> createState() => _WallpapersState();
}

class _WallpapersState extends State<Wallpapers> {

  // following are different variables being used in the whole project for different functionalities

   List<dynamic>pre_defined_options = ['Nature', 'Cats', 'Space', 'Computers', 'City'];
   List<dynamic> image = [];
   int page_no  = 1;
   final String api_Key = 'KxhCp0iVqaWOYPRux5rQ0jNZpXGi8DShHRTpZpSOpGJTzA0eI0sy7rhi';
   late String searchQuery;
   int selectedIndex = -1;

   @override
  void initState() { // We used this so that the first thing that happens when widget tree is build is to call the fetch-api function
     super.initState();
     fetchapi();
   }



   // fetchapi function makes the api call based on the Search query or the default.
   Future<void> fetchapi({String query = ''}) async {
     // Optional query parameter
     String url = 'https://api.pexels.com/v1/curated?per_page=80&page=$page_no';
     if (query.isNotEmpty) { // If there is query in the search box then make a api call with query parameter entered by the user
       url = 'https://api.pexels.com/v1/search?query=$query&per_page=80&page=$page_no';
     }
     await http.get( // here the http.get request is sent to the pexels servers
       Uri.parse(url),
       headers: {
         'Authorization': api_Key, // our api_key as the authorization header
       },
     ).then((value) {
       if (value.statusCode == 200) {
         Map result = jsonDecode(value.body); // added the response to a hash map ( Key: value pair)
         print(result);
         setState(() {
           if (page_no == 1) {
             image = result['photos']; // Clear image list for initial search
           } else {
             image.addAll(result['photos']); // Add fetched images on load more
           }
         });
       } else {
         print("Error fetching data");
       }
     });
   }

   Future<dynamic> loadMoreImage() async {
     setState(() {
       page_no = page_no + 1;
     });
     await fetchapi(query: searchQuery); // Call fetchapi with updated page number and search query
   }

   // Triggers the search when the user clicks the search icon
   void searchImages() {
     setState(() {
       image = []; // Clear image list for new search
       page_no = 1; // Reset page number for new search
     });
     fetchapi(query: searchQuery); // Call fetchapi with the search query
   }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:  Center(child: Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 141, 202, 251),
          highlightColor: const Color.fromARGB(255, 239, 127, 164),
          child:  const Text("CatSnap", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        ),
        automaticallyImplyLeading: false, // This line removes the back arrow which was coming bacause of Navigation from the SplashScreen
      ),
      body:
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0))
              ),
              // This is used to take the seach query from the user
              child: Row(children: [
                SizedBox(
                  width: 320,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search wallpapers',
                      hintStyle: TextStyle(fontFamily: 'sans',color: Colors.grey),
                      focusColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value; // Update search query on input change
                      });
                    },
                  ),
                ),IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: searchImages, // Call searchImages on icon tap
                ),
              ],
              ),
            ),
          ),
          Container(
            height: 50,
            color: Colors.black,
            child:
            ListView.builder(
                scrollDirection: Axis.horizontal,  //If you have defined something like coloumn you will get the renderflex error because the coloumn is not flixbble as listview
                itemCount: pre_defined_options.length,
                itemBuilder: (context,index)
                {
                  final isSelected = selectedIndex == index; //  it checks if the current item's index (index) matches the selectedIndex.
                  return InkWell(
                    onTap: (){
                      setState(() {
                        selectedIndex = index; // when you select any item in the list its index is assgined to selectedIndex variable
                        searchQuery = pre_defined_options[index];
                        searchImages(); // when you tap on any list item new wallpapers get loaded in the gridview.
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      height: 70,
                      width: 150,
                      decoration:  BoxDecoration(
                          color: isSelected ? Colors.grey : Colors.white,   //condition for giving color to list items. The item whose index matches the selectedIndex condition will be greyish and other items will be white
                          shape:BoxShape.rectangle,
                          borderRadius: const BorderRadius.all(Radius.circular(10.0))
                      ),
                      child: Center(child:Text(pre_defined_options[index],style: const TextStyle(fontWeight: FontWeight.w500),)),
                    ),
                  );
                }
            ),
          ),
          Expanded(
              child: GridView.builder( // grid view to show the images from api response
                itemCount: image.length, // this means jitne photos api response mai ayege utni he grid items create hojayegei
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                       crossAxisSpacing: 5,
                        childAspectRatio: 2/2,
                         mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index)
                  {
                  if(image[index] != null){
                    return GestureDetector( // GestureDetector function takes the touch as input and immediately transfers the Image url of the image to the FullImage screen
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FullImage(imageUrl: image[index]['src']['portrait'], photoGrapher_name: image[index]['photographer'],),)); // this is the path for pushing the url of the image on which the touch was detected
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(0)),
                        child: Container(
                          margin: const EdgeInsets.only(left: 5.0, right: 5.0,top: 5.0),
                          child: Image(image: NetworkImage(image[index]['src']['tiny']),fit: BoxFit.cover),
                        ),
                      ),
                    );
                  }
                  else{
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!, // Adjust base color for desired shimmer effect
                        highlightColor: Colors.grey[100]!, // Adjust highlight color for desired shimmer effect
                        child: Container(
                          color: const Color.fromARGB(255, 108, 182, 243),
                          child: const  Text('Loading content'),
                        ),
                      );
                  }
                  }
              ),
          ),
         const  SizedBox(height: 5),
          // InkWell( // this function takes the touch as input and output response is set by the user using the OnTap
          //   onTap: (){
          //     loadMoreImage(); // In our case we are calling the Loadmore function to load more images in the gridview
          //   },
          //   child: Container(
          //     height: 50,
          //     width: 200,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(20.0), // Set the desired radius
          //       color: Colors.white, // Set the container color
          //     ),
          //     child:  const Center(child: Text("Load more", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),)),
          //   ),
          // )
        ],
      ),

    );
  }
}
