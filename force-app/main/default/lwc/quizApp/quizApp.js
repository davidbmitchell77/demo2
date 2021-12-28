import { LightningElement } from 'lwc';

export default class QuizApp extends LightningElement
{
    selected = {}; // for storing answers
    correctAnswers = 0;
    score = 0.0;
    isSubmitted = false;

    questions = 
    [
        {
            id: "1",
            question: "Which of the following is not a template loop:",
            choices: {
                a: "for:each",
                b: "iterator",
                c: "map loop"
            },
            correctAnswer: "c"
        },
        {
            id: "2",
            question: "Which of the following is invalid in LWC component folder:",
            choices: {
                a: ".svg",
                b: ".apex",
                c: ".js"
            },
            correctAnswer: "b"
        },
        {
            id: "3",
            question: "Which of the following is not a directive:",
            choices: {
                a: "for:each",
                b: "if:true",
                c: "@track loop"
            },
            correctAnswer: "c"
        }
    ]

    get isScoredFull()
    {
        let result = "slds-var-m-bottom_medium slds-text-heading_medium ";
        result += ((this.correctAnswers === this.questions.length) ? "slds-text-color_success" : "slds-text-color_error");
        return result;
    }

    get notAllSelected() {
        return !(Object.keys(this.selected).length === this.questions.length);
    }
 
    get notAnySelected() {
        return (Object.keys(this.selected).length === 0);
    } 

    changeHandler(event)
    {
        const {name, value} = event.target;
        this.selected = {...this.selected, [name]:value};
      //console.log("name", event.target.name);
      //console.log("value", event.target.value);
    }
 
    resetHandler()
    {
        this.selected = {};
        this.correctAnswers = 0;
        this.isSubmitted = false;
        let radios = this.template.querySelectorAll("input[type='radio']");
        Array.from(radios).forEach(element => {
            element.checked = false;
        });
    }
 
    submitHandler(event)
    {
        event.preventDefault();  // prevent page refresh
        let correct = this.questions.filter(item=>this.selected[item.id] === item.correctAnswer);
        this.correctAnswers = correct.length;
        this.score = (Math.round((correct.length / this.questions.length) * 1000) / 10);
        this.isSubmitted = true;
    }
}