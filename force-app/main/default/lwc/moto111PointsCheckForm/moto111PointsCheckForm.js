import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import save111PointsCheck from '@salesforce/apex/MOTO_VehInspectionCtrl.save111PointsCheck';
import imageResource from '@salesforce/resourceUrl/carIMG_LWC';

import LWCImages from "@salesforce/resourceUrl/LWCImages";
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

let canvasElement, ctx, flag = false, dot_flag = false, prevX = 0,
    currX = 0, prevY = 0,
    currY = 0, x = "red", y = 2, w, h, img;
let storageArray = [];
let cStep = 0;
let attachment;
let dataURL, convertedDataURI;

export default class Moto111PointsCheckForm extends LightningElement {
    @api oppRecord;
    @track PointsCheckRec;
    @track Registration_documents__c;
    @track On_board_equipment__c;
    @track Safety_equipment__c;
    @track Warranty_booklet__c;
    @track Maintenance_booklet__c;

    loaded;
    Tloaded = true;
    Floaded = false;
    fileData;
    @track allFilesData = [];

    connectedCallback() {
        let PointsCheckObj = { sobjectType: 'X111_Point_Check__c' };
        PointsCheckObj.Opportunity__c = this.oppRecord.Id;
        PointsCheckObj.Registration_documents__c=true;
        PointsCheckObj.On_board_equipment__c=true;
        PointsCheckObj.Safety_equipment__c=true;
        PointsCheckObj.Warranty_booklet__c=true;
        PointsCheckObj.Maintenance_booklet__c=true;
        PointsCheckObj.OBD_Fault_Memory_check__c="OK";
        PointsCheckObj.Tire_Pressure_Monitoring_TPM__c="OK";
        PointsCheckObj.Front_RH_LH__c="OK";
        PointsCheckObj.Rear_RH_LH__c="OK";
        PointsCheckObj.Door_locking_system__c="OK";
        PointsCheckObj.Remote_controls__c="OK";
        PointsCheckObj.Alarm_system_and_immobillzer__c="OK";
        PointsCheckObj.Ignition_ignition_switch__c="OK";
        PointsCheckObj.Steering_wheel_lock__c="OK";
        PointsCheckObj.Interior_lighting__c="OK";
        PointsCheckObj.Horn__c="OK";
        PointsCheckObj.Wipers_front_rear__c="OK";
        PointsCheckObj.Windscreen_washer_and_headlight_system__c="OK";
        PointsCheckObj.Exterior_mirror_rear_view_mirror__c="OK";
        PointsCheckObj.Instrument_panel__c="OK";
        PointsCheckObj.Multi_function_steering_wheel__c="OK";
        PointsCheckObj.Steering_column_adjustment__c="OK";
        PointsCheckObj.On_board_clock__c="OK";
        PointsCheckObj.Warning_lights_and_sounds__c="OK";
        PointsCheckObj.Airbag_system__c="OK";
        PointsCheckObj.Sun_visors__c="OK";
        PointsCheckObj.Windscreen_rear_window_and_mirror__c="OK";
        PointsCheckObj.Audio_Radio_telephone_CD_auto_changer__c="OK";
        PointsCheckObj.Audio_system_radio_CD_DVD__c="OK";
        PointsCheckObj.Seat_heating__c="OK";
        PointsCheckObj.Seat_ventilation__c="OK";
        PointsCheckObj.Power_windows_incl_anti_pinch__c="OK";
        PointsCheckObj.Steering_wheel_heating__c="OK";
        PointsCheckObj.Auxiliary_heating__c="OK";
        PointsCheckObj.Seat_adjustment_seat_position_memory__c="OK";
        PointsCheckObj.Cup_holders__c="OK";
        PointsCheckObj.Glove_compartment_lid__c="OK";
        PointsCheckObj.Cigarette_lighter_sockets__c="OK";
        PointsCheckObj.Ashtrays__c="OK";
        PointsCheckObj.Seat_belts_and_seat_belt_height__c="OK";
        PointsCheckObj.Seat_and_had_restraint_upholstery__c="OK";
        PointsCheckObj.Roof_sliding_sunroof__c="OK";
        PointsCheckObj.Roof_lining__c="OK";
        PointsCheckObj.Cabriolet_wind_deflector__c="OK";
        PointsCheckObj.Floor_mats_and_carpet__c="OK";
        PointsCheckObj.Interior_trim_luggage_compartment__c="OK";
        PointsCheckObj.Unlocking_mechanism_for_all_lids__c="OK";
        PointsCheckObj.Equipment_Exclusive_equipmentt__c="OK";
        PointsCheckObj.Tread_depth__c="OK";
        PointsCheckObj.Frt_LH_RH_RR_RH_RR_LH__c="OK";
        PointsCheckObj.Tyre_Size_F_R__c="OK";
        PointsCheckObj.Tyre_manufacturer__c="OK";
        PointsCheckObj.No_safety_related_damage_on_wheels_tyres__c="OK";
        PointsCheckObj.Tyre_pressure_FRT_RR__c="OK";
        PointsCheckObj.Underbody_cover__c="OK";
        PointsCheckObj.Exhaust_system__c="OK";
        PointsCheckObj.Chassis_wheel_suspension_shock_absorber__c="OK";
        PointsCheckObj.Stabilizer_bearings__c="OK";
        PointsCheckObj.Axle_joints__c="OK";
        PointsCheckObj.Drive_axles__c="OK";
        PointsCheckObj.Transfer_case__c="OK";
        PointsCheckObj.Steering_gear__c="OK";
        PointsCheckObj.Transmission__c="OK";
        PointsCheckObj.Fuel_system__c="OK";
        PointsCheckObj.Radiators_coolers_fans__c="OK";
        PointsCheckObj.Coolant_hoses_and_connections__c="OK";
        PointsCheckObj.Brake_lines_and_hoses__c="OK";
        PointsCheckObj.Brake_Pads__c="OK";
        PointsCheckObj.Brake_discs_within_wear_limits__c="OK";
        PointsCheckObj.Brake_calipers_air_ducts_cover_plates__c="OK";
        PointsCheckObj.Body__c="OK";
        PointsCheckObj.Interior_trim_luggage_compartment__c="OK";
        PointsCheckObj.Convertible_top__c="OK";
        PointsCheckObj.Paintwork__c="OK";
        PointsCheckObj.Doors_and_lids__c="OK";
        PointsCheckObj.Exterior_lights__c="OK";
        PointsCheckObj.Headlight_adjustment__c="OK";
        PointsCheckObj.Rims__c="OK";
        PointsCheckObj.Glazing__c="OK";
        PointsCheckObj.Spoiler__c="OK";
        PointsCheckObj.Water_drains_and_air_guides__c="OK";
        PointsCheckObj.Equipment_Exclusive_equipment__c="OK";
        PointsCheckObj.Trailer_coupling__c="OK";
        PointsCheckObj.Taking_two_photos_as_shown_documentation__c="OK";
        PointsCheckObj.Engine_idling__c="OK";
        PointsCheckObj.Air_conditioning_compressor__c="OK";
        PointsCheckObj.Belts_generator_air_conditioning_fans__c="OK";
        PointsCheckObj.Engine__c="OK";
        PointsCheckObj.Generator_Alternator__c="OK";
        PointsCheckObj.Battery_test_attach_battery_check_sheet__c="OK";
        PointsCheckObj.Engine_oil__c="OK";
        PointsCheckObj.Coolant__c="OK";
        PointsCheckObj.Power_steering_hydraulic_oil__c="OK";
        PointsCheckObj.Brake_clutch_fluid__c="OK";
        PointsCheckObj.Windscreen_and_headlight_washer_fluid__c="OK";
        PointsCheckObj.Transmission_Fluid__c="OK";
        PointsCheckObj.Staring_and_idle_speed_behaviour__c="OK";
        PointsCheckObj.Braking_effect_foot_brake_and_parking__c="OK";
        PointsCheckObj.ABS__c="OK";
        PointsCheckObj.Suspension_system_Strut_Type_Air__c="OK";
        PointsCheckObj.Power_steering__c="OK";
        PointsCheckObj.Steering_wheel_centered__c="OK";
        PointsCheckObj.Directional_stability__c="OK";
        PointsCheckObj.Auto_Braking__c="OK";
        PointsCheckObj.Vehicle_performance__c="OK";
        PointsCheckObj.Gear_Shift_operation__c="OK";
        PointsCheckObj.Auto_Stop_start_stop__c="OK";
        PointsCheckObj.Heating_ventilation_system_air__c="OK";
        PointsCheckObj.ParkAssist_reversing_camera__c="OK";
        PointsCheckObj.navigation_system__c="OK";
        PointsCheckObj.Cruise_control_all_functions__c="OK";
        PointsCheckObj.Instrument_panel_while_vehicle_motion__c="OK";
        PointsCheckObj.Hill_Hold_Control__c="OK";
        PointsCheckObj.Lane_departure_warning_LDW__c="OK";
        PointsCheckObj.Lane_Change_Assist_LCA__c="OK";
        PointsCheckObj.Distance_control_system__c="OK";
        PointsCheckObj.No_unusual_noises_vibrations__c="Ok";

        this.PointsCheckRec = PointsCheckObj;
    }
    handleclose(event) {
        let fieldName = event.target.name;
        this.PointsCheckRec[fieldName] = false;
        this[fieldName] = true;
        console.log(this.PointsCheckRec);
    }
    handlecheck(event) {
        let fieldName = event.target.name;
        this.PointsCheckRec[fieldName] = true;
        this[fieldName] = false;
        console.log(this.PointsCheckRec);
    }













