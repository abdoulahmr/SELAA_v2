import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:selaa/backend-functions/data_manipulation.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/backend-functions/load_data.dart';
import 'package:selaa/backend-functions/map_fun.dart';

class OrderDelivery extends StatefulWidget {
  const OrderDelivery({Key? key, required this.orderID, required this.selected}) : super(key: key);
  final String orderID;
  final bool selected;

  @override
  State<OrderDelivery> createState() => _OrderDeliveryState();
}

class _OrderDeliveryState extends State<OrderDelivery> {
  late LatLng _currentLocation = const LatLng(0, 0);
  late GoogleMapController _mapController;
  late BitmapDescriptor customMarkerIcon = BitmapDescriptor.defaultMarker;
  List<Map<String, dynamic>> agents = [];
  bool isLoading = true;
  bool selected = false;

  @override
  void initState() {
    super.initState();
    getCurrentLocation().then((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        selected = widget.selected;
      });
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(
        _currentLocation,
        17.0,
      ));
    });
    loadAgents().then((data){
      setState(() {
        agents = data;
      });
    });
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Delivery Agent'),
        backgroundColor: AppColors().secondaryColor,
      ),
      body: isLoading
      ? Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: FutureBuilder<List<Marker>>(
              future: _loadMarkers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                  return GoogleMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation,
                      zoom: 17.0,
                    ),
                    markers: Set<Marker>.of(snapshot.data!),
                  );
                } else {
                  return CircularProgressIndicator(
                    color: AppColors().primaryColor,
                  );
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  color: AppColors().secondaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60.0),
                    topRight: Radius.circular(60.0),
                  ),
                ),
                child: selected
                ? StreamBuilder<List<dynamic>>(
                    stream: getRequestStatusStream(widget.orderID),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          color: AppColors().primaryColor,
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<dynamic> statuses = snapshot.data ?? [];
                        if (statuses.isEmpty) {
                          return const Text('No status data');
                        } else {
                          if(statuses[0]['status'] == 'pending'){
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: AppColors().primaryColor,
                                ),
                                const Text('Waiting for confirmation'),
                                const SizedBox(height: 20.0),
                                ElevatedButton(
                                  onPressed: () {
                                  },
                                  child: const Text('Cancel Request'),
                                ),
                              ],
                            );
                          }if(statuses[0]['status'] == 'confirmed'){
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: AppColors().primaryColor,
                                ),
                                const SizedBox(height: 10),                                
                                const Text("Delivery agent on the way"),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "Agent:",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(
                                      "${agents[0]['firstname']} ${agents[0]['lastname']}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: AppColors().primaryColor,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "Phone Number:",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(
                                      "${agents[0]['phoneNumber']}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: AppColors().primaryColor,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "Licence Plate:",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(
                                      "${agents[0]['licencePlate']}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: AppColors().primaryColor,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }if(statuses[0]['status'] == 'arrived'){
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child: const Text(
                                        'Agent has arrived, scan the QR code to confirm delivery',
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),                                
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(
                                          Size(
                                            MediaQuery.of(context).size.width * 0.4,
                                            MediaQuery.of(context).size.height * 0.05,
                                          ),
                                        ),
                                        backgroundColor: MaterialStateProperty.all(AppColors().primaryColor),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                            side: BorderSide(color: AppColors().borderColor),
                                          ),
                                        ),
                                      ),
                                      onPressed: (){}, 
                                      child: const Text(
                                        'Report Issue',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                QrImageView(
                                  data: widget.orderID,
                                  version: QrVersions.auto,
                                  size: MediaQuery.of(context).size.width * 0.35,
                                )
                              ],
                            );
                          }if(statuses[0]['status'] == 'delivering'){
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: AppColors().primaryColor,
                                ),
                                const SizedBox(height: 20.0),
                                const Text('Delivery in progress'),
                                const SizedBox(height: 20.0),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                      Size(
                                        MediaQuery.of(context).size.width * 0.4,
                                        MediaQuery.of(context).size.height * 0.05,
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(AppColors().primaryColor),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        side: BorderSide(color: AppColors().borderColor),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                  },
                                  child: const Text(
                                    'Report Issue',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }if(statuses[0]['status'] == 'delivered'){
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: AppColors().primaryColor,
                                ),
                                const SizedBox(height: 20.0),
                                const Text('Delivery in progress'),
                                const SizedBox(height: 20.0),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                      Size(
                                        MediaQuery.of(context).size.width * 0.4,
                                        MediaQuery.of(context).size.height * 0.05,
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(AppColors().primaryColor),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        side: BorderSide(color: AppColors().borderColor),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                  },
                                  child: const Text(
                                    'Report Issue',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }else{
                            return const Text("no data");
                          }
                        }
                      }
                    },
                  )
                : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: ListView.builder(
                      itemCount: agents.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _mapController.animateCamera(
                                  CameraUpdate.newLatLng(
                                    LatLng(
                                      agents[index]['lastLocation'].latitude,
                                      agents[index]['lastLocation'].longitude,
                                    ),
                                  ),
                                );
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Delivery Agent'),
                                      content: Text(
                                        '${agents[index]['brand']} ${agents[index]['model']}',
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            requestDelivery(agents[index]['agentId'],_currentLocation,widget.orderID);
                                            setState(() {
                                              selected = true;
                                              agents=[agents[index]];
                                            });
                                          },
                                          child: const Text('OK',style: TextStyle(color: Color(0xFF415B5B))),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel',style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      agents[index]['firstname'] + ' ' + agents[index]['lastname'],
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    const Text(
                                      "priceX",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        agents[index]['vehiculeType'] == 'Car' ?
                                        const Icon(Icons.directions_car) :
                                        agents[index]['vehiculeType'] == 'Truck' ?
                                        const Icon(Icons.local_shipping) :
                                        const Icon(Icons.motorcycle),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          '${agents[index]['brand']}',
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          '${agents[index]['model']}',
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on),
                                        const SizedBox(width: 10.0),
                                        FutureBuilder<double>(
                                          future: calculateDistance(
                                            _currentLocation,
                                            LatLng(
                                              agents[index]['lastLocation'].latitude,
                                              agents[index]['lastLocation'].longitude,
                                            ),
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.done &&
                                              snapshot.hasData) {
                                              return Text(
                                                '${(snapshot.data! / 1000).toStringAsFixed(2)} km',
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                ),
                                              );
                                            } else {
                                              return CircularProgressIndicator(
                                                color: AppColors().primaryColor,
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: AppColors().primaryColor,
                            ),
                          ],
                        );
                      },
                    )
                  ),
                )
              ),
            ),
          ),
        ],
      )
      : Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.width * 0.1,
            child: CircularProgressIndicator(
              color: AppColors().primaryColor,
            ),
          )
        ),
    );
  }

  Future<List<Marker>> _loadMarkers() async {
    List<Marker> markers = [];
    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: _currentLocation,
        icon: customMarkerIcon,
    ));
    for (var agent in agents) {
      BitmapDescriptor icon = await loadCustomMarkerIcon(agent["vehiculeType"]);
      markers.add(
        Marker(
          markerId: MarkerId(agent['firstname'] + agent['lastname']),
          position: LatLng(
            agent['lastLocation'].latitude,
            agent['lastLocation'].longitude,
          ),
          icon: icon,
        ),
      );
    }
    return markers;
  }
}