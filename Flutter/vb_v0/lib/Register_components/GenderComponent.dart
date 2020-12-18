// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vb_v0/ModelClass/UserProfile.dart'; 

class GenderComponent extends StatefulWidget{
  final UserProfile userProfile;
  final PageController controller;

  GenderComponent({ Key key, this.userProfile, this.controller}) : super(key: key);
  @override
  _GenderComponentState createState() => _GenderComponentState(userProfile: this.userProfile, controller: this.controller);
}

class _GenderComponentState extends State with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  final UserProfile userProfile;
  final PageController controller;
  _GenderComponentState({this.userProfile, this.controller});

  int selectedRadio = -1;

  final BoxDecoration floatingEffect =
       BoxDecoration(
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
      );
  
   Widget build(BuildContext context){
    
    return Container(
      child:Column(
        children: <Widget>[
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
                        Text("Biological Sex", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 35),)
                      ],
                    )
                      
                    
                  )
                    
                ), 
        Expanded(flex:3, 
          child:
            Row(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(2, (int index) {
                  return 
                  GestureDetector(
                    onTap: () {
                      setState(() => selectedRadio = index);
                    },
                    child:
                      new Container(
                          decoration: (index == selectedRadio?floatingEffect:null),
                          child: 
                          SizedBox(
                            width: 150.0,
                            height: 150.0,
                            child: Card(
                              elevation: 6,
                              shape: CircleBorder(),
                              child: Center(
                                child:Text(index==0?"F":"M", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 30),)
                              ),
                            
                            )
                          )
                      )
                      
                  );
                  
                  
                  // Radio<int>(
                  //   value: index,
                  //   groupValue: selectedRadio,
                  //   onChanged: (int value) {
                  //     setState(() => {selectedRadio = value});
                  //     print(selectedRadio);
                  //   },
                  // );
                }),
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
                      print("Selected Radio: " + selectedRadio.toString());
                      if(selectedRadio != -1){
                        userProfile.sex = selectedRadio;
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
} 


// class CustomElevation extends StatelessWidget {
//   final Widget child;
//   final bool effectOn;
  

//   CustomElevation({@required this.child,this.effectOn}) : assert(child != null);

//   @override
//   Widget build(BuildContext context) {
//     print(this.effectOn);
//     return Container(
//       decoration: (this.effectOn?this.floatingEffect:null),
//       child: this.child,
//     );
//   }
// }