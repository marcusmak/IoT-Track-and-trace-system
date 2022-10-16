// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vb_v0/ModelClass/UserProfile.dart'; 

class AgeComponent extends StatefulWidget{
  final UserProfile userProfile;
  final PageController controller;
  
  AgeComponent({ Key key, this.userProfile, this.controller}) : super(key: key);
  @override
  _AgeComponentState createState() => _AgeComponentState(userProfile: this.userProfile, controller: this.controller);
} 

// class  extends StatelessWidget{
  
// }


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

class _AgeComponentState extends State<AgeComponent> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  
  int _index = 0;
  PageController _controller = PageController(initialPage: 0,viewportFraction: 0.4);
  final UserProfile userProfile;
  final PageController controller;
  
  _AgeComponentState({this.userProfile, this.controller});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initialize age scollable state");
    WidgetsBinding.instance.addPostFrameCallback((_)=>_controller.animateToPage(30, duration: Duration(seconds: 1), curve: Curves.bounceOut));
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child:Column(
        children: <Widget>[
          Expanded(child: 
            Column(
              children:[
                Expanded(
                  flex:1, 
                  
                  child:
                    Container(
                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.025),
                      child:Column(
                        
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("Age", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 35),)
                        ],
                      )
                        
                      
                    )
                      
                  ), 
                Expanded(flex:3, child: AgeScrollable(context),),
              ]
            )
          ),
          Container(child: 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width * 0.1),
                child: GestureDetector(
                    onTap: () {
                      controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                    },                
                    child: Text("Prev",style: TextStyle(color: Colors.white),),
                  )
                    
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width * 0.1),
                  child: GestureDetector(
                    onTap: () {
                      if(_index != 0){
                        // print("Age: " + _index.toString());
                        userProfile.age = _index;
                        controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                      }
                    },                
                    child: Text("Next",style: TextStyle(color: Colors.white),),
                  )
                    
                ),
              ],
            )
          ,)
      ],)
    );
  }

  Widget AgeScrollable(BuildContext context){
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
                            controller:_controller,
                            
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
                                    color: Colors.grey,
                                    // width: 10,
                                    elevation: 6,
                                    shape: CircleBorder(),
                                    // color: Color.fromARGB((255/5*(i+1)).toInt(), 255, 255, 255),
                                    child: Center(
                                      child:Text(i.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 35),)
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