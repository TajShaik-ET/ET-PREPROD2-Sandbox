import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';
import {
    ShowToastEvent
} from "lightning/platformShowToastEvent";
import ExternalStyle from '@salesforce/resourceUrl/ExternalStyle';
import uploadFile from '@salesforce/apex/ET_VRTS.uploadFile';
import deleteFile from '@salesforce/apex/ET_VRTS.deleteFile';
import getRelatedFilesByRecordId from '@salesforce/apex/ET_VRTS.getRelatedFilesByRecordId';

export default class Et_VRTS_FileUpload extends LightningElement {
    @track filesList = [];
    fileData;
    @api uploadDisabled;
    @api recordId;

    connectedCallback() {
        console.log('recordId: ' + this.recordId);
        if (this.recordId != null && this.recordId != '')
            this.fetchFiles(this.recordId);
    }

    openfileUpload(event) {
        var recid = event.target.dataset.recid;
        const file = event.target.files[0];
        if (!file) {
            this.showToastNotification('warning', 'Please select a file', '', 'pester');
            return;
        }
        var reader = new FileReader();
        reader.onload = () => {
            var base64 = reader.result.split(',')[1];
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': recid //this.recordId 
            }
            //console.log('fileData: '+JSON.stringify(this.fileData));
            this.handleUpload();
        }
        reader.readAsDataURL(file);
    }

    handleUpload() {
        this.showSpinner = true;
        console.log('fileData: ' + JSON.stringify(this.fileData));
        const {
            base64,
            filename,
            recordId
        } = this.fileData;
        uploadFile({
            base64: base64,
            filename: filename,
            recordId: recordId
        }).then(result => {
            console.log('result: ' + result);
            if (result != null && result != '') {
                let title = this.fileData.filename + ' uploaded successfully!';
                this.showToastNotification('Success', title, 'success', 'pester');
                this.fileData = null;
                this.fetchFiles(recordId);
            }
        })
        this.showSpinner = false;
    }

    fetchFiles(recordId) {
        console.log('fetchFiles');
        getRelatedFilesByRecordId({
            recordId: recordId //this.recordId //'a8R8E00000041NOUAY'
        }).then((response) => {
            //console.log('fetchFiles >>> ' + JSON.stringify(response));
            if (response != null && response != '') {
                this.filesList = Object.keys(response).map(item => ({
                    "label": response[item],
                    "value": item,
                    "url": `/sfc/servlet.shepherd/document/download/${item}`
                }))
                //console.log(this.filesList)
            } else {
                this.filesList = [];
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
            this.showToastNotification('Error', error, 'error', 'sticky');
        })
    }

    get uploadDisabled() {
        var filesList = this.filesList;
        if (filesList.length >= 5) {
            return true;
        } else {
            return false;
        }
    }

    deleteHandler(event) {
        console.log(event.target.dataset.id);
        deleteFile({
            ContentDocId: event.target.dataset.id
        }).then((response) => {
            console.log('deleteFile response >>> ' + response);
            console.log('recordId', this.recordId);
            if (this.recordId != null && this.recordId != '')
                this.fetchFiles(this.recordId);
            if (response != null && response != '') {
                if (response == true)
                    this.showToastNotification('Success', 'File deleted Successfully!', 'success', 'pester');
                else
                    this.showToastNotification('Error', 'File not deleted', 'error', 'sticky');
                //this.fetchFiles();
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
            this.showToastNotification('Error', error, 'error', 'sticky');
        })
    }

    downloadHandler(event) {
        console.log(event.target.dataset.id);
        window.open(event.target.dataset.id);
    }

    showToastNotification(title, message, variant, mode) {
        //console.log(message);
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant, //info (default), success, warning, and error
            mode: mode //dismissible (default), pester, sticky
        });
        this.dispatchEvent(evt);
    }

}