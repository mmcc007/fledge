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
      "Triggers the build server to start a beta build and release to testers in both store consoles.";

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

    final workingDir = argResults['appdir'];

    var newTag = incrementSemverTag(semver, workingDir);

    // trigger beta release on build server
    git.runSync(['push', 'origin', newTag]);

    log.message('Beta release of $newTag started on build server.');
  }

  static String validateRepo() {
    String errorMessage;
//    if (!entryExists('.git')) errorMessage = 'Error: git repository must exist';

    // check if in dev branch
    final branches = git.runSync(['branch']);
    if (!(branches.isNotEmpty && branches.contains('* dev')))
      errorMessage =
          'Error: must be in dev branch and all files committed and pushed';

    // check if files committed and pushed
    if (git.runSync(['status', '-s']).isNotEmpty)
      errorMessage = 'Error: all dev files must be committed and pushed';

    // check if all files committed
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