    handleUrgent(event) {
        let fieldName = event.target.name;
        let AllDoorsHingesLocks = this.template.querySelectorAll(`[data-id="${fieldName}"]`);
        AllDoorsHingesLocks.forEach(item => {
            item.selected = false;
        });
        let buttonIconStateful = event.target;
        buttonIconStateful.selected = true;
        this.PointsCheckRec[fieldName] = "Not Applicable";

    }
    handleAdviosry(event) {
        let fieldName = event.target.name;
        let AllDoorsHingesLocks = this.template.querySelectorAll(`[data-id="${fieldName}"]`);
        AllDoorsHingesLocks.forEach(item => {
            item.selected = false;
        });
        let buttonIconStateful = event.target;
        buttonIconStateful.selected = true;
        this.PointsCheckRec[fieldName] = "Defective and Repair";

    }
    handleOk(event) {
        let fieldName = event.target.name;
        let AllDoorsHingesLocks = this.template.querySelectorAll(`[data-id="${fieldName}"]`);
        AllDoorsHingesLocks.forEach(item => {
            item.selected = false;
        });
        let buttonIconStateful = event.target;
        buttonIconStateful.selected = true;
        this.PointsCheckRec[fieldName] = "OK";


    }
    handleSubmit() {
        const fieldElement = this.template.querySelector('[data-id="Comments"]');
        if (fieldElement) {
            this.fieldValue = fieldElement.value;
        }
        this.PointsCheckRec.Comments__c = this.fieldValue;
        if (cStep == 0) {
			const errorMsg = 'Please Mark The Diagram Before Saving';
			const evt = new ShowToastEvent({
				title: 'Error',
				message: errorMsg,
				variant: 'error'
			});
			this.dispatchEvent(evt);
			const canvasQuery = this.template.querySelector('[data-id="canvasDia"]');
			canvasQuery.scrollIntoView({ behavior: 'smooth' });
			return;
		}



        this.loaded = this.Tloaded;
        ctx.globalCompositeOperation = "destination-over";
        ctx.fillStyle = "#FFF"; //white
        ctx.fillRect(0, 0, canvasElement.width, canvasElement.height);
        dataURL = canvasElement.toDataURL("image/png");
        convertedDataURI = dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
        this.fileData = {
            'filename': 'MarkedDiagram.png',
            'filetype': 'image/png',
            'base64': convertedDataURI,
        }
        this.allFilesData.push(this.fileData)
        const Points111CheckRecord = this.PointsCheckRec;
        save111PointsCheck({
            Points111CheckRecord,
            fileData: JSON.stringify(this.allFilesData)
        })
            .then(result => {
                console.log('res--' + result)
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: '111 Points CheckForm is Created Successfully ',
                        variant: 'success',
                    }),
                );
                this.loaded = this.Floaded;
                this.backbButtonHanlder();
            })
            .catch(error => {
                alert(e.message)
            });
    }
    backbButtonHanlder(event) {
        const backButtonEvent = new CustomEvent("backbuttonclick", {
            detail: null
        });
        this.dispatchEvent(backButtonEvent);
    }


    //cavas
    @api recordId;
    constructor() {
        super();

    }
    renderedCallback() {
        Promise.all([
            loadStyle(this, LWCImages + '/LWC-Images/css/ETExternalStyle.css')

        ])
            .then(() => {
                console.log("All scripts and CSS are loaded. perform any initialization function.")
            })
            .catch(error => {
                console.log("failed to load the scripts");
            });

        let canvasQuery = this.template.querySelector('[data-id="canvasDia"]');
        canvasQuery.addEventListener('mousemove', (e) => { this.searchCoordinatesForEvent('move', e) });
        canvasQuery.addEventListener('mousedown', (e) => { this.searchCoordinatesForEvent('down', e) });
        canvasQuery.addEventListener('mouseup', (e) => { this.searchCoordinatesForEvent('up', e) });
        canvasQuery.addEventListener('mouseout', (e) => { this.searchCoordinatesForEvent('out', e) });

        canvasQuery.addEventListener('touchstart', (e) => {

            var touch = e.touches[0];
            var mouseEvent = new MouseEvent("mousedown", {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            canvasQuery.dispatchEvent(mouseEvent);
            e.preventDefault();
        });
        canvasQuery.addEventListener('touchend', (e) => {

            this.searchCoordinatesForEvent('up', e)
        });
        canvasQuery.addEventListener('touchmove', (e) => {

            var touch = e.touches[0];
            var mouseEvent = new MouseEvent("mousemove", {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            canvasQuery.dispatchEvent(mouseEvent);
            e.preventDefault();
        });

        canvasElement = canvasQuery;
        ctx = canvasElement.getContext("2d");
        img = new Image();
        img.src = imageResource;
        img.onload = () => {
            ctx.drawImage(img, 0, 0, canvasElement.width, canvasElement.height);
        }


        let undoButton = this.template.querySelector('[data-id="undoBtn"]');
        undoButton.addEventListener("click", (e) => {
            if (cStep > 0) {
                cStep--;
                var canvasPic = new Image();
                canvasPic.src = storageArray[cStep];
                canvasPic.onload = () => {
                    ctx.drawImage(canvasPic, 0, 0);
                }
            }
        });
        let redoButton = this.template.querySelector('[data-id="redoBtn"]');
        redoButton.addEventListener("click", (e) => {

            if (cStep < storageArray.length - 1) {
                cStep++;
                var canvasPic = new Image();
                canvasPic.src = storageArray[cStep];
                canvasPic.onload = () => { ctx.drawImage(canvasPic, 0, 0); }
            }

        });

    }
    cPush() {
        try {
            cStep++;

            if (cStep < storageArray.length) {
                storageArray.length = cStep;
            }
            storageArray.push(canvasElement.toDataURL());

        } catch (e) {
            console.log(e.message)
        }


    }
    searchCoordinatesForEvent(requestedEvent, e) {
        e.preventDefault();
        const rect = canvasElement.getBoundingClientRect();

        if (requestedEvent == 'down') {
            prevX = currX;
            prevY = currY;
            currX = e.clientX - rect.left;
            currY = e.clientY - rect.top;

            flag = true;
            dot_flag = true;
            if (dot_flag) {
                ctx.beginPath();
                ctx.fillStyle = x;
                ctx.fillRect(currX, currY, 2, 2);
                ctx.closePath();
                dot_flag = false;
            }
        }
        if (requestedEvent == 'up' || requestedEvent == "out") {
            flag = false;
            if (requestedEvent == 'up')
                this.cPush();
        }

        if (requestedEvent == 'move') {
            if (flag) {
                prevX = currX;
                prevY = currY;
                currX = e.clientX - rect.left;
                currY = e.clientY - rect.top;
                this.draw();
            }
        }

    }

    draw() {
        ctx.beginPath();
        ctx.moveTo(prevX, prevY);
        ctx.lineTo(currX, currY);
        ctx.strokeStyle = x;
        ctx.lineWidth = y;
        ctx.stroke();
        ctx.closePath();
    }
    clearDrawing() {
        ctx.clearRect(0, 0, canvasElement.width, canvasElement.height);
        ctx.drawImage(img, 0, 0, canvasElement.width, canvasElement.height);
        cStep = 0;
    }

    //till cavas
}