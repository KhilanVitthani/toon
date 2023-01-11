import 'package:yodo1mas/Yodo1MAS.dart';

import '../../main.dart';
import '../utilities/ad_service.dart';
import '../utilities/progress_dialog_utils.dart';
import '../utilities/timer_service.dart';

void setUp() {
  getIt.registerSingleton<CustomDialogs>(CustomDialogs());
  getIt.registerSingleton<TimerService>(TimerService());
  getIt.registerSingleton<AdService>(AdService());
}
