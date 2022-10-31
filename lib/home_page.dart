import 'package:flutter/material.dart';
import 'package:rest_api_app/details_page.dart';
import 'package:rest_api_app/users_pets.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // For holding response as UserPets
  late UsersPets usersPets;
  // for data is loaded flag
  bool isDataLoaded = false;
  // error holding
  String errorMessage = '';

  // API Call
  Future<UsersPets> getDataFromAPI() async {
    Uri uri = Uri.parse(
        'https://jatinderji.github.io/users_pets_api/users_pets.json');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      // All ok
      UsersPets usersPets = usersPetsFromJson(response.body);
      setState(() {
        isDataLoaded = true;
      });
      return usersPets;
    } else {
      errorMessage = '${response.statusCode}: ${response.body} ';
      return UsersPets(data: []);
    }
  }

  callAPIandAssignData() async {
    usersPets = await getDataFromAPI();
  }

  @override
  void initState() {
    callAPIandAssignData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rest API Call'),
        centerTitle: true,
      ),
      body: isDataLoaded
          ? errorMessage.isNotEmpty
              ? Text(errorMessage)
              : usersPets.data.isEmpty
                  ? const Text('No Data')
                  : ListView.builder(
                      itemCount: usersPets.data.length,
                      itemBuilder: (context, index) => getRow(index),
                    )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget getRow(int index) {
    return Card(
      child: ListTile(
        onTap: () {
          // Navigate to Next Details
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailsPage(userPet: usersPets.data[index]),
              ));
        },
        leading: CircleAvatar(
          radius: 21,
          backgroundColor:
              usersPets.data[index].isFriendly ? Colors.green : Colors.red,
          child: CircleAvatar(
            radius: 20,
            backgroundColor:
                usersPets.data[index].isFriendly ? Colors.green : Colors.red,
            backgroundImage: NetworkImage(usersPets.data[index].petImage),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              usersPets.data[index].userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Dog: ${usersPets.data[index].userName}'),
          ],
        ),
        trailing: Icon(
          usersPets.data[index].isFriendly ? Icons.pets : Icons.do_not_touch,
          color: usersPets.data[index].isFriendly ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
