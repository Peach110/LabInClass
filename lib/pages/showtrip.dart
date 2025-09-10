import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_1/config/internal_config.dart';
import 'package:flutter_mobile_1/pages/profile.dart';
import 'package:http/http.dart' as http;

// ===== Configuration class =====
class Configuration {
  static Future<Map<String, dynamic>> getConfig() async {
    return {"apiEndpoint": API_ENDPOINT};
  }
}

// ===== Model =====
class TripGetResponse {
  final String name;
  final String destination;
  final String detail;
  final String? coverimage;

  TripGetResponse({
    required this.name,
    required this.destination,
    required this.detail,
    this.coverimage,
  });

  factory TripGetResponse.fromJson(Map<String, dynamic> json) {
    return TripGetResponse(
      name: json['name'] ?? '',
      destination: json['destination'] ?? '',
      detail: json['detail'] ?? 'ไม่มีรายละเอียด',
      coverimage: json['coverimage'],
    );
  }
}

List<TripGetResponse> tripGetResponseFromJson(String str) {
  final data = jsonDecode(str) as List;
  return data.map((e) => TripGetResponse.fromJson(e)).toList();
}

// ===== Service =====
class TripService {
  final String apiUrl;

  TripService({required this.apiUrl});

  Future<List<TripGetResponse>> getTrips() async {
    try {
      final res = await http.get(Uri.parse('$apiUrl/trips'));
      log(res.body);

      List<TripGetResponse> tripGetResponses = tripGetResponseFromJson(
        res.body,
      );
      log("โหลดทริป ${tripGetResponses.length} รายการ");

      return tripGetResponses;
    } catch (e) {
      log("Error getTrips: $e");
      return [];
    }
  }
}

class ShowtripPage extends StatefulWidget {
  final int cid;
  final Map<String, dynamic> userData;

  const ShowtripPage({super.key, required this.cid, required this.userData});

  @override
  State<ShowtripPage> createState() => _ShowtripPageState();
}

class _ShowtripPageState extends State<ShowtripPage> {
  String? url;
  List<TripGetResponse> trips = [];
  List<TripGetResponse> filteredTrips = [];
  String selectedFilter = "ทั้งหมด";

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) async {
      setState(() {
        url = config['apiEndpoint'];
      });

      if (url != null) {
        final service = TripService(apiUrl: url!);
        final tripsFromApi = await service.getTrips();
        setState(() {
          trips = tripsFromApi;
          filteredTrips = tripsFromApi;
        });
      }
    });
  }

  void applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == "ทั้งหมด") {
        filteredTrips = trips;
      } else {
        filteredTrips = trips
            .where((trip) => trip.destination == filter)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("รายการทริป"),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'Profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(userData: widget.userData),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "Profile",
                child: Text("ข้อมูลส่วนตัว"),
              ),
              const PopupMenuItem(value: "Logout", child: Text("ออกจากระบบ")),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.all(8.0), child: Text("ปลายทาง")),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterButton("ทั้งหมด"),
                const SizedBox(width: 8),
                _buildFilterButton("เอเชีย"),
                const SizedBox(width: 8),
                _buildFilterButton("ยุโรป"),
                const SizedBox(width: 8),
                _buildFilterButton("อเมริกา"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredTrips.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredTrips.length,
                    itemBuilder: (context, index) {
                      final trip = filteredTrips[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: trip.coverimage != null
                                    ? Image.network(
                                        trip.coverimage!,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Image.asset(
                                                "assets/images/ashe.jpg",
                                                height: 150,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                      )
                                    : Image.asset(
                                        "assets/images/ashe.jpg",
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                trip.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "ปลายทาง: ${trip.destination}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                trip.detail,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TripDetailPage(trip: trip),
                                      ),
                                    );
                                  },
                                  child: const Text("รายละเอียดเพิ่มเติม"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    return FilledButton(
      onPressed: () => applyFilter(filter),
      style: FilledButton.styleFrom(
        backgroundColor: selectedFilter == filter
            ? Colors.deepPurple
            : Colors.grey[300],
        foregroundColor: selectedFilter == filter ? Colors.white : Colors.black,
      ),
      child: Text(filter),
    );
  }
}

// ===== Page: TripDetailPage =====
class TripDetailPage extends StatelessWidget {
  final TripGetResponse trip;

  const TripDetailPage({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(trip.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: trip.coverimage != null
                  ? Image.network(
                      trip.coverimage!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/ashe.jpg",
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      "assets/images/ashe.jpg",
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              "ชื่อทริป: ${trip.name}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "ปลายทาง: ${trip.destination}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "รายละเอียด: ${trip.detail}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
