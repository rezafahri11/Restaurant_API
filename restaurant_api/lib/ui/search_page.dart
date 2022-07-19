import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/provider/search_provider.dart';
import 'package:restaurant_api/widgets/search_view.dart';

class SearchRestaurantPage extends StatelessWidget {
  static const routeName = 'search_page';
  const SearchRestaurantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      builder: (context, child) {
        return Scaffold(
            appBar: AppBar(title: const Text('Search Restaurant')),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    hintText: 'Cari restoran berdasarkan nama, kategori atau menu',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (String value) {
                    Provider.of<SearchProvider>(context, listen: false)
                        .searchRestaurant(value);
                  },
                ),
                Expanded(
                  child: Consumer<SearchProvider>(
                    builder: (context, state, _) {
                      if (state.state == fetchSearch.Loading) {
                        return const Center(
                          child: Icon(
                            Icons.search_rounded,
                            size: 100,
                          ),
                        );
                      } else if (state.state == fetchSearch.HasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.result.founded,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 3,
                              child: SearchRestaurantView(restaurant: state.result.restaurants[index],),
                            );
                          },
                        );
                      } else if (state.state == fetchSearch.NoData) {
                        return Center(
                          child: Text(state.message),
                        );
                      } else if (state.state == fetchSearch.Error) {
                        return Center(
                          child: Text(state.message),
                        );
                      } else {
                        return Center(
                          child: Text(''),
                        );
                      }
                    },
                  ),
                )
              ],
            ));
      },
    );
  }
}
