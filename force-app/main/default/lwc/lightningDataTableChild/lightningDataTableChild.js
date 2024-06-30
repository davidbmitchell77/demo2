import { LightningElement, api } from 'lwc';

export default class LightningDataTableChild extends LightningElement {

    @api cols;
    @api records;

    sortBy;
    sortDirection;

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.records));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = ((direction === 'asc') ? 1 : -1);
        parseData.sort((x, y) => {
            x = (keyValue(x) ? keyValue(x) : '');
            y = (keyValue(y) ? keyValue(y) : '')
            return (isReverse * ((x > y) - (y > x)));
        });
        this.records = parseData;
    }
}