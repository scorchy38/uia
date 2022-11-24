import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uia/gameover.dart';
import 'ghost.dart';
import 'player.dart';
import 'path.dart';
import 'squares.dart';
import 'eaten.dart';
class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
   static int nr=11;
  int ns =  nr * 17;
  List<int> barriers =[0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110,121,132,143,154,165,176,177,178,179,180,181,182,183,184,185,186,175,164,153,142,131,120,109,98,87,76,65,54,43,32,21,
  27,38,148,159,24,25,35,36,29,30,40,41,145,146,156,157,150,151,161,162,57,68,79,90,101,112,123,63,74,85,96,107,118,129,81,70,59,60,61,72,83,
  103,114,125,126,127,116,105];
  List<int> food=[];
  List<int> gpath=[20,19,18,17,16,15,14,13,12,23,34,45,56,67,78,89,100,111,122,133,144,155,166,167,168,169,170,171,172,173,174,163,152,141,140,139,138,137,136,135,124,113,102,91,80,69,58,47,48,49,50,51,52,53,
  64,75,86,97,108,119,130,141,152,163,174,163,152,141,130,119,108,97,86,75,64,53,42,31];

  int pl = nr*15+1;
  String dir = "right";
  int score =0;
  bool gover=false;
  void getFood(){
    for(int i=0;i<ns;i++){
      if(!barriers.contains(i)){
        food.add(i);
      }
    }
  }

    bool s=false;
    bool mc=false;
    bool nofood=false;
    int gh=20;
    //String ghdir="Left";
   int j=0;
 void moveghost(){
   Timer.periodic(Duration(milliseconds: 180), (timer) {
     if(j!=gpath.length-1){
       setState(() {
         gh=gpath[j];
       });
       j++;
     }
     else if(j==gpath.length-1) {
       j=0;
       setState(() {
         gh=gpath[j];
       });
       j++;
     }
     }
   );
 }
  void start(){
    s=true;

    moveghost();
    getFood();
    Timer.periodic(Duration(milliseconds: 120), (timer) {
      setState(() {
        mc=!mc;

      });
      if(food.contains(pl)){
        food.remove(pl);
        score+=2;
      }
      if(gh==pl){
        setState(() {
          gover=true;
        });
      }
      if(food.isEmpty){
        setState(() {
          nofood=true;
        });
      }
      switch(dir){
        case "left": moveleft();
          break;
        case "right": moveright();
          break;
        case "up": moveup();
          break;
        case "down": movedown();
          break;
      }

    });
  }
    void moveleft(){
      if(!barriers.contains(pl-1)){
        setState(() {
          pl--;
        });
      }
    }
    void moveright(){
      if(!barriers.contains(pl+1)){
        setState(() {
          pl++;
        });
      }
    }
    void moveup(){
      if(!barriers.contains(pl-nr)){
        setState(() {
          pl-=nr;
        });
      }
    }
    void movedown(){
      if(!barriers.contains(pl+nr)){
      setState(() {
      pl+=nr;
      });
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,


      body: (!gover && !nofood ) ?Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/garden.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: GestureDetector(
                onVerticalDragUpdate: (details){
                  if(details.delta.dy >0){
                    dir="down";
                  }
                  else if(details.delta.dy <0){
                    dir="up";
                  }
                  //print(dir);
                },
                onHorizontalDragUpdate:(details){
                  if(details.delta.dx >0){
                    dir="right";
                  }
                  else if(details.delta.dx <0){
                    dir="left";
                  }
                  //print(dir);
                } ,

                child: Container(
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: ns,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: nr,
                  ) , itemBuilder: (BuildContext context, int index){
                       if(mc && index==pl){
                         return Padding(padding: EdgeInsets.all(4),
                         child: Container(
                           decoration: BoxDecoration(
                             color: Colors.yellow,
                             shape: BoxShape.circle,
                           ),
                         ) ,
                         );
                       }
                      else if(pl == index){
                        switch(dir){
                          case "left": return Transform.rotate(angle: pi,child: MyPacman(),);
                            break;
                          case "right":
                            return MyPacman();
                            break;
                          case "up":
                            return Transform.rotate(angle: 3*pi/2,child: MyPacman(),);
                          break;
                          case "down":
                            return Transform.rotate(angle: pi/2,child: MyPacman(),);
                          break;
                          default:  return MyPacman();

                        }
                      }

                      else if((gh==index) && (s==true)){
                        return MyGhost();
                       }
                      else if(barriers.contains(index)){
                        return Mysquare(
                          //child: Text(index.toString()),
                          innercolor: Colors.blue[700],
                          outercolor: Colors.blue[900],
                        );
                       }
                       else if(food.contains(index) && s==true){

                         return Mypath(
                            // child: Text(index.toString()),
                             innercolor: Colors.yellow[300],
                             outercolor: Colors.white,
                    );
                       }
                       else if (!food.contains(index) && s==true){
                         return Myfood(
                           innercolor: Colors.transparent,
                           outercolor: Colors.transparent,
                         );
                      }
                       else{
                         return Mypath(
                           //child: Text(index.toString()),
                           innercolor: Colors.yellow[300],
                           outercolor: Colors.transparent,
                         );
                      }
                  }),

                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Score: "+ score.toString() ,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                      ),
                    ),
                    GestureDetector(
                      onTap: start,
                      child: Text("P L A Y",style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                      ),
                      ),
                    ),
                  ],
                ),

              ),
            ),
          ],
        ),
      ) : Gameover(t: score,)
    );
  }
}
