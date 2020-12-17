import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vb_v0/ModelClass/UserProfile.dart';
import 'package:vb_v0/Register_components/AccountRegComponent.dart';
import 'package:vb_v0/Register_components/AgeComponent.dart';
import 'package:vb_v0/Register_components/JobComponent.dart';
import 'package:vb_v0/Register_components/MapComponent.dart';
import 'package:vb_v0/Register_components/GenderComponent.dart';
// import 'LoginPage.dart';

class RegisterPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( children: <Widget> [
          Container (
            constraints: BoxConstraints.expand(),
            // color: Colors.lightBlue,
            // alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/register_background.jpg'),
                  colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.multiply),
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.topLeft
                )
              ),
          ),
          SingleChildScrollView(
            // physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.10,
                // horizontal: MediaQuery.of(context).size.width * 0.05
              ),
              child:Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child:Padding(
                      padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width * 0.1),
                      child:Row(
                      children : <Widget> [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Color.fromRGBO(217,215,157,1),
                          size: 30.0,
                        ),
                        Text("Back", style: TextStyle(color: Color.fromRGBO(217,215,157,1), fontWeight: FontWeight.w700, fontSize: 25),)
                      ]
                      )
                    )

                  ),
                  Container(
                    // constraints: BoxConstraints.expand(),
                    height:MediaQuery.of(context).size.height * 0.75,
                    child:Center(
                      child:
                        
                        Questionaire()
                        
                      )
                  ),

                  
                // )
                ]

                
              
                )
              )
            )
          
  
      
      
        ]
      )
    );
    

  }

}

class Questionaire extends StatefulWidget{
  QuestionaireState createState() => QuestionaireState();
}

class QuestionaireState extends State<Questionaire>{
  int pageNum = 0;
  List<Widget> questions;
  UserProfile userProfile = new UserProfile();
  void Function() onNextCallback;
  
  // void onNext(void Function() onNextCallback){
  //   setState(
  //     ()=> this.onNextCallback = onNextCallback
  //   );
  // }
  
  @override
  void initState() { 
    super.initState();
    questions = <Widget>[
      // AccountRegComponent(userProfile: userProfile, controller: controller),
      // GenderComponent(userProfile: userProfile, controller: controller),
      // AgeComponent(userProfile: userProfile, controller: controller),
      // JobComponent(),
      MapComponent(userProfile: userProfile, controller: controller),
      // ConfirmationComponent(userProfile: userProfile, controller: controller),
    ];
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => print("Username:" + userProfile.userName.toString()));
    
  }


  final controller = PageController(
    initialPage: 0,
  );

  Widget mainContent(){
    return PageView(
            controller: controller,
            onPageChanged: (page){ setState((){pageNum = page;}); print(page.toString()); },
            pageSnapping: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: questions
    );
  }
  
  

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Expanded(child: mainContent(),),
        // Container(child: 
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Padding(
        //       padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width * 0.1),
        //       child: (pageNum!=0)?GestureDetector(
        //           onTap: () {
        //             controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        //           },                
        //           child: Text("Prev",style: TextStyle(color: Colors.white),),
        //         ):Container()
                  
        //       ),
        //       Padding(
        //         padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width * 0.1),
        //         child: GestureDetector(
        //           onTap: () {
        //             if(pageNum!=questions.length-1){
        //               // if(onNextCallback != null ){
        //               //   onNextCallback();
        //               // }
        //               controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        //             }
        //             else
        //               Navigator.pushReplacementNamed(context, '/scan_setup');
        //           },                
        //           child: Text(pageNum==questions.length-1?"Submit":"Next",style: TextStyle(color: Colors.white),),
        //         )
                  
        //       ),
        //     ],
        //   )
        // ,)
      ],
    );
  }
}


class ConfirmationComponent extends StatelessWidget {
  final PageController controller;
  final UserProfile userProfile;
  const ConfirmationComponent({Key key, this.controller, this.userProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}