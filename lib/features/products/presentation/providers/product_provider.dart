import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'products_repository_provider.dart';

final productProvider = StateNotifierProvider.autoDispose.family<ProductNotifier, ProductState, String>(
  ( ref, productId ) {
    final productRepository = ref.watch(productsRepositoryProvider);
    return ProductNotifier(
      productRepository: productRepository,
      productId: productId,
    );
  }
);

class ProductNotifier extends StateNotifier<ProductState> {

  final ProductsRepository productRepository;

  ProductNotifier({
    required this.productRepository,
    required String productId,
  }): super(ProductState( id: productId )){
    loadProduct();
  }

  Future<void> loadProduct() async {
    try {
      final product = await productRepository.getProductById( state.id );
      state = state.copyWith(
        product: product,
        isLoading: false,
      );
    } catch (e) {
      print(e);
    }
  }
}

class ProductState {

  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) => ProductState(
        id: id ?? this.id,
        product: product ?? this.product,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
    );
}