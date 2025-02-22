/* eslint-disable no-alert */
import { LightningElement, wire, track } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import Id from "@salesforce/user/Id";
import getServiceRequests from "@salesforce/apex/ETST_MyServicesController.getServiceRequests";
import BUS_IMAGE from "@salesforce/resourceUrl/bus_image";
import BACKGROUND_IMAGE from "@salesforce/resourceUrl/background_image";
import NOSERVICES_MSG from "@salesforce/label/c.ETST_No_Services_Message";
import NOSERVICES_MSG_AR from "@salesforce/label/c.ETST_We_didn_t_find_anything_for_you_AR"
import REQ_STATUS from "@salesforce/label/c.ETST_Confirmed";
import PAYEE from "@salesforce/label/c.ETST_Payee";
import BACK_BUTTON from "@salesforce/label/c.ETST_Back";
import BACK_BUTTON_AR from "@salesforce/label/c.ETST_Back_AR";
import SERVICE_TYPE from "@salesforce/label/c.ETST_Service_Type";
import SERVICE_TYPE_AR from "@salesforce/label/c.ETST_Service_Type_AR";
import TRANSPORT_TYPE from "@salesforce/label/c.ETST_Transport_Type"; 
import TRANSPORT_TYPE_AR from "@salesforce/label/c.ETST_Transport_Type_AR"; 
import START_DATE from "@salesforce/label/c.ETST_Pick_Up_Start_Date";
import START_DATE_AR from "@salesforce/label/c.ETST_Pick_Up_Start_Date_AR";
import END_DATE from "@salesforce/label/c.ETST_Pick_Up_End_Date";
import END_DATE_AR from "@salesforce/label/c.ETST_Pick_Up_End_Date_AR";
import PAYMENT from "@salesforce/label/c.ETST_Payment";
import PAYMENT_AR from "@salesforce/label/c.ETST_Payment_AR";
import REFUND from "@salesforce/label/c.ETST_Refund";
import REFUND_AR from "@salesforce/label/c.ETST_Refund_AR";
import STATUS from "@salesforce/label/c.ETST_Status";
import STATUS_AR from "@salesforce/label/c.ETST_Status_AR";
import SORTBy from "@salesforce/label/c.ETST_Sort_By";
import SORTBy_AR from "@salesforce/label/c.ETST_Sort_By_AR";
export default class EtSchoolMyServices extends NavigationMixin(
  LightningElement
) {
  userId = Id;
  initialRecords;
  busImage = BUS_IMAGE;
  backgroundImage = BACKGROUND_IMAGE;
  errors;
  label = {
    NOSERVICES_MSG,
    NOSERVICES_MSG_AR,
    REQ_STATUS,
    PAYEE,
    BACK_BUTTON_AR,
    BACK_BUTTON,
    SERVICE_TYPE,
    SERVICE_TYPE_AR,
    TRANSPORT_TYPE,
    TRANSPORT_TYPE_AR,
    STATUS,
    STATUS_AR,
    REFUND,
    REFUND_AR,
    PAYMENT,
    PAYMENT_AR,
    START_DATE,
    START_DATE_AR,
    END_DATE,
    END_DATE_AR,
    SORTBy,
    SORTBy_AR
  };
  @track filterValue = "Upcoming";
  @track filteredRecords;
  @track showMessage = false;
  showPayButton = false;
  lang;
  @track lang_en;
  @track Sort_By;
  @track BACK;
  @track SERVICE_TYPE;
  @track TRANSPORT_TYPE;
  @track START_DATE;
  @track END_DATE;
  @track PAYMENT;
  @track REFUND;
  @track STATUS;
  @track NO_SERVICES;
  todayDate = new Date().toISOString().split("T")[0];
  get options() {
    return [
      { label: "All", value: "All" },
      { label: "Active", value: "Active" },
      { label: "Upcoming", value: "Upcoming" },
      { label: "Past", value: "Past" }
    ];
  }
  get options_AR() {
    return [
      { label: "الجميع", value: "All" },
      { label: "نشيط", value: "Active" },
      { label: "القادمة", value: "Upcoming" },
      { label: "ماضي", value: "Past" }
    ];
  }

  @wire(getServiceRequests)
  serviceRecords({ error, data }) {
    if (data) {
      this.initialRecords = data;
      if (this.initialRecords.length === 0) this.showMessage = true;
      let recs = [];
      let date = new Date().toISOString().split("T")[0];
      for (let rec of this.initialRecords) {
        if (
          this.filterValue === "Upcoming" &&
          rec.ETST_Pick_Up_Start_Date__c >= date
        ) {
          if (
            rec.ETST_Status__c === this.label.REQ_STATUS &&
            rec.ETST_Payee__c === this.label.PAYEE &&
            rec.ETST_Fare_Charges__c > 0
          ) {
            this.showPayButton = true;
          }
          recs.push(rec);
        }
      }
      this.filteredRecords = recs;
      this.errors = undefined;
    }
    if (error) {
      this.errors = error;
      this.initialRecords = undefined;
    }
  }
  navigateHome(evt) {
    evt.preventDefault();
    this[NavigationMixin.Navigate]({
      type: "standard__webPage",
      attributes: {
        url: "/etst-home-page?lang="+this.lang
      }
    });
  }

  handlePaynow(evt) {
    evt.preventDefault();
    let reqId = evt.target.name;
    this[NavigationMixin.Navigate]({
      type: "standard__webPage",
      attributes: {
        url:
          "/school-transport-payment-page?recordId=" +
          reqId +
          "&src=etst&lang="+this.lang
      }
    });
  }
  handleChange(event) {
    this.filterValue = event.detail.value;
    if (this.filterValue === "All") {
      this.showPayButton = false;
      this.filteredRecords = this.initialRecords;
      if (this.filteredRecords.length === 0) {
        this.showMessage = true;
      } else {
        this.showMessage = false;
      }
    } else this.filter();
  }
  connectedCallback(){
      var url_string = window.location.href;
      var url = new URL(url_string)
      console.log('url***'+url);
      var lang = url.searchParams.get("lang");
      if(lang =='ar'){
        this.lang='ar';
        this.lang_en = false;
        this.Sort_By = this.label.SORTBy_AR;
        this.BACK = this.label.BACK_BUTTON_AR;
        this.SERVICE_TYPE = this.label.SERVICE_TYPE_AR;
        this.TRANSPORT_TYPE = this.label.TRANSPORT_TYPE_AR;
        this.START_DATE = this.label.START_DATE_AR;
        this.END_DATE = this.label.END_DATE_AR;
        this.PAYMENT = this.label.PAYMENT_AR;
        this.REFUND = this.label.REFUND_AR;
        this.STATUS = this.label.STATUS_AR;
        this.NO_SERVICES = this.label.NOSERVICES_MSG_AR;
      }else{ 
        this.lang='en';
        this.lang_en = true;
        this.Sort_By = this.label.SORTBy;
        this.BACK = this.label.BACK_BUTTON;
        this.SERVICE_TYPE = this.label.SERVICE_TYPE;
        this.TRANSPORT_TYPE = this.label.TRANSPORT_TYPE;
        this.START_DATE = this.label.START_DATE;
        this.END_DATE = this.label.END_DATE;
        this.PAYMENT = this.label.PAYMENT;
        this.REFUND = this.label.REFUND;
        this.STATUS = this.label.STATUS;
        this.NO_SERVICES = this.label.NOSERVICES_MSG;
      }
  } 
  
  filter() {
    if (this.filterValue) {
      this.filteredRecords = this.initialRecords;
      if (this.filteredRecords) {
        let recs = [];
        for (let rec of this.filteredRecords) {
          let date = new Date().toISOString().split("T")[0];
          console.log("Rec is " + JSON.stringify(rec));
          console.log("date ", date);
          if (
            this.filterValue === "Upcoming" &&
            rec.ETST_Pick_Up_Start_Date__c >= date
          ) {
            if (
              rec.ETST_Status__c === this.label.REQ_STATUS &&
              rec.ETST_Payee__c === this.label.PAYEE &&
              rec.ETST_Fare_Charges__c > 0
            ) {
              this.showPayButton = true;
            }
            recs.push(rec);
          } else if (
            this.filterValue === "Past" &&
            rec.ETST_Pick_Up_End_Date__c <= date
          ) {
            this.showPayButton = false;
            recs.push(rec);
          } else if (this.filterValue === "Active" && rec.ETST_Is_Active__c) {
            this.showPayButton = false;
            recs.push(rec);
          }
        }

        console.log("Recs are " + JSON.stringify(recs));
        this.filteredRecords = recs;
        if (this.filteredRecords.length === 0) {
          this.showMessage = true;
        } else {
          this.showMessage = false;
        }
      }
    } else {
      this.filteredRecords = this.initialRecords;
    }
  }
}