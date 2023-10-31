// Get Audiences ==> Men, Women, Boys, Girls, Baybies,

import 'package:flutter/material.dart';
import 'package:shoe_shop_3/pages/cate_prod/all_categories.dart';

import '../../models/audience_model.dart';
import '../../reops/audience_repo.dart';
import '../../widgets/custom_drawer_app_mode.dart';
import '../../widgets/search_appbar.dart';

class BaseCategoriesPage extends StatefulWidget {
  const BaseCategoriesPage({Key? key}) : super(key: key);

  @override
  State<BaseCategoriesPage> createState() => _BaseCategoriesPageState();
}

class _BaseCategoriesPageState extends State<BaseCategoriesPage> {
  void updateAppModeIcon(IconData newIcon) {
    setState(() {
      appModeIcon = newIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(context),
      drawer: CustomDrawerWithAppMode(context, updateAppModeIcon),
      body: Container(
        child: FutureBuilder<List<AudienceModel>>(
          future: AudienceRepository().getAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                    child: Text("Error: ${snapshot.error.toString()}"));
              }
              var items = snapshot.data ?? [];
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: items.isEmpty
                    ? Center(child: Text("No Data"))
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AllCategoriesPage(
                                        field: "Audience",
                                        value: '${items[index].name}',
                                      )));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          items[index].image ?? ''),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(
                                            0.4), // Adjust background image opacity (0.0 to 1.0)
                                        BlendMode
                                            .darken, // Apply a dark overlay
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 16.0),
                                        Text(
                                          '${items[index].name}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: items.length,
                      ),
              );
            } else {
              return Center(
                child: Text("Error: ${snapshot.error.toString()}"),
              );
            }
          },
        ),
      ),
    );
  }
}
