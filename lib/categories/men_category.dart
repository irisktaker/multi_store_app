import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screens/sub_category_product.dart';
import 'package:multi_store_app/utilities/categories_list.dart';

class MenCategory extends StatelessWidget {
  const MenCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 35,
          ),
          child: Text(
            'Men',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 40,
            crossAxisSpacing: 10,
            physics: const BouncingScrollPhysics(),
            children: List.generate(
              men.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubCategoryProducts(
                          mainCateName: 'men',
                          subCateName: men[index],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Image(
                          image: AssetImage(
                            'images/men/men$index.jpg',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(men[index])
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
