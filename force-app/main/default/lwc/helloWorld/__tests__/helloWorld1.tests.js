describe("Test Suite", () => {
    beforeEach(() => {
        console.log('Before each running...')
    })

    afterEach(() => {
        console.log('After each running...')
    })

    test("(1 + 2) equals 3", () => {
        let n = (1 + 2)
        expect(n).toBe(3)
    })

    test("(2 + 2) equals 4", () => {
        let n = (2 + 2)
        expect(n).toBe(4)
    })

    it("(5 * 5) equals 25", () => {
        let n = (5 * 5);
        expect(n).toBeLessThan(250)
        expect(n).toBe(25)
        expect(n).toBeGreaterThan(2.5);
    })
})