
@module("fs")
external readFileSync: (
  ~name: string,
   [#utf8],
) => string = "readFileSync"

type tests = {
  inputs: array<int>,
  output: int,
}

type parameter ={
  name: string,
  types: string,
}

type data = {
  \"module": string,
  name: string,
  parameters:array<parameter>,
  tests: array<tests>,
}

@scope("JSON") @val
external parseIntoMyData: string => data = "parse"

let file = readFileSync(~name="../json-files/Int.subtract.json", #utf8)
let myData = parseIntoMyData(file)
let name = myData.name
let \"module" = myData.\"module"
let resultsR = []
let resultsF = []
let resultsO = []

for i in 0 to Belt.Array.length(myData.tests)-1{
    let test = myData.tests[i];
    let inputs = test.inputs
    let output = test.output
    let resultRescript = `test ("${name}(${Js.Array.isArray(inputs)?Js.Array.joinWith(",",inputs): Js.Array.toString(inputs)})", () => expect(${Belt.Int.toString(output)!="exception"? `${\"module"}.${name}(${Js.Array.isArray(inputs)?Js.Array.joinWith(",",inputs): Js.Array.toString(inputs)})) |> toEqual(Eq.int, ${Belt.Int.toString(output)}))` : `() => ${\"module"}.${name}(${Js.Array.isArray(inputs)?Js.Array.joinWith(",",inputs): Js.Array.toString(inputs)})) |> toThrow)`} \n`
    resultsR->Belt.Array.push(resultRescript)
    let resultOcaml = `test "${name}(${Js.Array.isArray(inputs)?Js.Array.joinWith(",",inputs): Js.Array.toString(inputs)})" (fun () -> expect (${Belt.Int.toString(output)!="exception"? `${\"module"}.${name} ${Js.Array.isArray(inputs)?Js.Array.joinWith(" ",inputs): Js.Array.toString(inputs)}) |> toEqual Eq.int ${Belt.Int.toString(output) == "exception"? "|> toThrow":Belt.Int.toString(output)}) ; `:`fun () -> ${\"module"}.${name} ${Js.Array.isArray(inputs)?Js.Array.joinWith(" ",inputs): Js.Array.toString(inputs)}) |> toThrow); `}\n`
    resultsO->Belt.Array.push(resultOcaml)
    let resultFSharp =
        `testCase "${name}(${Js.Array.isArray(inputs)?Js.Array.joinWith(",",inputs): Js.Array.toString(inputs)})" \n<| fun _ -> \n    ${Belt.Int.toString(output)!="exception"? `let expected = ${Belt.Int.toString(output)}\n    Expect.equal expected (${\"module"}.${name} ${Js.Array.isArray(inputs)?Js.Array.joinWith(" ",inputs): Js.Array.toString(inputs)}) "error"` : `Expect.equal (${\"module"}.${name} ${Js.Array.isArray(inputs)?Js.Array.joinWith(" ",inputs): Js.Array.toString(inputs)}) |> failwith "error"`}\n`
    resultsF->Belt.Array.push(resultFSharp)

}
    let finalresultR = Js.Array.joinWith("",resultsR)
    let finalresultF = Js.Array.joinWith("",resultsF)
    let finalresultO = Js.Array.joinWith("",resultsO)
    %raw("Fs.appendFileSync(`../test/rescriptTests/IntTest.res`, finalresultR, 'utf8')")
    %raw("Fs.appendFileSync(`../test/ocamlTests/IntTest.ml`, finalresultO, 'utf8')")
    %raw("Fs.appendFileSync(`../test/fsharpTests/IntTest.fs`, finalresultF, 'utf8')")





