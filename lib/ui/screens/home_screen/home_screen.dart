import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/ui/custom_widgets/custom_elevated_button.dart';
import 'package:enzer_app/ui/screens/home_screen/components/home_screen_header.dart';
import 'package:enzer_app/ui/screens/home_screen/components/home_tab_bar.dart';
import 'package:enzer_app/ui/screens/home_screen/components/leader_board.dart';
import 'package:enzer_app/ui/screens/home_screen/components/premium_card_section.dart';
import 'package:enzer_app/ui/screens/home_screen/components/reward_section.dart';
import 'package:enzer_app/ui/screens/home_screen/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

const _kSurfaceColor = AppColors.backgroundColor;
const double _kTabBarHeight = 52.0;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = HomeViewModel();
        vm.onRefreshNeeded = () => _refreshKey.currentState?.show();
        return vm;
      },
      child: Consumer<HomeViewModel>(
        builder: (context, model, _) => DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: Container(
              decoration: BoxDecoration(gradient: AppColors.primaryGradient),
              child: RefreshIndicator(
                key: _refreshKey,
                color: AppColors.primary,
                onRefresh: model.loadData,
                child: SafeArea(
                  top: true,
                  bottom: false,
                  child: NestedScrollView(
                    physics: const ClampingScrollPhysics(),
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: model.isRefreshing
                              ? LinearProgressIndicator(
                                  color: AppColors.primary,
                                  backgroundColor: Colors.white24,
                                  minHeight: 2,
                                )
                              : const SizedBox.shrink(),
                        ),
                        SliverToBoxAdapter(child: HomeHeader(model: model)),

                        //Card section
                        SliverToBoxAdapter(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: _kSurfaceColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(48),
                                topRight: Radius.circular(48),
                              ),
                            ),
                            child: Column(
                              children: [
                                20.verticalSpace,
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                  ),
                                  child: PremiumCardSection(model: model),
                                ),
                                16.verticalSpace,
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                  ),
                                  child: CustomElevatedButton(
                                    text: 'Invite Friend',
                                    onPressed: model.onInviteFriend,
                                    prefixIcon: Icons.share_outlined,
                                    isBold: true,
                                  ),
                                ),
                                16.verticalSpace,
                              ],
                            ),
                          ),
                        ),
                        //Sticky tab bar
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _StickyTabBarDelegate(
                            tabBar: Container(
                              color: _kSurfaceColor,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: HomeTabBar(),
                            ),
                          ),
                        ),

                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                context,
                              ),
                          sliver: const SliverToBoxAdapter(
                            child: SizedBox.shrink(),
                          ),
                        ),
                      ];
                    },
                    body: NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (notification) {
                        notification.disallowIndicator();
                        return true;
                      },
                      child: TabBarView(
                        physics: const PageScrollPhysics(),
                        children: [
                          _TabBody(
                            padding: EdgeInsets.fromLTRB(
                              20.w,
                              24.h,
                              20.w,
                              100.h,
                            ),
                            child: RewardsSection(model: model),
                          ),
                          _TabBody(
                            padding: EdgeInsets.fromLTRB(
                              20.w,
                              15.h,
                              20.w,
                              100.h,
                            ),
                            child: LeaderboardSection(model: model),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Tab body
class _TabBody extends StatelessWidget {
  final EdgeInsets padding;
  final Widget child;

  const _TabBody({required this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _kSurfaceColor,
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding: padding,
            sliver: SliverToBoxAdapter(child: child),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: ColoredBox(
              color: _kSurfaceColor,
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

//Sticky tab bar delegate

const double _kBleed = 2.0;

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget tabBar;

  const _StickyTabBarDelegate({required this.tabBar});

  @override
  double get minExtent => _kTabBarHeight;

  @override
  double get maxExtent => _kTabBarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: _kTabBarHeight,
          height: _kBleed,
          child: ColoredBox(color: _kSurfaceColor),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: -_kBleed,
          height: _kBleed,
          child: ColoredBox(color: _kSurfaceColor),
        ),

        Positioned.fill(child: tabBar),
      ],
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) =>
      oldDelegate.tabBar != tabBar;
}
