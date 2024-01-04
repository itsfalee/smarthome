import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key,}) : super(key: key);



  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State {
  String strLatLong = 'Belum Mendapatkan Lat dan Long, Silahkan tekan tombol';
  String strAlamat = 'Mencari lokasi...';
  bool loading = false;

  //getLatLong
  Future _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //location service not enabled, don't continue
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    //permission denied forever
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permission denied forever, we cannot access',
      );
    }
    //continue accessing the position of device
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // //getAddress
  Future getAddressFromLongLat(Position position) async {
    List placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);

    Placemark place = placemarks[0];
    setState(() {
      strAlamat = '${place.street}, ${place.subLocality}, ${place.locality}, '
          '${place.postalCode}, ${place.country}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color.fromARGB(255, 247, 233, 194),
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 247, 233, 194),
       ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Titik Koordinat',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              child: Text(strLatLong),
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: strLatLong));
                final snackBar = SnackBar(
                  content: const Text('LatLong berhasil disalin!'),
                  backgroundColor: (Colors.teal),
                  action: SnackBarAction(
                    textColor: Colors.white,
                    label: 'Tutup',
                    onPressed: () {},
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Alamat',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: GestureDetector(
                child: Text(strAlamat),
                onLongPress: () {
                  Clipboard.setData(ClipboardData(text: strAlamat));
                  final snackBar = SnackBar(
                    content: const Text('Alamat berhasil disalin!'),
                    backgroundColor: (Colors.green),
                    action: SnackBarAction(
                      textColor: Colors.white,
                      label: 'Tutup',
                      onPressed: () {},
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.teal),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });

                      Position position = await _getGeoLocationPosition();
                      setState(() {
                        loading = false;
                        strLatLong =
                            '${position.latitude}, ${position.longitude}';
                      });

                      getAddressFromLongLat(position);
                    },
                    child: const Text(
                      'Tagging Lokasi',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
