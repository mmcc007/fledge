import 'package:args/command_runner.dart';
import 'package:fledge/src/commands/beta.dart';
import 'package:fledge/src/git.dart' as git;
import '../log.dart' as log;

/// Release a build.
///
/// Triggers the build server to release most recent beta build to users on both stores.
class ReleaseCommand extends Command {
  // The [name] and [description] properties must be defined by every
  // subclass.
  final name = "release";
  final description =
      "Triggers the build server to release most recent beta build to users on both stores.";

  ReleaseCommand();

  // [run] may also return a Future.
  void run() {
    final betaCommand = BetaCommand();
    betaCommand.validateRepo();

//    # dev should be committed
//    #ensure_git_branch dev
//    ensure_git_status_clean
//    sh "git checkout dev"
//    # push what ever is in dev to origin so other developers can pick it up
//    # (if not already done)
//    sh "git push origin"

    // commit dev to master to trigger CICD to complete beta and release
    git.runSync(['checkout', 'master']);
    git.runSync(['merge', 'dev']);
    git.runSync(['push', 'origin']);
    // return to dev branch
    git.runSync(['checkout', 'dev']);

//    sh "git checkout master"
//    sh "git merge dev"
//    sh "git push origin"
//    # return to dev branch
//    sh "git checkout dev"
//    var result = runProcessSync('fastlane', ['release']);
//    for (final line in result.stdout) print(line);
//    if (!result.success) {
//      for (final line in result.stderr) print(line);
//      ApplicationException('release failed to start');
//    }
    var lastTag = git.runSync(['tag', '--sort=v:refname']).last;
    log.message('Release of $lastTag started on build server.');
  }
}
