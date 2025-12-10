import 'package:dio/dio.dart';
import 'package:teslo_app/config/config.dart';
import 'package:teslo_app/features/products/domain/domain.dart';
import 'package:teslo_app/features/products/infastructure/infrastructure.dart';

class ProductsDatasourceImpl implements ProductsDatasource {
  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({required this.accessToken})
    : dio = Dio(
        BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

  Future<String> _uploadPhoto(String path) async {
    try {
      final fileName = path.split('/').last;

      final FormData data = FormData.fromMap({
        'file': await MultipartFile.fromFile(path, filename: fileName),
      });

      final response = await dio.post('/files/product', data: data);
      return response.data['image'];
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<String>> _uploadPhotos(List<String> photos) async {
    try {
      final photosToUpload = photos
          .where((photo) => photo.contains("/"))
          .toList();

      final photosToIgnore = photos
          .where((photo) => !photo.contains("/"))
          .toList();

      final List<Future<String>> uploadJob = photosToUpload
          .map(_uploadPhoto)
          .toList();

      final newImages = await Future.wait(uploadJob);

      return [...photosToIgnore, ...newImages];
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];

      final String method = productId == null ? 'POST' : 'PATCH';

      final String url = (productId == null)
          ? '/products'
          : '/products/$productId';

      productLike.remove('id');

      productLike['images'] = await _uploadPhotos(productLike['images']);

      final response = await dio.request(
        url,
        data: productLike,
        options: Options(method: method),
      );

      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');

      return ProductMapper.jsonToEntity(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ProductNotFoundError();
      }
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Product>> getProductsByPage({
    int limit = 10,
    int offset = 0,
  }) async {
    final response = await dio.get<List>(
      '/products',
      queryParameters: {'limit': limit, 'offset': offset},
    );

    final List<Product> products = [];
    for (final productJson in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(productJson));
    }

    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }
}
