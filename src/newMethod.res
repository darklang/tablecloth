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
let inparr =[]
let inparr2 =[]
let length =Belt.Array.length(myData.parameters)

let generate =Belt.Array.map(myData.tests, (test =>{
            let output= test.output
    if (length==1){
        //param length == 1 type string
        if (myData.parameters[0].\"type"=="string"){
            let newInput= `"${Js.Array.toString(test.inputs)}"`
            let newInputR= Js.Array.toString(test.inputs)
            let resultRescript = `test ("${name}(${newInputR})", () => expect(${Belt.Int.toString(output)!="exception"? `${name}(${newInput})) |> toEqual(Eq.int, ${Belt.Int.toString(output)}))` : `() => ${name}(${newInput})) |> toThrow)`} \n`
            resultsR->Belt.Array.push(resultRescript)
            let resultOcaml = `test "${name}(${newInput})" (fun () -> expect (${Belt.Int.toString(output)!="exception"? `${name} ${newInput}) |> toEqual Eq.int ${Belt.Int.toString(output) == "exception"? "|> toThrow":Belt.Int.toString(output)}) ; `:`fun () -> ${name} ${newInput}) |> toThrow); `}\n`
            resultsO->Belt.Array.push(resultOcaml)
            let resultFSharp = `testCase "${name}(${newInput})"\n <| fun _ -> \n    let expected = ${Belt.Int.toString(output)}\n    Expect.equal expected (${name} ${newInput})\n`
            resultsF->Belt.Array.push(resultFSharp)

        }else{
            //param length == 1 type array
            if (Js.Array.isArray(test.inputs)){
                let newInput= `[${Js.Array.toString(test.inputs)}]`
                let resultRescript = `test ("${name}(${newInput})", () => expect(${Belt.Int.toString(output)!="exception"? `${name}(${newInput})) |> toEqual(Eq.int, ${Belt.Int.toString(output)}))` : `() => ${name}(${newInput})) |> toThrow)`} \n`
                resultsR->Belt.Array.push(resultRescript)
                let resultOcaml = `test "${name}(${newInput})" (fun () -> expect (${Belt.Int.toString(output)!="exception"? `${name} ${newInput}) |> toEqual Eq.int ${Belt.Int.toString(output) == "exception"? "|> toThrow":Belt.Int.toString(output)}) ; `:`fun () -> ${name} ${newInput}) |> toThrow); `}\n`
                resultsO->Belt.Array.push(resultOcaml)
                let resultFSharp =`testCase "${name}(${newInput})"\n <| fun _ -> \n    let expected = ${Belt.Int.toString(output)}\n    Expect.equal expected (${name} ${newInput})\n`
                resultsF->Belt.Array.push(resultFSharp)

            }
            //param length == 1 type int 
            else{
                let newInput= Js.Array.toString(test.inputs)
                let resultRescript = `test ("${name}(${newInput})", () => expect(${Belt.Int.toString(output)!="exception"? `${name}(${newInput})) |> toEqual(Eq.int, ${Belt.Int.toString(output)}))` : `() => ${name}(${newInput})) |> toThrow)`} \n`
                resultsR->Belt.Array.push(resultRescript)
                let resultOcaml = `test "${name}(${newInput})" (fun () -> expect (${Belt.Int.toString(output)!="exception"? `${name} ${newInput}) |> toEqual Eq.int ${Belt.Int.toString(output) == "exception"? "|> toThrow":Belt.Int.toString(output)}) ; `:`fun () -> ${name} ${newInput}) |> toThrow); `}\n`
                resultsO->Belt.Array.push(resultOcaml)
                let resultFSharp =`testCase "${name}(${newInput})"\n <| fun _ -> \n    let expected = ${Belt.Int.toString(output)}\n    Expect.equal expected (${name} ${newInput})\n`
                resultsF->Belt.Array.push(resultFSharp)
            }}
        }
        //param length > 1 type 
    else{
        //param length > 1 type string
        for i in 0 to length-1{
        if (myData.parameters[i].\"type"=="string"){
            let newInput= `"${Belt.Int.toString(test.inputs[i])}"`
            inparr->Belt.Array.push(newInput)
        }
        //param length > 1 type array
        if (Js.Array.isArray(test.inputs[i])){
            let newInput= `[${Belt.Int.toString(test.inputs[i])}]`
            inparr2->Belt.Array.push(newInput)
            let newInput=Js_array.joinWith(",", inparr2)
            let resultRescript = `test ("${name}(${newInput})", () => expect(${Belt.Int.toString(output)!="exception"? `${name}(${newInput})) |> toEqual(Eq.int, ${Belt.Int.toString(output)}))` : `() => ${name}(${newInput})) |> toThrow)`} \n`
            resultsR->Belt.Array.push(resultRescript)
            let resultOcaml = `test "${name}(${newInput})" (fun () -> expect (${Belt.Int.toString(output)!="exception"? `${name} ${newInput}) |> toEqual Eq.int ${Belt.Int.toString(output) == "exception"? "|> toThrow":Belt.Int.toString(output)}) ; `:`fun () -> ${name} ${newInput}) |> toThrow); `}\n`
            resultsO->Belt.Array.push(resultOcaml)
            let resultFSharp =`testCase "${name}(${newInput})"\n <| fun _ -> \n    let expected = ${Belt.Int.toString(output)}\n    Expect.equal expected (${name} ${newInput})\n`
            resultsF->Belt.Array.push(resultFSharp)
        }
        //param length > 1 type int
    }
        let newInput = Js_array.joinWith(",", test.inputs)
        let newInputOF = Js_array.joinWith(" ", test.inputs)
        let resultRescript = `test ("${name}(${newInputOF})", () => expect(${Belt.Int.toString(output)!="exception"? `${name}(${newInput})) |> toEqual(Eq.int, ${Belt.Int.toString(output)}))` : `() => ${name}(${newInput})) |> toThrow)`} \n`
        resultsR->Belt.Array.push(resultRescript)
        let resultOcaml = `test "${name}(${newInput})" (fun () -> expect (${Belt.Int.toString(output)!="exception"? `${name} ${newInputOF}) |> toEqual Eq.int ${Belt.Int.toString(output) == "exception"? "|> toThrow":Belt.Int.toString(output)}) ; `:`fun () -> ${name} ${newInputOF}) |> toThrow); `}\n`
        resultsO->Belt.Array.push(resultOcaml)
        // let resultFSharp =`testCase "${name}(${newInput})"\n <| fun _ -> \n    let expected = ${Belt.Int.toString(output)}\n    Expect.equal expected (${name} ${newInputOF})\n`
        let resultFSharp =
        `testCase "${name}(${newInput})" \n<| fun _ -> \n    ${Belt.Int.toString(output)!="exception"? `let expected = ${Belt.Int.toString(output)}\n    Expect.equal expected (${\"module"}.${name} ${newInputOF}) "error"` : `Expect.equal (${\"module"}.${name} ${newInputOF}) |> failwith "error"`}\n`
        resultsF->Belt.Array.push(resultFSharp)    
}

}))

    let finalresultR = Js.Array.joinWith("",resultsR)
    let finalresultF = Js.Array.joinWith("",resultsF)
    let finalresultO = Js.Array.joinWith("",resultsO)
    %raw("Fs.appendFileSync(`../test/rescriptTests/IntTest.res`, finalresultR, 'utf8')")
    %raw("Fs.appendFileSync(`../test/ocamlTests/IntTest.ml`, finalresultO, 'utf8')")
    %raw("Fs.appendFileSync(`../test/fsharpTests/IntTest.fs`, finalresultF, 'utf8')")
    // Node.Fs.writeFileSync(`../rescriptTests/${name}Test.res`, finalresultR, #utf8)
    // Node.Fs.writeFileSync(`../ocamlTests/${name}Test.ml`, finalresultO, #utf8)
    // Node.Fs.writeFileSync(`../fsharpTests/${name}Test.fs`, finalresultF, #utf8)