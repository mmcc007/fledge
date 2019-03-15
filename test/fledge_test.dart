import 'package:fledge/fledge.dart';
import 'package:test/test.dart';
import 'package:fledge/src/git.dart' as git;

void main() {
  test('create git tag if none exists', () {
    if (git.runSync(['tag']).isEmpty) git.runSync(['tag', '0.0.0']);
  });

  test('increment the semver git tag', () {
    final semver = Semver.patch;
    final workingDir = 'example';

    final betaCommand = BetaCommand();
    var newTag = betaCommand.incrementSemverTag(semver, workingDir);
    print('newTag=$newTag');
  });

  test('trigger beta build', () {
    final semver = Semver.patch;
    final workingDir = 'example';

    final betaCommand = BetaCommand();
    var newTag = betaCommand.incrementSemverTag(semver, workingDir);

    git.runSync(['push', 'origin', newTag]);
  });

  test('issue #19, checking for dev branch', () {
    // check for dev in alphabetical list of branches
    final branches = git.runSync(['branch']);
    expect(branches.contains('* dev'), true);
    expect(BetaCommand.validateRepo(), isNull);
  });
}
