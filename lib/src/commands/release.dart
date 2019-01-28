import 'package:args/command_runner.dart';
import 'package:fly/src/exceptions.dart';
import 'package:fly/src/io.dart';

/// Release a build.
///
/// Triggers the build server to release most recent beta build to users on both stores.
class ReleaseCommand extends Command {
  // The [name] and [description] properties must be defined by every
  // subclass.
  final name = "release";
  final description =
      "Triggers the build server to release most recent beta build to users on both stores.";

  ReleaseCommand() {
    // [argParser] is automatically created by the parent class.
//    argParser.addFlag('all', abbr: 'a');
  }

  // [run] may also return a Future.
  void run() {
    // [argResults] is set before [run()] is called and contains the options
    // passed to this command.
//    print(argResults['all']);
//    print('Release to users!');
    PubProcessResult result = runProcessSync('fastlane', ['release']);
    for (final line in result.stdout) print(line);
    if (!result.success) {
      for (final line in result.stderr) print(line);
      ApplicationException('release failed to start');
    }
  }
}
