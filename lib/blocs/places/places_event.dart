part of 'places_bloc.dart';

@immutable
abstract class PlacesEvent extends Equatable {
  const PlacesEvent();
}

class FetchPlaces extends PlacesEvent {
  const FetchPlaces();

  @override
  List<Object> get props => [];
}

class AddPlaceEvent extends PlacesEvent {
  final Placemark placemark;

  const AddPlaceEvent({@required this.placemark}) : assert(placemark != null);

  @override
  List<Object> get props => [placemark];
}

class RemovePlaceEvent extends PlacesEvent {
  final PlacemarkLocal placemarkLocal;

  const RemovePlaceEvent({@required this.placemarkLocal})
      : assert(placemarkLocal != null);

  @override
  List<Object> get props => [placemarkLocal];
}
