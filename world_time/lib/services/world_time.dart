import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String? location;
  String? time;
  String? flag;
  String? url;
  bool? isDayTime;

  WorldTime({this.location, this.flag, this.url});

  Future<void> getTime() async {
    try {
      // make the request
      Response response =
          await get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(response.body);

      // get properties from json
      String datetime = data['utc_datetime'];
      String offset = data['utc_offset'].substring(1, 3);
      String offsetmin = data['utc_offset'].substring(4, 6);
      // create DateTime object
      DateTime now = DateTime.parse(datetime);
      if (data['utc_offset'][0] == '+') {
        now = now.add(
            Duration(hours: int.parse(offset), minutes: int.parse(offsetmin)));
      } else {
        now = now.subtract(
            Duration(hours: int.parse(offset), minutes: int.parse(offsetmin)));
      }
      // set the time property
      isDayTime = now.hour > 5 && now.hour < 20 ? true : false;
      time = DateFormat.jm().format(now);
    } catch (e) {
      time = 'could not get time';
    }
  }
}
