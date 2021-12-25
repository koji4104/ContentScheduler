import 'constants.dart';
import 'package:flutter/material.dart';

import 'progress_model.dart';

List progressList = [
  ProgressData(
    name: "Download",
    value: 80,
    total: 100,
    col: 0xFF0000FF,
  ),
  ProgressData(
    name: "Storage",
    value: 60,
    total: 100,
    col: 0xFF00FF00,
  ),
  ProgressData(
    name: "Transcode",
    value: 5,
    total: 100,
    col: 0xFFFF0000,
  ),
  ProgressData(
    name: "Documents",
    value: 15,
    total: 100,
    col: 0xFF00FFFF,
  ),
];
