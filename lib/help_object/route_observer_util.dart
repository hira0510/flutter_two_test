import 'package:flutter/material.dart';

class RouteObserverUtil{
  static final _observerUtil = RouteObserverUtil._internal();
  final RouteObserver<PageRoute> _routeObserver = RouteObserver();
  factory RouteObserverUtil(){
    return _observerUtil;
  }

  RouteObserverUtil._internal();

  RouteObserver<PageRoute> get routeObserver => _routeObserver;

}