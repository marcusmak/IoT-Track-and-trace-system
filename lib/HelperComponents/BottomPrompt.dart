import 'package:flutter/material.dart';

class BottomPrompt extends StatefulWidget {
  void Function(bool) setBottomPrompt;
  Widget child;
  BottomPrompt(this.setBottomPrompt,this.child,{Key key}) : super(key: key);

  @override
  _BottomPromptState createState() => _BottomPromptState();
}

class _BottomPromptState extends State<BottomPrompt> {
  bool isShow = true;
  
  @override
  Widget build(BuildContext context) {
    
    return isShow?
     Dismissible(
      direction: DismissDirection.down,
      key: const Key('bottomPrompt'),
      onDismissed: (_) => widget.setBottomPrompt(false),
      child: Container(
          child: FittedBox(
                  child: Container(
                    padding: EdgeInsets.only(
                      top:MediaQuery.of(context).size.height * 0.01,
                    ),
                    alignment: Alignment.topCenter,
                    // height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(72, 72, 72, 1),
                      // border: Border.all(color:Colors.blueGrey),
                      borderRadius: BorderRadiusDirectional.only(
                        topStart:Radius.circular(25.0),
                        topEnd: Radius.circular(25.0)
                        
                      )

                    ),
                    child: 
                      Container(
                        // onPanUpdate: (details) {
                        //   if (details.delta.dy < 0) {
                        //     // swiping down
                        //     setState(()=>isShow = false);
                        //     print("swipe down");
                        //   }
                        // },
                        child: Column(
                            children: [
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.01,
                                  width: MediaQuery.of(context).size.width* 0.2,
                                  decoration: BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius: BorderRadius.circular(25)
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top:   MediaQuery.of(context).size.height * 0.022,
                                    left:  MediaQuery.of(context).size.width * 0.025,
                                    right: MediaQuery.of(context).size.width * 0.025,
                                  ),
                                  child: widget.child,
                                )
                              
                              ],
                        ),

                      )
                  ),
                
          )
       )
    ):
    Container();
    // if(isShow)
    
    //   return Container(
    //     child: Container(
    //       padding: EdgeInsets.symmetric(
    //         vertical: MediaQuery.of(context).size.height * 0.01,
    //       // horizontal: ,
    //       ),
    //       alignment: Alignment.topCenter,
    //       height: MediaQuery.of(context).size.height * 0.25,
    //       width: MediaQuery.of(context).size.width,
    //       decoration: BoxDecoration(
    //         color: Color.fromRGBO(72, 72, 72, 1),
    //         borderRadius: BorderRadiusDirectional.only(
    //           topStart:Radius.circular(25.0),
    //           topEnd: Radius.circular(25.0)
              
    //         )

    //       ),
    //       child: 
    //         GestureDetector(
    //           onPanUpdate: (details) {
    //             if (details.delta.dy < 0) {
    //               // swiping down
    //               setState(()=>isShow = false);
    //               print("swipe down");
    //             }
    //           },
    //           child: Container(
    //             height: MediaQuery.of(context).size.height * 0.01,
    //             width: MediaQuery.of(context).size.width* 0.2,
    //             decoration: BoxDecoration(
    //             color: Colors.white54,
    //             borderRadius: BorderRadius.circular(25)

    //             ),
    //             // child: Text("!@3"),
    //           ),
    //         )
    //     ),
    //   );
    // else
    //   return Container();
  }
}