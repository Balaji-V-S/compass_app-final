import 'package:compass_edge/Pages/EmergencyButton.dart';
import 'package:compass_edge/Services/Admobclass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math; // to calculate pi val

import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:compass_edge/Pages/Police.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
//Pages
import 'package:compass_edge/Pages/Location_screen.dart';
import 'package:compass_edge/Services/Admobclass.dart';
import 'package:compass_edge/Pages/mapbox.dart';
import 'package:compass_edge/Pages/torch.dart';
import 'package:compass_edge/Pages/Nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

// Since direction keeps changing... a stf widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // BannerAd? _banner;
  //InterstitialAd? _interstitialAd;

  @override
  /*void initState() {
    super.initState();

    _createBannerAd();

    _CreateInterstitialAd();
  }

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  void _CreateInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobService.interstitialAdUnitId!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => _interstitialAd = ad,
          onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null,
        ));
  }
*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.asset(
                  'assets/logo-png.png',
                  fit: BoxFit.contain,
                  scale: 10,
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(right: 90, left: 10),
                  child: Text('Compass Edge',
                      style: GoogleFonts.jost(
                          fontSize: 20, fontWeight: FontWeight.bold)))
            ],
          ),
        ),
        drawer: const NavigationDrawer(),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 93, 172, 236),
                Color.fromARGB(255, 83, 105, 226)
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Builder(builder: (context) {
            return Column(
              children: <Widget>[
                Expanded(child: _buildCompass()),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCompass() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // might need to accound for padding on iphones
    //var padding = MediaQuery.of(context).padding;
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        double? direction = snapshot.data!.heading;
        //print(direction);
        // if direction is null, then device does not support this sensor
        // show error message
        if (direction == 0.000) {
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          return WillPopScope(
            child: Stack(
              children: [
                Container(height: 45, child: const Emergency()),
                Padding(
                  padding: const EdgeInsets.only(top: 0100),
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/Compass_null.png',
                      scale: 1.4,
                    ),
                  ),
                ),
                Container(
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 310),
                    child: Column(
                      children: [
                        Text(
                          'OOPS! Magnetometer is missing on your device,\n Unsupported Magnetometer and Altimeter',
                          style: GoogleFonts.jost(
                              fontSize: 17, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        Icon(
                          CupertinoIcons.compass,
                          size: 40,
                        )
                      ],
                    ),
                  )),
                ),
                Container(
                  child: Builder(builder: (context) {
                    return Column(
                      children: <Widget>[
                        const Expanded(child: TorchButton()),
                      ],
                    );
                  }),
                ),
                /* Container(
                margin: const EdgeInsets.only(bottom: 12),
                //height: 52,
                child: AdWidget(ad: _banner!),
              ),*/
              ],
            ),
            onWillPop: () => _onBackpressed(context),
          );
        } else {
          int ang = (direction!.round());
          return WillPopScope(
            child: Stack(
              children: [
                Container(height: 45, child: const Emergency()),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Transform.rotate(
                    angle: ((ang) * (math.pi / 180) * -1),
                    child: Image.asset(
                      'assets/digicom.png',
                      scale: 0.9,
                    ),
                  ),
                ),
                Container(
                  child: Builder(builder: (context) {
                    return Column(
                      children: <Widget>[
                        const Expanded(child: TorchButton()),
                      ],
                    );
                  }),
                ),
                /* Container(
                margin: const EdgeInsets.only(bottom: 12),
                //height: 52,
                child: AdWidget(ad: _banner!),
              ),*/
                Center(
                  child: Text(
                    "$ang",
                    style: GoogleFonts.anton(
                      color: const Color(0xFFEBEBEB),
                      fontSize: 50,
                    ),
                  ),
                ),
                Positioned(
                  // center of the screen - half the width of the rectangle
                  left: (width / 2) - ((width / 80) / 2),
                  // height - width is the non compass vertical space, half of that
                  top: (height - width) / 2,
                  child: SizedBox(
                    width: width / 80,
                    height: width / 10,
                    child: Container(
                      //color: HSLColor.fromAHSL(0.85, 0, 0, 0.05).toColor(),
                      color: const Color.fromARGB(255, 245, 4, 4),
                    ),
                  ),
                ),
              ],
            ),
            onWillPop: () => _onBackpressed(context),
          );
        }
      },
    );
  }

  Future<bool> _onBackpressed(BuildContext context) async {
    bool? exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Really?",
              style: GoogleFonts.jost(),
            ),
            content: Text(
              "Do you want to exit the App?",
              style: GoogleFonts.jost(),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  "Yes",
                  style: GoogleFonts.jost(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  "No",
                  style: GoogleFonts.jost(color: Colors.black),
                ),
              )
            ],
          );
        });
    return exitApp ?? false;
  }
}
