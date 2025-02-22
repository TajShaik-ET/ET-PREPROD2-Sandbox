import { LightningElement, api } from "lwc";

export default class Etst_Pagination extends LightningElement {
  totalRecords;
  pageSize = 5;
  visibleRecords;
  totalPages;
  get records() {
    return this.visibleRecords;
  }
  @api
  set records(data) {
    if (data) {
      this.totalRecords = data;
      this.visibleRecords = data.slice(0, this.pageSize);
      this.totalPages = Math.ceil(data.length / this.pageSize);
      this.updateRecords();
    }
  }
  previousHandler() {}

  nextHandler() {}

  updateRecords() {
    this.dispatchEvent(
      new CustomEvent("update", {
        detail: {
          records: this.visibleRecords
        }
      })
    );
  }
}