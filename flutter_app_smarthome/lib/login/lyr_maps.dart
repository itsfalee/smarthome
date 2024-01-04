import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // menampikan peta
import 'package:latlong2/latlong.dart'; //mendapatkan lat long
import 'package:geolocator/geolocator.dart'; // nilai dari lat long
import 'package:geocoding/geocoding.dart'; //mendaptkan nilai dari alamt,negara,prov,kota,dll


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Geocoding',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController _mapController;
  late LatLng _targetLocation;
  // double _sheetPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getLocation();
  }

  void _moveCamera() {
    _mapController.move(
      _targetLocation,
      _mapController.zoom,
    );
  }

  Future<List<Placemark>> _getPlacemarks(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      return placemarks;
    } catch (e) {
      print("Error getting placemarks: $e");
      return [];
    }
  }

  Future<void> _getLocation() async {
    try {
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await _getPlacemarks(position);

      setState(() {
        currentLocation = position;
        currentPlacemarks = placemarks;
        _targetLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Position? currentLocation;
  List<Placemark> currentPlacemarks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Map'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(currentLocation?.latitude ?? -0.9471,
                  currentLocation?.longitude ?? 100.4172),
              initialZoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(// untuk penanda merah pada peta
                markers: [
                if (currentLocation != null)
                  Marker(
                    point: LatLng(
                      currentLocation!.latitude,
                      currentLocation!.longitude,
                    ),
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  )
              ]),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return GeocodingInfoWidget(
                placemarks: currentPlacemarks,
                scrollController: scrollController,
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _getLocation();
          _moveCamera();
        },
        shape: CircleBorder(side: BorderSide(color: Colors.red)),
        splashColor: Colors.black45,
        backgroundColor: Colors.white,
        elevation: 30,
        child: Icon(
          Icons.my_location,
          color: Colors.red,
        ),
      ),
    );
  }
}

class GeocodingInfoWidget extends StatelessWidget {
  final List<Placemark> placemarks;
  final ScrollController scrollController;

  GeocodingInfoWidget(
      {required this.placemarks, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    Placemark firstPlacemark =
        placemarks.isNotEmpty ? placemarks.first : Placemark();

    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Text(
              'Information:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Negara   : ${firstPlacemark.country}'),
                Text('Provinsi : ${firstPlacemark.administrativeArea}'),
                Text('Kota     : ${firstPlacemark.subAdministrativeArea}'),
                Text('Kecamatan: ${firstPlacemark.locality}'),
                Text('Kelurahan: ${firstPlacemark.subLocality}'),
                Text('Jalan    : ${firstPlacemark.name}'),
                SizedBox(height: 16.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
