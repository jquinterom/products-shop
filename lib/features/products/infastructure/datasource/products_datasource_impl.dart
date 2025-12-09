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

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];

      final String method = productId == null ? 'POST' : 'PATCH';

      final String url = (productId == null) ? '/post' : '/products/$productId';

      productLike.remove('id');

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
