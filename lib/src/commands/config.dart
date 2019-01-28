import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fly/src/io.dart';
import 'package:resource/resource.dart';
import 'package:fly/src/log.dart' as log;

/// Config a flutter app for CICD.
///
/// Installs the build server config files.
class ConfigCommand extends Command {
  // The [name] and [description] properties must be defined by every
  // subclass.
  final name = "config";
  final description = "Installs the build server config files.";

  ConfigCommand() {
    // [argParser] is automatically created by the parent class.
    argParser.addOption('buildserver',
        abbr: 'b',
        allowed: [
          'travis',
          'gitlab',
        ],
        help: 'Available build servers:',
        valueHelp: 'build server',
        allowedHelp: {
          'travis': 'Travis-CI.',
          'gitlab': 'GitLab-CI.',
        });
  }

  // [run] may also return a Future.
  Future run() async {
    // [argResults] is set before [run()] is called and contains the options
    // passed to this command.
//    print(argResults['all']);
//    print('Config fly!');
//
//    PubProcessResult result = runProcessSync('ls', []);
//    print(result.stdout);

    final resourcePath = 'resource';

    final buildServer = argResults['buildserver'];

    if (buildServer != null) {
      // if config not complete run config
      if (!alreadyRun(buildServer)) {
        // todo: do not overwrite any files
        await unpackTarGzFile('$resourcePath/fastlane/fastlane.tar.gz', '.');
//      try {
        switch (buildServer) {
          case 'travis':
            await unpackTextFile(
                '$resourcePath/travis/.travis.yml', '.travis.yml');

            break;
          case 'gitlab':
            await unpackTextFile(
                '$resourcePath/gitlab/.gitlab-ci.yml', '.gitlab-ci.yml');

            break;
          default:
            throw 'unknown build server $buildServer';
        }
//      } on FormatException catch (error) {
//        usageException(error.message);
//      }
      } else {
        usageException('config already run');
      }
    } else
      usageException('build server not specified');
  }
}

Future unpackTextFile(String resourcePath, String filePath) async {
  resourcePath = 'package:fly/$resourcePath';
  log.io('unpacking $resourcePath to $filePath');
  var resource = Resource(resourcePath);
  final String text = await resource.readAsString();
  final file = await File(filePath).create();
  await file.writeAsString(text, flush: true);
}

Future unpackTarGzFile(String resourcePath, String filePath) async {
  resourcePath = 'package:fly/$resourcePath';
  log.io('unpacking $resourcePath to $filePath');
  var resource = Resource(resourcePath);
  await extractTarGz(resource.openRead(), filePath);
}

bool alreadyRun(String buildServer) {
  bool alreadyRun = entryExists('./fastlane') &&
      entryExists('./ios/fastlane') &&
      entryExists('./android/fastlane');
  switch (buildServer) {
    case 'travis':
      alreadyRun = alreadyRun && entryExists('.travis.yml');
      break;
    case 'gitlab':
      alreadyRun = alreadyRun && entryExists('.gitlab-ci.yml');
      break;
    default:
      throw 'unknown build server $buildServer';
  }

  return alreadyRun;
}
