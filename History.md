0.1.2 / 2013-09-26
==================

* Bug fix where if passed a path to a file, an empty array was returned

0.1.1 / 2013-09-15
==================

* Added tavis.ci service hook
* Added homepage

0.1.0 / 2013-09-15
==================

* Added `exclude` option in order to exclude certain paths
* Rewrote all the tests in a completely different style. They're better than before as they're actually running against real files on the file system
* Removed sinon dev dependency
* Upgraded Mocha version
* Moved License out of README into own file
* Rewrote README

0.0.4 / 2013-09-11
==================

* Made `globber` use async version of `isFile` when `includeDirectories` options is `false`.

0.0.3 / 2013-09-09
==================

* Remove `globber.glob` (node-glob no longer exposed)
* Add ability to pass an array of paths as first argument to `globber` and `globber.sync`
* Rewrote most everything, better tests and much better code design