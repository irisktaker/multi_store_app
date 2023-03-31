import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screens/sub_category_product.dart';

class SliderBar extends StatelessWidget {
  final String mainCateName;
  const SliderBar({
    Key? key,
    required this.mainCateName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.78,
      width: MediaQuery.of(context).size.width * 0.05,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.brown.withOpacity(
              0.20,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: RotatedBox(
            quarterTurns: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                mainCateName.toLowerCase() == 'beauty'
                    ? const Text('')
                    : const Text(
                        '<<',
                        style: style,
                      ),
                Text(
                  mainCateName.toUpperCase(),
                  style: style,
                ),
                mainCateName.toLowerCase() == 'men'
                    ? const Text('')
                    : const Text(
                        '>>',
                        style: style,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const style = TextStyle(
  color: Colors.brown,
  fontSize: 16,
  fontWeight: FontWeight.w600,
  letterSpacing: 10,
);

class SubCategoryModel extends StatelessWidget {
  final String mainCateName;
  final String subCateName;
  final String assetName;
  final String mainCateLabel;
  const SubCategoryModel({
    Key? key,
    required this.mainCateName,
    required this.subCateName,
    required this.assetName,
    required this.mainCateLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategoryProducts(
              mainCateName: mainCateName,
              subCateName: subCateName,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: Image(
              image: AssetImage(
                assetName,
              ),
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            mainCateLabel,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}

class CategoryHeaderWidget extends StatelessWidget {
  final String headerLabel;
  const CategoryHeaderWidget({
    Key? key,
    required this.headerLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 35,
      ),
      child: Text(
        headerLabel,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
