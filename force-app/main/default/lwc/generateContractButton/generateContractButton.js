import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class GenerateContractButton extends NavigationMixin(LightningElement) {
    
    constructor() {
        super();
        console.log('-----GenerateContractButton--connectedCallBack--');
        this[NavigationMixin.Navigate]({
            type: "standard__component",
            attributes: {
                componentName: "c__PRI_generateContractContainer"
            },
            state: {
                c__propertyValue: '500'
            }
        });
    }
}