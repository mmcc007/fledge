//import 'dart:io';
//
//import 'package:args/command_runner.dart';
//import 'package:cicd/src/runner/cicd_command_runner.dart';
//
///// Runs the CICD tool with support for the specified list of [commands].
//Future<int> run(List<String> args, List<Command> commands
////, {
////  bool muteCommandLogging = false,
////  bool verbose = false,
////  bool verboseHelp = false,
////  bool reportCrashes,
////  String flutterVersion,
////  Map<Type, Generator> overrides,
////}
//    ) async {
////  reportCrashes ??= !isRunningOnBot;
////
////  if (muteCommandLogging) {
////    // Remove the verbose option; for help and doctor, users don't need to see
////    // verbose logs.
////    args = List<String>.from(args);
////    args.removeWhere(
////        (String option) => option == '-v' || option == '--verbose');
////  }
//
//  final CommandRunner runner = CicdCommandRunner();
//  commands.forEach(runner.addCommand);
//
//  try {
//    await runner.run(args);
//    exit(0);
//  } catch (error, stackTrace) {
////    String getVersion() =>
////        flutterVersion ?? FlutterVersion.instance.getVersionString();
////    return await _handleToolError(
////        error, stackTrace, verbose, args, reportCrashes, getVersion);
//    print('Error: ' + error);
//    print('StackTrace: ' + stackTrace.toString());
//  }
//
//  return Future.value(1);
////  return runInContext<int>(() async {
////    // Initialize the system locale.
////    final String systemLocale = await intl_standalone.findSystemLocale();
////    intl.Intl.defaultLocale = intl.Intl.verifiedLocale(
////        systemLocale, intl.NumberFormat.localeExists,
////        onFailure: (String _) => 'en_US');
////
////    try {
////      await runner.run(args);
////      await _exit(0);
////    } catch (error, stackTrace) {
////      String getVersion() =>
////          flutterVersion ?? FlutterVersion.instance.getVersionString();
////      return await _handleToolError(
////          error, stackTrace, verbose, args, reportCrashes, getVersion);
////    }
////    return 0;
////  }, overrides: overrides);
//}
