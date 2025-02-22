import { LightningElement, wire, track } from 'lwc';
import fetchRecords from '@salesforce/apex/ET_CallCenterFAQ.fetchRecords';
export default class ET_CallCenterFAQ extends LightningElement {
    @track faqData = [];
    @track departmentMap = [];
    searchQuery = '';
    @track queryFaq;
    @track activeSections = []; //this controls which sections are expanded 
    @track serviceEntryactiveSections = []; //this controls which sections are expanded 

    @track openSectionList = '';
    @track error;

    constructor() {
        super();
        this.queryFaq = 'SELECT Id,Sequence__c,Number__c,Department_En__c,Department_Ar__c,Service_En__c,Service_Ar__c,Activities_En__c,Activities_Ar__c FROM Call_Center_FAQ__mdt ORDER BY Sequence__c ASC';
        console.log('Constructor:', this.queryFaq);
    }

    connectedCallback() {
        console.log('connectedCallback');
    }

    @wire(fetchRecords, { strQuery: '$queryFaq' })
    wiredFaqData({ error, data }) {
        if (data) {
            //console.log('data: ', data);
            this.faqData = data;
            // Prepare departmentMap
            const resultMap = new Map();
            // Iterate over the data array
            data.forEach(item => {
                // If the department doesn't exist in resultMap, initialize it with an empty map
                if (!resultMap.has(item.Department_En__c + ' (' + item.Department_Ar__c + ')')) {
                    resultMap.set(item.Department_En__c + ' (' + item.Department_Ar__c + ')', new Map());
                }
                // If the service doesn't exist in the service's map, initialize it with an empty array
                const serviceMap = resultMap.get(item.Department_En__c + ' (' + item.Department_Ar__c + ')');
                if (!serviceMap.has(item.Service_En__c + ' (' + item.Service_Ar__c + ')')) {
                    serviceMap.set(item.Service_En__c + ' (' + item.Service_Ar__c + ')', []);
                }
                // Push the item into the service's array
                serviceMap.get(item.Service_En__c + ' (' + item.Service_Ar__c + ')').push(item);
            });
            // Convert resultMap to an array of objects
            this.departmentMap = Array.from(resultMap, ([key, value]) => ({
                key,
                value: Array.from(value, ([key, value]) => ({ key, value }))
            }));

            //SK
            if (this.departmentMap && Array.isArray(this.departmentMap)) {
                this.departmentMap.forEach(item => {
                    this.activeSections.push(item.key);
                    if (Array.isArray(item.value)) {
                        item.value.forEach(innerItem => {
                            this.serviceEntryactiveSections.push(innerItem.key);
                        });
                    }
                });
            }
            console.log('serviceEntryactiveSections: ', JSON.stringify(this.serviceEntryactiveSections));
            //

        } else if (error) {
            console.log('error ', error);
            this.error = error;
        }
    }

    handleSectionToggle(event) {
        console.log(event.detail.openSections);
        this.openSectionList = event.detail.openSections.join(', ');
        console.log('openSectionList', this.openSectionList);
    }

    handleOpenAll(event) {
        this.activeSections = this.departmentMap.map(resp => resp.key);
        console.log('Open activeSections', this.activeSections);
    }

    handleCollapseAll(event) {
        this.activeSections = [];
        console.log('Close activeSections', this.activeSections);
    }

    handleSearch(event) {
        this.searchQuery = event.target.value.trim();
    }

    handleSearchButtonClick() {
        // Filter data based on search query
        const filteredData = this.filterData(this.searchQuery);
        console.log(filteredData);
        // Update departmentMap with filtered data
        this.updateDepartmentMap(filteredData);
    }

    filterData(searchQuery) {
        console.log('searchQuery', searchQuery);
        // Your data array
        const data = this.faqData;

        //SK
        console.log(data);
        data.filter(item => {
            if (item.Activities_En__c !== null && item.Activities_En__c !== undefined && item.Activities_Ar__c !== null && item.Activities_Ar__c !== undefined) {
                const combinedActivities = (item.Activities_En__c || '') + ' ' + (item.Activities_Ar__c || '');
                console.log('FQ:  ' + item.Service_En__c + ': ' + combinedActivities.toLowerCase().includes(searchQuery.toLowerCase()))
            }
        });
        // Filter data based on search query
        return data.filter(item => {
            if (item.Service_Ar__c !== null && item.Service_Ar__c !== undefined && item.Service_En__c !== null && item.Service_En__c !== undefined  && item.Activities_En__c !== null && item.Activities_En__c !== undefined && item.Activities_Ar__c !== null && item.Activities_Ar__c !== undefined) {
                const combinedActivities = (item.Service_Ar__c || '') + ' ' + (item.Service_En__c || '') + ' ' + (item.Activities_En__c || '') + ' ' + (item.Activities_Ar__c || '');
                return combinedActivities.toLowerCase().includes(searchQuery.toLowerCase()) // || item.Activities_Ar__c.toLowerCase().includes(searchQuery.toLowerCase())
            }
        });
        //     

    }

    updateDepartmentMap(filteredData) {
        // Prepare departmentMap
        const resultMap = new Map();
        // Iterate over the filtered data
        filteredData.forEach(item => {
            // If the department doesn't exist in resultMap, initialize it with an empty map
            if (!resultMap.has(item.Department_En__c + ' (' + item.Department_Ar__c + ')')) {
                resultMap.set(item.Department_En__c + ' (' + item.Department_Ar__c + ')', new Map());
            }
            // If the service doesn't exist in the service's map, initialize it with an empty array
            const serviceMap = resultMap.get(item.Department_En__c + ' (' + item.Department_Ar__c + ')');
            if (!serviceMap.has(item.Service_En__c + ' (' + item.Service_Ar__c + ')')) {
                serviceMap.set(item.Service_En__c + ' (' + item.Service_Ar__c + ')', []);
            }
            // Push the item into the service's array
            serviceMap.get(item.Service_En__c + ' (' + item.Service_Ar__c + ')').push(item);
        });
        // Convert resultMap to an array of objects
        this.departmentMap = Array.from(resultMap, ([key, value]) => ({
            key,
            value: Array.from(value, ([key, value]) => ({ key, value }))
        }));
    }

}