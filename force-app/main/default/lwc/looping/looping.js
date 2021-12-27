import { LightningElement } from 'lwc';

export default class Looping extends LightningElement
{
    cars =
    [
        "BMW",
        "Audi",
        "Honda",
        "Toyota",
        "Hyundai"
    ].sort();

    ceoList =
    [
        {
            id: 1,
            company: "Amazon",
            name: "Jeff Bezos"
        },
        {
            id: 2,
            company: "Apple",
            name: "Tim Cook"
        },
        {
            id: 3,
            company: "Facebook",
            name: "Mark Zuckerberg"
        },
        {
            id: 4,
            company: "Google",
            name: "Sundar Pichai"
        }
    ];
}