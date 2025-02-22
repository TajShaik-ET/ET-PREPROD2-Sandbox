import { LightningElement, track, wire, api } from 'lwc';
import searchAccounts from '@salesforce/apex/ETAmana_Employees_InvolvedController.searchAccounts';
import createEmployeeForAccount from '@salesforce/apex/ETAmana_Employees_InvolvedController.createEmployeeForAccount';
import checkEistingEmployeeRecord from '@salesforce/apex/ETAmana_Employees_InvolvedController.checkEistingEmployeeRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const DELAY = 300;
export default class Etamana_Employees_Involved extends LightningElement {
    @api recordId; // Receive the Amana_solution__c ID
    @track searchResults = [];
    @track selectedAccounts = [];
    searchTerm = '';
    isDropdownOpen = false;

    // Handle input changes and fetch search results
    handleSearch(event) {
        this.searchTerm = event.target.value;

        if (this.searchTerm.length >= 2) {
            searchAccounts({ searchTerm: this.searchTerm })
                .then(result => {
                    this.searchResults = result;
                    this.isDropdownOpen = true;
                })
                .catch(error => {
                    console.error('Error fetching accounts:', error);
                    this.searchResults = [];
                });
        } else {
            this.searchResults = [];
            this.isDropdownOpen = false;
        }
    }

    // Handle selecting an account
    // handleSelect(event) {
    //     const accountId = event.currentTarget.dataset.id;
    //     const accountName = event.currentTarget.dataset.name;

    //     // Add to selected accounts if not already selected
    //     // if (!this.selectedAccounts.find(account => account.id === accountId)) {
    //     //     this.selectedAccounts = [
    //     //         ...this.selectedAccounts,
    //     //         { id: accountId, name: accountName }
    //     //     ];
    //     // }

    //     checkEistingEmployeeRecord({ accountId: accountId, recordId: this.recordId })
    //     .then((result) => {
    //         if (result === true) {
    //             // Dispatch an error event if the employee already exists
    //             this.dispatchEvent(
    //                 new CustomEvent('error', {
    //                     detail: 'Employee with the selected account already exists'
    //                 })
    //             );
    //         } else {
    //             // Add to selected accounts if not already selected and no conflict
    //             if (!this.selectedAccounts.find(account => account.id === accountId)) {
    //                 this.selectedAccounts = [
    //                     ...this.selectedAccounts,
    //                     { id: accountId, name: accountName }
    //                 ];
    //             }
    //         }
    //     // Clear search results and input
    //     this.searchResults = [];
    //     this.searchTerm = '';
    //     this.isDropdownOpen = false;
    // }

    handleSelect(event) {
        const accountId = event.currentTarget.dataset.id;
        const accountName = event.currentTarget.dataset.name;

        // Check if the employee with the selected account already exists
        checkEistingEmployeeRecord({ accountId: accountId, recordId: this.recordId })
            .then((result) => {
                if (result === true) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Employee with the selected account already exists',
                            variant: 'error'
                        })
                    );
                } else {
                    // Add to selected accounts if not already selected and no conflict
                    if (!this.selectedAccounts.find(account => account.id === accountId)) {
                        this.selectedAccounts = [
                            ...this.selectedAccounts,
                            { id: accountId, name: accountName }
                        ];
                    }

                    // Clear search results and input
                    this.searchResults = [];
                    this.searchTerm = '';
                    this.isDropdownOpen = false;
                }
            })
            .catch((error) => {
                console.error('Error checking existing employee record:', error);
                // Optionally dispatch an error event for API errors
                this.dispatchEvent(
                    new CustomEvent('error', {
                        detail: 'An error occurred while checking for existing employee records.'
                    })
                );
            });
    }

    // Handle removing a selected account
    handleRemove(event) {
        const accountId = event.currentTarget.dataset.id;
        this.selectedAccounts = this.selectedAccounts.filter(account => account.id !== accountId);
    }

    // Handle saving selected accounts as Employee records
    handleSave() {
        console.log('Selected Accounts:', this.selectedAccounts);
        console.log('Amana_solution__c ID:', this.recordId);

        if (this.selectedAccounts.length > 0 && this.recordId) {
            const account = this.selectedAccounts.map(account => ({ Id: account.id, Name: account.name }));
            //var account = [this.selectedAccounts];
            console.log('recordId:', this.recordId);
            createEmployeeForAccount({ account: account, recordId: this.recordId })
                .then(() => {
                    this.dispatchEvent(
                        /*new CustomEvent('success', {
                            detail: 'Employee records created successfully!'
                        })*/
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Employee records created successfully!',
                            variant: 'success'
                        })
                    );
                    // Optionally, clear selections after saving
                    this.selectedAccounts = [];
                })
                .catch(error => {
                    console.error('Error creating Employee records:', error);
                    this.dispatchEvent(
                        new CustomEvent('error', {
                            detail: 'Error creating Employee records.'
                        })
                        /*new ShowToastEvent({
                        title: 'Warning',
                        message: 'No accounts selected or Amana_solution__c ID is missing.',
                        variant: 'warning'
                        })*/
                    );
                });
        } else {
            console.error('No accounts selected or Amana_solution__c ID missing.');
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Warning',
                    message: 'No accounts selected or Amana_solution__c ID is missing.',
                    variant: 'warning'
                })
            );
        }
    }

    // Close the dropdown when clicking outside
    handleBlur() {
        setTimeout(() => {
            this.isDropdownOpen = false;
        }, 200); // Delay to allow selecting a record before closing
    }

}