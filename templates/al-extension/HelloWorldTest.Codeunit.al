codeunit 50001 "Hello World Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    procedure TestHelloWorldPageOpens()
    var
        HelloWorldPage: TestPage "Hello World";
    begin
        // [SCENARIO] The Hello World page opens without errors
        // [GIVEN] The user has access to the page
        // [WHEN] The page is opened
        HelloWorldPage.OpenView();

        // [THEN] The page is open
        Assert.IsTrue(HelloWorldPage.Opened, 'Page should be open.');

        HelloWorldPage.Close();
    end;

    var
        Assert: Codeunit Assert;
}
