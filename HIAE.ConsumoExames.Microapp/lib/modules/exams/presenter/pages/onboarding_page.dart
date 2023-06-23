// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/utils/local_storage_utils.dart';
import '../../../../core/widgets/bread_crumbs.dart';
import '../../../../core/widgets/dots_indicator_widget.dart';
import '../../../../core/widgets/responsive_app_bar.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  bool _isLoaded = false;
  final alreadySeenTheOnboarding = ValueNotifier<bool?>(null);
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      final result = await getCheckOnboardingLocalStorage();
      if (result) {
        await Navigator.of(context).pushReplacementNamed(Routes.listExamsPage);
      }
      alreadySeenTheOnboarding.value = result;
    }
  }

  @override
  void dispose() {
    _pageController = PageController();

    super.dispose();
  }

  int pageIndex = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: ZeraColors.neutralLight,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                fillOverscroll: true,
                child: AnimatedBuilder(
                  animation: alreadySeenTheOnboarding,
                  builder: (context, child) {
                    if (alreadySeenTheOnboarding.value == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 1200),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ResponsiveAppBar(
                              // onTap: null,
                              rootNavigator: true,
                              breadCrumbs: kIsWeb
                                  ? BreadCrumbs(
                                      listBreadCrumbs: [
                                        EXAM_RESULTS.translate(),
                                      ],
                                    )
                                  : null,
                              iconColor: ZeraColors.primaryMedium,
                              trailing: [
                                InkWell(
                                  onTap: () async {
                                    await setCheckOnboardingLocalStorage(
                                      true,
                                    );
                                    Navigator.of(context).pushReplacementNamed(
                                      Routes.listExamsPage,
                                    );
                                  },
                                  child: ZeraText(
                                    'Pular',
                                    color: ZeraColors.primaryDark,
                                    theme: const ZeraTextTheme(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      letterSpacing: 0.1,
                                      lineHeight: 2,
                                    ),
                                    // type: ZeraTextType.BOLD_24_NEUTRAL_DARK_BASE,
                                  ),
                                ),
                              ],
                              bottomChild: [
                                ZeraText(
                                  EXAM_RESULTS.translate(),
                                  type: ZeraTextType.BOLD_24_NEUTRAL_DARK_BASE,
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              constraints: const BoxConstraints(
                                minHeight: 343,
                                maxHeight: 486,
                              ),
                              height: double.infinity,
                              alignment: Alignment.center,
                              child: PageView(
                                onPageChanged: (index) {
                                  pageIndex = index;
                                },
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  ItemOnboardingWidget(
                                    pathImage: UNDRAW_HAPPY_NEWS_IMG,
                                    title: WE_HAVE_NEWS_FOR_YOU.translate(),
                                    description:
                                        TO_FURTHER_IMPROVE_YOUR_EXPERIENCE_WITH_OUR_DIGITAL_SERVICES
                                            .translate(),
                                  ),
                                  ItemOnboardingWidget(
                                    pathImage: UNDRAW_FILE_SEARCHING_IMG,
                                    title: EVOLUTIONARY_REPORT2.translate(),
                                    description:
                                        EASILY_VIEW_EXAM_HISTORY_SHARE_RESULTS
                                            .translate(),
                                  ),
                                  ItemOnboardingWidget(
                                    pathImage: UNDRAW_FILING_SYSTEM_IMG,
                                    title: IMPORT_YOUR_EXAMS_FROM_OTHER_LABS
                                        .translate(),
                                    description:
                                        NOW_YOU_CAN_EASILY_ORGANIZE_ALL_YOUR_EXAMS
                                            .translate(),
                                  ),
                                ],
                                controller: _pageController,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DotsIndicatorWidget(
                          controller: _pageController,
                          itemCount: 3,
                          onDotTap: (indexTaped) {},
                        ),
                        const SizedBox(height: 40),
                        AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) => ZeraButton(
                            onPressed: () async {
                              if (pageIndex == 2) {
                                await setCheckOnboardingLocalStorage(true);
                                Navigator.of(context).pushReplacementNamed(
                                  Routes.listExamsPage,
                                );
                              }

                              _pageController.animateToPage(
                                pageIndex + 1,
                                duration: const Duration(
                                  milliseconds: kDotsIndicatorAnimationDuration,
                                ),
                                curve: Curves.ease,
                              );
                            },
                            text: pageIndex == 2
                                ? START.translate()
                                : NEXT.translate(),
                            style: ZeraButtonStyle.PRIMARY_DARK,
                            theme: ZeraButtonTheme(
                              fontSize: 16,
                              minWidth: 300,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}

class ItemOnboardingWidget extends StatelessWidget {
  final String pathImage;
  final String title;
  final String description;
  const ItemOnboardingWidget({
    Key? key,
    required this.pathImage,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 420,
          ),
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                height: MediaQuery.of(context).size.height > 800 ? 290 : 200,
                width: MediaQuery.of(context).size.height > 800 ? 320 : 244,
                margin: const EdgeInsets.symmetric(vertical: 40),
                child: Image.asset(
                  pathImage,
                  package: MICRO_APP_PACKAGE_NAME,
                ),
              ),
              ZeraText(
                title,
                type: ZeraTextType.BOLD_MEDIUM_16_DARK_01,
              ),
              const SizedBox(height: 8),
              ZeraText(
                description,
                textAlign: TextAlign.center,
                theme: const ZeraTextTheme(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  lineHeight: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
}
