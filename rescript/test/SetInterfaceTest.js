let { exec } = require('child_process')

describe('Set.mli', () => {
  test('prevent interface files from diverging', (done) => {
    exec(
      'diff rescript/src/TableclothSet.mli native/src/TableclothSet.mli',
      (_error, stdout, _stderror) => {
        expect(stdout).toMatchSnapshot()
        done()
      },
    )
  })
})
