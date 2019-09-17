(async () => {
    const testCase = new TestCase("Sakuli Content");
    const screen = new Region();
    const env = new Environment();
    env.setSimilarity(0.90);
    const url = "https://sakuli.io";
    try {
        await _navigateTo(url);

        await screen.mouseWheelUp(10);
        await screen.find("/getting.png").then(target => target.click());
        await _highlight(_code("npm init"));
        await testCase.endOfStep("Code component found.");

        await _navigateTo(url);
        await _highlight(_link("Enterprise"));
        await _click(_link("Enterprise"));
        await _highlight(_heading1("Enterprise Plans"));
        await testCase.endOfStep("Opened Enterprise page.");

    } catch (e) {
        await testCase.handleException(e);
    } finally {
        await testCase.saveResult();
    }
})().then(done);
