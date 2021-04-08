# Genotype Specification Language (GSL)

Amyris domain specification language for rapidly specifying genetic designs

Documentation in the repo is sparse currently, but you can find

* the scientific paper describing the language here http://pubs.acs.org/doi/abs/10.1021/acssynbio.5b00194
* GSL documentation as part of the Autodesk genetic constructor tool here https://geneticconstructor.readme.io/docs/genotype-specification-language
* the press release on the GSL / Autodesk collaboration here http://investors.amyris.com/releasedetail.cfm?ReleaseID=992005


# To create a windows executable in the bin/Gscl directory
```
dotnet publish src\Gslc -r win-x64 -p:PublishSingleFile=true --self-contained true -o bin/Gslc
bin\Gslc\Gslc.exe --help
```

# Alternately, simply build and run using dotnet
```
dotnet build src\Gslc
dotnet src\Gslc\bin\Debug\net5.0\Gslc.dll --help
```

# Example usage
```bash
dotnet src\Gslc\bin\Debug\net5.0\Gslc.dll --noprimers --defaultRef S288C --step examples\simple_fusion.gsl
```

