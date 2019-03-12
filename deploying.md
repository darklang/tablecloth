To deploy to opam

- update /opam and /native/tablecloth-native.opam to version x.y.z
- git tag -f x.y.z
- git push origin x.y.z
- opam-publish tablecloth-native -v x.y.z https://github.com/darklang/tablecloth/archive/0.0.3.tar.gz
- make the pull request work

To deploy to npm

- npm publish
