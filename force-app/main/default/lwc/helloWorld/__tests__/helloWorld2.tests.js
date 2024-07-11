import { createElement } from 'lwc';
import HelloWorld from 'c/helloWorld';

describe('c-helloWorld', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    })

    test('dd', () => {
        let i = 1;
        expect(++i).toBe(2);
    })
})