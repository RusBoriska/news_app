import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/shared/queries.dart';
import '/features/news/domain/entity/news_entity.dart';
import '/features/news/presentation/screens/bloc/main_news_bloc.dart';
import '/core/di/service_locator.dart';


class MainNewsScreen extends StatelessWidget {
  const MainNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainNewsBloc, MainNewsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is MainNewsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is MainNewsErrorState) {
          return Center(
            child: Text(
              state.message,
              textAlign: TextAlign.center,
            ),
          );
        }
        if (state is MainNewsInitialState) {
          return Scaffold(
            body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "What news do you want to read?",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber, // Background color
                              ),
                              onPressed: () => context.read<MainNewsBloc>().add(MainNewsGetRecentNewsEvent(query: serviceLocator<Query>().russia)),
                              child: const Text(
                                "Russia",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              )
                          ),
                          const SizedBox(height: 20,),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber, // Background color
                              ),
                              onPressed: () => context.read<MainNewsBloc>().add(MainNewsGetRecentNewsEvent(query: serviceLocator<Query>().elonMusk)),
                              child: const Text(
                                "Elon Musk",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              )
                          ),
                          const SizedBox(height: 20,),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber, // Background color
                              ),
                              onPressed: () => _showDialogWithField(context),
                              child: const Text(
                                "Your query",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              )
                          ),
                        ],
                      ),
                    )
                  ],
                )
            ),
          );
        }
        if (state is MainNewsGetRecentNewsSuccessState) {
          return WillPopScope(
            child: Scaffold(
              body: SafeArea(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent News',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color: Colors.white),
                            child: const Row(
                              children: [
                                Text(
                                  'VIEW MORE',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: 10,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      childAspectRatio: 21 / 10,
                      crossAxisCount: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children:
                          state.news.map((news) => _newsItem(context, news)).toList(),
                    ),
                  ],
                ),
              ),
            ),
              onWillPop: () async {
                  return false;
            }
            );
        }
        return const SizedBox();
      },
    );
  }


  void _showDialogWithField(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (_) {
        TextEditingController queryController = TextEditingController();
        return AlertDialog(
          title: const Text('Write your query below'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: queryController,
                    decoration: const InputDecoration(hintText: 'Your query'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<MainNewsBloc>().add(MainNewsGetRecentNewsEvent(query: queryController.text));
                  Navigator.pop(context);
                  queryController.clear();
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }


    Widget _newsItem(BuildContext context, NewsEntity news) {
    final borderRadius = BorderRadius.circular(10);
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: (){
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('News'),
              content: SingleChildScrollView(
                child: Text(news.description!)
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Center(
                      child: Text('OK')
                  ),
                ),
              ],
            );
          },
        );
        },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
        ),
        child: Stack(
          children: [
            if (news.imageUrl == null)
              const Center(
                child: Text(
                  "No Image",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            if (news.imageUrl != null)
              CachedNetworkImage(
                imageUrl: news.imageUrl!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Text(
                    "No Image",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                stops: const [0, 0.4, 0.6, 1],
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.8)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      if (news.publishedAt != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(999)),
                              child: Text(news.publishedAt!.split("T")[0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  )),
                            )
                          ],
                        )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(news.title?.trim() ?? '',
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey[100],
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          )),
                      if (news.description != null)
                        Text(
                          news.description!.trim(),
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey[400],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
