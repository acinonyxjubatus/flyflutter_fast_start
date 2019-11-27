import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flyflutter_fast_start/model/placemark_local.dart';
import 'package:flyflutter_fast_start/repositories/places/places_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injector/injector.dart';
import 'package:meta/meta.dart';

part 'places_event.dart';

part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  PlacesRepository placesRepository;

  PlacesBloc() {
    Injector injector = Injector.appInstance;
    placesRepository = injector.getDependency<PlacesRepository>();
  }

  @override
  PlacesState get initialState => EmptyPlacesState();

  @override
  Stream<PlacesState> mapEventToState(PlacesEvent event) async* {
    if (event is FetchPlaces) {
      yield LoadingPlacesState();
      try {
        final List<PlacemarkLocal> places =
        await placesRepository.getPlaces();
        yield LoadedPlacesState(placemarks: places);
      } catch (_) {
        yield ErrorPlacesState();
      }
    }
    if (event is AddPlaceEvent) {
      yield LoadingPlacesState();
      try {
        // add new place
        await placesRepository.addPlace(event.placemark);
        // get all new places as list to reinit UI
        final List<PlacemarkLocal> places =
        await placesRepository.getPlaces();
        yield LoadedPlacesState(placemarks: places);
      } catch (_) {
        yield ErrorAddingPlaceState();
      }
    }
    if (event is RemovePlaceEvent) {
      try {
        // remove new place
        await placesRepository.deletePlacemark(event.placemarkLocal.id);
        yield RemovedPlaceState(id: event.placemarkLocal.id);
      }catch (_) {
        yield ErrorRemovingPlaceState();
      }
    }
  }
}
