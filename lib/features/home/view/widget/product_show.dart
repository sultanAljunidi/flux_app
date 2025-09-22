part of '../home_view.dart';

class _ProductShow extends StatefulWidget {
  const _ProductShow();

  @override
  State<_ProductShow> createState() => _ProductShowState();
}

class _ProductShowState extends State<_ProductShow> {
  final PageController controller = PageController();
  late Timer timer;
  int _selectedPromo = 0;
  bool _isLoading = true;
  final List<String> images = [
    AppImages.women1,
    AppImages.women2,
    AppImages.women3,
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_selectedPromo < images.length - 1) {
        _selectedPromo++;
      } else {
        _selectedPromo = 0;
      }
      if (controller.positions.isNotEmpty) {
        controller.animateToPage(
          _selectedPromo,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175,
      child: _isLoading
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3, // عدد الكروت الوهمية
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: MediaQuery.of(context).size.width - 32,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              },
            )
          : Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView.builder(
                  controller: controller,
                  itemCount: images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedPromo = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            Image.asset(
                              images[index],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 20,
                              right: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Text(
                                    "Autumn \nCollection\n2021",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Dot indicators
                Positioned(
                  bottom: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(images.length, (index) {
                      final isCurrent = index == _selectedPromo;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: isCurrent ? 12 : 8,
                        width: isCurrent ? 12 : 8,
                        decoration: BoxDecoration(
                          color: isCurrent ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
    );
  }
}
