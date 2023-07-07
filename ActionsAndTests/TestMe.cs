using NUnit.Framework;

namespace ActionsAndTests;

public class TestMe
{
    [SetUp]
    public async Task Setup()
    {
    }

    [TearDown]
    public async Task Teardown()
    {
    }

    [Test]
    public async Task SimpleTestMethod()
    {
        Assert.IsTrue(false);
    }
}
