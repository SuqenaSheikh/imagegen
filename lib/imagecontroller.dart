import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ImageController extends GetxController {
  final RxString prompt = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString imageUrl = ''.obs;
  final RxString errorMessage = ''.obs;

  Future<void> generateImage(String inputPrompt) async {
    if (inputPrompt.trim().isEmpty) {
      errorMessage.value = 'Please enter a prompt.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    imageUrl.value = '';

    try {
      final encodedPrompt = Uri.encodeComponent(inputPrompt);
      final url =
          'https://image.pollinations.ai/prompt/$encodedPrompt?width=512&height=512&nologo=true';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        imageUrl.value = url;
      } else {
        throw Exception('Failed to generate image: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
