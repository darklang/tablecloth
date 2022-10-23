
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
  name: string,
  parameters:array<parameter>,
  tests: array<tests>,
}

@scope("JSON") @val
external parseIntoMyData: string => data = "parse"

let file = readFileSync(~name="../json-files/Int.subtract.json", #utf8)
let myData = parseIntoMyData(file)
let name = myData.name
let resultsR = []
let resultsF = []
let resultsO = []

for i in 0 to Belt.Array.length(myData.tests)-1{
    let test = myData.tests[i];
    let inputs = test.inputs
    let output = test.output
    let resultRescript = `test ("${name}(${Js.Array.isArray(inputs)?Js.Array.joinWith(",",inputs): Js.Array.toString(inputs)})", () => expect(${Js.Array.isArray(inputs)?Js.Array.joinWith(",",inputs): Js.Array.toString(inputs)}) |> toEqual(${Belt.Int.toString(output)})) \n`
    resultsR->Belt.Array.push(resultRescript)
    let resultOcaml = `test "${name}(${Js.Array.isArray(inputs)?Js.Array.joinWith(",",inputs): Js.Array.toString(inputs)})" (fun () -> expect (${name} ${Js.Array.isArray(inputs)?Js.Array.joinWith(" ",inputs): Js.Array.toString(inputs)}) |> toEqual Eq.Int ${Belt.Int.toString(output)}) ; \n`
    resultsO->Belt.Array.push(resultOcaml)
    let resultFSharp =
        `testCase "${name}(${Js.Array.isArray(inputs)?Js.Array.joinWith(",",inputs): Js.Array.toString(inputs)})" <| fun _ -> \n    let expected = ${Belt.Int.toString(output)}\n    Expect.equal expected (${name} ${Js.Array.isArray(inputs)?Js.Array.joinWith(" ",inputs): Js.Array.toString(inputs)})\n`
    resultsF->Belt.Array.push(resultFSharp)

}
    let finalresultR = Js.Array.joinWith("",resultsR)
    let finalresultF = Js.Array.joinWith("",resultsF)
    let finalresultO = Js.Array.joinWith("",resultsO)
    Node.Fs.writeFileSync(`../test/rescriptTests/IntTest/${name}Test.res`, finalresultR, #utf8)
    Node.Fs.writeFileSync(`../test/ocamlTests/IntTest/${name}Test.ml`, finalresultO, #utf8)
    Node.Fs.writeFileSync(`../test/fsharpTests/IntTest/${name}Test.fs`, finalresultF, #utf8)




