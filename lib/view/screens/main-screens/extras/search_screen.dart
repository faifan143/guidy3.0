import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/main_screen_controller.dart';
import 'package:guidy/view/widgets/reusable_form_field.dart';
import 'package:iconly/iconly.dart';

import '../../../../model/shop_model.dart';
import '../../../widgets/custom_shop.dart';

class SearchScreen extends GetView<MainScreenController> {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    Get.put(MainScreenController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            controller.myServices.sharedPref.getString("lang") == "en"
                ? IconlyBroken.arrow_left
                : IconlyBroken.arrow_right,
            color: Colors.blue[900],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Text(
              "Search".tr,
              style: TextStyle(color: Colors.blue[900]),
            ),
            SizedBox(width: 15.w),
            Icon(
              IconlyBroken.search,
              color: Colors.blue[900],
            )
          ],
        ),
      ),
      body: SafeArea(
        child: GetBuilder<MainScreenController>(builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 5.h,),
                  ReusableFormField(
                    controller: searchController,
                    hint: "name , address , phone , rating".tr,
                    icon: const Icon(IconlyBroken.search),
                    isPassword: false,
                    label: "Search".tr,
                    checkValidate: (String) {},
                    onTyping: (query) {
                      controller.searchShops(
                        context: context,
                        searchText: query.trim(),
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  Obx(() {
                    if (controller.loading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (controller.error.isNotEmpty) {
                      return Center(
                        child: Text('Error: ${controller.error}'),
                      );
                    } else {
                      final List<ShopModel> shops = controller.shops;
                      return shops.isNotEmpty
                          ? SizedBox(
                        height: 680.h,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: shops.length,
                          itemBuilder: (BuildContext context, int index) {
                            ShopModel shopModel = shops[index];
                            return SizedBox(
                              width: 340.w,
                              child: CustomShopWidget(
                                shopModel: shopModel,
                                isProfile: false,
                              ),
                            );
                          },
                        ),
                      )
                          : SizedBox(
                        height: 300.h,
                        child: Center(
                          child: Text(
                            "No Shops Available".tr,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                      );
                    }
                  }),
                  SizedBox(
                    height: 200.h,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
