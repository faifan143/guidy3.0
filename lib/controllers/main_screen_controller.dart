import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guidy/core/classes/FilterType.dart';
import 'package:guidy/core/classes/firebase_api.dart';
import 'package:guidy/core/functions/signupSuccessful.dart';
import 'package:guidy/model/evaluate_model.dart';
import 'package:guidy/model/shop_model.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guidy/core/constants/AppConnection.dart';
import 'package:guidy/core/constants/AppRoutes.dart';
import 'package:guidy/core/constants/appTheme.dart';
import 'package:guidy/core/services/sharedPreferences.dart';
import 'package:guidy/model/user_model.dart';
import 'package:guidy/view/screens/main-screens/followings.dart';
import 'package:guidy/view/screens/main-screens/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/follow_model.dart';
import '../model/offer_model.dart';
import '../view/screens/main-screens/main_categories.dart';
import '../view/screens/main-screens/profile.dart';

class MainScreenController extends GetxController {
  int currentPage = 0;

  changePage(int index) {
    currentPage = index;
    update();
  }

  bool pickedImageLoading = false;

  bool hasNotification = false;

  bool loadingHomeScreen = true;

  MyServices myServices = Get.find();

  UserModel? myUser;
   bool isAdmin = false;

  changeImageLoadingState() {
    pickedImageLoading = !pickedImageLoading;
    update();
  }

  void removePostImage() {
    postImage = null;
    postImageLink = '';
    update();
  }

  String searchText = "";

  void changeSearchText(String query) {
    searchText = query;
    update();
  }

  bool isPassword = true;

  changePassState() {
    isPassword = !isPassword;
    update();
  }

  String? selectedValue;

  selectedOption(String option) {
    selectedValue = option;
    if (option == 'edit') update();
  }

  String categoriesScreenSelectedCategory = "";

  selectCategoryScreen(String category) {
    categoriesScreenSelectedCategory = category;
    Get.toNamed(AppRoutes.categoriesJoker);
    update();
  }

  TextEditingController mySearch = TextEditingController();

  TextEditingController textCtrl = TextEditingController();

  TextEditingController feedbackCtrl = TextEditingController();

  List<Widget> carouselItems = [];

