//import 'package:args/command_runner.dart';
//import 'package:cicd/cicd.dart' as cicd;
//import 'package:args/args.dart';
//import 'dart:io';
//
//import 'package:cicd/src/commands/calc.dart';
//
//// arg constants
////const argHelp = 'help';
////const argCommand = 'command';
//
//main(List<String> args) {
////  print('Hello world: ${cicd.calculate()}!');
//
//  final bool help = args.contains('-h') ||
//      args.contains('--help') ||
//      (args.isNotEmpty && args.first == 'help') ||
//      args.isEmpty;
//
//  var argParser = new ArgParser()
////    ..addOption(argCommand,
////        allowed: [
////          'calc',
////          'install',
////          'beta',
////          'release',
////        ],
////        help: 'Available commands:',
////        valueHelp: 'command name',
////        allowedHelp: {
////          'calc': 'Run a calculation',
////          'install': 'Install fastlane and build server config files',
////          'beta': 'Start a beta on both stores',
////          'release': 'Release to both stores',
////        })
//////    ..addOption(
//////      argCalc,
//////      help: 'Calc command',
//////      valueHelp: 'Calculate a value',
//////    )
////    ..addFlag(argHelp,
////        abbr: 'h', help: 'Display this help information.', negatable: false)
//      ;
//
//  var calcCmd = argParser.addCommand('calc');
//
//  // install fastlane files and selected build server dependency
//  var installCmd = argParser.addCommand('install');
//  // start beta command
//  var betaCmd = argParser.addCommand('beta');
//  // release command
//  var releaseCmd = argParser.addCommand('release');
//
//  var argResults = argParser.parse(args);
//
//  // validate
////  print(argResults[argCommand]);
//  if (help) usage(argParser);
//  if (argResults.arguments.length == 0) usage(argParser);
////  if (argResults[argHelp]) usage(argParser);
////  if (argResults[argCommand] == null) {
////    handleError(argParser, "Missing required argument: $argCommand");
////  }
////  var cicdRunner = new CommandRunner("CICD", "CICD for Flutter.")
////    ..addCommand(new CalcCommand());
//////    ..run(['calc']);
////
////  cicdRunner.run(args).catchError((error) {
////    if (error is! UsageException) throw error;
////    print(error);
////    exit(64); // Exit code 64 indicates a usage error.
////  });
//  cicd.run(args, [CalcCommand()]);
//}
//
//void usage(ArgParser argParser) {
//  const usage = """
//usage: cicd [--help] <command>
//    <command name>    Available commands:
//
//          [beta]                Start a beta on both stores
//          [calc]                Run a calculation
//          [install]             Install fastlane and build server config files
//          [release]             Release to both stores
//
//    -h, --help                  Display this help information.
//  """;
//  print('$usage');
//  print(argParser.usage);
//  exit(64); // Exit code 64 indicates a usage error.
//}
//
//void handleError(ArgParser argParser, String msg) {
//  stderr.writeln(msg);
//  usage(argParser);
//}

import 'package:fly/src/command_runner.dart';

void main(List<String> arguments) {
  FlyCommandRunner().run(arguments);
}
