import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:froncophonie/constant.dart';
import 'package:froncophonie/models/place.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controller/requirement_state_controller.dart';
import 'clipper.dart';

class Beacon_Screen extends StatefulWidget {
  const Beacon_Screen({Key? key}) : super(key: key);

  @override
  State<Beacon_Screen> createState() => _Beacon_ScreenState();
}

class _Beacon_ScreenState extends State<Beacon_Screen>   with WidgetsBindingObserver {

  RequirementStateController controller =  Get.put(RequirementStateController());
  StreamSubscription<BluetoothState>? _streamBluetooth;
  StreamSubscription<RangingResult>? _streamRanging;
  var mybeacons = <String, Beacon>{};
  var tryy = <String, Beacon>{};
  String test_song="";


  Map<String,Place> places =<String,Place>{
    "EBEFD083-70A2-47C8-9837-E7B5634DF666": Place("Restaurant",
        "Restaurant",
        "Le restaurant italien gastronomique Faenza dans le parc de Djerba explore se trouve en face du Hanout de la TICDCE et a votre gauche en entrant.",
          "assets/666.jpg",
        "EBEFD083-70A2-47C8-9837-E7B5634DF666"),

    // "EBEFD083-70A2-47C8-9837-E7B5634DF777": Place("Algérie",
    //     "Alger",
    //     "Alger, surnommée El Bahdja, El Mahrussa ou El Beida, est la capitale de l'Algérie et en est la ville la plus peuplée.",
    //     "assets/alger.jpg",
    //     "EBEFD083-70A2-47C8-9837-E7B5634DF777"),
    //
    // "EBEFD083-70A2-47C8-9837-E7B5634DF888": Place(
    //     "République démocratique du Congo",
    //     "Kinshasa",
    //     "Kinshasa, appelée Léopoldville de 1881 à 1966, est la capitale et la plus grande ville de la république démocratique du Congo (RDC) ainsi que d'Afrique ; elle s’étend sur 9 965 km2. Avec une population estimée en 2021 à 17 millions d'habitants dans sa zone métropolitaine, elle est la troisième",
    //     "assets/kinshasa.png",
    //     "EBEFD083-70A2-47C8-9837-E7B5634DF888"),

    "EBEFD083-70A2-47C8-9837-E7B5634DF111": Place(
        "Pavillon de la tunisie",
        "Pavillon de la tunisie",
        "Le pavillon est un espace qui contient plusieurs expériences numériques immersives valorisant le patrimoine culturel tunisien, il a la forme d'un dôme circulaire et placé au centre du village de la francophonie."
        ,"assets/111.jpg",
        "EBEFD083-70A2-47C8-9837-E7B5634DF111"),

    "EBEFD083-70A2-47C8-9837-E7B5634DF222": Place(
        "Salle de conférence",
        "Salle de conférence",
        "La salle de conférence sera dediée â l'exposition des différentes manifestations culturelles.",
        "assets/222.jpg",
        "EBEFD083-70A2-47C8-9837-E7B5634DF222"),

    "EBEFD083-70A2-47C8-9837-E7B5634DF333": Place(
        "WC",
        "WC",
        "Les salles d'eaux se trouvent dans le restaurant la faenza à votre gauche en entrant.",
        "assets/333.png",
        "EBEFD083-70A2-47C8-9837-E7B5634DF333"),


    "EBEFD083-70A2-47C8-9837-E7B5634DF444": Place(
        "Espace Connecté ( AMVPPC)",
        "Espace Connecté ( AMVPPC)",
        "Espace connecté crée par l'agence de mise en valeur du patrimoine et de la promotion de la culture de  sous le nom Patrimoines connectés, patrimoine partagés au village de la francophonie. l'espace héberge un certain nombre d'expéiences numériques et culturelles.",
        "assets/444.jpg",
        "EBEFD083-70A2-47C8-9837-E7B5634DF444"),


    "EBEFD083-70A2-47C8-9837-E7B5634DF555": Place(
        "Hanout",
        "Hanout",
        "Le métaverse au coeur de djerba , évenement crée par Tunis International Center for Digital Cultural (TICDCE),un certain nombre d'expériences numériques liées aux monuments de l'île de Djerba, l'espace se trouve a votre gauche en entrant.",
        "assets/555.jpg",
        "EBEFD083-70A2-47C8-9837-E7B5634DF555"),


    // "EBEFD083-70A2-47C8-9837-E7B5634DF999": Place(
    //     "test",
    //     "999",
    //     "Kinshasa, appelée Léopoldville de 1881 à 1966, est la capitale et la plus grande ville de la république démocratique du Congo (RDC) ainsi que d'Afrique ; elle s’étend sur 9 965 km2. Avec une population estimée en 2021 à 17 millions d'habitants dans sa zone métropolitaine, elle est la troisième",
    //     "assets/kinshasa.png",
    //     "EBEFD083-70A2-47C8-9837-E7B5634DF999"),
    //
    //
    // "EBEFD083-70A2-47C8-9837-E7B5634D1000": Place(
    //     "test",
    //     "1000",
    //     "Kinshasa, appelée Léopoldville de 1881 à 1966, est la capitale et la plus grande ville de la république démocratique du Congo (RDC) ainsi que d'Afrique ; elle s’étend sur 9 965 km2. Avec une population estimée en 2021 à 17 millions d'habitants dans sa zone métropolitaine, elle est la troisième",
    //     "assets/kinshasa.png",
    //     "EBEFD083-70A2-47C8-9837-E7B5634D1000"),


  };

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    super.initState();
    listeningState();

