import 'package:dio/dio.dart';
import 'package:teslo_app/config/config.dart';
import 'package:teslo_app/features/products/domain/domain.dart';
import 'package:teslo_app/features/products/infastructure/mappers/product_mapper.dart';

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
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
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
