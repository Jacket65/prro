/// Layout thresholds shared by the responsive shells.
///
/// [kNarrowWidth] is the only breakpoint the app has today: below it the shell
/// stacks its panels and the app bar collapses its labels. It is a single named
/// constant rather than a scale because there is nothing else to scale — adding
/// tablet/desktop tiers means deciding what they do, not inventing numbers.
const double kNarrowWidth = 600;
