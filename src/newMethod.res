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
  \"type": string,
}

type data = {
  \"module": string,
  name: string,
  parameters:array<parameter>,
  tests: array<tests>,
  returnType: int
}

@scope("JSON") @val
external parseIntoMyData: string => data = "parse"

let file = readFileSync(~name="../json-files/Bool.toString.json", #utf8)
let myData = parseIntoMyData(file)
let name = myData.name
let returnType = myData.returnType
let \"module" = myData.\"module"
let resultsR = []
let resultsF = []
let resultsO = []
let inparr =[]
let newInput=ref("")
let newInputR=ref("")
let newInputOF=ref("")
let output=ref(0)
let length =Belt.Array.length(myData.parameters)

let generate =Belt.Array.map(myData.tests, (test =>{
    output:= test.output
    if (length==1){
        //param length == 1 type string
        if (myData.parameters[0].\"type"=="string"){
            newInput:= `"${Js.Array.toString(test.inputs)}"`
            newInputR:= Js.Array.toString(test.inputs)
            newInputOF:= `"${Js.Array.toString(test.inputs)}"`

        }else{
            //param length == 1 type array
            if (Js.Array.isArray(test.inputs)){
                newInput:= `[${Js.Array.toString(test.inputs)}]`

            }
            //param length == 1 type int 
            else{
                newInput:= Js.Array.toString(test.inputs)
                newInputR:= Js.Array.toString(test.inputs)
                newInputOF:= Js.Array.toString(test.inputs)
            }}
        }
        //param length > 1 type 
    else{

        for i in 0 to length-1{
        //param length > 1 type array
        if (Js.Array.isArray(test.inputs[i])){
            newInput:= `[${Belt.Int.toString(test.inputs[i])}]`
            inparr->Belt.Array.push(newInput)
            newInput:=Js_array.joinWith(",", inparr)
        }
        //param length > 1 type int
    }
        newInput := Js_array.joinWith(",", test.inputs)
        newInputOF := Js_array.joinWith(" ", test.inputs)
        newInputR := Js_array.joinWith(",", test.inputs)
  
}

    let resultRescript = `test ("${name}(${newInputR.contents})", () => expect(${Belt.Int.toString(output.contents)!="exception"? `${\"module"}.${name}(${newInput.contents})) |> toEqual(${Js.String.includes("Some", Belt.Int.toString(output.contents)) || Js.String.includes("None", Belt.Int.toString(output.contents)) ? `{open Eq\n${Js.String.slice(~from=0, ~to_=6, Belt.Int.toString(returnType))}(${Js.String.replace(">", "" ,Js.String.sliceToEnd(~from=7, Belt.Int.toString(returnType)))})}`: `Eq.${Belt.Int.toString(returnType)}`}, ${Belt.Int.toString(output.contents)}))` : `() => ${\"module"}.${name}(${newInput.contents})) |> toThrow)`} \n`
    resultsR->Belt.Array.push(resultRescript)
    let resultOcaml = `test "${name}(${newInput.contents})" (fun () -> expect (${Belt.Int.toString(output.contents)!="exception"? `${\"module"}.${name} ${newInputOF.contents}) |> toEqual ${Js.String.includes("Some", Belt.Int.toString(output.contents)) || Js.String.includes("None", Belt.Int.toString(output.contents)) ? `(let open Eq in ${Js.String.slice(~from=0, ~to_=6, Belt.Int.toString(returnType))} ${Js.String.replace(">", "" ,Js.String.sliceToEnd(~from=7, Belt.Int.toString(returnType)))})`: `Eq.${Belt.Int.toString(returnType)}`} ${Belt.Int.toString(output.contents) == "exception"? "|> toThrow":Belt.Int.toString(output.contents)}) ; `:`fun () -> ${name} ${newInputOF.contents}) |> toThrow); `}\n`
    resultsO->Belt.Array.push(resultOcaml)
    let resultFSharp =
    `testCase "${name}(${newInput.contents})" \n<| fun _ -> \n    ${Belt.Int.toString(output.contents)!="exception"? `let expected = ${Belt.Int.toString(output.contents)}\n    Expect.equal expected (${\"module"}.${name} ${newInputOF.contents}) "error"` : `Expect.equal (${\"module"}.${name} ${newInputOF.contents}) |> failwith "error"`}\n`
    resultsF->Belt.Array.push(resultFSharp)  

}))

    let finalresultR = Js.Array.joinWith("",resultsR)
    let finalresultF = Js.Array.joinWith("",resultsF)
    let finalresultO = Js.Array.joinWith("",resultsO)
    // %raw("Fs.appendFileSync(`../test/rescriptTests/IntTest.res`, finalresultR, 'utf8')")
    // %raw("Fs.appendFileSync(`../test/ocamlTests/IntTest.ml`, finalresultO, 'utf8')")
    // %raw("Fs.appendFileSync(`../test/fsharpTests/IntTest.fs`, finalresultF, 'utf8')")
    Node.Fs.writeFileSync(`../test/rescriptTests/Bool/${name}Test.res`, finalresultR, #utf8)
    Node.Fs.writeFileSync(`../test/ocamlTests/Bool/${name}Test.ml`, finalresultO, #utf8)
    Node.Fs.writeFileSync(`../test/fsharpTests/Bool/${name}Test.fs`, finalresultF, #utf8)