    controller.startStream.listen((flag) {
      if (flag == true) {
        print("111111111");
        initScanBeacon();
      }
    });
    controller.pauseStream.listen((flag) {
      if (flag == true) {
        print("2222222222222222");

        pauseScanBeacon();
      }
    });
  }


  initScanBeacon() async {
    await flutterBeacon.initializeScanning;
    var status = await Permission.bluetoothScan.request();
    var status2 = await Permission.bluetoothConnect.request();
    var status3= await Permission.bluetooth.request();

    print(status.isGranted);
    print(status2.isGranted);
    print(status3.isGranted);

    if (!controller.authorizationStatusOk ||
        !controller.locationServiceEnabled ||
        !controller.bluetoothEnabled) {
      print(
          'RETURNED, authorizationStatusOk=${controller.authorizationStatusOk}, '
              'locationServiceEnabled=${controller.locationServiceEnabled}, '
              'bluetoothEnabled=${controller.bluetoothEnabled}');
      return;
    }
    final regions = <Region>[
      Region(
        identifier: 'iBeacon1',
        proximityUUID: 'EBEFD083-70A2-47C8-9837-E7B5634DF666',
      ),
      // Region(
      //   identifier: 'iBeacon2',
      //   proximityUUID: 'EBEFD083-70A2-47C8-9837-E7B5634DF777',
      // ),
      // Region(
      //   identifier: 'iBeacon3',
      //   proximityUUID: 'EBEFD083-70A2-47C8-9837-E7B5634DF888',
      // ),
      // Region(
      //   identifier: 'iBeacon4',
      //   proximityUUID: 'EBEFD083-70A2-47C8-9837-E7B5634DF615',
      // ),
      Region(
        identifier: 'iBeacon4',
        proximityUUID: 'EBEFD083-70A2-47C8-9837-E7B5634DF111',
      ),
      Region(
        identifier: 'iBeacon5',
        proximityUUID: 'EBEFD083-70A2-47C8-9837-E7B5634DF222',
      ),

      Region(
        identifier: 'iBeacon6',
        proximityUUID: 'EBEFD083-70A2-47C8-9837-E7B5634DF333',
      ),
      Region(
        identifier: 'iBeacon7',
        proximityUUID: 'EBEFD083-70A2-47C8-9837-E7B5634DF444',
      ),
      Region(
        identifier: 'iBeacon8',
        proximityUUID: 'EBEFD083-70A2-47C8-9837-E7B5634DF555',
      ),
      // Region(
      //   identifier: 'iBeacon9',
      //   proximityUUID: 'EBEFD083-70A2-47C8-9837-E7B5634DF999',
      // ),
      // Region(
      //   identifier: 'iBeacon10',
      //   proximityUUID: 'EBEFD083-70A2-47C8-9837-E7B5634D1000',
      // ),
      // Region(
      //   identifier: 'iBeacon5',
      //   proximityUUID: 'EBEFD083-70A2-47C8-9837-E7B5634DF611',
      // ),
      // Region(
      //   identifier: 'iBeacon6',
      //   proximityUUID: 'EBEFD083-70A2-47C8-9837-E7B5634DF616',
      // ),
      // Region(
      //   identifier: 'iBeacon7',
      //   proximityUUID: 'EBEFD083-70A2-47C8-9837-E7B5634DF617',
      // ),
      // Region(
      //   identifier: 'iBeacon8',
      //   proximityUUID: 'EBEFD083-70A2-47C8-9837-E7B5634DF618',
      // )
    ];

    if (_streamRanging != null) {
      if (_streamRanging!.isPaused) {
        _streamRanging?.resume();
        return;
      }
    }

    _streamRanging =
        flutterBeacon.ranging(regions).listen((RangingResult result) {
          // print("resulkt :    "+result.toString());
          if (mounted) {
            setState(() {

              if (result.beacons.isNotEmpty){
                mybeacons[result.beacons.first.proximityUUID]=result.beacons.first;
                // print("/////////////////////////////");
                // print(mybeacons);
                // print("////////////////////////");
              }
              if(mybeacons.length>1 && result.beacons.isNotEmpty  ){
                if(mybeacons[result.beacons.first.proximityUUID]!.accuracy<10) {
                  tryy = SplayTreeMap.from(
                      mybeacons, (key1, key2) =>
                      mybeacons[key1]!.accuracy.compareTo(
                          mybeacons[key2]!.accuracy));
                  if (test_song != tryy.values.toList()[0].proximityUUID) {
                    // FlutterRingtonePlayer.playNotification();
                    FlutterRingtonePlayer.play(
                        fromAsset: "assets/song/notification.mp3");
                    test_song = tryy.values.toList()[0].proximityUUID;
                    print(tryy.values.toList()[0].proximityUUID);
                  }
                }
              }
              // print("************************************");
              //  debugPrint(_regionBeacons.toString());
              //  print(_regionBeacons.length);
              // print("************************************");
            });
          }
        });
  }


  pauseScanBeacon() async {
    _streamRanging?.pause();
    if (mybeacons.isNotEmpty) {
      setState(() {
        mybeacons.clear();
        tryy.clear();
      });
    }
  }


  listeningState() async {
    print('Listening to bluetooth state');
    _streamBluetooth = flutterBeacon
        .bluetoothStateChanged()
        .listen((BluetoothState state) async {
      controller.updateBluetoothState(state);
      await checkAllRequirements();
    });
  }

  checkAllRequirements() async {
    await flutterBeacon.requestAuthorization;

    final bluetoothState = await flutterBeacon.bluetoothState;
    controller.updateBluetoothState(bluetoothState);
    print('BLUETOOTH $bluetoothState');

    final authorizationStatus = await flutterBeacon.authorizationStatus;
    controller.updateAuthorizationStatus(authorizationStatus);
    print('AUTHORIZATION $authorizationStatus');

    final locationServiceEnabled =
    await flutterBeacon.checkLocationServicesIfEnabled;
    controller.updateLocationService(locationServiceEnabled);
    print('LOCATION SERVICE $locationServiceEnabled');

    if (controller.bluetoothEnabled &&
        controller.authorizationStatusOk &&
        controller.locationServiceEnabled) {
      print('STATE READY');
        print('SCANNING');

        controller.startScanning();

    } else {
      print('STATE NOT READY');
      controller.pauseScanning();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('AppLifecycleState = $state');
    if (state == AppLifecycleState.resumed) {
      if (_streamBluetooth != null) {
        if (_streamBluetooth!.isPaused) {
          _streamBluetooth?.resume();
          // _streamRanging?.resume();
        }
      }
      await checkAllRequirements();
    } else if (state == AppLifecycleState.paused) {
      _streamBluetooth?.pause();
      // _streamRanging?.pause();

    }
  }

  @override
  void dispose() {
    _streamBluetooth?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return Scaffold(
      body:
        SafeArea(
          child: Container(
            color: bgColor,
              child:
              tryy.length>0 ? tryy.values.toList()[0].proximityUUID.isEmpty ? Center(child: CircularProgressIndicator()):

              Column(
                children: [
                      Stack(
                        children: [
                          ClipPath(
                            clipper:WaveClipper(),
                            child: Container(
                              height:MediaQuery.of(context).size.height*0.54 ,
                              color: Colors.grey.shade200,

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipPath(
                              clipper:WaveClipper(),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: InteractiveViewer(
                                  child: Image.asset(
                                      places[tryy.values.toList()[0].proximityUUID]!.Image.toString()
                                      , width: MediaQuery.of(context).size.width,
                                    height:MediaQuery.of(context).size.height*0.5 ,
                                    fit: BoxFit.cover,

                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height* .32,
                            child: Container(
                                width: MediaQuery.of(context).size.width* .5,
                                padding: const EdgeInsets.only(left: 20,top: 20),
                                child: AutoSizeText( places[tryy.values.toList()[0].proximityUUID]!.Name.toString(),
                                  maxFontSize: 48,
                                  minFontSize: 25,
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w900,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 2
                                      ..strokeCap=StrokeCap.round
                                      ..strokeJoin=StrokeJoin.round
                                      ..color = const Color(0xffF9F5EB),
                                  ),

                                )),
                          ),
                          Positioned(
                            top: size.height*0.37,
                            right: size.width*0.1,
                            child: Container(
                              width: size.width * .25,
                              height: size.width *.25,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(200),
                                color: customBlue
                              ),
                              alignment: Alignment.center,
                              child: AutoSizeText(places[tryy.values.toList()[0].proximityUUID]!.Name.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),
                              maxFontSize: 25,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )

                        ],
                      ),
                   // Container(
                   //   width: MediaQuery.of(context).size.width,
                   //   height: 10,
                   //   color: Color(0xff1C3879),
                   // ),
                   Container(
                     padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                     color: customBlue,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      width: size.width* .7,
                      height: 50,
                      alignment: Alignment.center,
                      child: AutoSizeText( places[tryy.values.toList()[0].proximityUUID]!.Pays.toString(),
                        textAlign: TextAlign.center,
                          maxLines: 1
                          ,style: GoogleFonts.roboto(fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.white

                        ),

                      )),

                  SizedBox(height: 24,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                    decoration: BoxDecoration(
                    color: Colors.white,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: AutoSizeText(places[tryy.values.toList()[0].proximityUUID]!.Desceription.toString(),
                      style: GoogleFonts.rubik(),
                      maxFontSize: 18,
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: size.width *.05),
                  //   height: 70,
                  //   width: size.width,
                  //   // color: Colors.red,
                  //   alignment: Alignment.centerRight,
                  //   child: Image.asset("assets/bray_img.png",width: size.width* .4,),
                  // )

                  // Center(child: Text(tryy.values.toList()[0].proximityUUID),),
                ],
              ):Center(child: CircularProgressIndicator(color: Colors.red,)),
            ),
        ),

    );
  }




  handleOpenLocationSettings() async {
    if (Platform.isAndroid) {
      await flutterBeacon.openLocationSettings;
    } else if (Platform.isIOS) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Location Services Off'),
            content: Text(
              'Please enable Location Services on Settings > Privacy > Location Services.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  handleOpenBluetooth() async {
    if (Platform.isAndroid) {
      try {
        await flutterBeacon.openBluetoothSettings;
      } on PlatformException catch (e) {
        print(e);
      }
    } else if (Platform.isIOS) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Bluetooth is Off'),
            content: Text('Please enable Bluetooth on Settings > Bluetooth.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

}
