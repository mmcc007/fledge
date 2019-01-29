import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fledge/src/io.dart';
import 'package:fledge/src/log.dart' as log;
import 'package:resource/resource.dart';

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
    final resourcePath = 'resource';

    final buildServer = argResults['buildserver'];

    // todo: create dev branch if none exists
    // git branch dev
    // git checkout dev
    // git push --set-upstream origin dev

    if (buildServer != null) {
      // if config not complete run config
      if (!alreadyRun(buildServer)) {
        // todo: do not overwrite any files
        await unpackTarGzFile('$resourcePath/fastlane/fastlane.tar.gz', '.');
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
      } else {
        usageException('config already run');
      }
    } else
      usageException('build server not specified');
  }
}

Future unpackTextFile(String resourcePath, String filePath) async {
  resourcePath = 'package:fledge/$resourcePath';
  log.io('unpacking $resourcePath to $filePath');
  var resource = Resource(resourcePath);
  var text = await resource.readAsString();
  final file = await File(filePath).create();
  await file.writeAsString(text, flush: true);
}

Future unpackTarGzFile(String resourcePath, String filePath) async {
  resourcePath = 'package:fledge/$resourcePath';
  log.io('unpacking $resourcePath to $filePath');
  var resource = Resource(resourcePath);
  await extractTarGz(resource.openRead(), filePath);
}

bool alreadyRun(String buildServer) {
  var alreadyRun = entryExists('./fastlane') &&
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
