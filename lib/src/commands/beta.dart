import 'package:fledge/src/command.dart';
import 'package:fledge/src/git.dart' as git;
import 'package:fledge/src/io.dart';
import '../log.dart' as log;

enum Semver { major, minor, patch }

/// Start a beta build.
///
/// Triggers the build server to start a beta build and release to testers
/// in both stores.
class BetaCommand extends PubCommand {
  // The [name] and [description] properties must be defined by every
  // subclass.
  final name = "beta";
  final description =
      "Triggers the build server to start a beta build and release to testers in both stores.";

  BetaCommand() {
    // [argParser] is automatically created by the parent class.
    argParser.addOption(
      'release',
      abbr: 'r',
      allowed: ['major', 'minor', 'patch'],
      help: 'Available release types:',
      valueHelp: 'release types',
      allowedHelp: {
        'major': 'Major Release, eg, 1.0.0',
        'minor': 'Minor Release, eg, 0.1.0',
        'patch': 'Patch Release, eg, 0.0.1',
      },
      defaultsTo: 'patch',
    );

    argParser.addOption('appdir',
        abbr: 'a',
        help: 'App directory:',
        valueHelp: 'app dir',
        hide: true,
        defaultsTo: '.');
//    argParser.addFlag('dry-run',
//        abbr: 'n',
//        negatable: false,
//        help: "Report what dependencies would change but don't change any.");
//
//    argParser.addFlag('precompile',
//        defaultsTo: true,
//        help: "Precompile executables and transformed dependencies.");
//
//    argParser.addFlag('working-dir', negatable: true, hide: true);
  }

  // [run] may also return a Future.
  void run() {
    var validateErrorMsg = validateRepo();
    if (validateErrorMsg != null) usageException(validateErrorMsg);

    // create git tag if none exists
    if (git.runSync(['tag']).isEmpty) git.runSync(['tag', '0.0.0']);

    // increment semver tag
    final release = argResults['release'];

    var semver =
        Semver.values.firstWhere((e) => e.toString() == 'Semver.' + release);

//    final workingDir = 'example';
    final workingDir = argResults['appdir'];

    var newTag = incrementSemverTag(semver, workingDir);

    // trigger beta release on build server
    git.runSync(['push', 'origin', newTag]);

//
//    var result = runProcessSync('git', ['tag']);
//    if (result.success) {
//      if (result.stdout.isEmpty) runProcessSync('git', ['tag', '0.0.0']);
//      result = runProcessSync('fastlane', ['start_beta']);
//      for (final line in result.stdout) print(line);
//    }
//    if (!result.success) {
//      for (final line in result.stderr) print(line);
//      usageException('Error: beta failed to start');
//    }
    log.message('Beta release of $newTag started on build server.');
  }

  static String validateRepo() {
    String errorMessage;
//    if (!entryExists('.git')) errorMessage = 'Error: git repository must exist';

    final gitResult = git.runSync(['branch']);
    if (!(gitResult.isNotEmpty && gitResult[0].contains('dev')))
      errorMessage =
          'Error: must be in dev branch and all files committed and pushed';

    //    // check if files committed and pushed
    //    if (git.runSync(['status', '-s']).isNotEmpty)
    //      usageException('Error: all dev files must be committed and pushed');

    if (git.runSync(['log', 'origin/dev..dev']).isNotEmpty)
      errorMessage = 'Error: all dev files must be pushed';

    return errorMessage;
  }

  String incrementSemverTag(Semver semver, [String workingDir = '.']) {
    final List tags = git.runSync(['tag', '--sort=v:refname']);
    //    print('tags=$tags');
    final String lastTag = tags.last;

    // increment tag
    var semverResult = runProcessSync(
        './script/semver', ['bump', semver.toString().split('.').last, lastTag],
        workingDir: workingDir);
    if (semverResult.success) {
      // set new tag
      var newTag = semverResult.stdout.last;
      //      print('newTag=$newTag');
      git.runSync(['tag', newTag]);
      return newTag;
    } else {
      for (final line in semverResult.stderr) print(line);
      usageException('Error: incrementing tag failed');
    }
    return null;
  }
}
