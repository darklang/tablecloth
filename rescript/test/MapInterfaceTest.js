let { exec } = require('child_process')

describe('Map', () => {
  test('prevent interface files from diverging', (done) => {
    exec(
      'diff rescript/src/TableclothMap.mli native/src/TableclothMap.mli',
      (_error, stdout, _stderror) => {
        expect(stdout).toMatchSnapshot()
        done()
      },
    )
  })
})
