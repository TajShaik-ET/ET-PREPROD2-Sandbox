/* eslint-disable getter-return */
/* eslint-disable consistent-return */
/* eslint-disable no-return-assign */
/* eslint-disable no-sequences */
/* eslint-disable @lwc/lwc/no-api-reassignments */
/* eslint-disable no-undef */
/* eslint-disable no-alert */
import { LightningElement, wire, track, api } from "lwc";
import getRefundRequests from "@salesforce/apex/ETST_RefundRequestController.getRefundRequests";
import { exportDataCSVFile } from "c/etSchoolUtils";
const columns = [
  {
    label: "Refund Name",
    fieldName: "Name",
    type: "url",
    typeAttributes: {
      label: { fieldName: "RefundName" },
      target: "_blank"
    },
    sortable: true
  },
  {
    label: "Service Request",
    fieldName: "reqLink",
    type: "url",
    typeAttributes: {
      label: { fieldName: "ServiceReqName" },
      target: "_blank"
    }
  },
  {
    label: "Refund Amount",
    fieldName: "RefundAmount"
  },
  {
    label: "Status",
    fieldName: "RefundStatus",
    type: "text"
  },
  {
    label: "Requested Date",
    fieldName: "CreatedDate",
    type: "date",
    typeAttributes: {
      month: "2-digit",
      day: "2-digit",
      year: "numeric",
      hour: "2-digit",
      minute: "2-digit"
    }
  }
];
export default class ETST_RefundRequests extends LightningElement {
  @track refundRecords = [];
  @track visibleRefundRecords = [];
  visibleRefundRequests;
  errors;
  @api searchKey = "";
  @api sortedDirection = "desc";
  @api sortedBy = "Name";

  @track page = 1;
  @track startingRecord = 1;
  @track endingRecord = 0;
  @track pageSize = 10;
  @track totalRecordCount = 0;
  @track totalPage = 0;
  @track columns = columns;
  @wire(getRefundRequests, {
    searchKey: "$searchKey",
    sortBy: "$sortedBy",
    sortDirection: "$sortedDirection"
  })
  retriveRefundRecords({ error, data }) {
    if (data) {
      let currentData = [];
      data.forEach((row) => {
        let rowData = {};
        rowData.Name = `/${row.Id}`;
        rowData.RefundName = row.Name;
        if (row.ET_Service_Request__c) {
          rowData.reqLink = `/${row.ET_Service_Request__c}`;
          rowData.ServiceReqName = row.ET_Service_Request__r.Name;
        }
        rowData.RefundAmount = row.ET_Refund_Amount__c;
        rowData.RefundStatus = row.ET_Refund_Status__c;
        rowData.CreatedDate = row.CreatedDate;
        currentData.push(rowData);
      });
      this.totalRecordCount = data.length;
      this.totalPage = Math.ceil(this.totalRecordCount / this.pageSize);
      this.endingRecord = this.pageSize;
      this.refundRecords = currentData;
      this.visibleRefundRecords = this.refundRecords.slice(0, this.pageSize);
      console.log("refund", this.refundRecords);
    }
    if (error) {
      this.errors = error;
      this.refundRecords = undefined;
    }
  }

  handleKeyChange(event) {
    this.searchKey = event.target.value;
    /* if (this.searchKey === null || this.searchKey === "") {
      console.log("key", this.searchKey);
      this.paze = 1;
      this.displayRecordPerPage(this.page);
    }*/
  }

  updateColumnSorting(event) {
    this.sortedBy = event.detail.fieldName;
    this.sortedDirection = event.detail.sortDirection;
    console.log("sortedBy ", this.sortedBy);
    console.log("sortedDirection ", this.sortedDirection);
    let fieldValue = (row) => row[this.sortedBy] || "";
    let reverse = this.sortedDirection === "desc" ? 1 : -1;
    this.visibleRefundRecords = [
      ...this.visibleRefundRecords.sort(
        (a, b) => (
          (a = fieldValue(a)),
          (b = fieldValue(b)),
          reverse * ((a > b) - (b > a))
        )
      )
    ];
    // return refreshApex(this.result);
  }
  refundHeaders = {
    RefundName: "Refund Request Name",
    ServiceReqName: "Service Request",
    RefundAmount: "Refund Amount",
    RefundStatus: "Refund Status",
    CreatedDate: "Requested Date"
  };
  downloadRefundRecords() {
    console.log("download clicked");
    exportDataCSVFile(
      this.refundHeaders,
      this.refundRecords,
      "Refund Requests"
    );
  }

  previousHandler() {
    if (this.page > 1) {
      this.page = this.page - 1; //decrease page by 1
      this.displayRecordPerPage(this.page);
    }
  }

  get disablePreviousButtons() {
    if (
      this.visibleRefundRecords === undefined ||
      this.visibleRefundRecords.length === 0 ||
      this.page === 1
    )
      return true;
  }

  get disableNextButtons() {
    if (
      this.visibleRefundRecords === undefined ||
      this.visibleRefundRecords.length === 0 ||
      this.page === this.totalPage
    )
      return true;
  }
  //clicking on next button this method will be called
  nextHandler() {
    if (this.page < this.totalPage && this.page !== this.totalPage) {
      this.page = this.page + 1; //increase page by 1
      this.displayRecordPerPage(this.page);
    }
  }

  //this method displays records page by page
  displayRecordPerPage(page) {
    this.startingRecord = (page - 1) * this.pageSize;
    this.endingRecord = this.pageSize * page;

    this.endingRecord =
      this.endingRecord > this.totalRecordCount
        ? this.totalRecordCount
        : this.endingRecord;

    this.visibleRefundRecords = this.refundRecords.slice(
      this.startingRecord,
      this.endingRecord
    );

    this.startingRecord = this.startingRecord + 1;
  }
}