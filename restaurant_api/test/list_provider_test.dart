import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_api/data/api/api_service.dart';
import 'package:restaurant_api/data/model/restaurant_list.dart';

@GenerateMocks([http.Client])
void main() {
  group("Testing for Restaurant List API", () {
    test ( 'Testing get restaurants',
      () async {
        final client = MockClient();

        when(client.get(Uri.parse(ApiService.baseUrl+ApiService.list)))
          .thenAnswer((_) async=> http.Response(
            '{"error":false,"message":"success","count":20,"restaurants":[]}',
            200));
        
        expect(await ApiService(client: client).getRestaurants(), isA<RestaurantList>());
      }
    );
  });
}