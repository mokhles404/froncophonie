import 'package:flutter/material.dart';
import 'package:froncophonie/constant.dart';



class WelcomePage extends StatelessWidget {

  final String title;
  final String descrption;
  final String imgpath;
  final bool firstPage;
  const WelcomePage(
      {Key? key,
        required this.title,
        required this.descrption,
        required this.imgpath,
        required this.firstPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
            color: bgColor,
        child:Column(
          children: [
            Flexible(
              flex: 6,
              child: Container(
                width: size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .05,vertical: size.height * .04),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(imgpath,fit: BoxFit.cover,)),
                ) ,
              ),
            ),
            Flexible(
              flex: 7,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/Layer 2.png",  ),
                    fit: BoxFit.cover
                  )
                ),
                child: Column(
                  children: [
                    SizedBox(height: size.height * .02,),
                    if(firstPage)
                    Container(
                      color: customBlue,
                      width: size.width* .5,
                      height: size.height* .05,
                      alignment: Alignment.center,
                      child: Text("Bienvenue",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 30),),
                    ),
                    // SizedBox(height: size.height* .03,),
                    Image.asset("assets/bienvenue.png",width: size.width * .45),
                    // SizedBox(height: size.height* .03,),
                    Container(

                      child: Text(title,style: TextStyle(color: customBlue,fontSize: 28,fontWeight: FontWeight.w700),),
                    ),
                    SizedBox(height: size.height* .03,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: size.width *.05),
                      child: Text(descrption,style: TextStyle(),textAlign: TextAlign.justify,),
                    ),
            Container(height: 80,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
