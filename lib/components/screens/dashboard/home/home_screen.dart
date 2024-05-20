import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmit_practical/app/constants/color_constant.dart';
import 'package:gmit_practical/app/constants/string_constants.dart';
import 'package:gmit_practical/app/constants/text_style_constants.dart';
import 'package:gmit_practical/app/model/dashboard/product_list_resp_model.dart';
import 'package:gmit_practical/app/utils/debouncer.dart';
import 'package:gmit_practical/app/utils/route_util.dart';
import 'package:gmit_practical/app/utils/shared_pref_util.dart';
import 'package:gmit_practical/components/screens/dashboard/home/bloc/home_bloc.dart';
import 'package:gmit_practical/components/screens/dashboard/home/bloc/repository/home_repo.dart';
import 'package:gmit_practical/components/widgets/custom_text_field.dart';
import 'package:gmit_practical/components/widgets/custom_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc homeBloc = HomeBloc();
  SharedPrefUtil? sharedPrefUtil;
  String? userProfile, userName;

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  final Debouncer _deBouncer =
      Debouncer(delay: const Duration(milliseconds: 500));

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    homeBloc = context.read<HomeBloc>();
    sharedPrefUtil = SharedPrefUtil();
    userName = sharedPrefUtil!.getString(SharedPrefUtil.keyUserName);
    userProfile = sharedPrefUtil!.getString(SharedPrefUtil.keyUserProfile);
    homeBloc.add(const ProductListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.primaryColor,
          leading: CustomWidgets.getUserProfile(profileUrl: userProfile ?? ""),
          title: Text(
            userName ?? "",
            style: CustomTextStyle.getBoldText(
                textSize: 20, textColor: ColorConstants.whiteColor),
          ),
          actions: [
            InkWell(
              onTap: _userLogout,
              child: const Padding(
                padding: EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.logout,
                  color: ColorConstants.whiteColor,
                ),
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            homeBloc.add(const ProductListEvent());
          },
          color: ColorConstants.primaryColor,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              CustomWidgets.getSearchBar(context,
                  searchController: searchController,
                  searchFocus: searchFocus,
                  onChange: (){
                    _updateData();
                  }),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          if ((state.dataLoading ?? false)) {
                            return CustomWidgets.getCenterLoading();
                          }

                          if ((state.products ?? []).isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.products!.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return getProductCard(state.products![index]);
                              },
                            );
                          }

                          return CustomWidgets.noDataFound();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getProductCard(Product product) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ).copyWith(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.thumbnail ?? "",
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: ColorConstants.hintColor.withOpacity(0.07),
                    height: 150,
                    width: double.infinity,
                    child: const Icon(Icons.image),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.title ?? "",
              style: CustomTextStyle.getBoldText(textSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              product.description ?? "",
              style: CustomTextStyle.getRegularText(
                textSize: 15,
                textColor: ColorConstants.blackColor.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '\$${product.price}',
                  style: CustomTextStyle.getBoldText(
                    textSize: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${product.discountPercentage}% off',
                  style: CustomTextStyle.getRegularText(
                      textSize: 16, textColor: ColorConstants.greenColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star,
                    color: ColorConstants.yellowColor, size: 20),
                const SizedBox(width: 5),
                Text(
                  product.rating.toString(),
                  style: CustomTextStyle.getRegularText(
                    textSize: 16,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  '${StringConstants.stock}: ${product.stock}',
                  style: CustomTextStyle.getRegularText(
                    textSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${StringConstants.brand}: ${product.brand}',
              style: CustomTextStyle.getRegularText(
                textSize: 16,
              ),
            ),
            Text(
              '${StringConstants.category}: ${product.category}',
              style: CustomTextStyle.getRegularText(
                textSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateData() {
    _deBouncer.debounce(() async {
      HomeRepository.cancelToken.cancel();
      await Future.delayed(const Duration(milliseconds: 300));
      HomeRepository.cancelToken = CancelToken();
      homeBloc.add(
          ProductSearchListEvent(searchText: searchController.text.trim()));
    });
  }

  void _userLogout() {
    CustomWidgets.showLogoutDialog(context, actionCallBack: (value) {
      if (value) {
        (sharedPrefUtil ?? SharedPrefUtil()).clearPreference();
        RouteUtil.visitLoginPage(context);
      }
    });
  }
}
