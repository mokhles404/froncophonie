import 'package:flutter/material.dart';
import 'package:froncophonie/view/beacon_screen.dart';
import 'package:froncophonie/view/introduction_screen.dart';
import 'package:get/get.dart';
import '../constant.dart';


class ChoiceScreen extends StatelessWidget {
  const ChoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              // image: AssetImage("assets/Layer 2.png"),
              image: AssetImage("assets/background.png"),
                  fit: BoxFit.fill
            )
          ),
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(18)

            ),
            width: size.width*0.9,
            height: size.height*0.45,
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: ()=> Get.to(Introduction_Screen()),
                  child: Container(
                    margin: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                    color: customBlue,
                     borderRadius: BorderRadius.circular(8)
                    ),
                    width: size.width* .7,
                    height: 60,
                    alignment: Alignment.center,
                    child: const Text("Voyant",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 30),),
                  ),
                ),
                SizedBox(height: size.height*.02,),
                GestureDetector(
                  onTap: ()=> Get.offAll(Beacon_Screen()),
                  child: Container(
                  margin: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: customBlue,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    width: size.width* .7,
                    height: 60,
                    alignment: Alignment.center,
                    child: const Text("Non Voyant",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 30),),
                  ),
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}
