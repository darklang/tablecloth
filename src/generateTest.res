@module("fs")
external readFileSync: (~name: string, [#utf8]) => string = "readFileSync"

type tests = {
  inputs: array<int>,
  output: int,
}

type parameter = {
  name: string,
  \"type": string,
}

type data = {
  \"module": string,
  name: string,
  parameters: array<parameter>,
  tests: array<tests>,
  returnType: string,
}

@scope("JSON") @val
external parseIntoMyData: string => data = "parse"
let \"module" = ref("")
let testCasesR = []
let testCasesF = []
let testCasesO = []
// let files = [
//   "Bool.compare.json",
//   "Bool.equal.json",
//   "Bool.fromInt.json",
//   "Bool.fromString.json",
//   "Bool.toInt.json",
//   "Bool.toString.json",
//   "Bool.xor.json",
// ]
// let files = [
//   "Char.fromCode.json",
//   "Char.fromString.json",
//   "Char.isAlphanumeric.json",
//   "Char.isDigit.json",
//   "Char.isLetter.json",
//   "Char.isLowercase.json",
//   "Char.isPrintable.json",
//   "Char.isUppercase.json",
//   "Char.isWhitespace.json",
//   "Char.toCode.json",
//   "Char.toDigit.json",
//   "Char.toLowercase.json",
//   "Char.toString.json",
//   "Char.toUppercase.json",
// ]
let files = [
  "Int.absolute.json",
  "Int.add.json",
  "Int.clamp.json",
  "Int.divide.json",
  "Int.divideFloat.json",
  "Int.fromString.json",
  "Int.inRange.json",
  "Int.isEven.json",
  "Int.isOdd.json",
  "Int.maximum.json",
  "Int.minimum.json",
  "Int.modulo.json",
  "Int.multiply.json",
  "Int.negate.json",
  "Int.power.json",
  "Int.remainder.json",
  "Int.subtract.json",
  "Int.toFloat.json",
  "Int.toString.json",
]
let generateAllTests = Belt.Array.map(files, file => {
  let file = readFileSync(~name="../json-files/" ++ file, #utf8)
  let myData = parseIntoMyData(file)
  let name = myData.name
  let returnType = myData.returnType
  \"module" := myData.\"module"
  let resultsR = []
  let resultsF = []
  let resultsO = []
  let newInput = ref("")
  let newInputR = ref("")
  let newInputOF = ref("")
  let output = ref("")
  let length = Belt.Array.length(myData.parameters)

  let generate = Belt.Array.map(myData.tests, test => {
    output := Belt.Int.toString(test.output)
    if myData.returnType == "string" {
      output := `"${Belt.Int.toString(test.output)}"`
    } else if Js.String.includes("array", myData.returnType) {
      output := `[${Belt.Int.toString(test.output)}]`
      //TODO: add a different output for ocaml and f# ([||])
    }

    if length == 1 {
      //param length == 1 type string
      if myData.parameters[0].\"type" == "string" {
        newInput := `"${Js.Array.toString(test.inputs)}"`
        newInputR := Js.Array.toString(test.inputs)
        newInputOF := `"${Js.Array.toString(test.inputs)}"`
      } //param length == 1 type array
      else if Js.Array.isArray(test.inputs) {
        newInput := `[${Js.Array.toString(test.inputs)}]`
        newInputOF := `[|${Js.Array.toString(test.inputs)}|]`
      } else {
        //param length == 1 

        newInput := Js.Array.toString(test.inputs)
        newInputR := Js.Array.toString(test.inputs)
        newInputOF := Js.Array.toString(test.inputs)
      }
    } else {
      //param length > 1 type
      newInput := Js_array.joinWith(",", test.inputs)
      newInputOF := Js_array.joinWith(" ", test.inputs)
      newInputR := Js_array.joinWith(",", test.inputs)
    }

    let resultRescript = `test ("${name}(${newInputR.contents})", () => expect(${output.contents != "exception"
        ? `${\"module".contents}.${name}(${newInput.contents})) |> toEqual(${Js.String.includes(
              "Some",
              output.contents,
            ) ||
            Js.String.includes("None", output.contents)
              ? `{open Eq\n${Js.String.slice(
                    ~from=0,
                    ~to_=6,
                    returnType,
                  )}(${Js.String.replace(
                    ">",
                    "",
                    Js.String.sliceToEnd(~from=7, returnType),
                  )})}`
              : `Eq.${returnType}`}, ${output.contents}))`
        : `() => ${\"module".contents}.${name}(${newInput.contents})) |> toThrow)`} \n`
    resultsR->Belt.Array.push(resultRescript)

    let resultOcaml = `test "${name}(${newInput.contents})" (fun () -> expect (${output.contents != "exception"
        ? `${\"module".contents}.${name} ${newInputOF.contents}) |> toEqual ${Js.String.includes(
              "Some",
              output.contents,
            ) ||
            Js.String.includes("None", output.contents)
              ? `(let open Eq in ${Js.String.slice(
                    ~from=0,
                    ~to_=6,
                    returnType,
                  )} ${Js.String.replace(
                    ">",
                    "",
                    Js.String.sliceToEnd(~from=7, returnType),
                  )})`
              : `Eq.${returnType}`} ${output.contents == "exception"
              ? "|> toThrow"
              : output.contents}) ; `
        : `fun () -> ${name} ${newInputOF.contents}) |> toThrow); `}\n`
    resultsO->Belt.Array.push(resultOcaml)

    let resultFSharp = `testCase "${name}(${newInput.contents})" \n<| fun _ -> \n    ${output.contents != "exception"
        ? `let expected = ${output.contents}\n    Expect.equal expected (${\"module".contents}.${name} ${newInputOF.contents}) "error"`
        : `Expect.equal (${\"module".contents}.${name} ${newInputOF.contents}) |> failwith "error"`}\n`
    resultsF->Belt.Array.push(resultFSharp)
  })

  testCasesR->Belt.Array.push(Js.Array.joinWith("", resultsR))
  testCasesF->Belt.Array.push(Js.Array.joinWith("", resultsF))
  testCasesO->Belt.Array.push(Js.Array.joinWith("", resultsO))
})


let testHeaderR = `open Tablecloth\nopen AlcoJest\n\nlet suite= suite("${\"module".contents}", () => {\n   open ${\"module".contents}\n`
let combineTestsR = `${testHeaderR}${Js.Array.joinWith("", testCasesR)}})`
let testHeaderO = `open Tablecloth\nopen AlcoJest\n\nlet suite =\n suite "${\"module".contents}" (fun () ->\n   let open ${\"module".contents} in\n`
let combineTestsO = `${testHeaderO}${Js.Array.joinWith("", testCasesO)})`
let testHeaderF = `open Tablecloth\nopen Expecto\n\n[<Tests>]\nlet tests =\n  testList\n  "${\"module".contents}"\n[`
let combineTestsF = `${testHeaderF}${Js.Array.joinWith("", testCasesF)}]`
Node.Fs.writeFileSync(
  `../test/rescriptTests/${\"module".contents}Test.res`,
  combineTestsR,
  #utf8,
)
Node.Fs.writeFileSync(
  `../test/ocamlTests/${\"module".contents}Test.ml`,
  combineTestsO,
  #utf8,
)
Node.Fs.writeFileSync(
  `../test/fsharpTests/${\"module".contents}Test.fs`,
  combineTestsF,
  #utf8,
)
