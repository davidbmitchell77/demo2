import { LightningElement } from 'lwc';

export default class SlotParentDemo extends LightningElement
{
    get happyNewYear()
    {
        let result = "";

        result += "!!!";
        result += "_   ";
        result += "H A P P Y";
        result += "_  ";
        result += "N E W";
        result += "_   ";
        result += "Y E A R";
        result += "_   ";
        result += "!!!";

        return result;
    }
 
    get currentYear() {
        return (new Date().getFullYear());
    }
}