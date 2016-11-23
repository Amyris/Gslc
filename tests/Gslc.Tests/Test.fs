/// NUnit test wrapper available for adding either integration tests of the command line application
/// or tests of plugin extensions defined here.
namespace Gslc.Tests
open System
open NUnit.Framework

[<TestFixture>]
type Test() = 

    [<Test>]
    member x.TestCase() =
        Assert.IsTrue(true)

