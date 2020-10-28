import 'package:flutter/material.dart';
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
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.10,
                horizontal: MediaQuery.of(context).size.width * 0.05
              ),
              child:Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
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
  final controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return PageView(
            controller: controller,
            onPageChanged: (page)=>{ print(page.toString()) },
            pageSnapping: true,
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              AccountRegComponent(),
              GenderComponent(),
              AgeComponent(),
              // JobComponent(),
              MapComponent(),
            ]
    );
  }
}