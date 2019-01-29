import 'package:fledge/src/command.dart';
import 'package:fledge/src/exceptions.dart';
import 'package:fledge/src/git.dart' as git;
import 'package:fledge/src/io.dart';

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
//    argParser.addFlag('all', abbr: 'a');
  }

  // [run] may also return a Future.
  void run() {
    if (!entryExists('.git')) usageException('git repository must exist');

    final gitResult = git.runSync(['branch']);
    if (!(gitResult.isNotEmpty && gitResult[0].contains('dev')))
      usageException(
          'must be in dev branch and all files committed and pushed');

    // check if files committed and pushed
    if (git.runSync(['status', '-s']).isNotEmpty)
      usageException('all dev files must be committed and pushed');

    if (git.runSync(['log', 'origin/dev..dev']).isNotEmpty)
      usageException('all dev files must be pushed');

    // create git tag if none exists
    var result = runProcessSync('git', ['tag']);
    if (result.success) {
      if (result.stdout.isEmpty) runProcessSync('git', ['tag', '0.0.0']);
      result = runProcessSync('fastlane', ['start_beta']);
      for (final line in result.stdout) print(line);
      if (!result.success) {
        for (final line in result.stderr) print(line);
        ApplicationException('beta failed to start');
      }
    }
  }
}
