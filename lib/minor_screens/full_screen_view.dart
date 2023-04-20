import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/app_bar_widget.dart';

class FullScreenView extends StatefulWidget {
  final List<dynamic> imagesList;
  const FullScreenView({Key? key, required this.imagesList}) : super(key: key);

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  final PageController _controller = PageController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Text(
                ('${index + 1}') + ('/') + ('${widget.imagesList.length}'),
                style: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 8,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.50,
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    index = value;  
                  });
                },
                controller: _controller,
                children: images(),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
              child: imageView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.imagesList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _controller.jumpToPage(index);
          },
          child: Container(
            width: 120,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.yellow,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.imagesList[index].toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> images() {
    return List.generate(widget.imagesList.length, (index) {
      return InteractiveViewer(
        transformationController: TransformationController(),
        child: Image.network(
          widget.imagesList[index].toString(),
        ),
      );
    });
  }
}
