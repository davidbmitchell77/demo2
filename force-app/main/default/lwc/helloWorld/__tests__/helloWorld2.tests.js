import { createElement } from 'lwc';
import HelloWorld from 'c/helloWorld';

describe('c-hello-world', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    })

    test('Zero to Hero', () => {
        const element = createElement('c-hello-world', { is: HelloWorld });
        document.body.appendChild(element);
        const div = element.shadowRoot.querySelectorAll('div')[0];
        expect(div.textContent).toBe('"Zero to Hero" is a course of LWC.');
    })
})