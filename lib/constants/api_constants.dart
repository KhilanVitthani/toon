import 'package:get/get.dart';
import '../../main.dart';
import '../app/routes/app_pages.dart';

const imagePath = "assets/images/";
const baseUrl = "https://member.imglarger.com/api/";
const imageCartton = "https://access2.imglarger.com:8997/";

class ApiConstant {
  static const login = "User/Login";
  static const upload = "upload";
}

class ArgumentConstant {
  static const userId = "userId";
  static const imageFile = "imageFile";
  static const isFromCatoonizer = "isFromCatoonizer";
  static const isFromEnhancer = "isFromEnhancer";
  static const isFromDenoiser = "isFromDenoiser";
  static const isFromAnime = "isFromAnime";
  static const isFromImageEnlarger = "isFromImageEnlarger";
  static const isFromImageUpscaler = "isFromImageUpscaler";
  static const isFromSharpener = "isFromSharpener";
  static const isFromFaceRetouch = "isFromFaceRetouch";
  static const isFromBGRemover = "isFromBGRemover";
  static const isFromColorizer = "isFromColorizer";
  static const capuredImage = "capuredImage";
  static const password = "password";
}

getLogOut() {
  Get.offAllNamed(Routes.HOME);
}

String getYoutubeThumbnail({required String videoId}) {
  return "https://img.youtube.com/vi/$videoId/hqdefault.jpg";
}
