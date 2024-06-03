import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../model/shop_model.dart';

class GoogleMapScreen extends StatefulWidget {
  final ShopModel shopModel;

  const GoogleMapScreen({Key? key, required this.shopModel}) : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}
class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(double.parse(widget.shopModel.latitude), double.parse(widget.shopModel.longitude)),
        zoom: 20.0,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
