import 'dart:async';

import 'package:flutter/widgets.dart' show ChangeNotifier, FocusNode, TextEditingController;
import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps/app/domain/repositories/search_repository.dart';
import 'package:google_maps/app/helpers/current_position.dart';

class SearchPlaceController extends ChangeNotifier {
  final SearchRepository _searchRepository;

  String _query = '';
  String get query => _query;

  late StreamSubscription _subscription;

  List<Place>? _places = [];
  List<Place>? get places => _places;

  Place? _origin, _destination;

  Place? get origin => _origin;
  Place? get destination => _destination;

  final originFocusNode = FocusNode();
  final destinationFocusNode = FocusNode();

  final originController = TextEditingController();
  final destinationController = TextEditingController();

  late bool _originHasFocus;
  bool get originHasFocus => _originHasFocus;

  SearchPlaceController(
    this._searchRepository, {
    required Place? origin,
    required Place? destination,
    required bool hasOriginFocus,
  }) {
    _originHasFocus = hasOriginFocus;

    _origin = origin;
    _destination = destination;

    if (_origin != null) {
      originController.text = _origin!.title;
    }

    if (_destination != null) {
      destinationController.text = _destination!.title;
    }

    if (_originHasFocus) {
      originFocusNode.requestFocus();
    } else {
      destinationFocusNode.requestFocus();
    }

    _subscription = _searchRepository.onResults.listen(
      (results) {
        _places = results;
        notifyListeners();
      },
    );

    originFocusNode.addListener(() {
      if (originFocusNode.hasFocus && !_originHasFocus) {
        _onOriginFocusNodeChanged(true);
      } else if (!originFocusNode.hasFocus && _origin == null) {
        originController.text = '';
      }
    });

    destinationFocusNode.addListener(() {
      if (destinationFocusNode.hasFocus && _originHasFocus) {
        _onOriginFocusNodeChanged(false);
      } else if (!destinationFocusNode.hasFocus && _destination == null) {
        destinationController.text = '';
      }
    });
  }

  Timer? _debouncer;

  void _onOriginFocusNodeChanged(bool hasFocus) {
    _originHasFocus = hasFocus;
    _places = [];
    _query = '';
    notifyListeners();
  }

  void onQueryChanged(String text) {
    _query = text;
    _debouncer?.cancel();
    _debouncer = Timer(
      const Duration(milliseconds: 500),
      () {
        if (_query.length >= 3) {
          print("🎃 Call to API $query");
          final currentPosition = CurrentPosition.i.value;
          if (currentPosition != null) {
            _searchRepository.cancel();
            _searchRepository.search(query, currentPosition);
          }
        } else {
          print("🎃 cancel API call");
          clearQuery();
        }
      },
    );
  }

  void clearQuery() {
    _searchRepository.cancel();
    _places = [];
    if (_originHasFocus) {
      _origin = null;
    } else {
      _destination = null;
    }
    notifyListeners();
  }

  void pickPlace(Place place) {
    if (_originHasFocus) {
      _origin = place;
      originController.text = place.title;
    } else {
      _destination = place;
      destinationController.text = place.title;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    originController.dispose();
    destinationController.dispose();
    originFocusNode.dispose();
    destinationFocusNode.dispose();
    _debouncer?.cancel();
    _subscription.cancel();
    _searchRepository.dispose();
    super.dispose();
  }
}