  List<Widget> screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    Container(),
    const FollowingScreen(),
    const ProfileScreen(),
  ];

  List<String> requestTags = [];

  String mergeTags(List<dynamic> Tags) {
    String result = "";
    for (String string in Tags) {
      result = result + "#$string";
    }
    return result;
  }

  List<Text> stringsToTexts(List<dynamic> strings) {
    List<Text> texts = [];
    for (String string in strings) {
      texts.add(
        Text(
          string,
          style: englishTheme.textTheme.headline1!.copyWith(
              color: CupertinoColors.white,
              fontWeight: FontWeight.w300,
              fontSize: 18),
        ),
      );
    }
    return texts;
  }

  // /////////////////////////////////////////////////////////////////

  File? postImage;
  String? postImageLink;
  var postImagePicker = ImagePicker();

  Future<void> getPostImage() async {
    final pickedFile =
        await postImagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      if (postImage != null) {}
      update();
    } else {
      pickedImageLoading = false;
      if (pickedImageLoading == false) update();
    }
  }

  Uint8List? myProfilePic;

  Future<Uint8List?> loadPicture(String filename) async {
    const String serverAddress =
        'http://${AppConnection.url}:${AppConnection.port}/assets';
    try {
      final response = await http.get(Uri.parse('$serverAddress/$filename'));
      if (response.statusCode == 200) {
        return response.bodyBytes; // Return the image bytes
      } else {
        print('Failed to download image: ${response.statusCode}');
        return null; // Return null if download fails
      }
    } catch (error) {
      print('Error downloading image: $error');
      return null; // Return null if download fails
    }
  }

  void initializeUser() {
    final jsonString = myServices.sharedPref.getString('user_model');
    if (jsonString != null) {
      try {
        final Map<String, dynamic> userData = json.decode(jsonString);
        if (isAdmin) {
          myUser = UserModel(
            email: userData['ad_email'].toString(),
            username: userData['ad_name'].toString(),
            phone: userData['ad_phone'].toString(),
            image: userData['ad_picture'].toString(),
            address: "",
            latitude: "",
            longitude: "",
          );
        } else {
          myUser = UserModel.fromJson(userData);
        }
      } catch (e) {
        print('Error parsing JSON data: $e');
      }
    } else {
      print('No user data found in SharedPreferences.');
    }
  }

  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  void updateBackendCords(double latitude, double longitude) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/user/update_cords');
    final response = await http.post(uri, body: {
      'email': myUser!.email,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    }, headers: {
      "Authorization": myServices.sharedPref.getString("token")!,
    });

    if (response.statusCode == 200) {
    } else {
      // Handle error
    }
  }

  void updateLocation(double lat, double long) {
    latitude.value = lat;
    longitude.value = long;

    updateBackendCords(latitude.value, longitude.value);
  }

  Future<void> getLocationUpdates() async {
    Geolocator.getPositionStream(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.best))
        .listen((Position position) {
      updateLocation(position.latitude, position.longitude);
    });
  }

  void addMainCat(BuildContext context, String mainName) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/admin/add_main_category');
    var response = await http.post(
      uri,
      body: {'main_category': mainName},
      headers: {"Authorization": myServices.sharedPref.getString("token")!},
    );
    if (response.statusCode == 200) {
      snackBar(
          context: context,
          contentType: ContentType.success,
          title: "Done . . .",
          body: "Main Category Added");
      getCategories();
      Navigator.pop(context);
    } else {
      snackBar(
          context: context,
          contentType: ContentType.warning,
          title: "Oops . . .",
          body: "Main Category Add Failed");
    }
  }

  String? selectedMainForSubAdd;

  void addSubcat(BuildContext context, String subName) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/admin/add_subcategory');
    var response = await http.post(
      uri,
      body: {'main_category': selectedMainForSubAdd, 'sub_name': subName},
      headers: {"Authorization": myServices.sharedPref.getString("token")!},
    );
    if (response.statusCode == 200) {
      snackBar(
          context: context,
          contentType: ContentType.success,
          title: "Done . . .",
          body: "Subcategory Added");
      getCategories();
      Navigator.pop(context);
    } else {
      snackBar(
          context: context,
          contentType: ContentType.warning,
          title: "Oops . . .",
          body: "Subcategory Add Failed");
    }
  }

  List<File> selectedPhotosForShopAdd = [];
  Map shopData = {
    "shop_name": "",
    "shop_phone": "",
    "shop_address": "",
    "lat": "",
    "long": "",
    "shop_rating": "",
    "subcategories": []
  };

  Future<bool> addShop(BuildContext context) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/admin/add_shop');

    var request = http.MultipartRequest('POST', uri);

    request.fields['shop_name'] = shopData['shop_name'];
    request.fields['shop_phone'] = shopData['shop_phone'];
    request.fields['shop_address'] = shopData['shop_address'];
    request.fields['lat'] = shopData['lat'].toString();
    request.fields['long'] = shopData['long'].toString();
    request.fields['rating'] = shopData['shop_rating'].toString();
    request.fields['subcategories'] = shopData['subcategories'].join(',');

    for (int i = 0; i < selectedPhotosForShopAdd.length; i++) {
      request.files.add(
        await http.MultipartFile.fromPath(
            'photos', selectedPhotosForShopAdd[i].path),
      );
    }

    request.headers['Authorization'] =
        myServices.sharedPref.getString('token')!;

    try {
      final streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        print('Shop added successfully.');
        sendNotification(
            context: context,
            title: "New Shop",
            body:
                "${shopData['shop_name']} opened in ${shopData['shop_address']} ",
            data: {});
        return true;
      } else {
        print(
            'Failed to add shop. Status code: ${streamedResponse.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error adding shop: $e');
      return false;
    }
  }

  Map<String, String> mainCategories = {};
  Map<String, String> subcategories = {};
  Map<String, List<dynamic>> formattedCategories = {};

  void getCategories() async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/user/get_categories');
    var response = await http.get(
      uri,
      headers: {"Authorization": myServices.sharedPref.getString("token")!},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      Map<String, List<dynamic>> categoriesMap = {};

      for (var row in responseData['proccessedRows']) {
        String mainId = row['main'].toString().split('-')[1];
        String mainName = row['main'].toString().split('-')[0];
        String subId = row['sub'].toString().split('-')[1];
        String subName = row['sub'].toString().split('-')[0];
        if (!mainCategories.containsValue(mainName)) {
          mainCategories[mainId] = mainName;
        }
        if (!subcategories.containsValue(subName) && subName!='null') {
          subcategories[subId] = subName;
        }

        if (!categoriesMap.containsKey(mainName)) {
          categoriesMap[mainName] = [];
        }
        categoriesMap[mainName]!.add(subName);
      }
      formattedCategories = categoriesMap;
    }
  }

  Set<String> shopPhonePairs = Set();
  Map<String, dynamic> subShopsMap = {};

  bool isShopIdInShopsList(String shopId, List<ShopModel> shopsList) {
    for (var shop in shopsList) {
      if (shop.shop_id == shopId) {
        return true;
      }
    }
    return false;
  }

  Future<List<EvaluateModel>> getEvaluations(String shopId) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/user/get_evaluations');
    final response = await http.post(
      uri,
      body: {"shop_id": shopId},
      headers: {"Authorization": myServices.sharedPref.getString("token")!},
    );
    List<EvaluateModel> evaluationsList = [];

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> rows = responseData['rows'];
      print(responseData);
      rows.forEach((evaluation) {
        evaluationsList.add(EvaluateModel.fromJson(evaluation));
      });
    } else {
      print("Failed fetching the evaluations ${response.statusCode}");
    }
    return evaluationsList;
  }

  Future<List<ShopModel>> getShopPhonePairs() async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/user/get_shops');
    final response = await http.get(
      uri,
      headers: {"Authorization": myServices.sharedPref.getString("token")!},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      List<ShopModel> shopsList = [];
      // Extract shops data from the response
      final Map<String, dynamic> shopsData = responseData['shops'];
      subShopsMap = shopsData;
      // Initialize subShopsMap lists
      shopsData.forEach((subcategory, shops) {
        subShopsMap.putIfAbsent(subcategory, () => []);
      });

      // Populate shopPhonePairs and subShopsMap
      shopsData.forEach((subcategory, shops) {
        for (final shop in shops) {
          final shopName = shop['shop_name'];
          final shopPhone = shop['shop_phone'].toString();

          shopPhonePairs.add("$shopName - $shopPhone");

          ShopModel shopModel = ShopModel.fromJson(shop);

          if (!isShopIdInShopsList(shopModel.shop_id, shopsList)) {
            shopsList.add(shopModel);
          }
        }
      });
      return shopsList;
    } else {
      throw Exception('Failed to get shop data: ${response.statusCode}');
    }
  }

  List<File> selectedPhotosForOfferAdd = [];
  Map offerData = {
    "shop_name": "",
    "shop_phone": "",
    "start_date": "",
    "offer_name": "",
    "description": "",
    "expiration_date": "",
  };

  Future<bool> addOffer(BuildContext context) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/admin/add_offer');
    var request = http.MultipartRequest('POST', uri);
    request.fields['offer_name'] = offerData['offer_name'];
    request.fields['shop_name'] = offerData['shop_name'];
    request.fields['shop_phone'] = offerData['shop_phone'];
    request.fields['description'] = offerData['description'];
    request.fields['start_date'] = offerData['start_date'].toString();
    request.fields['expiration_date'] = offerData['expiration_date'].toString();
    for (int i = 0; i < selectedPhotosForOfferAdd.length; i++) {
      request.files.add(
        await http.MultipartFile.fromPath(
            'photos', selectedPhotosForOfferAdd[i].path),
      );
    }
    request.headers['Authorization'] =
        myServices.sharedPref.getString('token')!;
    try {
      final streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        print('Shop added successfully.');
        sendNotification(
            context: context,
            title: "New Offer",
            body:
                "${offerData['shop_name']} made a new offer :\n ${offerData['offer_name']}",
            data: {});
        await onInit();
        update();
        return true;
      } else {
        print(
            'Failed to add shop. Status code: ${streamedResponse.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error adding offer: $e');
      return false;
    }
  }

  Future<bool> addFollow(
      {required BuildContext context, required String shopId}) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/user/add_follow');

    var response = await http.post(
      uri,
      body: {
        'cust_email': myUser!.email,
        'shop_id': shopId,
      },
      headers: {"Authorization": myServices.sharedPref.getString("token")!},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['state'] == "success") {
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception('Failed : ${response.statusCode}');
    }
  }

  List<ShopModel> followings = [];

  bool isShopIdInFollowings(String shopId) {
    for (var shop in followings) {
      if (shop.shop_id == shopId) {
        return true;
      }
    }
    return false;
  }

  Future<void> fetchFollowings() async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/user/get_following');

    var response = await http.post(
      uri,
      body: {
        'cust_email': myUser!.email,
      },
      headers: {"Authorization": myServices.sharedPref.getString("token")!},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['state'] == "success") {
        if (responseData.containsKey('shops')) {
          List<dynamic> shops = responseData['shops'];
          late ShopModel shopModel;
          shops.map((shop) => {
                shopModel = ShopModel.fromJson(shop),
                if (!isShopIdInFollowings(shopModel.shop_id))
                  {
                    followings.add(shopModel),
                  }
              });
        }
      }
      update();
    } else {
      print('Failed: ${response.statusCode} No Followings Found');
    }
  }

  Future<bool> addFavorite(
      {required BuildContext context, required String offerId}) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/user/add_favorite');

    var response = await http.post(
      uri,
      body: {
        'cust_email': myUser!.email,
        'offer_id': offerId,
      },
      headers: {"Authorization": myServices.sharedPref.getString("token")!},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['state'] == "success") {
        return true;
      } else {
        return false;
      }
    } else {
      print('Failed: ${response.statusCode}');
      return false;
    }
  }

  List<MapEntry<OfferModel, ShopModel>> favorites = [];

  bool isOfferIdInFavorites(String offerId) {
    for (var entry in favorites) {
      if (entry.key.offerId == offerId) {
        return true;
      }
    }
    return false;
  }

  Future<void> fetchFavorite() async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/user/get_favorites');

    var response = await http.post(
      uri,
      body: {
        'cust_email': myUser!.email,
      },
      headers: {"Authorization": myServices.sharedPref.getString("token")!},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['state'] == "success") {
        List<dynamic> offers = responseData['offers'];
        for (var offer in offers) {
          ShopModel shopModel = ShopModel.fromJson(offer['offer_shop']);
          OfferModel offerModel = OfferModel.fromJson(offer['offer_data']);
          if (!isOfferIdInFavorites(offerModel.offerId)) {
            favorites.add(MapEntry(offerModel, shopModel));
          }
        }
      }
      update();
    } else {
      print('Failed: ${response.statusCode} No Favorites Found');
    }
  }

  Future<List<OfferModel>> getShopOffers(
      {required String shopId, required String token}) async {
    final url = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/user/get_offers');
    final response = await http.post(
      url,
      body: {'shop_id': shopId},
      headers: {"Authorization": token},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> offersData = jsonData['offers'];
      return offersData
          .map((offerData) => OfferModel.fromJson(offerData))
          .toList();
    } else {
      throw Exception('Failed to load offers');
    }
  }

  ShopModel? recently_Searched;
  ShopModel? recently_Evaluated;

  Future<void> evaluateShop(
      {required BuildContext context,
      required ShopModel shopModel,
      required String pricesFB,
      required String productsFB,
      required String serviceFB,
      required String overall,
      required String priceRating,

      }) async {
    print(myUser!.email);
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/user/evaluate_shop');

    var response = await http.post(
      uri,
      body: {
        'cust_email': myUser!.email.trim(),
        'shop_id': shopModel.shop_id,
        'prices_feedback': pricesFB,
        'products_quality_feedback': productsFB,
        'service_quality_feedback': serviceFB,
        'overall_rating': overall,
        'price_rating': priceRating,
        'old_rating': shopModel.shop_rating

      },
      headers: {"Authorization": myServices.sharedPref.getString("token")!},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['state'] == "success") {
        snackBar(
            context: context,
            contentType: ContentType.success,
            title: 'Done ...',
            body: 'Shop Evaluated');
        recently_Evaluated = shopModel;
        myServices.sharedPref
            .setString("recently_evaluated", jsonEncode(shopModel.toJson()));
        update();
      } else {
        snackBar(
            context: context,
            contentType: ContentType.failure,
            title: 'Oops ...',
            body: 'Shop Evaluation Failed');
      }
    } else {
      throw Exception('Failed: ${response.statusCode}');
    }
  }

  Future<void> updateMainCategory(
      {required BuildContext context,
      required String mainId,
      required String mainName}) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/admin/update_main_category');

    try {
      final response = await http.post(
        uri,
        body: {'main_id': mainId, 'main_name': mainName},
        headers: {"Authorization": myServices.sharedPref.getString("token")!},
      );

      if (response.statusCode == 200) {
        print('Main category updated successfully');
        Navigator.pop(context);
        await onInit();
        update();
      } else if (response.statusCode == 404) {
        print('Main category not found');
      } else {
        throw Exception("Failed : ${response.statusCode}");
      }
    } catch (error) {
      print('Error updating main category: $error');
    }
  }

  Future<void> updateSubcategory(
      {required BuildContext context,
      required String subId,
      required String subName}) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/admin/update_subcategory');

    try {
      final response = await http.post(
        uri,
        body: {'sub_id': subId, 'sub_name': subName},
        headers: {"Authorization": myServices.sharedPref.getString("token")!},
      );

      if (response.statusCode == 200) {
        print('Subcategory updated successfully');
        Navigator.pop(context);
        await onInit();
        update();
      } else if (response.statusCode == 404) {
        print('Subcategory not found');
      } else {
        throw Exception('Failed to update subcategory');
      }
    } catch (error) {
      print('Error updating subcategory: $error');
    }
  }

  Future<bool> updateShop(
      {required String shopId,
      required String shopName,
      required String shopPhone,
      required String shopAddress,
      required String lat,
      required String long}) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/admin/update_shop');

    try {
      final response = await http.post(
        uri,
        body: {
          'shop_id': shopId,
          'shop_name': shopName,
          'shop_phone': shopPhone,
          'shop_address': shopAddress,
          'lat': lat,
          'long': long,
        },
        headers: {"Authorization": myServices.sharedPref.getString("token")!},
      );

      if (response.statusCode == 200) {
        print('Shop updated successfully');
        await onInit();
        update();
        return true;
      } else if (response.statusCode == 404) {
        print('Shop not found');
        return false;
      } else {
        return false;
      }
    } catch (error) {
      print('Error updating shop: $error');
      return false;
    }
  }

  Future<bool> updateOffer(
      {required String offerId,
      required String offerName,
      required String description,
      required String expirationDate}) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/admin/update_offer');

    try {
      final response = await http.post(
        uri,
        body: {
          'offer_id': offerId,
          'offer_name': offerName,
          'description': description,
          'expiration_date': expirationDate,
        },
        headers: {"Authorization": myServices.sharedPref.getString("token")!},
      );

      if (response.statusCode == 200) {
        print('Offer updated successfully');
        await onInit();
        update();
        return true;
      } else if (response.statusCode == 404) {
        print('Offer not found');
        return false;
      } else {
        return false;
      }
    } catch (error) {
      print('Error updating offer: $error');
      return false;
    }
  }

  Future<void> deleteMain(
      {required BuildContext context, required String mainId}) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/admin/delete_main');

    try {
      final response = await http.delete(
        uri,
        body: {'main_id': mainId},
        headers: {"Authorization": myServices.sharedPref.getString("token")!},
      );

      if (response.statusCode == 200) {
        print('Main category deleted successfully');
        Navigator.pop(context);
        await onInit();
        update();
      } else if (response.statusCode == 404) {
        print('Main category not found');
      } else {
        throw Exception("Failed : ${response.statusCode}");
      }
    } catch (error) {
      print('Error deleting main category: $error');
    }
  }

  Future<void> deleteSub(
      {required BuildContext context, required String subId}) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/admin/delete_sub');

    try {
      final response = await http.delete(
        uri,
        body: {'sub_id': subId},
        headers: {"Authorization": myServices.sharedPref.getString("token")!},
      );

      if (response.statusCode == 200) {
        print('Sub category deleted successfully');
        Navigator.pop(context);
        await onInit();
        update();
      } else if (response.statusCode == 404) {
        print('Sub category not found');
      } else {
        throw Exception("Failed : ${response.statusCode}");
      }
    } catch (error) {
      print('Error deleting sub category: $error');
    }
  }

  Future<void> deleteShop(
      {required BuildContext context, required String shopId}) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/admin/delete_shop');

    try {
      final response = await http.delete(
        uri,
        body: {'shop_id': shopId},
        headers: {"Authorization": myServices.sharedPref.getString("token")!},
      );

      if (response.statusCode == 200) {
        print('shop deleted successfully');
        Navigator.pop(context);
        await onInit();
        update();
      } else if (response.statusCode == 404) {
        print('shop not found');
      } else {
        throw Exception("Failed : ${response.statusCode}");
      }
    } catch (error) {
      print('Error deleting shop category: $error');
    }
  }

  Future<void> deleteOffer(
      {required BuildContext context, required String offerId}) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/admin/delete_offer');

    try {
      final response = await http.delete(
        uri,
        body: {'offer_id': offerId},
        headers: {"Authorization": myServices.sharedPref.getString("token")!},
      );

      if (response.statusCode == 200) {
        print('offer deleted successfully');
        Navigator.pop(context);
        await onInit();
        update();
      } else if (response.statusCode == 404) {
        print('offer not found');
      } else {
        throw Exception("Failed : ${response.statusCode}");
      }
    } catch (error) {
      print('Error deleting offer category: $error');
    }
  }

  var loading = false.obs;
  var error = ''.obs;
  List<ShopModel> shops = [];

  Future<void> searchShops(
      {required BuildContext context, required String searchText}) async {
    final Uri uri = Uri.parse(
        'http://${AppConnection.url}:${AppConnection.port}/user/search');

    try {
      loading.value = true;
      error.value = '';
      final response = await http.post(
        uri,
        body: {'search_text': searchText},
        headers: {"Authorization": myServices.sharedPref.getString("token")!},
      );
      var responseData = jsonDecode(response.body);
      print(responseData);
      List<ShopModel> shopsModel = [];
      if (response.statusCode == 200) {
        if (responseData['state'] == "success") {
          List<dynamic> shopsJson = responseData['shops'];
          shopsJson.forEach((shopJson) {
            shopsModel.add(ShopModel.fromJson(shopJson));
          });
        }
        shops = shopsModel;
        recently_Searched = shopsModel[0];
        myServices.sharedPref.setString(
            "recently_searched", jsonEncode(recently_Searched!.toJson()));
      } else if (response.statusCode == 404) {
        print('Shop not found');
      } else {
        throw Exception("Failed : ${response.statusCode}");
      }
      loading.value = false;
    } catch (error) {
      loading.value = false;
      this.error.value = 'Error searching for shops: $error';
    }
  }

  FilterType filteringMode = FilterType.DEFAULT;

  void changeFilterMode(String mode) {
    filteringMode = mode == "Nearest"
        ? FilterType.NEAR
        : mode == "Highly Rated"
            ? FilterType.RATE
            : mode == "Cheapest"
                ? FilterType.CHEAP
                : FilterType.DEFAULT;
    update();
  }

  Future<List<ShopModel>> fetchNearestShops() async {
    final response = await http.get(
      Uri.parse(
          'http://${AppConnection.url}:${AppConnection.port}/user/nearest-shops?latitude=${latitude.value}&longitude=${longitude.value}'),
      headers: <String, String>{
        "Authorization": myServices.sharedPref.getString("token")!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['shops'];

      if (responseData.isNotEmpty) {
        return responseData.map((data) => ShopModel.fromJson(data)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load shops');
    }
  }

  Future<List<ShopModel>> fetchCheapestShops() async {
    final response = await http.get(
      Uri.parse(
          'http://${AppConnection.url}:${AppConnection.port}/user/pricly-rated-shops'),
      headers: <String, String>{
        "Authorization": myServices.sharedPref.getString("token")!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['shops'];

      if (responseData.isNotEmpty) {
        return responseData.map((data) => ShopModel.fromJson(data)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load shops');
    }
  }

  Future<List<ShopModel>> fetchShopsByOverallRating() async {
    final response = await http.get(
      Uri.parse('http://${AppConnection.url}:${AppConnection.port}/user/highly-rated-shops'),
      headers: <String, String>{
        "Authorization":  myServices.sharedPref.getString("token")!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['shops'];

      if (responseData.isNotEmpty) {
        return responseData.map((data) => ShopModel.fromJson(data)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load shops');
    }
  }

  Future<List<ShopModel>> fetchFutureFollowings() async {
    final response = await http.post(
      Uri.parse('http://${AppConnection.url}:${AppConnection.port}/user/get_following'),
      headers: <String, String>{
        "Authorization": myServices.sharedPref.getString("token")!,
      },
      body: {
        'cust_email': myUser!.email,
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['shops'];

      if (responseData.isNotEmpty) {
          followings =responseData.map((data) => ShopModel.fromJson(data)).toList();
        return followings;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load followings');
    }
  }

  Future<List<OfferModel>> fetchFavorites() async {
    final response = await http.post(
      Uri.parse('http://${AppConnection.url}:${AppConnection.port}/user/get_favorites'),
      headers: <String, String>{
        "Authorization": myServices.sharedPref.getString("token")!,
      },
      body: {'cust_email': myUser!.email},
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['offers'];
      if (responseData.isNotEmpty) {
        return responseData.map((data) => OfferModel.fromJson(data['offer_data'])).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load favorites');
    }
  }



  @override
  Future<void> onInit() async {
    super.onInit();
      await FirebaseMessaging.instance.subscribeToTopic("all");

    myServices.sharedPref.setString("logged", "1");
    isAdmin = myServices.sharedPref.getString("isAdmin") == "true";
    initializeUser();
    myProfilePic = await loadPicture(myUser!.image);
    await Permission.location.request();
    getCategories();
    await getShopPhonePairs();
    if (!isAdmin) {
      String? recentlyEvaluatedString =
          myServices.sharedPref.getString("recently_evaluated");
      String? recentlySearchedString =
          myServices.sharedPref.getString("recently_searched");
      if (recentlyEvaluatedString != null &&
          recentlyEvaluatedString.isNotEmpty &&
          recentlySearchedString != null &&
          recentlySearchedString.isNotEmpty) {
        try {
          recently_Evaluated =
              ShopModel.fromJson(jsonDecode(recentlyEvaluatedString));
          recently_Searched =
              ShopModel.fromJson(jsonDecode(recentlySearchedString));
        } catch (e) {
          print('Error parsing recently_evaluated JSON: $e');
        }
      } else {
        print('recently_evaluated is null or empty');
        recently_Evaluated = null;
        recently_Searched = null;
      }

      getLocationUpdates();
      await fetchFavorite();
      await fetchFutureFollowings();
    }
  }
}
