// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 

class GenderComponent extends StatefulWidget{
  @override
  _GenderComponentState createState() => _GenderComponentState();
}

class _GenderComponentState extends State with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;


   int selectedRadio;
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
    print("Selected Radio: " + selectedRadio.toString());
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

          
      
        )
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