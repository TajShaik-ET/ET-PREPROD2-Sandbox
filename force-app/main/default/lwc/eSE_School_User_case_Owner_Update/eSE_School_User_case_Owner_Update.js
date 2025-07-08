import { LightningElement, track } from 'lwc';
import getCaseData from '@salesforce/apex/ESE_SchoolUser_Case_Owner_Update.getCaseData';
import getAccountsByNameOrCode from '@salesforce/apex/ESE_SchoolUser_Case_Owner_Update.getAccountsByNameOrCode';
import getUserList from '@salesforce/apex/ESE_SchoolUser_Case_Owner_Update.getUserList';
import updateCaseOwnersBatch from '@salesforce/apex/ESE_SchoolUser_Case_Owner_Update.updateCaseOwnersBatch';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class eSE_School_User_case_Owner_Update extends LightningElement {
    @track accountName = '';
    @track cases = [];
    @track users = [];
    @track selectedUserId = '';
    @track showModal = false;
    @track searchKey = ''; 
    @track startDate = '';
    @track endDate = '';
    @track status = ''; 
    @track accounts = [];
    @track paginatedCases = [];
    @track currentPage = 1;
    @track pageSize = 20; 
    @track totalPages = 0;
    @track isPreviousDisabled = true;
    @track isNextDisabled = true;

    statusOptions = [
        { label: 'None', value: '' },
        { label: 'New', value: 'New' },
        { label: 'Open', value: 'Open' },
        { label: 'In Progress', value: 'In Progress' },
        { label: 'Closed', value: 'Closed' },
        { label: 'On Hold', value: 'On Hold' },
        { label: 'Rejected', value: 'Rejected' },
        { label: 'Escalated', value: 'Escalated' }
    ];

    @track columns = [
        { label: 'Case Number', fieldName: 'CaseLink', type: 'url', typeAttributes: {label: { fieldName: 'CaseNumber' }, target: '_blank'} },
        { label: 'Account Name', fieldName: 'AccountLink', type: 'url', typeAttributes: {label: { fieldName: 'AccountName' }, target: '_blank'} },
        { label: 'Status', fieldName: 'Status' },
        { label: 'Owner', fieldName: 'OwnerName', type: 'text' },
        { label: 'Old Owner', fieldName: 'OldOwner', type: 'text' },
        { label: 'New Owner', fieldName: 'NewOwner', type: 'text' },
        { label: 'Case Created Date', fieldName: 'CreatedDate', type: 'date' }
    ];

    connectedCallback() {
        this.fetchUsers();
    }

    fetchUsers() {
        if (!this.searchKey || this.searchKey === this.selectedUserId) {
            this.users = []; 
            return;
        }

        getUserList({ searchKey: this.searchKey })
            .then(result => {
                this.users = result.map(user => ({
                    label: user.name,
                    value: user.id
                }));
            })
            .catch(error => {
                console.error('Error fetching users:', error);
                this.showToast('Error', 'Error fetching users', 'error');
            });
    }

    handleAccountNameChange(event) {
        this.accountName = event.target.value;

        if (this.accountName.length >= 3) {
            getAccountsByNameOrCode({ accountNameOrCode: this.accountName })
                .then(result => {
                    this.accounts = result;
                })
                .catch(error => {
                    console.error('Error fetching accounts:', error);
                    this.showToast('Error', 'Error fetching accounts', 'error');
                });
        } else {
            this.accounts = []; 
        }
    }

    handleAccountSelect(event) {
        const selectedAccount = event.target.dataset.name;
        this.accountName = selectedAccount;
        this.accounts = [];
        //this.handleSearch(); 
    }

    handleStartDateChange(event) {
        this.startDate = event.target.value;
    }

    handleEndDateChange(event) {
        this.endDate = event.target.value;
    }

    handleStatusChange(event) {
        this.status = event.target.value;
    }

    async handleSearch() {
    if (!this.accountName) {
        this.cases = []; 
        this.updatePagination();
        this.caseCount = [];
        this.showToast('Error', 'Please select the account Name to filter cases.', 'error');
        return;
    }

    try {        
        // Fetch case data, user list, and case history from Apex
        const result = await getCaseData({
            accountName: this.accountName,
            startDate: this.startDate || null,
            endDate: this.endDate || null,
            status: this.status,
        });

        console.log('--- Raw Result from Apex: ---', result);

        // Extract cases, users, and case history
        this.cases = result.cases.map(caseRecord => ({
            ...caseRecord,
            CaseNumber: caseRecord.caseNumber,
            Status: caseRecord.status,
            CreatedDate: caseRecord.createdDate,
            OwnerName: caseRecord.ownerName || 'N/A',
            AccountName: caseRecord.accountName || 'N/A',
            CaseLink: `/lightning/r/Case/${caseRecord.id}/view`,
            AccountLink: `/lightning/r/Account/${caseRecord.accountId}/view`, // Ensure correct Account ID is used
        }));

        console.log('Result Cases:', result.cases);
        console.log('Result Users:', result.users);
        console.log('Result Histories:', result.caseHistories);
        // Build a map for the latest owner change history per case
        const latestHistoryMap = result.caseHistories.reduce((acc, history) => {
            if (!acc[history.caseId] || new Date(acc[history.caseId].createdDate) < new Date(history.createdDate)) {
                acc[history.caseId] = history;
            }
            return acc;
        }, {});
        console.log('--- Latest Case History Map: ---', latestHistoryMap);
        // Create a map of user IDs to user names for easy lookup
        const userMap = result.users.reduce((acc, user) => {
            acc[user.id] = user.name;
            return acc;
        }, {});
        console.log('--- User Map: ---', userMap);
        // Attach Old Owner and New Owner information from history data
        this.cases = this.cases.map(caseRecord => {
            const history = latestHistoryMap[caseRecord.id] || {}; // Get latest history record for this case
            const oldValue = history.oldValue;
            const newValue = history.newValue;

            const oldOwnerName = userMap[oldValue] || oldValue;
            const newOwnerName = userMap[newValue] || newValue;
            const caseowner = caseRecord.OwnerName;

            console.log(`Case ID: ${caseRecord.id}`);
            console.log(`Old Value: ${history.oldValue}, Old Owner Name: ${oldOwnerName || 'No Data'}`);
            console.log(`New Value: ${history.newValue}, New Owner Name: ${newOwnerName || 'No Data'}`);

            return {
                ...caseRecord,
                OldOwner: oldOwnerName,
                NewOwner: newOwnerName,
                OwnerName: caseowner 
            };
        });
        this.caseCount = this.cases.length;
        this.updatePagination();
    } catch (error) {
        console.error('Error fetching data:', error);
        this.showToast('Error', 'Error fetching case data', 'error');
    }
}
    updatePagination() {
        this.totalPages = Math.ceil(this.cases.length / this.pageSize);
        const startIdx = (this.currentPage - 1) * this.pageSize;
        const endIdx = this.currentPage * this.pageSize;
        this.paginatedCases = this.cases.slice(startIdx, endIdx);
        this.isPreviousDisabled = this.currentPage === 1;
        this.isNextDisabled = this.currentPage === this.totalPages;
    }

    handleNextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage += 1;
            this.updatePagination();
        }
    }

    handlePrevPage() {
        if (this.currentPage > 1) {
            this.currentPage -= 1;
            this.updatePagination();
        }
    }

    handleUpdate() {
        if (this.cases.length === 0) {
            this.showToast('Error', 'No cases available to update. Please search for an account first.', 'error');
            return;
        }
        this.showModal = true; 
    }

    handleSearchKeyChange(event) {
        this.searchKey = event.target.value;
        this.fetchUsers(); 
    }

    handleUserSelect(event) {
        const userId = event.currentTarget.dataset.id; 
        const userName = event.currentTarget.dataset.name; 
    
        if (userId) {
            this.selectedUserId = userId; 
            this.searchKey = userName; 
            this.users = []; 
            console.log('Selected User ID:', this.selectedUserId);
            console.log('Search Key after selection:', this.searchKey);
        } else {
            console.error('Error: Selected user ID is undefined');
        }
    }
    
    handleSave() {
    if (!this.selectedUserId) {
        this.showToast('Error', 'Please select a user to assign as the new owner.', 'error');
        return;
    }
    const caseIds = this.cases.map(c => c.id); // Corrected case ID extraction
    console.log('Case IDs to update:', caseIds);
    console.log('New owner ID:', this.selectedUserId);
    const oldOwnerMap = this.cases.reduce((acc, caseRecord) => {
        acc[caseRecord.id] = caseRecord.OwnerName; // Store current owner name as old owner
        return acc;
    }, {});
    updateCaseOwnersBatch({ caseIds: caseIds, newOwnerId: this.selectedUserId })
        .then(() => {
            console.log('Case owners updated successfully.');
            // Update the owner details in the local cases list
            this.cases = this.cases.map(caseRecord => {
                if (caseIds.includes(caseRecord.id)) { 
                    return {
                        ...caseRecord,
                        OwnerName: this.searchKey,
                        NewOwner: this.searchKey,
                        OldOwner: oldOwnerMap[caseRecord.id] || 'N/A',
                    };
                }
                return caseRecord;
            });
            this.showModal = false;
            this.selectedUserId = ''; // Reset selected user
            console.log('Calling handleSearch to refresh the case list.');
            this.searchKey = '';
            this.updatePagination();
            console.log('After handleSearch call:');
            console.log('Updated cases list:', this.cases);
            this.showToast('Success', 'Case owners updated successfully!', 'success');
        })
        .catch(error => {
            console.error('Error updating case owners:', error);
            this.showToast('Error', 'Error updating case owners', 'error');
        });
}
        handleExport() {
        if (!this.cases.length) {
            this.showToast('Error', 'No cases available to export.', 'error');
            return;
        }

        const headers = ['Case Number', 'Account Name', 'Status', 'Owner', 'Old Owner', 'New Owner', 'Created Date'];
        const rows = this.cases.map(caseRecord => [
            caseRecord.CaseNumber,
            caseRecord.AccountName,
            caseRecord.Status,
            caseRecord.OwnerName,
            caseRecord.OldOwner,
            caseRecord.NewOwner,
            caseRecord.CreatedDate
        ]);

        let csvContent = 'data:text/csv;charset=utf-8,';
        csvContent += headers.join(',') + '\n';
        rows.forEach(row => {
            csvContent += row.map(value => `"${value}"`).join(',') + '\n';
        });

        const encodedUri = encodeURI(csvContent);
        const link = document.createElement('a');
        link.setAttribute('href', encodedUri);
        link.setAttribute('download', 'Cases_Export.csv');
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);

        this.showToast('Success', 'Cases exported successfully.', 'success');
    }

  handleOpenReport() {

    let reportUrl = `/lightning/r/Report/00Odv000000QjuLEAS/view?`;

     reportUrl += `fv0=${encodeURIComponent(this.accountName)}`; 

    if (this.status) {
        reportUrl += `&fv1=${encodeURIComponent(this.status)}`; 
    }

    if (this.startDate) {
        reportUrl += `&fv2=${encodeURIComponent(this.startDate)}`; 
    }

    if (this.endDate) {
       reportUrl += `&fv3=${encodeURIComponent(this.endDate)}`; 
    }
    window.open(reportUrl, '_blank');
}


    handleCloseModal() {
        this.showModal = false;
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(event);
    }
}