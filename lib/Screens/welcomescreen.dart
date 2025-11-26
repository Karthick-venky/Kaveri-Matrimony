
import '../export.dart';
import 'loginScreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background_success.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              height: 550,
             color: Colors.amberAccent,
              //color: Colors.red,
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  const Text('Registration Successfully',style: TextStyle(color: Colors.blue,fontSize: 25,fontWeight: FontWeight.w900),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/mainlogo.jpg',fit: BoxFit.fitWidth,)
                  ),
                  const SizedBox(height: 10,),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('தங்களின் வரன் விபரம் பதிவு செய்யப்பட்டது விரைவில் தங்களை தொடர்பு கொள்கிறோம் மேலும் தகவல் பெற இந்த எண்ணில் 9363052151 தொடர்பு கொள்ளவும்',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const loginScreen(),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFf9fd01),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      minimumSize: const Size(100, 50),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
