import 'package:flutter/material.dart';
import 'package:multi_store_app/utilities/categories_list.dart';
import 'package:multi_store_app/widgets/category_widget.dart';

class WomenCategory extends StatelessWidget {
  const WomenCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.78,
              width: MediaQuery.of(context).size.width * 0.70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CategoryHeaderWidget(headerLabel: 'Women'),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 40,
                      crossAxisSpacing: 10,
                      physics: const BouncingScrollPhysics(),
                      children: List.generate(
                        women.length - 1,
                        (index) {
                          return SubCategoryModel(
                            mainCateName: 'women',
                            subCateName: women[index + 1],
                            assetName: 'images/women/women$index.jpg',
                            mainCateLabel: women[index + 1],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: SliderBar(mainCateName: 'women'),
          )
        ],
      ),
    );
  }
}
