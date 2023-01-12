import 'package:flutter/material.dart';
import 'package:froncophonie/view/beacon_screen.dart';
import 'package:froncophonie/view/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';

class Introduction_Screen extends StatefulWidget {
  const Introduction_Screen({Key? key}) : super(key: key);

  @override
  State<Introduction_Screen> createState() => _Introduction_ScreenState();
}

class _Introduction_ScreenState extends State<Introduction_Screen> {
  final mycontroller = PageController();
  int index = 0;

  @override
  void dispose() {
    mycontroller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: mycontroller,
        onPageChanged: (ind) {
          setState(() {
            index = ind;
          });
        },
        children: const [
          WelcomePage(
              imgpath: "assets/welcome_bg.jpg",
              title: "Village de la Francophonie",
              firstPage: true,
              descrption:
                 "Le terme Francophonie est apparu en France à la fin du XIXe siècle pour définir l'espace géographique qui réunissait les francophones du monde et le projet de la Francophonie. L'Organisation internationale de la Francophonie (OIF) a été créée en 2007 et compte actuellement 88 États et gouvernements.        "

          ),
          WelcomePage(
              imgpath: "assets/welcome_bg2.jpg",
              title: "Savoir plus",
              firstPage: false,
              descrption:
        "Cette application vous aidera à faire le tour du village de la francophonie .Ceci est une application, qui vous permet de déterminer votre position même si c'est la première fois que vous les visitez"
          ),
          WelcomePage(
              imgpath: "assets/welcome_bg3.png",
              title: "Prenons un tour",
              firstPage: false,
              descrption:
        "Vous pouvez commencer votre visite et découvrir chaque pays à travers un guide audio .")
        ],
      ),
      bottomSheet: Container(
        // color: Color(0xffEAE3D2),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [




            //Demo part
            // SizedBox(width: 50,),
            index ==2
                ? TextButton(
                    onPressed: () {
                      mycontroller.animateToPage(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    child: Text(
                      "retour ",
                      style: GoogleFonts.actor(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff607EAA)),
                    ))
                : TextButton(
                    onPressed: () {
                      Get.offAll(const Beacon_Screen(),duration: Duration(milliseconds: 500),curve: Curves.bounceIn);
                    },
                    child: Text(
                      "Sauter ",
                      style: GoogleFonts.actor(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff607EAA)),
                    )),
            Center(
              child: SmoothPageIndicator(
                controller: mycontroller,
                count: 3,
              ),
            ),
            TextButton(
                onPressed: () {
                  print(index);
                  if (index == 0) {
                    mycontroller.animateToPage(1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  }else if(index==1){
                    mycontroller.animateToPage(2,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  }
                  else {
                    Get.offAll(const Beacon_Screen());
                  }
                },
                child: Text(index == 0 || index ==1 ? "Suivant" : " Commencer",
                    style: GoogleFonts.actor(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff607EAA)))),
          ],
        ),
      ),
    );
  }
}


