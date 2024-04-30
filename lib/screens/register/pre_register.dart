// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:selaa/backend-functions/links.dart';
import 'package:selaa/generated/l10n.dart';
//import 'package:selaa/main.dart';
import 'package:selaa/screens/register/choice_auth.dart';

class PreRegister extends StatefulWidget {
  const PreRegister({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PreRegisterPageState createState() => _PreRegisterPageState();
}

class _PreRegisterPageState extends State<PreRegister> {
  late PageController _pageController;
  int currentStep = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: currentStep - 1,
      keepPage: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentStep = 4;
                    });
                    _pageController.animateToPage(
                      currentStep - 1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(AppColors().secondaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Skip',
                        style: TextStyle(
                          color: AppColors().primaryColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors().primaryColor,
                      ),
                    ],
                  ),
                ),
                DropdownButton(
                  icon: Icon(
                    Icons.language, 
                    color: AppColors().primaryColor,
                    size: 35,
                  ),
                  underline: Container(),
                  items: const [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: 'ar',
                      child: Text('العربية'),
                    ),
                  ], 
                  onChanged: (language){
                    // if(language == 'en'){
                    //   Main.setLocale(context, const Locale('en'));
                    // }
                    // if(language == 'ar'){
                    //   Main.setLocale(context, const Locale('ar'));
                    // }
                  }
                ),
              ],
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    currentStep = page + 1;
                  });
                },
                children: const [
                  Step1Widget(),
                  Step2Widget(),
                  Step3Widget(),
                  Step4Widget(),
                ],
              ),
            ),
            DotsIndicator(
              dotsCount: 4,
              position: currentStep - 1,
              decorator: DotsDecorator(
                color: AppColors().secondaryColor,
                activeColor: AppColors().primaryColor,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                if (currentStep < 4) {
                  setState(() {
                    currentStep++;
                  });
                  _pageController.animateToPage(
                    currentStep - 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
                if (currentStep == 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChoiceAuthPage()),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors().secondaryColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              child: currentStep == 4
                ? Text(
                    S.of(context).getStarted,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors().primaryColor,
                    ),
                  )
                : Icon(
                    Icons.arrow_forward,
                    color: AppColors().primaryColor,
                  ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
    );
  }
}

class Step1Widget extends StatelessWidget {
  const Step1Widget({Key? key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(ImagePaths().blackverticalLogo),
          width: 250,
          height: 250,
        ),
        const SizedBox(
          height: 60,
        ),
        Text(
          S.of(context).welcomeToSelaa,
          style: const TextStyle(
            fontSize: 25,
            fontFamily: 'Montserrat',
          ),
        )
      ],
    );
  }
}

class Step2Widget extends StatelessWidget {
  const Step2Widget({Key? key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/gifs/megaphone.gif'),
            width: 250,
            height: 250,
          ),
          const SizedBox(
            height: 60,
          ),
          Text(
            S.of(context).effortlessOrderingForYourBusiness,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontFamily: 'Montserrat',
            ),
          )
        ],
      ),
    );
  }
}

class Step3Widget extends StatelessWidget {
  const Step3Widget({Key? key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/gifs/delivery-truck.gif'),
            width: 250,
            height: 250,
          ),
          const SizedBox(
            height: 60,
          ),
          Text(
            S.of(context).streamlinedDeliveriesToYourDoorstep,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontFamily: 'Montserrat',
            ),
          )
        ],
      ),
    );
  }
}

class Step4Widget extends StatelessWidget {
  const Step4Widget({Key? key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/gifs/pallets.gif'),
            width: 250,
            height: 250,
          ),
          const SizedBox(
            height: 60,
          ),
          Text(
            S.of(context).exploreExclusiveDealsAndOffers,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontFamily: 'Montserrat',
            ),
          )
        ],
      ),
    );
  }
}
