import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:vendor_store/models/product.dart';
import 'package:vendor_store/services/manage_http_response.dart';
import '../global_variables.dart';

class ProductController {
 Future<void> uploadProduct({
    required String productName,
    required int productPrice,
    required int quantity,
    required String description,
    required String category,
    required String vendorId,
    required String fullName,
    required String subCategory,
    required List<File>? pickedImages,
    required context,
  }) async {
    try {
      if (pickedImages == null || pickedImages.isEmpty) {
        showSnackBar(context, 'Vui lòng chọn hình ảnh');
        return;
      }

      final cloudinary = CloudinaryPublic("dajwnmjjf", "tb9fytch");
      List<String> images = [];

      for (var i = 0; i < pickedImages.length; i++) {
        try {
          CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(pickedImages[i].path, folder: productName),
          );
          images.add(cloudinaryResponse.secureUrl);
        } catch (e) {
          print("Lỗi tải ảnh lên Cloudinary: $e");
          showSnackBar(context, "Lỗi khi tải ảnh lên Cloudinary");
          return;
        }
      }

      if (category.isEmpty || subCategory.isEmpty) {
        showSnackBar(context, "Chọn danh mục sản phẩm");
        return;
      }

      final Product product = Product(
        id: '',
        productName: productName,
        productPrice: productPrice,
        quantity: quantity,
        description: description,
        category: category,
        vendorId: vendorId,
        fullName: fullName,
        subCategory: subCategory,
        images: images,
      );

      try {
        http.Response response = await http.post(
          Uri.parse("$uri/api/add-products"),
          body: product.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          },
        );

        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Tải sản phẩm thành công");
          },
        );
      } catch (e) {
        print("Lỗi kết nối API: $e");
        showSnackBar(context, "Lỗi kết nối đến server");
      }
    } catch (e) {
      print("Lỗi không xác định: $e");
      showSnackBar(context, "Đã xảy ra lỗi, vui lòng thử lại");
    }
  }
}
