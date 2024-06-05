import 'package:flutter/material.dart';


class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<String> Ideas_list = ['Goku','One piece manga','Army','Weapons'];
  List<String> popular_ideas = ['Cute pfp','Jujutsu kaisen','Cute Couple','Cute girl','Sports Cars','Luxurious houses'];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 1, // This makes the width of sized box adjust automattically with the screen on different mobile phones
            height: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              color: Colors.yellow,
              child: const Center(child: Text("Space for creative or AI touch",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 1, // This makes the width of sized box adjust automattically with the screen on different mobile phones
            height: MediaQuery.of(context).size.height * 0.05,
            child: const Center(child: Text('Ideas for you',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,),),
          ),
          ),
          Container(
            height: 100,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                itemCount: Ideas_list.length,

                itemBuilder: (context,index){
                return Container(
                  margin: const EdgeInsets.all(5),
                  height: 100,
                  width: 150,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.rectangle,
                    borderRadius:  BorderRadius.all(Radius.circular(20.0),),
                  ),
                  child: const Center(child: Text('Place image here'),),
                );
           }
          ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 1, // This makes the width of sized box adjust automattically with the screen on different mobile phones
            height: MediaQuery.of(context).size.height * 0.05,
            child: const Center(child: Text('Popular on catsnap',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,),),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.299,
            color: Colors.white,
            child: GridView.builder(
              itemCount: popular_ideas.length,
                gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2,
                    mainAxisSpacing: 10,
                ),
                itemBuilder: (context,index){
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.rectangle,
                    borderRadius:  BorderRadius.all(Radius.circular(20.0),),
                  ),
                  child: const Center(child: Text('Place image here'),),
                );
                }
            ),
          ),
        ],
      ),
    );
  }
}
