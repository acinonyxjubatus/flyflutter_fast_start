part of 'places_bloc.dart';

@immutable
abstract class PlacesState extends Equatable {
  const PlacesState();

  @override
  List<Object> get props => [];
}

class EmptyPlacesState extends PlacesState {}

class LoadingPlacesState extends PlacesState {}

class LoadedPlacesState extends PlacesState {
  final List<PlacemarkLocal> placemarks;

  const LoadedPlacesState({@required this.placemarks})
      : assert(placemarks != null);

  @override
  List<Object> get props => [placemarks];
}

class ErrorPlacesState extends PlacesState {}

class ErrorAddingPlaceState extends PlacesState {}

class RemovedPlaceState extends PlacesState {
  final int id;

  const RemovedPlaceState({@required this.id}) : assert(id > 0);

  @override
  List<Object> get props => [id];
}

class ErrorRemovingPlaceState extends PlacesState {}
