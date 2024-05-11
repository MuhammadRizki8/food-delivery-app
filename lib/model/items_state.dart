class ItemsState {}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsLoadedAll extends ItemsState {
  final List<dynamic> itemsAll;
  ItemsLoadedAll(this.itemsAll);
}

class ItemsLoadedFilter extends ItemsState {
  final List<dynamic> itemsFilter;
  ItemsLoadedFilter(this.itemsFilter);
}

class ItemsError extends ItemsState {
  final String message;
  ItemsError(this.message);
}
