// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 

class AgeComponent extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      child:Column(
        children: <Widget>[
        Expanded(
                flex:1, 
                
                child:
                  Container(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("What's your age?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 35),)
                      ],
                    )
                      
                    
                  )
                    
                ), 
        Expanded(flex:3, child: AgeScrollable(),)
      ],)
    );
  }
}


class CustomElevation extends StatelessWidget {
  final Widget child;

  CustomElevation({@required this.child}) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color.fromARGB(125, 102, 104, 50),
            blurRadius: 12.5,
            offset: Offset(0, 0),
          ),
          BoxShadow(
            color: Color.fromARGB(125, 255, 255, 255),
            blurRadius: 8,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: this.child,
    );
  }
}

class AgeScrollable extends StatefulWidget{
  @override
  _AgeScrollableState createState() => _AgeScrollableState();
} 

class _AgeScrollableState extends State<AgeScrollable>{
  int _index = 30;

  @override
  Widget build(BuildContext context){
        return Container(
                    // constraints: BoxConstraints.expand(),
                    height:MediaQuery.of(context).size.height * 0.6,
                    child:Center(
                      child:
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width * 0.75,
                          child:PageView.builder(
                            pageSnapping: false,
                            itemCount: 80,
                            controller: PageController(initialPage: 30,viewportFraction: 0.4),
                            onPageChanged: (int index) => setState(() => _index = index),
                            itemBuilder: (_, i) {
                              if(i == _index)
                                return  
                                CustomElevation(
                                  child: 
                                  SizedBox(
                                    width: 200.0,
                                    height: 300.0,
                                    child: Card(
                                    // decoration: BoxDecoration(
                                    //   color: Colors.white,
                                    //   shape: BoxShape.circle,
                                    // ),
                                    // width: 10,
                                    elevation: 6,
                                    shape: CircleBorder(),
                                    // color: Color.fromARGB((255/5*(i+1)).toInt(), 255, 255, 255),
                                    child: Center(
                                      child:Text(i.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 35),)
                                    ),
                                    
                                    )
                                  )
                                
                                );
                              else
                                return 
                                Transform.scale(
                                  scale: 1,
                                  // child: Card(
                                  //   // decoration: BoxDecoration(
                                  //   //   color: Colors.white,
                                  //   //   shape: BoxShape.circle,
                                  //   // ),
                                  //   // width: 10,
                                  //   elevation: 6,
                                  //   shape: CircleBorder(),
                                  //   // color: Color.fromARGB((255/5*(i+1)).toInt(), 255, 255, 255),
                                    child: Center(
                                      child:Text(i.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 35),)
                                    ),
                                    
                                  // )
                                );
                            },
                        ),
                          
                          
                        //   ListView(
                        //   scrollDirection: Axis.horizontal,
                        //   children: getAgeArray(context)
                        // )
                          
                        )
                        // Text("PlaceHolder", style: TextStyle(color: Color.fromRGBO(217,215,157,1), fontWeight: FontWeight.w700, fontSize: 25),)
                        
                      )
                
          );

  }


}



// class AgeScrollable extends StatefulWidget{
//   @override
//   _AgeScrollableState createState() =>_AgeScrollableState();
  
// }


// class _AgeScrollableState extends State<AgeScrollable>{

//     List<Widget> getAgeArray(BuildContext _context){
//       List <Widget> ageCells = List<Widget>();
//       for(int i=15;i<75;i++)
//       {
//           ageCells.add(
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(_context).size.width * 0.01),
//               child:Container(
//                 decoration: BoxDecoration(
//                   // color: Colors.white,
//                   shape: BoxShape.circle,
//                 ),
//                 width: MediaQuery.of(_context).size.width * 0.33,
//                   // color: Color.fromARGB((255/5*(i+1)).toInt(), 255, 255, 255),
//                 child: Center(
//                   child:Text(i.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 35),)
//                 )
//               ),
//             )
//           );
//       }
//       return ageCells;
//   }

//   final controller = PageController(
//     initialPage: 0,
//     viewportFraction: 0.2
//   );

//   @override
//   Widget build(BuildContext context) {
//     return PageView(
//             controller: controller,
//             onPageChanged: (page)=>{ print(page.toString()) },
//             pageSnapping: true,
//             scrollDirection: Axis.horizontal,
//             children: getAgeArray(context)
//     );
//   }
// }