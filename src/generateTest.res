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

let file = readFileSync(~name="../json-files/Bool.xor.json", #utf8)
let myData = parseIntoMyData(file)
let name = myData.name
let returnType = myData.returnType
let \"module" = myData.\"module"
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
      //param length == 1 type int

      newInput := Js.Array.toString(test.inputs)
      newInputR := Js.Array.toString(test.inputs)
      newInputOF := Js.Array.toString(test.inputs)
    }
  } else {
    //param length > 1 type int
    newInput := Js_array.joinWith(",", test.inputs)
    newInputOF := Js_array.joinWith(" ", test.inputs)
    newInputR := Js_array.joinWith(",", test.inputs)
  }

  let resultRescript = `test ("${name}(${newInputR.contents})", () => expect(${output.contents != "exception"
      ? `${\"module"}.${name}(${newInput.contents})) |> toEqual(${Js.String.includes(
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
      : `() => ${\"module"}.${name}(${newInput.contents})) |> toThrow)`} \n`
  resultsR->Belt.Array.push(resultRescript)

  let resultOcaml = `test "${name}(${newInput.contents})" (fun () -> expect (${output.contents != "exception"
      ? `${\"module"}.${name} ${newInputOF.contents}) |> toEqual ${Js.String.includes(
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
      ? `let expected = ${output.contents}\n    Expect.equal expected (${\"module"}.${name} ${newInputOF.contents}) "error"`
      : `Expect.equal (${\"module"}.${name} ${newInputOF.contents}) |> failwith "error"`}\n`
  resultsF->Belt.Array.push(resultFSharp)
})

let finalresultR = Js.Array.joinWith("", resultsR)
let finalresultF = Js.Array.joinWith("", resultsF)
let finalresultO = Js.Array.joinWith("", resultsO)
%raw("Fs.appendFileSync(`../test/rescriptTests/BoolTest.res`, finalresultR, 'utf8')")
%raw("Fs.appendFileSync(`../test/ocamlTests/BoolTest.ml`, finalresultO, 'utf8')")
%raw("Fs.appendFileSync(`../test/fsharpTests/BoolTest.fs`, finalresultF, 'utf8')")
// Node.Fs.writeFileSync(
//   `../test/rescriptTests/CharTest/${name}Test.res`,
//   finalresultR,
//   #utf8,
// )
// Node.Fs.writeFileSync(
//   `../test/ocamlTests/CharTest/${name}Test.ml`,
//   finalresultO,
//   #utf8,
// )
// Node.Fs.writeFileSync(
//   `../test/fsharpTests/CharTest/${name}Test.fs`,
//   finalresultF,
//   #utf8,
// )
