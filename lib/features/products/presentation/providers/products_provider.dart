
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repository_provider.dart';

final productsProvider = StateNotifierProvider<ProductsNotifier, ProductState>((ref) {
  
  final productsRepository = ref.watch( productsRepositoryProvider );

  return ProductsNotifier(
    productsRepository: productsRepository,
  ); 
});

class ProductsNotifier extends StateNotifier<ProductState> {

  final ProductsRepository productsRepository;

  ProductsNotifier({
    required this.productsRepository,
  }): super(ProductState()) {
    loadNextPage();
  }

  Future loadNextPage() async {

    if ( state.isLoading || state.isLastPage ) return;

    state = state.copyWith(
      isLoading: true
    );

    final products = await productsRepository
      .getProductsByPage(limit: state.limit, offset: state.offset);

    if ( products.isEmpty ) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true
      );
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...products]
    );
  
  }
}

// State
class ProductState {

  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const [],
  });

  ProductState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) => ProductState(
    isLastPage: isLastPage ?? this.isLastPage,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
    isLoading: isLoading ?? this.isLoading,
    products: products ?? this.products,
  );
  
}