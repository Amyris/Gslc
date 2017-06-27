/// top-level entry point for GSLc.
/// Injects plugins into main compiler function call.
open gslc
open CoreOutputProviders
open JsonAssembly
open BasicCodonProvider
open BasicAlleleSwapProvider
open BasicL2ExpansionProvider
open utils

let seamlessPlugin = (SeamlessPlugin.createSeamlessPlugin true (fun _ x -> x))
let allPlugins = 
    basicOutputPlugins@
    [seamlessPlugin;
     autodeskJsonOutputPlugin;
     basicCodonProviderPlugin;
     basicAlleleSwapPlugin;
     basicL2ExpansionPlugin]

[<EntryPoint>]
let main argv =
    try
        let flowResult = gslc allPlugins argv
        match flowResult with
        | Exit(code, msg) ->
            msg |> Option.map (printf "%s") |> ignore
            exit code
        | Continue(_) ->
            printfn "InternalError: GSL relinquished flow control in the continue state."
            exit 1

    with e ->
        printfn "InternalError:\n%s" (prettyPrintException e)
        exit 1
