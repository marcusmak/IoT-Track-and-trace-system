import 'package:flutter/material.dart';
import 'package:vb_v0/HomeComponents/Tabs.dart';
import 'package:vb_v0/HelperComponents/BottomPrompt.dart';

/// This is the stateful widget that the main application instantiates.
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const Color barBgColor = Color.fromARGB(255, 79, 79, 79);
  static const Color inactiveBtnColor = Color.fromRGBO(130, 121, 121,0.5);
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Widget BPContent;
  void setBPContent(Widget content){
    print("set Content");
    setState(() {
      BPContent = content;
    });
    print(BPContent);
    setBottomPrompt(true);
  }

  List<Widget> _widgetOptions() {
    return <Widget>[
      // Text(
      //   'Index 0: List',
      //   style: optionStyle,
      // ),
      ListTab(this.setBPContent,this.setBottomPrompt),
      // MapTab(),
      Text(
        'Index 1: Map',
        style: optionStyle,
      ),
      PackingTab(),
      // Text(
      //   'Index 2: Packing',
      //   style: optionStyle,
      // ),
      Text(
        'Index 3: Chart',
        style: optionStyle,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  bool bottomPromptShow = false;

  void setBottomPrompt(bool value){
    setState(() {
      bottomPromptShow = value;
    });
  }

  Widget overlay(){
    // return Flex(direction: null)
    return Positioned.fill(
      // flex: 1,
      child: GestureDetector(
        onTap: (){
          this.setBottomPrompt(false);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black38
          ),
        ),
      )
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
              children:[
                  Scaffold(
                    body: Scaffold(
                      backgroundColor: Color.fromARGB(255, 100, 100, 100),
                      body: Padding(
                        padding: EdgeInsets.fromLTRB(0,MediaQuery.of(context).size.height * 0.05,0,0),
                        child:
                        Column(
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:<Widget>[
                                GestureDetector(
                                  onTap: (){
                                    print("add an item");
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
                                    child:
                                    Icon(
                                        Icons.playlist_add,
                                        size: 30.0,
                                        color: Color.fromRGBO(207, 190, 190, 1)
                                    )
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    print("go to setting");
                                    Navigator.pushNamed(context, "/setting");
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
                                    child:Icon(
                                      Icons.settings,
                                      size: 30.0,
                                      color: Color.fromRGBO(207, 190, 190, 1)
                                    ),
                                  ),
                                ),
                              ]
                            ),
                            _widgetOptions().elementAt(_selectedIndex),
                          ],
                        )
                        
                      )
                    ),
                    bottomNavigationBar: BottomNavigationBar(
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.list_alt_rounded),
                          title: Text('List'),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.map),
                          title: Text('Map'),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.card_travel_rounded),
                          title: Text('Packing'),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.pie_chart),
                          title: Text('School'),
                        ),
                      ],
                      currentIndex: _selectedIndex,
                      selectedItemColor: Color.fromRGBO(207, 190, 190, 1),
                      unselectedItemColor: inactiveBtnColor,
                      showSelectedLabels: true,
                      iconSize: 30.0,
                      type: BottomNavigationBarType.fixed,
                      showUnselectedLabels: true,
                      onTap: _onItemTapped,
                      backgroundColor: barBgColor,
                    ),
                    
                  ),
                  bottomPromptShow?overlay():Container(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child:bottomPromptShow?BottomPrompt(setBottomPrompt,BPContent):Container(), 
                    
                    
                  ),
          ]
        ),
    );
    
     
  }
}
